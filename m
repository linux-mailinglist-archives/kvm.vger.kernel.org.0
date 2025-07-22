Return-Path: <kvm+bounces-53054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B4FB0CF9C
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 04:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C40A3B2990
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 02:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390171DFE0B;
	Tue, 22 Jul 2025 02:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NYydIyw+"
X-Original-To: kvm@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8899AE573;
	Tue, 22 Jul 2025 02:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753150952; cv=none; b=MIcibHe7dhN9K6+20BMboABEvJMY0jn5nlU7AVbnIZ3aF1gluT6UgoFdnPS5goN6nBoLm7s0bXVFB9jprRXwgKDQmjqbe6WNo9TraZcmPzqKe2FerFej0ekzZ5zynCTJE7P/yQwm1tCAmx+paS3qOm8/LrFovm2rB58Z4hdXJj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753150952; c=relaxed/simple;
	bh=QbTtBiEuTKJxsVRJATE0jtxPRwX8pZR6yE5+I+zORZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F17xt5xqLm//r3hE5rm0VjIk1YO+QfKLK/64PaaJwO9htZfulRFD4a7Kz/BQn6ZH4gx/CcDka9FEqFabhYPyvPoQMC9oIElNPnqGu3OPkJo3FfccWoKIfXehO/KLTzRaB8GzebB0uflqWZJhuFnDudC9PMMOa4fCAUNE5ckCW+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NYydIyw+; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753150947; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=rnddjr1TA6eWUS4Z0+c9ZMpNcvutQ6Idh5vDJofAMV4=;
	b=NYydIyw+h0Efb4xeksI1MwNI9i8Y+FVFfwE729kHrzJZEUV9/FY/fnq6pjfKz/b5o1UFKxmrNn9YEPsrh7wlFj1MUq9/KRhk0DEpVKyRx8fH0czaT3EJmeqQGpi4aVitS/N5oZvoLA1P5zVoPUIOPyx9lHXDkblMeijCqlWzLTg=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WjTxcb9_1753150945 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Jul 2025 10:22:26 +0800
Date: Tue, 22 Jul 2025 10:22:25 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Keir Fraser <keirf@google.com>
Cc: Yao Yuan <yaoyuan0329os@gmail.com>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
Message-ID: <icgg7uqbhoj674wjhngwf3svbvikofjgubtgcua64epaf4kxil@oyjyydk7asxp>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
 <aHphgd0fOjHXjPCI@google.com>
 <5zpxxmymnyzncdnewdonnglvmvbtggjyxyqvkf6yars2bbyr4b@gottasrtoq2s>
 <aHtQG_k_1q3862s3@google.com>
 <4i65mgp4rtfox2ttchamijofcmwjtd6sefmuhdkfdrjwaznhoc@2uhcfv2ziegj>
 <aH3w9t78dvxsDjhV@google.com>
 <lb3i3h2rwq3kvm6tqoiiyrqcpqe2ctxcwmapgifii3dzqzfuqh@eqcqeudpfjlg>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lb3i3h2rwq3kvm6tqoiiyrqcpqe2ctxcwmapgifii3dzqzfuqh@eqcqeudpfjlg>

On Tue, Jul 22, 2025 at 10:01:27AM +0800, Yao Yuan wrote:
> On Mon, Jul 21, 2025 at 07:49:10AM +0800, Keir Fraser wrote:
> > On Sun, Jul 20, 2025 at 08:08:30AM +0800, Yao Yuan wrote:
> > > On Sat, Jul 19, 2025 at 07:58:19AM +0000, Keir Fraser wrote:
> > > > On Sat, Jul 19, 2025 at 10:15:56AM +0800, Yao Yuan wrote:
> > > > > On Fri, Jul 18, 2025 at 08:00:17AM -0700, Sean Christopherson wrote:
> > > > > > On Thu, Jul 17, 2025, Yao Yuan wrote:
> > > > > > > On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > > > > > > > In preparation to remove synchronize_srcu() from MMIO registration,
> > > > > > > > remove the distributor's dependency on this implicit barrier by
> > > > > > > > direct acquire-release synchronization on the flag write and its
> > > > > > > > lock-free check.
> > > > > > > >
> > > > > > > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > > > > > > ---
> > > > > > > >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> > > > > > > >  1 file changed, 2 insertions(+), 9 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > > > index 502b65049703..bc83672e461b 100644
> > > > > > > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > > > > > > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > > > > > >  	gpa_t dist_base;
> > > > > > > >  	int ret = 0;
> > > > > > > >
> > > > > > > > -	if (likely(dist->ready))
> > > > > > > > +	if (likely(smp_load_acquire(&dist->ready)))
> > > > > > > >  		return 0;
> > > > > > > >
> > > > > > > >  	mutex_lock(&kvm->slots_lock);
> > > > > > > > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > > > > > > >  		goto out_slots;
> > > > > > > >  	}
> > > > > > > >
> > > > > > > > -	/*
> > > > > > > > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > > > > > > > -	 * registration before returning through synchronize_srcu(), which also
> > > > > > > > -	 * implies a full memory barrier. As such, marking the distributor as
> > > > > > > > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > > > > > > > -	 * a completely configured distributor.
> > > > > > > > -	 */
> > > > > > > > -	dist->ready = true;
> > > > > > > > +	smp_store_release(&dist->ready, true);
> > > > > > >
> > > > > > > No need the store-release and load-acquire for replacing
> > > > > > > synchronize_srcu_expedited() w/ call_srcu() IIUC:
> > > > > >
> > > > > > This isn't about using call_srcu(), because it's not actually about kvm->buses.
> > > > > > This code is concerned with ensuring that all stores to kvm->arch.vgic are ordered
> > > > > > before the store to set kvm->arch.vgic.ready, so that vCPUs never see "ready==true"
> > > > > > with a half-baked distributor.
> > > > > >
> > > > > > In the current code, kvm_vgic_map_resources() relies on the synchronize_srcu() in
> > > > > > kvm_io_bus_register_dev() to provide the ordering guarantees.  Switching to
> > > > > > smp_store_release() + smp_load_acquire() removes the dependency on the
> > > > > > synchronize_srcu() so that the synchronize_srcu() call can be safely removed.
> > > > >
> > > > > Yes, I understand this and agree with your point.
> > > > >
> > > > > Just for discusstion: I thought it should also work even w/o
> > > > > introduce the load acqure + store release after switch to
> > > > > call_srcu(): The smp_mb() in call_srcu() order the all store
> > > > > to kvm->arch.vgic before store kvm->arch.vgic.ready in
> > > > > current implementation.
> > > >
> > > > The load-acquire would still be required, to ensure that accesses to
> > > > kvm->arch.vgic do not get reordered earlier than the lock-free check
> > > > of kvm->arch.vgic.ready. Otherwise that CPU could see that the vgic is
> > > > initialised, but then use speculated reads of uninitialised vgic state.
> > > >
> > >
> > > Thanks for your explanation.
> > >
> > > I see. But there's "mutex_lock(&kvm->slot_lock);" before later
> > > acccessing to the kvm->arch.vgic, so I think the order can be
> > > guaranteed. Of cause as you said a explicitly acquire-load +
> > > store-release is better than before implicitly implementation.
> >
> > If vgic_dist::ready is observed true by the lock-free read (the one
> > which is turned into load-acquire by this patch) then the function
> > immediately returns with no mutex_lock() executed. It is reads of
> > vgic_dist *after* return from kvm_vgic_map_resources() that you have
> > to worry about, and which require load-acquire semantics.
>
> I think this is the main purpose of such lock-free reading
> here, to avoid lock contention on VM w/ large vCPUs for
> vcpus' first time run together.
>
> store-release makes sure the changes to vgic_dist::ready
> become visible after the changes to vgic_dist become
> visible, but it doesn't guarantee the vgic_dist::ready
> becomes visible to reader on aother CPU **IMMEDIATELY**,
> thus load-acquire in reader side is request for this.
> Is above understanding correct ?

No. I get your point, the load-acuqire here for:

There's code path that the cpu read the vgic_dist reorder
before the vgic_dist::ready in case of the cpu get
vgic_dist::ready is true w/o the load_acquire here.

>
> >
> > >
> > > > > >

