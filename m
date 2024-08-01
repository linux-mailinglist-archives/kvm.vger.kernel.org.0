Return-Path: <kvm+bounces-22939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB83944B90
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 14:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1CD2B249FB
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 12:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A89F1A070F;
	Thu,  1 Aug 2024 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQ8LR14Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEE1194AE6;
	Thu,  1 Aug 2024 12:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722516097; cv=none; b=QgoBEBXvmV0bDsws3jt9Z1xCEbB+rNLEq2SDs4aSfbQ+KA4ygBL0DS33EDZwgHjWnZ+Ajqg6VHfqWa7yu0aE1p/MP7A1dp9s8Dor1R3arW+CF3cRFVTVFPrFzNeD6IU7D4TQ0LNG7FBYldBWtavC2TXqGsKRY5h5Tr0EvkX2dUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722516097; c=relaxed/simple;
	bh=dgSN2qX2pMdRfPMVfoDkmamauFtZYMSKVUq5U/yUdzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdBMH23citerGAO8mOwiA7Q3gRN2ZxEqvYrfbrP9EUcDZWLEmEL/s66qatDz36VGJ1Rba43MMoWxirocqEpaktDtocIkHWeTwN3mc1gImCr0qpiXIjJ3Y6QmAwnHq45YEbPIXpqPXrAM6uowEZTkR1WI2jrmazCwWL/g3IL6Jv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQ8LR14Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862D8C32786;
	Thu,  1 Aug 2024 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722516097;
	bh=dgSN2qX2pMdRfPMVfoDkmamauFtZYMSKVUq5U/yUdzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FQ8LR14YNInTkJXFMl+0hgu5LWIWY+Fze0XvqA7ZVeNmWTY5qyqqgKqeoWbVdwtPB
	 hLyn3uL9x2RowiG86NXtK++pnQZFDFuWa3zJ88dm5mHqcC/psfpkMkH68mh8LAoRuW
	 FkNb9UObRILrJD6O1aiYAVqGHL3h3F7Bq6J9phZnzrBIxpeMxCwPu2Z6VwQr1NwRId
	 6Jpu8r2q0XvBOclh4x33862RZ/YD97RttQD33ycYRWlzCOKi6njl5lasOfs/qJRTaM
	 eY52HhvKRaKIrOYPcV3PnBzkQywD1fG8+3TIIUE1TLLrWrpt4hhFTVN3x1cX+eF0+e
	 Sqs4R1duVeclQ==
Date: Thu, 1 Aug 2024 13:41:32 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
Message-ID: <20240801124131.GA4730@willie-the-truck>
References: <20240730155646.1687-1-will@kernel.org>
 <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co>
 <Zql3vMnR86mMvX2w@google.com>
 <20240731133118.GA2946@willie-the-truck>
 <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co>
 <Zqpj8M3xhPwSVYHY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zqpj8M3xhPwSVYHY@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Jul 31, 2024 at 09:18:56AM -0700, Sean Christopherson wrote:
> On Wed, Jul 31, 2024, Michal Luczaj wrote:
> > On 7/31/24 15:31, Will Deacon wrote:
> > > On Tue, Jul 30, 2024 at 04:31:08PM -0700, Sean Christopherson wrote:
> > >> On Tue, Jul 30, 2024, Michal Luczaj wrote:
> > >>> On 7/30/24 17:56, Will Deacon wrote:
> > >>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > >>>> index d0788d0a72cc..b80dd8cead8c 100644
> > >>>> --- a/virt/kvm/kvm_main.c
> > >>>> +++ b/virt/kvm/kvm_main.c
> > >>>> @@ -4293,7 +4293,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> > >>>>  
> > >>>>  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> > >>>>  		r = -EINVAL;
> > >>>> -		goto kvm_put_xa_release;
> > >>>> +		goto err_xa_release;
> > >>>>  	}
> > >>>>  
> > >>>>  	/*
> > >>>> @@ -4310,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> > >>>>  
> > >>>>  kvm_put_xa_release:
> > >>>>  	kvm_put_kvm_no_destroy(kvm);
> > >>>> +err_xa_release:
> > >>>>  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
> > >>>>  unlock_vcpu_destroy:
> > >>>>  	mutex_unlock(&kvm->lock);
> > >>>
> > >>> My bad for neglecting the "impossible" path. Thanks for the fix.
> > >>>
> > >>> I wonder if it's complete. If we really want to consider the possibility of
> > >>> this xa_store() failing, then keeping vCPU fd installed and calling
> > >>> kmem_cache_free(kvm_vcpu_cache, vcpu) on the error path looks wrong.
> > >>
> > >> Yeah, the vCPU is exposed to userspace, freeing its assets will just cause
> > >> different problems.  KVM_BUG_ON() will prevent _new_ vCPU ioctl() calls (and kick
> > >> running vCPUs out of the guest), but it doesn't interrupt other CPUs, e.g. if
> > >> userspace is being sneaking and has already invoked a vCPU ioctl(), KVM will hit
> > >> a use-after-free (several of them).
> > > 
> > > Damn, yes. Just because we haven't returned the fd yet, doesn't mean
> > > userspace can't make use of it.
> > >
> > >> As Michal alluded to, it should be impossible for xa_store() to fail since KVM
> > >> pre-allocates/reserves memory.  Given that, deliberately leaking the vCPU seems
> > >> like the least awful "solution".
> > > 
> > > Could we actually just move the xa_store() before the fd creation? I
> > > can't immediately see any issues with that...
> > 
> > Hah, please see commit afb2acb2e3a3 :) Long story short: create_vcpu_fd()
> > can legally fail, which must be handled gracefully, which would involve
> > destruction of an already xa_store()ed vCPU, which is racy.
> 
> Ya, the basic problem is that we have two ways of publishing the vCPU, fd and
> vcpu_array, with no way of setting both atomically.  Given that xa_store() should
> never fail, I vote we do the simple thing and deliberately leak the memory.

I'm inclined to agree. This conversation did momentarily get me worried
about the window between the successful create_vcpu_fd() and the
xa_store(), but it looks like 'kvm->online_vcpus' protects that.

I'll spin a v2 leaking the vCPU, then.

Will

