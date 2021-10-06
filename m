Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762D74244B2
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbhJFRmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:49 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53564 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239019AbhJFRmg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:36 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 31214307CAE6;
        Wed,  6 Oct 2021 20:30:59 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 157443064495;
        Wed,  6 Oct 2021 20:30:59 +0300 (EEST)
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
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 15/77] KVM: x86: add kvm_x86_ops.control_msr_intercept()
Date:   Wed,  6 Oct 2021 20:30:11 +0300
Message-Id: <20211006173113.26445-16-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed for the KVMI_VCPU_EVENT_MSR event, which is used notify
the introspection tool about any change made to a MSR of interest.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/svm/svm.c             | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c             |  7 +++++++
 4 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 90e913408c6e..4228b775a48e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -128,6 +128,7 @@ KVM_X86_OP(desc_ctrl_supported)
 KVM_X86_OP(control_desc_intercept)
 KVM_X86_OP(desc_intercepted)
 KVM_X86_OP(msr_write_intercepted)
+KVM_X86_OP(control_msr_intercept)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 79b2d8abff36..29f4e8b619e1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1335,6 +1335,8 @@ struct kvm_x86_ops {
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
+	void (*control_msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable);
 	bool (*msr_write_intercepted)(struct kvm_vcpu *vcpu, u32 msr);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 97f7406cf7d6..b7ef0671863e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -712,6 +712,16 @@ void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 	set_msr_interception_bitmap(vcpu, msrpm, msr, type, value);
 }
 
+static void svm_control_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable)
+{
+	const struct vcpu_svm *svm = to_svm(vcpu);
+	u32 *msrpm = is_guest_mode(vcpu) ? svm->nested.msrpm :
+					   svm->msrpm;
+
+	set_msr_interception(vcpu, msrpm, msr, type, enable);
+}
+
 u32 *svm_vcpu_alloc_msrpm(void)
 {
 	unsigned int order = get_order(MSRPM_SIZE);
@@ -4718,6 +4728,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
+	.control_msr_intercept = svm_control_msr_intercept,
 	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = svm_get_segment_base,
 	.get_segment = svm_get_segment,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b036aed96912..a140d69b1bd3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3859,6 +3859,12 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 		vmx_set_msr_bitmap_write(msr_bitmap, msr);
 }
 
+static void vmx_control_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable)
+{
+	vmx_set_intercept_for_msr(vcpu, msr, type, enable);
+}
+
 static void vmx_reset_x2apic_msrs(struct kvm_vcpu *vcpu, u8 mode)
 {
 	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
@@ -7637,6 +7643,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
+	.control_msr_intercept = vmx_control_msr_intercept,
 	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
