Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D29496675
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 18:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbfHTQdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 12:33:52 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38398 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbfHTQdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 12:33:52 -0400
Received: by mail-pl1-f195.google.com with SMTP id m12so3024126plt.5
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 09:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bWIGZxxgvl4qFKXxWqPgqd0bBeELRf+xZFJ9UvZDToc=;
        b=mqdAf+lxrMO3jA4TtPtqh25bbF5dsGXJTmx/44lvQN6RGjrlb8y9+m6Ndi7hBNr1/M
         VIH+vuRVBRE1Xh5YBa4Occ7otWphwTdCnSdEvKXxpi4kgB010zaMQR+iIwHz9CvqwXXr
         fZ0SSBZwV8oJd/LgogU7m8S7Q94RjTZJLjDc9wSs0J6eOOQ3Jr4ucvjQC/yo1EHbSIMU
         Ih2Spn2PG48RTph9FzYLIUppm5O1csTYU1oZff8gvXMe0ZNKwQP3zGKLB4FcBTSSZxbK
         A3Qw0DTMtiANVytxDh4PFu1Jtm1174MXaHNHso6eQJstsT6qHPixleKSVD+J6mCWwPk0
         eDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bWIGZxxgvl4qFKXxWqPgqd0bBeELRf+xZFJ9UvZDToc=;
        b=ZyOcxqVk+d5TPe+56Hep/pd69F7M9vqoqHDIGjdck6T6caY1C69mWy5qp1ujf3YFRB
         Iob+kVDe3WMh78iKTcG003srnkokpsvZejyf2aMoSDyw854VTDK+hJpGZaQ2dbNgeHdd
         tgIn0jZ2/Mz6y/1XVujPxzQIYaKDmtMI2WsTfjl82bKsrqIBaDbDzKslO+eezQhkotum
         4qSZDr66XIb+0SyQVgxapu3gKGWe9YVXVE4feavWVad+aNIlAvjLvyIqht8YsSM26gG4
         6p/XQh91qliS1tLPg8GEORI4v5yZtcKB3TIzyeAFj6K7g7hpzb6ZSTa+uEYbdtyFhHvq
         eGQw==
X-Gm-Message-State: APjAAAVlZSg8lqmsbkUXZDcvqa7raOepiPJG45mZxANnW16sRjby1W+S
        UZBH8x0PwKJsuDQ5Xzy5e5w=
X-Google-Smtp-Source: APXvYqwIa6skIa//K7AQHga3Qkq4GYwkKMKf6YokYxX+qC3AamfLwEHgFrhTyK7wtd6lAvcWm/74Dg==
X-Received: by 2002:a17:902:7442:: with SMTP id e2mr18551312plt.315.1566318830946;
        Tue, 20 Aug 2019 09:33:50 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id y14sm41168633pfq.85.2019.08.20.09.33.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 09:33:50 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CANRm+Cz_3g9bUwzMzWffZCSayaEKqbx9=J3E7CWMMbQP224h9g@mail.gmail.com>
Date:   Tue, 20 Aug 2019 09:33:46 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Matt Delco <delco@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7C092342-7A13-406F-8E2D-AB357DC73586@gmail.com>
References: <20190819230422.244888-1-delco@google.com>
 <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
 <20190820003700.GH1916@linux.intel.com>
 <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
 <20190820015641.GK1916@linux.intel.com>
 <74C7BC03-99CA-4213-8327-B8D23E3B22AB@gmail.com>
 <CANRm+Cz_3g9bUwzMzWffZCSayaEKqbx9=J3E7CWMMbQP224h9g@mail.gmail.com>
