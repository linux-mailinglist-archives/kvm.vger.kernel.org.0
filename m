Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B863762E74B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 22:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiKQVu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 16:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiKQVuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 16:50:54 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B549B10FD8
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 13:50:53 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r18so3245522pgr.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 13:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVmf135oDM7cjIg0p5NOjXYbOvJzirQGQpU1E7UATjY=;
        b=MvR6zBMU0iANN+nwt76pdZpEdGUXfCq0ZK+4B8OYKPG0Dza8+CFdmcnhM0yTTqlWlu
         iWfcDWW6MFSAJ/Xu5HsJ7pwHCG3e5GksnU6q9t+P0b07psgKC3SWh1Xf1WXkDGWFIQt6
         zeZLwT//eWzHFTuXYAZwo1LXDvc7tvVe+HQxu8UJ4wVGYI/Bzz/iWIuclnK15dtJNIMX
         d6CQ7CTfZ/xqppeMX3oU25UT5bKpW8WNjdgLk8m0mFOZpXmHboq3Y3R65+yjWkMybBor
         Da9Dab8hL+kPFkVRci1CXVUX9k7/eXKTKpQctbD8c1rXAKJHq2cC89y2B2JzDSbtiGGy
         Cgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVmf135oDM7cjIg0p5NOjXYbOvJzirQGQpU1E7UATjY=;
        b=JpBzU7WFbusjUxDHS4RJyHLmcqENx3mxEwMTxKvrjikX3E/sv4Akh5JYLWKjxWkWQe
         VNIRQCGWvBBBQt/BC8GPzwUc9HZ/gdZuv+lgUTk5Z8xERTdbspMeazlc7si+MZ++xKj6
         19xb9ZLBzC7F/4xHNMCcVHF5b+wYZG4kEwyivznwOtdSb42fFkXAEvefJZlZ4qodlhrV
         JPCuUDpZuzQabhv1ZmYXGcReYD/5f7wwgohMHSGUVW/D2EzEdqzQxVt8M2kmfUkY0wa8
         locPc5s/V75vQgPjwS9wuJXT6AEDfuK2CVzrgeyTcVRiAf07HbT7les+SsrlD50KBp7B
         26aA==
X-Gm-Message-State: ANoB5pmY77VNN51iQkRaefPZApLsZCc8eIrR3I/Dp2CQn80qtuGuIIlk
        yZ2pqRK85LgP5RLM0jBhP9spfA==
X-Google-Smtp-Source: AA0mqf7ojiEOfGMugQYHg3mgtr0O+ymG8fIyWealzk5fox/o6TkFLXvXx/gvXMhXQPTcyJUS9c5J7A==
X-Received: by 2002:a63:5359:0:b0:46f:7e1c:e6e6 with SMTP id t25-20020a635359000000b0046f7e1ce6e6mr3941995pgl.138.1668721853125;
        Thu, 17 Nov 2022 13:50:53 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id i8-20020a170902c94800b00172fad607b3sm1879087pla.207.2022.11.17.13.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 13:50:52 -0800 (PST)
Date:   Thu, 17 Nov 2022 13:50:49 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        ricarkol@gmail.com
Subject: Re: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y3asuXMXYPjsGgCA@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-5-ricarkol@google.com>
 <Y3KrHG4WMXMUquUy@google.com>
 <Y3QazjAUVE+T6rHh@google.com>
 <Y3QgVqSUCm8kdbeN@google.com>
 <Y3Qms0lbCiLFJvG+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Qms0lbCiLFJvG+@google.com>
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

