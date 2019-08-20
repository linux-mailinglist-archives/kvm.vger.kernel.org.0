Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F9F955D3
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 06:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfHTEJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 00:09:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43923 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbfHTEJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 00:09:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id v12so2509966pfn.10
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gnZ0X/QaJ/HDqZ3T8G9L+8VAEPaChw0bP3+iMGqZbUs=;
        b=qBxyaIMQz19MGIirZwGSsWHgpepsooVy/p5DiMwqVfYYkKG0hVG2qqbYpMrCKs/Zb2
         TLaY3XNfaozRin6x7cgI+tjdAwhcr4UfhNc8xe6Cn/yo+ODtKV+Zo69P7LbSguwXfc/I
         ESyGCiv4uDjAlJcGGx4zMdGL8Y4T8yG/NeNvZLPD4Ye/trbE1s+AnH9dpBgZlGmBAkyq
         V2AMVv805QYMhnlxlQ7vh5AN/5dnQFs0PpWwpLAAbLypiND+w1meIVeSK69yFcfa48Ng
         vCzWAVe2Mx2J6H0Ox7v7QQJerK+Jd/zndX253+4U9YfExx1CffImpbkq/3UbG6EM0DMF
         NI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=gnZ0X/QaJ/HDqZ3T8G9L+8VAEPaChw0bP3+iMGqZbUs=;
        b=rC9Tqh4jXVUHbFrPVjGv0iUB3P7MNfnQUTtJqdtCH2Ga44ZEmL32gv1hNdTDdtYxp+
         NNWv4W0nVVp2CVWCMqDRjVBuRFMgQvXpDVglCd26im+LWjEOJLsSwuzpaMYZ9XYLPcOk
         hY4NG2CbOi/Qo2bTkz6zD5SI9MMded5yDz0PMq8lEgK7dFtZuUu+IM2O118EHDRosA4L
         Ezz4Xdi06FHwTPG9NE7PMnjjBx24BLa/CxAPqFD7bQTtYF+MRnpqtS3LhAF+4U/8TDbt
         KCSFHeBrOTXQc8htpTeoCbcF696ZgETiQhPCskko/iLAU5Z8CIzJmU7LFSoN+nUgMojM
         Xq8g==
X-Gm-Message-State: APjAAAX+eEAfDh3V3rBSHw0jnboWXyOvs560NAIQaFG98RU3XQpzuTo/
        7oOQEkTRQQ4NkyXNcGdBF6Q=
X-Google-Smtp-Source: APXvYqyMDLwe6xrAddGhv8sofkfq3aucLfiNtvVt1WkwF7YXbBujfZdIQNq2ZD1IFCF37cyvUzEKXw==
X-Received: by 2002:a17:90a:3be5:: with SMTP id e92mr24693243pjc.86.1566274138845;
        Mon, 19 Aug 2019 21:08:58 -0700 (PDT)
Received: from [10.0.1.12] (c-24-23-137-57.hsd1.ca.comcast.net. [24.23.137.57])
        by smtp.gmail.com with ESMTPSA id e185sm6803370pfa.119.2019.08.19.21.08.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 21:08:58 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190820015641.GK1916@linux.intel.com>
Date:   Mon, 19 Aug 2019 21:08:56 -0700
Cc:     Matt Delco <delco@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <74C7BC03-99CA-4213-8327-B8D23E3B22AB@gmail.com>
References: <20190819230422.244888-1-delco@google.com>
 <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
 <20190820003700.GH1916@linux.intel.com>
 <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
 <20190820015641.GK1916@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Aug 19, 2019, at 6:56 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> +Cc Nadav
