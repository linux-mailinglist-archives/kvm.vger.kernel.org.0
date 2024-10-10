Return-Path: <kvm+bounces-28376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0C5997FE6
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1819B25D8F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4B82038DD;
	Thu, 10 Oct 2024 07:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b="uCPQpDvQ"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0582E1C9EBC;
	Thu, 10 Oct 2024 07:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728547141; cv=none; b=tFY29OHI8CjUzRDDkSfz0udWQWrYhZdEFIAT0Q+JP05n5X0HVvgYc5zosFDzXeZ5n9HQY2YVV5m7FRIDCKZSxBkDGrfoQRWNeQEOtR8RHRXiGvVgq3s0/s04jwdQpXJeLwbZB4w1xneeU/KQmHOosAMCEGLNpMfMVyKCJO0t6hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728547141; c=relaxed/simple;
	bh=GDOcGbuAYk/B0p/JvyMP/6g9CMIGjYoHFT4ldFExnsI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gjN5qCd+9VA58+qccL8xhIEaXrSmtBbUQ9ipzJIqv4zWqKvFRBXxutTr1Yio1AgyhfX1m5WNQAYgN2j6muWBeYmVA66mcMCmAqWRD+9HDdj5bDwcULdnnndU/253+fqgWiEww66+6gbxDjBncbqelgnULKK5cwa1cwfljQbu1f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=efault@gmx.de header.b=uCPQpDvQ; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1728547077; x=1729151877; i=efault@gmx.de;
	bh=APz9gvbRhyagSJnMo8MubkUrG3bdgKvMN3oDBP6oDfk=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=uCPQpDvQb9XNzMfP/NdaVAODUuP/qGqcYkIPTt9W9Y0RqimLL2s6Q4wDAmotFEnC
	 4PYa4kk1Yw2/bfXHniAsQtkjCzgJKjmDLQAn/6PEGmSEjMbEn8QNWc+XZPVBc7/Ck
	 MU/GQhprP4nD6mDN9VeJvnZ632eXFH5n5iH0wZDu63sUYq32dHPD7PGaBr8x2LWc6
	 Ob62w2ONlosvBVumWWUg/Ow2wqsSI7VW1xGSwIfPttxXesetoHb0Oq+KmYYK1AXbx
	 qaMQVefEj4dMc5Y8B4pvnmAuMEFZrOPyv78Aq/evaoARx8u0WQkRLPEo8s1qaLojO
	 dy5DYbvbEf1Oj/rAPQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from homer.fritz.box ([91.212.106.104]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MYvY8-1tTj1R0ni4-00RSJU; Thu, 10
 Oct 2024 09:57:57 +0200
Message-ID: <028501cdd2469a678df3b77c25c3cd9a1b6eff66.camel@gmx.de>
Subject: Re: [PATCH 17/24] sched/fair: Implement delayed dequeue
From: Mike Galbraith <efault@gmx.de>
To: Sean Christopherson <seanjc@google.com>, Marek Szyprowski
	 <m.szyprowski@samsung.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, 
 juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com,  rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com,  linux-kernel@vger.kernel.org,
 kprateek.nayak@amd.com, wuyun.abel@bytedance.com, 
 youssefesmat@chromium.org, tglx@linutronix.de, kvm@vger.kernel.org
Date: Thu, 10 Oct 2024 09:57:55 +0200
In-Reply-To: <ZwdA0sbA2tJA3IKh@google.com>
References: <20240727102732.960974693@infradead.org>
	 <20240727105030.226163742@infradead.org>
	 <CGME20240828223802eucas1p16755f4531ed0611dc4871649746ea774@eucas1p1.samsung.com>
	 <5618d029-769a-4690-a581-2df8939f26a9@samsung.com>
	 <ZwdA0sbA2tJA3IKh@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8kTllqzJiGIMIHz2BW2DTBpMUQhvY2hog/nF/iIxIqSQuuDslBb
 n22RNf10gAj3KNcmGsDEkIUGmAG2w+NM6cDMpARKswX99JJdXi5FjBut1aVAFejTHwvrl9T
 wqQgZd8G/DKiKXMBoC53zK4hnReENyS3SoLxAEflimgmU0zMPeT9RgjVEChziFXYNymYYyD
 xwbX6o8CRWLtM2EYUvAgg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QSvM6LeZu3M=;hYT6iwMLQB40f/g2d8jm1LgnNIb
 Cwar6Kpa+ntp/xe1qauGKPLb/maBnFAduG7YDV6OOHpWqoXeX1xkar5IVbaIizTaLZWm5jTNY
 grBgJ+nI9bdiGvUSonDLb/YqLvzAbHywYxhRuzLMtshh1zvgTpBpMKiNXcfhQY5Lek4AXAXxC
 d0fj0N4KVof6bevAg1HZH7xF3E5wo4qUMHDst4Go2MiIvO3GcSQDBpCED2PbjIrI9ucbfaXEQ
 sGN2rYk+B7r3ygWBi0MRDGtOffbtQbp5nOXv8wD/lY/Q8uScUqpkrIaC7EEI2RAfa3TdMwJLk
 0EV3q+7asBVlKCO4CIDvLW+eDynhUVnLW/2ow2+6LM6bbaIvS5VMpB16DEHsU8KzUAPMADODp
 3lr3TLy8r7CpiJqj4V4afwx367+MMBDI1VTcRBRlvCsMQirCJu++ObWHBQ7mBtni8Lu13kLfo
 FSH8q8pjqBwwwI27VvnpdWEakfBS1bOvKbvIfFiDkY2ETYisk9s9CrGio8Fbfj7eZmlZpe+7N
 AuFc6AmTYQ1OHZCOB5LqyAzWwSV0GDUstH3S5ly8d32dDit4YxTVLEJAl9S7QW37O3tx7MR4Z
 /k9eah/ZyGuc8WiOWM1VHk36CyEYIFWfcF6oqyK7Ev7BPYypYHctvYEzjtsEBAJyHVD6lZyU+
 rwP1UiLhlR1w+woPYMxTv9mnU+N5i/TqLwxp6Q7P/NS34cZOD16R5dXnJIOO9b2HaJUQOsNOP
 uyXG9hhupoxp7b5hAjaggv9hN/Adkrp+rCeoEG7pSRX0d8lQonggXQwA2QBE2inAteiWPAsJi
 JsZoaZofnxW9e7U3eagDLYL9R4LnP1ed5c8nhSo1vuFz8=

On Wed, 2024-10-09 at 19:49 -0700, Sean Christopherson wrote:
>
> Any thoughts on how best to handle this?=C2=A0 The below hack-a-fix reso=
lves the issue,
> but it's obviously not appropriate.=C2=A0 KVM uses vcpu->preempted for m=
ore than just
> posted interrupts, so KVM needs equivalent functionality to current->on-=
rq as it
> was before this commit.
>
> @@ -6387,7 +6390,7 @@ static void kvm_sched_out(struct preempt_notifier =
*pn,
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->scheduled_ou=
t, true);
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (current->on_rq && vcpu->wants_=
to_run) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (se_runnable(&current->se) && v=
cpu->wants_to_run) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->preempted, true);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 WRITE_ONCE(vcpu->ready, true);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }

Why is that deemed "obviously not appropriate"?  ->on_rq in and of
itself meaning only "on rq" doesn't seem like a bad thing.

	-Mike

