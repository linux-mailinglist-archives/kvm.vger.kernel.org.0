Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5903B1978CD
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgC3KUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:05 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43780 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729640AbgC3KUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:04 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1D05F30747C7;
        Mon, 30 Mar 2020 13:12:50 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E3C44305B7A2;
        Mon, 30 Mar 2020 13:12:49 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 10/81] KVM: x86: add .bp_intercepted() to struct kvm_x86_ops
Date:   Mon, 30 Mar 2020 13:11:57 +0300
Message-Id: <20200330101308.21702-11-alazar@bitdefender.com>
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

The introspection tool and the userspace can request #BP interception.
This function will be used to check if this interception is enabled
by either side.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 15 +++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  6 ++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 98959e8cd448..afc5bf3fa730 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1077,6 +1077,7 @@ struct kvm_x86_ops {
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
+	bool (*bp_intercepted)(struct kvm_vcpu *vcpu);
 	void (*update_bp_intercept)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 50d1ebafe0b3..73871f28ad7b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -611,6 +611,13 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
+static inline bool get_exception_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	return (vmcb->control.intercept_exceptions & (1U << bit));
+}
+
 static inline void set_intercept(struct vcpu_svm *svm, int bit)
 {
 	struct vmcb *vmcb = get_host_vmcb(svm);
@@ -7393,6 +7400,13 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
 	avic_update_access_page(kvm, activate);
 }
 
+static inline bool svm_bp_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return get_exception_intercept(svm, BP_VECTOR);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7419,6 +7433,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.vcpu_blocking = svm_vcpu_blocking,
 	.vcpu_unblocking = svm_vcpu_unblocking,
 
+	.bp_intercepted = svm_bp_intercepted,
 	.update_bp_intercept = update_bp_intercept,
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 079d9fbf278e..eee8d81f7083 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7849,6 +7849,11 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static bool vmx_bp_intercepted(struct kvm_vcpu *vcpu)
+{
+	return (vmcs_read32(EXCEPTION_BITMAP) & (1u << BP_VECTOR));
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7872,6 +7877,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
+	.bp_intercepted = vmx_bp_intercepted,
 	.update_bp_intercept = update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
