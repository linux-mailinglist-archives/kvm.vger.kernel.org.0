Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF9D155DAB
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgBGSRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:53 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40728 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727609AbgBGSQv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:51 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C775A305D34E;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B52F23052069;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 48/78] KVM: introspection: handle vCPU introspection requests
Date:   Fri,  7 Feb 2020 20:16:06 +0200
Message-Id: <20200207181636.1065-49-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

The introspection requests (KVM_REQ_INTROSPECTION) are checked before
entering guest or when the vCPU is halted.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              |  3 ++
 include/linux/kvm_host.h        |  2 +
 include/linux/kvmi_host.h       |  4 ++
 virt/kvm/introspection/kvmi.c   | 72 +++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c             |  2 +
 6 files changed, 84 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 378a094ceb5b..9cf45ca73af5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -78,6 +78,7 @@
 #define KVM_REQ_HV_STIMER		KVM_ARCH_REQ(22)
 #define KVM_REQ_LOAD_EOI_EXITMAP	KVM_ARCH_REQ(23)
 #define KVM_REQ_GET_VMCS12_PAGES	KVM_ARCH_REQ(24)
+#define KVM_REQ_INTROSPECTION		KVM_ARCH_REQ(25)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46aeb32cb07f..46a135595893 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8391,6 +8391,9 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
+		if (kvm_check_request(KVM_REQ_INTROSPECTION, vcpu))
+			kvmi_handle_requests(vcpu);
+
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 52e98720d0f6..d2d9b814093e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -505,6 +505,8 @@ struct kvm {
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
 	struct mutex kvmi_lock;
+	refcount_t kvmi_ref;
+	struct completion kvmi_complete;
 	struct kvm_introspection *kvmi;
 };
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 1d80d233fbd5..6a0fb481b192 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -56,6 +56,8 @@ int kvmi_ioctl_command(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_preunhook(struct kvm *kvm);
 
+void kvmi_handle_requests(struct kvm_vcpu *vcpu);
+
 #else
 
 static inline int kvmi_init(void) { return 0; }
@@ -64,6 +66,8 @@ static inline void kvmi_create_vm(struct kvm *kvm) { }
 static inline void kvmi_destroy_vm(struct kvm *kvm) { }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
+static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
+
 #endif /* CONFIG_KVM_INTROSPECTION */
 
 #endif
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 5149f8e06131..ea86512ca81e 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -65,6 +65,12 @@ void kvmi_uninit(void)
 	kvmi_cache_destroy();
 }
 
+static void kvmi_make_request(struct kvm_vcpu *vcpu)
+{
+	kvm_make_request(KVM_REQ_INTROSPECTION, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
 static int __kvmi_add_job(struct kvm_vcpu *vcpu,
 			  void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 			  void *ctx, void (*free_fct)(void *ctx))
@@ -96,6 +102,9 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 
 	err = __kvmi_add_job(vcpu, fct, ctx, free_fct);
 
+	if (!err)
+		kvmi_make_request(vcpu);
+
 	return err;
 }
 
@@ -217,6 +226,7 @@ static void __kvmi_unhook(struct kvm *kvm)
 {
 	struct kvm_introspection *kvmi = KVMI(kvm);
 
+	wait_for_completion_killable(&kvm->kvmi_complete);
 	kvmi_sock_put(kvmi);
 }
 
@@ -242,8 +252,23 @@ int kvmi_ioctl_unhook(struct kvm *kvm)
 	return 0;
 }
 
+struct kvm_introspection * __must_check kvmi_get(struct kvm *kvm)
+{
+	if (refcount_inc_not_zero(&kvm->kvmi_ref))
+		return kvm->kvmi;
+
+	return NULL;
+}
+
+void kvmi_put(struct kvm *kvm)
+{
+	if (refcount_dec_and_test(&kvm->kvmi_ref))
+		complete(&kvm->kvmi_complete);
+}
+
 static int __kvmi_hook(struct kvm *kvm,
 		       const struct kvm_introspection_hook *hook)
+
 {
 	struct kvm_introspection *kvmi = KVMI(kvm);
 
@@ -266,6 +291,7 @@ static int kvmi_recv_thread(void *arg)
 	 */
 	kvmi_sock_shutdown(kvmi);
 
+	kvmi_put(kvmi->kvm);
 	return 0;
 }
 
@@ -293,9 +319,18 @@ int kvmi_hook(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	if (err)
 		goto destroy;
 
+	init_completion(&kvm->kvmi_complete);
+
+	refcount_set(&kvm->kvmi_ref, 1);
+	/*
+	 * Paired with refcount_inc_not_zero() from kvmi_get().
+	 */
+	smp_wmb();
+
 	kvmi->recv = kthread_run(kvmi_recv_thread, kvmi, "kvmi-recv");
 	if (IS_ERR(kvmi->recv)) {
 		err = -ENOMEM;
+		kvmi_put(kvm);
 		goto unhook;
 	}
 
@@ -616,3 +651,40 @@ int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, u64 size, const void *buf)
 
 	return 0;
 }
+
+static struct kvmi_job *kvmi_pull_job(struct kvm_vcpu_introspection *vcpui)
+{
+	struct kvmi_job *job = NULL;
+
+	spin_lock(&vcpui->job_lock);
+	job = list_first_entry_or_null(&vcpui->job_list, typeof(*job), link);
+	if (job)
+		list_del(&job->link);
+	spin_unlock(&vcpui->job_lock);
+
+	return job;
+}
+
+void kvmi_run_jobs(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	struct kvmi_job *job;
+
+	while ((job = kvmi_pull_job(vcpui))) {
+		job->fct(vcpu, job->ctx);
+		kvmi_free_job(job);
+	}
+}
+
+void kvmi_handle_requests(struct kvm_vcpu *vcpu)
+{
+	struct kvm_introspection *kvmi;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return;
+
+	kvmi_run_jobs(vcpu);
+
+	kvmi_put(vcpu->kvm);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ef7d14ef8e86..b701254f1125 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2414,6 +2414,8 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 		goto out;
 	if (signal_pending(current))
 		goto out;
+	if (kvm_test_request(KVM_REQ_INTROSPECTION, vcpu))
+		goto out;
 
 	ret = 0;
 out:
