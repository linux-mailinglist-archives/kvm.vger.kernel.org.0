Return-Path: <kvm+bounces-58148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC61B89A21
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 15:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C5D61B24EA0
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 13:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C8E2701D8;
	Fri, 19 Sep 2025 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="RVT8QQCj"
X-Original-To: kvm@vger.kernel.org
Received: from out28-3.mail.aliyun.com (out28-3.mail.aliyun.com [115.124.28.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E81B212549;
	Fri, 19 Sep 2025 13:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287749; cv=none; b=Xpc+nNR9LL2UZ4Cy8voR/NV10OgWl9ZjBK9ekp3d+ktlCxkUA5yCspK4RPnOn7LbQE3iD3bRThbEV2eTzH2nY3/sPvFNPTTJAvA59k0g8sWXJUjTREPx538L5oiCamPbKRNg5Up42cu/F5M0pxCaMXOrhCgF6IFX2RdGShtsx1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287749; c=relaxed/simple;
	bh=3lIEpKwOnpu73+fgs+lceb7bsLh9X2fFWNmOumrRMOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvWIhex9fbBUnevjUCbNbufSJ1THtuhdYTrLLM9YmQLRUTpjqndQXmmYY07UWQFKyZBSVxywGdRU0fcHZP+Ab9nusgkSHiHYb+Ne2oq5h/kuCeoHR4vt0dNj1K9Ycuiq+RPwEyX6eeUAHxf8ZX6xhYch5PSQ99rUWIAST7WzMYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=RVT8QQCj; arc=none smtp.client-ip=115.124.28.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1758287736; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=J7LVPaqxBRA20pcGtx+vMG8nQAx+OaSeaSdhOeBY2Ew=;
	b=RVT8QQCjY3pOSGnsRm8B5UElCIW7MWVP23bECAr//4cKG0OktH3TRKQIQTund5D+1PjHUvSd+Wl1orC3CObeN/RG/D6lgi6VdoW8c8zDb89RtZaRa37qWqtsVPAUyPx/8jYQrxdJYdDdG7/luRWPipNQSrUj4mHLNcfrm3UbAA8=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.eixVD.U_1758287735 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 19 Sep 2025 21:15:35 +0800
Date: Fri, 19 Sep 2025 21:15:35 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: SVM: Use cached value as restore value of
 TSC_AUX for SEV-ES guest
Message-ID: <20250919131535.GA73646@k08j02272.eu95sqa>
References: <05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com>
 <9da5eb48ccf403e1173484195d3d7d96978125b7.1758166596.git.houwenlong.hwl@antgroup.com>
 <9991df11-fe7c-41e1-9890-f0c38adc8137@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9991df11-fe7c-41e1-9890-f0c38adc8137@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Sep 18, 2025 at 01:47:06PM -0500, Tom Lendacky wrote:
> On 9/17/25 22:38, Hou Wenlong wrote:
> > The commit 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support
> > for virtualized TSC_AUX") assumes that TSC_AUX is not changed by Linux
> > post-boot, so it always restores the initial host value on #VMEXIT.
> > However, this is not true in KVM, as it can be modified by user return
> > MSR support for normal guests. If an SEV-ES guest always restores the
> > initial host value on #VMEXIT, this may result in the cached value in
> > user return MSR being different from the hardware value if the previous
> > vCPU was a non-SEV-ES guest that had called kvm_set_user_return_msr().
> > Consequently, this may pose a problem when switching back to that vCPU,
> > as kvm_set_user_return_msr() would not update the hardware value because
> > the cached value matches the target value. Unlike the TDX case, the
> > SEV-ES guest has the ability to set the restore value in the host save
> > area, and the cached value in the user return MSR is always the current
> > hardware value. Therefore, the cached value could be used directly
> > without RDMSR in svm_prepare_switch_to_guest(), making this change
> > minimal.
> 
> I'm not sure I follow. If Linux never changes the value of TSC_AUX once it
> has set it, then how can it ever be different? Have you seen this issue?
> 
> Thanks,
> Tom
>
Hi, Tom.

IIUD, the normal guest still uses the user return MSR to load the guest
TSC_AUX value into the hardware when TSC_AUX virtualization is
supported.  However, the user return MSR only restores the host value
when returning to userspace, rather than when the vCPU is scheduled out.
This may lead to an issue during vCPU switching on a single pCPU, which
appears as follows:

       normal vCPU -> SEV-ES vCPU -> normal vCPU

When the normal vCPU switches to the SEV-ES vCPU, the hardware TSC_AUX
value remains as the guest value set in kvm_set_user_return_msr() by the
normal vCPU.  After the #VMEXIT from the SEV-ES vCPU, the hardware value
becomes the host value. However, the cached TSC_AUX value in the user
return MSR remains the guest value of previous normal vCPU. Therefore,
when switching back to that normal vCPU, kvm_set_user_return_msr() does
not perform a WRMSR to load the guest value into the hardware, because
the cached value matches the target value. As a result, during the
execution of the normal vCPU, the normal vCPU would get an incorrect
TSC_AUX value for RDTSCP/RDPID.

I didn't find the available description of TSC_AUX virtualization in
APM; all my analysis is based on the current KVM code. Am I missing
something?

Thanks.

> > 
> > Fixes: 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX")
> > Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 33 ++++++++++++++-------------------
> >  1 file changed, 14 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 1650de78648a..1be9c65ee23b 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -577,18 +577,6 @@ static int svm_enable_virtualization_cpu(void)
> >  
> >  	amd_pmu_enable_virt();
> >  
> > -	/*
> > -	 * If TSC_AUX virtualization is supported, TSC_AUX becomes a swap type
> > -	 * "B" field (see sev_es_prepare_switch_to_guest()) for SEV-ES guests.
> > -	 * Since Linux does not change the value of TSC_AUX once set, prime the
> > -	 * TSC_AUX field now to avoid a RDMSR on every vCPU run.
> > -	 */
> > -	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
> > -		u32 __maybe_unused msr_hi;
> > -
> > -		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
> > -	}
> > -
> >  	return 0;
> >  }
> >  
> > @@ -1408,12 +1396,19 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> >  	/*
> >  	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
> >  	 * available. The user return MSR support is not required in this case
> > -	 * because TSC_AUX is restored on #VMEXIT from the host save area
> > -	 * (which has been initialized in svm_enable_virtualization_cpu()).
> > +	 * because TSC_AUX is restored on #VMEXIT from the host save area.
> > +	 * However, user return MSR could change the value of TSC_AUX in the
> > +	 * kernel. Therefore, to maintain the logic of user return MSR, set the
> > +	 * restore value to the cached value of user return MSR, which should
> > +	 * always reflect the current hardware value.
> >  	 */
> > -	if (likely(tsc_aux_uret_slot >= 0) &&
> > -	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
> > -		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
> > +	if (likely(tsc_aux_uret_slot >= 0)) {
> > +		if (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm))
> > +			kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
> > +		else
> > +			sev_es_host_save_area(sd)->tsc_aux =
> > +				(u32)kvm_get_user_return_msr_cache(tsc_aux_uret_slot);
> > +	}
> >  
> >  	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE) &&
> >  	    !sd->bp_spec_reduce_set) {
> > @@ -3004,8 +2999,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >  		 * TSC_AUX is always virtualized for SEV-ES guests when the
> >  		 * feature is available. The user return MSR support is not
> >  		 * required in this case because TSC_AUX is restored on #VMEXIT
> > -		 * from the host save area (which has been initialized in
> > -		 * svm_enable_virtualization_cpu()).
> > +		 * from the host save area (which has been set in
> > +		 * svm_prepare_switch_to_guest()).
> >  		 */
> >  		if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) && sev_es_guest(vcpu->kvm))
> >  			break;

