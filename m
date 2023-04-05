Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C488C6D712E
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbjDEASi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbjDEASh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:18:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1323AA5
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:18:36 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5416d3a321eso341095407b3.12
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680653915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd7RpaVgSzjmUu7EdftLg4OZak25hQtH/XbM2nSwlrk=;
        b=o5Ah2Rs+6Sj2hIEHmizpgIH2KiADidsEOths3T4oiZq61BmAK9nJclSbDpiZVgjRgy
         pWFsB1OX6gBTt8RTP/rWjnqD3/Bs4bBk4G7LaKoe3cnmiOaKF1WfoMYjtGTLL60uLDX7
         gcXp3GnLVeoX8xAxExXa/qLfnNLggBWRRNkxzZAOc/G6jO8T4jl6R2OyMZ3NQNGC5GKd
         cDGw6OIIJgdQJDuSI5ZLo3Lu95JZsJuYNSmoTz+xpFGNj8UJUm9RJmIZsMQ2kZTVTEcP
         oKJRhvJGXXwNMmxLf81MRuVMr/oZ+VWDfx8FnAZMxVOvAstFwY53SEXLZVMK78Z83UBB
         m0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680653915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd7RpaVgSzjmUu7EdftLg4OZak25hQtH/XbM2nSwlrk=;
        b=mA2yajblbvv1sqg/lE7NWlyk3bexcKNd7iyQzWnn+JS9KJ5chWjLdATSYBxf9d0Re6
         cEMZOceYyhr84uGJ70NQXe0nv/4t0V+1SfKl8gKMqnkmhbQpXXnQiOQuouYJXLI11bvz
         HhVyFzZAuudfG59xxvH9GrlFbB3fP13nXra+xNW6ePM9aWL2vefsFyRVkGUZwk3XOwmA
         FvDnN2XNm/LwkCUvwj5ZvBWgFm+97wCYTqxoIFDRk1Des2ujfKO5Y/KGlHbUtQye90+A
         F17HAcmVECxx7A1O26y6j22sKi8NBDYF9nFxN/cKoiZROuAd6slxyrSfLFymNP8w8GnL
         olAw==
X-Gm-Message-State: AAQBX9dqoLqelH0JzEU0nUSfcX9oMJysMRPHgZbLMyHxjE6UyR/41vjv
        tYfDMJ5cRsqw7TamH9w4Y328LjlRG7M=
X-Google-Smtp-Source: AKy350bTaOC6PoGuVpNZy26GisoxCodW42F26uuKQvhqcPvQRa8MK5tznWkbfBdUmZVlEknPFXRcNk4oClo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:90b:b0:b81:a13:50c3 with SMTP id
 bu11-20020a056902090b00b00b810a1350c3mr733710ybb.2.1680653915688; Tue, 04 Apr
 2023 17:18:35 -0700 (PDT)
Date:   Tue, 4 Apr 2023 17:18:34 -0700
In-Reply-To: <20230330092149.101047-1-kai.huang@intel.com>
Mime-Version: 1.0
References: <20230330092149.101047-1-kai.huang@intel.com>
Message-ID: <ZCy+Wiehn9QYdgXR@google.com>
Subject: Re: [PATCH] KVM: VMX: Get rid of hard-coded value around IA32_VMX_BASIC
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023, Kai Huang wrote:
> Currently, setup_vmcs_config() uses hard-coded values when performing
> sanity check on the value of IA32_VMX_BASIC MSR and setting up the three
> members of 'vmcs_config': size, revison_id and basic_cap.  However, the
> kernel actually already has macro definitions for those relevant bits in
> asm/msr-index.h and functions to get revision_id and size in asm/vmx.h.
> 
> Add the missing helper function to get the basic_cap, and use those
> macros and helper functions in setup_vmcs_config() to get rid of those
> hard-coded values.
> 
> No functional change intended.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/include/asm/vmx.h |  5 +++++
>  arch/x86/kvm/vmx/vmx.c     | 17 +++++++++--------
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 498dc600bd5c..2b488895fe0e 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -141,6 +141,11 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
>  	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
>  }
>  
> +static inline u32 vmx_basic_cap(u64 vmx_basic)

I would omit this helper and just open code the ugliness, purely because what
it's tracking is completely random.

> +{
> +	return (vmx_basic & ~GENMASK_ULL(44, 32)) >> 32;
> +}
> +

...

