Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3692D1AFC
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgLGUrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:47:40 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42568 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgLGUrg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:47:36 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 80552305D502;
        Mon,  7 Dec 2020 22:46:13 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 577183072784;
        Mon,  7 Dec 2020 22:46:13 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 10/81] KVM: x86: add kvm_x86_ops.cr3_write_intercepted()
Date:   Mon,  7 Dec 2020 22:45:11 +0200
Message-Id: <20201207204622.15258-11-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function will be used to allow the introspection tool to disable the
CR3-write interception when it is no longer interested in these events,
but only if nothing else depends on these VM-exits.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/svm.c          | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0eeb1d829a1d..a402384a9326 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1124,6 +1124,7 @@ struct kvm_x86_ops {
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*control_cr3_intercept)(struct kvm_vcpu *vcpu, int type,
 				      bool enable);
+	bool (*cr3_write_intercepted)(struct kvm_vcpu *vcpu);
 	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4f28fa035048..5000ee25545b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1720,6 +1720,13 @@ static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 			 svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
 }
 
+static bool svm_cr3_write_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm_is_intercept(svm, INTERCEPT_CR3_WRITE);
+}
+
 static void svm_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
@@ -4247,6 +4254,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.is_valid_cr4 = svm_is_valid_cr4,
 	.set_cr4 = svm_set_cr4,
 	.control_cr3_intercept = svm_control_cr3_intercept,
+	.cr3_write_intercepted = svm_cr3_write_intercepted,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
 	.set_idt = svm_set_idt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c5a53642d1c0..7b2a60cd7a76 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2995,6 +2995,13 @@ static void vmx_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 		exec_controls_clearbit(vmx, cr3_exec_control);
 }
 
+static bool vmx_cr3_write_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return !!(exec_controls_get(vmx) & CPU_BASED_CR3_LOAD_EXITING);
+}
+
 static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 					unsigned long cr0,
 					struct kvm_vcpu *vcpu)
@@ -7643,6 +7650,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.is_valid_cr4 = vmx_is_valid_cr4,
 	.set_cr4 = vmx_set_cr4,
 	.control_cr3_intercept = vmx_control_cr3_intercept,
+	.cr3_write_intercepted = vmx_cr3_write_intercepted,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
