Return-Path: <kvm+bounces-43809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAF6A96507
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFD137A46A1
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5FC1F5617;
	Tue, 22 Apr 2025 09:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qre4BV9t"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0616F50F
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745315437; cv=none; b=l9DBfxNwjYhkDibN0zTmHvsPbIpp863zFLSfJIOz4B1+yFKRH5CWiNbXI0+OT7RFvVlfPj4DkQl/Pa7giJ5zAniI5p10adppboMswj6lEpdUrir+sPhLZkdAjp/i2RRqxCX2eQH2I4FGA0wkks0WL4i909D1/pmTFy+GEhNM0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745315437; c=relaxed/simple;
	bh=zDV8OxNLQ8MhcmOT1G6Ea6ESv4kGJYgT3u5B/5/FiJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ileHqwTHb2dl5Tpcy62ZubaaEgVbC5+zZrthZVmmirApcz0TEFyyqtL2YoAreb4tXHvBkkWcDBfQmd9XkaIy+sfm994gm7BBK8/Hb2RGTJvJQyq8E1GH/o2tAhx1RhLOfgC3Ot5PUl5mfS6rF67YLGLSgfcnlBQ6djA3VORvkXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qre4BV9t; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 22 Apr 2025 02:50:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745315422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5UdJAOdV/668zvHtmpZ0xxxMpckLQ1uAstFNlgQV1vw=;
	b=qre4BV9tLsGeIf59kGU51ge7hOIju0IJVihA25NgW/o9nWdTridPvccoWQ7i1hqZKgJ8Qc
	IgjYci9v/6p9X0DvxSyJbkLSrzJlNwcTZ5DKNBc82lfdP2SVrdsYNBjI5S+f0EShju4/o2
	ZkU708BKkhJAnlZPjkMqWdDq8lzdCqA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 09/24] KVM: SEV: Generalize tracking ASID->vCPU with
 xarrays
Message-ID: <aAdmWtPWsS0tHf29@Asmaa.>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-10-yosry.ahmed@linux.dev>
 <de73e879d6775a9900789a64fcea0f90e557681f.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de73e879d6775a9900789a64fcea0f90e557681f.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 03, 2025 at 04:05:12PM -0400, Maxim Levitsky wrote:
> On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> > Following changes will track ASID to vCPU mappings for all ASIDs, not
> > just SEV ASIDs. Using per-CPU arrays with the maximum possible number of
> > ASIDs would be too expensive.
> 
> Maybe add a word or two to explain that currently # of SEV ASIDS is small
> but # of all ASIDS is relatively large (like 16 bit number or so)?

Good idea.

> > @@ -1573,13 +1567,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  	if (sev_guest(vcpu->kvm)) {
> >  		/*
> >  		 * Flush the TLB when a different vCPU using the same ASID is
> > -		 * run on the same CPU.
> > +		 * run on the same CPU. xa_store() should always succeed because
> > +		 * the entry is reserved when the ASID is allocated.
> >  		 */
> >  		asid = sev_get_asid(vcpu->kvm);
> > -		if (sd->sev_vcpus[asid] != vcpu) {
> > -			sd->sev_vcpus[asid] = vcpu;
> > +		prev = xa_store(&sd->asid_vcpu, asid, vcpu, GFP_ATOMIC);
> > +		if (prev != vcpu || WARN_ON_ONCE(xa_err(prev)))
> 
> Tiny nitpick: I would have prefered to have WARN_ON_ONCE(xa_err(prev) first in the above condition,
> because in theory we shouldn't use a value before we know its not an error,
> but in practice this doesn't really matter.

I think it's fine because we are just comparing 'prev' to the vCPU
pointer we have, we are not dereferencing it. So it should be safe. I'd
rather only check the error condition last because it shouldn't ever
happen.

> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 3ab2a424992c1..4929b96d3d700 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -340,8 +340,7 @@ struct svm_cpu_data {
> >  
> >  	struct vmcb *current_vmcb;
> >  
> > -	/* index = sev_asid, value = vcpu pointer */
> Maybe keep the above comment?

I think it's kinda pointless tbh because it's obvious from how the
xarray is used, but I am fine with keeping it if others agree it's
useful.

> 
> > -	struct kvm_vcpu **sev_vcpus;
> > +	struct xarray asid_vcpu;
> >  };
> >  
> >  DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
> > @@ -655,6 +654,8 @@ void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
> >  void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
> >  void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
> >  				     int trig_mode, int vec);
> > +bool svm_register_asid(unsigned int asid);
> > +void svm_unregister_asid(unsigned int asid);
> >  
> >  /* nested.c */
> >  
> > @@ -793,7 +794,6 @@ void sev_vm_destroy(struct kvm *kvm);
> >  void __init sev_set_cpu_caps(void);
> >  void __init sev_hardware_setup(void);
> >  void sev_hardware_unsetup(void);
> > -int sev_cpu_init(struct svm_cpu_data *sd);
> >  int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
> >  extern unsigned int max_sev_asid;
> >  void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
> > @@ -817,7 +817,6 @@ static inline void sev_vm_destroy(struct kvm *kvm) {}
> >  static inline void __init sev_set_cpu_caps(void) {}
> >  static inline void __init sev_hardware_setup(void) {}
> >  static inline void sev_hardware_unsetup(void) {}
> > -static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
> >  static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
> >  #define max_sev_asid 0
> >  static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
> 
> 
> Overall looks good to me.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks!

> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> 