>  #ifdef CONFIG_X86_64
>  	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
> -	if (vmx_msr_high & (1u<<16))
> +	if (basic_msr & VMX_BASIC_64)
>  		return -EIO;
>  #endif
>  
>  	/* Require Write-Back (WB) memory type for VMCS accesses. */
> -	if (((vmx_msr_high >> 18) & 15) != 6)
> +	if (((basic_msr & VMX_BASIC_MEM_TYPE_MASK) >> VMX_BASIC_MEM_TYPE_SHIFT)
> +			!= VMX_BASIC_MEM_TYPE_WB)

This one is worthy of a helper, e.g. 

	if (vmx_basic_vmcs_memtype(basic_msr) != VMX_BASIC_MEM_TYPE_WB)
		return -EIO;


>  		return -EIO;
>  
>  	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
>  
> -	vmcs_conf->size = vmx_msr_high & 0x1fff;
> -	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
> +	vmcs_conf->size = vmx_basic_vmcs_size(basic_msr);
> +	vmcs_conf->basic_cap = vmx_basic_cap(basic_msr);

Actually, looking at this more closely, splitting up the basic MSR during setup
is silly.  None of the usage is in hot paths, and cpu_has_vmx_basic_inout() is
downright bizarre with the current code.

Rather than do all of these weird dances, what about saving the full/raw MSR in
the config, and then using the helpers to extract info as needed?  E.g. the below
over a few patches.  As a bonus (maybe), KVM will sanity check the entire MSR
across CPUs.

---
 arch/x86/include/asm/vmx.h      |  5 +++++
 arch/x86/kvm/vmx/capabilities.h |  6 ++----
 arch/x86/kvm/vmx/vmx.c          | 22 +++++++++-------------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..b21dcd128add 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -141,6 +141,11 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
 	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
 }
 
+static inline u32 vmx_basic_vmcs_memtype(u64 vmx_basic)
+{
+	return (vmx_basic & VMX_BASIC_MEM_TYPE_MASK) >> VMX_BASIC_MEM_TYPE_SHIFT;
+}
+
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
 	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 45162c1bcd8f..d8849e42ca80 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -54,9 +54,7 @@ struct nested_vmx_msrs {
 };
 
 struct vmcs_config {
-	int size;
-	u32 basic_cap;
-	u32 revision_id;
+	u64 basic;
 	u32 pin_based_exec_ctrl;
 	u32 cpu_based_exec_ctrl;
 	u32 cpu_based_2nd_exec_ctrl;
@@ -76,7 +74,7 @@ extern struct vmx_capability vmx_capability __ro_after_init;
 
 static inline bool cpu_has_vmx_basic_inout(void)
 {
-	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
+	return vmcs_config.basic & VMX_BASIC_INOUT;
 }
 
 static inline bool cpu_has_virtual_nmis(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7bf14abdba1..64a43c2d72e9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2597,13 +2597,13 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			     struct vmx_capability *vmx_cap)
 {
-	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u64 basic_msr;
 	u64 misc_msr;
 	int i;
 
@@ -2722,29 +2722,25 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_vmexit_control &= ~x_ctrl;
 	}
 
-	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
+	rdmsrl(MSR_IA32_VMX_BASIC, basic_msr);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
-	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
+	if (vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE)
 		return -EIO;
 
 #ifdef CONFIG_X86_64
 	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
-	if (vmx_msr_high & (1u<<16))
+	if (basic_msr & VMX_BASIC_64)
 		return -EIO;
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != 6)
+	if (vmx_basic_vmcs_memtype(basic_msr) != VMX_BASIC_MEM_TYPE_WB)
 		return -EIO;
 
 	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
 
-	vmcs_conf->size = vmx_msr_high & 0x1fff;
-	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
-
-	vmcs_conf->revision_id = vmx_msr_low;
-
+	vmcs_conf->basic = basic_msr;
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
@@ -2883,13 +2879,13 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
-	memset(vmcs, 0, vmcs_config.size);
+	memset(vmcs, 0, vmx_basic_vmcs_size(vmcs_config.basic));
 
 	/* KVM supports Enlightened VMCS v1 only */
 	if (kvm_is_using_evmcs())
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
-		vmcs->hdr.revision_id = vmcs_config.revision_id;
+		vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
 
 	if (shadow)
 		vmcs->hdr.shadow_vmcs = 1;
@@ -2982,7 +2978,7 @@ static __init int alloc_kvm_area(void)
 		 * physical CPU.
 		 */
 		if (kvm_is_using_evmcs())
-			vmcs->hdr.revision_id = vmcs_config.revision_id;
+			vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
 
 		per_cpu(vmxarea, cpu) = vmcs;
 	}

base-commit: f6cde92083dec5cf424504d7029acdffbe5beed8
-- 

