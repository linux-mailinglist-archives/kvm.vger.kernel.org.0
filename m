Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF40602918
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 12:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJRKKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 06:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJRKKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 06:10:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A0D6CF6F
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 03:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666087814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9Jck7KUtqojsImURvcQHqLduKuZ3IugcOkTqhUz1cU=;
        b=AIcR5hM63Y4552qXb+K4Kd6L2Ztgkw2xBIfvvWFBA5pVli0pQrel18mp/ajWMnyvUmD3Rk
        XQn0MSG+doc8NZYdRyIpUJSmd+QSnDvdqHH3I4cHMYVsPsHBlx8x6p+dtjGGLBX2dyWNPb
        fcU1by9js3lCNvERCEsGbtR0xDRfQqY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-Neg-AG1KPiqrP7xjefF7Fw-1; Tue, 18 Oct 2022 06:10:11 -0400
X-MC-Unique: Neg-AG1KPiqrP7xjefF7Fw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99B1C185A7AC;
        Tue, 18 Oct 2022 10:10:10 +0000 (UTC)
Received: from ovpn-193-156.brq.redhat.com (ovpn-193-156.brq.redhat.com [10.40.193.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EFB040C94AA;
        Tue, 18 Oct 2022 10:10:08 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: VMX: Resurrect vmcs_conf sanitization for KVM-on-Hyper-V
Date:   Tue, 18 Oct 2022 12:10:00 +0200
Message-Id: <20221018101000.934413-5-vkuznets@redhat.com>
In-Reply-To: <20221018101000.934413-1-vkuznets@redhat.com>
References: <20221018101000.934413-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 9bcb90650e31 ("KVM: VMX: Get rid of eVMCS specific VMX controls
sanitization") dropped 'vmcs_conf' sanitization for KVM-on-Hyper-V because
there's no known Hyper-V version which would expose a feature
unsupported in eVMCS in VMX feature MSRs. This works well for all
currently existing Hyper-V version, however, future Hyper-V versions
may add features which are supported by KVM and are currently missing
in eVMCSv1 definition (e.g. APIC virtualization, PML,...). When this
happens, existing KVMs will get broken. With the inverted 'unsupported
by eVMCSv1' checks, we can resurrect vmcs_conf sanitization and make
KVM future proof.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 80 +++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/evmcs.h |  1 +
 arch/x86/kvm/vmx/vmx.c   |  5 +++
 3 files changed, 76 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 47f6d1cbd428..89d7b9537ada 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#define pr_fmt(fmt) "kvm/hyper-v: " fmt
+
 #include <linux/errno.h>
 #include <linux/smp.h>
 
@@ -362,6 +364,7 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 
 enum evmcs_revision {
 	EVMCSv1_LEGACY,
+	EVMCSv1_STRICT,
 	NR_EVMCS_REVISIONS,
 };
 
@@ -379,31 +382,36 @@ enum evmcs_ctrl_type {
 static const u32 evmcs_supported_ctrls[NR_EVMCS_CTRLS][NR_EVMCS_REVISIONS] = {
 	[EVMCS_EXIT_CTRLS] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_VMEXIT_CTRL,
+		[EVMCSv1_STRICT] = EVMCS1_SUPPORTED_VMEXIT_CTRL,
 	},
 	[EVMCS_ENTRY_CTRLS] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_VMENTRY_CTRL,
+		[EVMCSv1_STRICT] = EVMCS1_SUPPORTED_VMENTRY_CTRL,
 	},
 	[EVMCS_EXEC_CTRL] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_EXEC_CTRL,
+		[EVMCSv1_STRICT] = EVMCS1_SUPPORTED_EXEC_CTRL,
 	},
 	[EVMCS_2NDEXEC] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_2NDEXEC & ~SECONDARY_EXEC_TSC_SCALING,
+		[EVMCSv1_STRICT] = EVMCS1_SUPPORTED_2NDEXEC,
 	},
 	[EVMCS_3RDEXEC] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_3RDEXEC,
 	},
 	[EVMCS_PINCTRL] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_PINCTRL,
+		[EVMCSv1_STRICT] = EVMCS1_SUPPORTED_PINCTRL,
 	},
 	[EVMCS_VMFUNC] = {
 		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_VMFUNC,
+		[EVMCSv1_STRICT] = EVMCS1_SUPPORTED_VMFUNC,
 	},
 };
 
-static u32 evmcs_get_supported_ctls(enum evmcs_ctrl_type ctrl_type)
+static u32 evmcs_get_supported_ctls(enum evmcs_ctrl_type ctrl_type,
+				    enum evmcs_revision evmcs_rev)
 {
-	enum evmcs_revision evmcs_rev = EVMCSv1_LEGACY;
-
 	return evmcs_supported_ctrls[ctrl_type][evmcs_rev];
 }
 
