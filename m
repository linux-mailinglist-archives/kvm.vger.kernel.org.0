Return-Path: <kvm+bounces-54468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C31DB21A79
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6F841A25213
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C732D6E4F;
	Tue, 12 Aug 2025 02:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TX/L9weU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106B876C61
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 02:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754964138; cv=none; b=KF1UejMh2ExGnuzV2rMSWXwS+drKnPJuT5Ws+BoeKeKczM/KcYungGEMgBCFHHLGQqLDKTPJzjnKrPNZzaAM6qecd3lQLIVRVtRc4gYzGDn17t88bbr3N7WLXhZGYz7QLEBO/tEErmzdJF4HKIEnnwuJ3ot44yobj3kLL4EqMEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754964138; c=relaxed/simple;
	bh=6Ar/zG8qyGe4g7CqcuUZw2HDZaYj0AoVayKU0WPfvBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IfKvTX8rJse+GFYTJeqtkXSRSR+k8guwJgzRM7bgkeYjO7U14uJx5fXCFIsGWW0r2Sl0sZ9Ltz7xF9Bab3uFB+pkClQDfKrR3lA/dvZoMY+zAe4RAMA1sx+6ztarGKA9Iwa/6v/Hf9/Z1RXTQAANv2rupJhwsrnF7RvPX+ruoZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TX/L9weU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b42249503c4so4644535a12.0
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 19:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754964136; x=1755568936; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kgryqc2YtOyUg6uo1xDn5Y9DaT8+ppyu9pI3cldNMUc=;
        b=TX/L9weUdmsiQtdMR5zhQtDFK8jP4vTJJb2h8TTLPhm9acOAVHCQHBUdQQcOiHV9BD
         XppscSeJUYUZZCx0Iw3qgeczEtdgm5k78as2jVY0HaSPoQmjOGXiV1V1fI8FU6QVu96M
         P7N0yiUHusAiy+3cW2saUIwsHaMf8Hcka0PzGVDYPErEt4Mfze8vTXfiYQz7/65qdzGR
         jqXEIEvo8Tm9UjnLSA5yVsroAkfbH/0MHXdalXqgioK4tSy1HK+zptdOXwS9sV01HCjL
         Y642jvbJPK3HkIpUl4zNYk431H8AYHMzM+0qaVIOBGgyLygD5Sz3BNti9Q6+IZtCx9vi
         WDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754964136; x=1755568936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kgryqc2YtOyUg6uo1xDn5Y9DaT8+ppyu9pI3cldNMUc=;
        b=nexCQ7fKRcX/VX9Hg48CRRTZYXhOmjSyR/eyncaUJMH98E/UBM3vEmr0Lg94QKh9H2
         IlEpA85+uQq1fCX9wh1Jj31siYLyl5VHSlPlM8BgcaCJH2dW6jvYMa0kgeM2u3uKwuGo
         zXVp1eDw+f32zRm28m49fW3s9k4hiBiu256SL/UwQQVQDofyIZtuQQOn0Vnn/ngOp78z
         MqXorc1aA9gzeE9X24rAxLAXAT+MFNppZiwXS6JKj6ogEix0waz5/ZiYYSYjruNKmUH7
         vJD9ZsYjEJw8Q4OAl2rkuvC36mgPBAv1TjcWysIdclYp6KZmE7QMyDqG8YdTlqz5hhVl
         m6xg==
X-Forwarded-Encrypted: i=1; AJvYcCXBUiSo8GB5t+ogoKUGK5IQdDFgSbeMrxq5elxbVUd7WZGh2+lezPVc5paLlWB5D9foK9o=@vger.kernel.org
X-Gm-Message-State: AOJu0YztpyBjiVCT/sfLE+24dB6tp6ytndo5FZFLpzlaW7HSFdgubOmO
	//0SXDIxGOIP0Rzq4MHdqa9zNcHgB5ub2V4uY7AppU85/remtwVSRXkMTzk/Dh9dhDmMUzbgilO
	hw92I9w==
