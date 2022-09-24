Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D195A5E8D12
	for <lists+kvm@lfdr.de>; Sat, 24 Sep 2022 15:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiIXNWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Sep 2022 09:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIXNWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Sep 2022 09:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C6A83F26
        for <kvm@vger.kernel.org>; Sat, 24 Sep 2022 06:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664025756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3uxj1+GKvLhjTJsBYDFACeIios9PGOogVxZ0xR9xLAE=;
        b=gRbxmVdxeD/hGcq1h/8NVO8ExmaRd2t3mqORGRO2DqYu93gypK4jkM85V99UrQid/SrIYa
        XTJHqnzlYsaKchvlkVf+7K6GffbMg+1CxwFcQO6NFBNBIjZr3I6FYTthlcCA5Y48bOCed0
        XonSiiHTskfOn/HMM9lbJ9NKeoCFtCg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-501-0lyUYZCWMS6L8onBhhORyQ-1; Sat, 24 Sep 2022 09:22:35 -0400
X-MC-Unique: 0lyUYZCWMS6L8onBhhORyQ-1
Received: by mail-qt1-f198.google.com with SMTP id fy20-20020a05622a5a1400b0035bef08641dso1686759qtb.18
        for <kvm@vger.kernel.org>; Sat, 24 Sep 2022 06:22:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=3uxj1+GKvLhjTJsBYDFACeIios9PGOogVxZ0xR9xLAE=;
        b=0gPSuDsWSJE6Wv7NYnS6w8tEnREUBFKAm4Ji7H93SowPghyB8vB4t8UMF0/3S33iwj
         RVTPkG0dT0kjTycGll8vPZtUOtB5qM9m9eC55mushktQA6Q0UEXGq2O8qLHp9nmb+Ugz
         +Uem+2vWmA7RsjwDvJ22RBVONG5L087YcPO5NW60NIgsiEAXgZkD2cb9mJpScppcftXJ
         PYGz2Krbg2sFZKTEQfYLxiKK5KPYgaPda/2MTBTGtz7VmD8JgJSeMEZ6BkOmTc0VwJDj
         QBzpmQbJxiz2RfEnckuuRH/P09qaOyGjQeeB0zhi+xvNN425W0778D67Wptbn/hkj+dM
         DbbQ==
X-Gm-Message-State: ACrzQf2Ues8XP6ob+dsZvmr72V/UVgc9pVd9FzZRnp9lfG+evLq53R9E
        z6hV7w1Y+gXGinSWeX2DUhW4ld/nQwdLNzCiMgRhdXyq3/sO+t9qOVZtrv7Eq9+VwhTbIbzQl5P
        ykuWQ9ouYdk9X
X-Received: by 2002:ae9:efc9:0:b0:6cb:e321:12fb with SMTP id d192-20020ae9efc9000000b006cbe32112fbmr8522657qkg.446.1664025754894;
        Sat, 24 Sep 2022 06:22:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5YA1JL1/uDMHUoxAlHxScMC7JDEiu9eEbcqunQtBxM+ofG9JVSf89kU1SBvFY6Em2al/iirQ==
X-Received: by 2002:ae9:efc9:0:b0:6cb:e321:12fb with SMTP id d192-20020ae9efc9000000b006cbe32112fbmr8522645qkg.446.1664025754653;
        Sat, 24 Sep 2022 06:22:34 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id s2-20020a05620a29c200b006ce40fbb8f6sm7649270qkp.21.2022.09.24.06.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 06:22:34 -0700 (PDT)
Date:   Sat, 24 Sep 2022 09:22:32 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        gshan@redhat.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
Message-ID: <Yy8EmMhF+2jcm3m6@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
 <YyzYI/bvp/JnbcxS@xz-m1.local>
 <87czbmjhbh.wl-maz@kernel.org>
 <Yy36Stppz4tYBPiP@x1n>
 <87edw1i290.wl-maz@kernel.org>
 <87czblhv2a.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87czblhv2a.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 24, 2022 at 12:26:53PM +0100, Marc Zyngier wrote:
