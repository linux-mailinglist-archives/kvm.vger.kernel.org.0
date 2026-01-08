Return-Path: <kvm+bounces-67476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39A48D06507
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 62ED63019E1B
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8963382DF;
	Thu,  8 Jan 2026 21:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBX+Q4vp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FAA331218;
	Thu,  8 Jan 2026 21:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767907714; cv=none; b=XVBLhONE6xdR6hkzIcP+wjCQT1F1+xXL6IcUpB6Pejobxl8E9KACtWSroDdj5DgJ1p1uvHTi4HRqsBuChVqezkGEqNotD8CN8NEIXL2Ceve25j7WZ9R5XgjNptv8BW0xuqmtfhYSz8PRhsA37+0zjtQghJbda28IHgA1yqhzXv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767907714; c=relaxed/simple;
	bh=867MVYqB2USbUxXWc7YOR69zdzsNdxKNzvzgaETZw/w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=P7bhYrug/c48xwgYf3V+3Fjbsq6HppAErI2RhmKe6lgMs2YO5rVzZs/uZuayGgC8eYYHUvhmFPVdTvlxKITkbLqkt7rcTgN698J4BovtbgE5xNktF+Ar469BVjtmo2Rq22ZlqA1vPCvqHLWKfL+wtu1b73vd/wesDJJjhONZ/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBX+Q4vp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A44C116C6;
	Thu,  8 Jan 2026 21:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767907714;
	bh=867MVYqB2USbUxXWc7YOR69zdzsNdxKNzvzgaETZw/w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=SBX+Q4vpB64LFyZQjZGly1tVIEl03H0JgAaNlYBQaa0c9BdbyQ/CyixCVBdwCz8f1
	 KvDstoz4Jktk1JC+O/y6FNcawe6dhtMc10QmQ74oyDFWlU72V+4YiR0io7xlB8DkCk
	 82XA1nOe20ZyQy33ENE8D+o5Gir8YHC2CtmV0W5cezQRBNTpXXpkygykA8UPLJq+5Q
	 j6pJItlh9JXcxMsckAyecdB/Rjvf3w0JsEz1IJxe78+HOaI5zks1BtsGsRy8favUJ2
	 4DscJy2HxDmgWI5xYN2ExenjDL0aEQhItiX0aZmqnwqfJko5QhY5JRRjCnuM/jo4zE
	 HSpJ68xUaDprw==
From: Thomas Gleixner <tglx@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Ankit Soni <Ankit.Soni@amd.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, Vasant
 Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, Joao
 Martins <joao.m.martins@oracle.com>, Francesco Lavra
 <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>, Naveen
 Rao <Naveen.Rao@amd.com>, Crystal Wood <crwood@redhat.com>
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold
 ir_list_lock across IRTE updates in IOMMU)
In-Reply-To: <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
Date: Thu, 08 Jan 2026 22:28:29 +0100
Message-ID: <874iovu742.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Dec 22 2025 at 15:09, Paolo Bonzini wrote:
> On 12/22/25 10:16, Ankit Soni wrote:
>>    ======================================================
>>    WARNING: possible circular locking dependency detected
>>    6.19.0-rc2 #20 Tainted: G            E
>>    ------------------------------------------------------
>>    CPU 58/KVM/28597 is trying to acquire lock:
>>      ff12c47d4b1f34c0 (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0
>> 
>>      but task is already holding lock:
>>      ff12c49b28552110 (&svm->ir_list_lock){....}-{2:2}, at: avic_pi_update_irte+0x147/0x270 [kvm_amd]
>> 
>>      which lock already depends on the new lock.
>> 
>>    Chain exists of:
>>      &irq_desc_lock_class --> &rq->__lock --> &svm->ir_list_lock
>> 
>>    Possible unsafe locking scenario:
>> 
>>          CPU0                            CPU1
>>          ----                            ----
>>     lock(&svm->ir_list_lock);
>>                                        lock(&rq->__lock);
>>                                        lock(&svm->ir_list_lock);
>>     lock(&irq_desc_lock_class);
>> 
>>          *** DEADLOCK ***
>> 
>> So lockdep sees:
>> 
>>    &irq_desc_lock_class -> &rq->__lock -> &svm->ir_list_lock
>> 
>> while avic_pi_update_irte() currently holds svm->ir_list_lock and then
>> takes irq_desc_lock via irq_set_vcpu_affinity(), which creates the
>> potential inversion.
>> 
>>    - Is this lockdep warning expected/benign in this code path, or does it
>>      indicate a real potential deadlock between svm->ir_list_lock and
>>      irq_desc_lock with AVIC + irq_bypass + VFIO?
>
> I'd treat it as a potential (if unlikely) deadlock:
>
> (a) irq_set_thread_affinity triggers the scheduler via wake_up_process,
> while irq_desc->lock is taken
>
> (b) the scheduler calls into KVM with rq_lock taken, and KVM uses
> ir_list_lock within __avic_vcpu_load/__avic_vcpu_put
>
> (c) KVM wants to block scheduling for a while and uses ir_list_lock for
> that purpose, but then takes irq_set_vcpu_affinity takes irq_desc->lock.
>
> I don't think there's an alternative choice of lock for (c); and there's
> no easy way to pull the irq_desc->lock out of the IRQ subsystem--in fact

Don't even think about that.

> the stickiness of the situation comes from rq->rq_lock and
> irq_desc->lock being both internal and not leaf.
>
> Of the three, the most sketchy is (a); notably, __setup_irq() calls
> wake_up_process outside desc->lock.  Therefore I'd like so much to treat
> it as a kernel/irq/ bug; and the simplest (perhaps too simple...) fix is

It's not more sketchy than VIRT assuming that it can do what it wants
under rq->lock. :)

> to drop the wake_up_process().  The only cost is extra latency on the
> next interrupt after an affinity change.

The real problematic cost is that in an isolation scenario the wakeup
happens at the next interrupt which might be far into the isolated
phase. That's why the wakeup is there. See:

  c99303a2d2a2 ("genirq: Wake interrupt threads immediately when changing affinity")

Obviously you did not even bother to look that up otherwise you would
have CC'ed Crystal and asked her to take a look...

Thanks,

        tglx






