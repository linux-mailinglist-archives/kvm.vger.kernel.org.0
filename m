Return-Path: <kvm+bounces-45082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 450D2AA5E9A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 14:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AB574A83EC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 12:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E25422688C;
	Thu,  1 May 2025 12:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxDjMdGB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1F41EEE6;
	Thu,  1 May 2025 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746103472; cv=none; b=TYB8Ab9/nImi3fNlgZJwT5oB9ezMX2TJko4+gypc5rGac0jsFtglwdvq+CsSCoJNg7Gzld2BhTzYx4/bWPCfu0xB3K1A2I31czdTyaI4v/NVIIL4540JlC2TbttfJg2sUyfCfOXYL5WqJ/7Tl+Mp2OMGbTo/d19M5v82cmyz+lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746103472; c=relaxed/simple;
	bh=WPG4ItA0UQzz9G5Wed/nsDRuYNB8SmpWf7d7wvrM4Ig=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m4KkZO0oOO/Jti5Zem06Qr98h6IAgcCBcJHvhXe9mW5g4sMB3CJRxQkj5FcSKzgogT32VqyV7/7VXx4eRfVAz9RMJxy+i0ovQyKz+tx8wDci4i9wvfP0oTyGeyPYFs0wbtXFhJj+CtG7uszdg2+rbs4Sgo3RIdy3RbwzQ7ui2hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxDjMdGB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D40FC4CEE3;
	Thu,  1 May 2025 12:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746103472;
	bh=WPG4ItA0UQzz9G5Wed/nsDRuYNB8SmpWf7d7wvrM4Ig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QxDjMdGBaO7OILE121xxXL/ZOnOaqCLtEBXhMWqkB+3PJ/81e/MmSvY1wUToCrhj4
	 o09UND4kIgR1FXBbOv/55FCd/OzVBwRgoBGOKRqd4tO9c5cjsRV1GlGty2ybIey98M
	 Lg+nMO5pZgEPqvPhdAFXoifIaxQoyNf5AIQ+1z0cDZWJ9kRunCBuAPEBO/FXXum7lW
	 W1LmcTN82A52L8g5iIa5Ucd/iUs8WO+yyP/I650zIl0luAwZDGv+aVLdfXY2xUanJs
	 d03TuxAlnXfTT8Rtp+TeEMdJfupvUktoh6E1sLRqamQNoOxsDebivNk/cK+bAp+RnI
	 Bf6br0mFislfA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uATHB-00AZcw-3q;
	Thu, 01 May 2025 13:44:29 +0100
Date: Thu, 01 May 2025 13:44:28 +0100
Message-ID: <861pt8ijpv.wl-maz@kernel.org>
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
In-Reply-To: <20250501111552.GO4198@noisy.programming.kicks-ass.net>
References: <20250430203013.366479-1-mlevitsk@redhat.com>
	<20250430203013.366479-3-mlevitsk@redhat.com>
	<864iy4ivro.wl-maz@kernel.org>
	<20250501111552.GO4198@noisy.programming.kicks-ass.net>
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

On Thu, 01 May 2025 12:15:52 +0100,
Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > + */
> > > +int kvm_trylock_all_vcpus(struct kvm *kvm)
> > > +{
> > > +	struct kvm_vcpu *vcpu;
> > > +	unsigned long i, j;
> > > +
> > > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > > +		if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))
> 
> This one includes an assertion that kvm->lock is actually held.

Ah, cunning. Thanks.

> That said, I'm not at all sure what the purpose of all this trylock
> stuff is here.
> 
> Can someone explain? Last time I asked someone said something about
> multiple VMs, but I don't know enough about kvm to know what that means.

Multiple VMs? That'd be real fun. Not.

> Are those vcpu->mutex another class for other VMs? Or what gives?

Nah. This is firmly single VM.

The purpose of this contraption is that there are some rare cases
where we need to make sure that if we update some global state, all
the vcpus of a VM need to see, or none of them.

For these cases, the guarantee comes from luserspace, and it gives the
pinky promise that none of the vcpus are running at that point. But
being of a suspicious nature, we assert that this is true by trying to
take all the vcpu mutexes in one go. This will fail if a vcpu is
running, as KVM itself takes the vcpu mutex before doing anything.

Similar requirement exists if we need to synthesise some state for
userspace from all the individual vcpu states.

If the global locking fails, we return to userspace with a middle
finger indication, and all is well. Of course, this is pretty
expensive, which is why it is only done in setup phases, when the VMM
configures the guest.

The splat this is trying to address is that when you have more than 48
vcpus in a single VM, lockdep gets upset seeing up to 512 locks of a
similar class being taken.

Disclaimer: all the above is completely arm64-specific, and I didn't
even try to understand what other architectures are doing.

HTH,

	M.

-- 
Without deviation from the norm, progress is not possible.

