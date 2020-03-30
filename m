Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250841978CA
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgC3KUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:04 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43788 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729525AbgC3KUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2DE9B30747D2;
        Mon, 30 Mar 2020 13:12:51 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0486A305B7A1;
        Mon, 30 Mar 2020 13:12:50 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 16/81] KVM: x86: add .desc_intercepted()
Date:   Mon, 30 Mar 2020 13:12:03 +0300
Message-Id: <20200330101308.21702-17-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
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
index 11e49dbec78c..89968ec63b64 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1107,6 +1107,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	bool (*desc_ctrl_supported)(void);
 	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
+	bool (*desc_intercepted)(struct kvm_vcpu *vcpu);
 	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
 	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ea4f02cab67d..34e7f4f18cd8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -636,6 +636,13 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
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
@@ -7472,6 +7479,20 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
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
@@ -7522,6 +7543,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.set_gdt = svm_set_gdt,
 	.desc_ctrl_supported = svm_desc_ctrl_supported,
 	.control_desc_intercept = svm_control_desc_intercept,
+	.desc_intercepted = svm_desc_intercepted,
 	.get_dr6 = svm_get_dr6,
 	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c710bd200c56..4651d1283698 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7884,6 +7884,13 @@ static bool vmx_cr3_write_intercepted(struct kvm_vcpu *vcpu)
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
@@ -7931,6 +7938,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_gdt = vmx_set_gdt,
 	.desc_ctrl_supported = vmx_desc_ctrl_supported,
 	.control_desc_intercept = vmx_control_desc_intercept,
+	.desc_intercepted = vmx_desc_intercepted,
 	.get_dr6 = vmx_get_dr6,
 	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
