Return-Path: <kvm+bounces-41874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 44537A6E6E7
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 23:54:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C46007A5F90
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EA81F0980;
	Mon, 24 Mar 2025 22:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TSuXWiQ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0CF1EF0A1
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742856877; cv=none; b=kXsJZOJO577+5/mXjPAyBa6n+tI8CBE5cdYdUAU2ZqQc7XxhB3ss+Uv9YRH05PNXYuT9Wsy95AotR2Ix43OvpL7fNFY+0wikJD1RolRL8AtHa5UAzD0C8WABwz050V8AIZ/Xymu3hzkbBVPzd8ZeG0vVuZ6wJrBMNCwULUQvjTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742856877; c=relaxed/simple;
	bh=H/KbU9bNZPSdTUDBAgDADPKvsO4zVTxptFjNZFV9tZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZoK+ob3WD5c0vCL4gQqwgMdFZrkq6XWQr0Zer2g4sT2bcLBbPR1jmIoPxg9BGtGs1fhuX01j444SFOegoxNVjYL8KGMcI1acqISgK3gfU0KBQoOSjDyT5tnatE0svTus3s3/PgaL9fPBsCR1myfeAYSb4ZMdEHCcfZ036096j+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TSuXWiQ2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff52e1c56fso13152547a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 15:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742856874; x=1743461674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wbsrCW8dqSE0zO5n1Ik72zuJrrYpxKr+BDPKgcfDXD4=;
        b=TSuXWiQ2HifeF0GIIF+bjBXNIG8noUs44d1oBG7xRdgIYlU4Hg1BV08yAK5hCOdql0
         vh4w6ZauARC/FvUoCXHvEx+z5MvXW6NoRoz+1x0n2ZQKBrM2c8pRZ/fx2t+KI10Z12zy
         5aNCQT2IWZP1Q4jklqsuo5jRX6UWSPyXeDmW9dD1o9zP7cmTLkdzmxai/PEvZKrZmj/A
         98Vt3UOV+92OhooLA3zUOM5lz1PsqHot8ZyuV9nWtHX6C6x1wc4iF7Nf0DA1An2fYFds
         aJQQSoBXm2CkXbAOoB1JVb1mnU4DabEiN8k8ScM+iYrR2rQYbWWsOeL5iOEf88xzVmI+
         rDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742856874; x=1743461674;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wbsrCW8dqSE0zO5n1Ik72zuJrrYpxKr+BDPKgcfDXD4=;
        b=O50r5aO5DA90M4cjSaHBBUVzouWEBqqB119fDm9qUujPQXHIQN3pMq5V2ScqtmzD9S
         medulSvboUx7WvXtAymfnDKDLzeO8n2t32J6ObT4tdh2qevSx2Z+sDmzctts5F+I0GEC
         WPd9MQ5j+u7ztpqpPDDY5fGldrq/b6TWxLTxAnotFy/GUL2eDkPIf0tx2X9ZRGSUYPj3
         KWLk+bc8deTcFeptEirixUsGZ1SF1m0GcXfnrGJcrXXinBKtZUuIRX9vnCb4EpBu7fFe
         AoB653jF1QEEcKWdizBEam868enoBzEJQCLWaMdjDc3iqOOzT//OyCzrRYWOApZ30ApG
         GBzg==
X-Gm-Message-State: AOJu0Ywbm3n0jrR69egEOS56mY/wmwM0URdi88yyXUffVw0V54/sDpXk
	Ig73o+DijtnFUx+sWr+wC5XqSd7o7JQXIfX5YhaTes7i8wQ7Pj+AWJp3tHVN/ELXt20SddF44Em
	ADg==
