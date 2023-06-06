Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF372340B
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 02:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjFFA0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 20:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbjFFA0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 20:26:33 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBDE106
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 17:26:32 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53f8167fb04so1733157a12.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 17:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686011192; x=1688603192;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=57xLL5QLpKaW3OXqEodlsTSv1HyOP+9co98ax0v76HY=;
        b=lqEYY1lnfLDxtpmn4kplzYK2jl2f1q3Kos6UryusxG9eQVVIqu7/Ff8GoyG72Tx4ju
         tnhzpT3A9fyaimcyP1o0BPzwwCkO2aV0wdneYijIcMs49wVjSBMiHD1mtSpCCZyiQQAO
         LUgjCG8i0FIuKKyqLzpVGeN2LKI8EMPdntsdX4IXmq2dPh9dC3pba9ANxBHYAP4MwVJW
         fPahOHyICaUDN2W1cKpGuzNLm+cshK4FhAsynaVs3YTgOxE5dRfw7gCKnNE19Q2G6cG2
         0HGc/WBVJIaYDIjaj9x2UOLclL488MA04FJXbwALCu8YCUR91whX23UNEONuypv0g/Ew
         QaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686011192; x=1688603192;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57xLL5QLpKaW3OXqEodlsTSv1HyOP+9co98ax0v76HY=;
        b=Y1Hg0KuTBNKlCdof2kPYc3PfjxQANh0xoY+P17sI0Vd5WQK4eQY/Ovon+W/tQY6q+A
         uCZL/q3r8bafSsMzogFJBpVF0JruNb/hTyNmVkxztXDZd2Qa+3k8OB8Q4hDR2qG3BCdo
         +uf8IPCZU+KAKt+rMaDuwIA8LzAw1w3jI+TKlAAlLgyVgU90cv2vPmSojZu361GLcDq+
         4SS16ZbvpcZDIXoq/5UeLuE+yWcH95HFT4/QfR3+urcrmdWGME9RzcIZULBeCW++3QLP
         2Okh8MWq/shohMBJ5Y64e5bNGLVcO2NW1KODyP4VF0E1QaSbC8MtKrdDcnkLvPfOasbQ
         wrOQ==
X-Gm-Message-State: AC+VfDxFMGkdALQoQWpexud7HDPCK53vzZM3FiyAYdSiLlKjJGgNgNr5
        LHBHmLRzZ2i41eg8XxB2zsA9w6gxWvM=
X-Google-Smtp-Source: ACHHUZ4cvPIdTvtBLYP239DC1Dl4JGNt+zyM+8Rr3NHcHnAYPFoLJF8UpE/Jj96GHIqo16D1tbQCqPGOMPY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1911:0:b0:542:ac5b:f2c8 with SMTP id
 z17-20020a631911000000b00542ac5bf2c8mr10598pgl.6.1686011191788; Mon, 05 Jun
 2023 17:26:31 -0700 (PDT)
Date:   Mon, 5 Jun 2023 17:26:30 -0700
In-Reply-To: <ZGztAF1e5op6FlRQ@u40bc5e070a0153.ant.amazon.com>
Mime-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <de6acc7e-8e7f-2c54-11cc-822df4084719@gmail.com>
 <ZGztAF1e5op6FlRQ@u40bc5e070a0153.ant.amazon.com>
Message-ID: <ZH59NkUHPcgfxJSO@google.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
From:   Sean Christopherson <seanjc@google.com>
To:     Roman Kagan <rkagan@amazon.de>, Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Eric Hankland <ehankland@google.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023, Roman Kagan wrote:
> On Tue, May 23, 2023 at 08:40:53PM +0800, Like Xu wrote:
> > On 4/5/2023 8:00 pm, Roman Kagan wrote:
> > > Performance counters are defined to have width less than 64 bits.  The
> > > vPMU code maintains the counters in u64 variables but assumes the value
> > > to fit within the defined width.  However, for Intel non-full-width
> > > counters (MSR_IA32_PERFCTRx) the value receieved from the guest is
> > > truncated to 32 bits and then sign-extended to full 64 bits.  If a
> > > negative value is set, it's sign-extended to 64 bits, but then in
> > > kvm_pmu_incr_counter() it's incremented, truncated, and compared to the
> > > previous value for overflow detection.
> > 
> > Thanks for reporting this issue. An easier-to-understand fix could be:
> > 
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index e17be25de6ca..51e75f121234 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -718,7 +718,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
> > 
> >  static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
> >  {
> > -       pmc->prev_counter = pmc->counter;
> > +       pmc->prev_counter = pmc->counter & pmc_bitmask(pmc);
> >        pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
> >        kvm_pmu_request_counter_reprogram(pmc);
> >  }
> > 
> > Considering that the pmu code uses pmc_bitmask(pmc) everywhere to wrap
> > around, I would prefer to use this fix above first and then do a more thorough
> > cleanup based on your below diff. What do you think ?
> 
> I did exactly this at first.  However, it felt more natural and easier
> to reason about and less error-prone going forward, to maintain the
> invariant that pmc->counter always fits in the assumed width.

Agreed, KVM shouldn't store information that's not supposed to exist.
