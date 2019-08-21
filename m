Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B891D96E56
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 02:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfHUA0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 20:26:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44219 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfHUA0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 20:26:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id c81so185950pfc.11
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2019 17:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UTGqmxLslzgPS99C6GoPIEDdIK2K/4tbVpIHIHKEwe4=;
        b=R4x9jIU6tEAO8LForYD4ACiWtwfIMSVF1eLXLeVm/ESjjyotBdtlZBp5aw5HBALN7T
         3yEc4PrnuBjCy9SE1F4gc4aNfqYlPpi0SpZU/+wz9JiPhjNIHFQjf1WLxBQDYUyt82yR
         D8yJa05bFkQzvIaReRG4cHdBx0rZQrhe4RzUY+Xdo0rGCRt6QY72i5HnnyIf+gIY0lx6
         rED8S6a8ObmBy3nCtyoD1U3Iz04WnOAGCAvFYAFkEeAjy0VPsP4mWv/JvTeoMpk3qS/k
         QEcuLjFnTtyTqXm55COll4bDRX+MVKjS6RZbFRan0RNrTx14oRx+C1rnIJgsmzaGLqOF
         gy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=UTGqmxLslzgPS99C6GoPIEDdIK2K/4tbVpIHIHKEwe4=;
        b=JY8KpB76AM9Je08Sk1IJUoZUq+akTp01E3mgwz8dw3/SBOiExThXeWyVvikmpxODmj
         xBZEwqojSN7Z7q8uLsEZ9csMb2mDS/l0O6KcxdbxS/hL7GSBiktaUgGFBSQb74xPoz/Q
         DgTGUYV69vrKaGjPV/O7s8m3dgSn/av7rPXbtz0TGCZDBz9uXqaQgZqY3iWejizWt1uw
         OpEJ2EasXo87X/jHc+5IOo7xY9USeeCytBT98BPj5i0O4OUozAcS1E5dHBsrPwAqx2x1
         q7OraZ3bevoKy33pYLqUMhtxFA3s2s7qoh4n3U3/FbFGHZrfYHzOvIu2vXEoHZAig4aB
         4Cyg==
X-Gm-Message-State: APjAAAUxmXeoARBGatNOSzeJLeWwWJ0d2+234yrCFvQKFrUn2oFSVHTp
        c+wE26AP+FALiKGgP5Renv0=
X-Google-Smtp-Source: APXvYqwsO49Md0et4AgGZAX35am7mjqnJ7Np70AG7LKMtdAfaBhqE0cD80vRmvY+cDxU9n+QO4sX1w==
X-Received: by 2002:a63:1d0e:: with SMTP id d14mr27174597pgd.324.1566347191848;
        Tue, 20 Aug 2019 17:26:31 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id 4sm13561466pfe.76.2019.08.20.17.26.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 17:26:31 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CANRm+CwcLEmNT5VQdPh+H3AmQG+MEyBcV-WwBDeS0ZgJwbiaQg@mail.gmail.com>
Date:   Tue, 20 Aug 2019 17:26:29 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Matt Delco <delco@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DB6D66A7-6143-4185-ACD4-326CF7290FC0@gmail.com>
References: <20190819230422.244888-1-delco@google.com>
 <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
 <20190820003700.GH1916@linux.intel.com>
 <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
 <20190820015641.GK1916@linux.intel.com>
 <74C7BC03-99CA-4213-8327-B8D23E3B22AB@gmail.com>
 <CANRm+Cz_3g9bUwzMzWffZCSayaEKqbx9=J3E7CWMMbQP224h9g@mail.gmail.com>
 <7C092342-7A13-406F-8E2D-AB357DC73586@gmail.com>
 <CANRm+CwcLEmNT5VQdPh+H3AmQG+MEyBcV-WwBDeS0ZgJwbiaQg@mail.gmail.com>
