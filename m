Return-Path: <kvm+bounces-14692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD71C8A5BEC
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 22:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D03D71C21E17
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 20:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3F2155A58;
	Mon, 15 Apr 2024 20:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bjk4GjP/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DABC15575F
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 20:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713211229; cv=none; b=sTU8AG77fMz4/jU8GlLb+wFEaSuHht5u6Isfm09pkPDPvOnUXdMaY5dJ6aMUmPN0RY9lfS0OUA3OiCaa5HwUPgbJl+nh1jxbDGaRhLU8dJWtG53SW5cQtXM1QB20/8yWMcs23YPpMGO/h2VZ/VJakhsG5M6L6LmwXqDERHG8TVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713211229; c=relaxed/simple;
	bh=xXhcNfG113GvJD2OEwTo3qa1iQgotNM4aT6S1SSguJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q357SGQr7jaYB3jCJ2egHiUCjQTpnV6EdQJdplhCJPbcamKIlaA9X7llTH159KTUT9BgziOtemOxO8grfu5UaX9kHFkgIatDdotMzsZgahPmo/EOCXP4fN5K9Uyb1K5BSZKraVnMDJLZ8Kwqat/2oiv7ePBgv961JaXsYuMCEos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bjk4GjP/; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-617bd0cf61fso67525127b3.3
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713211226; x=1713816026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dO9HanFFGKFK/j1cHNx96Mo7D8sNAuc5BfumQ1LiUu0=;
        b=bjk4GjP/xvgDZ1Dndvr5CZyL93dFkUaB6JQIko7slcu5LhF5sohSZMAreq+Ps730Xj
         lXji+zSMmYyy00qsyLrURipQmuOq/0R7kCI7JwO6o5gn81QEwc8NdAxdoSXvZvL09LQ1
         pzir2FvSe1W+DYyF1ZNYA8NklTR0SV9tVvgv/dDrcOoa82ha74A8mG0XdrD0PHZ1nwXN
         as9drFRhVE0mFfhUxw5Pa5sdasxtYLpEd85ZxGKIi1sgLI/FOOWAt6ovlsngZ5lcpAfP
         0xocsUa6tHvZnbblJMR55BtHS4PseIxKT74lIzp6CbqEeY7eRZfgO7YskrntGDajusFO
         EO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713211226; x=1713816026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dO9HanFFGKFK/j1cHNx96Mo7D8sNAuc5BfumQ1LiUu0=;
        b=wMxBOz2wEixgeAUB1lxHKIhd83xz5kkgijDaZfh3AMAYROa+a42vqRA9sJndaBTa6Y
         3KalDvmz+SRM8LX+R1zmbOdfYoP06V4sUINbx2Bk92puwj/s3FZpz8LvjZxiWwnIe5A0
         1Ce269id2dqbCkjk97+afIJP/HUpUweAipS1uWSLKa/0Sa9FLcbhjdwAD2ot2aSk8Ml4
         fH5YJBIOjzusOo/dxD+pgY1g+q4wpalMCmRX4OTO6EBmMkHanOamHisNxTg/pCxexmWK
         r5atGzar01r2CKHJcxyKLO8mZQHwKOx/lNcJHZYxtDPXvRFvFoS6ftmrp7PvWR5JV9Bk
         D2Bg==
X-Forwarded-Encrypted: i=1; AJvYcCVhF29Xv+63N+Rt40mE2UEyslSJljmkFlFxWNP37isRoNh/s7V5vj2cygWLz/EIqF1Y0foVjSMipZzuDMFkrxgxIXa2
X-Gm-Message-State: AOJu0Yx2SMeg0CXtzACqOflMqIz4WesL3s2k9G1/RHF4Sm8n74RiEE1Z
	kVFi7o7ksB5D168A8jYC+2wcmWw2+UPVdnDvKMvR9+1S/Mdh3omRL4QreOWtFwFsHLTQpySyuoq
	tNA==