X-Google-Smtp-Source: AGHT+IF+A3MRYO1Ib9PzKbl2Ck0BoY+LW+8B+JNaSZZAtYsatU2674/gIQ7AECyZ1ZH3omZGjRptguxiCmg=
X-Received: from pjbsw12.prod.google.com ([2002:a17:90b:2c8c:b0:31f:1ed:c76e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a0e:b0:31e:fe21:ca43
 with SMTP id 98e67ed59e1d1-321c09b4cc1mr2341826a91.4.1754964136142; Mon, 11
 Aug 2025 19:02:16 -0700 (PDT)
Date: Mon, 11 Aug 2025 19:02:10 -0700
In-Reply-To: <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <d432b8b7cfc413001c743805787990fe0860e780.camel@intel.com>
 <sjhioktjzegjmyuaisde7ui7lsrhnolx6yjmikhhwlxxfba5bh@ss6igliiimas> <c2a62badf190717a251d269a6905872b01e8e340.camel@intel.com>
Message-ID: <aJqgosNUjrCfH_WN@google.com>
Subject: Re: [PATCHv2 00/12] TDX: Enable Dynamic PAMT
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kas@kernel.org" <kas@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Rick P Edgecombe wrote:
> On Mon, 2025-08-11 at 07:31 +0100, kas@kernel.org wrote:
> > > I don't see any other reason for the global spin lock, Kirill was that
> > > it?  Did you consider also adding a lock per 2MB region, like the
> > > refcount? Or any other granularity of lock besides global? Not saying
> > > global is definitely the wrong choice, but seems arbitrary if I got the
> > > above right.
> > 
> > We have discussed this before[1]. Global locking is problematic when you
> > actually hit contention. Let's not complicate things until we actually
> > see it. I failed to demonstrate contention without huge pages. With huge
> > pages it is even more dubious that we ever see it.
> > 
> > [1]
> > https://lore.kernel.org/all/4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com/
> 
> Ah, I see.
> 
> I just did a test of simultaneously starting 10 VMs with 16GB of ram (non huge

How many vCPUs?  And were the VMs actually accepting/faulting all 16GiB?

There's also a noisy neighbor problem lurking.  E.g. malicious/buggy VM spams
private<=>shared conversions and thus interferes with PAMT allocations for other
VMs.

> pages) and then shutting them down. I saw 701 contentions on startup, and 53
> more on shutdown. Total wait time 2ms. Not horrible but not theoretical either.
> But it probably wasn't much of a cacheline bouncing worse case.

Isn't the SEAMCALL done while holding the spinlock?  I assume the latency of the
SEAMCALL is easily the long pole in the flow.

> And I guess this is on my latest changes not this exact v2, but it shouldn't
> have changed.
> 
> But hmm, it seems Dave's objection about maintaining the lock allocations would
> apply to the refcounts too? But the hotplug concerns shouldn't actually be an
> issue for TDX because they gets rejected if the allocations are not already
> there. So complexity of a per-2MB lock should be minimal, at least
> incrementally. The difference seems more about memory use vs performance.
> 
> What gives me pause is in the KVM TDX work we have really tried hard to not take
> exclusive locks in the shared MMU lock path. Admittedly that wasn't backed by
> hard numbers.

Maybe not for TDX, but we have lots and lots of hard numbers for why taking mmu_lock
for write is problematic.  Even if TDX VMs don't exhibit the same patterns *today*
as "normal" VMs, i.e. don't suffer the same performance blips, nothing guarantees
that will always hold true.
 
> But an enormous amount of work went into lettings KVM faults happen under the
> shared lock for normal VMs. So on one hand, yes it's premature optimization.
> But on the other hand, it's a maintainability concern about polluting the
> existing way things work in KVM with special TDX properties.
> 
> I think we need to at least call out loudly that the decision was to go with the
> simplest possible solution, and the impact to KVM. I'm not sure what Sean's
> opinion is, but I wouldn't want him to first learn of it when he went digging
> and found a buried global spin lock in the fault path.

Heh, too late, I saw it when this was first posted.  And to be honest, my initial
reaction was very much "absolutely not" (though Rated R, not PG).  Now that I've
had time to think things through, I'm not _totally_ opposed to having a spinlock
in the page fault path, but my overall sentiment remains the same.

For mmu_lock and related SPTE operations, I was super adamant about not taking
exclusive locks because based on our experience with the TDP MMU, converting flows
from exclusive to shared is usually significantly more work than developing code
for "shared mode" straightaway (and you note above, that wasn't trivial for TDX).
And importantly, those code paths were largely solved problems.  I.e. I didn't
want to get into a situation where TDX undid the parallelization of the TDP MMU,
and then had to add it back after the fact.

I think the same holds true here.  I'm not completely opposed to introducing a
spinlock, but I want to either have a very high level of confidence that the lock
won't introduce jitter/delay (I have low confidence on this front, at least in
the proposed patches), or have super clear line of sight to making the contention
irrelevant, without having to rip apart the code.

My biggest question at this point is: why is all of this being done on-demand?
IIUC, we swung from "allocate all PAMT_4K pages upfront" to "allocate all PAMT_4K
pages at the last possible moment".  Neither of those seems ideal.

E.g. for things like TDCS pages and to some extent non-leaf S-EPT pages, on-demand
PAMT management seems reasonable.  But for PAMTs that are used to track guest-assigned
memory, which is the vaaast majority of PAMT memory, why not hook guest_memfd?
I.e. setup PAMT crud when guest_memfd is populated, not when the memory is mapped
into the guest.  That way setups that cares about guest boot time can preallocate
guest_memfd in order to get the PAMT stuff out of the way.

You could do the same thing by prefaulting guest memory, but TDX has limitations
there, and I see very little value in precisely reclaiming PAMT memory when a
leaf S-EPT is zapped, i.e. when a page is converted from private=>shared.  As
above, that's just asking for noisy neighbor issues.

The complaints with static PAMT are that it required burning 0.4% of memory even
if the host isn't actively running TDX VMs.  Burning 0.4% of the memory assigned
to a guest, regardless of whether it's map private or shared, seems acceptable,
and I think would give us a lot more flexibility in avoiding locking issues.

Similarly, we could bind a PAMT to non-leaf S-EPT pages during mmu_topup_memory_caches(),
i.e. when arch.mmu_external_spt_cache is filled.  Then there would be no need for
a separate vcpu->arch.pamt_page_cache, and more work would be done outside of
mmu_lock.  Freeing SPTs would still be done under mmu_lock (I think), but that
should be a much rarer operation.