On Tue, Nov 15, 2022 at 11:54:27PM +0000, Oliver Upton wrote:
> On Tue, Nov 15, 2022 at 03:27:18PM -0800, Ricardo Koller wrote:
> > On Tue, Nov 15, 2022 at 03:03:42PM -0800, Ricardo Koller wrote:
> > > On Mon, Nov 14, 2022 at 08:54:52PM +0000, Oliver Upton wrote:
> 
> [...]
> 
> > > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > > > index d1f309128118..9c42eff6d42e 100644
> > > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > > @@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
> > > > >  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
> > > > >  }
> > > > >  
> > > > > +struct stage2_split_data {
> > > > > +	struct kvm_s2_mmu		*mmu;
> > > > > +	void				*memcache;
> > > > > +	struct kvm_pgtable_mm_ops	*mm_ops;
> > > > 
> > > > You can also get at mm_ops through kvm_pgtable_visit_ctx
> > > > 
> > > > > +};
> > > > > +
> > > > > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > > > +			       enum kvm_pgtable_walk_flags visit)
> > > > > +{
> > > > > +	struct stage2_split_data *data = ctx->arg;
> > > > > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > > > > +	kvm_pte_t pte = ctx->old, attr, new;
> > > > > +	enum kvm_pgtable_prot prot;
> > > > > +	void *mc = data->memcache;
> > > > > +	u32 level = ctx->level;
> > > > > +	u64 phys;
> > > > > +
> > > > > +	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	/* Nothing to split at the last level */
> > > > > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > > > > +		return 0;
> > > > > +
> > > > > +	/* We only split valid block mappings */
> > > > > +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> > > > > +		return 0;
> > > > > +
> > > > > +	phys = kvm_pte_to_phys(pte);
> > > > > +	prot = kvm_pgtable_stage2_pte_prot(pte);
> > > > > +	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
> > > > > +
> > > > > +	/*
> > > > > +	 * Eager page splitting is best-effort, so we can ignore the error.
> > > > > +	 * The returned PTE (new) will be valid even if this call returns
> > > > > +	 * error: new will be a single (big) block PTE.  The only issue is
> > > > > +	 * that it will affect dirty logging performance, as the huge-pages
> > > > > +	 * will have to be split on fault, and so we WARN.
> > > > > +	 */
> > > > > +	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
> > > > 
> > > > I don't believe we should warn in this case, at least not
> > > > unconditionally. ENOMEM is an expected outcome, for example.
> > > 
> > > Given that "eager page splitting" is best-effort, the error must be
> > > ignored somewhere: either here or by the caller (in mmu.c). It seems
> > > that ignoring the error here is not a very good idea.
> > 
> > Actually, ignoring the error here simplifies the error handling.
> > stage2_create_removed() is best-effort; here's an example.  If
> > stage2_create_removed() was called to split a 1G block PTE, and it
> > wasn't able to split all 2MB blocks, it would return ENOMEM and a valid
> > PTE pointing to a tree like this:
> > 
> > 		[---------1GB-------------]
> > 		:                         :
> > 		[--2MB--][--2MB--][--2MB--]
> > 		:       :
> > 		[ ][ ][ ]
> > 
> > If we returned ENOMEM instead of ignoring the error, we would have to
> > clean all the intermediate state.  But stage2_create_removed() is
> > designed to always return a valid PTE, even if the tree is not fully
> > split (as above).  So, there's no really need to clean it: it's a valid
> > tree. Moreover, this valid tree would result in better dirty logging
> > performance as it already has some 2M blocks split into 4K pages.
> 
> I have no issue with installing a partially-populated table, but
> unconditionally ignoring the return code and marching onwards seems
> dangerous. If you document the behavior of -ENOMEM on
> stage2_create_removed() and return early for anything else it may read a
> bit better.

This got me thinking. These partially-populated tables are complicating
things too much for not good reason. They should be very rare, as the
caller will ensure there's enough memory in the memcache. So what do you
think of this other option?

https://github.com/ricarkol/linux/commit/54ba44f7d00d93cbaecebd148c102ca9d7c0e711

used here:

https://github.com/ricarkol/linux/commit/ff63a8744c18d5e4589911831e20ccb41712bda2#

It reuses the stage2 mapper to implement create_removed(), and makes
things simpler by only returning success when building a fully populated
tree. The caller doesn't need to clean anything in case of failures:
partially populated trees are cleaned up by create_removed() before
returninf failure.

> 
> --
> Thanks,
> Oliver
