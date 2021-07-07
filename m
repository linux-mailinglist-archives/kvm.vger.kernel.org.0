Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D903BEC86
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 18:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhGGQtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 12:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhGGQtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 12:49:51 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09299C06175F
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 09:47:11 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id f93-20020a9d03e60000b02904b1f1d7c5f4so2062297otf.9
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 09:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YyRaH5Oo6J22wOM9JZwFBLlP8kDCJOpC1JZ+Dxo4FQs=;
        b=ZcW/PvVBty3Je/jJ5jHA/UQDZC+bFqnRDU+Ez0NYaUH8/N4X74MkZ1Ijz72PQ/Ftam
         Wrt36wKUJl/t4W+BBSapmEi8mLM0xjKH1/8WtmYkqk7DHhLmkhq/aomPPxx6oEBeERfR
         nssMMu/dYSlRefhmYsedpodJxMPXOx3DcmrR/16NmRJjjTXjvtKLusO0fS9v+wilbpGB
         0pw9tNvseR8EHT9Bqg4K0vmsUi83L97jFsodabh4ZQK9lwwbcqGyKV6Zd+4CtZARrPjP
         UMSu1cZtJu62KrmIYZQNtMAV5zrY26koQiuWB1Ctv2XRjqVEZ1ed6Z8Td8o8UPFzf0B/
         Kaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YyRaH5Oo6J22wOM9JZwFBLlP8kDCJOpC1JZ+Dxo4FQs=;
        b=ukRRHomw4pkuyTainsEvAopuB8jhSkge4ZUZwz+jL/ELiSaZhWxe/FAu2B8VZe3vvc
         5lF5apJGleUwlJuZlU4R3sIn1iAhaszBQ/mUQkmDK/W5M+fcWX8NI+iHH1sQZ/XSTg6k
         5PUWFq5Cxgj72y+0lUXNR53c6OonnkVce8ThIJew3i8+o3tjM8SL89HHGdFt78r9tOEh
         XbNmVJEuIhQZ3GAuFFmDsBAj+3lg+MwziwBXECROorEQ3Y/gchCkCooY4xA8OD0iQiVp
         pL1vyuVuI8BeVODh1jApsn7cUDWaFVXuAHm7iwL7EZy2DYV9UszxUOgNUoH91mHlC6jL
         IGng==
X-Gm-Message-State: AOAM532Zl/qGfys60daMgR0JZfToMPX7UXAHDoKFKo6c7qCgO72OhaVi
        jWok0a2inOSwU+NGjeNoKz/KlXCVXsG/LWw+9TwuaA==
X-Google-Smtp-Source: ABdhPJz3dz9+RLMqVQ9IdeABlYDId89QfpQyvLnvzwJuuYkAWk1g69TJPnwWNdgpMErZEBtL5ri5DL0mIbJJ49y+qj8=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr20885719oth.241.1625676430135;
 Wed, 07 Jul 2021 09:47:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210628124814.1001507-1-stsp2@yandex.ru> <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
 <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
 <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru> <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
 <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru> <6c0a0ffe6103272b648dbc3099f0445d5458059b.camel@redhat.com>
 <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru> <CALMp9eQo6aUCz6+KOWJLhOXJET+4HHVA-HyhjHzAjnfFgTec4Q@mail.gmail.com>
 <6b263403-f959-6d9a-2bbe-15a684df6f50@yandex.ru>
In-Reply-To: <6b263403-f959-6d9a-2bbe-15a684df6f50@yandex.ru>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 7 Jul 2021 09:46:58 -0700
Message-ID: <CALMp9eRk1x-yTragM8OdQP3VSesVOAzezBs4acbqdiJz=nW-Qw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     stsp <stsp2@yandex.ru>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 7, 2021 at 9:34 AM stsp <stsp2@yandex.ru> wrote:
>
> 07.07.2021 19:16, Jim Mattson =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Tue, Jul 6, 2021 at 4:06 PM stsp <stsp2@yandex.ru> wrote:
> >> 07.07.2021 02:00, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>> On Wed, 2021-07-07 at 00:50 +0300, stsp wrote:
> >>>> 06.07.2021 23:29, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>> On Tue, 2021-07-06 at 15:06 +0300, stsp wrote:
> >>>>>> 06.07.2021 14:49, Maxim Levitsky =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>>>> Now about the KVM's userspace API where this is exposed:
> >>>>>>>
> >>>>>>> I see now too that KVM_SET_REGS clears the pending exception.
> >>>>>>> This is new to me and it is IMHO *wrong* thing to do.
> >>>>>>> However I bet that someone somewhere depends on this,
> >>>>>>> since this behavior is very old.
> >>>>>> What alternative would you suggest?
> >>>>>> Check for ready_for_interrupt_injection
> >>>>>> and never call KVM_SET_REGS if it indicates
> >>>>>> "not ready"?
> >>>>>> But what if someone calls it nevertheless?
> >>>>>> Perhaps return an error from KVM_SET_REGS
> >>>>>> if exception is pending? Also KVM_SET_SREGS
> >>>>>> needs some treatment here too, as it can
> >>>>>> also be called when an exception is pending,
> >>>>>> leading to problems.
> >>>>> As I explained you can call KVM_GET_VCPU_EVENTS before calling
> >>>>> KVM_SET_REGS and then call KVM_SET_VCPU_EVENTS with the struct
> >>>>> that was filled by KVM_GET_VCPU_EVENTS.
> >>>>> That will preserve all the cpu events.
> >>>> The question is different.
> >>>> I wonder how _should_ the KVM
> >>>> API behave when someone calls
> >>>> KVM_SET_REGS/KVM_SET_SREGS
> >>> KVM_SET_REGS should not clear the pending exception.
> >>> but fixing this can break API compatibilitly if some
> >>> hypervisor (not qemu) relies on it.
> >>>
> >>> Thus either a new ioctl is needed or as I said,
> >>> KVM_GET_VCPU_EVENTS/KVM_SET_VCPU_EVENTS can be used
> >>> to preserve the events around that call as workaround.
> >> But I don't need to preserve
> >> events. Canceling is perfectly
> >> fine with me because, if I inject
> >> the interrupt at that point, the
> >> exception will be re-triggered
> >> anyway after interrupt handler
> >> returns.
> > The exception will not be re-triggered if it was a trap,
> But my assumption was that
> everything is atomic, except
> PF with shadow page tables.
> I guess you mean the cases
> when the exception delivery
> causes EPT fault, which is a bit
> of a corner case.

No, that's not what I mean. Consider the #DB exception, which is
intercepted in all configurations to circumvent a DoS attack. Some #DB
exceptions modify DR6. Once the exception has been 'injected,' DR6 has
already been modified. If you do not complete the injection, but you
deliver an interrupt instead, then the interrupt handler can see a DR6
value that is architecturally impossible.
