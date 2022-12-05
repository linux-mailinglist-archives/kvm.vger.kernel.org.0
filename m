Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B914B6430C2
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLESuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 13:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiLESum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:50:42 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73D31D64C
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 10:50:39 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id q71so11274797pgq.8
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 10:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p5ashMmlbLpHS/ekdQ6Rli3d8exmQ4txWz1/CMHFXQk=;
        b=GlALXVUVyecG1mOEFO21aXN1nBxC1f9g38wb9bXfpUl8Wgjy0xAtLTM2LaB3YxJ7/q
         x+fY+IFN9JVmqQ2JYJACVJsrBxsvE+qM3S5RfUK+NN5je79JbIGHvoGdd24y4HsUGWk9
         9+ywZIvougKMLPZ2DGq1i7x0rqiiQ0DQwoCmjUgJigXqREQGm6/zbQAKXDnoR9uvb2PT
         xBSXwFW9bHfA8xKAgNu3q6t4zjhzvCM5cmhD5oUl7NmjmD5pYIoOCQ1L0hFNTAtIEXFl
         BMf2gUvK8vxrI3ILX9IIOws45ZGxZlv9IyioR3V5tHqupBZEc0bCe3L7gtkMRRXU0qYk
         c+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p5ashMmlbLpHS/ekdQ6Rli3d8exmQ4txWz1/CMHFXQk=;
        b=tmuRdRDxN+fRWA3sKnHFAQghu0VVyancCbM8WRJ6JzJDMRIBfXo0jwoVXcAnGPLQ1C
         F9uxOvatqIqPPpH5tztV3/qncSLIR8eRvafK7ddh5cY5NUTOgZWstucNE0I1fiqR/DgH
         JUTFmQo7sYFFSb4Z8VqKOijuiwTTc/qH7fjVCBGhBHCLyVgxSUkjk8TSVdNJmMKaV63v
         RC0gO9v2lTN28ZAm2/CZ39bacM5sCmRpg1+HIMV74HGUYRuQYE/1bsRKvVlWbx6K4O8D
         rntZqCxbc5LIuxMauVcdmP3MxMdvAT0ipacEAJcLde68m7QiC/lp+pGdglfd6d1/Ml1Y
         5wAw==
X-Gm-Message-State: ANoB5plbrC+F2vxzYh8F8MFIn+TTToo6rm4R/bjCS/oGDAl/Z0nGKU8A
        qMo8ferC1WJNUuAWTtvRYpQqMy5U/92TxLVX
X-Google-Smtp-Source: AA0mqf5twGUsQSeEi1/4s7d6sQeK1iMb4NejovSmn0WyEQ+wyi5jPiXs8MAqwng6CVsoyRqnvMgjMQ==
X-Received: by 2002:a05:6a00:198d:b0:569:92fa:cbbc with SMTP id d13-20020a056a00198d00b0056992facbbcmr66701255pfl.77.1670266239153;
        Mon, 05 Dec 2022 10:50:39 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id q100-20020a17090a1b6d00b00218ddc8048bsm11243965pjq.34.2022.12.05.10.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 10:50:38 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:50:35 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v4 04/16] KVM: arm64: PMU: Distinguish between 64bit
 counter and 64bit overflow
Message-ID: <Y449e7dMzf1zaOh4@google.com>
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-5-maz@kernel.org>
 <Y4jasyxvFRNvvmox@google.com>
 <Y4jbosgHbUDI0WF4@google.com>
 <86zgc2kqcz.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zgc2kqcz.wl-maz@kernel.org>
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

