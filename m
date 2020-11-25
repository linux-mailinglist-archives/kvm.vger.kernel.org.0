Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9512C3CB9
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgKYJmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:49 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57144 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728291AbgKYJmB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:01 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2D094305D500;
        Wed, 25 Nov 2020 11:35:45 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0E61D3072784;
        Wed, 25 Nov 2020 11:35:45 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 14/81] KVM: x86: add kvm_x86_ops.desc_intercepted()
Date:   Wed, 25 Nov 2020 11:34:53 +0200
Message-Id: <20201125093600.2766-15-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
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
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 730429cd2e3d..0e9144e23ce6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1132,6 +1132,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	bool (*desc_ctrl_supported)(void);
 	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
+	bool (*desc_intercepted)(struct kvm_vcpu *vcpu);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c8e56ad9cbb1..86f0dcf9fecd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1660,6 +1660,20 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 	}
 }
 
+static inline bool svm_desc_intercepted(struct kvm_vcpu *vcpu)
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
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
 	ulong gcr0 = svm->vcpu.arch.cr0;
@@ -4307,6 +4321,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_gdt = svm_set_gdt,
 	.desc_ctrl_supported = svm_desc_ctrl_supported,
 	.control_desc_intercept = svm_control_desc_intercept,
+	.desc_intercepted = svm_desc_intercepted,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 20351e027898..5bd6a4add27e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3361,6 +3361,13 @@ static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
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
@@ -7668,6 +7675,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_gdt = vmx_set_gdt,
 	.desc_ctrl_supported = vmx_desc_ctrl_supported,
 	.control_desc_intercept = vmx_control_desc_intercept,
+	.desc_intercepted = vmx_desc_intercepted,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
