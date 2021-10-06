Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FD94244E3
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbhJFRn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:27 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53746 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239325AbhJFRmm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:42 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 17C14307CADE;
        Wed,  6 Oct 2021 20:30:56 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id F31153064495;
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
Subject: [PATCH v12 08/77] KVM: x86: add kvm_x86_ops.cr3_write_intercepted()
Date:   Wed,  6 Oct 2021 20:30:04 +0300
Message-Id: <20211006173113.26445-9-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function will be used to allow the introspection tool to disable the
CR3-write interception when it is no longer interested in these events,
but only if nothing else depends on these VM-exits.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/svm/svm.c             | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c             | 8 ++++++++
 4 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e1f63d36efb7..04a77a0858ef 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -123,6 +123,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
 KVM_X86_OP(bp_intercepted)
 KVM_X86_OP(control_cr3_intercept)
+KVM_X86_OP(cr3_write_intercepted)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 89d53e55e1f9..9c3133380028 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1343,6 +1343,7 @@ struct kvm_x86_ops {
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*control_cr3_intercept)(struct kvm_vcpu *vcpu, int type,
 				      bool enable);
+	bool (*cr3_write_intercepted)(struct kvm_vcpu *vcpu);
 	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5a051fa19c7e..9fac69c8e135 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1863,6 +1863,13 @@ static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 			 svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
 }
 
+static bool svm_cr3_write_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm_is_intercept(svm, INTERCEPT_CR3_WRITE);
+}
+
 static void svm_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
@@ -4634,6 +4641,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.is_valid_cr4 = svm_is_valid_cr4,
 	.set_cr4 = svm_set_cr4,
 	.control_cr3_intercept = svm_control_cr3_intercept,
+	.cr3_write_intercepted = svm_cr3_write_intercepted,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
 	.set_idt = svm_set_idt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8f5bc371f38..3f5731213acf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3021,6 +3021,13 @@ static void vmx_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 		exec_controls_clearbit(vmx, cr3_exec_control);
 }
 
+static bool vmx_cr3_write_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return !!(exec_controls_get(vmx) & CPU_BASED_CR3_LOAD_EXITING);
+}
+
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7622,6 +7629,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.is_valid_cr4 = vmx_is_valid_cr4,
 	.set_cr4 = vmx_set_cr4,
 	.control_cr3_intercept = vmx_control_cr3_intercept,
+	.cr3_write_intercepted = vmx_cr3_write_intercepted,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
