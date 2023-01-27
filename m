Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E47367F0F8
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjA0WNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjA0WNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:13:08 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD9386265
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:13:07 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id m2so1356712plg.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MYZLnIY40jroi4PUdqvbvxtFSMplKPLRfAgf0y9nkzg=;
        b=ksR7ca23af5oO5I4qYDIotvq/MhuLrKR7MYC3FJ6StOQzO/2JXMz+/WZVdjBxapzb8
         HItsDxsNdZIGxV02S4ykxUVCSweRwCrvf9jQRH9DobgGuOkMZ6IjEzkm5E0guLmkmS86
         cq3pKkJ/F5GMFWD/9PCKKNcPfoIT/96Bxz70IHJnWICkri/bR9fpLeZUf0SObWB5s8nh
         a6aP/SIaYQm9+IDQBcHZn1Z1fTA2KJjQ1vqNB/n2sYNd0PiGTUl3Qkz8+ZgKG3e0ZZ0L
         rC28nDt/CxljhB4cuBVzrwazFVCYqItTDxC00gpRRsGYQYS6EvF6doFUlQ7RTy/+qsnR
         fi9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYZLnIY40jroi4PUdqvbvxtFSMplKPLRfAgf0y9nkzg=;
        b=kb7NkzJCzcfSJTh52obJvzcmqsHJYAqrv5EmjPFe196FHMIQ1P2BfaDbGf0EJ3XLcz
         E/f5NaHsQlk7T7Y2iXFGdw35HexCRe4ySmsESp5CVM8BPPXueENkLdwZsfPtTHsENRSX
         OiO0AD/JgW80OuWDCe2aNXBmSoQ8u7C5hXt0d7iXrfpIaYqohw05Bv5hMuyuM70ZYaok
         r3O1FrRo2JBIZmMdrPVt72dYJxp49czfvzOlKfuNL8CQuMouOykhIQ0/hQ7OdGQhAVMC
         G0V9k+mzzxkB6LlFjVId6pvy/QlfQVIm6PhcfEy0YQX5B2YA3K5JaAoG4mIISt9PJJGH
         ywog==
X-Gm-Message-State: AO0yUKWYfacQ6hali9rHmaRTaC4FM2PcTmNKDPqiJC5VqH5fCzV9Vm0s
        f8rRm3tL+g+W4JVZZKWyVf8AIw==
X-Google-Smtp-Source: AK7set/0dExFpzzLK4RYqfigvbVamCCmgG4niaVo6padoH8EHnSaiVdeRzszIIjvxl3/NzqRtWsxOA==
X-Received: by 2002:a05:6a21:33aa:b0:b9:14e:184b with SMTP id yy42-20020a056a2133aa00b000b9014e184bmr181110pzb.3.1674857586778;
        Fri, 27 Jan 2023 14:13:06 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j11-20020aa7928b000000b0058bb8943c9asm3052469pfa.161.2023.01.27.14.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 14:13:05 -0800 (PST)
Date:   Fri, 27 Jan 2023 22:13:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v2 14/15] KVM: x86: Add Arch LBR data MSR access interface
Message-ID: <Y9RMbq1FgygCPRrZ@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-15-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-15-weijiang.yang@intel.com>
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

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> Arch LBR MSRs are xsave-supported, but they're operated as "independent"
> xsave feature by PMU code, i.e., during thread/process context switch,
> the MSRs are saved/restored with perf_event_task_sched_{in|out} instead
> of generic kernel fpu switch code, i.e.,save_fpregs_to_fpstate() and
> restore_fpregs_from_fpstate(). When vcpu guest/host fpu state swap happens,
> Arch LBR MSRs are retained so they can be accessed directly.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index b57944d5e7d8..241128972776 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -410,6 +410,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>  		}
>  		return 0;
> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
> +		rdmsrl(msr_info->index, msr_info->data);

I don't see how this is correct.  As called out in patch 5:

 : If for some magical reason it's safe to access arch LBR MSRs without disabling
 : IRQs and confirming perf event ownership, I want to see a very detailed changelog
 : explaining exactly how that magic works.

> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -528,6 +533,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		    (data & ARCH_LBR_CTL_LBREN))
>  			intel_pmu_create_guest_lbr_event(vcpu);
>  		return 0;
> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
> +		wrmsrl(msr_info->index, msr_info->data);
> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>  		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> -- 
> 2.27.0
> 
