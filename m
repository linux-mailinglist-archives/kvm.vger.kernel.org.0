Return-Path: <kvm+bounces-35580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD61A1292E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B8923A37FC
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 16:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72170192D69;
	Wed, 15 Jan 2025 16:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwNmXlBF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F5315886D;
	Wed, 15 Jan 2025 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736959891; cv=none; b=G73LRNdHio9w85AgYJdr8+paFHCB9VghFxmwKhDaK1X3+vtEbNwDj0UoFhsfEv0PmcRJ/rq07wfSDVbBGieBm1YDipVVa7pjDQSoxvY8yDLPXLq+Shb56++4/UAVJN55PRLTDkNCLTvPKXAyZxSD5hJ76AF7r2+/JUbTMq71IzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736959891; c=relaxed/simple;
	bh=XMPQKBQIrMsLOkkhKRMdJJP0GfR9abGvFF+fnKukqz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZG4HQNToYSA30pM+CyYU2KJPhOtbOCFIwAK1ANai/ZrTB3pkar+2kcQW/JRvebaBaANv/KU4GH2ynNPGli4ME7jFfaq9fqRxqT56JKjSoqWwyQYycmfJEBZfcvIzdSnRKm7jndWznndNsV9ptEpSw+bm/85Ol4xXj7SgWPlq/dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwNmXlBF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777F9C4CED1;
	Wed, 15 Jan 2025 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736959891;
	bh=XMPQKBQIrMsLOkkhKRMdJJP0GfR9abGvFF+fnKukqz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pwNmXlBFD+nXyAYIkktuAyEBUeQh5x0NwidEb+wkiUgV04OBBcLvqqogzZdCCDkHA
	 /40M2kz5yIagvaP/iIjLLxuTXRd67529CR44TytjJijItZUl1KWwPldTAf7x/KuUIv
	 h05NRcOqM1szDZ2ROoSt/TZH8BRGf2ueKnvqQQwal8UNFbUo2kADK3CALJ9j+/4mMH
	 OeB/EDXfwn9xn4MekzPtBoduP7dC3CFNmMlYX16HrroxWBEMr0SeCbSzKW1bizpnyA
	 VrDi96XqbbrKZq6s0bVkdbUMT8GqS4tcBiZgLQNNSSwxF8maZgsz1ibbaZ+5eEOOhu
	 LbYWLfPJSLkjg==
Date: Wed, 15 Jan 2025 09:51:28 -0700
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, michael.christie@oracle.com,
	Tejun Heo <tj@kernel.org>, Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Z4fnkL5-clssIKc-@kbusch-mbp>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z4Uy1beVh78KoBqN@kbusch-mbp>
 <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
 <Z4cmLAu4kdb3cCKo@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4cmLAu4kdb3cCKo@google.com>

On Tue, Jan 14, 2025 at 07:06:20PM -0800, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 2401606db2604..422b6b06de4fe 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -7415,6 +7415,8 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
> > >   {
> > >   	if (nx_hugepage_mitigation_hard_disabled)
> > >   		return 0;
> > > +	if (kvm->arch.nx_huge_page_recovery_thread)
> > > +		return 0;
> 
> ...
> 
> > >   	kvm->arch.nx_huge_page_last = get_jiffies_64();
> > >   	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index c79a8cc57ba42..263363c46626b 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -11463,6 +11463,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> > >   	struct kvm_run *kvm_run = vcpu->run;
> > >   	int r;
> > > +	r = kvm_mmu_post_init_vm(vcpu->kvm);
> > > +	if (r)
> > > +		return r;
> 
> The only lock held at this point is vcpu->mutex, the obvious choices for guarding
> the per-VM task creation are kvm->lock or kvm->mmu_lock, but we definitely don't
> want to blindly take either lock in KVM_RUN.

Thanks for the feedback. Would this otherwise be okay if I use a
different mechanism to ensure the vhost task creation happens only once
per kvm instance? Or are you suggesting the task creation needs to be
somewhere other than KVM_RUN?

My other initial concern was that this makes kvm_destroy_vm less
symmetrical to kvm_create_vm, but that part looks okay: the vcpu that's
being run holds a reference preventing kvm_destroy_vm from being called.

