Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6AF228AD7
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgGUVR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:27 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37794 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731291AbgGUVQI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:08 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2339F305D769;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 062E5304FA13;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 20/84] KVM: x86: add .control_msr_intercept()
Date:   Wed, 22 Jul 2020 00:08:18 +0300
Message-Id: <20200721210922.7646-21-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This is needed for the KVMI_EVENT_MSR event, which is used notify the
introspection tool about any change made to a MSR of interest.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/svm.c          | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a3230ab377db..f04a01dac423 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1110,6 +1110,8 @@ struct kvm_x86_ops {
 	void (*update_bp_intercept)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
+	void (*control_msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
+				      int type, bool enable);
 	bool (*msr_write_intercepted)(struct kvm_vcpu *vcpu, u32 msr);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
 	void (*get_segment)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dfa1a6e74bf7..9c8e77193f98 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -612,6 +612,16 @@ static void set_msr_interception(struct kvm_vcpu *vcpu,
 	msrpm[offset] = tmp;
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
 static void svm_vcpu_init_msrpm(u32 *msrpm)
 {
 	int i;
@@ -4096,6 +4106,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_msr_feature = svm_get_msr_feature,
 	.get_msr = svm_get_msr,
 	.set_msr = svm_set_msr,
+	.control_msr_intercept = svm_control_msr_intercept,
 	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = svm_get_segment_base,
 	.get_segment = svm_get_segment,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ecf7fb21b812..fed661eb65a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3822,6 +3822,15 @@ static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 		vmx_disable_intercept_for_msr(vcpu, msr_bitmap, msr, type);
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
 static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 {
 	u8 mode = 0;
@@ -7916,6 +7925,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
+	.control_msr_intercept = vmx_control_msr_intercept,
 	.msr_write_intercepted = msr_write_intercepted,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