To:     Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Aug 19, 2019, at 10:08 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
>=20
> On Tue, 20 Aug 2019 at 12:10, Nadav Amit <nadav.amit@gmail.com> wrote:
>>> On Aug 19, 2019, at 6:56 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>=20
>>> +Cc Nadav
>>>=20
>>> On Mon, Aug 19, 2019 at 06:07:01PM -0700, Matt Delco wrote:
>>>> On Mon, Aug 19, 2019 at 5:37 PM Sean Christopherson <
>>>> sean.j.christopherson@intel.com> wrote:
>>>>=20
>>>>> On Tue, Aug 20, 2019 at 01:42:37AM +0200, Paolo Bonzini wrote:
>>>>>> On 20/08/19 01:04, Matt delco wrote:
>>>>>>> From: Matt Delco <delco@google.com>
>>>>>>>=20
>>>>>>> Time seems to eventually stop in a Windows VM when using Skype.
>>>>>>> Instrumentation shows that the OS is frequently switching the =
APIC
>>>>>>> timer between one-shot and periodic mode.  The OS is typically =
writing
>>>>>>> to both LVTT and TMICT.  When time stops the sequence observed =
is that
>>>>>>> the APIC was in one-shot mode, the timer expired, and the OS =
writes to
>>>>>>> LVTT (but not TMICT) to change to periodic mode.  No future =
timer
>>>>> events
>>>>>>> are received by the OS since the timer is only re-armed on TMICT
>>>>> writes.
>>>>>>> With this change time continues to advance in the VM.  TBD if =
physical
>>>>>>> hardware will reset the current count if/when the mode is =
changed to
>>>>>>> period and the current count is zero.
>>>>>>>=20
>>>>>>> Signed-off-by: Matt Delco <delco@google.com>
>>>>>>> ---
>>>>>>> arch/x86/kvm/lapic.c | 9 +++++++--
>>>>>>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>>=20
>>>>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>>>>>> index 685d17c11461..fddd810eeca5 100644
>>>>>>> --- a/arch/x86/kvm/lapic.c
>>>>>>> +++ b/arch/x86/kvm/lapic.c
>>>>>>> @@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct kvm_lapic
>>>>> *apic, u32 reg, u32 val)
>>>>>>>           break;
>>>>>>>=20
>>>>>>> -   case APIC_LVTT:
>>>>>>> +   case APIC_LVTT: {
>>>>>>> +           u32 timer_mode =3D apic->lapic_timer.timer_mode;
>>>>>>>           if (!kvm_apic_sw_enabled(apic))
>>>>>>>                   val |=3D APIC_LVT_MASKED;
>>>>>>>           val &=3D (apic_lvt_mask[0] |
>>>>> apic->lapic_timer.timer_mode_mask);
>>>>>>>           kvm_lapic_set_reg(apic, APIC_LVTT, val);
>>>>>>>           apic_update_lvtt(apic);
>>>>>>> +           if (timer_mode =3D=3D APIC_LVT_TIMER_ONESHOT &&
>>>>>>> +               apic_lvtt_period(apic) &&
>>>>>>> +               !hrtimer_active(&apic->lapic_timer.timer))
>>>>>>> +                   start_apic_timer(apic);
>>>>>>=20
>>>>>> Still, this needs some more explanation.  Can you cover this, as =
well as
>>>>>> the oneshot->periodic transition, in kvm-unit-tests' x86/apic.c
>>>>>> testcase?  Then we could try running it on bare metal and see =
what
>>>>> happens.
>>>>=20
>>>> I looked at apic.c and test_apic_change_mode() might already be =
testing
>>>> this.  It sets oneshot & TMICT, waits for the current value to get
>>>> half-way, changes the mode to periodic, and then tries to test that =
the
>>>> value wraps back to the upper half.  It then waits again for the =
half-way
>>>> point, changes the mode back to oneshot, and waits for zero.  After
>>>> reaching zero it does:
>>>>=20
>>>> /* now tmcct =3D=3D 0 and tmict !=3D 0 */
>>>> apic_change_mode(APIC_LVT_TIMER_PERIODIC);
>>>> report("TMCCT should stay at zero", !apic_read(APIC_TMCCT));
>>>>=20
>>>> which seems to be testing that oneshot->periodic won't reset the =
timer if
>>>> it's already zero.  A possible caveat is there's hardly any delay =
between
>>>> the mode change and the timer read.  Emulated hardware will react
>>>> instantaneously (at least as seen from within the VM), but hardware =
might
>>>> need more time to react (though offhand I'd expect HW to be fast =
enough for
>>>> this particular timer).
>>>>=20
>>>> So, it looks like the code might already be ready to run on =
physical
>>>> hardware, and if it has (or does already as part of a regular =
test), then
>>>> that does raise some doubt on what's the appropriate code change to =
make
>>>> this work.
>>>=20
>>> Nadav has been running tests on bare metal, maybe he can weigh in on
>>> whether or not test_apic_change_mode() passes on bare metal.
>>=20
>> These tests pass on bare-metal.
>=20
> Good to know this. In addition, in linux apic driver, during mode
> switch __setup_APIC_LVTT() always sets lapic_timer_period(number of
> clock cycles per jiffy)/APIC_DIVISOR to APIC_TMICT which can avoid the
> issue Matt report. So is it because there is no such stuff in windows
> or the windows version which Matt testing is too old?

I find it kind of disappointing that you (and others) did not try the
kvm-unit-tests of bare-metal. :(

It should be working, once Paolo (ahem..) applies the one pending patch. =
You
do need a serial console though (which is usually available through
ilo/idrac/etc). It should also work with UEFI/kexec, although I did not =
run
such tests.

