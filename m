Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E243424497
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239382AbhJFRml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:41 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53568 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238476AbhJFRme (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:34 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CE2F4307CAE1;
        Wed,  6 Oct 2021 20:30:57 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B454A3064495;
        Wed,  6 Oct 2021 20:30:57 +0300 (EEST)
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
Subject: [PATCH v12 12/77] KVM: x86: add kvm_x86_ops.desc_intercepted()
Date:   Wed,  6 Oct 2021 20:30:08 +0300
Message-Id: <20211006173113.26445-13-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function will be used to test if the descriptor-table registers
access is already tracked by userspace.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmx.c             |  8 ++++++++
 4 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index dd08f3120f8f..30d01c9ed31b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -126,6 +126,7 @@ KVM_X86_OP(control_cr3_intercept)
 KVM_X86_OP(cr3_write_intercepted)
 KVM_X86_OP(desc_ctrl_supported)
 KVM_X86_OP(control_desc_intercept)
+KVM_X86_OP(desc_intercepted)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2e5ddb18804b..1182b0fbd245 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1351,6 +1351,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	bool (*desc_ctrl_supported)(void);
 	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
+	bool (*desc_intercepted)(struct kvm_vcpu *vcpu);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0d46f5aa20c3..c1b1e5cdd508 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1805,6 +1805,20 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 	}
 }
 
+static bool svm_desc_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return (svm_is_intercept(svm, INTERCEPT_STORE_IDTR) ||
+		svm_is_intercept(svm, INTERCEPT_STORE_GDTR) ||
+		svm_is_intercept(svm, INTERCEPT_STORE_LDTR) ||
+		svm_is_intercept(svm, INTERCEPT_STORE_TR) ||
+		svm_is_intercept(svm, INTERCEPT_LOAD_IDTR) ||
+		svm_is_intercept(svm, INTERCEPT_LOAD_GDTR) ||
+		svm_is_intercept(svm, INTERCEPT_LOAD_LDTR) ||
+		svm_is_intercept(svm, INTERCEPT_LOAD_TR));
+}
+
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4692,6 +4706,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_gdt = svm_set_gdt,
 	.desc_ctrl_supported = svm_desc_ctrl_supported,
 	.control_desc_intercept = svm_control_desc_intercept,
+	.desc_intercepted = svm_desc_intercepted,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d0f02d52b401..8f34b19827a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3405,6 +3405,13 @@ static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 	vmcs_writel(GUEST_GDTR_BASE, dt->address);
 }
 
+static bool vmx_desc_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return !!(secondary_exec_controls_get(vmx) & SECONDARY_EXEC_DESC);
+}
+
 static bool rmode_segment_valid(struct kvm_vcpu *vcpu, int seg)
 {
 	struct kvm_segment var;
@@ -7647,6 +7654,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_gdt = vmx_set_gdt,
 	.desc_ctrl_supported = vmx_desc_ctrl_supported,
 	.control_desc_intercept = vmx_control_desc_intercept,
+	.desc_intercepted = vmx_desc_intercepted,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
