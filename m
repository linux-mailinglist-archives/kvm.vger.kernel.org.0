Return-Path: <kvm+bounces-43813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 61176A9654E
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 12:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CAF77A6C71
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46558202C58;
	Tue, 22 Apr 2025 10:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QDReBMql"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588571E0DEB
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 10:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745316128; cv=none; b=YtT+a5x4I0IskvQAsf1MqCbvu2DMna1SmSu5uBDlt9wobz43HOJ4gUh2iyz1N2eGeZtfib1RnucClbsj1XQ7T2FRSVdcwd3tsDGYu8G6HpuK+BGhVYFuSgcUGgvGZoyRavXbuJjcRMKcFUM7bbM6PxBHGnNTuqmliYLRkxRmu0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745316128; c=relaxed/simple;
	bh=kxY6QvQV/uIU7XpsVKigY5EUFj2vydilh5LQQMcOVVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsBIN/T0T0o9eWBR2Q+J/E4Qm+DMaeitEwIylj1o4+X0+oz3dAvX+7SUoxtpCotnmjutg6qM+u2bbfXPAa/ppeichYz0MNjFGnG8dFTVn2E+HpOUN1ixvc9ZKOh7taIIZ5ezBCSNyv/5v+HNuzP2LZjWkPj7kYrHFSpwFOyW1pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QDReBMql; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 22 Apr 2025 03:01:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745316121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9VXFK4typB7ym9opTXVD91a+Eyu7LKMaTOQWZkdez0Y=;
	b=QDReBMqlWYe59Cdu6zZJZBZyxyL+QSbkui6RMLSPRA1L9SllCXvFOUalhtVrZXew1gtnPn
	BypsisyzAy2XpXJpWUf//PBKDn/uk2Z4/uhb4ns1KmGsWs90Mhkc96/bXiRi0sPitlq2xd
	zkrOlI43Uzx6T4VIYoqT7ph0MImTWpk=
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
Subject: Re: [RFC PATCH 23/24] KVM: nSVM: Allocate a new ASID for nested
 guests
Message-ID: <aAdpFYUmRynvgxvj@Asmaa.>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326194423.3717668-1-yosry.ahmed@linux.dev>
 <20250326194423.3717668-4-yosry.ahmed@linux.dev>
 <5f714d7fb68aef92f1bea58a10deb4de1a10a5b8.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f714d7fb68aef92f1bea58a10deb4de1a10a5b8.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 03, 2025 at 04:11:47PM -0400, Maxim Levitsky wrote:
> On Wed, 2025-03-26 at 19:44 +0000, Yosry Ahmed wrote:
> > Now that nested TLB flushes are properly tracked, start allocating a
> > separate ASID for nested guests. This allows dropping the unconditional
> > TLB flushes on nested transitions and doing finer grained TLB flushing
> > when necessary.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 11 +++++++++--
> >  arch/x86/kvm/svm/svm.c    |  5 +++--
> >  arch/x86/kvm/svm/svm.h    |  3 +++
> >  3 files changed, 15 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 544913461693c..0c887c91bd50d 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1204,6 +1204,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
> >  {
> >  	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
> >  	struct page *vmcb02_page;
> > +	unsigned int asid;
> >  
> >  	if (svm->nested.initialized)
> >  		return 0;
> > @@ -1221,8 +1222,14 @@ int svm_allocate_nested(struct vcpu_svm *svm)
> >  
> >  	svm->nested.initialized = true;
> >  
> > -	if (!kvm_svm->nested_asid)
> > -		kvm_svm->nested_asid = kvm_svm->asid;
> > +	if (!kvm_svm->nested_asid) {
> > +		asid = kvm_tlb_tags_alloc(&svm_asids);
> > +		if (asid && !svm_register_asid(asid)) {
> > +			kvm_tlb_tags_free(&svm_asids, asid);
> > +			asid = 0;
> > +		}
> > +		kvm_svm->nested_asid = asid ?: fallback_asid;
> > +	}
> 
> Nitpick: AFAIK at least nested KVM doesn't enable EFER.SVME,
> unless it actually runs a guest thus most of the time we will waste a ASID on a VM
> which once did run a VM nested and since then doesn't run anything else.

Oh yeah, I missed that, thanks. Will do.

> 
> So maybe we want to free the nested ASID in the svm_free_nested?
> 
> >  
> >  	return 0;
> >  
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 4b95fd6b501e6..196f5bca57a0e 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -249,8 +249,8 @@ static unsigned long iopm_base;
> >  
> >  DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
> >  
> > -static struct kvm_tlb_tags svm_asids;
> > -static unsigned int fallback_asid;
> > +struct kvm_tlb_tags svm_asids;
> > +unsigned int fallback_asid;
> >  
> >  /*
> >   * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
> > @@ -5127,6 +5127,7 @@ static void svm_vm_destroy(struct kvm *kvm)
> >  	avic_vm_destroy(kvm);
> >  	sev_vm_destroy(kvm);
> >  	kvm_tlb_tags_free(&svm_asids, kvm_svm->asid);
> > +	kvm_tlb_tags_free(&svm_asids, kvm_svm->nested_asid);
> >  }
> >  
> >  static int svm_vm_init(struct kvm *kvm)
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 0c44133bc05ca..220d10d2b1a5c 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -630,6 +630,9 @@ static inline void svm_vmgexit_no_action(struct vcpu_svm *svm, u64 data)
> >  
> >  extern bool dump_invalid_vmcb;
> >  
> > +extern struct kvm_tlb_tags svm_asids;
> > +extern unsigned int fallback_asid;
> > +
> >  u32 svm_msrpm_offset(u32 msr);
> >  u32 *svm_vcpu_alloc_msrpm(void);
> >  void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> 

