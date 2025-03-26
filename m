Return-Path: <kvm+bounces-42076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CBE1A723D0
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46EB17A62D9
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 22:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB81263C6D;
	Wed, 26 Mar 2025 22:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V5BNzKMd"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0298625FA27;
	Wed, 26 Mar 2025 22:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743027407; cv=none; b=uyQFXTpXBn6kqoYD0KP/SvjZ/SW11FEl8/HF9fTrB7sK36aV01xnXdTM457qD60BKSXtTKtaHIB84HEPQfB1JiNgRo/HQ23fJPrCYFlemHNTkpglns6AUZbN85dzD+9uXbLMFb8lJOod2Dgk878zr8tIyZB452bo4N1qBCGDhDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743027407; c=relaxed/simple;
	bh=L44KeKP+YK8ms0QSB3LVnrGLyrHBNU8opCfBoB1E/EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pIWjzLLDH9EACqIE40KShKsSOa29ABOZgBWkKnPVjU+Ag6sQQwbE5TGt3/WnE2Oz2APQcaFVyDrgv7aMSTCsAfKgozJUP9fHjw6dw2ooSWi4pwUnkzlEBGd7pEasRF26mUS0rrJhLz5W6jiR9nZ/6a1KICXF/fuCCQQkYiXQr1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V5BNzKMd; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 26 Mar 2025 22:16:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743027402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wG7XTWpkE3LKZFt50WsjetypYEWpdI63n5wJpfKwCQw=;
	b=V5BNzKMdUy9S3LTERH5dXimRKArNQxtvaHKrC12Hrv7O7VUXBpSUjb4Cyfekagu0qYCX8Z
	cehTEUvaWfk7XwVsV9krSv3mTw1kTo6UIat34EChThgU8gW0l2wJXqWif6kTZXnHjY2K4A
	tRCUgjh2EVwd7kvAfpDz69fWDrvuwIo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>,
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Unify cross-vCPU IBPB
Message-ID: <Z-R8xRbsjv4lalAX@google.com>
References: <20250320013759.3965869-1-yosry.ahmed@linux.dev>
 <Z-RnjKsXPwNWKsKU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-RnjKsXPwNWKsKU@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 26, 2025 at 01:46:04PM -0700, Sean Christopherson wrote:
> On Thu, Mar 20, 2025, Yosry Ahmed wrote:
> >  arch/x86/kvm/svm/svm.c    | 24 ------------------------
> >  arch/x86/kvm/svm/svm.h    |  2 --
> >  arch/x86/kvm/vmx/nested.c |  6 +++---
> >  arch/x86/kvm/vmx/vmx.c    | 15 ++-------------
> >  arch/x86/kvm/vmx/vmx.h    |  3 +--
> >  arch/x86/kvm/x86.c        | 19 ++++++++++++++++++-
> >  6 files changed, 24 insertions(+), 45 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 8abeab91d329d..89bda9494183e 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1484,25 +1484,10 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
> >  	return err;
> >  }
> >  
> > -static void svm_clear_current_vmcb(struct vmcb *vmcb)
> > -{
> > -	int i;
> > -
> > -	for_each_online_cpu(i)
> > -		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);
> 
> Ha!  I was going to say that processing only online CPUs is likely wrong, but
> you made that change on the fly.  I'll probably split that to a separate commit
> since it's technically a bug fix.

Good call. To be completely honest I didn't even realize I fixed this. I
just used for_each_possible_cpu() in kvm_arch_vcpu_destroy() because I
thought that's the right thing to do, and I didn't notice that the SVM
code was using for_each_online_cpu() :)

> 
> A few other nits, but I'll take care of them when applying.

Thanks!

> 
> Overall, nice cleanup!
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 69c20a68a3f01..4034190309a61 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4961,6 +4961,8 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
> >  	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
> >  }
> >  
> > +static DEFINE_PER_CPU(struct kvm_vcpu *, last_vcpu);
> > +
> >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  {
> >  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > @@ -4983,6 +4985,18 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  
> >  	kvm_x86_call(vcpu_load)(vcpu, cpu);
> >  
> > +	if (vcpu != per_cpu(last_vcpu, cpu)) {
> 
> I have a slight preference for using this_cpu_read() (and write) so that it's more
> obvious this is operating on the current CPU.

Hmm I think it's confusing that a cpu is passed into
kvm_arch_vcpu_load(), yet we use the current CPU here. In practice it
seems to me that they will always be the same, but if we want to make
this clear I'd rather we do it on the scope of the entire function.

We can probably stop passing in a CPU and just use the current CPU
throughout the function, and just add an assertion that preemption is
disabled.

> 
> > +		/*
> > +		 * Flush the branch predictor when switching vCPUs on the same physical
> > +		 * CPU, as each vCPU should have its own branch prediction domain. No
> > +		 * IBPB is needed when switching between L1 and L2 on the same vCPU
> > +		 * unless IBRS is advertised to the vCPU. This is handled on the nested
> > +		 * VM-Exit path.
> > +		 */
> > +		indirect_branch_prediction_barrier();
> > +		per_cpu(last_vcpu, cpu) = vcpu;
> > +	}
> > +
> >  	/* Save host pkru register if supported */
> >  	vcpu->arch.host_pkru = read_pkru();
> >  
> > @@ -12367,10 +12381,13 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> >  
> >  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  {
> > -	int idx;
> > +	int idx, cpu;
> >  
> >  	kvmclock_reset(vcpu);
> >  
> > +	for_each_possible_cpu(cpu)
> > +		cmpxchg(per_cpu_ptr(&last_vcpu, cpu), vcpu, NULL);
> 
> It's definitely worth keeping a version of SVM's comment to explaining the cross-CPU
> nullification.

Good idea. Should I send a new version or will you take care of this as
well while applying?

> 
> > +
> >  	kvm_x86_call(vcpu_free)(vcpu);
> >  
> >  	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
> > -- 
> > 2.49.0.395.g12beb8f557-goog
> > 

