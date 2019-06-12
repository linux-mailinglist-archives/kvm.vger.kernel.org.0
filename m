Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA21C419FE
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 03:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406913AbfFLBhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 21:37:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46177 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406864AbfFLBhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 21:37:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so8564615pfy.13;
        Tue, 11 Jun 2019 18:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ydXYegSsk8MFFAKGT3kHy7pToynlZlXFgT5BPbWFhEQ=;
        b=s/iyRl96wWweA0Dc+5vAJ04IgU/jkPqkjOPULxvdeFHMVp6+SB0nh0w7OEkUFKp5V9
         CqWPNijp6hAD9M0TU74Rrz1tAsA3MYm0idF5PRpTN6YzUbknOYuU9pCqixCNJMiAMFx2
         HpS7UHaD3C26iyKheZHbsi1lntzlpMnsft/RNpXtAoLrmTzeyvYsr7Ve5UtA+AXsdUJf
         n1pQllp1zPXVv3t7nzx2mzJfutm1ku3/Gepa8oHqqZCSRXgoA6lIVF6VUE7YGLomaqvh
         68YM/aNYOK84mKzQr3ymkmguwqzd10bLmFwL/5P4MYqY3epnD2kC1tB3jOWIiNR5u4xL
         opGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ydXYegSsk8MFFAKGT3kHy7pToynlZlXFgT5BPbWFhEQ=;
        b=YtBWAeqGEQK2rKnZxzyA9nmcveyWKPadyiDjghomyGDOW9pX0sQKLPuEaXfroQHc5c
         WRP/Y92kzr+T6x39CrfmYE87z90xpCW9u7F98r/ydEwLETFjzyxWUBhJbPwd+BNKiMby
         xHmcgpo2cKOkPvDJn5oAChL0w2IljdP4aNEU3vm8yaVXB54Eqgml1lZXMhWBmrbcj8KD
         qTZtOkpZudax1B5kTo8OYmuX8B7FrFL72FjbJbYb/TWj8bDwsMBGx5i16VtXWjUJyi3+
         ql3Sh36WrzEpysqsG23osYEjoVjpf2ltBE/pV0+Dchh4nWxXBAcul2PRVU2bfM+LT8St
         1NMg==
X-Gm-Message-State: APjAAAUqDN7uHU+JqfYiqndfmwk/MY/3w3ODVR+ee3KHqEEGRaVrUr34
        EdOxpCyLL6H2oFi092PSgsI=
X-Google-Smtp-Source: APXvYqyjjwVLTbzQhufcRUwHewlFSBLfXcxp/O0XaByfHEAHoEOV0wSnUDIiIkKrqFaPb8yjt8rrYw==
X-Received: by 2002:a63:b1d:: with SMTP id 29mr22800685pgl.103.1560303459071;
        Tue, 11 Jun 2019 18:37:39 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id a16sm26653148pfd.68.2019.06.11.18.37.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 18:37:38 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CANRm+Cx6Z=jxLaXqwhBDpVTsKH8mgoo4iC=U8GbAAJz-5gk5ZA@mail.gmail.com>
Date:   Tue, 11 Jun 2019 18:37:36 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <28BF5471-57E8-41FE-B401-D49D57D01A63@gmail.com>
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask> <20190611011100.GB24835@linux.intel.com>
 <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com>
 <F136E492-5350-49EE-A856-FBAEDB12FF99@gmail.com>
 <CANRm+CyZcvuT80ixp9f0FNmjN+rTUtw8MshtBG0Uk4L1B1UjDw@mail.gmail.com>
 <153047ED-75E2-4E70-BC33-C5FF27C08638@gmail.com>
 <CANRm+Cx6Z=jxLaXqwhBDpVTsKH8mgoo4iC=U8GbAAJz-5gk5ZA@mail.gmail.com>
To:     Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 11, 2019, at 6:18 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
>=20
> On Wed, 12 Jun 2019 at 00:57, Nadav Amit <nadav.amit@gmail.com> wrote:
>>> On Jun 11, 2019, at 3:02 AM, Wanpeng Li <kernellwp@gmail.com> wrote:
>>>=20
>>> On Tue, 11 Jun 2019 at 09:48, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>> On Jun 10, 2019, at 6:45 PM, Wanpeng Li <kernellwp@gmail.com> =
wrote:
>>>>>=20
>>>>> On Tue, 11 Jun 2019 at 09:11, Sean Christopherson
>>>>> <sean.j.christopherson@intel.com> wrote:
>>>>>> On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99=
 wrote:
>>>>>>> 2019-05-30 09:05+0800, Wanpeng Li:
>>>>>>>> The idea is from Xen, when sending a call-function IPI-many to =
vCPUs,
>>>>>>>> yield if any of the IPI target vCPUs was preempted. 17% =
performance
>>>>>>>> increasement of ebizzy benchmark can be observed in an =
over-subscribe
>>>>>>>> environment. (w/ kvm-pv-tlb disabled, testing TLB flush =
call-function
>>>>>>>> IPI-many since call-function is not easy to be trigged by =
userspace
>>>>>>>> workload).
>>>>>>>=20
>>>>>>> Have you checked if we could gain performance by having the =
yield as an
>>>>>>> extension to our PV IPI call?
>>>>>>>=20
>>>>>>> It would allow us to skip the VM entry/exit overhead on the =
caller.
>>>>>>> (The benefit of that might be negligible and it also poses a
>>>>>>> complication when splitting the target mask into several PV IPI
>>>>>>> hypercalls.)
>>>>>>=20
>>>>>> Tangetially related to splitting PV IPI hypercalls, are there any =
major
>>>>>> hurdles to supporting shorthand?  Not having to generate the mask =
for
>>>>>> ->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy =
to way
>>>>>> shave cycles for affected flows.
>>>>>=20
>>>>> Not sure why shorthand is not used for native x2apic mode.
>>>>=20
>>>> Why do you say so? native_send_call_func_ipi() checks if allbutself
>>>> shorthand should be used and does so (even though the check can be =
more
>>>> efficient - I=E2=80=99m looking at that code right now=E2=80=A6)
>>>=20
>>> Please continue to follow the apic/x2apic driver. Just apic_flat set
>>> APIC_DEST_ALLBUT/APIC_DEST_ALLINC to ICR.
>>=20
>> Indeed - I was sure by the name that it does it correctly. That=E2=80=99=
s stupid.
>>=20
>> I=E2=80=99ll add it to the patch-set I am working on (TLB shootdown =
improvements),
>> if you don=E2=80=99t mind.
>=20
> Original for hotplug cpu safe.
> https://lwn.net/Articles/138365/
> https://lwn.net/Articles/138368/
> Not sure shortcut native support is acceptable, I will play my
> kvm_send_ipi_allbutself and kvm_send_ipi_all. :)

Yes, I saw these threads before. But I think the test in
native_send_call_func_ipi() should take care of it.

I=E2=80=99ll recheck.=
