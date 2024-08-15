Return-Path: <kvm+bounces-24221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BA99526D9
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 02:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F1461F24BF8
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8CC4A05;
	Thu, 15 Aug 2024 00:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tc9RmOu5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC918A32
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 00:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723681420; cv=none; b=ogfS/lxcS/tDBRBH6qOAhHfevZaqlOq/FvTUJRPuUzNmgylG+2snj6eCh0AK2geNruancdQWEDlHAe2YU5pTekkJPIo4CGaLKdLfZY2Lx0BGSZInbNBSYuI8zaoMO4GLrhq6NoG2LZ4rMthAM7Pli6iT9RRmDYeWVPucF41OrU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723681420; c=relaxed/simple;
	bh=suWnLmH8CZD5CKZpCqGzoBDzsiuPxsn+e87dVsPHe/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=utbaoAJR/Yn/JJqXJRE9TRfyD7GimaGtrj5AyMS/dCOrvF4dayQhHYRabLOc+8d8gKoRzz27cLZXiZrZAh6yH49Zf9LomWbQZF7I0z9QVkisQ2CFZe9EZPm9aiswuxoA359VnKYSkkvmYpkWhSd0N/nUvWonFQTnC3fwKFSNt00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tc9RmOu5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1a9bad5dso370691b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723681418; x=1724286218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=na+DQAropa9HhQkX0n6COE58Sm+QVzbS54Fw3LBcwkg=;
        b=Tc9RmOu5VHf0+n+FFdemc0NquMn8Xs4Epv2ssHAcgbEOheAqm+Pq1n0CV5TzWmv6xj
         CFWj4Py99KE7UCnMZ5ppkPfJmRh2cYlBn3eZ8WGMxYN8QqlTceFKS9jjtYY1eivpBXZZ
         8uNtC98ElNyeBgz9+qUDW+psHeju7UNmNN01xvaV6NvxZpchEF80TjaqGZngaIi/3JyL
         SZmOUh5S778rdBg8JGKfgHNTaOn7Z291LzLtU4JyExhyZ0+q2CYaBIATmhh7HsbPIEl2
         AjheTBZud+dAn4u4s9zExCLf2XzYTzRInZsLnoLnvOzTzcXeEP7kXh4Mn82QzKay8TCz
         c3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723681418; x=1724286218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=na+DQAropa9HhQkX0n6COE58Sm+QVzbS54Fw3LBcwkg=;
        b=q0EhS0W7VE/p3Nglq5xCQw2vonPMow+JKpNArfB7NNDZLznCCnhvpLdof3l6KsbdLX
         09QIV/3bPtlp/8xGame9l2eh38UuVzRUEZfcU/RC6wEJzPepRAKwe3w+JnlFkg1biynC
         rfTFPjizLvrg+dEvtcfcGlZJd7aSm1KfqaP5LlqRSnEcibhbt/bTlJG6Vcz3AO73040F
         AB3Fy0BJz9ri85s5EIB47erYbKgbD08SWzlyl1yQRd3eBel91hPZ4zKhff53mpVgS6Db
         6hiSIrRK1PEeWVD9ZtC6cOjpbxffiMAPEPNanWdACb2BcYx9pSbGnfEcS7jDfEXu/eed
         W+3w==
X-Forwarded-Encrypted: i=1; AJvYcCUdUkvSefY8VtFSdXzlLQcqTj64E/L3RlbUvGoZczAEM3qXyBLS4NECC5Re42RPR91Rjbdl9ivrNDwPBQWT0RTdmGc3
X-Gm-Message-State: AOJu0YwW4ysuSsT3WC7c/DfgGhSg0rts/yAyIe7FFuwuIqTOIV7L4FeO
	79dTeitebu440uYnt+n/tURm8lDXWVTkymJpM+0Oq5+a3RAAqYvIPrs6TPfbSD8bge+cUj1xqMt
	sxg==
X-Google-Smtp-Source: AGHT+IGoZtQk6EhIPI9XMZuU6TS6huGs8UeaDStKkTJudv5DvPbQJzN1W9iOqNUU9Nrexb3O6V5rC1Lbce8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:91c9:0:b0:710:4d06:93b3 with SMTP id
 d2e1a72fcca58-712673e5d8bmr25637b3a.3.1723681417634; Wed, 14 Aug 2024
 17:23:37 -0700 (PDT)
