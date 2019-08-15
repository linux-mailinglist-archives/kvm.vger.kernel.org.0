Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1BE8E362
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 06:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfHOEFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 00:05:06 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46387 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHOEFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 00:05:06 -0400
Received: by mail-ot1-f65.google.com with SMTP id z17so3149624otk.13;
        Wed, 14 Aug 2019 21:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhpSNDDdJjVXj/ea1nbfBdH4ileub7FSt2+byXY5COo=;
        b=dRKfezk6wLD8aeBoV6dH6+vP9uNj1ixyut6Qx2AstL4Y5PpAq14H7YOqmG+p8A+z8D
         0gN0atNkD5mDPadJCGPyINoFRUtUelAe4iZubONrQYxCCr3LLR3wtDlEaPJeWqYpgTq7
         +p0D31Tm61pVtELl/nsBAOxhihrjRFr05jvAfhYK0xzAx08R6DUbq+aOHvrPPfIoX7rj
         y0lDwwgRqbZuCGU4jzX7lF4eYrFNdmvGVKwFbMbjiIrS+0lkRWamMrtacBSuOez0uUvx
         Txsk6yGwGQGpSX3e9ff2dgxs4xC7ieBwS0Mbf/KVgCM1AIsTDeI4J4y611MQXp1UFq2d
         j4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hhpSNDDdJjVXj/ea1nbfBdH4ileub7FSt2+byXY5COo=;
        b=S6Dkd5el8MvSSSy3Rir58l2pobhjt05oABC8VlJap990FZnz19/8E+X1ddACpda8YU
         k18pGFk6bBzDHzPjM47gI7m94wqwmvqz0h8v09ZG+zSslJeroTH9/bdDGD7bLaFnEMg/
         ZVV3EOuKRVlEu0NgKfB/15JxwMoVe4RIRyNgjeO1XDo7yO9RaKylYl5xWdcpcIR7XiZ1
         JkoZCRPsGkGZ9OU65eNqAMVSMXA6XSOFTMq0ow+DGx+gJO8U8H5e4Ch6SFyjfXo++PcQ
         uskaQoSlKWEJkEBktaQVL1ULdoKQ74ntS2jAHwTgGE0KD36HBluI8/8rC3s5UYXUUylM
         GjqQ==
X-Gm-Message-State: APjAAAWsCXIkCTAey4vbwJ1nHucMtUZPvkgSWdZi0aTgQYUOkptgb52L
        YLMb1BiSAle2w7qSFRz2dRZ7LGxKB+icW8PEdXpWqVDS
X-Google-Smtp-Source: APXvYqwCRTwWTw7SR/A8Wq6QJdAx2Jdsxrh64E6D2IWQ6kUf7znfSKE12dj2jIshA0cUhR08ojSDKlBLMIXUh1+TZCI=
X-Received: by 2002:a05:6830:144b:: with SMTP id w11mr2012289otp.185.1565841905602;
 Wed, 14 Aug 2019 21:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <1565329531-12327-1-git-send-email-wanpengli@tencent.com>
 <fad8ceed-8b98-8fc4-5b6a-63bbca4059a8@redhat.com> <CANRm+CwMMUEyZXmiUu5Y8GA=BEUYGLw31CRyZTc2uA+ct4Bamg@mail.gmail.com>
 <ba07fb02-9b55-15e4-d240-24da59e09369@redhat.com>
In-Reply-To: <ba07fb02-9b55-15e4-d240-24da59e09369@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 15 Aug 2019 12:04:48 +0800
Message-ID: <CANRm+CzGNyST4=BtE-eKvjB-PUVVoM-gUC2Np8NH7tm0Gp2_nQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Periodically revaluate appropriate lapic_timer_advance_ns
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Aug 2019 at 20:50, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/08/19 11:06, Wanpeng Li wrote:
> > On Fri, 9 Aug 2019 at 18:24, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 09/08/19 07:45, Wanpeng Li wrote:
> >>> From: Wanpeng Li <wanpengli@tencent.com>
> >>>
> >>> Even if for realtime CPUs, cache line bounces, frequency scaling, presence
> >>> of higher-priority RT tasks, etc can cause different response. These
> >>> interferences should be considered and periodically revaluate whether
> >>> or not the lapic_timer_advance_ns value is the best, do nothing if it is,
> >>> otherwise recaluate again.
> >>
> >> How much fluctuation do you observe between different runs?
> >
> > Sometimes can ~1000 cycles after converting to guest tsc freq.
>
> Hmm, I wonder if we need some kind of continuous smoothing.  Something like

Actually this can fluctuate drastically instead of continuous
smoothing during testing (running linux guest instead of
kvm-unit-tests).

>
>         if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE) {
>                 /* no update for random fluctuations */
>                 return;
>         }
>
>         if (unlikely(timer_advance_ns > 5000))
>                 timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
>         apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>
> and removing all the timer_advance_adjust_done stuff.  What do you think?

I just sent out v2, periodically revaluate and get a minimal
conservative value from these revaluate points. Please have a look. :)

Regards,
Wanpeng Li
