Return-Path: <kvm+bounces-45095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14504AA5F8F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:55:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DB0F4A82A8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E746D1D5CDE;
	Thu,  1 May 2025 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pfk1ZFoG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E8C1DFDE;
	Thu,  1 May 2025 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746107713; cv=none; b=iI65CjDNwi7h5xeoORzlCcj8RIhXOHqxgHTrR4U8dT3ZJQDG73RAvrKhMwWrXIbUj3qipjywDVzlN+aZZyOyH2QhzSQhIkp8+1EQePRFkpaVPylRwQYBjI0pfj67x0rrQrNH6RbHxZFG5mof8cuYcwCLXl49FTJPQcVZkNZFCOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746107713; c=relaxed/simple;
	bh=HP9qPQcXPFBaNtd0LbBqA0JNCPyQw698ggOHjYeim0Y=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Moo6jmleYrGW09UTBIdWVNAmk98O6WxaHHPr0ceS2K2YjSP67WJAKkjg3tCGcHaQ4mKF2CADWQCAh12zvS/wCK5ZeIIh2sBBK3KNaJBOLopuWtJdKRzZTF/arxmw0+i7texqmnqJAximFv4V7Nm5qYUSzHMRQgfHHiRsAxl0AAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pfk1ZFoG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E48EC4CEE3;
	Thu,  1 May 2025 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746107712;
	bh=HP9qPQcXPFBaNtd0LbBqA0JNCPyQw698ggOHjYeim0Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Pfk1ZFoGFQBcJbn4eAazqmyuBJ6TkiGf2ekSQDgoa5Fjia9S2lMt5efsrXyzq1Vvm
	 ULeuC83dmMDOduBWW3xv2ptavXQm1vdoGdMaOq6foW7rtSQf8ouqLVTIFegJWn1fzS
	 EorN2jN0LePdF11Vpm6UW5UyEsjAfLLhsNMAJTWfxtw7S29pRommXhIjicwQXKd09K
	 dja4faMd/aLvbeN4QKFNqUIDiiz0PK5zIlRXOlq9ONM7WY09BvtawseMmekfxpdUph
	 231yeafldT6FquJnpqz72EltQ8Tb6TsqSFX9obyV9riRozvuNYg8YfhJH7B6vS3/oQ
	 Lfve/zxbzhOzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uAUNa-00AakJ-3R;
	Thu, 01 May 2025 14:55:10 +0100
Date: Thu, 01 May 2025 14:55:08 +0100
Message-ID: <86v7qkh1vn.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Borislav Petkov <bp@alien8.de>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andre Przywara <andre.przywara@arm.com>,
	x86@kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Shusen Li <lishusen2@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 2/5] arm64: KVM: use mutex_trylock_nest_lock when locking all vCPUs
In-Reply-To: <20250501134126.GT4439@noisy.programming.kicks-ass.net>
References: <20250430203013.366479-1-mlevitsk@redhat.com>
	<20250430203013.366479-3-mlevitsk@redhat.com>
	<864iy4ivro.wl-maz@kernel.org>
	<20250501111552.GO4198@noisy.programming.kicks-ass.net>
	<861pt8ijpv.wl-maz@kernel.org>
	<20250501134126.GT4439@noisy.programming.kicks-ass.net>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: peterz@infradead.org, mlevitsk@redhat.com, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, jiangkunkun@huawei.com, longman@redhat.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, bhelgaas@google.com, boqun.feng@gmail.com, bp@alien8.de, aou@eecs.berkeley.edu, anup@brainfault.org, paul.walmsley@sifive.com, suzuki.poulose@arm.com, palmer@dabbelt.com, alex@ghiti.fr, glider@google.com, oliver.upton@linux.dev, andre.przywara@arm.com, x86@kernel.org, joey.gouly@arm.com, tglx@linutronix.de, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, mingo@redhat.com, jingzhangos@google.com, hpa@zytor.com, dave.hansen@linux.intel.com, kvmarm@lists.linux.dev, will@kernel.org, keisuke.nishimura@inria.fr, sebott@redhat.com, lishusen2@huawei.com, pbonzini@redhat.com, rdunlap@infradead.org, seanjc@google.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 01 May 2025 14:41:26 +0100,
Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Thu, May 01, 2025 at 01:44:28PM +0100, Marc Zyngier wrote:
> > On Thu, 01 May 2025 12:15:52 +0100,
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > > + */
> > > > > +int kvm_trylock_all_vcpus(struct kvm *kvm)
> > > > > +{
> > > > > +	struct kvm_vcpu *vcpu;
> > > > > +	unsigned long i, j;
> > > > > +
> > > > > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > > > > +		if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
> > > 
> > > This one includes an assertion that kvm->lock is actually held.
> > 
> > Ah, cunning. Thanks.
> > 
> > > That said, I'm not at all sure what the purpose of all this trylock
> > > stuff is here.
> > > 
> > > Can someone explain? Last time I asked someone said something about
> > > multiple VMs, but I don't know enough about kvm to know what that means.
> > 
> > Multiple VMs? That'd be real fun. Not.
> > 
> > > Are those vcpu->mutex another class for other VMs? Or what gives?
> > 
> > Nah. This is firmly single VM.
> > 
> > The purpose of this contraption is that there are some rare cases
> > where we need to make sure that if we update some global state, all
> > the vcpus of a VM need to see, or none of them.
> > 
> > For these cases, the guarantee comes from luserspace, and it gives the
> > pinky promise that none of the vcpus are running at that point. But
> > being of a suspicious nature, we assert that this is true by trying to
> > take all the vcpu mutexes in one go. This will fail if a vcpu is
> > running, as KVM itself takes the vcpu mutex before doing anything.
> > 
> > Similar requirement exists if we need to synthesise some state for
> > userspace from all the individual vcpu states.
> 
> Ah, okay. Because x86 is simply doing mutex_lock() instead of
> mutex_trylock() -- which would end up waiting for this activity to
> subside I suppose.
> 
> Hence the use of the killable variant I suppose, for when they get tired
> of waiting.

Yeah, I remember some debate around that when this refactoring was
first posted. I quickly paged it out.

> If all the architectures are basically doing the same thing, it might
> make sense to unify this particular behaviour. But what do I know.

I don't know either. The trylock behaviour has been there since day-1
on the arm side, and changing it would have userspace visible effects.
So I'm pretty keen on preserving it, warts and all. The last thing I
need is a VMM person hitting my inbox on the grounds that their toy is
broken.

On the other hand, we're talking about virtualisation, so everything
is more or less broken by design...

	M.

-- 
Without deviation from the norm, progress is not possible.

