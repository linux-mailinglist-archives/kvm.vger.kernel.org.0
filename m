Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8441978E1
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbgC3KUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:20 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43780 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729757AbgC3KUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id F3C6330747CE;
        Mon, 30 Mar 2020 13:12:50 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D330C305B7A0;
        Mon, 30 Mar 2020 13:12:50 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 15/81] KVM: x86: add .control_desc_intercept()
Date:   Mon, 30 Mar 2020 13:12:02 +0300
Message-Id: <20200330101308.21702-16-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_EVENT_DESCRIPTOR event.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++--
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 81a59b03b0c5..11e49dbec78c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1106,6 +1106,7 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	bool (*desc_ctrl_supported)(void);
+	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
 	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
 	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fd21439475b5..ea4f02cab67d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7447,6 +7447,31 @@ static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 			 clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
 }
 
+static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (enable) {
+		set_intercept(svm, INTERCEPT_STORE_IDTR);
+		set_intercept(svm, INTERCEPT_STORE_GDTR);
+		set_intercept(svm, INTERCEPT_STORE_LDTR);
+		set_intercept(svm, INTERCEPT_STORE_TR);
+		set_intercept(svm, INTERCEPT_LOAD_IDTR);
+		set_intercept(svm, INTERCEPT_LOAD_GDTR);
+		set_intercept(svm, INTERCEPT_LOAD_LDTR);
+		set_intercept(svm, INTERCEPT_LOAD_TR);
+	} else {
+		clr_intercept(svm, INTERCEPT_STORE_IDTR);
+		clr_intercept(svm, INTERCEPT_STORE_GDTR);
+		clr_intercept(svm, INTERCEPT_STORE_LDTR);
+		clr_intercept(svm, INTERCEPT_STORE_TR);
+		clr_intercept(svm, INTERCEPT_LOAD_IDTR);
+		clr_intercept(svm, INTERCEPT_LOAD_GDTR);
+		clr_intercept(svm, INTERCEPT_LOAD_LDTR);
+		clr_intercept(svm, INTERCEPT_LOAD_TR);
+	}
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7496,6 +7521,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
 	.desc_ctrl_supported = svm_desc_ctrl_supported,
+	.control_desc_intercept = svm_control_desc_intercept,
 	.get_dr6 = svm_get_dr6,
 	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 657c9ac0070b..c710bd200c56 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3034,6 +3034,16 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
 	return eptp;
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
 void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -3090,11 +3100,11 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
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
 
@@ -7920,6 +7930,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
 	.desc_ctrl_supported = vmx_desc_ctrl_supported,
+	.control_desc_intercept = vmx_control_desc_intercept,
 	.get_dr6 = vmx_get_dr6,
 	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
