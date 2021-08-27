Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6483F9540
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244371AbhH0HlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:41:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231345AbhH0HlG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 03:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630050017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rii/zgRLd6hCVDVQRt0tyZE6ehMX8WY/dl6bs0+yEDI=;
        b=IjX0aBVWRp/3QDYD8PGXMWRB/4XtlZe432PqN8J0xJ4hYFzZSwZgPg+Wkw7YIE93Ok7xT/
        m5rK2FDBXux4EL/9EWQ6DsO2/cgKZgK61WV+nT46W/bPT3IOdad1QNYbf21+PQ9wyI7jm+
        B91ot8zgEWgRljWkRuE7H7bGEqdKndY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-OZcKGQ-XOz-VX3n2n3XdaA-1; Fri, 27 Aug 2021 03:40:15 -0400
X-MC-Unique: OZcKGQ-XOz-VX3n2n3XdaA-1
Received: by mail-ed1-f70.google.com with SMTP id m16-20020a056402511000b003bead176527so2848366edd.10
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 00:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rii/zgRLd6hCVDVQRt0tyZE6ehMX8WY/dl6bs0+yEDI=;
        b=W7EZVBv+2Qs3h//Y1C7w+f+WfL6CBkD/BmKrc35AGAl/7qBclVK05hKb2mempyNnYo
         z+s20z3mhb6bYXkGBmChQvuc2FqXDfTZAlaDyAZ0SohBniBo8Zo4434aajNIg6+e2VWY
         an6oOHX5rLctmYsZdVfKct3OFZdvRNDro6N48J83GrpLU1lVwgHmMDKxlqEA55MI5ymf
         fLxu+UIv/5cLl99REAlEhFepfkQuvOL+WQUaD6pXPXt/7B4D8j+MiE/ldymW6rE9Lo5l
         7xwBq20l4yRi5rzqffxeSHBEqWQXW8/1S5mc2Pnw+mqxpmkS2omTVAuFW0Yie05+YWik
         xM4A==
X-Gm-Message-State: AOAM5332Gx/wXcwPxJqwIRgO+P6EapD4voGmmOLK8qKng8E8IVOgv3Oh
        9YREQ1JSsO5tiVBL5YxFB3FSifdEBdx2komq/BPP8cl8tmI4aH5WAUOvwVwdW3DByPaKmYIOSUP
        FK9nxmtxxJX9i
X-Received: by 2002:a17:906:7802:: with SMTP id u2mr8568592ejm.325.1630050014001;
        Fri, 27 Aug 2021 00:40:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlEI4c4uSGsWYzam6QjM0CnHAaEPMYHwHg4H4eCO8Seu3DwRP7jsyPigOg5ReqAEUGy+6+5A==
X-Received: by 2002:a17:906:7802:: with SMTP id u2mr8568574ejm.325.1630050013822;
        Fri, 27 Aug 2021 00:40:13 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id ca4sm2433570ejb.1.2021.08.27.00.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 00:40:13 -0700 (PDT)
Date:   Fri, 27 Aug 2021 09:40:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        pshier@google.com, ricarkol@google.com, rananta@google.com,
        reijiw@google.com, jingzhangos@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        Alexandru.Elisei@arm.com, suzuki.poulose@arm.com,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: KVM/arm64: Guest ABI changes do not appear rollback-safe
Message-ID: <20210827074011.ci2kzo4cnlp3qz7h@gator.home>
References: <YSVhV+UIMY12u2PW@google.com>
 <87mtp5q3gx.wl-maz@kernel.org>
 <CAOQ_QshSaEm_cMYQfRTaXJwnVqeoN29rMLBej-snWd6_0HsgGw@mail.gmail.com>
 <87fsuxq049.wl-maz@kernel.org>
 <20210825150713.5rpwzm4grfn7akcw@gator.home>
 <CAOQ_QsgWiw9-BuGTUFpHqBw3simUaM4Tweb9y5_oz1UHdr4ELg@mail.gmail.com>
 <877dg8ppnt.wl-maz@kernel.org>
 <YSfiN3Xq1vUzHeap@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSfiN3Xq1vUzHeap@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 06:49:27PM +0000, Oliver Upton wrote:
> On Thu, Aug 26, 2021 at 09:37:42AM +0100, Marc Zyngier wrote:
> > On Wed, 25 Aug 2021 19:14:59 +0100,
> > Oliver Upton <oupton@google.com> wrote:
> > > 
> > > On Wed, Aug 25, 2021 at 8:07 AM Andrew Jones <drjones@redhat.com> wrote:
> > 
> > [...]
> > 
> > > > Thanks for including me Marc. I think you've mentioned all the examples
> > > > of why we don't generally expect N+1 -> N migrations to work that I
> > > > can think of. While some of the examples like get-reg-list could
> > > > eventually be eliminated if we had CPU models to tighten our machine type
> > > > state, I think N+1 -> N migrations will always be best effort at most.
> > > >
> > > > I agree with giving userspace control over the exposer of the hypercalls
> > > > though. Using pseudo-registers for that purpose rather than a pile of
> > > > CAPs also seems reasonable to me.
> > > >
> > > > And, while I don't think this patch is going to proceed, I thought I'd
> > > > point out that the opt-out approach doesn't help much with expanding
> > > > our migration support unless we require the VMM to be upgraded first.
> > > >
> > > > And, even then, the (N_kern, N+1_vmm) -> (N+1_kern, N_vmm) case won't
> > > > work as expected, since the source enforce opt-out, but the destination
> > > > won't.
> > > 
> > > Right, there's going to need to be a fence in both kernel and VMM
> > > versions. Before the fence, you can't rollback with either component.
> > > Once on the other side of the fence, the user may freely migrate
> > > between kernel + VMM combinations.
> > >
> > > > Also, since the VMM doesn't key off the kernel version, for the
> > > > most part N+1 VMMs won't know when they're supposed to opt-out or not,
> > > > leaving it to the user to ensure they consider everything. opt-in
> > > > usually only needs the user to consider what machine type they want to
> > > > launch.
> > > 
> > > Going the register route will implicitly require opt-out for all old
> > > hypercalls. We exposed them unconditionally to the guest before, and
> > > we must uphold that behavior. The default value for the bitmap will
> > > have those features set. Any hypercalls added after that register
> > > interface will then require explicit opt-in from userspace.
> > 
> > I disagree here. This makes the ABI inconsistent, and means that no
> > feature can be implemented without changing userspace. If you can deal
> > with the existing features, you should be able to deal with the next
> > lot.
> >
> > > With regards to the pseudoregister interface, how would a VMM discover
> > > new bits? From my perspective, you need to have two bitmaps that the
> > > VMM can get at: the set of supported feature bits and the active
> > > bitmap of features for a running guest.
> > 
> > My proposal is that we have a single pseudo-register exposing the list
> > of implemented by the kernel. Clear the bits you don't want, and write
> > back the result. As long as you haven't written anything, you have the
> > full feature set. That's pretty similar to the virtio feature
> > negotiation.
> 
> Ah, yes I agree. Thinking about it more we will not need something
> similar to KVM_GET_SUPPORTED_CPUID.
> 
> So then, for any register where userspace/KVM need to negotiate
> features, the default value will return the maximum feature set that is
> supported. If userspace wants to constrain features, read out the
> register, make sure everything you want is there, and write it back
> blowing away the superfluous bits. Given this should we enforce ordering
> on feature registers, such that a VMM can only write to the registers
> before a VM is started?

That's a good idea. KVM_REG_ARM64_SVE_VLS has this type of constraint so
we can model the feature register control off that.

> 
> Also, Reiji is working on making the identity registers writable for the
> sake of feature restriction. The suggested negotiation interface would
> be applicable there too, IMO.

This this interesting news. I'll look forward to the posting.

> 
> Many thanks to both you and Drew for working this out with me.
>

Thanks,
drew 

