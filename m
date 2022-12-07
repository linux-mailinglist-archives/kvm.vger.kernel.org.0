Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A008364609D
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 18:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiLGRtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 12:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiLGRtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 12:49:04 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D35654E9
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 09:49:03 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so2158456pjp.1
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 09:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DoJAqfR7ZvwAFiT9srWB2lyZBimUwRAh5SkQOgCpWVU=;
        b=agsFaYqECAL1MPKDSRlaJV8kh8LVOmH7JyrbPFY5LZHTSTSh4H1W0rBB/2jFHBM+ug
         Ftz6j0F8PaZ/B0r106lYXc+WPNhnsE5AeHrn52PmxZ6jA4CxChancNX5S4XeRqatj7ml
         Z+VNICtE76VbH/asrkz0yXijc36RDB2MozVL3yONb34dKckZdK3ORVSMef3B+SAWUYjR
         yf7dCgc2ybBs1pTC7KU/zZ+J/nXsJjgUWHmLWU6YMVhQRl92etqNEXmiqUjBKcSSso3V
         eYgjy4z83ZLVYjGSAkg+BH96z7VcIMqQ95O6AgQNoxiKZfnRe8UCGwDOPQ48N9xy8ZrG
         Lw+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DoJAqfR7ZvwAFiT9srWB2lyZBimUwRAh5SkQOgCpWVU=;
        b=2NKTA1vB4jCaV3SFshoN1eENvPbZTdV9pLdQj7STt/C31pisia8HtPqfIyGaYFhqEv
         BznQ0dnB2GfaWgZzvZzbM0e9X9DwH4PZ85d2ft/U8it8T+Okg6QuVgTbrPJPPVB9ItOU
         9n87f0p9nvprRiLgj2t/YJ9wVxAd1Ojrt08pXc3DofNlErt6J6xQAA03LPObsF1ypCUt
         HrwJ1O1Sktn6wl/7/wPoU7YL7JCxSlDAYuMj1vtczsHL1R0EdjTc1Q+0F/uy7s229llx
         5lUmqb+qetHgiqw8uTDYDcTY1+6+m/0qzYNJDMIx6hQiq9Zk6uSsbKX04Z7LN68NVutJ
         mGGg==
X-Gm-Message-State: ANoB5pkUPONO1MosPPHp4Cw6U2IyNMvtDcxHjaVGiA7deefW4HLeSY9b
        7SuGT+MOINTKzoxOv42H5PCUGQ==
X-Google-Smtp-Source: AA0mqf7+cEw6DpVd/xxS6KqoKAuqr/wjwSNyv+uy7vc511bTIAbG5FcprGnJgigMDg5CjC3wkWNHWQ==
X-Received: by 2002:a05:6a21:9996:b0:a4:efde:2ed8 with SMTP id ve22-20020a056a21999600b000a4efde2ed8mr1749638pzb.0.1670435342977;
        Wed, 07 Dec 2022 09:49:02 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m17-20020a170902f21100b00189393ab02csm14805031plc.99.2022.12.07.09.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 09:49:02 -0800 (PST)
Date:   Wed, 7 Dec 2022 17:48:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/pmu: Avoid ternary operator by directly
 referring to counters->type
Message-ID: <Y5DSChtav9fqfeEA@google.com>
References: <20221205113718.1487-1-likexu@tencent.com>
 <Y44gbvm5Zb7a1Sbj@google.com>
 <38b2a836-f9a4-23e4-107b-61efc74638a4@gmail.com>
 <Y495sF0rDGrrfstD@google.com>
 <7db2bc22-99b8-96f3-66f3-d1695e2e82c1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7db2bc22-99b8-96f3-66f3-d1695e2e82c1@gmail.com>
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

On Wed, Dec 07, 2022, Like Xu wrote:
> On 7/12/2022 1:19 am, Sean Christopherson wrote:
> > On Tue, Dec 06, 2022, Like Xu wrote:
> > > > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > > > index e5cec07ca8d9..28b0a784f6e9 100644
> > > > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > > > @@ -142,7 +142,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
> > > > >    	}
> > > > >    	if (idx >= num_counters)
> > > > >    		return NULL;
> > > > > -	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
> > > > > +	*mask &= pmu->counter_bitmask[counters->type];
> > > > 
> > > > In terms of readability, I have a slight preference for the current code as I
> 
> IMO, using counters->type directly just like pmc_bitmask() will add more readability
> and opportunistically helps some stale compilers behave better.

Anyone that cares about this level of micro-optimization absolutely should be
using a toolchain that's at or near the bleeding edge.

> > > > don't have to look at counters->type to understand its possible values.
> > > When someone tries to add a new type of pmc type, the code bugs up.
> > 
> > Are there new types coming along?  If so, I definitely would not object to refactoring
> > this code in the context of a series that adds a new type(s).  But "fixing" this one
> > case is not sufficient to support a new type, e.g. intel_is_valid_rdpmc_ecx() also
> > needs to be updated.  Actually, even this function would need additional updates
> > to perform a similar sanity check.
> 
> True but this part of the change is semantically relevant, which should not
> be present in a harmless generic optimization like this one. Right ?

For modern compilers, it's not an optimization.

> > 	if (fixed) {
> > 		counters = pmu->fixed_counters;
> > 		num_counters = pmu->nr_arch_fixed_counters;
> > 	} else {
> > 		counters = pmu->gp_counters;
> > 		num_counters = pmu->nr_arch_gp_counters;
> > 	}
> > 	if (idx >= num_counters)
> > 		return NULL;
> > 
> > > And, this one will make all usage of pmu->counter_bitmask[] more consistent.
> > 
> > How's that?  There's literally one instance of using ->type
> > 
> >    static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
> >    {
> > 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> > 
> > 	return pmu->counter_bitmask[pmc->type];
> >    }
> > 
> > everything else is hardcoded.  And using pmc->type there make perfect sense in
> > that case.  But in intel_rdpmc_ecx_to_pmc(), there is already usage of "fixed",
> > so IMO switching to ->type makes that function somewhat inconsistent with itself.
> 
> More, it's rare to see code like " [ a ? b : c] " in the world of both KVM and x86.

There are a few false positives here, but ternary operators are common.

  $ git grep ? arch/x86/kvm | wc -l
  292

If you're saying that indexing an array with a ternary operator is rare, then sure,
but only because there is almost never anything that fits such a pattern, not because
it's an inherently bad pattern.

> Good practice (branchless) should be scattered everywhere and not the other
> way around.

Once again, modern compilers will not generate branches for this code.