X-Google-Smtp-Source: AGHT+IGiw7ILhrX9iuCbLlYhgfQOn44Bu+lzK1r35/JFTn8Ji2iJWjpcfklE9ShIDfGS/ecZUh41fJSCs0E=
X-Received: from pjbsc2.prod.google.com ([2002:a17:90b:5102:b0:2ff:611c:bae8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c3:b0:2ee:d024:e4fc
 with SMTP id 98e67ed59e1d1-30310022326mr26084574a91.33.1742856874511; Mon, 24
 Mar 2025 15:54:34 -0700 (PDT)
Date: Mon, 24 Mar 2025 15:54:32 -0700
In-Reply-To: <facda6e2-3655-4f2c-9013-ebb18d0e6972@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <facda6e2-3655-4f2c-9013-ebb18d0e6972@gmail.com>
Message-ID: <Z-HiqG_uk0-f6Ry1@google.com>
Subject: Re: pvclock time drifting backward
From: Sean Christopherson <seanjc@google.com>
To: Ming Lin <minggr@gmail.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+David

On Wed, Mar 19, 2025, Ming Lin wrote:
> Hi,
>=20
> After performing a live migration on a QEMU guest OS that had been runnin=
g for over 30 days,
> we noticed that the guest OS time was more than 2 seconds behind the actu=
al time.
>=20
> After extensive debugging, we found that this issue is related to master_=
kernel_ns and master_cycle_now.
>=20
> When the guest OS starts, the host initializes a pair of master_kernel_ns=
 and master_cycle_now values.
> After live migration, the host updates these values.
>=20
> Our debugging showed that if the host does not update master_kernel_ns/ma=
ster_cycle_now,
> the guest OS time remains correct.
>=20
> To illustrate how updating master_kernel_ns/master_cycle_now leads to the=
 guest OS time drifting backward,
> we applied the following debug patch:
>=20
> The patch adds a KVM debugfs entry to trigger time calculations and print=
 the results.
> The patch runs on the host side, but we use __pvclock_read_cycles() to si=
mulate the guest OS updating its time.
>=20
> Example Output:
>=20
> # cat /sys/kernel/debug/kvm/946-13/pvclock
> old: master_kernel_ns: 15119778316
> old: master_cycle_now: 37225912658
> old: ns: 1893199569691
> new: master_kernel_ns: 1908210098649
> new: master_cycle_now: 4391329912268
> new: ns: 1893199548401
>=20
> tsc 4391329912368
> kvmclock_offset -15010550291
> diff: ns: 21290
>=20
> Explanation of Parameters:
>=20
> Input:
> "old: master_kernel_ns:" The master_kernel_ns value recorded when the gue=
st OS started (remains unchanged during testing).
> "old: master_cycle_now:" The master_cycle_now value recorded when the gue=
st OS started (remains unchanged during testing).
> "new: master_kernel_ns:" The latest master_kernel_ns value at the time of=
 reading.
> "new: master_cycle_now:" The latest master_cycle_now value at the time of=
 reading.
> tsc: The rdtsc() value at the time of reading.
> kvmclock_offset: The offset recorded by KVM_SET_CLOCK when the guest OS s=
tarted (remains unchanged during testing).
>=20
> Output:
> "old: ns:" Time in nanoseconds calculated using the old master_kernel_ns/=
master_cycle_now.
> "new: ns:" Time in nanoseconds calculated using the new master_kernel_ns/=
master_cycle_now.
> "diff: ns:" (old ns - new ns), representing the time drift relative to th=
e guest OS start time.
>=20
> Test Script:
> #!/bin/bash
>=20
> qemu_pid=3D$(pidof qemu-system-x86_64)
>=20
> while [ 1 ] ; do
>     echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"
>     echo "Guest OS running time: $(ps -p $qemu_pid -o etime=3D | awk '{pr=
int $1}')"
>     cat /sys/kernel/debug/kvm/*/pvclock
>     echo
>     sleep 10
> done
>=20
> Test Results:
> Below are the first and last parts of a >2-hour test run.
> As time progresses, the time drift calculated using the latest master_ker=
nel_ns/master_cycle_now increases monotonically.
>=20
> After 2 hours and 18 minutes, the guest OS time drifted by approximately =
93 milliseconds.
>=20
> I have uploaded an image for a more intuitive visualization of the time d=
rift:
> https://postimg.cc/crCDWtD7
>=20
> Is this a real problem?

David can confirm, but I'm pretty sure the drift you are observing is addre=
ssed
by David's series to fix a plethora of kvmclock warts.

https://lore.kernel.org/all/20240522001817.619072-1-dwmw2@infradead.org

> If there is any fix patch, I=E2=80=99d be happy to test it. Thanks!
>=20
>=20
>     1 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     2 guest os running time: 00:50
>     3 old: master_kernel_ns: 15119778316
>     4 old: master_cycle_now: 37225912658
>     5 old: ns: 48092694964
>     6 new: master_kernel_ns: 63103244699
>     7 new: master_cycle_now: 147587790614
>     8 new: ns: 48092694425
>     9
>    10 tsc 147587790654
>    11 kvmclock_offset -15010550291
>    12 diff: ns: 539
>    13
>    14 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    15 guest os running time: 01:00
>    16 old: master_kernel_ns: 15119778316
>    17 old: master_cycle_now: 37225912658
>    18 old: ns: 58139026532
>    19 new: master_kernel_ns: 73149576143
>    20 new: master_cycle_now: 170694333104
>    21 new: ns: 58139025879
>    22
>    23 tsc 170694333168
>    24 kvmclock_offset -15010550291
>    25 diff: ns: 653
>    26
>    27 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    28 guest os running time: 01:10
>    29 old: master_kernel_ns: 15119778316
>    30 old: master_cycle_now: 37225912658
>    31 old: ns: 68183772122
>    32 new: master_kernel_ns: 83194321616
>    33 new: master_cycle_now: 193797227862
>    34 new: ns: 68183771357
>    35
>    36 tsc 193797227936
>    37 kvmclock_offset -15010550291
>    38 diff: ns: 765
>    39
>    40 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    41 guest os running time: 01:20
>    42 old: master_kernel_ns: 15119778316
>    43 old: master_cycle_now: 37225912658
>    44 old: ns: 78225289157
>    45 new: master_kernel_ns: 93235838545
>    46 new: master_cycle_now: 216892696976
>    47 new: ns: 78225288279
>    48
>    49 tsc 216892697034
>    50 kvmclock_offset -15010550291
>    51 diff: ns: 878
>    52
>    53 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    54 guest os running time: 01:30
>    55 old: master_kernel_ns: 15119778316
>    56 old: master_cycle_now: 37225912658
>    57 old: ns: 88268955340
>    58 new: master_kernel_ns: 103279504612
>    59 new: master_cycle_now: 239993109102
>    60 new: ns: 88268954349
>    61
>    62 tsc 239993109168
>    63 kvmclock_offset -15010550291
>    64 diff: ns: 991
>    65
>    66 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    67 guest os running time: 01:40
>    68 old: master_kernel_ns: 15119778316
>    69 old: master_cycle_now: 37225912658
>    70 old: ns: 98313212581
>    71 new: master_kernel_ns: 113323761740
>    72 new: master_cycle_now: 263094880668
>    73 new: ns: 98313211476
>    74
>    75 tsc 263094880732
>    76 kvmclock_offset -15010550291
>    77 diff: ns: 1105
> .....
> .....
> 10160 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 10161 guest os running time: 02:17:11
> 10162 old: master_kernel_ns: 15119778316
> 10163 old: master_cycle_now: 37225912658
> 10164 old: ns: 8229817213297
> 10165 new: master_kernel_ns: 8244827670997
> 10166 new: master_cycle_now: 18965537819524
> 10167 new: ns: 8229817120748
> 10168
> 10169 tsc 18965537819622
> 10170 kvmclock_offset -15010550291
> 10171 diff: ns: 92549
> 10172 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 10173 guest os running time: 02:17:21
> 10174 old: master_kernel_ns: 15119778316
> 10175 old: master_cycle_now: 37225912658
> 10176 old: ns: 8239861074959
> 10177 new: master_kernel_ns: 8254871532564
> 10178 new: master_cycle_now: 18988638681302
> 10179 new: ns: 8239860982297
> 10180
> 10181 tsc 18988638681358
> 10182 kvmclock_offset -15010550291
> 10183 diff: ns: 92662
> 10184 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 10185 guest os running time: 02:17:31
> 10186 old: master_kernel_ns: 15119778316
> 10187 old: master_cycle_now: 37225912658
> 10188 old: ns: 8249904622988
> 10189 new: master_kernel_ns: 8264915080459
> 10190 new: master_cycle_now: 19011738821632
> 10191 new: ns: 8249904530213
> 10192
> 10193 tsc 19011738821736
> 10194 kvmclock_offset -15010550291
> 10195 diff: ns: 92775^@
> 10196 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 10197 guest os running time: 02:17:41
> 10198 old: master_kernel_ns: 15119778316
> 10199 old: master_cycle_now: 37225912658
> 10200 old: ns: 8259949369203
> 10201 new: master_kernel_ns: 8274959826576
> 10202 new: master_cycle_now: 19034841717872
> 10203 new: ns: 8259949276315
> 10204
> 10205 tsc 19034841717942
> 10206 kvmclock_offset -15010550291
> 10207 diff: ns: 92888
> 10208 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 10209 guest os running time: 02:17:51
> 10210 old: master_kernel_ns: 15119778316
> 10211 old: master_cycle_now: 37225912658
> 10212 old: ns: 8269996849598
> 10213 new: master_kernel_ns: 8285007306846
> 10214 new: master_cycle_now: 19057950902658
> 10215 new: ns: 8269996756597
> 10216
> 10217 tsc 19057950902756
> 10218 kvmclock_offset -15010550291
> 10219 diff: ns: 93001^@
> 10220 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 10221 guest os running time: 02:18:02
> 10222 old: master_kernel_ns: 15119778316
> 10223 old: master_cycle_now: 37225912658
> 10224 old: ns: 8280039094317
> 10225 new: master_kernel_ns: 8295049551453
> 10226 new: master_cycle_now: 19081048045430
> 10227 new: ns: 8280039001203
> 10228
> 10229 tsc 19081048045526
> 10230 kvmclock_offset -15010550291
> 10231 diff: ns: 93114^@
>=20
>=20
>=20
> =C2=A0=C2=A0=C2=A0 pvclock debugfs patch
> ---
> =C2=A0arch/x86/include/asm/kvm_host.h |=C2=A0 4 +++
> =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 29 +++++++++++++++-
> =C2=A0b.sh=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
> =C2=A0virt/kvm/kvm_main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 75 +++++++++++++++++++++++++++++++++++++++++
> =C2=A04 files changed, 108 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 32ae3aa50c7e..5a82a69bfe7a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1411,6 +1411,10 @@ struct kvm_arch {
> =C2=A0=C2=A0=C2=A0=C2=A0 struct delayed_work kvmclock_update_work;
> =C2=A0=C2=A0=C2=A0=C2=A0 struct delayed_work kvmclock_sync_work;
> +=C2=A0=C2=A0=C2=A0 u64 old_master_kernel_ns;
> +=C2=A0=C2=A0=C2=A0 u64 old_master_cycle_now;
> +=C2=A0=C2=A0=C2=A0 s64 old_kvmclock_offset;
> +
> =C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_xen_hvm_config xen_hvm_config;
> =C2=A0=C2=A0=C2=A0=C2=A0 /* reads protected by irq_srcu, writes by irq_lo=
ck */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4b64ab350bcd..a56511ed8c5b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2819,7 +2819,7 @@ static inline u64 vgettsc(struct pvclock_clock *clo=
ck, u64 *tsc_timestamp,
> =C2=A0 * As with get_kvmclock_base_ns(), this counts from boot time, at t=
he
> =C2=A0 * frequency of CLOCK_MONOTONIC_RAW (hence adding gtos->offs_boot).
> =C2=A0 */
> -static int do_kvmclock_base(s64 *t, u64 *tsc_timestamp)
> +int do_kvmclock_base(s64 *t, u64 *tsc_timestamp)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0 struct pvclock_gtod_data *gtod =3D &pvclock_gtod=
_data;
> =C2=A0=C2=A0=C2=A0=C2=A0 unsigned long seq;
> @@ -2861,6 +2861,27 @@ static int do_monotonic(s64 *t, u64 *tsc_timestamp=
)
> =C2=A0=C2=A0=C2=A0=C2=A0 return mode;
> =C2=A0}
> +u64 mydebug_get_kvmclock_ns(u64 master_kernel_ns, u64 master_cycle_now, =
s64 kvmclock_offset, u64 tsc)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct pvclock_vcpu_time_info=
 hv_clock;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ret;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hv_clock.tsc_timestamp =3D ma=
ster_cycle_now;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hv_clock.system_time =3D mast=
er_kernel_ns + kvmclock_offset;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* both __this_cpu_read() and=
 rdtsc() should be on the same cpu */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 get_cpu();
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_get_time_scale(NSEC_PER_S=
EC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &hv_clock.tsc_shi=
ft,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &hv_clock.tsc_to_=
system_mul);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D __pvclock_read_cycles=
(&hv_clock, tsc);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 put_cpu();
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> +}
> +
> =C2=A0static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0 struct pvclock_gtod_data *gtod =3D &pvclock_gtod=
_data;
> @@ -2988,6 +3009,10 @@ static void pvclock_update_vm_gtod_copy(struct kvm=
 *kvm)
