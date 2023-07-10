Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CF574E0E3
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 00:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjGJWNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 18:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGJWNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 18:13:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA92186
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 15:13:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c83284edf0eso1855983276.3
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 15:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689027212; x=1691619212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VhyuhUu7ArHYZFjkYslfHWi7GXr3zNNFUwoXSJr15Gs=;
        b=STVcaaR6HH1MmFncFyTKauvrHE7UvRNbNSVW/i5IKGtGvhl2UQnGE0vFR8gJ66Uk2c
         pWD9/7AWt0Iqe8hrimzxYspFm62Tpuf0XaR47UwByAWC2rQ0T6kPQCe8oLGEGk2MMwkv
         rBmWDcKgO+1vIm/903NAi1T6/+F83sjnYUCBHkfmOJZxODUEirpiNccdSuOM2hW0217K
         OlU7wM3kxncMAm2W+HP6uuGbfTIlJjhGRCFIXTnESPbtqbxag+pdinbQYT2Zj96mVyvK
         gugeJt7F2/3TjWMxVge86PJm6T+A3+F3MQhVXNhtRqdv1t9Vs+Kv55CAEUsXVZc2WS7i
         fOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689027212; x=1691619212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VhyuhUu7ArHYZFjkYslfHWi7GXr3zNNFUwoXSJr15Gs=;
        b=KQP0293G//Lvpm72SNsYNWlndf2eZvKsSmLq8gy4D+m4jwe26/caFm/XBCqTOTdrN3
         Ogepb2qQDUFnTkxldmnCb4z/1aymxBQXShWXw+uyV65YOV8mdwavycRIXcjBF0qHzV1I
         EpkeX42VtVQ8ypzdqvCtjWYkmOXAR+wZXffl4eTP9hXj4OXAxLmEyCMlkPKudzT9HCce
         bvKMT90ZpBhdiB2491DlVAFFKJE8HH8bYX9GV+FeSdBxfBjPpwkghp6o6XMAQS3PK22q
         qVTMdhNxJn9ZftingAZODCeOcDiW5azLacscBRnFazK5FMZQbDgL39m7GwjJs/DFCuJw
         njEg==
X-Gm-Message-State: ABy/qLawgnpN6aGhxBNKdfo16BFUu4fZGkYeYPWBEDpMse0TRnd+bak1
        ZFwBhNRoNdJCHZWDNbObaANEGX1OEsA=
X-Google-Smtp-Source: APBJJlGicNB3k+jdZ6LQfesOWoW0KcNW9IGPTA9A/vbsEkgluZUxiXkGaHoqNIMT3Y4Zm0AQCJca26jhABo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c05:0:b0:c70:d138:51b1 with SMTP id
 5-20020a250c05000000b00c70d13851b1mr42859ybm.12.1689027212157; Mon, 10 Jul
 2023 15:13:32 -0700 (PDT)
Date:   Mon, 10 Jul 2023 15:13:30 -0700
In-Reply-To: <ZKxL09AW1s2uL28x@linux.dev>
Mime-Version: 1.0
References: <20230703163548.1498943-1-maz@kernel.org> <ZKxIGOAcQbknIcBL@google.com>
 <ZKxL09AW1s2uL28x@linux.dev>
Message-ID: <ZKyCimgRJThIR0pw@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, isaku.yamahata@intel.com,
        pbonzini@redhat.com,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        stable@vger.kernek.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023, Oliver Upton wrote:
> On Mon, Jul 10, 2023 at 11:04:08AM -0700, Sean Christopherson wrote:
> > On Mon, Jul 03, 2023, Marc Zyngier wrote:
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index aaeae1145359..a28c4ffe4932 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1894,8 +1894,17 @@ static void _kvm_arch_hardware_enable(void *discard)
> > >  
> > >  int kvm_arch_hardware_enable(void)
> > >  {
> > > -	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> > > +	int was_enabled;
> > >  
> > > +	/*
> > > +	 * Most calls to this function are made with migration
> > > +	 * disabled, but not with preemption disabled. The former is
> > > +	 * enough to ensure correctness, but most of the helpers
> > > +	 * expect the later and will throw a tantrum otherwise.
> > > +	 */
> > > +	preempt_disable();
> > > +
> > > +	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> > 
> > IMO, this_cpu_has_cap() is at fault.
> 
> Who ever said otherwise?

Sorry, should have phrased that as "should be fixed".
 
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 7d7128c65161..b862477de2ce 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -3193,7 +3193,9 @@ static void __init setup_boot_cpu_capabilities(void)
> >  
> >  bool this_cpu_has_cap(unsigned int n)
> >  {
> > -       if (!WARN_ON(preemptible()) && n < ARM64_NCAPS) {
> > +       __this_cpu_preempt_check("has_cap");
> > +
> > +       if (n < ARM64_NCAPS) {
> 
> This is likely sufficient, but to Marc's point we have !preemptible()
> checks littered about, it just so happens that this_cpu_has_cap() is the
> first to get called. We need to make sure there aren't any other checks
> that'd break under hotplug.

Ah, "we" is all of arm64.  E.g. this pattern in arch/arm64/kernel/cpu_errata.c
is splattered all over the place.

  WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());

AFAICT, the only issue in KVM proper is the BUG_ON() in kvm_vgic_init_cpu_hardware().

Sadly, a hack-a-fix for stable probably does make sense :-(
