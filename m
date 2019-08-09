Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE6C87FAC
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437228AbfHIQUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:38 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53318 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437093AbfHIQT7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:59 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6978F305D3D3;
        Fri,  9 Aug 2019 19:00:56 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D8593305B7A3;
        Fri,  9 Aug 2019 19:00:55 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 12/92] kvm: introspection: add a jobs list to every introspected vCPU
Date:   Fri,  9 Aug 2019 18:59:27 +0300
Message-Id: <20190809160047.8319-13-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every vCPU has a lock-protected list in which (mostly) the receiving
worker places the jobs to be done by the vCPU once it is kicked
(KVM_REQ_INTROSPECTION) out of guest.

A job is defined by a "do" function, a pointer (context) and a "free"
function.

Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 virt/kvm/kvmi.c                 | 102 +++++++++++++++++++++++++++++++-
 virt/kvm/kvmi_int.h             |   9 +++
 3 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 180373360e34..67ed934ca124 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -78,6 +78,7 @@
 #define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
 #define KVM_REQ_LOAD_EOI_EXITMAP	KVM_ARCH_REQ(23)
 #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
+#define KVM_REQ_INTROSPECTION		KVM_ARCH_REQ(25)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index 860574039221..07ebd1c629b0 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -11,6 +11,9 @@
 #include <linux/bitmap.h>
 
 static struct kmem_cache *msg_cache;
+static struct kmem_cache *job_cache;
+
+static void kvmi_abort_events(struct kvm *kvm);
 
 void *kvmi_msg_alloc(void)
 {
@@ -34,14 +37,19 @@ static void kvmi_cache_destroy(void)
 {
 	kmem_cache_destroy(msg_cache);
 	msg_cache = NULL;
+	kmem_cache_destroy(job_cache);
+	job_cache = NULL;
 }
 
 static int kvmi_cache_create(void)
 {
+	job_cache = kmem_cache_create("kvmi_job",
+				      sizeof(struct kvmi_job),
+				      0, SLAB_ACCOUNT, NULL);
 	msg_cache = kmem_cache_create("kvmi_msg", KVMI_MSG_SIZE_ALLOC,
 				      4096, SLAB_ACCOUNT, NULL);
 
-	if (!msg_cache) {
+	if (!msg_cache || !job_cache) {
 		kvmi_cache_destroy();
 
 		return -1;
@@ -80,6 +88,53 @@ static bool alloc_kvmi(struct kvm *kvm, const struct kvm_introspection *qemu)
 	return true;
 }
 
+static int __kvmi_add_job(struct kvm_vcpu *vcpu,
+			  void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
+			  void *ctx, void (*free_fct)(void *ctx))
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
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
+	spin_lock(&ivcpu->job_lock);
+	list_add_tail(&job->link, &ivcpu->job_list);
+	spin_unlock(&ivcpu->job_lock);
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
+	if (!err) {
+		kvm_make_request(KVM_REQ_INTROSPECTION, vcpu);
+		kvm_vcpu_kick(vcpu);
+	}
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
 static bool alloc_ivcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu;
@@ -88,6 +143,9 @@ static bool alloc_ivcpu(struct kvm_vcpu *vcpu)
 	if (!ivcpu)
 		return false;
 
+	INIT_LIST_HEAD(&ivcpu->job_list);
+	spin_lock_init(&ivcpu->job_lock);
+
 	vcpu->kvmi = ivcpu;
 
 	return true;
@@ -101,6 +159,27 @@ struct kvmi * __must_check kvmi_get(struct kvm *kvm)
 	return NULL;
 }
 
+static void kvmi_clear_vcpu_jobs(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	struct kvmi_job *cur, *next;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+
+		if (!ivcpu)
+			continue;
+
+		spin_lock(&ivcpu->job_lock);
+		list_for_each_entry_safe(cur, next, &ivcpu->job_list, link) {
+			list_del(&cur->link);
+			kvmi_free_job(cur);
+		}
+		spin_unlock(&ivcpu->job_lock);
+	}
+}
+
 static void kvmi_destroy(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
@@ -118,6 +197,7 @@ static void kvmi_destroy(struct kvm *kvm)
 static void kvmi_release(struct kvm *kvm)
 {
 	kvmi_sock_put(IKVM(kvm));
+	kvmi_clear_vcpu_jobs(kvm);
 	kvmi_destroy(kvm);
 
 	complete(&kvm->kvmi_completed);
@@ -179,6 +259,13 @@ static void kvmi_end_introspection(struct kvmi *ikvm)
 	/* Signal QEMU which is waiting for POLLHUP. */
 	kvmi_sock_shutdown(ikvm);
 
+	/*
+	 * Trigger all the VCPUs out of waiting for replies. Although the
+	 * introspection is still enabled, sending additional events will
+	 * fail because the socket is shut down. Waiting will not be possible.
+	 */
+	kvmi_abort_events(kvm);
+
 	/*
 	 * At this moment the socket is shut down, no more commands will come
 	 * from the introspector, and the only way into the introspection is
@@ -420,6 +507,19 @@ int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
 	return 0;
 }
 
+static void kvmi_job_abort(struct kvm_vcpu *vcpu, void *ctx)
+{
+}
+
+static void kvmi_abort_events(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvmi_add_job(vcpu, kvmi_job_abort, NULL, NULL);
+}
+
 int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset)
 {
 	struct kvmi *ikvm;
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 8739a3435893..97f91a568096 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -75,7 +75,16 @@
 
 #define KVMI_NUM_COMMANDS KVMI_NEXT_AVAILABLE_COMMAND
 
+struct kvmi_job {
+	struct list_head link;
+	void *ctx;
+	void (*fct)(struct kvm_vcpu *vcpu, void *ctx);
+	void (*free_fct)(void *ctx);
+};
+
 struct kvmi_vcpu {
+	struct list_head job_list;
+	spinlock_t job_lock;
 };
 
 #define IKVM(kvm) ((struct kvmi *)((kvm)->kvmi))
