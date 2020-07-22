Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF86229C7F
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgGVQBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:35 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37848 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727778AbgGVQBe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:34 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 03FBB305D7D1;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E967F3072787;
        Wed, 22 Jul 2020 19:01:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 03/34] KVM: x86: add kvm_get_ept_view()
Date:   Wed, 22 Jul 2020 19:00:50 +0300
Message-Id: <20200722160121.9601-4-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

This function returns the EPT view of the current vCPU
or 0 if the hardware support is missing.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/vmx/vmx.c          |  8 ++++++++
 arch/x86/kvm/vmx/vmx.h          |  3 +++
 arch/x86/kvm/x86.c              | 10 ++++++++++
 4 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5eb26135e81b..0acc21087caf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1302,6 +1302,7 @@ struct kvm_x86_ops {
 	void (*control_singlestep)(struct kvm_vcpu *vcpu, bool enable);
 	bool (*get_vmfunc_status)(void);
 	bool (*get_eptp_switching_status)(void);
+	u16 (*get_ept_view)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
@@ -1773,4 +1774,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define GET_SMSTATE(type, buf, offset)		\
 	(*(type *)((buf) + (offset) - 0x7e00))
 
+u16 kvm_get_ept_view(struct kvm_vcpu *vcpu);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ccbf561b0fc4..0256c3a93c87 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8002,6 +8002,13 @@ static bool vmx_get_eptp_switching_status(void)
 	return kvm_eptp_switching_supported;
 }
 
+static u16 vmx_get_ept_view(struct kvm_vcpu *vcpu)
+{
+	const struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return vmx->view;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -8145,6 +8152,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.control_singlestep = vmx_control_singlestep,
 	.get_vmfunc_status = vmx_get_vmfunc_status,
 	.get_eptp_switching_status = vmx_get_eptp_switching_status,
+	.get_ept_view = vmx_get_ept_view,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index aa0c7ffd588b..14f0b9102d58 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -296,6 +296,9 @@ struct vcpu_vmx {
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
+
+	/* The view this vcpu operates on. */
+	u16 view;
 };
 
 enum ept_pointers_status {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b16b018c74cc..2e2c56a37bdb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10869,6 +10869,16 @@ u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
+u16 kvm_get_ept_view(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_x86_ops.get_ept_view)
+		return 0;
+
+	return kvm_x86_ops.get_ept_view(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_get_ept_view);
+
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
