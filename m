Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2713F155DCA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgBGSQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:45 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40640 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727162AbgBGSQn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:43 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3D0B0305D3CF;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 30963305206F;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 12/78] KVM: x86: add .cr3_write_intercepted()
Date:   Fri,  7 Feb 2020 20:15:30 +0200
Message-Id: <20200207181636.1065-13-alazar@bitdefender.com>
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

This function will be used to allow the introspection tool to disable the
CR3-write interception when it is no longer interested in these events,
but only if nothing depends on these VM-exits.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9032c996ebdb..d2fe08f44084 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1070,6 +1070,7 @@ struct kvm_x86_ops {
 	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*control_cr3_intercept)(struct kvm_vcpu *vcpu, int type,
 				      bool enable);
+	bool (*cr3_write_intercepted)(struct kvm_vcpu *vcpu);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b6081afec926..554ad7c57a0f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7256,6 +7256,13 @@ static inline bool svm_bp_intercepted(struct kvm_vcpu *vcpu)
 	return get_exception_intercept(svm, BP_VECTOR);
 }
 
+static inline bool svm_cr3_write_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return is_cr_intercept(svm, INTERCEPT_CR3_WRITE);
+}
+
 static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 				      bool enable)
 {
@@ -7311,6 +7318,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.set_cr3 = svm_set_cr3,
 	.set_cr4 = svm_set_cr4,
 	.control_cr3_intercept = svm_control_cr3_intercept,
+	.cr3_write_intercepted = svm_cr3_write_intercepted,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
 	.set_idt = svm_set_idt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4b6edb68e9e0..7cfd25800d89 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7776,6 +7776,13 @@ static bool vmx_bp_intercepted(struct kvm_vcpu *vcpu)
 	return (vmcs_read32(EXCEPTION_BITMAP) & (1u << BP_VECTOR));
 }
 
+static bool vmx_cr3_write_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return !!(exec_controls_get(vmx) & CPU_BASED_CR3_LOAD_EXITING);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7815,6 +7822,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
 	.control_cr3_intercept = vmx_control_cr3_intercept,
+	.cr3_write_intercepted = vmx_cr3_write_intercepted,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
