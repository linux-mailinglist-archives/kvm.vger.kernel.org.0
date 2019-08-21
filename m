Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FE496E2B
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 02:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfHUAUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 20:20:10 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40590 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfHUAUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 20:20:10 -0400
Received: by mail-oi1-f193.google.com with SMTP id h21so282367oie.7
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 17:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=McumRoSzhphZvdLPBExwA/sWB6pKSI7y/VbXjwtqeLc=;
        b=dv5EGsEnKIqTsYIDz8nTytGlanQEwDjpE3MgeZ54+uYqbyVWZHW1U0V0OwsLrskz99
         df5CrNKbRhUsfqR9pg8JxVTT2vWOOxnng7aro+5vEpga4dUGhSXguHy5un9hsaFwgVJx
         c4nEpC0DV21jZtBvsycE9KJTQSIGy+yLbhLzDgT7FEnwpfvwLPaTa7NdDahzwRRm2h1X
         cd4A/KkMQ/8iJDUiNc8pGFdsGG8Xur0i73JY9skLSmoG4f0BCo9lXINZkGZg2yiKcrYR
         kJc7zHnf1sa46MFE573XQBZp7hgUNC/IrWqG5u9lcr+OCcXc8SNAS/SupjGd4bCKpehD
         oPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=McumRoSzhphZvdLPBExwA/sWB6pKSI7y/VbXjwtqeLc=;
        b=Dr0FE4lPqIOdU3pBCnCzJXa03oVhupAJn21OYYAaZ7aNgXhsm0cKAx6QbEd9kfQ7mS
         MtMxA9OsHVUFCsXBzmydQVNmpBm6MNsZOWlU2+UwA55UHMh2EJy4jGJ+DhY89pr/Z8mU
         hGWYhxM4+tKJtLKpNGqMAXlZzVKCfWQGy2FgysWHvzoZX/dAeDO3BFtvvSvMNxTW3jd2
         FSR2dtF6H1/l30aafvjUN26rs7nZZkCl11EKrQLCulI4gJDYNUk6B4JfBgJ2MCkRyD6V
         kvqlehezrw/TnazHRxuJLW+H9KGHlZyY5Yvlf5tY3IZ/5WAfK0McR+Ke/JAeit48dBQ3
         5dng==
X-Gm-Message-State: APjAAAVztehyKCxO8s8sOxhPCutLwLPec2cw89JzYZW8qHohMMcZP+jS
        EKzsS/ZLcQtCG6kpIJzPwNeK8Dykk4JI9qQ9g1E=
X-Google-Smtp-Source: APXvYqxQ0MtmBY+k+ep2Pm0sAjak58Ms30uuGDIHVStJzDFi/LEEBhVk43X4V2Kda8iF6R3iTo2M0Fy9k1Hvcy1kbiU=
X-Received: by 2002:aca:c449:: with SMTP id u70mr2056686oif.5.1566346808658;
 Tue, 20 Aug 2019 17:20:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190819230422.244888-1-delco@google.com> <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
 <20190820003700.GH1916@linux.intel.com> <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
 <20190820015641.GK1916@linux.intel.com> <74C7BC03-99CA-4213-8327-B8D23E3B22AB@gmail.com>
 <CANRm+Cz_3g9bUwzMzWffZCSayaEKqbx9=J3E7CWMMbQP224h9g@mail.gmail.com> <7C092342-7A13-406F-8E2D-AB357DC73586@gmail.com>
