Return-Path: <kvm+bounces-63546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0D3C69F12
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 15:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0F13234AF8F
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 14:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7E335BDCD;
	Tue, 18 Nov 2025 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CT2vs3iY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B6F32E6A9
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763475611; cv=none; b=Mf0hi78h1YF6rl41p1NHo9zu5xX1ke+NzajMrJ7uNRcxOQlOLrfT3llLonftXC/l67SB5sGOCpsXbG5o9hKq3eN+aY9cKlaCQeLL8g12GHoGSnOY709AyryQU4aVyZZUaSt3QMYAGr1ul76MPGjuuZshG7A8D7VUE6W7a17tNd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763475611; c=relaxed/simple;
	bh=VNXsIUNhy+3XDUlMUkL7Q+4iGshuTfgpRMOfuGpJ1OM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BHpKTtEcpxEYhoHvPLnT39OjDt44IZDD5U8fsgOn5Jnm81MLHXUh+abtI2jIyCcZ5RXQoPRi8BxHnNagiKLQg3cD19eRU3tIkTUDdm8h3Ya+ruAJCP29VEVWktMkDkRASv0bexUfFUGB+t+Fg1EUZ0fNkgnjUi9T/MZgEfrJGk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CT2vs3iY; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-343dfb673a8so5273650a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 06:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763475609; x=1764080409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=niYvXJCoZg2Gp2Q/RvXbbH7B9mh1SgoAyvVJXLvgGCg=;
        b=CT2vs3iYpjzBkAcpU1qnIGV6dMqW9Covr9MYLyLmyuGUBoi67csnH/1ZJV7HxMH9xD
         BPv/Z8SiDZNcmiB+dnyfuNl2LTlZjHykfR/qLa9SUelshrZGKiK22E0BSB7uEGIDmpHY
         XUUTdXIYikO8AXlmfOHB0GNNx4F1f6ubChHvvlBAUecnMJM7vfyUdBiyTMCxoJanZrmx
         MOQzBJpxQcwG9UF/pb8lfjhBYhEu54iEciUOV9soeKDi5i36o42/l3GannXMDNNcq5WN
         xHl11cQHJkkLktMxbMXfcpWww5VdVZ7jjJEuSta/wkeam2yK2Qr0eRhYU0CoJg4+rvS9
         77vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763475609; x=1764080409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=niYvXJCoZg2Gp2Q/RvXbbH7B9mh1SgoAyvVJXLvgGCg=;
        b=XJSWTkG1pdT1xqD86dyit6/p1uSTluHnqG3gKFMm/VzOH/Q9lhGSOBLy3TYP9liYoB
         lxmiP5I75pjPNJlaYT8SexTLJjHy0JttbcUaHAQtxhsMQK5XBFKZ868wygAziqfUy5Oc
         8BVOihAvC/BeQm4wEzpCuwMnIr9/AEjIP3p6STV+yxEMuEdfnBD8H28ea0RoaUr2bXek
         xiFGC+JNvUoCAN4WQZonbbXIrppp33NhdwrX2VlnkZAc7QsCdo0ZMf26qbk8gVfDrZyj
         Ow7ZYdMnS/M7ore9HjCi3v8BT63Mi3iKAOeZ54zsR3rphhkrSbd9ow80G4mL/wxOYv2Q
         R6Kw==
X-Forwarded-Encrypted: i=1; AJvYcCWv9Rmaoe6FKBVfO/mlMZ8hnsiCUYZDhyV4HZ1W1R5ncULadeC7zwen51Itd8H/kPtl6ko=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYSfAC0cQQr5sEOu83LUopVaNovTKrsZQOwzll1ejMMP4UMz9I
	KHdF1nOeUWSj85j/nywul5ZdoRMjVoQPVTaUwU+m/6za7pR1Fs6QkEDlAdxBdq+NGcWKLe5CiPc
	aNWiY0jtQozcCKpuPQSOfG8tAyicZ1lg=
X-Gm-Gg: ASbGnctnEuaeeg45TmoaZPC3jhlNdJ0hvaHsJg8nRC9mHTVN40ZFWtLlTndFRuz6LwP
	GP76449SZmgJFU6O754/DTKsWvkbC9z2hhymLB2FKwyOzGk24xKF/Oc+EqKxvo3Er0ixZTWYH3V
	p7eCWoTwF9bgVX4Dzf+9W0r1wgGf8QPbKh5ZDy8o+Zbf6jFCbNxsaIleK1zFuNSlEGDVky4BpNG
	VZclL4Qe/Ji4H/lctuddrVzRNR0O2hKOU9JLbbL1QgWC6sLebHB1+l7X4VT/uYeagERi+gByFXf
	ot/Bnw==
X-Google-Smtp-Source: AGHT+IGn1uQVe7kftT3d3TYcFj6nKpYdAM/gW4eGkSIyZh9HxqyQyXuPtFluAR2SW+6iWYEv70DkQRqziTTTzQYjfSI=
X-Received: by 2002:a17:90b:3841:b0:340:6f9c:b25b with SMTP id
 98e67ed59e1d1-343f9ec8d41mr19164615a91.11.1763475608506; Tue, 18 Nov 2025
 06:20:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <a1e5a8db-8382-4f52-8ef2-3b62b0c031ab@linux.ibm.com>
 <CANRm+CzVtzgYYwgaqEMmsOAo7m=Esd9rd-zbB7zXzgL_p5SgxQ@mail.gmail.com> <2a57185c-dce1-46c6-96f6-f51a81cd42a8@linux.ibm.com>
