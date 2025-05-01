Return-Path: <kvm+bounces-45089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E0EAAA5F51
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60C7217BBA2
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7021B1C5D7B;
	Thu,  1 May 2025 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q9FCL2T2"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0778E199934;
	Thu,  1 May 2025 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106922; cv=none; b=tATpJfYWzSIQ/5kHfLZZduchHNxyRpQQoU01eL8PaP+5f8WLUee8dcFyZjeR03jiMC+8eLByJM0IR8fBQogXKsvaAwUaat4P1w8vKWI/qt6E2rI5ssqjvAZshYObd6FVTnfJyOeZLML23KhVhGEwGMUFvbDp74GQQSIjz54m6WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106922; c=relaxed/simple;
	bh=Kj/tTIVj+YbmZAeGhD45xGA77N5aCHiVWUmsTJOf5Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTRkBog/0EY4Jzq0Qps6hEWcaTAHsIfeUZjFCRPE/4mrOYgSzXYCU6u4+pfYyBFxk43fPUVveHukucB55GcGGvWTGTK2UlqZBBX8fPZQz64DcS0uwHgKL77tr8Md8b18I6C6xIqkDXOo07lB2izLmQNkdnN8LQ1bWnrSmllAucw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q9FCL2T2; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xowpOTNHZuGO7hdiOZBA1ktd0ANINI9wdxjSaNfAYr4=; b=Q9FCL2T2yxtlsZmsHNZUwJ8del
	DL8laA78CDwP4h6JIEK8DYCPbAEn5jqEbbLSZWIhOKuDrIy1I6OqTo9KD9RydEXs9LtTQP7JwdVeq
	4saOXLHsvs5AkFnJ22A0h3WN+8CgiXYNQ/0f8sG5/dYNuYkLxnqAaR+vvCg/5l2w8jZZCo7FHKQiW
	f288JWqa60gzVN2mzNjAgCr3QbhjMXdNy9WwPnwoi3VTWwB8wMrcCtefnZGM/Bk0zwdWtETejY/nF
	8yoxbchPCJPBA6ar0KmslCX7gVXF+rtiSA7clAWpkSlgnj6PDZkABXJr1Y2KN+tXGm4cSTkn3K4kE
	LaXMEXvg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uAUAJ-0000000E13k-38FL;
	Thu, 01 May 2025 13:41:28 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2B30630035E; Thu,  1 May 2025 15:41:27 +0200 (CEST)
Date: Thu, 1 May 2025 15:41:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Boqun Feng <boqun.feng@gmail.com>, Borislav Petkov <bp@alien8.de>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andre Przywara <andre.przywara@arm.com>, x86@kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>, Ingo Molnar <mingo@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>, Shusen Li <lishusen2@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 2/5] arm64: KVM: use mutex_trylock_nest_lock when
 locking all vCPUs
Message-ID: <20250501134126.GT4439@noisy.programming.kicks-ass.net>
References: <20250430203013.366479-1-mlevitsk@redhat.com>
 <20250430203013.366479-3-mlevitsk@redhat.com>
 <864iy4ivro.wl-maz@kernel.org>
 <20250501111552.GO4198@noisy.programming.kicks-ass.net>
 <861pt8ijpv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861pt8ijpv.wl-maz@kernel.org>

On Thu, May 01, 2025 at 01:44:28PM +0100, Marc Zyngier wrote:
> On Thu, 01 May 2025 12:15:52 +0100,
> Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > > + */
> > > > +int kvm_trylock_all_vcpus(struct kvm *kvm)
> > > > +{
> > > > +	struct kvm_vcpu *vcpu;
> > > > +	unsigned long i, j;
> > > > +
> > > > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > > > +		if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
> > 
> > This one includes an assertion that kvm->lock is actually held.
> 
> Ah, cunning. Thanks.
> 
> > That said, I'm not at all sure what the purpose of all this trylock
> > stuff is here.
> > 
> > Can someone explain? Last time I asked someone said something about
> > multiple VMs, but I don't know enough about kvm to know what that means.
> 
> Multiple VMs? That'd be real fun. Not.
> 
> > Are those vcpu->mutex another class for other VMs? Or what gives?
> 
> Nah. This is firmly single VM.
> 
> The purpose of this contraption is that there are some rare cases
> where we need to make sure that if we update some global state, all
> the vcpus of a VM need to see, or none of them.
> 
> For these cases, the guarantee comes from luserspace, and it gives the
> pinky promise that none of the vcpus are running at that point. But
> being of a suspicious nature, we assert that this is true by trying to
> take all the vcpu mutexes in one go. This will fail if a vcpu is
> running, as KVM itself takes the vcpu mutex before doing anything.
> 
> Similar requirement exists if we need to synthesise some state for
> userspace from all the individual vcpu states.

Ah, okay. Because x86 is simply doing mutex_lock() instead of
mutex_trylock() -- which would end up waiting for this activity to
subside I suppose.

Hence the use of the killable variant I suppose, for when they get tired
of waiting.

If all the architectures are basically doing the same thing, it might
make sense to unify this particular behaviour. But what do I know.



