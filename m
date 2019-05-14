Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E2D1E42D
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 23:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfENVzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 17:55:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44958 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfENVzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 17:55:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id z16so216392pgv.11
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 14:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zGsQ7lgpHhpTbszYslBdzxyDCXSizX6+VVJQr1o6b6I=;
        b=Sqp9nGAlWQZ5vX1dxWHDTDuxZAQ8qZWMKHz3Jl8zJhU4HCd4U5LRW6+WrNk+FFVT4m
         hghwxry4xwaDl/HQX8VpDYEsXxjpIc+C5kovvhxiwYCqXTRQef29CxCNWFm1bW5znOQt
         K7SZARGMC8Rt7RfHAn3RpY8sM6daSCeeLH7swaooopzfa3ObMdZ6EWj/nj1LpViuniyi
         4bbhnkKWhoastGyfdBE/DJkoP1Rh8R0rld6KSf2YfFl4gdmjFXNecFeWf9TzQuYX9kSC
         yl5u8Qe4FV0TiiOwcMABkeTC1I2KGOOO/tJlPkFrFplmiajsczCkdhcwsEb9HLfHGJbp
         bZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zGsQ7lgpHhpTbszYslBdzxyDCXSizX6+VVJQr1o6b6I=;
        b=e1z0wQ3SFlz+ndl7Cq0+EF26cnuVF6EsDTPt5hnW6YrDUoF7xMx3DxTvfmQwgLSIby
         TYNBYQ8DKl0EMGHdphsP1Q8AysIhhG4OI042Ahbo/8NpbowcOlPXXUIFcFNQAAWNo3WX
         4UDq9jOO2uUttUa7mpNK0AsTVW7bIOGQ1xiIKpMI0Bu/xUzAgbRSClgIGZ1lVaNlUyOd
         /ilXtLxkSAPBlTGPebeAXn12WA7joEzFUV50SmZ+3aQbzTZRMub9PI9nM8Kbg5pebKZt
         qBa232NJKLPXhj/Bic/ZQ0imh+omPwmNEInDGMLXNMjSViyAqYc6NMSiSpOwiDU7/yPj
         srkA==
X-Gm-Message-State: APjAAAW7bpmbcB6Bqs3DCvy0Jy8zEIhhhJp2FO6wAadlCKrDciS9NxCZ
        sA7vcD+bjqzRBAT8m+o/xC2vLg==
X-Google-Smtp-Source: APXvYqw24l2gqEGsaEZKg5LYXhvlKPM4W+qe2urWfGhhgYhWFa149ACdSpb4zow/e83hwlMY5jdZGg==
X-Received: by 2002:a63:2bc8:: with SMTP id r191mr39777166pgr.72.1557870920728;
        Tue, 14 May 2019 14:55:20 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:bde9:fbad:7d91:52eb? ([2601:646:c200:1ef2:bde9:fbad:7d91:52eb])
        by smtp.gmail.com with ESMTPSA id d15sm116637pfm.186.2019.05.14.14.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 14:55:19 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table entries for percpu buffer
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190514210603.GD1977@linux.intel.com>
Date:   Tue, 14 May 2019 14:55:18 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A1EB80C0-2D88-4DC0-A898-3BED50A4F5A8@amacapital.net>
References: <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com> <20190514070941.GE2589@hirez.programming.kicks-ass.net> <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com> <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net> <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com> <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com> <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com> <20190514170522.GW2623@hirez.programming.kicks-ass.net> <20190514180936.GA1977@linux.intel.com> <CALCETrVzbBLokip5n0KEyG6irH6aoEWqyNODTy8embpXhB1GQg@mail.gmail.com> <20190514210603.GD1977@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 14, 2019, at 2:06 PM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
>> On Tue, May 14, 2019 at 01:33:21PM -0700, Andy Lutomirski wrote:
>> On Tue, May 14, 2019 at 11:09 AM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>> For IRQs it's somewhat feasible, but not for NMIs since NMIs are unblock=
ed
>>> on VMX immediately after VM-Exit, i.e. there's no way to prevent an NMI
>>> from occuring while KVM's page tables are loaded.
>>>=20
>>> Back to Andy's question about enabling IRQs, the answer is "it depends".=

>>> Exits due to INTR, NMI and #MC are considered high priority and are
>>> serviced before re-enabling IRQs and preemption[1].  All other exits are=

>>> handled after IRQs and preemption are re-enabled.
>>>=20
>>> A decent number of exit handlers are quite short, e.g. CPUID, most RDMSR=

>>> and WRMSR, any event-related exit, etc...  But many exit handlers requir=
e
>>> significantly longer flows, e.g. EPT violations (page faults) and anythi=
ng
>>> that requires extensive emulation, e.g. nested VMX.  In short, leaving
>>> IRQs disabled across all exits is not practical.
>>>=20
>>> Before going down the path of figuring out how to handle the corner case=
s
>>> regarding kvm_mm, I think it makes sense to pinpoint exactly what exits
>>> are a) in the hot path for the use case (configuration) and b) can be
>>> handled fast enough that they can run with IRQs disabled.  Generating th=
at
>>> list might allow us to tightly bound the contents of kvm_mm and sidestep=

>>> many of the corner cases, i.e. select VM-Exits are handle with IRQs
>>> disabled using KVM's mm, while "slow" VM-Exits go through the full conte=
xt
>>> switch.
>>=20
>> I suspect that the context switch is a bit of a red herring.  A
>> PCID-don't-flush CR3 write is IIRC under 300 cycles.  Sure, it's slow,
>> but it's probably minor compared to the full cost of the vm exit.  The
>> pain point is kicking the sibling thread.
>=20
> Speaking of PCIDs, a separate mm for KVM would mean consuming another
> ASID, which isn't good.

I=E2=80=99m not sure we care. We have many logical address spaces (two per m=
m plus a few more).  We have 4096 PCIDs, but we only use ten or so.  And we h=
ave some undocumented number of *physical* ASIDs with some undocumented mech=
anism by which PCID maps to a physical ASID.

I don=E2=80=99t suppose you know how many physical ASIDs we have?  And how i=
t interacts with the VPID stuff?
