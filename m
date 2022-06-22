Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9391E55518E
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 18:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376754AbiFVQpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 12:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376640AbiFVQpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 12:45:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CD363915D
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 09:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655916300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5VvNXqHl0oOGZeRIwHa6ZjCr17no+OrzJZwyqt7fqv4=;
        b=b+dI3o2UWY/dAqx3o5Ejtq/71X+r3cTtj9QStPPx2qDHR+qE0aubWHxmiY2VWbZ2WVq7DQ
        YcLdJ2VKW97Z5FjST42Ayh43gqdNg6CpsKr2KW/1ID0M0ry+yoTVkUyLtzACtbCWURYtdv
        tRy86CP/Jg8Bb6zXfNn4TlsZahsF9jU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-8zpEM2pXPjOH3EZCpPgrwQ-1; Wed, 22 Jun 2022 12:44:57 -0400
X-MC-Unique: 8zpEM2pXPjOH3EZCpPgrwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEEE785A584;
        Wed, 22 Jun 2022 16:44:56 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 687C240CFD0A;
        Wed, 22 Jun 2022 16:44:54 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 09/10] KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
Date:   Wed, 22 Jun 2022 18:44:31 +0200
Message-Id: <20220622164432.194640-10-vkuznets@redhat.com>
In-Reply-To: <20220622164432.194640-1-vkuznets@redhat.com>
References: <20220622164432.194640-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/capabilities.h | 11 +++--------
 arch/x86/kvm/vmx/vmx.c          |  8 +++++---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 2e223440e7ed..9a73087c8314 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -70,6 +70,7 @@ struct vmcs_config {
 	u32 vmexit_ctrl_req1;
 	u32 vmentry_ctrl;
 	u32 vmentry_ctrl_req1;
+	u64 misc;
 	struct nested_vmx_msrs nested;
 };
 extern struct vmcs_config vmcs_config;
@@ -229,11 +230,8 @@ static inline bool cpu_has_vmx_vmfunc(void)
 
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
@@ -375,10 +373,7 @@ static inline bool cpu_has_vmx_invvpid_global(void)
 
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
index 05a9919a2fec..9d1896184729 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2455,6 +2455,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _cpu_based_2nd_exec_control_low = 0;
 	u32 _vmexit_control_low = 0;
 	u32 _vmentry_control_low = 0;
+	u64 misc_msr;
 	int i;
 
 	/*
@@ -2687,6 +2688,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (((vmx_msr_high >> 18) & 15) != 6)
 		return -EIO;
 
+	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
+
 	vmcs_conf->size = vmx_msr_high & 0x1fff;
 	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
 
@@ -2703,6 +2706,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->vmexit_ctrl_req1         = _vmexit_control_low;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 	vmcs_conf->vmentry_ctrl_req1        = _vmentry_control_low;
+	vmcs_conf->misc 		= misc_msr;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (enlightened_vmcs)
@@ -8305,11 +8309,9 @@ static __init int hardware_setup(void)
 
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

