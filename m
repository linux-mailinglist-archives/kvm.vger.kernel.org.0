Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E524C67F0DC
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjA0WFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjA0WFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:05:09 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37D183277
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:04:58 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso9966488pjj.1
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugdPvIE/UgIi2AsYMAylfdJdarL/XqO+jhF52miiL8Q=;
        b=GVoXpHQG9bbBhGzTQHzrZUyORNlvmfU7YE/NH5m04au/2vt2heOVC3kCH5U0SLDOQG
         AJIo9BcFDSyqm2YGaMTA86EEITScX8/RnX3ixzzNQHiIN+itsvSVlH+8XSYvOJ5lVC7j
         Djy6+u/+Nvdy4KsA7Svnb2Aq+OCRqGs8ygpQ5kF+YOV7Ap1dFkThMrsYDhCcGizYMJOj
         do29msRAnKPyApXj33r8VCCRhGutiZ2lFyD3IFN51gVVnD1fHwfcK2t60DS6l/0reTCm
         YaucA6f9oewModG24SWutxzLsz3I+TWNSoKltmn/s/Q8Txq3BfSsT66+8LS41+V1vAIk
         RzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugdPvIE/UgIi2AsYMAylfdJdarL/XqO+jhF52miiL8Q=;
        b=OavEF2M0ni4XrJZfjBIMoxIg9UI2wmRuRNUg3CpIC5ZIaoxOy+ljKElASPuPOrdymK
         ua02fEn8x2aQ8I8SO97aGgcslwMKBvGcuacDgX+Tbq+l5w7t/eEroOJEbXV+IaKL3SnC
         GQvgriHwD1gYxiPyneJU7QIPsOLFS7eDZRZ3UfpSLOiekPHwKG0BRAdEbJW9dHtCUb0t
         cGq3XJkxkmt3PQ7CIZ00tY28MsT6U4bHjCsnFsAwL5JftgbN8GOmmad3ietres84QxTP
         FA6rIhM+9INqjYXbKFvLm+26QpJPoo0B3bnv0+pl1CbgI8Ran8sq81tb+q1Bi/I3I5yO
         tIQA==
X-Gm-Message-State: AO0yUKWHecsSEdPs6hu9iM6zj7UWRwpu6cucdMKDdbhPiwBk/UxQ6/io
        kaBWP8e09xBES3W68++d23+4tw==
X-Google-Smtp-Source: AK7set9vQlFslqlnZR46Wr8cjYyu49KcLXx/7Vh7DNsTz8Ti9zRuM0YhITae+SM2dUcJ3BTDQChOiQ==
X-Received: by 2002:a05:6a20:c18c:b0:b8:e33c:f160 with SMTP id bg12-20020a056a20c18c00b000b8e33cf160mr168219pzb.0.1674857098242;
        Fri, 27 Jan 2023 14:04:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w190-20020a6382c7000000b004812f798a37sm2274012pgd.60.2023.01.27.14.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 14:04:56 -0800 (PST)
Date:   Fri, 27 Jan 2023 22:04:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v2 10/15] KVM: x86/vmx: Check Arch LBR config when return
 perf capabilities
Message-ID: <Y9RKaEzZ9tSKW1ZB@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-11-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-11-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
>  	return vmcs_config.cpu_based_2nd_exec_ctrl &
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b28be793de29..59bdd9873fb5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2360,6 +2360,10 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  		if (guest_efer != host_efer)
>  			exec_control |= VM_ENTRY_LOAD_IA32_EFER;
>  	}
> +
> +	if (cpu_has_vmx_arch_lbr())
> +		exec_control &= ~VM_ENTRY_LOAD_IA32_LBR_CTL;
> +
>  	vm_entry_controls_set(vmx, exec_control);
>  
>  	/*
> @@ -2374,6 +2378,10 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>  		exec_control |= VM_EXIT_LOAD_IA32_EFER;
>  	else
>  		exec_control &= ~VM_EXIT_LOAD_IA32_EFER;
> +
> +	if (cpu_has_vmx_arch_lbr())
> +		exec_control &= ~VM_EXIT_CLEAR_IA32_LBR_CTL;

This is wrong.  If KVM doesn't enumerate suport to L1, then L1's value needs to
be preserved on entry/exit to/from L1<->L2.  I.e. just delete these lines.

>  	vm_exit_controls_set(vmx, exec_control);
>  
>  	/*
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2ab4c33b5008..359da38a19a1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2599,6 +2599,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
>  		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
>  		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
> +		{ VM_ENTRY_LOAD_IA32_LBR_CTL, 		VM_EXIT_CLEAR_IA32_LBR_CTL },
>  	};
>  
>  	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
> @@ -4794,6 +4795,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	vpid_sync_context(vmx->vpid);
>  
>  	vmx_update_fb_clear_dis(vcpu, vmx);
> +
> +	if (!init_event && cpu_has_vmx_arch_lbr())
> +		vmcs_write64(GUEST_IA32_LBR_CTL, 0);

This belongs in init_vmcs().

>  }
>  
>  static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
> @@ -6191,6 +6195,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	    vmentry_ctl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
>  		pr_err("PerfGlobCtl = 0x%016llx\n",
>  		       vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL));
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&

Follow every other field and check the VMCS support, not the cap.

> +	    vmentry_ctl & VM_ENTRY_LOAD_IA32_LBR_CTL)
> +		pr_err("ArchLBRCtl = 0x%016llx\n",
> +		       vmcs_read64(GUEST_IA32_LBR_CTL));
>  	if (vmentry_ctl & VM_ENTRY_LOAD_BNDCFGS)
>  		pr_err("BndCfgS = 0x%016llx\n", vmcs_read64(GUEST_BNDCFGS));
>  	pr_err("Interruptibility = %08x  ActivityState = %08x\n",

...

> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index a3da84f4ea45..f68c8a53a248 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -493,7 +493,8 @@ static inline u8 vmx_get_rvi(void)
>  	 VM_ENTRY_LOAD_IA32_EFER |					\
>  	 VM_ENTRY_LOAD_BNDCFGS |					\
>  	 VM_ENTRY_PT_CONCEAL_PIP |					\
> -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
> +	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
> +	 VM_ENTRY_LOAD_IA32_LBR_CTL)
>  
>  #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
>  	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
> @@ -515,7 +516,8 @@ static inline u8 vmx_get_rvi(void)
>  	       VM_EXIT_LOAD_IA32_EFER |					\
>  	       VM_EXIT_CLEAR_BNDCFGS |					\
>  	       VM_EXIT_PT_CONCEAL_PIP |					\
> -	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
> +	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
> +	       VM_EXIT_CLEAR_IA32_LBR_CTL)

Enabling these flags by default is wrong.  KVM will clear LBR_CTL on VM-Exit when
arch LBRs are supported, and AFAICT, never restore the host's values.  And that
will happen regardless of whether or not the guest is using arch LBRs.  I assume
the correct approach is to toggle these fields, but I'll be damned if I can figure
out what the intended behavior of the existing LBR suport is.  I'll follow up in
the cover letter.
