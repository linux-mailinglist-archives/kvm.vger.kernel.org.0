Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9782F57D720
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 00:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiGUW4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 18:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiGUW4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 18:56:31 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F948D5FE
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:56:29 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r186so2986883pgr.2
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GCuzPWEu7otLZxcKOxiOTjBEcbCLykrIMf22tVoEcgM=;
        b=ab4pIG/1tZZgSRaUxBAOJ/jiYodQ+Gh6U3ACDG2etAD/KJJSUWvWRs5RnTjKfeSt2N
         JTvh9v+li6lkk7IM0q3ABDJcMLke0SCe3Mkn6YOVbhbv9MP+S38lh+oLAQ1q9meKML75
         iDfocEvd9+qMfqbb1Kgc/Fw3f2x6dXN19NsHdUbEPgvTRoGJqCLBC2QkRBzE8nGLj+Fz
         lh3amcj1fGSgfino0/bhsb9HdWomZsoffm1F3dseyEatvt5Bvo+owz2Kw621yKKhNLvv
         0WPcpc48tqT0ILld9JZ/J/KiXJ0HyirbL6G/5K/rsajDw5/WneeGdiIkoKda6R1tHp+Y
         y7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GCuzPWEu7otLZxcKOxiOTjBEcbCLykrIMf22tVoEcgM=;
        b=M48Ei+Qj9NixCNge1lwddJxONE/6UfyxnQyNYqLZc+senVX7SLlhQUYXpImY/uR1Tb
         d6mzuEWGy9JaaL6vHeqjEhkXm3H1Om1pfhLRjOsF6LJSzLpRnqydjWhaLzi30TRZ3j6U
         czw5EOywRrTPdpSxq1n12jS4xA2uWnowulQqoJEAdwdpFpZGl72dgl6RAR2WuEVa737t
         aDDAU5dxWO4hxwPr62V9TaC3g/W/DBUP4rglpz5PsafgHYu9zPyCrNKPjWLqvqlwVwr2
         vKu76JWGO1XDVBdog696O3kQMhlrqJmkj3LnO0LR9d+Cw3kowRlJFcI+xv/usXotXJrI
         7eVg==
X-Gm-Message-State: AJIora+pjkMOgCM0EZCqT2kVoURBYVitAth0/hlsxf0cX5W25ebYmOXm
        NqWk6wSWW9r34aN34k8glPZjkQ==
X-Google-Smtp-Source: AGRyM1tvNyeeZFqJhLpPd5lMh8DRK3xHx7b1vhl4Hxah1uSc3wgMlOg9y3iWj7F08zMuW3Cz2sDd1A==
X-Received: by 2002:a63:8a41:0:b0:41a:4abd:5c98 with SMTP id y62-20020a638a41000000b0041a4abd5c98mr568303pgd.292.1658444189250;
        Thu, 21 Jul 2022 15:56:29 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090301c700b0016bf2dc1724sm2266311plh.247.2022.07.21.15.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 15:56:28 -0700 (PDT)
Date:   Thu, 21 Jul 2022 22:56:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 21/25] KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL
 errata handling out of setup_vmcs_config()
Message-ID: <YtnZmCutdd5tpUmz@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-22-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714091327.1085353-22-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> As a preparation to reusing the result of setup_vmcs_config() for setting
> up nested VMX control MSRs, move LOAD_IA32_PERF_GLOBAL_CTRL errata handling
> to vmx_vmexit_ctrl()/vmx_vmentry_ctrl() and print the warning from
> hardware_setup(). While it seems reasonable to not expose
> LOAD_IA32_PERF_GLOBAL_CTRL controls to L1 hypervisor on buggy CPUs,
> such change would inevitably break live migration from older KVMs
> where the controls are exposed. Keep the status quo for know, L1 hypervisor

s/know/now

> itself is supposed to take care of the errata.

Except the errata are based on FMS and the FMS exposed to the L1 hypervisor may
not be the real FMS.

But that's moot, because they _should_ be fully emulated by KVM anyways; KVM
runs L2 with a MSR value modified by perf, not the raw MSR value requested by L1.

Of course KVM screws things up and fails to clear the flag in entry controls...
All exit controls are emulated so at least KVM gets those right.

Untested, but I believe KVM the fix is:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d0e781c7ac72..76926147b672 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2357,7 +2357,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
         * we can avoid VMWrites during vmx_set_efer().
         */
        exec_control = __vm_entry_controls_get(vmcs01);
-       exec_control |= vmcs12->vm_entry_controls;
+       exec_control |= (vmcs12->vm_entry_controls &
+                        ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
        exec_control &= ~(VM_ENTRY_IA32E_MODE | VM_ENTRY_LOAD_IA32_EFER);
        if (cpu_has_load_ia32_efer()) {
                if (guest_efer & EFER_LMA)

> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 62 ++++++++++++++++++++++++++----------------
>  1 file changed, 38 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2dff5b94c535..e462e5b9c0a1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2416,6 +2416,31 @@ static bool cpu_has_sgx(void)
>  	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
>  }
>  
> +/*
> + * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
> + * can't be used due to errata where VM Exit may incorrectly clear
> + * IA32_PERF_GLOBAL_CTRL[34:32]. Work around the errata by using the
> + * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
> + */
> +static bool cpu_has_perf_global_ctrl_bug(void)
> +{
> +	if (boot_cpu_data.x86 == 0x6) {
> +		switch (boot_cpu_data.x86_model) {
> +		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
> +		case INTEL_FAM6_NEHALEM:	/* AAP115 */
> +		case INTEL_FAM6_WESTMERE:	/* AAT100 */
> +		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
> +		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
> +			return true;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +
>  static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>  				      u32 msr, u32 *result)
>  {
> @@ -2572,30 +2597,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  		_vmexit_control &= ~x_ctrl;
>  	}
>  
> -	/*
> -	 * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
> -	 * can't be used due to an errata where VM Exit may incorrectly clear
> -	 * IA32_PERF_GLOBAL_CTRL[34:32].  Workaround the errata by using the
> -	 * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
> -	 */
> -	if (boot_cpu_data.x86 == 0x6) {
> -		switch (boot_cpu_data.x86_model) {
> -		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
> -		case INTEL_FAM6_NEHALEM:	/* AAP115 */
> -		case INTEL_FAM6_WESTMERE:	/* AAT100 */
> -		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
> -		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
> -			_vmentry_control &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> -			_vmexit_control &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> -			pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
> -					"does not work properly. Using workaround\n");
> -			break;
> -		default:
> -			break;
> -		}
> -	}
> -
> -
>  	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
>  
>  	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
> @@ -4184,6 +4185,10 @@ static u32 vmx_vmentry_ctrl(void)
>  			  VM_ENTRY_LOAD_IA32_EFER |
>  			  VM_ENTRY_IA32E_MODE);
>  
> +

Extra line.

> +	if (cpu_has_perf_global_ctrl_bug())
> +		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +
>  	return vmentry_ctrl;
>  }
>  
> @@ -4198,6 +4203,10 @@ static u32 vmx_vmexit_ctrl(void)
>  	if (vmx_pt_mode_is_system())
>  		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
>  				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
> +
> +	if (cpu_has_perf_global_ctrl_bug())
> +		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +
>  	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
>  	return vmexit_ctrl &
>  		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
> @@ -8113,6 +8122,11 @@ static __init int hardware_setup(void)
>  	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
>  		return -EIO;
>  
> +	if (cpu_has_perf_global_ctrl_bug()) {

Curly braces not needed.

> +		pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
> +			     "does not work properly. Using workaround\n");
> +	}
> +
>  	if (boot_cpu_has(X86_FEATURE_NX))
>  		kvm_enable_efer_bits(EFER_NX);
>  
> -- 
> 2.35.3
> 