To:     Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Aug 20, 2019, at 5:19 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
>=20
> On Wed, 21 Aug 2019 at 00:33, Nadav Amit <nadav.amit@gmail.com> wrote:
>>> On Aug 19, 2019, at 10:08 PM, Wanpeng Li <kernellwp@gmail.com> =
wrote:
>>>=20
>>> On Tue, 20 Aug 2019 at 12:10, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>> On Aug 19, 2019, at 6:56 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>>>=20
>>>>> +Cc Nadav
>>>>>=20
>>>>> On Mon, Aug 19, 2019 at 06:07:01PM -0700, Matt Delco wrote:
>>>>>> On Mon, Aug 19, 2019 at 5:37 PM Sean Christopherson <
>>>>>> sean.j.christopherson@intel.com> wrote:
>>>>>>=20
>>>>>>> On Tue, Aug 20, 2019 at 01:42:37AM +0200, Paolo Bonzini wrote:
>>>>>>>> On 20/08/19 01:04, Matt delco wrote:
>>>>>>>>> From: Matt Delco <delco@google.com>
>>>>>>>>>=20
>>>>>>>>> Time seems to eventually stop in a Windows VM when using =
Skype.
>>>>>>>>> Instrumentation shows that the OS is frequently switching the =
APIC
>>>>>>>>> timer between one-shot and periodic mode.  The OS is typically =
writing
>>>>>>>>> to both LVTT and TMICT.  When time stops the sequence observed =
is that
>>>>>>>>> the APIC was in one-shot mode, the timer expired, and the OS =
writes to
>>>>>>>>> LVTT (but not TMICT) to change to periodic mode.  No future =
timer
>>>>>>> events
>>>>>>>>> are received by the OS since the timer is only re-armed on =
TMICT
>>>>>>> writes.
>>>>>>>>> With this change time continues to advance in the VM.  TBD if =
physical
>>>>>>>>> hardware will reset the current count if/when the mode is =
changed to
>>>>>>>>> period and the current count is zero.
>>>>>>>>>=20
>>>>>>>>> Signed-off-by: Matt Delco <delco@google.com>
>>>>>>>>> ---
>>>>>>>>> arch/x86/kvm/lapic.c | 9 +++++++--
>>>>>>>>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>>>>>=20
>>>>>>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>>>>>>>> index 685d17c11461..fddd810eeca5 100644
>>>>>>>>> --- a/arch/x86/kvm/lapic.c
>>>>>>>>> +++ b/arch/x86/kvm/lapic.c
>>>>>>>>> @@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct =
kvm_lapic
>>>>>>> *apic, u32 reg, u32 val)
>>>>>>>>>          break;
>>>>>>>>>=20
>>>>>>>>> -   case APIC_LVTT:
>>>>>>>>> +   case APIC_LVTT: {
>>>>>>>>> +           u32 timer_mode =3D apic->lapic_timer.timer_mode;
>>>>>>>>>          if (!kvm_apic_sw_enabled(apic))
>>>>>>>>>                  val |=3D APIC_LVT_MASKED;
>>>>>>>>>          val &=3D (apic_lvt_mask[0] |
>>>>>>> apic->lapic_timer.timer_mode_mask);
>>>>>>>>>          kvm_lapic_set_reg(apic, APIC_LVTT, val);
>>>>>>>>>          apic_update_lvtt(apic);
>>>>>>>>> +           if (timer_mode =3D=3D APIC_LVT_TIMER_ONESHOT &&
>>>>>>>>> +               apic_lvtt_period(apic) &&
>>>>>>>>> +               !hrtimer_active(&apic->lapic_timer.timer))
>>>>>>>>> +                   start_apic_timer(apic);
>>>>>>>>=20
>>>>>>>> Still, this needs some more explanation.  Can you cover this, =
as well as
>>>>>>>> the oneshot->periodic transition, in kvm-unit-tests' x86/apic.c
>>>>>>>> testcase?  Then we could try running it on bare metal and see =
what
>>>>>>> happens.
>>>>>>=20
>>>>>> I looked at apic.c and test_apic_change_mode() might already be =
testing
>>>>>> this.  It sets oneshot & TMICT, waits for the current value to =
get
>>>>>> half-way, changes the mode to periodic, and then tries to test =
that the
>>>>>> value wraps back to the upper half.  It then waits again for the =
half-way
>>>>>> point, changes the mode back to oneshot, and waits for zero.  =
After
>>>>>> reaching zero it does:
>>>>>>=20
>>>>>> /* now tmcct =3D=3D 0 and tmict !=3D 0 */
>>>>>> apic_change_mode(APIC_LVT_TIMER_PERIODIC);
>>>>>> report("TMCCT should stay at zero", !apic_read(APIC_TMCCT));
>>>>>>=20
>>>>>> which seems to be testing that oneshot->periodic won't reset the =
timer if
>>>>>> it's already zero.  A possible caveat is there's hardly any delay =
between
>>>>>> the mode change and the timer read.  Emulated hardware will react
>>>>>> instantaneously (at least as seen from within the VM), but =
hardware might
>>>>>> need more time to react (though offhand I'd expect HW to be fast =
enough for
>>>>>> this particular timer).
>>>>>>=20
>>>>>> So, it looks like the code might already be ready to run on =
physical
>>>>>> hardware, and if it has (or does already as part of a regular =
test), then
>>>>>> that does raise some doubt on what's the appropriate code change =
to make
>>>>>> this work.
>>>>>=20
>>>>> Nadav has been running tests on bare metal, maybe he can weigh in =
on
>>>>> whether or not test_apic_change_mode() passes on bare metal.
>>>>=20
>>>> These tests pass on bare-metal.
>>>=20
>>> Good to know this. In addition, in linux apic driver, during mode
>>> switch __setup_APIC_LVTT() always sets lapic_timer_period(number of
>>> clock cycles per jiffy)/APIC_DIVISOR to APIC_TMICT which can avoid =
the
>>> issue Matt report. So is it because there is no such stuff in =
windows
>>> or the windows version which Matt testing is too old?
>>=20
>> I find it kind of disappointing that you (and others) did not try the
>> kvm-unit-tests of bare-metal. :(
>=20
> Origianlly xen guys confirm the testcase on bare-metal, thanks for
> your double confirm.

No worries, I don=E2=80=99t look for a =E2=80=9Cthank you=E2=80=9D note. =
;-)

