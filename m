Return-Path: <kvm+bounces-41548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3898A6A3F2
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 11:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 965164233CC
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 10:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D802224AF6;
	Thu, 20 Mar 2025 10:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kdj3JpaA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE0F224256
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 10:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742467485; cv=none; b=a0RIonvIdqqA9lJpqsDHUpWxyS49Bib4hfZxFl0yGHqoOKQUQmDASam9JqI+H+rNNCOQatuu5MtaiRr+v9cH4+MVsNgKwB5L/xpnkslf/+0QUJn23SytR1sm5BN9VTuQdLXNZV94Ugx3joFYYUxgBUA46zW0+lbCzU65ZndZIJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742467485; c=relaxed/simple;
	bh=O8zyyL1p84aMCSSYT842uw6SFy2rTfsgAblLzeFkCR0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N0+X74Zu+SI+fksYt0sDMezki4xZg/osUhykjCICLsQSxQTSTa9SNHmGIKew1jgDdy7BcuGW2aHVBEKOUiK1ADfvIQm1DkU4MoySBUGTB0pjcMdOqxYFQc5oO3XD1i5mVa+AW6zRnAOkHWUym/LfqR7zKhuezlqruj9TsYqCcn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kdj3JpaA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d3b211d0eso9419175e9.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 03:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742467480; x=1743072280; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j11DFSETqOLtc+vMOz1k4rHgXFA118EedepjEdU8Zqw=;
        b=Kdj3JpaAcTMsJX0fWv0whfnlnrjaZjQkUoIxaVNNWymywgQ1lxYjwO8r7iq1JNp6QM
         Ojbu13PJrvGpih/A3lZ8h//bm+lQo87tlhkP9QV9OC12v7CPJ6kEgjQXJce0C5ni+hLc
         WK8hRYGR3L0Fg1Ms6LVwx4HmFLLx967l5J71fKJh2+DS8uT7oCIJlhzicsDfSOQYSkWF
         sHWVXfORZG9aTGDrruW97o37vT+nFRgMDzAibG+h4BCecMAJVWL9zR8i+Q2//u9V8cvF
         qTDTgtuLxb6b7EYFGNlNI/IdDW+67sG2wCaCd7GvxlgTKp/aIF7rCtp1mbYDuCw4iql2
         FLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742467480; x=1743072280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j11DFSETqOLtc+vMOz1k4rHgXFA118EedepjEdU8Zqw=;
        b=icbYjBHuOw0RIGFWr1yMQ6lXe8FFZuAg3DEAD1x6DyseeJ4yyu4Kp/T5+sWKCjPGKS
         /BEWF18lAB3N/Xsyvrk4k8GmLpT3uXCVf4SxDndv0XwVJOJNVSkb39btNPqvG6tzqsqX
         nUQRcgvoAmq59ecY0BojLAF3rzfQLynk06hmqWQmRkzjfvqOCw3nx+VsbwqIkftv8N+x
         qj+7r+c79e+7qaj6lJZFxV086UyCHH0QyHetMkXBOj1VwTf52CrZ4teeno/1Y4J4UxqX
         9L56YIYRWwJV0RvykiEAeqIdhH4KlvHIOwiYtc35O4Ey0naICZAszTkN0LO2hs0i8J3Y
         vCDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXicfAqSb48ZWIj9XTNex9lmFGhT3ljoI/R2aILAP1h5YFouI5ZpH58y+6KyjizFlSlghY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH2sPG0BuOkT0uEOIdPPaL6xhOK5G9/RRMbFHveKrPptbHsLVX
	s6HHRWGvsGpJIHbMvFxD/bkFIoUStXZl1OiVgxT3M8ptxsNooSa/CdlTXMW0bY+h78I1SNnoBNJ
	mYBZ3gAy/zg==
X-Google-Smtp-Source: AGHT+IHmhdHTuCMOMffmpvyIMCzJObzjHJotMPvb7/CKZriBN1WJ2Qe2CHVhTxdEuiWThlixsbw8H9oOiShQMA==
X-Received: from wmgg15.prod.google.com ([2002:a05:600d:f:b0:43b:c450:ea70])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1da2:b0:439:5f04:4f8d with SMTP id 5b1f17b1804b1-43d49187ba9mr20806165e9.12.1742467480075;
 Thu, 20 Mar 2025 03:44:40 -0700 (PDT)
Date: Thu, 20 Mar 2025 10:44:38 +0000
In-Reply-To: <Z9sRQ0cK0rupEiT-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250110-asi-rfc-v2-v2-0-8419288bc805@google.com>
 <20250110-asi-rfc-v2-v2-4-8419288bc805@google.com> <20250319172935.GMZ9r-_zzXhyhHBLfj@fat_crate.local>
 <Z9sRQ0cK0rupEiT-@google.com>
