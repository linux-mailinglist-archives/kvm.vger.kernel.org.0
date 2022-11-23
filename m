Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCE86369E7
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 20:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiKWTcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 14:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiKWTcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 14:32:17 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0981697D2
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:32:16 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y10so16346955plp.3
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/JSYRp45nEjV0NpaIaBwCx/OzBxrQGFLwnOyHJ2KQsQ=;
        b=s8OfvgPnZeFlN+MKcsaJ4BQ1A78/CHe6DTwXwlFxd+cq3CEOOGmHWj54k67D2pQSVI
         HcvSaZ8EnlJ8Sl6m9Y8l2m6MShw74CVri65DN+DA3T6Pw3h2XDxAzARxJeqS2MBDzoTV
         x632/5JQs36CtojvSNKJ0j8pis5Ym+cT9BMo1fsTG/6+CR3R/B825RSnB3+MiC1ALDlE
         2FnuXlev9RoqKHV4umiuccgSsGaaZvNz/cwVnaMAzCX/H+Q3LtjbdOMNo0VP+XdOfybg
         nNEbSf4TKiudylxLf/N1ihA+8LiK53kAA3eIWDZpaHgVbquWBCCbkKEDdFYwuLwFVRxJ
         2RAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/JSYRp45nEjV0NpaIaBwCx/OzBxrQGFLwnOyHJ2KQsQ=;
        b=NLaB25iMzurdTsTqh+892QAWr5s3890DGh5R/FyQ2o9Eu2dl6hntRL3tT6w7jwWgI1
         HwRUYeJCHijLwng8Cf7J3rQdEdRhtGdy6fxZsz9+EyaF6/4tivfUJEkf7Zv8ZK5Mmc3q
         Oaln7MyykT5pnwU91jxQr/IJ5wNIZYJyA+5KMy2qVSwn5c+Lug1de19AgTub+Gu1Zz1s
         0YmC7holGBwzxdyPIyqrQHXzzOJ0vogdONhriuIOhflger4nAA5c45PPtGS59achxwYr
         M5XFrW4nCsmWH95JNliEJ4Hc8+dUwvJIuXk9BTgBRj30QMH9kSHqCL27dvbYY6hmAtWy
         DDJw==
X-Gm-Message-State: ANoB5pk0QhpA6yuAlF6uGH+9sRpkOLTfiJFIMzfcma2G0mjsS7NRIr2m
        8YWFvhPsPLlkDmTVqPQSm8gOsHc5tmjxGg==
X-Google-Smtp-Source: AA0mqf6Grqi04ifea8b0dB4vvujuaUTtSQ3QcrIP3SYU9fWDTG1AEwnICzMdxnCcDKVJ/1ncPkFnxQ==
X-Received: by 2002:a17:903:234e:b0:188:cfc6:8543 with SMTP id c14-20020a170903234e00b00188cfc68543mr19569090plh.95.1669231935944;
        Wed, 23 Nov 2022 11:32:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v4-20020aa799c4000000b005745481a61dsm1970313pfi.80.2022.11.23.11.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 11:32:14 -0800 (PST)
Date:   Wed, 23 Nov 2022 19:32:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mhal@rbox.co
Subject: Re: [PATCH 2/4] KVM: x86/xen: Compatibility fixes for shared
 runstate area
Message-ID: <Y351Oz8mrGcaAUMg@google.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-2-dwmw2@infradead.org>
 <Y35kwZeS1pXGLNFg@google.com>
 <176c0c26fda9481a4e04c99289bb240a9b3c1ccd.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <176c0c26fda9481a4e04c99289bb240a9b3c1ccd.camel@infradead.org>
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

On Wed, Nov 23, 2022, David Woodhouse wrote:
> On Wed, 2022-11-23 at 18:21 +0000, Sean Christopherson wrote:
> > On Sat, Nov 19, 2022, David Woodhouse wrote:
> ...
> 		/* When invoked from kvm_sched_out() we cannot sleep */
> 		if (atomic)
> 			return;
> ...
> > > +		/*
> > > +		 * Use kvm_gpc_activate() here because if the runstate
> > > +		 * area was configured in 32-bit mode and only extends
> > > +		 * to the second page now because the guest changed to
> > > +		 * 64-bit mode, the second GPC won't have been set up.
> > > +		 */
> > > +		if (kvm_gpc_activate(v->kvm, gpc2, NULL, KVM_HOST_USES_PFN,
> > > +				     gpc1->gpa + user_len1, user_len2))
> > 
> > I believe kvm_gpc_activate() needs to be converted from write_lock_irq() to
> > write_lock_irqsave() for this to be safe.
> 
> Hm, not sure I concur. You're only permitted to call kvm_gpc_activate()
> in a context where you can sleep. Interrupts had better not be disabled
> already, and it had better not need write_lock_irqsave().
> 
> In this particular context, we do drop all locks before calling
> kvm_gpc_activate(), and we don't call it at all in the scheduling-out
> case when we aren't permitted to sleep.

Oh, duh, there's an "if (atomic)" check right above this.

> > Side topic, why do all of these flows disable IRQs?
> 
> The gpc->lock is permitted to be taken in IRQ context by the users of
> the GPC. For example we do this for the shared_info and vcpu_info when
> passing interrupts directly through to the guest via
> kvm_arch_set_irq_inatomic() → kvm_xen_set_evtchn_fast().
> 
> The code path is fairly convoluted but I do believe we get there
> directly from the VFIO IRQ handler, via the custom wakeup handler on
> the irqfd's waitqueue (irqfd_wakeup).

Yeah, I remember finding that flow.

> Now, perhaps a GPC user which knows that *it* is not going to use its
> GPC from IRQ context, could refrain from bothering to disable
> interrupts when taking its own gpc->lock. And that's probably true for
> the runstate area.

This is effectively what I was asking about.

> The generic GPC code still needs to disable interrupts when taking a
> gpc->lock though, unless we want to add yet another flag to control
> that behaviour.

Right.  Might be worth adding a comment at some point to call out that disabling
IRQs may not be strictly required for all users, but it's done for simplicity.
Ah, if/when we add kvm_gpc_lock(), that would be the perfect place to document
the behavior.

Thanks!
