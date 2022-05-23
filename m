Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62E153189D
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbiEWQna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 12:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239061AbiEWQnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 12:43:22 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1886973A
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:43:18 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q76so14146320pgq.10
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 09:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6oTk/zM3kr5sT5hZHtfbrEZg5Wd/Dydos1apa+GKeoY=;
        b=QdxOJcF3IWnNjLf1G8T+GpDa69DBUgRlOonCO9LKXCmpCDUGK12eSBoMWHmfPB1itJ
         SO9BTnoJSux49GWZSK+aV0I4qTYd1S7U/pNm5CyBDxxmmE8yrQD2tRoM9KBCPJXFbflE
         NZVsUtR6Fkn5DV69G9JvBi/zdjLwvJGQ9yglJbCfiiSANMzIX9HUuagkInt7uIPcjef8
         8HAu6iE+lLaZV7b38ndzGINx68cke3Vl/e2k2UnmsV5vPELJFfCMwJRI4iCoIS/7Tm19
         6QRQ0f4PnR1z0LHZJkZqomb4NnAZPi55FK86CpGOzn2mw9KYJMgnf1aqyn7b3wg8rBz5
         X6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6oTk/zM3kr5sT5hZHtfbrEZg5Wd/Dydos1apa+GKeoY=;
        b=I4hOGgrYpwksZVenaEtmvz9IReG89odscvRlIbfab2xPPCjLop/yIpvGCUb8Hu88A2
         oFsDkC2y6qFlTtcJM1+Z+1S+Qb31Hm1P6T8T8ZKeMFiUz6fYeRNA6WwZaOKg6YORBGbs
         k25g6qT0KsPb0Fz/8IboxjyJaUsZ/VS1aapgKwZaIWJINbtxoPXcP769LB/2dd+IwxKL
         5ZC0UX9ZBmlOn9faE7+OrGMDpgO5+Xm1tWjkIsOzlzOS06Le034xGFyqkgkagpIX5AL6
         qvbk2k2y1qGAzsMBoVMhJn9cO3LkdtCKp1fZZcfZoRRPEmSb9qzNALb2dn9ZP7I1XUPU
         QUzg==
X-Gm-Message-State: AOAM532s3dljBk6q3ZCZHPzDi7i1D/xb2uuxJ8aZjYDsskXlN8AidmoU
        jvVDyCyHTMpaJM6MPUX2ZOSGSg==
X-Google-Smtp-Source: ABdhPJwM1VqkA9PiDFWw+67HoD14fHH37p33rjlGv3CbNWhyEnQMAJ+UQkhvjCHmuamjH2aucWK5Eg==
X-Received: by 2002:a05:6a00:a0e:b0:4fd:fa6e:95fc with SMTP id p14-20020a056a000a0e00b004fdfa6e95fcmr24601061pfh.17.1653324197174;
        Mon, 23 May 2022 09:43:17 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id iw17-20020a170903045100b0015e8d4eb2dfsm5321204plb.297.2022.05.23.09.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:43:16 -0700 (PDT)
Date:   Mon, 23 May 2022 16:43:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yanfei Xu <yanfei.xu@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: x86: Fix the intel_pt PMI handling wrongly
 considered from guest
Message-ID: <You5oYO5flRRFv4n@google.com>
References: <20220523140821.1345605-1-yanfei.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523140821.1345605-1-yanfei.xu@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022, Yanfei Xu wrote:
> When kernel handles the vm-exit caused by external interrupts and NMI,
> it always set a type of kvm_intr_type to handling_intr_from_guest to
> tell if it's dealing an IRQ or NMI. For the PMI scenario, it could be
> IRQ or NMI.
> However the intel_pt PMI certainly is a NMI PMI, hence using

It'd be helpful for future readers to explain why it's guaranteed to an NMI.  E.g.

However, intel_pt PMIs are only generated for HARDWARE perf events, and
HARDWARE events are always configured to generate NMIs.  Use
kvm_handling_nmi_from_guest() to precisely identify if the intel_pt PMI
came from the guest to avoid false positives if an intel_pt PMI/NMI
arrives while the host is handling an unrelated IRQ VM-Exit.

> kvm_handling_nmi_from_guest() to distinguish if the intel_pt PMI comes
> from guest is more appropriate. This modification can avoid the host
> wrongly considered the intel_pt PMI comes from a guest once the host
> intel_pt PMI breaks the handling of vm-exit of external interrupts.
> 
> Fixes: db215756ae59 ("KVM: x86: More precisely identify NMI from guest when handling PMI")
> Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
> ---
> v1->v2:
> 1.Fix vmx_handle_intel_pt_intr() directly instead of changing the generic function.
> 2.Tune the commit message.
> 
> v2->v3:
> Add the NULL pointer check of variable "vcpu".
> 
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 610355b9ccce..982df9c000d3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7856,7 +7856,7 @@ static unsigned int vmx_handle_intel_pt_intr(void)
>  	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  
>  	/* '0' on failure so that the !PT case can use a RET0 static call. */
> -	if (!kvm_arch_pmi_in_guest(vcpu))
> +	if (!vcpu || !kvm_handling_nmi_from_guest(vcpu))

Alternatively,

	if (!kvm_arch_pmi_in_guest(vcpu) || !kvm_handling_nmi_from_guest(vcpu))

The generated code is the same since the compiler is smart enough to elide the
handling_intr_from_guest check from kvm_arch_pmi_in_guest.

I'm not actually sure that's better than the !vcpu check though, e.g. it hides the
not-NULL aspect of the check.

Either way, with a tweaked changelog,

Reviewed-by: Sean Christopherson <seanjc@google.com>
