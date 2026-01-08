Return-Path: <kvm+bounces-67489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B01D0661B
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D4BDE3017F84
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D289A33D514;
	Thu,  8 Jan 2026 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gsx2osJ7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD3033D6C2;
	Thu,  8 Jan 2026 21:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767909231; cv=none; b=Jww0M2XNkeaMt1osOGsS9LP4fdod0bTveq0WicAX2wDJ0V0Fdj72DLL46sMH2ufjM9oGDEef5OZlxfR0bRQ6jhYfNltjX5V7mBCxga8NX1Z+9jgX4Ujj29v3bVSj133dPpvSZqFTDQkTGai0TRJE74uMTQuQv5DtY17trYyYjXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767909231; c=relaxed/simple;
	bh=pES8CNvgEWUrZSrme3hkhLAvBUh0MV/JNCf1LMiME4k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p6A5CMdleYnH1M4jLvlSh1XdT7WTtdTaml+w4cSCXt3rWu9tU/riC3S4BUMLO1XKEQw0hyMdOs+slLHh+t+1yU6tRF+r4/cudeN5dInityPn0KnAcug0MFLOcNnCbO9o85L3FvRLVR9IGAhXWF/OMFrIsXuN0s3gHxLAfRTIemE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gsx2osJ7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3DCC116C6;
	Thu,  8 Jan 2026 21:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767909231;
	bh=pES8CNvgEWUrZSrme3hkhLAvBUh0MV/JNCf1LMiME4k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Gsx2osJ7hvB0mpEKQ4fqhnwT2ViurpZNG2S3fBsbAu0UMzSzFsVt9m70Wib8e3q25
	 me4TZhsJ+iRHr+5NwZNtKxHIlTQHQg5EIHLtj0Uv1pz+eRvT8SnYAyGWPl+f33nm6Y
	 tsxhXx1odR9DBjVbB2c4t69tZpVurqUFS3WPray2iRp1laPgIvkRKfmohAUkRsisMS
	 XbQ7J/JIDLf9XYw02DqeAaX2Ax1K7IoxBJHAMViDszRveLaAaN6b94QV7K4OLSzN8D
	 IgKSCK5k/VyIl1XQdhSSW6zWoAtIGx3GuOsoiYb2qtQpmES5fl7jPXiRACs8bEcJGw
	 uK4jglxXRlfDg==
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
In-Reply-To: <874iovu742.ffs@tglx>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com> <874iovu742.ffs@tglx>
Date: Thu, 08 Jan 2026 22:53:47 +0100
Message-ID: <87pl7jsrdg.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jan 08 2026 at 22:28, Thomas Gleixner wrote:
> On Mon, Dec 22 2025 at 15:09, Paolo Bonzini wrote:
>> Of the three, the most sketchy is (a); notably, __setup_irq() calls
>> wake_up_process outside desc->lock.  Therefore I'd like so much to treat
>> it as a kernel/irq/ bug; and the simplest (perhaps too simple...) fix is
>
> It's not more sketchy than VIRT assuming that it can do what it wants
> under rq->lock. :)

And just for the record, that's not the only place in the irq core which
has that lock chain.

irq_set_affinity_locked()       // invoked with desc::lock held
   if (desc->affinity_notify)
      schedule_work()           // Ends up taking rq::lock

and that's the case since cd7eab44e994 ("genirq: Add IRQ affinity
notifiers"), which was added 15 years ago.

Are you still claiming that this is a kernel/irq bug?

Thanks,

        tglx


