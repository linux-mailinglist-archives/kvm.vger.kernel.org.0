Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEE35FBB2B
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 21:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiJKTKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 15:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiJKTJp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:09:45 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06B494128
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:09:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so13038925pjl.0
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=20Kp1jeeHpGBum4Su4jfbPvVo7l5z9I8ZNUwYhcjAtE=;
        b=XxejvEzDPs7vSeKjrPhYc5Pxq32CeMTWb/w3ombhmCcQ+JNFI7ggIIV8Z+UzpJfdps
         B2Z2AcWMnObXOvuR3vMEDYAIeGDXW6/2FAww0TKsA4uMR1o/fzuiR5WSHRslv1V/AyyK
         Vsvc5jVht5MxMistIx77XQkhhYVCQVk3XKte/IftuvvP995QLooWRVoE8C4kt7Lb1Lfh
         BPaOccQjSBW3P9LkcC3K/RsSg9pfuQgwpi+rX+5t+Az/xERoY2vG2Irh4TyMHuvXGQzz
         sySvMFYqRj4qfhhoLf0lHR+msUCCwhx2MbbQvHY2mMUwfqXeK+BJJ/SOId8dKSg46YOr
         sx3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20Kp1jeeHpGBum4Su4jfbPvVo7l5z9I8ZNUwYhcjAtE=;
        b=iHgAXmYKO1z28QqAV8Wy/l4Fsrgye8ZaDEDQ8d9KbDuQtcrdn5mZlKCwt62oRgo2X4
         74ocbsuyRcXUWVMO5QmloJc7JWn/oQKRgrVMF2rqoWLVHxebAvvvlQMpogDmKabZfFby
         fWVsdDw1pEzvznhcUuVyFmBWT8dzZqLWP7J8hLxQzq7Sxh73Dqy8v2XE37kh/dYU3Gug
         ZOIX/MC2bMZJP9eHHOYkCq273Yim37Fd84vtjiuz288GNmmhjsQbPFVVizztOn6JWS7m
         uxPG/j12SzsGAU6lPRHW2RNU04hqyE5EpQjQ8UY+qgeLCGbv+8OXkF06suHTnAWHl4qC
         FdkA==
X-Gm-Message-State: ACrzQf1c2z7iVIxYeLTgavV5/4EltbPhEGTxUUJxP3SW9HjjoFVgZpon
        UGrMDCGBWkPMw/kQJbEvW+e+OA==
X-Google-Smtp-Source: AMsMyM78d3ySAgRa29zSbaUnARlPvkLOOwFA6nco4mi3nMGfCYfx2ftw9Xx1mbYh1ZPcBrNXdGAzQA==
X-Received: by 2002:a17:902:7290:b0:17f:d04b:bf57 with SMTP id d16-20020a170902729000b0017fd04bbf57mr24405317pll.147.1665515365613;
        Tue, 11 Oct 2022 12:09:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a11-20020a170902900b00b00179c99eb815sm9003192plp.33.2022.10.11.12.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:09:25 -0700 (PDT)
Date:   Tue, 11 Oct 2022 19:09:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: x86/pmu: Add PEBS support for SPR and future
 non-hybird models
Message-ID: <Y0W/YR6gXhunJYry@google.com>
References: <20220922051929.89484-1-likexu@tencent.com>
 <20220922051929.89484-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922051929.89484-2-likexu@tencent.com>
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

Kind of a nit, but I would prefer a shortlog that talks about the pdit/pdir
stuff and not a "enable PEBS" bucket.

On Thu, Sep 22, 2022, Like Xu wrote:
> @@ -140,6 +149,16 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
>  	__kvm_perf_overflow(pmc, true);
>  }
>  
> +static bool need_max_precise(struct kvm_pmc *pmc)
> +{
> +	if (pmc->idx == 0 && x86_match_cpu(vmx_pebs_pdist_cpu))
> +		return true;
> +	if (pmc->idx == 32 && x86_match_cpu(vmx_pebs_pdir_cpu))
> +		return true;
> +
> +	return false;
> +}
> +
>  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  				  u64 config, bool exclude_user,
>  				  bool exclude_kernel, bool intr)
> @@ -181,11 +200,11 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		 * the accuracy of the PEBS profiling result, because the "event IP"
>  		 * in the PEBS record is calibrated on the guest side.
>  		 *
> -		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
> +		 * On Icelake everything is fine. Other hardware (TNT+) that
>  		 * could possibly care here is unsupported and needs changes.

This part of the comment is still somewhat stale, and for me at least it's not at
all helpful.  

>  		 */
>  		attr.precise_ip = 1;
> -		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
> +		if (need_max_precise(pmc))
>  			attr.precise_ip = 3;

What about writing this as:

		attr.precise_ip = pmc_get_pebs_precision(pmc);

(or whatever name is appropriate for "pebs_precision").

Then in the helper, add comments to explaint the magic numbers and the interaction
with PDIST and PDIR.  Bonus points if #defines for the the magic numbers can be
added somewher

				 *  0 - SAMPLE_IP can have arbitrary skid
				 *  1 - SAMPLE_IP must have constant skid
				 *  2 - SAMPLE_IP requested to have 0 skid
				 *  3 - SAMPLE_IP must have 0 skid

static u64 pmc_get_pebs_precision(struct kvm_pmc *pmc)
{
	/* Comment that explains why PDIST/PDIR require 0 skid? */
	if ((pmc->idx == 0 && x86_match_cpu(vmx_pebs_pdist_cpu)) ||
	    (pmc->idx == 32 && x86_match_cpu(vmx_pebs_pdir_cpu)))
		return 3;

	/* Comment about constant skid? */
	return 1;
}


>  	}
>  
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index c5e5dfef69c7..4dc4bbe18821 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -398,7 +398,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>  
>  static inline bool vmx_pebs_supported(void)
>  {
> -	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
> +	return boot_cpu_has(X86_FEATURE_PEBS) &&
> +		!boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&

This belongs in a separate patch, and it should be ordered before patch 1 so that
there's no window where KVM can see pebs_ept==1 on a hybrid CPU.

Actually, shouldn't everything in this patch land before core enabling?

> +		kvm_pmu_cap.pebs_ept;

Please align indentation:

	return boot_cpu_has(X86_FEATURE_PEBS) &&
	       !boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
	       kvm_pmu_cap.pebs_ept;
