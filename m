Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C928F601626
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJQSUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiJQSUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:20:33 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C841A3A9
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:20:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so15018240pjq.3
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6jzGua7xpgU+8ricngS1qbS/DmygEHOLjUfJqLmkbXc=;
        b=iqgJRnrd9hi8EcWTYk8NOT6dJTCx/JvLMyK84CkHFjHm3oNtFgEOovS2tWYR/EsxUw
         ZL53GZ6ssLz88tFUMb6KMvmal9jWV8o7uB5cPgMsotv2eIXGJtfpvdr/OkacnTtejtRC
         mVaKk6lnoRPbFLKEqczrcfpnWAmoyiYUtzh4V8YDbTjmR3jyALem+3a9hJ4VkhP2i82C
         UKI2xCi/02AjofBvwcHotG3dO8+8qLbLZe9P/AfL6faIWGonepnVSS3K+0mh0s0DRQtj
         4f+TkO0WM3a8KJhmWf+a9aNk7K5B7HGPV9QMu8FBDNwdlQF/vqyOxb9mf9d+fwPVLnzC
         zUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jzGua7xpgU+8ricngS1qbS/DmygEHOLjUfJqLmkbXc=;
        b=GxE8THis2o3p/F7ka6L+vC9w9GbPdJO2XGp91XlSdMJSfCVG/mMZw6j0Wkpe9GT/Qr
         R+YB1WbO+oeKcfEEiYGEbFzCFLzz9ioU5gfBwn8THWFnQ4gCrFSqHl04Hbe+wy7fu5j9
         7qKzM166R7aiEaGS/KEapiKUuYQxW8w0tt8N18n/OKlqFahcD2EmS3e5Tgayjc19mdBf
         pKgV3jtzvEnhb4cayUukoOo33LFYD/qjzLdsut9UhMYCGbztYuyA2sJs+0pY4KtbJeix
         TtIDa2a4aB6sDSOq2BLM4FhzGIEt/rDmIczzWyPjR3Kbf/3F/h2/rWvq0xvZUzzzaycO
         Mg6Q==
X-Gm-Message-State: ACrzQf2rIbIeecJug2LRN9j+HO9iZLq/Nco+drUmYNp4ZeN4UlwiaKie
        Yf5EzmHszMq5pkGESMiYSonTuSa1/aW2+Q==
X-Google-Smtp-Source: AMsMyM52092vOS4KtpIsEhCL9ehrUvM3YK0nowIodox2T3d1VQtgl6lpjprnkONQyYHvk8VkKaZT3w==
X-Received: by 2002:a17:903:32c1:b0:185:5398:8c66 with SMTP id i1-20020a17090332c100b0018553988c66mr5000643plr.135.1666030830221;
        Mon, 17 Oct 2022 11:20:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902d2ce00b0017f36638010sm6926072plc.276.2022.10.17.11.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 11:20:29 -0700 (PDT)
Date:   Mon, 17 Oct 2022 18:20:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH v5 1/7] kvm: x86/pmu: Correct the mask used in a pmu
 event filter lookup
Message-ID: <Y02c6JdM432f8H+A@google.com>
References: <20220920174603.302510-1-aaronlewis@google.com>
 <20220920174603.302510-2-aaronlewis@google.com>
 <Y0C1c2bBNVF4qxJq@google.com>
 <CAAAPnDEk_bckk0W5C2vKiL4HJVUHFGV3_NqfdbsqYFqpJvuXog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDEk_bckk0W5C2vKiL4HJVUHFGV3_NqfdbsqYFqpJvuXog@mail.gmail.com>
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

On Sat, Oct 15, 2022, Aaron Lewis wrote:
> > And the total patch is:
> >
> > ---
> >  arch/x86/kvm/pmu.c           | 2 +-
> >  arch/x86/kvm/pmu.h           | 2 ++
> >  arch/x86/kvm/svm/pmu.c       | 2 ++
> >  arch/x86/kvm/vmx/pmu_intel.c | 2 ++
> >  4 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index d9b9a0f0db17..d0e2c7eda65b 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -273,7 +273,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
> >                 goto out;
> >
> >         if (pmc_is_gp(pmc)) {
> > -               key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
> > +               key = pmc->eventsel & kvm_pmu_ops.EVENTSEL_MASK;
> >                 if (bsearch(&key, filter->events, filter->nevents,
> >                             sizeof(__u64), cmp_u64))
> >                         allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index 5cc5721f260b..45a7dd24125d 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -40,6 +40,8 @@ struct kvm_pmu_ops {
> >         void (*reset)(struct kvm_vcpu *vcpu);
> >         void (*deliver_pmi)(struct kvm_vcpu *vcpu);
> >         void (*cleanup)(struct kvm_vcpu *vcpu);
> > +
> > +       const u64 EVENTSEL_MASK;
> 
> Agreed, a constant is better.  Had I realized I could do that, that
> would have been my first choice.
> 
> What about calling it EVENTSEL_RAW_MASK to make it more descriptive
> though?  It's a little too generic given there is EVENTSEL_UMASK and
> EVENTSEL_CMASK, also there is precedent for using the term 'raw event'
> for (eventsel+umask), i.e.
> https://man7.org/linux/man-pages/man1/perf-record.1.html.

Hmm.  I'd prefer to avoid "raw" because that implies there's a non-raw version
that can be translated into the "raw" version.  This is kinda the opposite, where
the above field is the composite type and the invidiual fields are the "raw"
components.

Refresh me, as I've gotten twisted about: this mask needs to be EVENTSEL_EVENT_MASK
+ EVENTSEL_UMASK, correct?  Or phrased differently, it'll hold more than just
EVENTSEL_EVENT_MASK?

What about something completely different, e.g. FILTER_MASK?  It'll require a
comment to document, but that seems inevitable, and FILTER_MASK should be really
hard to confuse with the myriad EVENTSEL_*MASK fields.
