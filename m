Return-Path: <kvm+bounces-37233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A8FA2730F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB2FD16641E
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 13:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A89215047;
	Tue,  4 Feb 2025 13:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HBjt2JUh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DA520B1E1;
	Tue,  4 Feb 2025 13:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674949; cv=none; b=kLCufuFza/5vyf74gH4G7Zp7jCfmhGjAyvtKhUH8DQY/h1JPvALqbLC3MlxPUcWW5dyHbsUazYFFDp+Zkxwt4W7E/JOvJa0rXAQ6LqCDmBl+bZu8l8ElL8MWV2DmiIupUEjx9EKk14R0lFUx0AXFkTCWeJfFJxdISyytnYXn0hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674949; c=relaxed/simple;
	bh=b+ooCn/im8Y3Wy7D22WsbfGCMjw6BGtlimqzo81hB08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vjea8lLDHMRguaRXM09wxUTspBrWpC2ISOsPjEoZ1IZGK6znbwIHcykkrw9ToFV2jbki36cqYCLllofx5GJZwaHDD+x9iazCADYK7SPhho9cA7bSWN5IGG9yrCEWMjsZlyI/Rz9F/vDhs+oOr+SibOureQP5noB3ljmOtn12vOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HBjt2JUh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8100C4CEE2;
	Tue,  4 Feb 2025 13:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738674948;
	bh=b+ooCn/im8Y3Wy7D22WsbfGCMjw6BGtlimqzo81hB08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HBjt2JUhwT3fgIobHOL8GA9vfVDqy/djtRNdUsDppWhwxxZmyvgW0HKRSQb5TrdHF
	 dLhhYHXaOPnlUTU4InbkDqBTotf6j4UhhFSvFdO+SyXtILNWmLR3XImgndfnjosyy2
	 o6IopgNfXQjdxcothJQ7IAST9i/togj4yszcOyuyjZykYMCXF+VDx/MEZy0ESmdEhC
	 MH4aqofYhns8Lrse/0mGm0Qg07bCZCynmFmow7u3VR660FLMIxOtX8zE2qp2l0rRG/
	 2rDmU6s+N/PdgKk0fetcqCB4fYgHTUEThAjJZGaqtJdcgIdv5Dcykp40Bm5qG5Y+aO
	 RzIrkSdMK7m7w==
Date: Tue, 4 Feb 2025 18:39:59 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: hyper-v: Convert synic_auto_eoi_used to an
 atomic
Message-ID: <cck44jwjx7h4xtxf32scqy376fd575zn4mhfzxu5k4dry7le3g@thckuzeoujuj>
References: <cover.1738595289.git.naveen@kernel.org>
 <3d8ed6be41358c7635bd4e09ecdfd1bc77ce83df.1738595289.git.naveen@kernel.org>
 <dc784d6e4f6c4478fc18e0bc2d5df56af40d0019.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc784d6e4f6c4478fc18e0bc2d5df56af40d0019.camel@redhat.com>

Hi Maxim,

On Mon, Feb 03, 2025 at 08:30:13PM -0500, Maxim Levitsky wrote:
> On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 6a6dd5a84f22..7a4554ea1d16 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -131,25 +131,18 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
> >  	if (auto_eoi_old == auto_eoi_new)
> >  		return;
> >  
> > -	if (!enable_apicv)
> > -		return;
> > -
> > -	down_write(&vcpu->kvm->arch.apicv_update_lock);
> > -
> >  	if (auto_eoi_new)
> > -		hv->synic_auto_eoi_used++;
> > +		atomic_inc(&hv->synic_auto_eoi_used);
> >  	else
> > -		hv->synic_auto_eoi_used--;
> > +		atomic_dec(&hv->synic_auto_eoi_used);
> >  
> >  	/*
> >  	 * Inhibit APICv if any vCPU is using SynIC's AutoEOI, which relies on
> >  	 * the hypervisor to manually inject IRQs.
> >  	 */
> > -	__kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
> > -					 APICV_INHIBIT_REASON_HYPERV,
> > -					 !!hv->synic_auto_eoi_used);
> > -
> > -	up_write(&vcpu->kvm->arch.apicv_update_lock);
> > +	kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
> > +				       APICV_INHIBIT_REASON_HYPERV,
> > +				       !!atomic_read(&hv->synic_auto_eoi_used));
> 
> Hi,
> 
> This introduces a race, because there is a race window between
> the moment we read hv->synic_auto_eoi_used, and decide to set/clear the inhibit.
> 
> After we read hv->synic_auto_eoi_used, but before we call the kvm_set_or_clear_apicv_inhibit,
> other core might also run synic_update_vector and change hv->synic_auto_eoi_used, 
> finish setting the inhibit in kvm_set_or_clear_apicv_inhibit,
> and only then we will call kvm_set_or_clear_apicv_inhibit with the stale value of hv->synic_auto_eoi_used and clear it.

Ah, indeed. Thanks for the explanation.

I wonder if we can switch to using kvm_hv->hv_lock in place of 
apicv_update_lock. That lock is already used to guard updates to 
partition-wide MSRs in kvm_hv_set_msr_common(). So, that might be ok 
too?


Thanks,
Naveen