> =C2=A0=C2=A0=C2=A0=C2=A0 host_tsc_clocksource =3D kvm_get_time_and_clockr=
ead(
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &ka->master_kernel_ns,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &ka->master_cycle_now);
> +=C2=A0=C2=A0=C2=A0 ka->old_master_kernel_ns =3D ka->master_kernel_ns;
> +=C2=A0=C2=A0=C2=A0 ka->old_master_cycle_now =3D ka->master_cycle_now;
> +=C2=A0=C2=A0=C2=A0 printk("MYDEBUG: old_master_kernel_ns =3D %llu, old_m=
aster_cycle_now =3D %llu\n",
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ka->o=
ld_master_kernel_ns, ka->old_master_cycle_now);
> =C2=A0=C2=A0=C2=A0=C2=A0 ka->use_master_clock =3D host_tsc_clocksource &&=
 vcpus_matched
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 && !ka->backwards_tsc_observed
> @@ -6989,6 +7014,8 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, =
void __user *argp)
> =C2=A0=C2=A0=C2=A0=C2=A0 else
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 now_raw_ns =3D get_kvmcl=
ock_base_ns();
> =C2=A0=C2=A0=C2=A0=C2=A0 ka->kvmclock_offset =3D data.clock - now_raw_ns;
> +=C2=A0=C2=A0=C2=A0 ka->old_kvmclock_offset =3D ka->kvmclock_offset;
> +=C2=A0=C2=A0=C2=A0 printk("MYDEBUG: old_kvmclock_offset =3D %lld\n", ka-=
>old_kvmclock_offset);
> =C2=A0=C2=A0=C2=A0=C2=A0 kvm_end_pvclock_update(kvm);
> =C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> =C2=A0}
> diff --git a/b.sh b/b.sh
> new file mode 120000
> index 000000000000..0ff9a93fd53f
> --- /dev/null
> +++ b/b.sh
> @@ -0,0 +1 @@
> +/home/mlin/build.upstream/b.sh
> \ No newline at end of file
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ba0327e2d0d3..d6b9a6e7275e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -399,6 +399,7 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memor=
y_cache *mc, int capacity,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
return mc->nobjs >=3D min ? 0 : -ENOMEM;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mc->objects[mc->nobjs++]=
 =3D obj;
