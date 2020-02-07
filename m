Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460AB155D7F
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgBGSQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:46 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40646 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727195AbgBGSQn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:43 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 43D26305D3D0;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 363773052070;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 13/78] KVM: x86: add .control_desc_intercept()
Date:   Fri,  7 Feb 2020 20:15:31 +0200
Message-Id: <20200207181636.1065-14-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
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
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d2fe08f44084..3b86e745da05 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1076,6 +1076,7 @@ struct kvm_x86_ops {
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
+	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
 	u64 (*get_dr6)(struct kvm_vcpu *vcpu);
 	void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 554ad7c57a0f..060d49b69b2e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7276,6 +7276,31 @@ static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
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
@@ -7324,6 +7349,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.set_idt = svm_set_idt,
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
+	.control_desc_intercept = svm_control_desc_intercept,
 	.get_dr6 = svm_get_dr6,
 	.set_dr6 = svm_set_dr6,
 	.set_dr7 = svm_set_dr7,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7cfd25800d89..646ce2650728 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2998,6 +2998,16 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa)
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
@@ -7828,6 +7838,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_idt = vmx_set_idt,
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
+	.control_desc_intercept = vmx_control_desc_intercept,
 	.get_dr6 = vmx_get_dr6,
 	.set_dr6 = vmx_set_dr6,
 	.set_dr7 = vmx_set_dr7,