> On Sat, 24 Sep 2022 09:51:39 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Fri, 23 Sep 2022 19:26:18 +0100,
> > Peter Xu <peterx@redhat.com> wrote:
> > > 
> > > On Fri, Sep 23, 2022 at 03:28:34PM +0100, Marc Zyngier wrote:
> > > > On Thu, 22 Sep 2022 22:48:19 +0100,
> > > > Peter Xu <peterx@redhat.com> wrote:
> > > > > 
> > > > > On Thu, Sep 22, 2022 at 06:01:29PM +0100, Marc Zyngier wrote:
> > > > > > In order to differenciate between architectures that require no extra
> > > > > > synchronisation when accessing the dirty ring and those who do,
> > > > > > add a new capability (KVM_CAP_DIRTY_LOG_RING_ORDERED) that identify
> > > > > > the latter sort. TSO architectures can obviously advertise both, while
> > > > > > relaxed architectures most only advertise the ORDERED version.
> > > > > > 
> > > > > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > > > ---
> > > > > >  include/linux/kvm_dirty_ring.h |  6 +++---
> > > > > >  include/uapi/linux/kvm.h       |  1 +
> > > > > >  virt/kvm/Kconfig               | 14 ++++++++++++++
> > > > > >  virt/kvm/Makefile.kvm          |  2 +-
> > > > > >  virt/kvm/kvm_main.c            | 11 +++++++++--
> > > > > >  5 files changed, 28 insertions(+), 6 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> > > > > > index 906f899813dc..7a0c90ae9a3f 100644
> > > > > > --- a/include/linux/kvm_dirty_ring.h
> > > > > > +++ b/include/linux/kvm_dirty_ring.h
> > > > > > @@ -27,7 +27,7 @@ struct kvm_dirty_ring {
> > > > > >  	int index;
> > > > > >  };
> > > > > >  
> > > > > > -#ifndef CONFIG_HAVE_KVM_DIRTY_RING
> > > > > > +#ifndef CONFIG_HAVE_KVM_DIRTY_LOG
> > > > > 
> > > > > s/LOG/LOG_RING/ according to the commit message? Or the name seems too
> > > > > generic.
> > > > 
> > > > The commit message talks about the capability, while the above is the
> > > > config option. If you find the names inappropriate, feel free to
> > > > suggest alternatives (for all I care, they could be called FOO, BAR
> > > > and BAZ).
> > > 
> > > The existing name from David looks better than the new one.. to me.
> > 
> > I'm happy to bikeshed, but please spell it out for me. If we follow
> > the current scheme, we need 3 configuration symbols (of which we
> > already have one), and 2 capabilities (of which we already have one).

I hope it's not bikeshedding.  I normally don't comment on namings at all
because many of them can be "bikeshedding" to me.  But this one is so
special because it directly collides with KVM_GET_DIRTY_LOG, which is other
method of dirty tracking.

> > 
> > Do you have any concrete proposal for those?
> 
> In order to make some forward progress, I've reworked the series[1]
> with another proposal for those:
> 
> Config symbols:
> 
> - HAVE_KVM_DIRTY_RING:
>   * mostly the same meaning as today
>   * not directly selected by any architecture
>   * doesn't expose any capability on its own
> 
> - HAVE_KVM_DIRTY_RING_TSO:
>   * only for strongly ordered architectures
>   * selects HAVE_KVM_DIRTY_RING
>   * exposes KVM_CAP_DIRTY_LOG_RING
>   * selected by x86
> 
> - HAVE_KVM_DIRTY_RING_ACQ_REL:
>   * selects HAVE_KVM_DIRTY_RING
>   * exposes KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>   * selected by arm64 and x86
> 
> Capabilities:
> 
> - KVM_CAP_DIRTY_LOG_RING: the good old x86-specific stuff, advertised
>   when HAVE_KVM_DIRTY_RING_TSO is selected
> 
> - KVM_CAP_DIRTY_LOG_RING_ACQ_REL: the new acquire/release semantics,
>   advertised when HAVE_KVM_DIRTY_RING_ACQ_REL is selected
> 
> This significantly reduces the churn and makes things slightly more
> explicit.

This looks good to me, thanks.

-- 
Peter Xu

