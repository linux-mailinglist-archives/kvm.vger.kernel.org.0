Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C7855512C
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376420AbiFVQTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 12:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357785AbiFVQTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 12:19:51 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A1DF377CD;
        Wed, 22 Jun 2022 09:19:50 -0700 (PDT)
Received: from anrayabh-desk (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0052420C5A6B;
        Wed, 22 Jun 2022 09:19:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0052420C5A6B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655914790;
        bh=QyM2DYaybCkPPWyyb3Q8kmflv5XZZucB3whsOcU0eqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KWhH0+nWRrf9uLKyqLX1yYWJx/qT696XIYu18PtMfS9d7ada3oBSeFhw6RGs+kANB
         l9kS6up53vzpL8nWgzMRH0xO8fRk7cPV/W1blKh1LCFrbyMJaq5/VssqcTOW7J3/0x
         sNFb2L+5O5yBWigzVk7bWeeZueFRJdSZXsVhRItw=
Date:   Wed, 22 Jun 2022 21:49:40 +0530
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Message-ID: <YrNBHFLzAgcsw19O@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqdsjW4/zsYaJahf@google.com>
 <YqipLpHI24NdhgJO@anrayabh-desk>
 <YqiwoOP4HX2LniI4@google.com>
 <87zgi5xh42.fsf@redhat.com>
 <YrMenI1mTbqA9MaR@anrayabh-desk>
 <87r13gyde8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r13gyde8.fsf@redhat.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 04:35:27PM +0200, Vitaly Kuznetsov wrote:
> Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:
> 
> > On Wed, Jun 22, 2022 at 10:00:29AM +0200, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> 
> >> > On Tue, Jun 14, 2022, Anirudh Rayabharam wrote:
> >> >> On Mon, Jun 13, 2022 at 04:57:49PM +0000, Sean Christopherson wrote:
> >> 
> >> ...
> >> 
> >> >> > 
> >> >> > Any reason not to use the already sanitized vmcs_config?  I can't think of any
> >> >> > reason why the nested path should blindly use the raw MSR values from hardware.
> >> >> 
> >> >> vmcs_config has the sanitized exec controls. But how do we construct MSR
> >> >> values using them?
> >> >
> >> > I was thinking we could use the sanitized controls for the allowed-1 bits, and then
> >> > take the required-1 bits from the CPU.  And then if we wanted to avoid the redundant
> >> > RDMSRs in a follow-up patch we could add required-1 fields to vmcs_config.
> >> >
> >> > Hastily constructed and compile-tested only, proceed with caution :-)
> >> 
> >> Independently from "[PATCH 00/11] KVM: VMX: Support TscScaling and
> >> EnclsExitingBitmap whith eVMCS" which is supposed to fix the particular
> >> TSC scaling issue, I like the idea to make nested_vmx_setup_ctls_msrs()
> >> use both allowed-1 and required-1 bits from vmcs_config. I'll pick up
> >> the suggested patch and try to construct something for required-1 bits.
> >
> > I tried this patch today but it causes some regression which causes
> > /dev/kvm to be unavailable in L1. I didn't get a chance to look into it
> > closely but I am guessing it has something to do with the fact that
> > vmcs_config reflects the config that L0 chose to use rather than what is
> > available to use. So constructing allowed-1 MSR bits based on what bits
> > are set in exec controls maybe isn't correct.
> 
> I've tried to pick it up but it's actually much harder than I think. The
> patch has some minor issues ('&vmcs_config.nested' needs to be switched
> to '&vmcs_conf->nested' in nested_vmx_setup_ctls_msrs()), but the main
> problem is that the set of controls nested_vmx_setup_ctls_msrs() needs
> is NOT a subset of vmcs_config (setup_vmcs_config()). I was able to
> identify at least:
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5e14e4c40007..8076352174ad 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2483,8 +2483,14 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>               CPU_BASED_INVLPG_EXITING |
>               CPU_BASED_RDPMC_EXITING;
>  
> -       opt = CPU_BASED_TPR_SHADOW |
> +       opt = CPU_BASED_INTR_WINDOW_EXITING |
> +             CPU_BASED_NMI_WINDOW_EXITING |
> +             CPU_BASED_TPR_SHADOW |
> +             CPU_BASED_USE_IO_BITMAPS |
>               CPU_BASED_USE_MSR_BITMAPS |
> +             CPU_BASED_MONITOR_TRAP_FLAG |
> +             CPU_BASED_RDTSC_EXITING |
> +             CPU_BASED_PAUSE_EXITING |
>               CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
>               CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
>         if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
> @@ -2582,6 +2588,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  #endif
>         opt = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>               VM_EXIT_LOAD_IA32_PAT |
> +             VM_EXIT_SAVE_IA32_PAT |
>               VM_EXIT_LOAD_IA32_EFER |
>               VM_EXIT_CLEAR_BNDCFGS |
>               VM_EXIT_PT_CONCEAL_PIP |
> @@ -2604,7 +2611,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>                 _pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
>  
>         min = VM_ENTRY_LOAD_DEBUG_CONTROLS;
> -       opt = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
> +       opt =
> +#ifdef CONFIG_X86_64
> +             VM_ENTRY_IA32E_MODE |
> +#endif
> +             VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
>               VM_ENTRY_LOAD_IA32_PAT |
>               VM_ENTRY_LOAD_IA32_EFER |
>               VM_ENTRY_LOAD_BNDCFGS |
> 
> but it is 1) not sufficient because some controls are smartly filtered
> out just because we don't want them for L1 -- and this doesn't mean that
> L2 doesn't need them and 2) because if we add some 'opt' controls to
> setup_vmcs_config() we need to filter them out somewhere else.
> 
> I'm starting to think we may just want to store raw VMX MSR values in
> vmcs_config first, then sanitize them (eVMCS, vmx preemtoion timer bug,
> perf_ctrl bug,..) and then do the adjust_vmx_controls() magic. 
> 
> I'm not giving up yet but don't expect something small and backportable
> to stable :-) 

How about we do something simple like the patch below to start with?
This will easily apply to stable and we can continue improving upon
it with follow up patches on mainline.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5cb18e00e78..f88d748c7cc6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6564,6 +6564,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		msrs->pinbased_ctls_high);
 	msrs->pinbased_ctls_low |=
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs))
+		msrs->pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
+#endif
 	msrs->pinbased_ctls_high &=
 		PIN_BASED_EXT_INTR_MASK |
 		PIN_BASED_NMI_EXITING |
@@ -6580,6 +6584,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->exit_ctls_low =
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs))
+		msrs->exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+#endif
 	msrs->exit_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
@@ -6600,6 +6608,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		msrs->entry_ctls_high);
 	msrs->entry_ctls_low =
 		VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs))
+		msrs->entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+#endif
 	msrs->entry_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
@@ -6657,6 +6669,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		      msrs->secondary_ctls_high);
 
 	msrs->secondary_ctls_low = 0;
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs))
+		msrs->secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+#endif
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
 		SECONDARY_EXEC_ENABLE_RDTSCP |

