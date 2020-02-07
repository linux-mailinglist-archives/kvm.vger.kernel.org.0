Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA90155D85
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgBGSQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:54 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40646 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727613AbgBGSQu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:50 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C1FA4305D34D;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AC853305207C;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v7 47/78] KVM: introspection: add a jobs list to every introspected vCPU
Date:   Fri,  7 Feb 2020 20:16:05 +0200
Message-Id: <20200207181636.1065-48-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every vCPU has a lock-protected list in which (mostly) the receiving
worker places the jobs that has to be done by the vCPU once it is kicked
(KVM_REQ_INTROSPECTION) out of guest.

A job is defined by a "do" function, a "free" function and a pointer
(context).

Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/linux/kvmi_host.h         | 10 +++++
 virt/kvm/introspection/kvmi.c     | 68 ++++++++++++++++++++++++++++++-
 virt/kvm/introspection/kvmi_int.h |  1 +
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index ca2db8043a53..1d80d233fbd5 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -11,8 +11,18 @@ struct kvm_vcpu;
 
 #define KVMI_NUM_COMMANDS KVMI_NUM_MESSAGES
 
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
index 655170ffb574..5149f8e06131 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -10,6 +10,7 @@
 #include <linux/kthread.h>
 
 static struct kmem_cache *msg_cache;
+static struct kmem_cache *job_cache;
 
 void *kvmi_msg_alloc(void)
 {
@@ -33,14 +34,19 @@ static void kvmi_cache_destroy(void)
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
@@ -59,6 +65,48 @@ void kvmi_uninit(void)
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
 static bool alloc_vcpui(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_introspection *vcpui;
@@ -67,6 +115,9 @@ static bool alloc_vcpui(struct kvm_vcpu *vcpu)
 	if (!vcpui)
 		return false;
 
+	INIT_LIST_HEAD(&vcpui->job_list);
+	spin_lock_init(&vcpui->job_lock);
+
 	vcpu->kvmi = vcpui;
 
 	return true;
@@ -82,7 +133,20 @@ static int create_vcpui(struct kvm_vcpu *vcpu)
 
 static void free_vcpui(struct kvm_vcpu *vcpu)
 {
-	kfree(vcpu->kvmi);
+	struct kvm_vcpu_introspection *vcpui = vcpu->kvmi;
+	struct kvmi_job *cur, *next;
+
+	if (!vcpui)
+		return;
+
+	spin_lock(&vcpui->job_lock);
+	list_for_each_entry_safe(cur, next, &vcpui->job_list, link) {
+		list_del(&cur->link);
+		kvmi_free_job(cur);
+	}
+	spin_unlock(&vcpui->job_lock);
+
+	kfree(vcpui);
 	vcpu->kvmi = NULL;
 }
 
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 3bc598b9b66c..e0d8256162f9 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -36,6 +36,7 @@
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
+#define VCPUI(vcpu) ((struct kvm_vcpu_introspection *)((vcpu)->kvmi))
 
 static inline bool is_vm_event_enabled(struct kvm_introspection *kvmi,
 					int event)