> =C2=A0=C2=A0=C2=A0=C2=A0 }
> +
> =C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> =C2=A0}
> @@ -998,6 +999,78 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
> =C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0}
> +extern int do_kvmclock_base(s64 *t, u64 *tsc_timestamp);
> +extern u64 mydebug_get_kvmclock_ns(u64 master_kernel_ns, u64 master_cycl=
e_now, s64 kvmclock_offset, u64 tsc);
> +
> +static ssize_t kvm_mydebug_pvclock_read(struct file *file, char __user *=
buf,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t len, loff_t *ppos)
> +{
> +=C2=A0=C2=A0=C2=A0 struct kvm *kvm =3D file->private_data;
> +=C2=A0=C2=A0=C2=A0 struct kvm_arch *ka;
> +=C2=A0=C2=A0=C2=A0 char buffer[256];
> +=C2=A0=C2=A0=C2=A0 ssize_t ret, copied;
> +=C2=A0=C2=A0=C2=A0 u64 new_master_kernel_ns;
> +=C2=A0=C2=A0=C2=A0 u64 new_master_cycle_now;
> +=C2=A0=C2=A0=C2=A0 u64 old_ns, new_ns;
> +=C2=A0=C2=A0=C2=A0 u64 tsc;
> +
> +=C2=A0=C2=A0=C2=A0 if (!kvm) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("file->private_data is=
 NULL\n");
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> +=C2=A0=C2=A0=C2=A0 }
> +
> +=C2=A0=C2=A0=C2=A0 ka =3D &kvm->arch;
> +
> +=C2=A0=C2=A0=C2=A0 do_kvmclock_base(&new_master_kernel_ns, &new_master_c=
ycle_now);
> +
> +=C2=A0=C2=A0=C2=A0 tsc =3D rdtsc();
> +
> +=C2=A0=C2=A0=C2=A0 old_ns =3D mydebug_get_kvmclock_ns(ka->old_master_ker=
nel_ns, ka->old_master_cycle_now, ka->old_kvmclock_offset, tsc);
> +=C2=A0=C2=A0=C2=A0 new_ns =3D mydebug_get_kvmclock_ns(new_master_kernel_=
ns, new_master_cycle_now, ka->old_kvmclock_offset, tsc);
> +
> +=C2=A0=C2=A0=C2=A0 ret =3D snprintf(buffer, sizeof(buffer),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "old: master_kernel_ns: %llu\n"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "old: master_cycle_now: %llu\n"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "old: ns: %llu\n"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "new: master_kernel_ns: %llu\n"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "new: master_cycle_now: %llu\n"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "new: ns: %llu\n\n"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "tsc %llu\n"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "kvmclock_offset %lld\n"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "diff: ns: %lld\n",
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ka->old_master_kernel_ns, ka->old_mast=
er_cycle_now, old_ns,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new_master_kernel_ns, new_master_cycle=
_now, new_ns,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tsc, ka->old_kvmclock_offset,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 old_ns - new_ns
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 );
> +
> +=C2=A0=C2=A0=C2=A0 if (ret < 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> +
> +=C2=A0=C2=A0=C2=A0 if ((size_t)ret > sizeof(buffer))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D sizeof(buffer);
> +
> +=C2=A0=C2=A0=C2=A0 if (*ppos >=3D ret)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0; /* EOF */
> +
> +=C2=A0=C2=A0=C2=A0 copied =3D min(len, (size_t)(ret - *ppos));
> +
> +=C2=A0=C2=A0=C2=A0 if (copy_to_user(buf, buffer + *ppos, copied)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("copy_to_user failed\n=
");
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EFAULT;
> +=C2=A0=C2=A0=C2=A0 }
> +
> +=C2=A0=C2=A0=C2=A0 *ppos +=3D copied;
> +
> +=C2=A0=C2=A0=C2=A0 return copied;
> +}
> +
> +static const struct file_operations kvm_pvclock_fops =3D {
> +=C2=A0=C2=A0=C2=A0 .owner =3D THIS_MODULE,
> +=C2=A0=C2=A0=C2=A0 .read =3D kvm_mydebug_pvclock_read,
> +=C2=A0=C2=A0=C2=A0 .open =3D simple_open,
> +};
> +
> =C2=A0static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdnam=
e)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0 static DEFINE_MUTEX(kvm_debugfs_lock);
> @@ -1063,6 +1136,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, c=
onst char *fdname)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &stat_fops_per_vm);
> =C2=A0=C2=A0=C2=A0=C2=A0 }
> +=C2=A0=C2=A0=C2=A0 debugfs_create_file("pvclock", 0444, kvm->debugfs_den=
try, kvm, &kvm_pvclock_fops);
> +
> =C2=A0=C2=A0=C2=A0=C2=A0 kvm_arch_create_vm_debugfs(kvm);
> =C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> =C2=A0out_err:
>=20