>=20
> On Mon, Aug 19, 2019 at 06:07:01PM -0700, Matt Delco wrote:
>> On Mon, Aug 19, 2019 at 5:37 PM Sean Christopherson <
>> sean.j.christopherson@intel.com> wrote:
>>=20
>>> On Tue, Aug 20, 2019 at 01:42:37AM +0200, Paolo Bonzini wrote:
>>>> On 20/08/19 01:04, Matt delco wrote:
>>>>> From: Matt Delco <delco@google.com>
>>>>>=20
>>>>> Time seems to eventually stop in a Windows VM when using Skype.
>>>>> Instrumentation shows that the OS is frequently switching the APIC
>>>>> timer between one-shot and periodic mode.  The OS is typically =
writing
>>>>> to both LVTT and TMICT.  When time stops the sequence observed is =
that
>>>>> the APIC was in one-shot mode, the timer expired, and the OS =
writes to
>>>>> LVTT (but not TMICT) to change to periodic mode.  No future timer
>>> events
>>>>> are received by the OS since the timer is only re-armed on TMICT
>>> writes.
>>>>> With this change time continues to advance in the VM.  TBD if =
physical
>>>>> hardware will reset the current count if/when the mode is changed =
to
>>>>> period and the current count is zero.
>>>>>=20
>>>>> Signed-off-by: Matt Delco <delco@google.com>
>>>>> ---
>>>>> arch/x86/kvm/lapic.c | 9 +++++++--
>>>>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>>>>=20
>>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>>>> index 685d17c11461..fddd810eeca5 100644
>>>>> --- a/arch/x86/kvm/lapic.c
>>>>> +++ b/arch/x86/kvm/lapic.c
>>>>> @@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct kvm_lapic
>>> *apic, u32 reg, u32 val)
>>>>>            break;
>>>>>=20
>>>>> -   case APIC_LVTT:
>>>>> +   case APIC_LVTT: {
>>>>> +           u32 timer_mode =3D apic->lapic_timer.timer_mode;
>>>>>            if (!kvm_apic_sw_enabled(apic))
>>>>>                    val |=3D APIC_LVT_MASKED;
>>>>>            val &=3D (apic_lvt_mask[0] |
>>> apic->lapic_timer.timer_mode_mask);
>>>>>            kvm_lapic_set_reg(apic, APIC_LVTT, val);
>>>>>            apic_update_lvtt(apic);
>>>>> +           if (timer_mode =3D=3D APIC_LVT_TIMER_ONESHOT &&
>>>>> +               apic_lvtt_period(apic) &&
>>>>> +               !hrtimer_active(&apic->lapic_timer.timer))
>>>>> +                   start_apic_timer(apic);
>>>>=20
>>>> Still, this needs some more explanation.  Can you cover this, as =
well as
>>>> the oneshot->periodic transition, in kvm-unit-tests' x86/apic.c
>>>> testcase?  Then we could try running it on bare metal and see what
>>> happens.
>>=20
>> I looked at apic.c and test_apic_change_mode() might already be =
testing
>> this.  It sets oneshot & TMICT, waits for the current value to get
>> half-way, changes the mode to periodic, and then tries to test that =
the
>> value wraps back to the upper half.  It then waits again for the =
half-way
>> point, changes the mode back to oneshot, and waits for zero.  After
>> reaching zero it does:
>>=20
>> /* now tmcct =3D=3D 0 and tmict !=3D 0 */
>> apic_change_mode(APIC_LVT_TIMER_PERIODIC);
>> report("TMCCT should stay at zero", !apic_read(APIC_TMCCT));
>>=20
>> which seems to be testing that oneshot->periodic won't reset the =
timer if
>> it's already zero.  A possible caveat is there's hardly any delay =
between
>> the mode change and the timer read.  Emulated hardware will react
>> instantaneously (at least as seen from within the VM), but hardware =
might
>> need more time to react (though offhand I'd expect HW to be fast =
enough for
>> this particular timer).
>>=20
>> So, it looks like the code might already be ready to run on physical
>> hardware, and if it has (or does already as part of a regular test), =
then
>> that does raise some doubt on what's the appropriate code change to =
make
>> this work.
>=20
> Nadav has been running tests on bare metal, maybe he can weigh in on
> whether or not test_apic_change_mode() passes on bare metal.

These tests pass on bare-metal.

