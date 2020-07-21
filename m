Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA23228ADE
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731496AbgGUVRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:45 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37986 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731273AbgGUVQF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:05 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 63DE6305D7F1;
        Wed, 22 Jul 2020 00:09:20 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3ACCC308C48E;
        Wed, 22 Jul 2020 00:09:20 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 11/84] KVM: x86: add .cr3_write_intercepted()
Date:   Wed, 22 Jul 2020 00:08:09 +0300
Message-Id: <20200721210922.7646-12-alazar@bitdefender.com>
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

This function will be used to allow the introspection tool to disable the
CR3-write interception when it is no longer interested in these events,
but only if nothing else depends on these VM-exits.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/svm.c          | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 89c0bd6529a5..ac45aacc9fc0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1117,6 +1117,7 @@ struct kvm_x86_ops {
 	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*control_cr3_intercept)(struct kvm_vcpu *vcpu, int type,
 				      bool enable);
+	bool (*cr3_write_intercepted)(struct kvm_vcpu *vcpu);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f14fc940538b..7a4ec6fbffb9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1609,6 +1609,13 @@ static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 			 clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
 }
 
+static bool svm_cr3_write_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return is_cr_intercept(svm, INTERCEPT_CR3_WRITE);
+}
+
 static void svm_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
@@ -4022,6 +4029,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_cr0 = svm_set_cr0,
 	.set_cr4 = svm_set_cr4,
 	.control_cr3_intercept = svm_control_cr3_intercept,
+	.cr3_write_intercepted = svm_cr3_write_intercepted,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
 	.set_idt = svm_set_idt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b9639703560..61eb64cf25c7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3020,6 +3020,13 @@ static void vmx_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
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
@@ -7890,6 +7897,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_cr0 = vmx_set_cr0,
 	.set_cr4 = vmx_set_cr4,
 	.control_cr3_intercept = vmx_control_cr3_intercept,
+	.cr3_write_intercepted = vmx_cr3_write_intercepted,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
