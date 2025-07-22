Return-Path: <kvm+bounces-53053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B43B0CF7A
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 04:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5692F5401A9
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 02:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ABA1D7E35;
	Tue, 22 Jul 2025 02:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FCwsnUrR"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D64918E25;
	Tue, 22 Jul 2025 02:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753149700; cv=none; b=ADr7J57u0UDSneLMOhH5Oykk+4w063aEIzhYt8D7mcQngcDjKdos425IMpkLTAyTRqw70xK0bKVckJnHoQwytjF89LMkVfTXpHseaZiiQKZWTFafqFZrHsqeqiR87jFhRGLaPQZ0abt73YdTbBZqnzXjx6TxwFzu1RRpl0FlN84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753149700; c=relaxed/simple;
	bh=zadc3FUqslMHFJYHO8aC1wjvFGNjIULcllHpfpeN+2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5ac0BFt8qmuePlqxpzsfDpcPKSRCwJGyDcH+EmRezlZVyzYln6RVXKR0TKYSFRb8h2QylSuhkaqvS5reimBc38rOPp+SkcpCAZOLf5qdo13eUmZMCCmHzTCw9cd8cQe6SBV4lpUXxhIcW2BOGdY8030KJpXZEzMghc5YDLjPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FCwsnUrR; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753149688; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=JXNM3pwI7U37QIp2W81rPzC0o3Xw9VVk8ohyCB9V5Ac=;
	b=FCwsnUrRJxgiweJJ11fjW4DGMy5PY0FPxwOwx5lg0WNpYURHuMYejaXD2jNdZjx9JOxLojoipIWoTveyWwa7d4p+46wGWFzt3dJrBKhC1Dn88RPYoS4EjfLq5CVseZdk6LSlk+v59RTVsfRBJrE7TaKI97ySJP/6rOQkG+Bzyh4=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WjTepwY_1753149687 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Jul 2025 10:01:27 +0800
Date: Tue, 22 Jul 2025 10:01:27 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Keir Fraser <keirf@google.com>
Cc: Yao Yuan <yaoyuan0329os@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
Message-ID: <lb3i3h2rwq3kvm6tqoiiyrqcpqe2ctxcwmapgifii3dzqzfuqh@eqcqeudpfjlg>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
 <aHphgd0fOjHXjPCI@google.com>
 <5zpxxmymnyzncdnewdonnglvmvbtggjyxyqvkf6yars2bbyr4b@gottasrtoq2s>
 <aHtQG_k_1q3862s3@google.com>
 <4i65mgp4rtfox2ttchamijofcmwjtd6sefmuhdkfdrjwaznhoc@2uhcfv2ziegj>
 <aH3w9t78dvxsDjhV@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH3w9t78dvxsDjhV@google.com>

On Mon, Jul 21, 2025 at 07:49:10AM +0800, Keir Fraser wrote:
> On Sun, Jul 20, 2025 at 08:08:30AM +0800, Yao Yuan wrote:
> > On Sat, Jul 19, 2025 at 07:58:19AM +0000, Keir Fraser wrote:
> > > On Sat, Jul 19, 2025 at 10:15:56AM +0800, Yao Yuan wrote:
> > > > On Fri, Jul 18, 2025 at 08:00:17AM -0700, Sean Christopherson wrote:
> > > > > On Thu, Jul 17, 2025, Yao Yuan wrote:
> > > > > > On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > > > > > > In preparation to remove synchronize_srcu() from MMIO registration,
> > > > > > > remove the distributor's dependency on this implicit barrier by
> > > > > > > direct acquire-release synchronization on the flag write and its
> > > > > > > lock-free check.
> > > > > > >
> > > > > > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > > > > > ---
> > > > > > >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> > > > > > >  1 file changed, 2 insertions(+), 9 deletions(-)
> > > > > > >
> > > > > > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > > index 502b65049703..bc83672e461b 100644
> > > > > > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > > > > >  	gpa_t dist_base;
> > > > > > >  	int ret = 0;
> > > > > > >
> > > > > > > -	if (likely(dist->ready))
> > > > > > > +	if (likely(smp_load_acquire(&dist->ready)))
> > > > > > >  		return 0;
> > > > > > >
> > > > > > >  	mutex_lock(&kvm->slots_lock);
> > > > > > > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > > > > >  		goto out_slots;
> > > > > > >  	}
> > > > > > >
> > > > > > > -	/*
> > > > > > > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > > > > > > -	 * registration before returning through synchronize_srcu(), which also
> > > > > > > -	 * implies a full memory barrier. As such, marking the distributor as
> > > > > > > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > > > > > > -	 * a completely configured distributor.
> > > > > > > -	 */
> > > > > > > -	dist->ready = true;
> > > > > > > +	smp_store_release(&dist->ready, true);
> > > > > >
> > > > > > No need the store-release and load-acquire for replacing
> > > > > > synchronize_srcu_expedited() w/ call_srcu() IIUC:
> > > > >
> > > > > This isn't about using call_srcu(), because it's not actually about kvm->buses.
> > > > > This code is concerned with ensuring that all stores to kvm->arch.vgic are ordered
> > > > > before the store to set kvm->arch.vgic.ready, so that vCPUs never see "ready==true"
> > > > > with a half-baked distributor.
> > > > >
> > > > > In the current code, kvm_vgic_map_resources() relies on the synchronize_srcu() in
> > > > > kvm_io_bus_register_dev() to provide the ordering guarantees.  Switching to
> > > > > smp_store_release() + smp_load_acquire() removes the dependency on the
> > > > > synchronize_srcu() so that the synchronize_srcu() call can be safely removed.
> > > >
> > > > Yes, I understand this and agree with your point.
> > > >
> > > > Just for discusstion: I thought it should also work even w/o
> > > > introduce the load acqure + store release after switch to
> > > > call_srcu(): The smp_mb() in call_srcu() order the all store
> > > > to kvm->arch.vgic before store kvm->arch.vgic.ready in
> > > > current implementation.
> > >
> > > The load-acquire would still be required, to ensure that accesses to
> > > kvm->arch.vgic do not get reordered earlier than the lock-free check
> > > of kvm->arch.vgic.ready. Otherwise that CPU could see that the vgic is
> > > initialised, but then use speculated reads of uninitialised vgic state.
> > >
> >
> > Thanks for your explanation.
> >
> > I see. But there's "mutex_lock(&kvm->slot_lock);" before later
> > acccessing to the kvm->arch.vgic, so I think the order can be
> > guaranteed. Of cause as you said a explicitly acquire-load +
> > store-release is better than before implicitly implementation.
>
> If vgic_dist::ready is observed true by the lock-free read (the one
> which is turned into load-acquire by this patch) then the function
> immediately returns with no mutex_lock() executed. It is reads of
> vgic_dist *after* return from kvm_vgic_map_resources() that you have
> to worry about, and which require load-acquire semantics.

I think this is the main purpose of such lock-free reading
here, to avoid lock contention on VM w/ large vCPUs for
vcpus' first time run together.

store-release makes sure the changes to vgic_dist::ready
become visible after the changes to vgic_dist become
visible, but it doesn't guarantee the vgic_dist::ready
becomes visible to reader on aother CPU **IMMEDIATELY**,
thus load-acquire in reader side is request for this.
Is above understanding correct ?

>
> >
> > > > >

