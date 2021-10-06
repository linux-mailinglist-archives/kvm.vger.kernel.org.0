Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE054244FF
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbhJFRoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:44:14 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53720 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239453AbhJFRmq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:46 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 483D0307CABF;
        Wed,  6 Oct 2021 20:30:55 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 2E6543064495;
        Wed,  6 Oct 2021 20:30:55 +0300 (EEST)
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
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 06/77] KVM: x86: add kvm_x86_ops.bp_intercepted()
Date:   Wed,  6 Oct 2021 20:30:02 +0300
Message-Id: <20211006173113.26445-7-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

Both, the introspection tool and the device manager can request #BP
interception. This function will be used to check if this interception
is already enabled by either side.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/svm/svm.c             | 8 ++++++++
 arch/x86/kvm/svm/svm.h             | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c             | 6 ++++++
 5 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..31af251c5622 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -121,6 +121,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
 KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP(bp_intercepted)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5271fce6cd65..26a52520b8bd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1323,6 +1323,7 @@ struct kvm_x86_ops {
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
+	bool (*bp_intercepted)(struct kvm_vcpu *vcpu);
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 89077160d463..abecc1234161 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1881,6 +1881,13 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 	vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
 }
 
+static bool svm_bp_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return get_exception_intercept(svm, BP_VECTOR);
+}
+
 static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4600,6 +4607,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_blocking = svm_vcpu_blocking,
 	.vcpu_unblocking = svm_vcpu_unblocking,
 
+	.bp_intercepted = svm_bp_intercepted,
 	.update_exception_bitmap = svm_update_exception_bitmap,
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d7bbe548ac3..32c2d6d3424b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -359,6 +359,14 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
 	recalc_intercepts(svm);
 }
 
+static inline bool get_exception_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	WARN_ON_ONCE(bit >= 32);
+	return vmcb_is_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
+}
+
 static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c8b2b6e7ed9..6fdc3d10b2b4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -715,6 +715,11 @@ static u32 vmx_read_guest_seg_ar(struct vcpu_vmx *vmx, unsigned seg)
 	return *p;
 }
 
+static bool vmx_bp_intercepted(struct kvm_vcpu *vcpu)
+{
+	return (vmcs_read32(EXCEPTION_BITMAP) & (1u << BP_VECTOR));
+}
+
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 {
 	u32 eb;
@@ -7586,6 +7591,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
+	.bp_intercepted = vmx_bp_intercepted,
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
