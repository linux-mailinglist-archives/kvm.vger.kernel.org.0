Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D754743F23
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbjF3PpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjF3PpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:45:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062EC35B0
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 08:45:07 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5706641dda9so18927787b3.3
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 08:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688139906; x=1690731906;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PGsWok1x7dplsdKnJrrmcBge8O50nAaWvf5Ok5mjPd4=;
        b=eGWMOFM3GXS9tFnRExmbojyXBqlwq1sFNIcYYNt/arDuFYsW3XSFXkF8D7ji6W9HFO
         1t3zqgJECHeAewxekDfmjmiVJhjLuv9owT68r2sk+2anDX2FECxtAgkji45GUi35HryQ
         nILNZhxmPSGqpyMJw0/iGNlrEz4ODnzq5GXM50PzGwrgRZzC+KepSXcT4SAwym9y4qZl
         KHJxFeJS1IJT5FbMPZ1SwsdKgWGMLvYGxOt1AvuRTkQys+iVOHUejAi5cn3k1MnbnVWH
         RmKTPVBNf3EjgUD0yDXkRWnRtwRxM0ZgtC8du3g7YOe+EZkHyNXqogZjC+E7XsLHS5qx
         o7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688139906; x=1690731906;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PGsWok1x7dplsdKnJrrmcBge8O50nAaWvf5Ok5mjPd4=;
        b=E84mvQnz52evagIQEAxjVDhGRwjrEFSBVAycTLLw4KGKqI3c99fjx8dLj2ro2VakOC
         x1TLTiEZXEBpOFOWUu1ljGkOPJAsOqJNH7VDIEkHlIRCZcNKt1uXhgm/6vqxsPYZ4Jnq
         bQZ+i/B2xsRb4ZhUrsjKjHSzrWSHKc9OC3Uogr6xcO7Q5V3MfJD1sNiagju33fKZluW1
         vtQ64Aaw9cDZaCA2gz8GpyHgKMym786h0FfheD8Pbdv1lMA6qXRO4tW95vdPjeN2jwNG
         +xqpVNzAgJYRHoh/WxjU+MMdep7mtKDOJrpk3KDc1J1tNZDMfkZgIrL8g6MqgeL/sViM
         m/rg==
X-Gm-Message-State: ABy/qLb0OhkfNk/lNaFF+DYJMfAaiLukSOFJGsTsGu6t9pKtQUb+OWRg
        5+f+T8ZqD5sCUQvv2RzwMkcmqv52u5o=
X-Google-Smtp-Source: APBJJlHy/+n3gP4uEnSiKJhOURvGBDU9Rhgp1safCbT03R172hS2cwVS+sadpG2Abl+BU20MlcvIRg6EdYs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:760a:0:b0:56c:fce1:7d8d with SMTP id
 r10-20020a81760a000000b0056cfce17d8dmr23323ywc.6.1688139906026; Fri, 30 Jun
 2023 08:45:06 -0700 (PDT)
Date:   Fri, 30 Jun 2023 08:45:04 -0700
In-Reply-To: <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
Mime-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com> <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
Message-ID: <ZJ74gELkj4DgAk4S@google.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
From:   Sean Christopherson <seanjc@google.com>
To:     Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023, Roman Kagan wrote:
> On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote:
> > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wrote:
> > > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
> > > >         return counter & pmc_bitmask(pmc);
> > > >  }
> > > >
> > > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
> > > > +{
> > > > +       if (pmc->perf_event && !pmc->is_paused)
> > > > +               perf_event_set_count(pmc->perf_event, val);
> > > > +
> > > > +       pmc->counter = val;
> > >
> > > Doesn't this still have the original problem of storing wider value than
> > > allowed?
> > 
> > Yes, this was just to fix the counter offset weirdness.  My plan is to apply your
> > patch on top.  Sorry for not making that clear.
> 
> Ah, got it, thanks!
> 
> Also I'm now chasing a problem that we occasionally see
> 
> [3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
> [3939579.462836] Do you have a strange power saving mode enabled?
> [3939579.462836] Dazed and confused, but trying to continue
> 
> in the guests when perf is used.  These messages disappear when
> 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") is
> reverted.  I haven't yet figured out where exactly the culprit is.

Can you reverting de0f619564f4 ("KVM: x86/pmu: Defer counter emulated overflow
via pmc->prev_counter")?  I suspect the problem is the prev_counter mess.
