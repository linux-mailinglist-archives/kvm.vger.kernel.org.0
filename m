Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A90155DB4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgBGSQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:47 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40648 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727243AbgBGSQo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:44 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4A1A3305D3D1;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3B4C63052071;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 14/78] KVM: x86: add .desc_intercepted()
Date:   Fri,  7 Feb 2020 20:15:32 +0200
Message-Id: <20200207181636.1065-15-alazar@bitdefender.com>
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

This function will be used to test if the descriptor access events
are already tracked by another user.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 22 ++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  8 ++++++++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3b86e745da05..4d43f5479c0c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1077,6 +1077,7 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
+	bool (*desc_intercepted)(struct kvm_vcpu *vcpu);
 	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
 	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 060d49b69b2e..bf1f2bca5357 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -632,6 +632,13 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
+static inline bool get_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	return (vmcb->control.intercept & (1ULL << bit));
+}
+
 static inline bool vgif_enabled(struct vcpu_svm *svm)
 {
 	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
@@ -7301,6 +7308,20 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
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
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7350,6 +7371,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
 	.control_desc_intercept = svm_control_desc_intercept,
+	.desc_intercepted = svm_desc_intercepted,
 	.get_dr6 = svm_get_dr6,
 	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 646ce2650728..8709a26736d9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7793,6 +7793,13 @@ static bool vmx_cr3_write_intercepted(struct kvm_vcpu *vcpu)
 	return !!(exec_controls_get(vmx) & CPU_BASED_CR3_LOAD_EXITING);
 }
 
+static bool vmx_desc_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return !!(secondary_exec_controls_get(vmx) & SECONDARY_EXEC_DESC);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7839,6 +7846,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
 	.control_desc_intercept = vmx_control_desc_intercept,
+	.desc_intercepted = vmx_desc_intercepted,
 	.get_dr6 = vmx_get_dr6,
 	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
