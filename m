Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73712D1B12
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgLGUsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:19 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42576 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727218AbgLGUsS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:18 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 81D7E305D46B;
        Mon,  7 Dec 2020 22:46:19 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 50EF43072784;
        Mon,  7 Dec 2020 22:46:19 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>
Subject: [PATCH v11 44/81] KVM: introspection: add a jobs list to every introspected vCPU
Date:   Mon,  7 Dec 2020 22:45:45 +0200
Message-Id: <20201207204622.15258-45-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every vCPU has a lock-protected list in which the receiving thread
places the jobs that has to be done by the vCPU thread
once it is kicked out of guest (KVM_REQ_INTROSPECTION).

Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/kvmi_host.h         | 10 +++++
 virt/kvm/introspection/kvmi.c     | 72 ++++++++++++++++++++++++++++++-
 virt/kvm/introspection/kvmi_int.h |  1 +
 3 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 9b0008c66321..b3874419511d 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -6,8 +6,18 @@
 
 #include <asm/kvmi_host.h>
 
+struct kvmi_job {
+	struct list_head link;
+	void *ctx;
+	void (*fct)(struct kvm_vcpu *vcpu, void *ctx);
+	void (*free_fct)(void *ctx);
+};
+
 struct kvm_vcpu_introspection {
 	struct kvm_vcpu_arch_introspection arch;
+
+	struct list_head job_list;
+	spinlock_t job_lock;
 };
 
 struct kvm_introspection {
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 5bccc3fb9ff2..6f73776eb04e 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -23,6 +23,7 @@ static DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
 static DECLARE_BITMAP(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
+static struct kmem_cache *job_cache;
 
 void *kvmi_msg_alloc(void)
 {
@@ -39,14 +40,19 @@ static void kvmi_cache_destroy(void)
 {
 	kmem_cache_destroy(msg_cache);
 	msg_cache = NULL;
+	kmem_cache_destroy(job_cache);
+	job_cache = NULL;
 }
 
 static int kvmi_cache_create(void)
 {
 	msg_cache = kmem_cache_create("kvmi_msg", KVMI_MSG_SIZE_ALLOC,
 				      4096, SLAB_ACCOUNT, NULL);
+	job_cache = kmem_cache_create("kvmi_job",
+				      sizeof(struct kvmi_job),
+				      0, SLAB_ACCOUNT, NULL);
 
-	if (!msg_cache) {
+	if (!msg_cache || !job_cache) {
 		kvmi_cache_destroy();
 
 		return -1;
@@ -118,6 +124,48 @@ void kvmi_uninit(void)
 	kvmi_cache_destroy();
 }
 
+static int __kvmi_add_job(struct kvm_vcpu *vcpu,
+			  void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
+			  void *ctx, void (*free_fct)(void *ctx))
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	struct kvmi_job *job;
+
+	job = kmem_cache_zalloc(job_cache, GFP_KERNEL);
+	if (unlikely(!job))
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&job->link);
+	job->fct = fct;
+	job->ctx = ctx;
+	job->free_fct = free_fct;
+
+	spin_lock(&vcpui->job_lock);
+	list_add_tail(&job->link, &vcpui->job_list);
+	spin_unlock(&vcpui->job_lock);
+
+	return 0;
+}
+
+int kvmi_add_job(struct kvm_vcpu *vcpu,
+		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
+		 void *ctx, void (*free_fct)(void *ctx))
+{
+	int err;
+
+	err = __kvmi_add_job(vcpu, fct, ctx, free_fct);
+
+	return err;
+}
+
+static void kvmi_free_job(struct kvmi_job *job)
+{
+	if (job->free_fct)
+		job->free_fct(job->ctx);
+
+	kmem_cache_free(job_cache, job);
+}
+
 static bool kvmi_alloc_vcpui(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_introspection *vcpui;
@@ -126,6 +174,9 @@ static bool kvmi_alloc_vcpui(struct kvm_vcpu *vcpu)
 	if (!vcpui)
 		return false;
 
+	INIT_LIST_HEAD(&vcpui->job_list);
+	spin_lock_init(&vcpui->job_lock);
+
 	vcpu->kvmi = vcpui;
 
 	return true;
@@ -139,9 +190,26 @@ static int kvmi_create_vcpui(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void kvmi_free_vcpu_jobs(struct kvm_vcpu_introspection *vcpui)
+{
+	struct kvmi_job *cur, *next;
+
+	list_for_each_entry_safe(cur, next, &vcpui->job_list, link) {
+		list_del(&cur->link);
+		kvmi_free_job(cur);
+	}
+}
+
 static void kvmi_free_vcpui(struct kvm_vcpu *vcpu)
 {
-	kfree(vcpu->kvmi);
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (!vcpui)
+		return;
+
+	kvmi_free_vcpu_jobs(vcpui);
+
+	kfree(vcpui);
 	vcpu->kvmi = NULL;
 }
 
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index b7c8730e7e6d..c3aa12554c2b 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -7,6 +7,7 @@
 #include <uapi/linux/kvmi.h>
 
 #define KVMI(kvm) ((kvm)->kvmi)
+#define VCPUI(vcpu) ((vcpu)->kvmi)
 /*
  * This limit is used to accommodate the largest known fixed-length
  * message.