Date: Wed, 14 Aug 2024 17:23:36 -0700
In-Reply-To: <Zr0_5gixFGlyQMl7@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240814123715.GB2032816@nvidia.com>
 <ZrzAlchCZx0ptSfR@google.com> <20240814144307.GP2032816@nvidia.com>
 <Zr0ZbPQHVNzmvwa6@google.com> <Zr09cyPZNShzeZc6@linux.dev> <Zr0_5gixFGlyQMl7@linux.dev>
Message-ID: <Zr1KiHO0pxPdYD_U@google.com>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, 
	David Hildenbrand <david@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Oliver Upton wrote:
> On Wed, Aug 14, 2024 at 04:28:00PM -0700, Oliver Upton wrote:
> > On Wed, Aug 14, 2024 at 01:54:04PM -0700, Sean Christopherson wrote:
> > > TL;DR: it's probably worth looking at mmu_stress_test (was: max_guest_memory_test)
> > > on arm64, specifically the mprotect() testcase[1], as performance is significantly
> > > worse compared to x86,
> > 
> > Sharing what we discussed offline:
> > 
> > Sean was using a machine w/o FEAT_FWB for this test, so the increased
> > runtime on arm64 is likely explained by the CMOs we're doing when
> > creating or invalidating a stage-2 PTE.
> > 
> > Using a machine w/ FEAT_FWB would be better for making these sort of
> > cross-architecture comparisons. Beyond CMOs, we do have some 
> 
> ... some heavy barriers (e.g. DSB(ishst)) we use to ensure page table
> updates are visible to the system. So there could still be some
> arch-specific quirks that'll show up in the test.

Nope, 'twas FWB.  On a system with FWB, ARM nicely outperforms x86 on mprotect()
when vCPUs stop on the first -EFAULT.  I suspect because ARM can do broadcast TLB
invalidations and doesn't need to interrupt and wait for every vCPU to respond.

  run1 = 10.723194154s, reset = 0.000014732s, run2 = 0.013790876s, ro = 2.151261587s, rw = 10.624272116s

However, having vCPUs continue faulting while mprotect() is running turns the
tables, I suspect due to mmap_lock

  run1 = 10.768003815s, reset = 0.000012051s, run2 = 0.013781921s, ro = 23.277624455s, rw = 10.649136889s

The x86 numbers since they're out of sight now:

 -EFAULT once
  run1 =  6.873408794s, reset = 0.000165898s, run2 = 0.035537803s, ro =  6.149083106s, rw = 7.713627355s

 -EFAULT forever
  run1 =  6.923218747s, reset = 0.000167050s, run2 = 0.034676225s, ro = 14.599445790s, rw = 7.763152792s

> > > and there might be bugs lurking the mmu_notifier flows.
> > 
> > Impossible! :)
> > 
> > > Jumping back to mmap_lock, adding a lock, vma_lookup(), and unlock in x86's page
> > > fault path for valid VMAs does introduce a performance regression, but only ~30%,
> > > not the ~6x jump from x86 to arm64.  So that too makes it unlikely taking mmap_lock
> > > is the main problem, though it's still good justification for avoid mmap_lock in
> > > the page fault path.
> > 
> > I'm curious how much of that 30% in a microbenchmark would translate to
> > real world performance, since it isn't *that* egregious.

vCPU jitter is the big problem, especially if userspace is doing something odd,
and/or if the kernel is preemptible (which also triggers yeild-on-contention logic
for spinlocks, ew).  E.g. the range-based retry to avoid spinning and waiting on
an unrelated MM operation was added by the ChromeOS folks[1] to resolve issues
where an MM operation got preempted and so blocked vCPU faults.

But even for cloud setups with a non-preemptible kernel, contending with unrelated
userspace VMM modification can be problematic, e.g. it turns out even the
gfn_to_pfn_cache logic needs range-based retry[2] (though that's a rather
pathological case where userspace is spamming madvise() to the point where vCPUs
can't even make forward progress).

> > We also have other uses for getting at the VMA beyond mapping granularity
> > (MTE and the VFIO Normal-NC hint) that'd require some attention too.

Yeah, though it seems like it'd be easy enough to take mmap_lock if and only if
it's necessary, e.g. similar to how common KVM takes it only if it encounters
VM_PFNMAP'd memory.

E.g. take mmap_lock if and only if MTE is active (I assume that's uncommon?), or
if the fault is to device memory.

[1] https://lore.kernel.org/all/20210222024522.1751719-1-stevensd@google.com
[2] https://lore.kernel.org/all/f862cefff2ed3f4211b69d785670f41667703cf3.camel@infradead.org

