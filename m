Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C71155D7D
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBGSQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:44 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40634 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbgBGSQn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:43 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2E42B305D3CD;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C7A5D305206D;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 10/78] KVM: x86: add .bp_intercepted() to struct kvm_x86_ops
Date:   Fri,  7 Feb 2020 20:15:28 +0200
Message-Id: <20200207181636.1065-11-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

The introspection tool and the userspace could request #BP
interception. This function will be used to check if the interception
is already enabled.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6aa4075..d279195dac97 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1048,6 +1048,7 @@ struct kvm_x86_ops {
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
+	bool (*bp_intercepted)(struct kvm_vcpu *vcpu);
 	void (*update_bp_intercept)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 122d4ce3b1ab..df34ab0da4ff 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -607,6 +607,13 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
+static inline bool get_exception_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	return (vmcb->control.intercept_exceptions & (1U << bit));
+}
+
 static inline void set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
@@ -7242,6 +7249,13 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
 }
 
+static inline bool svm_bp_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return get_exception_intercept(svm, BP_VECTOR);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7268,6 +7282,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.vcpu_blocking = svm_vcpu_blocking,
 	.vcpu_unblocking = svm_vcpu_unblocking,
 
+	.bp_intercepted = svm_bp_intercepted,
 	.update_bp_intercept = update_bp_intercept,
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..0d7ca70b310e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7758,6 +7758,11 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
+static bool vmx_bp_intercepted(struct kvm_vcpu *vcpu)
+{
+	return (vmcs_read32(EXCEPTION_BITMAP) & (1u << BP_VECTOR));
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7781,6 +7786,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
+	.bp_intercepted = vmx_bp_intercepted,
 	.update_bp_intercept = update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
