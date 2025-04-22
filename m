Return-Path: <kvm+bounces-43808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A11C6A964C0
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C09C71786C5
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B041202C58;
	Tue, 22 Apr 2025 09:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K0lyX3V+"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DF2201271
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745314944; cv=none; b=tzGn3OyXLTyzk9m8h3IA5BglqLhlXobM9tN7KYoFqKJsaAGJAFPdrym89TsINS1tCA9aqynkZGzPL4y/wClBdEUCminQw+a3tcXsa4KHuVd5OkeG5w7TTOVS+xf50w8iOMVXvcS2+sy7oM0XcZWlyM1SZ/afegJPtBsv5VA4VmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745314944; c=relaxed/simple;
	bh=Bq4Sryxb4C1FObNLM2RgXhRxBymuMSwKgbMQL0ImXTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OT+FNqA5Exdwa5MbaJSP1aL3gH4yIgubZh0N2Xj3hJncwnGJFEHPIZar1yQ5B0q2gnh3z2T4nyAoeaEyP+lS+Q2G2U5W2dL7sBBMB+JCLJMo9qun7e75eoC3qEIKTRL8ePI0GVTXn5oBkia2PyLyG8DqL/l1h1+7nSaa/jHvnIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K0lyX3V+; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 22 Apr 2025 02:41:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745314930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D+sbeOcrmZmAKgqkrfeYbAkcql3hWz+1ocR+pabuWf4=;
	b=K0lyX3V+9aLjeSq+b5MVUDIKF+pHHlcyFvdvxNTOJEgJ7C7t8NhBBh49H8apv+CiYQf0H+
	b+nuC86GEV+U2tcuto1UIZCUbrbTN7rjZkxzfSnmmk5m90098cN0LBYIE8Bkg4XLHBGy/7
	1uRoeM4WBeajFm1KyBzCMvR+Wsb9X7c=
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
Subject: Re: [RFC PATCH 06/24] KVM: SEV: Track ASID->vCPU instead of
 ASID->VMCB
Message-ID: <aAdkTzBgSfdNjCUo@Asmaa.>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-7-yosry.ahmed@linux.dev>
 <03be59f070a02555596550d5764aa8b416e43b58.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03be59f070a02555596550d5764aa8b416e43b58.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 03, 2025 at 04:04:05PM -0400, Maxim Levitsky wrote:
> On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> > SEV currently tracks the ASID to VMCB mapping for each physical CPU.
> > This is required to flush the ASID when a new VMCB using the same ASID
> > is run on the same CPU. 
> 
> 
> > Practically, there is a single VMCB for each
> > vCPU using SEV. 
> 
> Can you elaborate on this a bit? AFAIK you can't run nested with SEV,
> even plain SEV because guest state is encrypted, so for SEV we have
> indeed one VMCB per vCPU.

This is my understanding as well, will elaborate when I get around to
respinning.

> 
> > Furthermore, TLB flushes on nested transitions between
> > VMCB01 and VMCB02 are handled separately (see
> > nested_svm_transition_tlb_flush()).
> 
> Yes, or we can say that for now both VMCBs share the same ASID,
> up until later in this patch series.
> 
> > 
> > In preparation for generalizing the tracking and making the tracking
> > more expensive, start tracking the ASID to vCPU mapping instead. This
> > will allow for the tracking to be moved to a cheaper code path when
> > vCPUs are switched.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/sev.c | 12 ++++++------
> >  arch/x86/kvm/svm/svm.c |  2 +-
> >  arch/x86/kvm/svm/svm.h |  4 ++--
> >  3 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index d613f81addf1c..ddb4d5b211ed7 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -240,7 +240,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
> >  
> >  	for_each_possible_cpu(cpu) {
> >  		sd = per_cpu_ptr(&svm_data, cpu);
> > -		sd->sev_vmcbs[sev->asid] = NULL;
> > +		sd->sev_vcpus[sev->asid] = NULL;
> >  	}
> >  
> >  	mutex_unlock(&sev_bitmap_lock);
> > @@ -3081,8 +3081,8 @@ int sev_cpu_init(struct svm_cpu_data *sd)
> >  	if (!sev_enabled)
> >  		return 0;
> >  
> > -	sd->sev_vmcbs = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
> > -	if (!sd->sev_vmcbs)
> > +	sd->sev_vcpus = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
> > +	if (!sd->sev_vcpus)
> >  		return -ENOMEM;
> >  
> >  	return 0;
> > @@ -3471,14 +3471,14 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
> >  	/*
> >  	 * Flush guest TLB:
> >  	 *
> > -	 * 1) when different VMCB for the same ASID is to be run on the same host CPU.
> > +	 * 1) when different vCPU for the same ASID is to be run on the same host CPU.
> >  	 * 2) or this VMCB was executed on different host CPU in previous VMRUNs.
> >  	 */
> > -	if (sd->sev_vmcbs[asid] == svm->vmcb &&
> > +	if (sd->sev_vcpus[asid] == &svm->vcpu &&
> >  	    svm->vcpu.arch.last_vmentry_cpu == cpu)
> >  		return 0;
> >  
> > -	sd->sev_vmcbs[asid] = svm->vmcb;
> > +	sd->sev_vcpus[asid] = &svm->vcpu;
> >  	vmcb_set_flush_asid(svm->vmcb);
> >  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> >  	return 0;
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 18bfc3d3f9ba1..1156ca97fd798 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -694,7 +694,7 @@ static void svm_cpu_uninit(int cpu)
> >  	if (!sd->save_area)
> >  		return;
> >  
> > -	kfree(sd->sev_vmcbs);
> > +	kfree(sd->sev_vcpus);
> >  	__free_page(__sme_pa_to_page(sd->save_area_pa));
> >  	sd->save_area_pa = 0;
> >  	sd->save_area = NULL;
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 843a29a6d150e..4ea6c61c3b048 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -340,8 +340,8 @@ struct svm_cpu_data {
> >  
> >  	struct vmcb *current_vmcb;
> >  
> > -	/* index = sev_asid, value = vmcb pointer */
> > -	struct vmcb **sev_vmcbs;
> > +	/* index = sev_asid, value = vcpu pointer */
> > +	struct kvm_vcpu **sev_vcpus;
> >  };
> >  
> >  DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
> 
> 
> Code itself looks OK, so 
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks!

> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> 
> 

