Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95AF57D340
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 20:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiGUS1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiGUS1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 14:27:10 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8290D8B4BC
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:27:09 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h132so2375915pgc.10
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 11:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S1hUcrYm+jtlNZzV3SycrBnz6d392P58PDWep2jAQbA=;
        b=eqFJcZGcJJldZtX4Xp8ezyGFdGbgNW1scq7WjNRRoEKa16sc5Fcqkfx4OhC1woyJ7H
         7YKbcQGS4ygszF1xEbtwPPM5dWJ8cJU3y2TNUSReaVDzvbqRnH7LV461xvj0LI1RvPEh
         96Mv0m9+p2NcNH9lbYWvVQL/nGrpzl56f4QQBgtfin/TdMK77i//3eOqaIvuxDoqUsE2
         SGlKhjjrZH7udu1NKBuUZVu6gNyqH2CocdbtM1+oSkqtz98CnFAIwv1QImtmWHEfIRG/
         8zaHidAIqD+305jKxuD/XNlgyeJi6kxoCza7IvQjybu+x2gdsjdMO23OdquX1aedJudX
         DFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S1hUcrYm+jtlNZzV3SycrBnz6d392P58PDWep2jAQbA=;
        b=I6/Z+IFlgNwUNR2OWPHvF1LxvIFuk0GHl6um5EdXhuWf+WLB9N1m1eYh+VGnmKARbg
         dubWZWQlhnHXr4a8qI+cxtQRwINciKcxSIaFcREd06ieHU8C8Pm1lryEVlQ0Ydil2Ciz
         xOKH8pP9KnLiyak6LObXSLPiHD2K+oKE6GkKtLTIrraQzCC+n6PlMYu/Y8+sBPtzLWBU
         ia+r49LjiVpzzxG7o9mOnJyf31gmcZL1ueLfPouGMQ7e2KiHNHJI77Cz80Zk7tkg8AUn
         1d+w1Y19zzPaBQkEg2MxvlZ2Bmpbf95HNGxo2oF/5WzK7MU+QY0+9yTxob56c6imtzUo
         542Q==
X-Gm-Message-State: AJIora/H5U9X3Hu9P3mOxVEHIbBR7vBm3uUbILrGCg+9xixiqFcAzP68
        l/4q3uZ91+54uy5w6+y7zrRaow==
X-Google-Smtp-Source: AGRyM1vHDJWiDs8cF1+OpFVZ2ooip05ifRaVf9lJEliDPyb+HF9oE69PAyt+sphddWVd/3aluFv84A==
X-Received: by 2002:a63:541:0:b0:419:aea5:eff9 with SMTP id 62-20020a630541000000b00419aea5eff9mr35418553pgf.291.1658428028858;
        Thu, 21 Jul 2022 11:27:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ce8f00b0016bf5557690sm2070737plg.4.2022.07.21.11.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 11:27:08 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:27:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 3/7] KVM: x86/pmu: Avoid setting BIT_ULL(-1) to
 pmu->host_cross_mapped_mask
Message-ID: <YtmaeO85VAopC4BH@google.com>
References: <20220713122507.29236-1-likexu@tencent.com>
 <20220713122507.29236-4-likexu@tencent.com>
 <YtihtuxO/uefpAqJ@google.com>
 <84e1a911-d4f9-8984-a548-62100aafd035@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84e1a911-d4f9-8984-a548-62100aafd035@gmail.com>
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

On Thu, Jul 21, 2022, Like Xu wrote:
> On 21/7/2022 8:45 am, Sean Christopherson wrote:
> > On Wed, Jul 13, 2022, Like Xu wrote:
> > > From: Like Xu <likexu@tencent.com>
> > > 
> > > In the extreme case of host counters multiplexing and contention, the
> > > perf_event requested by the guest's pebs counter is not allocated to any
> > > actual physical counter, in which case hw.idx is bookkept as -1,
> > > resulting in an out-of-bounds access to host_cross_mapped_mask.
> > > 
> > > Fixes: 854250329c02 ("KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations")
> > > Signed-off-by: Like Xu <likexu@tencent.com>
> > > ---
> > >   arch/x86/kvm/vmx/pmu_intel.c | 11 +++++------
> > >   1 file changed, 5 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > index 53ccba896e77..1588627974fa 100644
> > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > @@ -783,20 +783,19 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
> > >   void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
> > >   {
> > >   	struct kvm_pmc *pmc = NULL;
> > > -	int bit;
> > > +	int bit, hw_idx;
> > >   	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
> > >   			 X86_PMC_IDX_MAX) {
> > >   		pmc = intel_pmc_idx_to_pmc(pmu, bit);
> > >   		if (!pmc || !pmc_speculative_in_use(pmc) ||
> > > -		    !intel_pmc_is_enabled(pmc))
> > > +		    !intel_pmc_is_enabled(pmc) || !pmc->perf_event)
> > >   			continue;
> > > -		if (pmc->perf_event && pmc->idx != pmc->perf_event->hw.idx) {
> > > -			pmu->host_cross_mapped_mask |=
> > > -				BIT_ULL(pmc->perf_event->hw.idx);
> > > -		}
> > > +		hw_idx = pmc->perf_event->hw.idx;
> > > +		if (hw_idx != pmc->idx && hw_idx != -1)
> > 
> > How about "hw_idx > 0" so that KVM is a little less dependent on perf's exact
> > behavior?  A comment here would be nice too.
> 
> The "hw->idx = 0" means that it occupies counter 0, so this part will look
> like this:

Doh, typo on my part, meant "hw_idx >= 0".  "> -1" is ok, though it's definitely
less idiomatic:

  $ git grep ">= 0" | wc -l
  5679
  $ git grep "> -1" | wc -l
  66