On Mon, Dec 05, 2022 at 12:05:32PM +0000, Marc Zyngier wrote:
> On Thu, 01 Dec 2022 16:51:46 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Thu, Dec 01, 2022 at 08:47:47AM -0800, Ricardo Koller wrote:
> > > On Sun, Nov 13, 2022 at 04:38:20PM +0000, Marc Zyngier wrote:
> > > > The PMU architecture makes a subtle difference between a 64bit
> > > > counter and a counter that has a 64bit overflow. This is for example
> > > > the case of the cycle counter, which can generate an overflow on
> > > > a 32bit boundary if PMCR_EL0.LC==0 despite the accumulation being
> > > > done on 64 bits.
> > > > 
> > > > Use this distinction in the few cases where it matters in the code,
> > > > as we will reuse this with PMUv3p5 long counters.
> > > > 
> > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > ---
> > > >  arch/arm64/kvm/pmu-emul.c | 43 ++++++++++++++++++++++++++++-----------
> > > >  1 file changed, 31 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > > index 69b67ab3c4bf..d050143326b5 100644
> > > > --- a/arch/arm64/kvm/pmu-emul.c
> > > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > > @@ -50,6 +50,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
> > > >   * @select_idx: The counter index
> > > >   */
> > > >  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > > > +{
> > > > +	return (select_idx == ARMV8_PMU_CYCLE_IDX);
> > > > +}
> > > > +
> > > > +static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
> > > >  {
> > > >  	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> > > >  		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> > > > @@ -57,7 +62,8 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > > >  
> > > >  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> > > >  {
> > > > -	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
> > > > +	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
> > > > +		!kvm_pmu_idx_has_64bit_overflow(vcpu, idx));
> > > >  }
> > > >  
> > > >  static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> > > > @@ -97,7 +103,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> > > >  		counter += perf_event_read_value(pmc->perf_event, &enabled,
> > > >  						 &running);
> > > >  
> > > > -	if (select_idx != ARMV8_PMU_CYCLE_IDX)
> > > > +	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
> > > >  		counter = lower_32_bits(counter);
> > > >  
> > > >  	return counter;
> > > > @@ -423,6 +429,23 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
> > > >  	}
> > > >  }
> > > >  
> > > > +/* Compute the sample period for a given counter value */
> > > > +static u64 compute_period(struct kvm_vcpu *vcpu, u64 select_idx, u64 counter)
> > > > +{
> > > > +	u64 val;
> > > > +
> > > > +	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
> > > > +		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
> > > > +			val = -(counter & GENMASK(31, 0));
> > > 
> > > If I understand things correctly, this might be missing another mask:
> > > 
> > > +		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx)) {
> > > +			val = -(counter & GENMASK(31, 0));
> > > +			val &= GENMASK(31, 0);
> > > +		} else {
> > > 
> > > For example, if the counter is 64-bits wide, it overflows at 32-bits,
> > > and it is _one_ sample away from overflowing at 32-bits:
> > > 
> > > 	0x01010101_ffffffff
> > > 
> > > Then "val = (-counter) & GENMASK(63, 0)" would return 0xffffffff_00000001.
> > 
> > Sorry, this should be:
> > 
> > 	Then "val = -(counter & GENMASK(31, 0))" would return 0xffffffff_00000001.
> > 
> > > But the right period is 0x00000000_00000001 (it's one sample away from
> > > overflowing).
> 
> Yup, this is a bit bogus. But this can be simplified by falling back
> to the normal 32bit handling (on top of the pmu-unchained branch):
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index d8ea39943086..24908400e190 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -461,14 +461,10 @@ static u64 compute_period(struct kvm_pmc *pmc, u64 counter)
>  {
>  	u64 val;
>  
> -	if (kvm_pmc_is_64bit(pmc)) {
> -		if (!kvm_pmc_has_64bit_overflow(pmc))
> -			val = -(counter & GENMASK(31, 0));
> -		else
> -			val = (-counter) & GENMASK(63, 0);
> -	} else {
> +	if (kvm_pmc_is_64bit(pmc) && kvm_pmc_has_64bit_overflow(pmc))

Great, thanks! Yes, that definitely makes things simpler ^.

> +		val = (-counter) & GENMASK(63, 0);
> +	else
>  		val = (-counter) & GENMASK(31, 0);
> -	}
>  
>  	return val;
>  }
> 
> which satisfies the requirement without any extra masking, and makes
> it plain that only a 64bit counter with 64bit overflow gets its period
> computed on the full 64bit, and that anyone else gets the 32bit
> truncation.
> 
> I'll stash yet another patch on top and push it onto -next.
> 
> Thanks!
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
