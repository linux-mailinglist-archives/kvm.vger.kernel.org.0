Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877A91D5AB3
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 22:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgEOUa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 16:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgEOUa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 16:30:57 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C39C061A0C
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 13:30:56 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id h15so3300385edv.2
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 13:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hUCVMuHXs0gz5/bBsK6N/3IhWm9s0JvgcPi6ACbO0XI=;
        b=YLikBlNaBN75qIWlarSaxA8UqsDQlwX6b1YP+d64bWsW/TnwNaWR4y1xNDNxtwCWE/
         cO6PxrQ/dxKvKf1e6SYFRvjjN51E0YdDO05PyCYXp4DDssN9I+wkKyWIyUH1FNYgNziN
         vZXieDpw/ScutGgFV6lLn57QLceJjmDHJWjGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hUCVMuHXs0gz5/bBsK6N/3IhWm9s0JvgcPi6ACbO0XI=;
        b=p/I7tDuaP+50GaFQKcOK9stdsafXylw/ujWbS4vRn2azlxcokuWfD9Svr5CQaVZs8U
         k0hJoXKGvmBD81iKgX96eaCr4m5JZgP9iNJAlHUJnCqqzJvuIeaBcdz9di2pP/FnscTj
         VoSUF3jYe2RihJ2RZjDR/XCxhMlXJ+vwlK+uAbYb0/sIuWYfc546UCbTE5yKsORK0tdM
         vpHObAwcZ9RQF+mFuihu/WphrsK3AQpnyMPzrCkIYqcUakm+frFbzGZByUHSRGSOzOXe
         zmtpt4v7FdA+fdqZcSHNkiYMCmbHfmYwH5RKdLMMrPB3+WYexJf9jpVyTwgTOgHj8z8e
         3rTg==
X-Gm-Message-State: AOAM530UpvrqaB0cZTAB3UtfrYUgLE6RK6GCrkhDAXCCDHgLSIn/PLwh
        xB++HldJZcE9Yk+jw/oT6M3oDj/RqwKyGzfTS2kdag==
X-Google-Smtp-Source: ABdhPJx9/s7+9UIoNxTI9MKtsfxRtN5gkD3j3tqbr38FauP7wjlCecAfgC5CxYQIz0HnAh6baAhBD8w3oMumnocMGy0=
X-Received: by 2002:aa7:dc49:: with SMTP id g9mr4578021edu.167.1589574655508;
 Fri, 15 May 2020 13:30:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200511220046.120206-1-mortonm@chromium.org> <20200512111440.15caaca2@w520.home>
 <92fd66eb-68e7-596f-7dd1-f1c190833be4@redhat.com> <20200513083401.11e761a7@x1.home>
 <8c0bfeb7-0d08-db74-3a23-7a850f301a2a@redhat.com> <CAJ-EccPjU0Lh5gEnr0L9AhuuJTad1yHX-BzzWq21m+e-vY-ELA@mail.gmail.com>
 <0fdb5d54-e4d6-8f2f-69fe-1b157999d6cd@redhat.com> <CAJ-EccP6GNmyCGJZFfXUo2_8KEN_sJZ3=88f+3E-8SJ=JT8Pcg@mail.gmail.com>
 <9d5d7eec-77dd-bca9-949f-8f39fcd7d8d7@redhat.com> <20200514164327.72734a77@w520.home>
In-Reply-To: <20200514164327.72734a77@w520.home>
From:   Micah Morton <mortonm@chromium.org>
Date:   Fri, 15 May 2020 13:30:43 -0700
Message-ID: <CAJ-EccPU8KpU96PM2PtroLjdNVDbvnxwKwWJr2B+RBKuXEr7Vw@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: Add module for IRQ forwarding
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 3:43 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Thu, 14 May 2020 23:17:29 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> > On 14/05/20 19:44, Micah Morton wrote:
> > > I realize this may seem like an over-use of VFIO, but I'm actually
> > > coming from the angle of wanting to assign _most_ of the important
> > > hardware on my device to a VM guest, and I'm looking to avoid
> > > emulation wherever possible. Of course there will be devices like the
> > > IOAPIC for which emulation is unavoidable, but I think emulation is
> > > avoidable here for the busses we've mentioned if there is a way to
> > > forward arbitrary interrupts into the guest.
> > >
> > > Since all these use cases are so close to working with vfio-pci right
> > > out of the box, I was really hoping to come up with a simple and
> > > generic solution to the arbitrary interrupt problem that can be used
> > > for multiple bus types.
> >
> > I shall defer to Alex on this, but I think the main issue here is that
> > these interrupts are not visible to Linux as pertaining to the pci-stub
> > device.  Is this correct?
>
> Yes.  Allowing a user to grant themselves access to an arbitrary
> interrupt is a non-starter, vfio-pci needs to somehow know that the
> user is entitled to that interrupt.  If we could do that, then we could
> just add it as a device specific interrupt.  But how do we do that?
>
> The quirk method to this might be to key off of the PCI vendor and
> device ID of the PCI i2c controller, lookup DMI information to know if
> we're on the platform that has this fixed association, and setup the
> extra interrupt.  The more extensible, but potentially bloated solution
> might be for vfio-pci to recognize the class code for a i2c controller
> and implement a very simple bus walk at device probe time that collects
> external dependencies.  I don't really know how the jump is made from
> that bus walk to digging the interrupt resource out of ACPI though or
> how many LoC would be required to perform the minimum possible
> discovery to collect this association.

The quirk method is interesting. I wonder if we have a guarantee for a
given platform and PCI vendor/device which IRQ number/type will be
used. If so that might be an option.

Would you need to do a bus walk? I guess it would be possible to
simply look at ACPI whenever you see a bus controller being assigned
with VFIO. ACPI should tell you about all the sub-devices on that bus
and their IRQ details. This is how vfio-platform (with DT, not ACPI)
knows which IRQs to forward into the guest right? Is there a
fundamental reason this is more difficult on x86 or is the code just
not there since PCI generally precludes the need for this?

>
> I notice in this RFC patch that you're using an exclusive interrupt for
> level triggered interrupts and therefore masking at the APIC.
> Requiring an exclusive interrupt is often a usability issue for PCI
> devices that don't support DisINTx and obviously we don't have that for
> non-PCI sub-devices.  What type of interrupt do you actually need for
> this device?  Thanks,

I don't have any reason to think the interrupts for sub-devices on the
bus would be shared with any other PCI devices or platform devices.
Are you asking if there's any chance the platform IRQs are shared
rather than exclusive or are you saying there's some issue with
presenting the exclusive IRQ to the guest as exclusive through PCI
legacy-style interrupts?

>
> Alex
>