@@ -437,31 +445,37 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		supported_ctrls = evmcs_get_supported_ctls(EVMCS_EXIT_CTRLS);
+		supported_ctrls = evmcs_get_supported_ctls(EVMCS_EXIT_CTRLS,
+							   EVMCSv1_LEGACY);
 		if (!evmcs_has_perf_global_ctrl(vcpu))
 			supported_ctrls &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
 		ctl_high &= supported_ctrls;
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		supported_ctrls = evmcs_get_supported_ctls(EVMCS_ENTRY_CTRLS);
+		supported_ctrls = evmcs_get_supported_ctls(EVMCS_ENTRY_CTRLS,
+							   EVMCSv1_LEGACY);
 		if (!evmcs_has_perf_global_ctrl(vcpu))
 			supported_ctrls &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 		ctl_high &= supported_ctrls;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS:
 	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
-		ctl_high &= evmcs_get_supported_ctls(EVMCS_EXEC_CTRL);
+		ctl_high &= evmcs_get_supported_ctls(EVMCS_EXEC_CTRL,
+						     EVMCSv1_LEGACY);
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= evmcs_get_supported_ctls(EVMCS_2NDEXEC);
+		ctl_high &= evmcs_get_supported_ctls(EVMCS_2NDEXEC,
+						     EVMCSv1_LEGACY);
 		break;
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
-		ctl_high &= evmcs_get_supported_ctls(EVMCS_PINCTRL);
+		ctl_high &= evmcs_get_supported_ctls(EVMCS_PINCTRL,
+						     EVMCSv1_LEGACY);
 		break;
 	case MSR_IA32_VMX_VMFUNC:
-		ctl_low &= evmcs_get_supported_ctls(EVMCS_VMFUNC);
+		ctl_low &= evmcs_get_supported_ctls(EVMCS_VMFUNC,
+						    EVMCSv1_LEGACY);
 		break;
 	}
 
@@ -471,7 +485,7 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 static bool nested_evmcs_is_valid_controls(enum evmcs_ctrl_type ctrl_type,
 					   u32 val)
 {
-	return !(val & ~evmcs_get_supported_ctls(ctrl_type));
+	return !(val & ~evmcs_get_supported_ctls(ctrl_type, EVMCSv1_LEGACY));
 }
 
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
@@ -511,6 +525,52 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_HYPERV)
+/*
+ * KVM on Hyper-V always uses the newest known eVMCSv1 revision, the assumption
+ * is: in case a feature has corresponding fields in eVMCS described and it was
+ * exposed in VMX feature MSRs, KVM is free to use it. Warn if KVM meets a
+ * feature which has no corresponding eVMCS field, this likely means that KVM
+ * needs to be updated.
+ */
+#define evmcs_check_vmcs_conf32(field, ctrl)					\
+	{									\
+		u32 supported, unsupported32;					\
+										\
+		supported = evmcs_get_supported_ctls(ctrl, EVMCSv1_STRICT);	\
+		unsupported32 = vmcs_conf->field & ~supported;			\
+		if (unsupported32) {						\
+			pr_warn_once(#field " unsupported with eVMCS: 0x%x\n",	\
+				     unsupported32);				\
+			vmcs_conf->field &= supported;				\
+		}								\
+	}
+
+#define evmcs_check_vmcs_conf64(field, ctrl)					\
+	{									\
+		u32 supported;							\
+		u64 unsupported64;						\
+										\
+		supported = evmcs_get_supported_ctls(ctrl, EVMCSv1_STRICT);	\
+		unsupported64 = vmcs_conf->field & ~supported;			\
+		if (unsupported64) {						\
+			pr_warn_once(#field " unsupported with eVMCS: 0x%llx\n",\
+				     unsupported64);				\
+			vmcs_conf->field &= supported;				\
+		}								\
+	}
+
+__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
+{
+	evmcs_check_vmcs_conf32(cpu_based_exec_ctrl, EVMCS_EXEC_CTRL);
+	evmcs_check_vmcs_conf32(pin_based_exec_ctrl, EVMCS_PINCTRL);
+	evmcs_check_vmcs_conf32(cpu_based_2nd_exec_ctrl, EVMCS_2NDEXEC);
+	evmcs_check_vmcs_conf64(cpu_based_3rd_exec_ctrl, EVMCS_3RDEXEC);
+	evmcs_check_vmcs_conf32(vmentry_ctrl, EVMCS_ENTRY_CTRLS);
+	evmcs_check_vmcs_conf32(vmexit_ctrl, EVMCS_EXIT_CTRLS);
+}
+#endif
+
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version)
 {
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 205b5b467617..300e50d52042 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -271,6 +271,7 @@ static inline void evmcs_load(u64 phys_addr)
 	vp_ap->enlighten_vmentry = 1;
 }
 
+__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
 static inline void evmcs_write32(unsigned long field, u32 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..7fd21b1fae1d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2720,6 +2720,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 	vmcs_conf->misc	= misc_msr;
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (enlightened_vmcs)
+		evmcs_sanitize_exec_ctrls(vmcs_conf);
+#endif
+
 	return 0;
 }
 
-- 
2.37.3

