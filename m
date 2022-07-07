Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC46C56A67A
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 17:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiGGPBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 11:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiGGPAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 11:00:46 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A595A2E7
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 08:00:11 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bf13so5946623pgb.11
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 08:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G6RMx64fqrI6cy8wnDq7cCVBXGQa2iE8832nGbvOALU=;
        b=ClGcyf7bNfMWmujsHhEnF/Xx/hEkZ3Z4FNpagv9TuHYv+rB2ZrPBDQ3fCqMDcsl5pV
         CBeJyBMCvo1pL0B3ydsAuiLbjBQy3W6n77BK0flFoi8TwTj3fM6QXTcHGBAo45VTiNid
         2NBpk0AAyo7f4o8O+bv5GMmY3wjU8BeQOAGTGbgFMpxilBBNWe2ewasP1yAQjQYKrwog
         RG4Y0eQZIV4yDPZzvVNS5TEwLzVSYPbm8VFgW3CGNEPt3iOeBe1ghfM+A5oF428A4PKT
         aEY7SEmSe1WrhzT3r52PQ8ShlbiCd5psG3SZFcHyxH0nxv5tOOzsqPvAWAwhXr7aNfGx
         CXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G6RMx64fqrI6cy8wnDq7cCVBXGQa2iE8832nGbvOALU=;
        b=eQgyiL9pr1Ii9Jh+1MVI78BfWLUpZb526DXiK9MhDOvKEbO9OTVEq1aby3IPSYcnUT
         Do6sS5FkDmmvoqq1vHtWQn3zE5ziZ7hfXZVrdm4664qLSI5P0BBKxIu+97SjlPulilXE
         2QirP5bl4GLfIkZ20c0cC+toBJOkNpLw3B0moLXsKnxKwgVfy8K1g+ZlVHMJ9ChG4jSB
         y/RrKMoB9UBC49Bnj2LxzVqNLxz5AkC3YgETS7TxvkPBoC6OPBsemjhJYM1QtsY8J7Wx
         kYDPu1O6q2Hpc8HbBqtlYQIxjrJmy0mK3mrAIl4qskTR8roGFyU+2fb1TAo/c1t2YRhA
         Dchg==
X-Gm-Message-State: AJIora91mEA9FY36LEJDVRILIuoJU8N4NX/KSJobgRlPL1u9FmPz9AoX
        WxI/7XOR/LEgbV5VSrvYtUcaaQ==
X-Google-Smtp-Source: AGRyM1sLZilIUWyi+X15U+ZBz33Y4xU6niUVQhNo8NYAoBxdUjBtMxFLv/nYuw98P7L3O2d7VJ/Jjw==
X-Received: by 2002:a17:90a:1485:b0:1ec:788e:a053 with SMTP id k5-20020a17090a148500b001ec788ea053mr5500526pja.16.1657206010466;
        Thu, 07 Jul 2022 08:00:10 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016bfea13321sm4242092plk.243.2022.07.07.08.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 08:00:09 -0700 (PDT)
Date:   Thu, 7 Jul 2022 15:00:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Micah Morton <mortonm@chromium.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: Add vfio-platform support for ONESHOT irq forwarding?
Message-ID: <Ysb09r+XXcVZyok4@google.com>
References: <20210125133611.703c4b90@omen.home.shazbot.org>
 <c57d94ca-5674-7aa7-938a-aa6ec9db2830@redhat.com>
 <CAJ-EccPf0+1N_dhNTGctJ7gT2GUmsQnt==CXYKSA-xwMvY5NLg@mail.gmail.com>
 <8ab9378e-1eb3-3cf3-a922-1c63bada6fd8@redhat.com>
 <CAJ-EccP=ZhCqjW3Pb06X0N=YCjexURzzxNjoN_FEx3mcazK3Cw@mail.gmail.com>
 <CAJ-EccNAHGHZjYvT8LV9h8oWvVe+YvcD0dwF7e5grxymhi5Pug@mail.gmail.com>
 <99d0e32c-e4eb-5223-a342-c5178a53b692@redhat.com>
 <31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com>
 <YsXzGkRIVVYEQNE3@google.com>
 <94423bc0-a6d3-f19f-981b-9da113e36432@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94423bc0-a6d3-f19f-981b-9da113e36432@semihalf.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 07, 2022, Dmytro Maluka wrote:
> Hi Sean,
> 
> On 7/6/22 10:39 PM, Sean Christopherson wrote:
> > On Wed, Jul 06, 2022, Dmytro Maluka wrote:
> > > This is not a problem on native, since for oneshot irq we keep the interrupt
> > > masked until the thread exits, so that the EOI at the end of hardirq doesn't
> > > result in immediate re-assert. In vfio + KVM case, however, the host doesn't
> > > check that the interrupt is still masked in the guest, so
> > > vfio_platform_unmask() is called regardless.
> > 
> > Isn't not checking that an interrupt is unmasked the real bug?  Fudging around vfio
> > (or whatever is doing the premature unmasking) bugs by delaying an ack notification
> > in KVM is a hack, no?
> 
> Yes, not checking that an interrupt is unmasked is IMO a bug, and my patch
> actually adds this missing checking, only that it adds it in KVM, not in
> VFIO. :)
> 
> Arguably it's not a bug that VFIO is not checking the guest interrupt state
> on its own, provided that the resample notification it receives is always a
> notification that the interrupt has been actually acked. That is the
> motivation behind postponing ack notification in KVM in my patch: it is to
> ensure that KVM "ack notifications" are always actual ack notifications (as
> the name suggests), not just "eoi notifications".

But EOI is an ACK.  It's software saying "this interrupt has been consumed".
 
> That said, your idea of checking the guest interrupt status in VFIO (or
> whatever is listening on the resample eventfd) makes sense to me too. The
> problem, though, is that it's KVM that knows the guest interrupt status, so
> KVM would need to let VFIO/whatever know it somehow. (I'm assuming we are
> focusing on the case of KVM kernel irqchip, not userspace or split irqchip.)
> So do you have in mind adding something like "maskfd" and "unmaskfd" to KVM
> IRQFD interface, in addition to resamplefd? If so, I'm actually in favor of
> such an idea, as I think it would be also useful for other purposes,
> regardless of oneshot interrupts.

Unless I'm misreading things, KVM already provides a mask notifier, irqfd just
needs to be wired up to use kvm_(un)register_irq_mask_notifier().
