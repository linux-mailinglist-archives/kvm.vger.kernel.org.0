Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5593D4244E2
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbhJFRn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:26 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53722 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239342AbhJFRmm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:42 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A5A60307CADD;
        Wed,  6 Oct 2021 20:30:55 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8C1FB3064495;
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>
Subject: [PATCH v12 07/77] KVM: x86: add kvm_x86_ops.control_cr3_intercept()
Date:   Wed,  6 Oct 2021 20:30:03 +0300
Message-Id: <20211006173113.26445-8-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VCPU_CONTROL_CR command, when the
introspection tool has to intercept the read/write access to CR3.

Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  6 ++++++
 arch/x86/kvm/svm/svm.c             | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c             | 18 ++++++++++++++++++
 4 files changed, 39 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 31af251c5622..e1f63d36efb7 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -122,6 +122,7 @@ KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
 KVM_X86_OP(bp_intercepted)
+KVM_X86_OP(control_cr3_intercept)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26a52520b8bd..89d53e55e1f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -146,6 +146,10 @@
 #define KVM_NR_FIXED_MTRR_REGION 88
 #define KVM_NR_VAR_MTRR 8
 
+#define CR_TYPE_R	1
+#define CR_TYPE_W	2
+#define CR_TYPE_RW	3
+
 #define ASYNC_PF_PER_VCPU 64
 
 enum kvm_reg {
@@ -1337,6 +1341,8 @@ struct kvm_x86_ops {
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	bool (*is_valid_cr4)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
+	void (*control_cr3_intercept)(struct kvm_vcpu *vcpu, int type,
+				      bool enable);
 	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index abecc1234161..5a051fa19c7e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1850,6 +1850,19 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		kvm_update_cpuid_runtime(vcpu);
 }
 
+static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
+				      bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (type & CR_TYPE_R)
+		enable ? svm_set_intercept(svm, INTERCEPT_CR3_READ) :
+			 svm_clr_intercept(svm, INTERCEPT_CR3_READ);
+	if (type & CR_TYPE_W)
+		enable ? svm_set_intercept(svm, INTERCEPT_CR3_WRITE) :
+			 svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
+}
+
 static void svm_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
@@ -4620,6 +4633,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_cr0 = svm_set_cr0,
 	.is_valid_cr4 = svm_is_valid_cr4,
 	.set_cr4 = svm_set_cr4,
+	.control_cr3_intercept = svm_control_cr3_intercept,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
 	.set_idt = svm_set_idt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6fdc3d10b2b4..c8f5bc371f38 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3004,6 +3004,23 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 #define CR3_EXITING_BITS (CPU_BASED_CR3_LOAD_EXITING | \
 			  CPU_BASED_CR3_STORE_EXITING)
 
+static void vmx_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
+				      bool enable)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 cr3_exec_control = 0;
+
+	if (type & CR_TYPE_R)
+		cr3_exec_control |= CPU_BASED_CR3_STORE_EXITING;
+	if (type & CR_TYPE_W)
+		cr3_exec_control |= CPU_BASED_CR3_LOAD_EXITING;
+
+	if (enable)
+		exec_controls_setbit(vmx, cr3_exec_control);
+	else
+		exec_controls_clearbit(vmx, cr3_exec_control);
+}
+
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7604,6 +7621,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_cr0 = vmx_set_cr0,
 	.is_valid_cr4 = vmx_is_valid_cr4,
 	.set_cr4 = vmx_set_cr4,
+	.control_cr3_intercept = vmx_control_cr3_intercept,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
