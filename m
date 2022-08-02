Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CF4587FFA
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbiHBQLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbiHBQL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:11:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8B8E4D4F0
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kXHvQ3PCkhHZj4Z5IK30a73EGXow1lQIQ2BqP5dMiU=;
        b=Kfis6r1BwzA5fCtmx4uMxNpNU06TEIAMYe/hTutV7DHUpbNGSZ9pc03vKDUiY08yRGWG1I
        aowHG45biY3lORRvJKcVHTlPO+/7btifkvzHkbriXQPpX/336Mi7Z0XYrADe7yRolvqCC6
        Vw374LcuaJJOjArYLatTXcgul74VjQQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-jHQYNgLxMbOnKBUGURHB-g-1; Tue, 02 Aug 2022 12:09:11 -0400
X-MC-Unique: jHQYNgLxMbOnKBUGURHB-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FD521029F75;
        Tue,  2 Aug 2022 16:09:10 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06B9A2166B26;
        Tue,  2 Aug 2022 16:09:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 25/26] KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
Date:   Tue,  2 Aug 2022 18:07:55 +0200
Message-Id: <20220802160756.339464-26-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like other host VMX control MSRs, MSR_IA32_VMX_MISC can be cached in
vmcs_config to avoid the need to re-read it later, e.g. from
cpu_has_vmx_intel_pt() or cpu_has_vmx_shadow_vmcs().

No (real) functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/capabilities.h | 11 +++--------
 arch/x86/kvm/vmx/vmx.c          |  8 +++++---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index faee1db8b0e0..87c4e46daf37 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -65,6 +65,7 @@ struct vmcs_config {
 	u64 cpu_based_3rd_exec_ctrl;
 	u32 vmexit_ctrl;
 	u32 vmentry_ctrl;
+	u64 misc;
 	struct nested_vmx_msrs nested;
 };
 extern struct vmcs_config vmcs_config;
@@ -225,11 +226,8 @@ static inline bool cpu_has_vmx_vmfunc(void)
 
 static inline bool cpu_has_vmx_shadow_vmcs(void)
 {
-	u64 vmx_msr;
-
 	/* check if the cpu supports writing r/o exit information fields */
-	rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
-	if (!(vmx_msr & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
+	if (!(vmcs_config.misc & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
 		return false;
 
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
@@ -371,10 +369,7 @@ static inline bool cpu_has_vmx_invvpid_global(void)
 
 static inline bool cpu_has_vmx_intel_pt(void)
 {
-	u64 vmx_msr;
-
-	rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
-	return (vmx_msr & MSR_IA32_VMX_MISC_INTEL_PT) &&
+	return (vmcs_config.misc & MSR_IA32_VMX_MISC_INTEL_PT) &&
 		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6461b03bad68..73bc6e18c2bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2557,6 +2557,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u64 misc_msr;
 	int i;
 
 	/*
@@ -2690,6 +2691,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (((vmx_msr_high >> 18) & 15) != 6)
 		return -EIO;
 
+	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
+
 	vmcs_conf->size = vmx_msr_high & 0x1fff;
 	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
 
@@ -2701,6 +2704,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
+	vmcs_conf->misc	= misc_msr;
 
 	return 0;
 }
@@ -8317,11 +8321,9 @@ static __init int hardware_setup(void)
 
 	if (enable_preemption_timer) {
 		u64 use_timer_freq = 5000ULL * 1000 * 1000;
-		u64 vmx_msr;
 
-		rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
 		cpu_preemption_timer_multi =
-			vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+			vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
 
 		if (tsc_khz)
 			use_timer_freq = (u64)tsc_khz * 1000;
-- 
2.35.3

