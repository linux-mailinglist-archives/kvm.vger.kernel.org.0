Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F9A2C3C80
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgKYJmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:00 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57134 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728077AbgKYJl7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:59 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9B3EB305D503;
        Wed, 25 Nov 2020 11:35:45 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 78DE63072785;
        Wed, 25 Nov 2020 11:35:45 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 17/81] KVM: x86: add kvm_x86_ops.control_msr_intercept()
Date:   Wed, 25 Nov 2020 11:34:56 +0200
Message-Id: <20201125093600.2766-18-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed for the KVMI_VCPU_EVENT_MSR event, which is used notify
the introspection tool about any change made to a MSR of interest.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/svm.c          | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c          |  7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8586c9f4feba..01853453a659 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1116,6 +1116,8 @@ struct kvm_x86_ops {
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
+	void (*control_msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable);
 	bool (*msr_write_intercepted)(struct kvm_vcpu *vcpu, u32 msr);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8d662ccf5b62..2bfefcfbddd7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -677,6 +677,16 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 	set_msr_interception_bitmap(vcpu, msrpm, msr, type, value);
 }
 
+static void svm_control_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable)
+{
+	const struct vcpu_svm *svm = to_svm(vcpu);
+	u32 *msrpm = is_guest_mode(vcpu) ? svm->nested.msrpm :
+					   svm->msrpm;
+
+	set_msr_interception(vcpu, msrpm, msr, type, enable);
+}
+
 u32 *svm_vcpu_alloc_msrpm(void)
 {
 	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
@@ -4328,6 +4338,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
+	.control_msr_intercept = svm_control_msr_intercept,
 	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = svm_get_segment_base,
 	.get_segment = svm_get_segment,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4833d3bf966..c1497b8e506c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3826,6 +3826,12 @@ static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 		vmx_disable_intercept_for_msr(vcpu, msr, type);
 }
 
+static void vmx_control_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable)
+{
+	vmx_set_intercept_for_msr(vcpu, msr, type, enable);
+}
+
 static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 {
 	u8 mode = 0;
@@ -7658,6 +7664,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
+	.control_msr_intercept = vmx_control_msr_intercept,
 	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
