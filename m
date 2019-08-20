Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3AC95894
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 09:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfHTHed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 03:34:33 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36284 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729194AbfHTHed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 03:34:33 -0400
Received: by mail-io1-f68.google.com with SMTP id o9so10167038iom.3
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 00:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sORZs5CqkehDSSjYN2DpG+xZQJMOSuCMbbQp0iKYGJo=;
        b=LpSUZVzIsQFAdHJUuO5WDCqH5xGbIzzK1Vm7h3U+KSPVUQSifSGSog8rLQTWFBqW1z
         s5Q9kOWkAlncwiCnk41wFwhASD+HoAgIZao/daNMpg8cg2km9Y+N3RfO0Exvw+Ljnt+v
         Y2aGe8YxwopUi8zvbckQySfdyH21dZv2lwZ0Yt4R1x72YIMiJ8ljPmzVvsbMd7ZO8hl5
         1slkPzheDrmq1nyASfj6gCdzuo0r26PB+TDjE4L0cpzV3eGvsEB7WNPuUtiFpjVx2TEM
         HVmk4ULEu3rDAHZUW4n9JrPo44h2YOinBxkrsdQ4D87fngFiIFTAPfiSIq+ndpn3fmnH
         3r5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sORZs5CqkehDSSjYN2DpG+xZQJMOSuCMbbQp0iKYGJo=;
        b=jRS9Dce6naXBVHWiROb7K7OeNyLQIEufWPo/vPpuEtgQN6xndlhwUVQZ/wHicb/2bh
         zUnfJpGhv7ArK9WQUhRriZi+/0kkz9CI9g5fasA1To3NMev5UvgixddaqBfxmewQxP3f
         pA7hkKhCavX2cy1VfKmdtXLk29bD2/4DJMSYIxL04Y6QNGYd+bmfe+0TE6dU9aHLxVez
         kLPRbzbarE8vD18PGiKVTIuitoFSrtu9pssu+50BuLZrPnAJ54+gRHuI+GdLWAglvrZW
         QX46XWMF2pGzPUICp6E6Bebl3mlqdtgoiqKksMwqhL/JeGDGN5+A2e5ghBLHP3/53EIQ
         KjVg==
X-Gm-Message-State: APjAAAUwx/P6i2Uh9PKWnFeZmB9RozlMMmjjLPfoEZTz4n9gX+pvVkPa
        MNNDZgQn38rBsT+A+xUCsYKQoSBJ0gXpOwananJy/A==
X-Google-Smtp-Source: APXvYqyNZWUCNM+nTj/mw/bNEUrZsIlwXfmqRM9aCQImN8FONR7U8McG0MkdyThWK2gDLrUh2sTUO28Fh6K+o4ANim0=
X-Received: by 2002:a02:b713:: with SMTP id g19mr2249813jam.77.1566286471913;
 Tue, 20 Aug 2019 00:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190819230422.244888-1-delco@google.com> <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
 <20190820003700.GH1916@linux.intel.com> <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
 <20190820015641.GK1916@linux.intel.com> <74C7BC03-99CA-4213-8327-B8D23E3B22AB@gmail.com>
 <CANRm+Cz_3g9bUwzMzWffZCSayaEKqbx9=J3E7CWMMbQP224h9g@mail.gmail.com>