In-Reply-To: <7C092342-7A13-406F-8E2D-AB357DC73586@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 21 Aug 2019 08:19:37 +0800
Message-ID: <CANRm+CwcLEmNT5VQdPh+H3AmQG+MEyBcV-WwBDeS0ZgJwbiaQg@mail.gmail.com>
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Matt Delco <delco@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Aug 2019 at 00:33, Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Aug 19, 2019, at 10:08 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > On Tue, 20 Aug 2019 at 12:10, Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> On Aug 19, 2019, at 6:56 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >>>
> >>> +Cc Nadav
> >>>
> >>> On Mon, Aug 19, 2019 at 06:07:01PM -0700, Matt Delco wrote:
> >>>> On Mon, Aug 19, 2019 at 5:37 PM Sean Christopherson <
> >>>> sean.j.christopherson@intel.com> wrote:
> >>>>
> >>>>> On Tue, Aug 20, 2019 at 01:42:37AM +0200, Paolo Bonzini wrote:
> >>>>>> On 20/08/19 01:04, Matt delco wrote:
> >>>>>>> From: Matt Delco <delco@google.com>
> >>>>>>>
> >>>>>>> Time seems to eventually stop in a Windows VM when using Skype.
> >>>>>>> Instrumentation shows that the OS is frequently switching the APIC
> >>>>>>> timer between one-shot and periodic mode.  The OS is typically writing
> >>>>>>> to both LVTT and TMICT.  When time stops the sequence observed is that
> >>>>>>> the APIC was in one-shot mode, the timer expired, and the OS writes to
> >>>>>>> LVTT (but not TMICT) to change to periodic mode.  No future timer
> >>>>> events
> >>>>>>> are received by the OS since the timer is only re-armed on TMICT
> >>>>> writes.
> >>>>>>> With this change time continues to advance in the VM.  TBD if physical
> >>>>>>> hardware will reset the current count if/when the mode is changed to
> >>>>>>> period and the current count is zero.
> >>>>>>>
> >>>>>>> Signed-off-by: Matt Delco <delco@google.com>
> >>>>>>> ---
> >>>>>>> arch/x86/kvm/lapic.c | 9 +++++++--
> >>>>>>> 1 file changed, 7 insertions(+), 2 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> >>>>>>> index 685d17c11461..fddd810eeca5 100644
> >>>>>>> --- a/arch/x86/kvm/lapic.c
> >>>>>>> +++ b/arch/x86/kvm/lapic.c
> >>>>>>> @@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct kvm_lapic
> >>>>> *apic, u32 reg, u32 val)
> >>>>>>>           break;
> >>>>>>>
> >>>>>>> -   case APIC_LVTT:
> >>>>>>> +   case APIC_LVTT: {
> >>>>>>> +           u32 timer_mode = apic->lapic_timer.timer_mode;
> >>>>>>>           if (!kvm_apic_sw_enabled(apic))
> >>>>>>>                   val |= APIC_LVT_MASKED;
> >>>>>>>           val &= (apic_lvt_mask[0] |
> >>>>> apic->lapic_timer.timer_mode_mask);
> >>>>>>>           kvm_lapic_set_reg(apic, APIC_LVTT, val);
> >>>>>>>           apic_update_lvtt(apic);
> >>>>>>> +           if (timer_mode == APIC_LVT_TIMER_ONESHOT &&
> >>>>>>> +               apic_lvtt_period(apic) &&
> >>>>>>> +               !hrtimer_active(&apic->lapic_timer.timer))
> >>>>>>> +                   start_apic_timer(apic);
> >>>>>>
> >>>>>> Still, this needs some more explanation.  Can you cover this, as well as
> >>>>>> the oneshot->periodic transition, in kvm-unit-tests' x86/apic.c
> >>>>>> testcase?  Then we could try running it on bare metal and see what
> >>>>> happens.
> >>>>
> >>>> I looked at apic.c and test_apic_change_mode() might already be testing
> >>>> this.  It sets oneshot & TMICT, waits for the current value to get
> >>>> half-way, changes the mode to periodic, and then tries to test that the
> >>>> value wraps back to the upper half.  It then waits again for the half-way
> >>>> point, changes the mode back to oneshot, and waits for zero.  After
> >>>> reaching zero it does:
> >>>>
> >>>> /* now tmcct == 0 and tmict != 0 */
> >>>> apic_change_mode(APIC_LVT_TIMER_PERIODIC);
> >>>> report("TMCCT should stay at zero", !apic_read(APIC_TMCCT));
> >>>>
> >>>> which seems to be testing that oneshot->periodic won't reset the timer if
> >>>> it's already zero.  A possible caveat is there's hardly any delay between
> >>>> the mode change and the timer read.  Emulated hardware will react
> >>>> instantaneously (at least as seen from within the VM), but hardware might
> >>>> need more time to react (though offhand I'd expect HW to be fast enough for
> >>>> this particular timer).
> >>>>
> >>>> So, it looks like the code might already be ready to run on physical
> >>>> hardware, and if it has (or does already as part of a regular test), then
> >>>> that does raise some doubt on what's the appropriate code change to make
> >>>> this work.
> >>>
> >>> Nadav has been running tests on bare metal, maybe he can weigh in on
> >>> whether or not test_apic_change_mode() passes on bare metal.
> >>
> >> These tests pass on bare-metal.
> >
> > Good to know this. In addition, in linux apic driver, during mode
> > switch __setup_APIC_LVTT() always sets lapic_timer_period(number of
> > clock cycles per jiffy)/APIC_DIVISOR to APIC_TMICT which can avoid the
> > issue Matt report. So is it because there is no such stuff in windows
> > or the windows version which Matt testing is too old?
>
> I find it kind of disappointing that you (and others) did not try the
> kvm-unit-tests of bare-metal. :(

Origianlly xen guys confirm the testcase on bare-metal, thanks for
your double confirm.

Regards,
Wanpeng Li
