Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434674244DA
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239661AbhJFRnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:13 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53560 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239239AbhJFRmk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:40 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2770E305CD43;
        Wed,  6 Oct 2021 20:31:11 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0D3783011FD8;
        Wed,  6 Oct 2021 20:31:11 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 42/77] KVM: introspection: handle vCPU introspection requests
Date:   Wed,  6 Oct 2021 20:30:38 +0300
Message-Id: <20211006173113.26445-43-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
index ee08fb330f0f..0315c5a94af3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9827,6 +9827,9 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1tf_flush_l1d = true;
 
 	for (;;) {
+		if (kvm_check_request(KVM_REQ_INTROSPECTION, vcpu))
+			kvmi_handle_requests(vcpu);
+
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 30bf1227c4a7..7d429d3afbb6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -151,6 +151,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
 #define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_INTROSPECTION     5
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
index e8d2d280fb43..93b1bec23e48 100644
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
index d70ec110696f..fd05869d703a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3202,6 +3202,8 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 		goto out;
 	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
 		goto out;
+	if (kvm_test_request(KVM_REQ_INTROSPECTION, vcpu))
+		goto out;
 
 	ret = 0;
 out:
