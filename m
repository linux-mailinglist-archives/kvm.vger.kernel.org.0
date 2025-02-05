Return-Path: <kvm+bounces-37327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9DEEA288DF
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 12:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3920C7A5E84
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D28922C339;
	Wed,  5 Feb 2025 11:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WUpPQ07+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF0522C356;
	Wed,  5 Feb 2025 11:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738753410; cv=none; b=NHtwRC++/fsTj3ZNkHCEkjX78VlKVlxXCh5ud6yNvkmjMz5s8esPz6CmLfw4ZH8T+vEvpTxS49BAdcjQM716miElwx+D3FydfQhQLzHvdLyIuXnfH3Iay/e2C7+DqYppQ8yJCHce9Eg/AlJtLPK4XIYuk+mMk9cJeFEmDVaPxy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738753410; c=relaxed/simple;
	bh=OuY74I+VqKoJ0NRQ64aHSB+Wh+45A5V+/R3/QTvXfrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8MXJBCyF3YLaAgMdbRDGro/ocbeL2RH0aMMjS4y3ct5y40N7u5zfQoNXS0letT/0vl1+X3iVrLJ+UwqkxSFmJI3uUNjxnM4aUGjP5EFatyTp9/t7MNLjNfj/qUttmHx8LP2iH720B0YZT5dVffbLQZP9Au6wINMsD7JiaiwJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WUpPQ07+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2EEC4CED1;
	Wed,  5 Feb 2025 11:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738753409;
	bh=OuY74I+VqKoJ0NRQ64aHSB+Wh+45A5V+/R3/QTvXfrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WUpPQ07+3fMSupwSbLeYDWhHBHTOPgzv3MyaQzerj6AOWQvfMD9g+1p4qhxot5Mzg
	 j++JR0goTniTqjxlpl/Xb315LWYVLN9vgSAwtfaaigsIDs2IoJODNQMNhC/7PY6XOD
	 0JJLhHXb/qfdfUJM1ptD9pxNLgFwWZKV5jJLlAut2zxSmVHhXGTiYHvKgWm1IlZh6O
	 DuXpUm3wkfdUJ1VtIb/lDbUTluszNm/0bOcQZZx7JQgMNWcPLfoKKAmVXI2H0Be4/r
	 AAey+vS0N7pLp+775iaTMe3/2iMH7SGCCOEFX2gjzSBuS1KV25CaSFyIqK4j4EC9u+
	 YorUoLIi3906Q==
Date: Wed, 5 Feb 2025 16:30:29 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: hyper-v: Convert synic_auto_eoi_used to an
 atomic
Message-ID: <xaihcdtaqimcu5knl2cqvj36dfwqq6xizxr7eg6cwyqsvwj2zr@tgjhldlrarp2>
References: <cover.1738595289.git.naveen@kernel.org>
 <3d8ed6be41358c7635bd4e09ecdfd1bc77ce83df.1738595289.git.naveen@kernel.org>
 <dc784d6e4f6c4478fc18e0bc2d5df56af40d0019.camel@redhat.com>
 <cck44jwjx7h4xtxf32scqy376fd575zn4mhfzxu5k4dry7le3g@thckuzeoujuj>
 <Z6JrbfQ-4bsERzA1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6JrbfQ-4bsERzA1@google.com>

On Tue, Feb 04, 2025 at 11:33:01AM -0800, Sean Christopherson wrote:
> On Tue, Feb 04, 2025, Naveen N Rao wrote:
> > Hi Maxim,
> > 
> > On Mon, Feb 03, 2025 at 08:30:13PM -0500, Maxim Levitsky wrote:
> > > On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
> > > > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > > > index 6a6dd5a84f22..7a4554ea1d16 100644
> > > > --- a/arch/x86/kvm/hyperv.c
> > > > +++ b/arch/x86/kvm/hyperv.c
> > > > @@ -131,25 +131,18 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
> > > >  	if (auto_eoi_old == auto_eoi_new)
> > > >  		return;
> > > >  
> > > > -	if (!enable_apicv)
> > > > -		return;
> > > > -
> > > > -	down_write(&vcpu->kvm->arch.apicv_update_lock);
> > > > -
> > > >  	if (auto_eoi_new)
> > > > -		hv->synic_auto_eoi_used++;
> > > > +		atomic_inc(&hv->synic_auto_eoi_used);
> > > >  	else
> > > > -		hv->synic_auto_eoi_used--;
> > > > +		atomic_dec(&hv->synic_auto_eoi_used);
> > > >  
> > > >  	/*
> > > >  	 * Inhibit APICv if any vCPU is using SynIC's AutoEOI, which relies on
> > > >  	 * the hypervisor to manually inject IRQs.
> > > >  	 */
> > > > -	__kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
> > > > -					 APICV_INHIBIT_REASON_HYPERV,
> > > > -					 !!hv->synic_auto_eoi_used);
> > > > -
> > > > -	up_write(&vcpu->kvm->arch.apicv_update_lock);
> > > > +	kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
> > > > +				       APICV_INHIBIT_REASON_HYPERV,
> > > > +				       !!atomic_read(&hv->synic_auto_eoi_used));
> > > 
> > > Hi,
> > > 
> > > This introduces a race, because there is a race window between the moment
> > > we read hv->synic_auto_eoi_used, and decide to set/clear the inhibit.
> > > 
> > > After we read hv->synic_auto_eoi_used, but before we call the
> > > kvm_set_or_clear_apicv_inhibit, other core might also run
> > > synic_update_vector and change hv->synic_auto_eoi_used, finish setting the
> > > inhibit in kvm_set_or_clear_apicv_inhibit, and only then we will call
> > > kvm_set_or_clear_apicv_inhibit with the stale value of
> > > hv->synic_auto_eoi_used and clear it.
> > 
> > Ah, indeed. Thanks for the explanation.
> > 
> > I wonder if we can switch to using kvm_hv->hv_lock in place of 
> > apicv_update_lock. That lock is already used to guard updates to 
> > partition-wide MSRs in kvm_hv_set_msr_common(). So, that might be ok 
> > too?
> 
> Why?  All that would do is add complexity (taking two locks, or ensuring there
> is no race when juggling locks), because if the guest is actually 
> toggling AutoEOI
> at a meaningful rate on multiple vCPUs, then there is going to be lock contention
> regardless of which lock is taken.

Yes, indeed.

The rationale for switching to a different lock was to address the 
original goal with this patch, which is to restrict use of 
apicv_update_lock to only toggling the APICv state. But, that is only 
relevant if we want to attempt that.

I do see why hv_lock won't work in this scenario though, so yes, we 
either need to retain use of apicv_update_lock, or introduce a new mutex 
for protecting updates to synic_auto_eoi_used.


Thanks,
Naveen


