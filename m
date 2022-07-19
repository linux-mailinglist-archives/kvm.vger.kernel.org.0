Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B4A57A999
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 00:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240707AbiGSWD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 18:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiGSWD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 18:03:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024786050C
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 15:03:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s21so15979944pjq.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 15:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eRpbtTCZs+5+sX8LZNM3fMyA3I2miPI5w4wEOaR3Kd8=;
        b=L0403lYdHQufM2qI/PJ7bMF875ZWcIbp65rgoZ6AMpKb9DrBBg49bzaDu5ytLIBR6k
         cHR87boOdSCFHXqHuUB3bJ3/m7PmELpKkXaieFF2bfYDWIRfnshHrZtHtelbFxJG2ipx
         acqsLcDu3PzNyZgPFGEAjSRO7dXCiAJSiucU2ODOr/1Tr1JIkYYK2Fv2bdo0VNTqWLkf
         27Yod0pT5lTvMEaQ1SGB9pq7eaKnbjBzVayp4h+Mpk0V8S9mnFNArj8aPPKHWF+02ZJW
         ML2WrV14/VEq64QAFmzb0Th4WQCIGfzCRUnjsH8+En28OeOHzbz3MLwbRFfyVZgsDFOf
         sB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eRpbtTCZs+5+sX8LZNM3fMyA3I2miPI5w4wEOaR3Kd8=;
        b=zSj5ivSq9T297IolXdb0jSBL51ICRKa6a3qkj1EYMFir7YDXaQOBYTlDKjHB0M2+s0
         5XZHFICqCtjLCr6wXtCaGmiMuwWOVaQx38EwXQKtCQ8zFfLWHYfS4CjNp37qzujY50lb
         hu8uZfi5SB/h0umiLQhe2lQpOAg1HYIi+9gSEYBbxKAK1uXO0qWzfRtioC3jzmM7MEyy
         dgK8E0z2mK6qB0zYINyQye7OD2h/kMOM6cRmyBKiqC2rzwwHCsiBgK+PDF1+Egcnu586
         uAkSKe/W1n4FDrdNKt8WiSnlzAHvh4NiCxVEHBt28XX3Jif2FFFF4QAjODOCfsunEVVH
         Iyqg==
X-Gm-Message-State: AJIora9HFwSC3rz2UV9Vc6IIPJt9+TuLe213lxtmSPqSDQFAlMx0h+k5
        TU91DEQyg06h8rH9r2KqsHrs9A==
X-Google-Smtp-Source: AGRyM1uWRLpTQswtNfEV1mRoZyGTzfyIBqNcfPo/PX+Gng0urzkvIUjr27tzFPFz+Ervz6Jjs/53rA==
X-Received: by 2002:a17:902:ce8c:b0:16c:4be6:254d with SMTP id f12-20020a170902ce8c00b0016c4be6254dmr35100092plg.51.1658268236359;
        Tue, 19 Jul 2022 15:03:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s5-20020a63e805000000b0041a411823d4sm2796267pgh.22.2022.07.19.15.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 15:03:55 -0700 (PDT)
Date:   Tue, 19 Jul 2022 22:03:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 02/12] KVM: X86/MMU: Add using_local_root_page()
Message-ID: <YtcqR8jDM+NVXgG5@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-3-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-3-jiangshanlai@gmail.com>
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

On Sat, May 21, 2022, Lai Jiangshan wrote:
> +static bool using_local_root_page(struct kvm_mmu *mmu)

Hmm, I agree with David that "local" isn't the most intuitive terminology.  But
I also do want to avoid private vs. shared to avoid confusion with confidential VMs.

Luckily, I don't think we need to come up with new terminology, just be literal
and call 'em "per-vCPU root pages".  E.g.

  static bool kvm_mmu_has_per_vcpu_root_page()

That way readers don't have to understand what "local" means, and that also captures
per-vCPU roots are an exception, i.e. that most roots are NOT per-vCPU.

> +{
> +	return mmu->root_role.level == PT32E_ROOT_LEVEL ||
> +	       (!mmu->root_role.direct && mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL);
> +}
> +
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
>  {
>  	struct kvm_mmu_page *sp;
> @@ -4252,10 +4285,11 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
>  {
>  	/*
>  	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
> -	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
> -	 * later if necessary.
> +	 * having to deal with PDPTEs.  Local roots can not be put into
> +	 * mmu->prev_roots[] because mmu->pae_root can not be shared for
> +	 * different roots at the same time.
>  	 */
> -	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
> +	if (unlikely(using_local_root_page(mmu)))

I don't know that I like using the local/per-vCPU helper.  The problem isn't _just_
that KVM is using a per-vCPU root, KVM is also deliberately punting on dealing with
PDTPRs.  E.g. the per-vCPU aspect doesn't explain why KVM doesn't allow reusing the
current root.  I don't like that the using_local_root_page() obfuscates that check.

My preference for this would be to revert back to a streamlined variation of the
code prior to commit 5499ea73e7db ("KVM: x86/mmu: look for a cached PGD when going
from 32-bit to 64-bit").

KVM switched to the !to_shadow_page() check to _avoid_ consuming (what is now)
mmu->root_role because, at the time of the patch, mmu held the _old_ data, which
was wrong/stale for nested virtualization transitions.

In other words, I would prefer that explicitly do (in a separate patch):

	/*
	 * For now, limit the fast switch to 64-bit VMs in order to avoid having
	 * to deal with PDPTEs.  32-bit VMs can be supported later if necessary.
	 */
	if (new_role.level < PT64_ROOT_LEVEL4)
		kvm_mmu_free_roots(kvm, mmu, KVM_MMU_ROOT_CURRENT);

The "hosts+VMs" can be shortened to just "VMs", because running a 64-bit VM with
a 32-bit host just doesn't work for a variety of reasons, i.e. doesn't need to be
called out here.
