Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968893E856A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 23:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhHJVf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 17:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbhHJVfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 17:35:54 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6FFC061765
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 14:35:32 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id i13so545670ilm.11
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 14:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lUE6eUMNCnrpO1N7j3rQ1PNPlaJZ7qzSUy+sJRK4FEM=;
        b=vymI9nKeiVsD/NRJcl8MVSTZRXr+NmurSByydqRiTU7iZ9DBAVJbroT+yxxd+bq7Oy
         igWAREU+JhyqdIMg1EuePqGhizukMrpATtdgypIpsOqN7iWmU8IuCrsPyD4v5lL+Ohc6
         JJrc3wSSgUlOkb7j5vX0uL0YG97i8RN2+/mUyAD2k1KeL1XKR+mG8LPKXaRlYB0rz1u+
         GfedsaBcmPk/GeZ1k6qSr7ge9m7C3mgCmFE16JO41FfRjNXfaPVS6A5lVQSptQFtJ+r1
         Km2JKiW92KxdXLH1zuqB/HqcBWT1rntDsmacBSDjXT1A+Fu1ehrpTZXbOuWTkpVA46QX
         bZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lUE6eUMNCnrpO1N7j3rQ1PNPlaJZ7qzSUy+sJRK4FEM=;
        b=CIEdAFVhkTb2OeyOczJFMnGONATjfmpBjCK6Ho9rLciGHeqtaWKFWnvtNDQbEI8jIW
         gn+IRp6zWhNyHUtSJMrAnyKI4lQnp8UcRPinaRTgGCv9O5d6xR7xZntDzQsJYJxHCLON
         2xIvTJZAjlOl2Ijc4v2M3qs/6BKntpk5a3Nbznth0x+eXIxMDdmfzGgfVFznZbfB0EUG
         03lEhtUKQ2sC5IVtQ82KLeWKI2TG8JiqxvRIQYFO7sUEah0pn1Qlm+jDseauVIkPevpH
         q6/qP+oRLhfdV/r/JRJcRhfD/rCIFQ6NOjwU4Q5wyTM6l6zunpZtzO22MKjAuO7CHwqh
         /viA==
X-Gm-Message-State: AOAM532ZBYJJvse6CFRZTMDXdjs4CKDeFnnyVKTbFex40kFjrxe/gjwO
        tBOpPVj8zPYl9M0O0txu01hyni1BkJjGrizG0RiT/A==
X-Google-Smtp-Source: ABdhPJxGYkX9hKhbVd1kniokF5j5+lFbDRHKxwd9lLvSfT9jwnQ29gg7CGwDoEiMqoUq48pxY1ll9zxlhJsfYX8cR10=
X-Received: by 2002:a92:d9ce:: with SMTP id n14mr422309ilq.29.1628631331702;
 Tue, 10 Aug 2021 14:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210806222229.1645356-1-junaids@google.com> <YRG7U3b3ZM17ggp4@google.com>
 <89c2d9da-590b-fb03-405c-4b16f2aff090@redhat.com>
In-Reply-To: <89c2d9da-590b-fb03-405c-4b16f2aff090@redhat.com>
From:   Junaid Shahid <junaids@google.com>
Date:   Tue, 10 Aug 2021 14:34:55 -0700
Message-ID: <CAL-GctE6jm4cYG8VB_mZisiRT-p7=Jppyepd28idsSqBEG7vyg@mail.gmail.com>
Subject: Re: [PATCH] kvm: vmx: Sync all matching EPTPs when injecting nested
 EPT fault
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        jmattson@google.com, bgardon@google.com, pshier@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 10:52 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/08/21 01:33, Sean Christopherson wrote:
> > On Fri, Aug 06, 2021, Junaid Shahid wrote:
> >> When a nested EPT violation/misconfig is injected into the guest,
> >> the shadow EPT PTEs associated with that address need to be synced.
> >> This is done by kvm_inject_emulated_page_fault() before it calls
> >> nested_ept_inject_page_fault(). However, that will only sync the
> >> shadow EPT PTE associated with the current L1 EPTP. Since the ASID
> >
> > For the changelog and the comment, IMO using "vmcs12 EPTP" instead of "L1 EPTP"
> > would add clarity.  I usually think of "L1 EPTP" as vmcs01->eptp and "L2 EPTP"
> > as vmcs02->EPTP.  There are enough EPTPs in play with nested that it'd help to
> > be very explicit.
>
> Or more briefly "EPT12".

Sounds good.

>
> >> is based on EP4TA rather than the full EPTP, so syncing the current
> >> EPTP is not enough. The SPTEs associated with any other L1 EPTPs
> >> in the prev_roots cache with the same EP4TA also need to be synced.
> >
> > No small part of me wonders if we should disallow duplicate vmcs12 EP4TAs in a
> > single vCPU's root cache, e.g. purge existing roots with the same pgd but
> > different role.  INVEPT does the right thing, but that seems more coincidental
> > than intentional.
> >
> > Practically speaking, this only affects A/D bits.  Wouldn't a VMM need to flush
> > the EP4TA if it toggled A/D enabling in order to have deterministic behavior?
> > In other words, is there a real world use case for switching between EPTPs with
> > same EP4TAs but different properties that would see a performance hit if KVM
> > purged unusable cached roots with the same EP4TA?
>
> Probably not, but the complexity wouldn't be much different.
>

I also don't know of a real world use case like that, so either way
would work. But I agree that it likely wouldn't be that much simpler.
So I guess I'll just send a v2 with the clearer terminology, unless
anyone really prefers disallowing duplicate EP4TAs in the root cache.

Thanks,
Junaid
