Return-Path: <kvm+bounces-29974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D75E39B5284
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 20:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AEB7B22124
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 19:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C2D2071FF;
	Tue, 29 Oct 2024 19:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="LteSbu9X";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="tffWXmsp"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08821FBF50;
	Tue, 29 Oct 2024 19:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730229183; cv=none; b=Vz4UgvMYbWvFr72RnRsas8UkXGwqXpLWcU75PGjWALCJSDpPJpLAEY9ZjAYuTQ3+3liYYOmeG9ZvB9Vt46yZkIvEwaSnoy1Y2Q2I+lglCed2EpfzThhrlKLHoJHkIxVzgPrMxoJv529nUQhm2td48T7WroUYRFcASr1kb/5eNjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730229183; c=relaxed/simple;
	bh=kVYtwcfclxpvBW30S2RwWocigUFMTa1azVLZdYZRh5E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cSwnp72HPtGnoBnHWXR4Vyzg4TCvdZ4vpHe/3Wijof36WUdjLu6z7g9B9hgUBpycPcOGmoGsmwtIdNOtwybXX192jdEgJAZTGWaJ9smRIZL9/763UCSqONwIyylFtczcBGI1+bs8Dlzul71DdUGKwvR5mPS54euqLpC3PVNksrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=LteSbu9X; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=tffWXmsp; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1730229180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nNDoZlvVc72wsuMOc+bkf/3VOAqrrScR8m3Zau9Vv2A=;
	b=LteSbu9Xs2VfzjzEJkuyON+4kl2xG6qdPp8l31+3semXp8JX+wELAol3bGKIObe2tC8qgZ
	r/STTisUNB90uUbxwASGC3zhmFIgz4HdCDWJ8xEIQl/+K5mHMFxoNuqo0ZLaEDvZPckodY
	Z8XS99mlhVFgp7za0qYgZUjaUCtVxgjcsQdOvp0LwCqhMCh6x+fh/yRfHObDJCQoBgQbIP
	uXtSvLiB/RJ383jc4ZUkzMBjcu8U3JPeBu5y0eUDtDarHfjnSuoL5XAuphDp4DcuYciNqf
	QyG5YZkWHdLLQBGYL1zxZrv1NWff66znqDKl1X+4MKqkdUQxnQCNZZI9aCo8uA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1730229180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nNDoZlvVc72wsuMOc+bkf/3VOAqrrScR8m3Zau9Vv2A=;
	b=tffWXmspbsG8CjVmPkNj8bsXifiOXLbwPOM8E71lx8cYAnHl21ExdcKl3ZFuIiOMh3MolO
	XUK1hXHPM3igiTBg==
To: Junaid Shahid <junaids@google.com>, Brendan Jackman
 <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Sean
 Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon
 <liran.alon@oracle.com>, Jan Setje-Eilers <jan.setjeeilers@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Andrew Morton
 <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Lorenzo Stoakes
 <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil
 Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, Khalid Aziz
 <khalid.aziz@oracle.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Valentin
 Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji
 Watanabe <reijiw@google.com>, Ofir Weisse <oweisse@google.com>, Yosry
 Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, KP
 Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, Matteo
 Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>,
 x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org
Subject: Re: [PATCH 01/26] mm: asi: Make some utility functions noinstr
 compatible
In-Reply-To: <ab8ef5ef-f51c-4940-9094-28fbaa926d37@google.com>
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
 <20240712-asi-rfc-24-v1-1-144b319a40d8@google.com>
 <20241025113455.GMZxuCX2Tzu8ulwN3o@fat_crate.local>
 <CA+i-1C3SZ4FEPJyvbrDfE-0nQtB_8L_H_i67dQb5yQ2t8KJF9Q@mail.gmail.com>
 <ab8ef5ef-f51c-4940-9094-28fbaa926d37@google.com>
Date: Tue, 29 Oct 2024 20:12:59 +0100
Message-ID: <878qu6205g.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Oct 29 2024 at 10:38, Junaid Shahid wrote:
> On 10/25/24 6:21 AM, Brendan Jackman wrote:
>>> I'd expect you either always inline the small functions - as you do for some
>>> aleady - or mark the others noinstr. But not something in between.
>>>
>>> Why this?
>> 
>> Overall it's pretty likely I'm wrong about the subtlety of noinstr's
>> meaning. And the benefits I listed above are pretty minor. I should
>> have looked into this as it would have been an opportunity to reduce
>> the patch count of this RFC!
>> 
>> Maybe I'm also forgetting something more important, perhaps Junaid
>> will weigh in...
>
> Yes, IIRC the idea was that there is no need to prohibit inlining for this class 
> of functions.

I doubt that it works as you want it to work.

+	inline notrace __attribute((__section__(".noinstr.text")))	\

So this explicitely puts the inline into the .noinstr.text section,
which means when it is used in .text the compiler will generate an out-of
line function in the .noinstr.text section and insert a call into the
usage site. That's independent of the size of the inline.

Thanks,

        tglx

