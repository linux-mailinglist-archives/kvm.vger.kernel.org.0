Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1655E8D1F
	for <lists+kvm@lfdr.de>; Sat, 24 Sep 2022 15:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiIXN36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Sep 2022 09:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiIXN3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Sep 2022 09:29:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB8C275F4
        for <kvm@vger.kernel.org>; Sat, 24 Sep 2022 06:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664026192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qXr4DOckx0LDMYlOGBYzUKtsg02p6ZUhk0YKodVLz8o=;
        b=bVC63A+cog/bUjKl6V86Nj1cg6nS6K9M3FMXT0FKKlRehjVHxeE4aGwcA2pqOT+ajzDvmw
        2h/xn8Hz+0XDEoPY8vORjevpjcz17fmKalE04H0rOuvxpgvnv3qcL30N+PEaCSIKHMYksX
        XtBUh0MCSEs0H6Uh2KqzILL6P3aS0jQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-39-F7y4LQOfPeelQrNbC0MFyA-1; Sat, 24 Sep 2022 09:29:50 -0400
X-MC-Unique: F7y4LQOfPeelQrNbC0MFyA-1
Received: by mail-qv1-f71.google.com with SMTP id n15-20020ad444af000000b004a2a341ad71so1681409qvt.15
        for <kvm@vger.kernel.org>; Sat, 24 Sep 2022 06:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qXr4DOckx0LDMYlOGBYzUKtsg02p6ZUhk0YKodVLz8o=;
        b=24LQQLHRFsMsM/e4N22U8LNQp5xRSh12iHicJXjrap9nfT07/taXz8g+dLIwabsUny
         Ga4QIu6Qd3Qelzx8IMiZou0nmzY/f1RGR/SkOSrbvLTk7RH89U3p0xcDr/ljBsIIGhyU
         G0ofNH69u3r7bSQOogjgzu6aUeO1lx6Ja3PWXgFm/D1WVoIv4hV+336k0UVLFLPt8vm5
         TnoA3Cwer4i1nF9OVYcwcofm69a1dEa/uNJtwE6AWYvtOFEhoEFkG0wwsJrVDwg/AIod
         BRyw0RBw2AbB4S6YTjL7TFiRu6rpiIH547d+TXP3ALugwdjMrZxEma/MXePq/Eo6RRh4
         S7qg==
X-Gm-Message-State: ACrzQf2UMLzNfcIm9ChpEyvsaR7R843+FSc3Rx/NLUykj94fkaEmFAJ/
        PAck3TQCwyNGhFrcWNfAmvA/RCDquxDB5EELj+Gb/OGIHFwNYpsE3EV/zcAqcKRs7ojbyJ2vCQ8
        1L74R239I+4dM
X-Received: by 2002:a05:620a:404e:b0:6ce:d80e:7813 with SMTP id i14-20020a05620a404e00b006ced80e7813mr8570047qko.421.1664026190199;
        Sat, 24 Sep 2022 06:29:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7BwReIOcrFIDEbMHRQghN+FYjNbq3iIOl2p0fzSRr0eqxGkxb1FAuziFdB8lQzK6tmdQK8mA==
X-Received: by 2002:a05:620a:404e:b0:6ce:d80e:7813 with SMTP id i14-20020a05620a404e00b006ced80e7813mr8570039qko.421.1664026189990;
        Sat, 24 Sep 2022 06:29:49 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id v11-20020a05622a014b00b0035cf0f50d7csm8283880qtw.52.2022.09.24.06.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 06:29:49 -0700 (PDT)
Date:   Sat, 24 Sep 2022 09:29:47 -0400
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
Subject: Re: [PATCH 3/6] KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ORDERED
Message-ID: <Yy8GSwk8vXPTMZU/@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-4-maz@kernel.org>
 <Yy43UM/+qTxc+/qt@x1n>
 <87fsghi2f4.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87fsghi2f4.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 24, 2022 at 09:47:59AM +0100, Marc Zyngier wrote:
> On Fri, 23 Sep 2022 23:46:40 +0100,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Thu, Sep 22, 2022 at 06:01:30PM +0100, Marc Zyngier wrote:
> > > Since x86 is TSO (give or take), allow it to advertise the new
> > > ORDERED version of the dirty ring capability. No other change is
> > > required for it.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/x86/kvm/Kconfig | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > > index e3cbd7706136..eb63bc31ed1d 100644
> > > --- a/arch/x86/kvm/Kconfig
> > > +++ b/arch/x86/kvm/Kconfig
> > > @@ -29,6 +29,7 @@ config KVM
> > >  	select HAVE_KVM_PFNCACHE
> > >  	select HAVE_KVM_IRQFD
> > >  	select HAVE_KVM_DIRTY_RING
> > > +	select HAVE_KVM_DIRTY_RING_ORDERED
> > >  	select IRQ_BYPASS_MANAGER
> > >  	select HAVE_KVM_IRQ_BYPASS
> > >  	select HAVE_KVM_IRQ_ROUTING
> > 
> > Before patch 2-3, we only have HAVE_KVM_DIRTY_RING.
> > 
> > After that, we'll have:
> > 
> > HAVE_KVM_DIRTY_LOG
> > HAVE_KVM_DIRTY_RING
> > HAVE_KVM_DIRTY_RING_ORDERED
> > 
> > I'm wondering whether we can just keep using the old HAVE_KVM_DIRTY_RING,
> > but just declare a new KVM_CAP_DIRTY_LOG_RING_ORDERED only after all memory
> > barrier patches merged (after patch 1).
> 
> The problem is to decide, on a per architecture basis, how to expose
> the old property. I'm happy to key it on being x86 specific, but that
> feels pretty gross, and totally unnecessary for strongly ordered
> architectures (s390?).
> 
> > IIUC it's a matter of whether any of the arch would like to support
> > !ORDERED version of dirty ring at all, but then IIUC we'll need to have the
> > memory barriers conditional too or not sure how it'll help.
> 
> Memory barriers do not affect the semantics of the userspace, while
> the lack thereof do. On strongly ordered architectures,
> acquire/release is usually "free", because that's implied by their
> memory model. If it thus free for these to implement both versions of
> the API.

Right, that's why I thought it won't help.  now I see what you meant,
indeed if without the three config we'll need a x86 ifdef which may not be
as clean as this approach.  Thanks for explaining.

-- 
Peter Xu