X-Google-Smtp-Source: AGHT+IHGTFAIjRzWDev68FdmldmWfZ1UzLqfL8TLlEPHkR6OJqIQG9yV8JRbQ1pK64hUb9utypx7cF35cNw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b8e:b0:dcc:e1a6:aca9 with SMTP id
 fj14-20020a0569022b8e00b00dcce1a6aca9mr3472192ybb.9.1713211226425; Mon, 15
 Apr 2024 13:00:26 -0700 (PDT)
Date: Mon, 15 Apr 2024 13:00:24 -0700
In-Reply-To: <Zh1h4gfOpImWHQsC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com> <CALzav=cF+tq-snKbdP76FpodUdd7Fhu9Pf3jTK5c5=vb-MY9cQ@mail.gmail.com>
 <Zg7utCRWGDvxdQ6a@google.com> <CALzav=coESqsXnLbX2emiO_P12WrPZh9WutxF6JWWqwX-6RFDg@mail.gmail.com>
 <Zh1h4gfOpImWHQsC@google.com>
Message-ID: <Zh2HWPFvWAxQSRVM@google.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 15, 2024, David Matlack wrote:
>  * I suspect the original issue my patch is trying to fix is actually specific
>    to the way the TDP MMU does eager page splitting and a more targeted fix is
>    warranted.
> 
> ---
> 
> To evaluate my patch I tested on x86 with different mmu_lock configurations
> to simulate other architectures.
> 
>  Config 1: tdp_mmu=Y fast_page_fault_read_lock=N eager_page_split=Y
>  Config 2: tdp_mmu=Y fast_page_fault_read_lock=Y eager_page_split=Y
>  Config 3: tdp_mmu=N fast_page_fault_read_lock=N eager_page_split=N
> 
> Note: "fast_page_fault_read_lock" is a non-upstream parameter I added to
> add a read_lock/unlock() in fast_page_fault().
> 
> Config 1 is vanilla KVM/x86. Config 2 emulates KVM/arm64. Config 3 emulates
> LoongArch if LoongArch added support for lockless write-protection fault
> handling.
> 
> The test I ran was a Live Migration of a 16VCPU 64GB VM running an aggressive
> write-heavy workload. To compare runs I evaluated 3 metrics:
> 
>  * Duration of pre-copy.
>  * Amount of dirty memory going into post-copy.
>  * Total CPU usage of CLEAR_DIRTY_LOG.
> 
> The following table shows how each metric changed after adding my patch to drop
> mmu_lock during CLEAR_DIRTY_LOG.
> 
>           | Precopy Duration | Post-Copy Dirty | CLEAR_DIRTY_LOG CPU
>  ---------|------------------|-----------------|---------------------
>  Config 1 | -1%              | -1%             | +6%
>  Config 2 | -1%              | +1%             | +123%
>  Config 3 | +32%             | +158%           | +5200%
> 
> Config 2 and 3 both show regressions, with Config 3 severely regressed in all 3
> dimensions.

...

> If this is all true, then a better / more targeted fix for this issue would be
> to drop mmu_lock in the TDP MMU eager page splitting path. For example, we
> could limit the "allocate under lock" behavior to only when the read-lock is
> held, e.g.
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7dfdc49a6ade..ea34f8232d97 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1472,9 +1472,11 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>          * If this allocation fails we drop the lock and retry with reclaim
>          * allowed.
>          */
> -       sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, nid);
> -       if (sp)
> -               return sp;
> +       if (shared) {
> +               sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, nid);
> +               if (sp)
> +                       return sp;
> +       }
> 
>         rcu_read_unlock();
> 
> I checked the KVM/arm64 eager page splitting code, and it drops the mmu_lock to
> allocate page tables. So I suspect no fix is needed there and this is, in fact,
> purely and x86-specific issue.

Hmm, it'd be nice if we didn't have to rely on random arch flows to coincidentally
do the optimal thing for eager page splitting.  Not sure how best to document the
"best known practice" though.

