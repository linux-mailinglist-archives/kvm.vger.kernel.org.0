Return-Path: <kvm+bounces-57953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 414FEB82166
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 00:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCA1A3AC81B
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 22:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FA630BBA2;
	Wed, 17 Sep 2025 22:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="keainyuX"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66904283FE0
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 22:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758146454; cv=none; b=Ra2ud+2dPpkpodBfvbH0NBwyS6enidXA+occdHyAriBOWHRy+Je62xhmA8BiD+/8hrz+vr5gqZMkZEVD5sC757UTEym/rwZ6mSzttBeKLuc672t/ebUT+4ohqli2HBOtpYEfTgkk7aIsLy75O1uDglj70975Mtp95dPEF7/FJmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758146454; c=relaxed/simple;
	bh=DwZcwwoD0hlZszD7uJ5a/CJC26FomIHim9TULkGhpSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vAjWxuCsPWIHJmK3xZDrSb8S1V4WiAzeRKSzDxNpeojzJh63XGrxpeypouoXq4GoaxhMqy5Ctis1V/bMiN7NvHZtQHKGO27hLQglF4Nx2k5cnCyv1N6VcAqaXRZlvmXnQ5ZJ9sVUJGYyIhKJ0tKhB/s1vvBgV/uF3HRIpDVmwGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=keainyuX; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 17 Sep 2025 15:00:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758146449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2SO80njLlKaFV9bGiNepABSN5e/ENohRhcDTngz1Wxk=;
	b=keainyuXp8ltIREWM43kEcd6qu4WeUgGSQ1BWxBnrGSTk6sBjOZ6+v0hskEpv+s/qgunLl
	TNWSfyFNndbrPhoxaAX5upovftUs+kjSgPDABPGXXUnK7jqhkKWu1cjVa6nFt1l6aBsb6u
	PUp1FWdJuq0eS8TSppAJ6lZ9e0AVnOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [PATCH 07/13] KVM: arm64: selftests: Provide helper for getting
 default vCPU target
Message-ID: <aMsviTd4TGoocUGI@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
 <20250917212044.294760-8-oliver.upton@linux.dev>
 <aMsui6JZ0q1z4pSc@vm4>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMsui6JZ0q1z4pSc@vm4>
X-Migadu-Flow: FLOW_OUT

Hi Itaru,

Appreciate the review.

On Thu, Sep 18, 2025 at 06:56:27AM +0900, Itaru Kitayama wrote:
> On Wed, Sep 17, 2025 at 02:20:37PM -0700, Oliver Upton wrote:
> > The default vCPU target in KVM selftests is pretty boring in that it
> > doesn't enable any vCPU features. Expose a helper for getting the
> > default target to prepare for cramming in more features. Call
> > KVM_ARM_PREFERRED_TARGET directly from get-reg-list as it needs
> > fine-grained control over feature flags.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  tools/testing/selftests/kvm/arm64/psci_test.c   |  2 +-
> >  .../testing/selftests/kvm/arm64/smccc_filter.c  |  2 +-
> >  .../selftests/kvm/arm64/vpmu_counter_access.c   |  4 ++--
> >  tools/testing/selftests/kvm/get-reg-list.c      |  9 ++++++---
> >  .../selftests/kvm/include/arm64/processor.h     |  2 ++
> >  .../testing/selftests/kvm/lib/arm64/processor.c | 17 +++++++++++------
> >  6 files changed, 23 insertions(+), 13 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/arm64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
> > index cf208390fd0e..0d4680da66d1 100644
> > --- a/tools/testing/selftests/kvm/arm64/psci_test.c
> > +++ b/tools/testing/selftests/kvm/arm64/psci_test.c
> > @@ -89,7 +89,7 @@ static struct kvm_vm *setup_vm(void *guest_code, struct kvm_vcpu **source,
> >  
> >  	vm = vm_create(2);
> >  
> > -	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> > +	kvm_get_default_vcpu_target(vm, &init);
> >  	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
> >  
> >  	*source = aarch64_vcpu_add(vm, 0, &init, guest_code);
> 
> I wonder if the ioctl() can be called unconditionally in the 
> aarch64_vcpu_add() function. If the intention is that the kvm selftest
> code needs to write this way I am fine with that.

I had a similar thought but decided against it as tests may need
fine-grained control over the feature flags (like above). I would hope
that most users will use the 'default' VM infrastructure if they do not
need this sort of control.

> Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks!

Best,
Oliver

