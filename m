Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B63A228AF7
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbgGUVP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:15:59 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37788 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731191AbgGUVP4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:15:56 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0C3FC305D761;
        Wed, 22 Jul 2020 00:09:21 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E1E50304FA14;
        Wed, 22 Jul 2020 00:09:20 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 15/84] KVM: x86: add .desc_intercepted()
Date:   Wed, 22 Jul 2020 00:08:13 +0300
Message-Id: <20200721210922.7646-16-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This function will be used to test if the descriptor-table registers
access is already tracked by another user.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          | 15 +++++++++++++++
 arch/x86/kvm/svm/svm.h          |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          |  8 ++++++++
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 83dfa0247130..2ed1e5621ccf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1125,6 +1125,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	bool (*desc_ctrl_supported)(void);
 	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
+	bool (*desc_intercepted)(struct kvm_vcpu *vcpu);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c70c14461483..cc55c571fe86 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1553,6 +1553,20 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 	}
 }
 
+static inline bool svm_desc_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return (get_intercept(svm, INTERCEPT_STORE_IDTR) ||
+		get_intercept(svm, INTERCEPT_STORE_GDTR) ||
+		get_intercept(svm, INTERCEPT_STORE_LDTR) ||
+		get_intercept(svm, INTERCEPT_STORE_TR) ||
+		get_intercept(svm, INTERCEPT_LOAD_IDTR) ||
+		get_intercept(svm, INTERCEPT_LOAD_GDTR) ||
+		get_intercept(svm, INTERCEPT_LOAD_LDTR) ||
+		get_intercept(svm, INTERCEPT_LOAD_TR));
+}
+
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
 	ulong gcr0 = svm->vcpu.arch.cr0;
@@ -4082,6 +4096,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_gdt = svm_set_gdt,
 	.desc_ctrl_supported = svm_desc_ctrl_supported,
 	.control_desc_intercept = svm_control_desc_intercept,
+	.desc_intercepted = svm_desc_intercepted,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d5c956e07c12..f86fababe413 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -318,6 +318,13 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
+static inline bool get_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	return (vmcb->control.intercept & (1ULL << bit));
+}
+
 static inline bool is_intercept(struct vcpu_svm *svm, int bit)
 {
 	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 199ffd318145..3b5778003b58 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3388,6 +3388,13 @@ static void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
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
@@ -7915,6 +7922,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_gdt = vmx_set_gdt,
 	.desc_ctrl_supported = vmx_desc_ctrl_supported,
 	.control_desc_intercept = vmx_control_desc_intercept,
+	.desc_intercepted = vmx_desc_intercepted,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