In-Reply-To: <2a57185c-dce1-46c6-96f6-f51a81cd42a8@linux.ibm.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Tue, 18 Nov 2025 22:19:56 +0800
X-Gm-Features: AWmQ_bmFJJlapkwOVPBX13UXydPqzDGoGmpsdoq1crmYnD_8Jmn6tnBn9Dzg_OM
Message-ID: <CANRm+CzPE+7UVtQuT-R9kfh5NJYx5h9j=-if4fUM-9M9xHjX0Q@mail.gmail.com>
Subject: Re: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Mete Durlu <meted@linux.ibm.com>, Axel Busch <axel.busch@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Christian=EF=BC=8C

On Tue, 18 Nov 2025 at 16:12, Christian Borntraeger
<borntraeger@linux.ibm.com> wrote:
>
> Am 12.11.25 um 06:01 schrieb Wanpeng Li:
> > Hi Christian,
> >
> > On Mon, 10 Nov 2025 at 20:02, Christian Borntraeger
> > <borntraeger@linux.ibm.com> wrote:
> >>
> >> Am 10.11.25 um 04:32 schrieb Wanpeng Li:
> >>> From: Wanpeng Li <wanpengli@tencent.com>
> >>>
> >>> This series addresses long-standing yield_to() inefficiencies in
> >>> virtualized environments through two complementary mechanisms: a vCPU
> >>> debooster in the scheduler and IPI-aware directed yield in KVM.
> >>>
> >>> Problem Statement
> >>> -----------------
> >>>
> >>> In overcommitted virtualization scenarios, vCPUs frequently spin on l=
ocks
> >>> held by other vCPUs that are not currently running. The kernel's
> >>> paravirtual spinlock support detects these situations and calls yield=
_to()
> >>> to boost the lock holder, allowing it to run and release the lock.
> >>>
> >>> However, the current implementation has two critical limitations:
> >>>
> >>> 1. Scheduler-side limitation:
> >>>
> >>>      yield_to_task_fair() relies solely on set_next_buddy() to provid=
e
> >>>      preference to the target vCPU. This buddy mechanism only offers
> >>>      immediate, transient preference. Once the buddy hint expires (ty=
pically
> >>>      after one scheduling decision), the yielding vCPU may preempt th=
e target
> >>>      again, especially in nested cgroup hierarchies where vruntime do=
mains
> >>>      differ.
> >>>
> >>>      This creates a ping-pong effect: the lock holder runs briefly, g=
ets
> >>>      preempted before completing critical sections, and the yielding =
vCPU
> >>>      spins again, triggering another futile yield_to() cycle. The ove=
rhead
> >>>      accumulates rapidly in workloads with high lock contention.
> >>
> >> I can certainly confirm that on s390 we do see that yield_to does not =
always
> >> work as expected. Our spinlock code is lock holder aware so our KVM al=
ways yield
> >> correctly but often enought the hint is ignored our bounced back as yo=
u describe.
> >> So I am certainly interested in that part.
> >>
> >> I need to look more closely into the other part.
> >
> > Thanks for the confirmation and interest! It's valuable to hear that
> > s390 observes similar yield_to() behavior where the hint gets ignored
> > or bounced back despite correct lock holder identification.
> >
> > Since your spinlock code is already lock-holder-aware and KVM yields
> > to the correct target, the scheduler-side improvements (patches 1-5)
> > should directly address the ping-pong issue you're seeing. The
> > vruntime penalties are designed to sustain the preference beyond the
> > transient buddy hint, which should reduce the bouncing effect.
>
> So we will play a bit with the first patches and check for performance im=
provements.
>
> I am curious, I did a quick unit test with 2 CPUs ping ponging on a count=
er. And I do
> see "more than count" numbers of the yield hypercalls with that testcase =
(as before).
> Something like 40060000 yields instead of 4000000 for a perfect ping pong=
. If I comment
> out your rate limit code I hit exactly the 4000000.
> Can you maybe outline a bit why the rate limit is important and needed?

Good catch! The 10=C3=97 inflation is actually expected behavior. The key
insight is that rate limit filters penalty applications, not yield
hypercalls. In your ping-pong test with 4M counter increments, PLE
hardware fires multiple times per lock acquisition (roughly 10 times
based on your numbers), and each triggers kvm_vcpu_on_spin() . Without
rate limit, every yield immediately applies vruntime penalty. In tight
ping-pong, this causes over-penalization where the skip vCPU becomes
so deprioritized it effectively starves, which paradoxically
neutralizes the debooster effect. You see "exactly 4M" not because
it's working optimally, but because excessive penalties create a
pathological equilibrium where subsequent yields are suppressed by
starvation. With a 6ms rate limit, all 40M hypercalls still occur (PLE
still fires), but only the first yield in each burst applies a penalty
while subsequent ones are filtered. This gives you roughly 4M
penalties (one per actual lock acquisition) instead of 40M, providing
sustained advantage without over-penalization. The 6ms threshold was
empirically tuned as roughly 2=C3=97 typical timeslice to filter intra-lock
PLE bursts while preserving responsiveness to legitimate contention.
Your test validates the design by showing rate limit prevents penalty
amplification even in the tightest ping-pong scenario.

I'll post v2 after the merge window with code comments addressing this
and other review feedback, which should be more suitable for
performance evaluation.

Wanpeng

