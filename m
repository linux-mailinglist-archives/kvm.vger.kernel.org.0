Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889AE2D1B46
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgLGUtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:49:35 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42570 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbgLGUs1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:27 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id AC4A6305D46C;
        Mon,  7 Dec 2020 22:46:19 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 871053072785;
        Mon,  7 Dec 2020 22:46:19 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 45/81] KVM: introspection: handle vCPU introspection requests
Date:   Mon,  7 Dec 2020 22:45:46 +0200
Message-Id: <20201207204622.15258-46-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

The receiving thread dispatches the vCPU introspection commands by
adding them to the vCPU's jobs list and kicking the vCPU. Before
entering in guest, the vCPU thread checks the introspection request
(KVM_REQ_INTROSPECTION) and runs its queued jobs.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c            |  3 ++
 include/linux/kvm_host.h      |  1 +
 include/linux/kvmi_host.h     |  4 ++
 virt/kvm/introspection/kvmi.c | 73 +++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c           |  2 +
 5 files changed, 83 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8a8a70552645..f691e8477136 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9144,6 +9144,9 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
+		if (kvm_check_request(KVM_REQ_INTROSPECTION, vcpu))
+			kvmi_handle_requests(vcpu);
+
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9441008b18be..66eca612adc7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -147,6 +147,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_PENDING_TIMER     2
 #define KVM_REQ_UNHALT            3
+#define KVM_REQ_INTROSPECTION     4
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index b3874419511d..736edb400c05 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -53,6 +53,8 @@ int kvmi_ioctl_event(struct kvm *kvm,
 		     const struct kvm_introspection_feature *feat);
 int kvmi_ioctl_preunhook(struct kvm *kvm);
 
+void kvmi_handle_requests(struct kvm_vcpu *vcpu);
+
 #else
 
 static inline int kvmi_version(void) { return 0; }
@@ -62,6 +64,8 @@ static inline void kvmi_create_vm(struct kvm *kvm) { }
 static inline void kvmi_destroy_vm(struct kvm *kvm) { }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
+static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
+
 #endif /* CONFIG_KVM_INTROSPECTION */
 
 #endif
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 6f73776eb04e..95677cb9a657 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -124,6 +124,12 @@ void kvmi_uninit(void)
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
@@ -155,6 +161,9 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 
 	err = __kvmi_add_job(vcpu, fct, ctx, free_fct);
 
+	if (!err)
+		kvmi_make_request(vcpu);
+
 	return err;
 }
 
@@ -323,6 +332,14 @@ int kvmi_ioctl_unhook(struct kvm *kvm)
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
 static void kvmi_put(struct kvm *kvm)
 {
 	if (refcount_dec_and_test(&kvm->kvmi_ref))
@@ -340,6 +357,19 @@ static int __kvmi_hook(struct kvm *kvm,
 	return 0;
 }
 
+static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
+{
+}
+
+static void kvmi_release_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvmi_add_job(vcpu, kvmi_job_release_vcpu, NULL, NULL);
+}
+
 static int kvmi_recv_thread(void *arg)
 {
 	struct kvm_introspection *kvmi = arg;
@@ -350,6 +380,8 @@ static int kvmi_recv_thread(void *arg)
 	/* Signal userspace and prevent the vCPUs from sending events. */
 	kvmi_sock_shutdown(kvmi);
 
+	kvmi_release_vcpus(kvmi->kvm);
+
 	kvmi_put(kvmi->kvm);
 	return 0;
 }
@@ -382,6 +414,10 @@ static int kvmi_hook(struct kvm *kvm,
 	init_completion(&kvm->kvmi_complete);
 
 	refcount_set(&kvm->kvmi_ref, 1);
+	/*
+	 * Paired with refcount_inc_not_zero() from kvmi_get().
+	 */
+	smp_wmb();
 
 	kvmi->recv = kthread_run(kvmi_recv_thread, kvmi, "kvmi-recv");
 	if (IS_ERR(kvmi->recv)) {
@@ -670,3 +706,40 @@ int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 
 	return ec;
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
index 783eec72bc73..c83acae3223b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2796,6 +2796,8 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 		goto out;
 	if (signal_pending(current))
 		goto out;
+	if (kvm_test_request(KVM_REQ_INTROSPECTION, vcpu))
+		goto out;
 
 	ret = 0;
 out:
