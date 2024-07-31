Return-Path: <kvm+bounces-22763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 968E89430E3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F836B21E0B
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 13:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400AF1B150E;
	Wed, 31 Jul 2024 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkRT3kC8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E6E2208E;
	Wed, 31 Jul 2024 13:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722432684; cv=none; b=IjXGGCaXSnpmpD+QCTvc4KdrWPM29CpP9LVXhlhkT5CT2mrAzmUJRWkNCVYbo1NEe5oh+lycPtfntHp1Zt4quXzL8V21tgUPbzaR9pu/bnnKBdMDWAQdAmIh2B7ziB1drDyjImxOX0OU7ZIgkkodQHAvreK18qaRluNXiSK35sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722432684; c=relaxed/simple;
	bh=zm91Q4SwUAgP+Wn+H1r0fJM1fUPmFDfFMc135yP2Iy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YV2+2FeVHqMSuys301I39iU5kh5ZkGPS2M0CrQECPQE0fave3WHBLvsRYl6mvg9mWZqZ8devyOsDfOE7Jhy0ftfcPi2jz2PThqzjfB7Hvtc5yV5kRRRqK0ES9YNkgYIc9CKiY9TUlxkqp2NOgy/5L4ns5OdWgcfKAcGGNVVzhMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YkRT3kC8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880F9C32786;
	Wed, 31 Jul 2024 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722432683;
	bh=zm91Q4SwUAgP+Wn+H1r0fJM1fUPmFDfFMc135yP2Iy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YkRT3kC8I5ivwMHPtQ8hClLHCgG4uY+uIAdWATS8zuZdvDGD5fll//e2LZ5xLywGO
	 YkEU53cflLdafjYufB2z24eJmUSFo5e/w5q63vygEqsDtxVF/Bln1sIX7BxQrqSDdw
	 sKvMt7PMXF916qIN3RN3mLHLIbPetJBVKZer3SYo3L/M72JlsS8NStUNuOULardnGh
	 Ci8bhcl496TVPzbygkDX2PVa5Gkk34ABOz6di/7wijbJdgpU1qYKcMiBgxsCzYlXLq
	 qnmmNNZW/aIwV7qlN27ozD6E5aDUV05ZLcdi1wcwlhvxF2vgkH6owIdFRpfDB3Lbvu
	 Dr+EmUbmJVwiA==
Date: Wed, 31 Jul 2024 14:31:19 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
Message-ID: <20240731133118.GA2946@willie-the-truck>
References: <20240730155646.1687-1-will@kernel.org>
 <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co>
 <Zql3vMnR86mMvX2w@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zql3vMnR86mMvX2w@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 30, 2024 at 04:31:08PM -0700, Sean Christopherson wrote:
> On Tue, Jul 30, 2024, Michal Luczaj wrote:
> > On 7/30/24 17:56, Will Deacon wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index d0788d0a72cc..b80dd8cead8c 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -4293,7 +4293,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> > >  
> > >  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> > >  		r = -EINVAL;
> > > -		goto kvm_put_xa_release;
> > > +		goto err_xa_release;
> > >  	}
> > >  
> > >  	/*
> > > @@ -4310,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> > >  
> > >  kvm_put_xa_release:
> > >  	kvm_put_kvm_no_destroy(kvm);
> > > +err_xa_release:
> > >  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
> > >  unlock_vcpu_destroy:
> > >  	mutex_unlock(&kvm->lock);
> > 
> > My bad for neglecting the "impossible" path. Thanks for the fix.
> > 
> > I wonder if it's complete. If we really want to consider the possibility of
> > this xa_store() failing, then keeping vCPU fd installed and calling
> > kmem_cache_free(kvm_vcpu_cache, vcpu) on the error path looks wrong.
> 
> Yeah, the vCPU is exposed to userspace, freeing its assets will just cause
> different problems.  KVM_BUG_ON() will prevent _new_ vCPU ioctl() calls (and kick
> running vCPUs out of the guest), but it doesn't interrupt other CPUs, e.g. if
> userspace is being sneaking and has already invoked a vCPU ioctl(), KVM will hit
> a use-after-free (several of them).

Damn, yes. Just because we haven't returned the fd yet, doesn't mean
userspace can't make use of it.

> As Michal alluded to, it should be impossible for xa_store() to fail since KVM
> pre-allocates/reserves memory.  Given that, deliberately leaking the vCPU seems
> like the least awful "solution".

Could we actually just move the xa_store() before the fd creation? I
can't immediately see any issues with that...

Will