X-Mailer: aerc 0.18.2
Message-ID: <D8L164U8HBTB.G5MS86AIISLM@google.com>
Subject: Re: [PATCH RFC v2 04/29] mm: asi: Add infrastructure for boot-time enablement
From: Brendan Jackman <jackmanb@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-alpha@vger.kernel.org>, <linux-snps-arc@lists.infradead.org>, 
	<linux-arm-kernel@lists.infradead.org>, <linux-csky@vger.kernel.org>, 
	<linux-hexagon@vger.kernel.org>, <loongarch@lists.linux.dev>, 
	<linux-m68k@lists.linux-m68k.org>, <linux-mips@vger.kernel.org>, 
	<linux-openrisc@vger.kernel.org>, <linux-parisc@vger.kernel.org>, 
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>, 
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>, 
	<sparclinux@vger.kernel.org>, <linux-um@lists.infradead.org>, 
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, 
	<kvm@vger.kernel.org>, <linux-efi@vger.kernel.org>, 
	Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed Mar 19, 2025 at 6:47 PM UTC, Yosry Ahmed wrote:
> On Wed, Mar 19, 2025 at 06:29:35PM +0100, Borislav Petkov wrote:
> > On Fri, Jan 10, 2025 at 06:40:30PM +0000, Brendan Jackman wrote:
> > > Add a boot time parameter to control the newly added X86_FEATURE_ASI.
> > > "asi=on" or "asi=off" can be used in the kernel command line to enable
> > > or disable ASI at boot time. If not specified, ASI enablement depends
> > > on CONFIG_ADDRESS_SPACE_ISOLATION_DEFAULT_ON, which is off by default.
> > 
> > I don't know yet why we need this default-on thing...
>
> It's a convenience to avoid needing to set asi=on if you want ASI to be
> on by default. It's similar to HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
> or ZSWAP_DEFAULT_ON.
>
> [..]
> > > @@ -175,7 +184,11 @@ static __always_inline bool asi_is_restricted(void)
> > >  	return (bool)asi_get_current();
> > >  }
> > >  
> > > -/* If we exit/have exited, can we stay that way until the next asi_enter? */
> > > +/*
> > > + * If we exit/have exited, can we stay that way until the next asi_enter?
> > 
> > What is that supposed to mean here?
>
> asi_is_relaxed() checks if the thread is outside an ASI critical
> section.
>
> I say "the thread" because it will also return true if we are executing
> an interrupt that arrived during the critical section, even though the
> interrupt handler is not technically part of the critical section.
>
> Now the reason it says "if we exit we stay that way" is probably
> referring to the fact that an asi_exit() when interrupting a critical
> section will be undone in the interrupt epilogue by re-entering ASI.
>
> I agree the wording here is confusing. We should probably describe this
> more explicitly and probably rename the function after the API
> discussions you had in the previous patch.

Yeah, this is confusing. It's trying to very concisely define the
concept of "relaxed" but now I see it through Boris' eyes I realise
it's really unhelpful to try and do that. And yeah we should probably
just rework the terminology/API.

To re-iterate what Yosry said, aside from my too-clever comment style
the more fundamental thing that's confusing here is that, using the
terminology currently in the code there are two concepts at play:

- The critical section: this is the path from asi_enter() to
  asi_relax(). The critical section can be interrupted, and code
  running in those interupts is not said to be "in the critical
  section".

- Being "tense" vs "relaxed". Being "tense" means the _task_ is in a
  critical section, but the current code might not be.

This distinction is theoretically relevant because e.g. it's a bug to
access sensitive data in a critical section, but it's OK to access it
while in the tense state (we will switch to the restricted address
space, but this is OK because we will have a chance to asi_enter()
again before we get back to the untrusted code). 

BTW, just to be clear:

1. Both of these are only relevant to code that's pretty deeply aware
   of ASI. (TLB flushing code, entry code, stuff like that).

2. To be honest whenever you write:

     if (asi_in_critical_section())

   You probably mean:

     if (WARN_ON(asi_in_critical_section()))

   For example if we try to flush the TLB in the critical section,
   there's a thing we can do to handle it. But that really shouldn't
   be necessary.  We want the critical section code to be very small
   and straight-line code.

   And indeed in the present code we don't use
   asi_in_critical_section() for anything bur WARNing.

> asi_is_relaxed() checks if the thread is outside an ASI critical
> section.

Now I see it written this way, this is probably the best way to
conceptualise it. Instead of having two concepts "tense/relaxed" vs
"ASI critical section" we could just say "the task is in a critical
section" vs "the CPU is in a critical section". So we could have
something like:

bool asi_task_critical(void);
bool asi_cpu_critical(void);

(They could also accept an argument for the task/CPU, but I can't see
any reason why you'd peek at another context like that).

--

For everything else, Ack to Boris or +1 to Yosry respectively.