As for the TDP MMU code, unless the cost of dropping and reacquiring mmu_lock for
read is measurable, I would prefer to unconditionally drop mmu_lock, and delete
the GFP_NOWAIT allocation.  There can be lock contention when mmu_lock is held
for read, it's just less common.

On a related topic, I think we should take a hard look at the rwlock_needbreak()
usage in tdp_mmu_iter_cond_resched().  Because dropping when allocating is really
just speculatively dropping mmu_lock because it _might_ be contended, but doing
so at a batch size that provides a good balance between doing enough work under
mmu_lock and providing low latency for vCPUs.  I.e. in theory, we should be able
to handle this fully in tdp_mmu_iter_cond_resched(), but that code is nowhere
near smart enough and it's currently only for preemptible kernels (or at least,
it's supposed to be only for preemptible kernels).

Simply yielding on contention is not at all optimal, as evidenced by the whole
dynamic preemption debacle[1][2].  The immediate issue was "fixed" by having vCPUs
avoid taking mmu_lock, but KVM really shouldn't get into a situation where KVM is
pathologically dropping mmu_lock to the point where a non-vCPU action grinds to
a halt.

The contention logic fails to take into account many things:

 (1) Is the other task higher priority?

 (2) Is the other task a vCPU, or something else?

 (3) Will yielding actually allow the other task to make forward progress?

 (4) What is the cost of dropping mmu_lock, e.g. is a remote TLB flush needed?

 (5) What is the expected duration this task is expected to hold mmu_lock?

 (6) Has this task made enough progress for yielding to be a decent choice?

and probably many more than that.

As we discussed off-list, I think there are two viable approaches:

 (a) We drop the preemption dependency from tdp_mmu_iter_cond_resched()'s lock
     contention logic, and improve the logic (especially the forward progress
     guarantees) so that tdp_mmu_iter_cond_resched() provides solid performance
     in all cases.

 (b) We completely remove the rwlock_needbreak() checks from
     tdp_mmu_iter_cond_resched(), and instead rely on unconditionally dropping
     mmu_lock in flows where doing so provides the best overall balance, e.g. as
     in the eager page split case.

I don't have a strong preference between (a) and (b), though I think I'd lean
towards (b), because it's simpler.  My guess is that we can achieve similar
performance results with both.  E.g. odds are decent that the "best" batch size
(see #6) is large enough that the cost of dropping and reacquiring mmu_lock is
in the noise when it's not contented.

The main argument I see for (b) is that it's simpler, as only code that actually
has a justified need to drop mmu_lock does so.  The advantage I see with (a) is
that it would provide structure and documentation for choosing when to drop
mmu_lock (or not).

E.g. dropping in the eager page split path makes sense because KVM does so at a
large batch size, odds are good that the contending task is a vCPU, there's no
TLB flush required, the total hold time of mmu_lock is high, and we know that
dropping mmu_lock will allow vCPUs to make forward progress.  (a) would do a much
better job of capturing all that in code, albeit with quite a bit more complexity.

Regardless of which option we choose, I think we should drop the preemptible kernel
dependency from the lock contention logic in tdp_mmu_iter_cond_resched(), i.e.
manually check if mmu_lock is contented instead of bouncing through rwlock_needbreak().

The current approach essentially means that there's zero testing of the performance
of the yield-on-contention logic.  E.g. the complaints about the TDP MMU yielding
too aggressively only popped up when commit c597bfddc9e9 ("sched: Provide Kconfig
support for default dynamic preempt mode") unintentionally enabled
rwlock_needbreak() by default.

That's definitely easier said then done though, as I suspect that if we switched
to rwlock_is_contended(), i.e. dropped the preemptible requirement, without also
enhancing tdp_mmu_iter_cond_resched() to make it smarter as above, we'd see a lot
of performance regressions.

[1] https://lore.kernel.org/all/20240312193911.1796717-3-seanjc@google.com
[2] https://lore.kernel.org/all/20240222012640.2820927-1-seanjc@google.com