In-Reply-To: <CANRm+Cz_3g9bUwzMzWffZCSayaEKqbx9=J3E7CWMMbQP224h9g@mail.gmail.com>
From:   Matt Delco <delco@google.com>
Date:   Tue, 20 Aug 2019 00:34:20 -0700
Message-ID: <CAHGX9Vr4HsVowENg8CS9pVWMr2n58H_tJqDX823oAHL++L8yHA@mail.gmail.com>
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 10:09 PM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Tue, 20 Aug 2019 at 12:10, Nadav Amit <nadav.amit@gmail.com> wrote:
> >
> > > On Aug 19, 2019, at 6:56 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > >
> > > +Cc Nadav
> > >
> > > On Mon, Aug 19, 2019 at 06:07:01PM -0700, Matt Delco wrote:
> > >> On Mon, Aug 19, 2019 at 5:37 PM Sean Christopherson <
> > >> sean.j.christopherson@intel.com> wrote:
> > >>
> > >>> On Tue, Aug 20, 2019 at 01:42:37AM +0200, Paolo Bonzini wrote:
> > >>>> On 20/08/19 01:04, Matt delco wrote:
> > >>>>> From: Matt Delco <delco@google.com>
> > >>>>>
> > >>>>> Time seems to eventually stop in a Windows VM when using Skype.
> > >>>>> Instrumentation shows that the OS is frequently switching the APIC
> > >>>>> timer between one-shot and periodic mode.  The OS is typically writing
> > >>>>> to both LVTT and TMICT.  When time stops the sequence observed is that
> > >>>>> the APIC was in one-shot mode, the timer expired, and the OS writes to
> > >>>>> LVTT (but not TMICT) to change to periodic mode.  No future timer
> > >>> events
> > >>>>> are received by the OS since the timer is only re-armed on TMICT
> > >>> writes.
> > >>>>> With this change time continues to advance in the VM.  TBD if physical
> > >>>>> hardware will reset the current count if/when the mode is changed to
> > >>>>> period and the current count is zero.
> > >>>>>
> > >>>>> Signed-off-by: Matt Delco <delco@google.com>
> > >>>>> ---
> > >>>>> arch/x86/kvm/lapic.c | 9 +++++++--
> > >>>>> 1 file changed, 7 insertions(+), 2 deletions(-)
> > >>>>>
> > >>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > >>>>> index 685d17c11461..fddd810eeca5 100644
> > >>>>> --- a/arch/x86/kvm/lapic.c
> > >>>>> +++ b/arch/x86/kvm/lapic.c
> > >>>>> @@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct kvm_lapic
> > >>> *apic, u32 reg, u32 val)
> > >>>>>            break;
> > >>>>>
> > >>>>> -   case APIC_LVTT:
> > >>>>> +   case APIC_LVTT: {
> > >>>>> +           u32 timer_mode = apic->lapic_timer.timer_mode;
> > >>>>>            if (!kvm_apic_sw_enabled(apic))
> > >>>>>                    val |= APIC_LVT_MASKED;
> > >>>>>            val &= (apic_lvt_mask[0] |
> > >>> apic->lapic_timer.timer_mode_mask);
> > >>>>>            kvm_lapic_set_reg(apic, APIC_LVTT, val);
> > >>>>>            apic_update_lvtt(apic);
> > >>>>> +           if (timer_mode == APIC_LVT_TIMER_ONESHOT &&
> > >>>>> +               apic_lvtt_period(apic) &&
> > >>>>> +               !hrtimer_active(&apic->lapic_timer.timer))
> > >>>>> +                   start_apic_timer(apic);
> > >>>>
> > >>>> Still, this needs some more explanation.  Can you cover this, as well as
> > >>>> the oneshot->periodic transition, in kvm-unit-tests' x86/apic.c
> > >>>> testcase?  Then we could try running it on bare metal and see what
> > >>> happens.
> > >>
> > >> I looked at apic.c and test_apic_change_mode() might already be testing
> > >> this.  It sets oneshot & TMICT, waits for the current value to get
> > >> half-way, changes the mode to periodic, and then tries to test that the
> > >> value wraps back to the upper half.  It then waits again for the half-way
> > >> point, changes the mode back to oneshot, and waits for zero.  After
> > >> reaching zero it does:
> > >>
> > >> /* now tmcct == 0 and tmict != 0 */
> > >> apic_change_mode(APIC_LVT_TIMER_PERIODIC);
> > >> report("TMCCT should stay at zero", !apic_read(APIC_TMCCT));
> > >>
> > >> which seems to be testing that oneshot->periodic won't reset the timer if
> > >> it's already zero.  A possible caveat is there's hardly any delay between
> > >> the mode change and the timer read.  Emulated hardware will react
> > >> instantaneously (at least as seen from within the VM), but hardware might
> > >> need more time to react (though offhand I'd expect HW to be fast enough for
> > >> this particular timer).
> > >>
> > >> So, it looks like the code might already be ready to run on physical
> > >> hardware, and if it has (or does already as part of a regular test), then
> > >> that does raise some doubt on what's the appropriate code change to make
> > >> this work.
> > >
> > > Nadav has been running tests on bare metal, maybe he can weigh in on
> > > whether or not test_apic_change_mode() passes on bare metal.
> >
> > These tests pass on bare-metal.
>
> Good to know this. In addition, in linux apic driver, during mode
> switch __setup_APIC_LVTT() always sets lapic_timer_period(number of
> clock cycles per jiffy)/APIC_DIVISOR to APIC_TMICT which can avoid the
> issue Matt report. So is it because there is no such stuff in windows
> or the windows version which Matt testing is too old?

I'm using Windows 10 (May 2019). Multimedia apps on Windows tend to
request higher frequency clocks, and this in turn can affect how the
kernel configures HW timers.  I may need to examine how Windows
typically interacts with the APIC timer and see if/how this changes
when Skype is used.  The frequent timer mode changes are not something
I'd expect a reasonably behaved kernel to do.
