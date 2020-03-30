Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D891197936
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgC3KTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:52 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43732 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728788AbgC3KTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:49 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id EFFF93074838;
        Mon, 30 Mar 2020 13:12:51 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CE098305B7A1;
        Mon, 30 Mar 2020 13:12:51 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 21/81] KVM: x86: add .control_msr_intercept()
Date:   Mon, 30 Mar 2020 13:12:08 +0300
Message-Id: <20200330101308.21702-22-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed for the KVMI_EVENT_MSR event.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm.c              | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9ae0e0364caf..73c9fcd800f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1089,6 +1089,8 @@ struct kvm_x86_ops {
 	void (*update_bp_intercept)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
+	void (*control_msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable);
 	bool (*msr_write_intercepted)(struct kvm_vcpu *vcpu, u32 msr);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 37c78bb4ba0b..13360429986e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7510,6 +7510,16 @@ static inline bool svm_desc_intercepted(struct kvm_vcpu *vcpu)
 		get_intercept(svm, INTERCEPT_LOAD_TR));
 }
 
+static void svm_control_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable)
+{
+	const struct vcpu_svm *svm = to_svm(vcpu);
+	u32 *msrpm = is_guest_mode(vcpu) ? svm->nested.msrpm :
+					   svm->msrpm;
+
+	set_msr_interception(vcpu, msrpm, msr, type, !enable);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7541,6 +7551,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
+	.control_msr_intercept = svm_control_msr_intercept,
 	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = svm_get_segment_base,
 	.get_segment = svm_get_segment,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4dc6fbf91ca5..845bf6885ae0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7897,6 +7897,15 @@ static bool vmx_desc_intercepted(struct kvm_vcpu *vcpu)
 	return !!(secondary_exec_controls_get(vmx) & SECONDARY_EXEC_DESC);
 }
 
+static void vmx_control_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+
+	vmx_set_intercept_for_msr(vcpu, msr_bitmap, msr, type, enable);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7925,6 +7934,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
+	.control_msr_intercept = vmx_control_msr_intercept,
 	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
