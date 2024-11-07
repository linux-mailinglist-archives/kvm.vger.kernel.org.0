Return-Path: <kvm+bounces-31172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C2B9C0F8F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A47851C2240C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E57217F3F;
	Thu,  7 Nov 2024 20:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aLXg3M1V"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6308721767B
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731010380; cv=none; b=dxCKWDDVGVsjfeS6PhjeSeovOoLDcRKTw4TnfqSuud2H2t2xKRMZd08/EDNLPFJ63y+ljJzJeaW6L2kT+um3DCWH0bByAFI4qc1chvJkiRBphs6xAGKfvKj+PLlESFEYXEg+EmmcmCKJSZZ/icFaKmnlyectyZP0hhnBsgAleeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731010380; c=relaxed/simple;
	bh=HkXk2116VXPTy0WsZYDmb3OcLe+jwjFBjUK4e3Cot7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUQneFyawlmk1NPRAiUUbVl3hnuGLn365HFehUxpuhr7Kz3zIKjUTRhXb6JTuyyKeQh+EOAEpG8eWF6TW+U9q9fX2vTdNOF8Vx+7xZlFQlnLkskRU5JyWfjHIwnHB3dP5Rw5593ezGcEBUsE2sa1CiUN5yDLKCWiA9sqvi2BlLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aLXg3M1V; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 7 Nov 2024 12:12:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731010375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=md1Yypu0rpYHhpDf+gbGftNadDIDh4a8KSfnBuItRrg=;
	b=aLXg3M1VtbQdZ0wwQ7VrnWXCSNjjexGviMquZZ1rHx0uynu/52qWHrem3Q5g7vCPfizqTj
	KG47QLcyeg78GndKL1blrPW77fH1L7CazBizIozgrU24UCKVr+ToaRJRImLCmwi4K+7DkI
	bj+Eb7UeZL54x5nQEiT/oCxrGswpEu0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
	broonie@kernel.org, maz@kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, joey.gouly@arm.com, shuah@kernel.org,
	pbonzini@redhat.com
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
Message-ID: <Zy0fPgwymCdBwLd_@linux.dev>
References: <20241107094000.70705-1-eric.auger@redhat.com>
 <20241107094000.70705-3-eric.auger@redhat.com>
 <Zyz_KGtoXt0gnMM8@google.com>
 <Zy0QFhFsICeNt8kF@linux.dev>
 <Zy0bcM0m-N18gAZz@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zy0bcM0m-N18gAZz@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 07, 2024 at 11:56:32AM -0800, Sean Christopherson wrote:
> On Thu, Nov 07, 2024, Oliver Upton wrote:
> > On Thu, Nov 07, 2024 at 09:55:52AM -0800, Sean Christopherson wrote:
> > > On Thu, Nov 07, 2024, Eric Auger wrote:
> > > > In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
> > > > KVM ioctls will fail and cause test failure. This now happens
> > > > with an aarch64 vgic test where the kvm_vm_free() fails. Let's
> > > > add a new kvm_vm_dead_free() helper that does all the deallocation
> > > > besides the KVM_SET_USER_MEMORY_REGION2 ioctl.
> > > 
> > > Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
> > > The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
> > > a more helpful error message, it is most definitely not intended to be an "official"
> > > way to detect and react to the VM being dead.
> > > 
> > > IMO, tests that intentionally result in a dead VM should assert that subsequent
> > > VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
> > > resources adds complexity and pollutes the core selftests APIs, with very little
> > > benefit.
> > 
> > Encouraging tests to explicitly leak resources to fudge around assertions
> > in the selftests library seems off to me.
> 
> I don't disagree, but I really, really don't want to add vm_dead().

It'd still be valuable to test that the VM is properly dead and
subsequent ioctls also return EIO, but I understand the hesitation.

> > IMO, the better approach would be to provide a helper that gives the
> > impression of freeing the VM but implicitly leaks it, paired with some
> > reasoning for it.
> 
> Actually, duh.  There's no need to manually delete KVM memslots for *any* VM,
> dead or alive.  Just skip that unconditionally when freeing the VM, and then the
> vGIC test just needs to assert on -EIO instead -ENXIO/-EBUSY.

Yeah, that'd tighten up the assertions a bit more to the exact ioctl
where we expect the VM to go sideways.

> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 7 Nov 2024 11:39:59 -0800
> Subject: [PATCH] KVM: selftests: Don't bother deleting memslots in KVM when
>  freeing VMs
> 
> When freeing a VM, don't call into KVM to manually remove each memslot,
> simply cleanup and free any userspace assets associated with the memory
> region.  KVM is ultimately responsible for ensuring kernel resources are
> freed when the VM is destroyed, deleting memslots one-by-one is
> unnecessarily slow, and unless a test is already leaking the VM fd, the
> VM will be destroyed when kvm_vm_release() is called.
> 
> Not deleting KVM's memslot also allows cleaning up dead VMs without having
> to care whether or not the to-be-freed VM is dead or alive.

Can you add a comment to kvm_vm_free() about why we want to avoid ioctls
in that helper? It'd help discourage this situation from happening again
in the future in the unlikely case someone wants to park an ioctl there.

> Reported-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I'm assuming you want to take this, happy to grab it otherwise.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> > > Marking a VM dead should be a _very_ rare event; it's not something that I think
> > > we should encourage, i.e. we shouldn't make it easier to deal with.  Ideally,
> > > use of kvm_vm_dead() should be limited to things like sev_vm_move_enc_context_from(),
> > > where KVM needs to prever accessing the source VM to protect the host.  IMO, the
> > > vGIC case and x86's enter_smm() are hacks.  E.g. I don't see any reason why the
> > > enter_smm() case can't synthesize a triple fault.
> > 
> > The VGIC case is at least better than the alternative of slapping
> > bandaids all over the shop to cope with a half-baked VM and ensure we
> > tear it down correctly. Userspace is far up shit creek at the point the
> > VM is marked as dead, so I don't see any value in hobbling along
> > afterwards.
> 
> Again, I don't disagree, but I don't want to normalize shooting the VM on errors.

Definitely not. It is very much a break-glass situation where this is
even somewhat OK.

-- 
Thanks,
Oliver

