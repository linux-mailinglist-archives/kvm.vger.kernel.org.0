Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5375C5854F4
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 20:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbiG2SPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 14:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbiG2SPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 14:15:23 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCE91AF13
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:15:21 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g12so5306361pfb.3
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 11:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Obk/pcqF68Ks7EntsqYVj2QhxCZophsW8ZmQm6Eytd0=;
        b=sdNmm3lLFIdBbY9ez5s+LiPHA0B79x8tQ1YJzPIc62ADvFEVyR6qw9k2bOtcfRWF/1
         QVKJrGQFjgxWtK4j9SVMWTC2uu7nEKyh5pxHBwgLIR1eNfHQ7hRGGiByQ70p6TWHI78q
         +xAaZPpgMHO0AeTlIJzRI00J4P/Nd24j8doXNytxXZXuPv8I9CjMq1tDu42BMi7Qiw3h
         G/dWVytyQYCgnE7SuD+OUsUtZ951KJf3smo8WTiuTY6vNJ9vp6Qx6WOmFMPlgAWHm9P6
         AHZyVKiPkewv86zzPZc4Uq+BEdRLvKI2eb+4Ygk81F4u/w24SmLfxsOqIzEaQR8aMRo/
         V5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Obk/pcqF68Ks7EntsqYVj2QhxCZophsW8ZmQm6Eytd0=;
        b=tq10OBVLCVd+KcAOmkh/gh0/Idf4O4H1RigIgXTuNuRx1C4HHi2X1d4yvgt+mZNPoK
         R670BL+EvHRTGGmwTCtYJRJpsH8ZfvhF5Ef7Oo+Xx8yBpf9XcYswFsq7lk1aqgM0LEE9
         lE7G7wVsXv+a2adx2lZlvkYvaYohmhe7ge4OnGObJsOsoYEOSGnGbKb/q+ClRsuOq9AN
         x1my4yQUnPJkwC5TOmprl+GGnUGA4q2moUeWpWOvM18Pj3YevhZjvKUtZzSTAAFTmO5e
         J76NZdj7AtwjJmqIA4X5zmhibfkeTdrPu8eK31DFfWid5bSkzy6F1M5MAZSYUfzNbzMg
         8AAA==
X-Gm-Message-State: AJIora+v0j5upump/nCX5w41e9g60XdT1+0DfGEKBPTvrmMPeNzEi57J
        U9QIFsBTXX330jeGxkXH8g3glg==
X-Google-Smtp-Source: AGRyM1svUsmBEpgf5T4GJq5zfLGGMtiYdIybjaQglORa4rlytr4GMQJOh2HBpI9hYelo6x2YrG5qWw==
X-Received: by 2002:a63:f011:0:b0:41a:6262:bfcd with SMTP id k17-20020a63f011000000b0041a6262bfcdmr3842848pgh.40.1659118520814;
        Fri, 29 Jul 2022 11:15:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a1709028ecb00b0016c38eb1f3asm3861796plo.214.2022.07.29.11.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 11:15:20 -0700 (PDT)
Date:   Fri, 29 Jul 2022 18:15:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 3/4] KVM: SVM: Adjust MMIO masks (for caching) before
 doing SEV(-ES) setup
Message-ID: <YuQjtLK1uk3/bhK/@google.com>
References: <20220728221759.3492539-1-seanjc@google.com>
 <20220728221759.3492539-4-seanjc@google.com>
 <9bdfbad2dc9f193fb57f7ee113db7f1c2b96973c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bdfbad2dc9f193fb57f7ee113db7f1c2b96973c.camel@intel.com>
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

On Fri, Jul 29, 2022, Kai Huang wrote:
> On Thu, 2022-07-28 at 22:17 +0000, Sean Christopherson wrote:
> > Adjust KVM's MMIO masks to account for the C-bit location prior to doing
> > SEV(-ES) setup.  A future patch will consume enable_mmio caching during
> > SEV setup as SEV-ES _requires_ MMIO caching, i.e. KVM needs to disallow
> > SEV-ES if MMIO caching is disabled.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index aef63aae922d..62e89db83bc1 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5034,13 +5034,16 @@ static __init int svm_hardware_setup(void)
> >  	/* Setup shadow_me_value and shadow_me_mask */
> >  	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
> >  
> > -	/* Note, SEV setup consumes npt_enabled. */
> > +	svm_adjust_mmio_mask();
> > +
> > +	/*
> > +	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
> > +	 * may be modified by svm_adjust_mmio_mask()).
> > +	 */
> >  	sev_hardware_setup();
> 
> If I am not seeing mistakenly, the code in latest queue branch doesn't consume
> enable_mmio_caching.  It is only added in your later patch.
> 
> So perhaps adjust the comment or merge patches together?

Oooh, I see what you're saying.  I split the patches so that if this movement turns
out to break something then bisection will point directly here, but that's a pretty
weak argument since both patches are tiny.  And taking patch 4 without patch 3,
e.g. in the unlikely event this movement needs to be reverted, is probably worse
than not having patch 4 at all, i.e. having somewhat obvious breakage is better.

So yeah, I'll squash this with patch 4.

Thanks!
