Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3D42D1AFE
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgLGUrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:47:41 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42576 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727009AbgLGUrk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:47:40 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 06920305D505;
        Mon,  7 Dec 2020 22:46:14 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DA35C3072785;
        Mon,  7 Dec 2020 22:46:13 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 13/81] KVM: x86: add kvm_x86_ops.control_desc_intercept()
Date:   Mon,  7 Dec 2020 22:45:14 +0200
Message-Id: <20201207204622.15258-14-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed to intercept descriptor-table registers access.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++--
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1e9cb521324e..730429cd2e3d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1131,6 +1131,7 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	bool (*desc_ctrl_supported)(void);
+	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 00bda794609c..c8e56ad9cbb1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1635,6 +1635,31 @@ static bool svm_desc_ctrl_supported(void)
 	return true;
 }
 
+static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (enable) {
+		svm_set_intercept(svm, INTERCEPT_STORE_IDTR);
+		svm_set_intercept(svm, INTERCEPT_STORE_GDTR);
+		svm_set_intercept(svm, INTERCEPT_STORE_LDTR);
+		svm_set_intercept(svm, INTERCEPT_STORE_TR);
+		svm_set_intercept(svm, INTERCEPT_LOAD_IDTR);
+		svm_set_intercept(svm, INTERCEPT_LOAD_GDTR);
+		svm_set_intercept(svm, INTERCEPT_LOAD_LDTR);
+		svm_set_intercept(svm, INTERCEPT_LOAD_TR);
+	} else {
+		svm_clr_intercept(svm, INTERCEPT_STORE_IDTR);
+		svm_clr_intercept(svm, INTERCEPT_STORE_GDTR);
+		svm_clr_intercept(svm, INTERCEPT_STORE_LDTR);
+		svm_clr_intercept(svm, INTERCEPT_STORE_TR);
+		svm_clr_intercept(svm, INTERCEPT_LOAD_IDTR);
+		svm_clr_intercept(svm, INTERCEPT_LOAD_GDTR);
+		svm_clr_intercept(svm, INTERCEPT_LOAD_LDTR);
+		svm_clr_intercept(svm, INTERCEPT_LOAD_TR);
+	}
+}
+
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
 	ulong gcr0 = svm->vcpu.arch.cr0;
@@ -4281,6 +4306,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
 	.desc_ctrl_supported = svm_desc_ctrl_supported,
+	.control_desc_intercept = svm_control_desc_intercept,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a5e1f61d2622..20351e027898 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3120,6 +3120,16 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
+static void vmx_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (enable)
+		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
+	else
+		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
+}
+
 static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	/*
@@ -3157,11 +3167,11 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
 		if (cr4 & X86_CR4_UMIP) {
-			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
+			vmx_control_desc_intercept(vcpu, true);
 			hw_cr4 &= ~X86_CR4_UMIP;
 		} else if (!is_guest_mode(vcpu) ||
 			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC)) {
-			secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
+			vmx_control_desc_intercept(vcpu, false);
 		}
 	}
 
@@ -7657,6 +7667,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
 	.desc_ctrl_supported = vmx_desc_ctrl_supported,
+	.control_desc_intercept = vmx_control_desc_intercept,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
