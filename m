Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240E2229CBB
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbgGVQC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:27 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37840 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbgGVQBf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:35 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id ECA03305D7D0;
        Wed, 22 Jul 2020 19:01:31 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E12943072786;
        Wed, 22 Jul 2020 19:01:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 02/34] KVM: x86: export .get_eptp_switching_status()
Date:   Wed, 22 Jul 2020 19:00:49 +0300
Message-Id: <20200722160121.9601-3-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marian Rotariu <marian.c.rotariu@gmail.com>

The introspection tool uses this function to check the hardware support
for EPT switching, which can be used either to singlestep vCPUs
on a unprotected EPT view or to use #VE in order to avoid filter out
VM-exits caused by EPT violations.

Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/vmx/capabilities.h | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 arch/x86/kvm/x86.c              | 3 +++
 4 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ab6989745f9c..5eb26135e81b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1301,6 +1301,7 @@ struct kvm_x86_ops {
 	bool (*gpt_translation_fault)(struct kvm_vcpu *vcpu);
 	void (*control_singlestep)(struct kvm_vcpu *vcpu, bool enable);
 	bool (*get_vmfunc_status)(void);
+	bool (*get_eptp_switching_status)(void);
 };
 
 struct kvm_x86_nested_ops {
@@ -1422,6 +1423,7 @@ extern u64  kvm_max_tsc_scaling_ratio;
 extern u64  kvm_default_tsc_scaling_ratio;
 
 extern u64 kvm_mce_cap_supported;
+extern bool kvm_eptp_switching_supported;
 
 /*
  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index e7d7fcb7e17f..92781e2c523e 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -219,6 +219,14 @@ static inline bool cpu_has_vmx_vmfunc(void)
 		SECONDARY_EXEC_ENABLE_VMFUNC;
 }
 
+static inline bool cpu_has_vmx_eptp_switching(void)
+{
+	u64 vmx_msr;
+
+	rdmsrl(MSR_IA32_VMX_VMFUNC, vmx_msr);
+	return vmx_msr & VMX_VMFUNC_EPTP_SWITCHING;
+}
+
 static inline bool cpu_has_vmx_shadow_vmcs(void)
 {
 	u64 vmx_msr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ec4396d5f36f..ccbf561b0fc4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7997,6 +7997,11 @@ static bool vmx_get_vmfunc_status(void)
 	return cpu_has_vmx_vmfunc();
 }
 
+static bool vmx_get_eptp_switching_status(void)
+{
+	return kvm_eptp_switching_supported;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -8139,6 +8144,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.gpt_translation_fault = vmx_gpt_translation_fault,
 	.control_singlestep = vmx_control_singlestep,
 	.get_vmfunc_status = vmx_get_vmfunc_status,
+	.get_eptp_switching_status = vmx_get_eptp_switching_status,
 };
 
 static __init int hardware_setup(void)
@@ -8178,6 +8184,8 @@ static __init int hardware_setup(void)
 	    !cpu_has_vmx_invept_global())
 		enable_ept = 0;
 
+	kvm_eptp_switching_supported = cpu_has_vmx_eptp_switching();
+
 	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
 		enable_ept_ad_bits = 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index feb20b29bb92..b16b018c74cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -161,6 +161,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+bool __read_mostly kvm_eptp_switching_supported;
+EXPORT_SYMBOL_GPL(kvm_eptp_switching_supported);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
