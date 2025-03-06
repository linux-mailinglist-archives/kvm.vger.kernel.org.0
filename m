Return-Path: <kvm+bounces-40239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B44EA5484E
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 11:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 651333AD141
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 10:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0AD72045A4;
	Thu,  6 Mar 2025 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h/hT+stm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A5C1A23A2
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 10:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741257988; cv=none; b=Xcv1sBO458BafKIbkknaCe3LMf5lBex1fNNNW6qAcTUBrdmsu1WrkL2wCqKi18IiJF3FObT6o5IwUak3w4fSEtiNE2+UVxTkOdwL7U7Kceeb87SQXt+KGd1AdvT/408KrpddmoXsFlHg6evepxn37F2u59LY71bMZEoahJYV2Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741257988; c=relaxed/simple;
	bh=Vr4kZC/vcH7LeNB/B0HqQ/sjqTFNCHEaRjMdcN5Xvkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FiMpvchs424DnRfM405lIKTAOKgwaRFLNfjLWaoknoR+pxXPBdKus7FDowFPFJP/CcDSt98VrF9K+Kay8u+uS5I+terX2T7OPV1Xhxd1zGJroYhQ458N0ZBO3k+L2DCsdHEKD8GhW/QiGnASbdENy3e0Pt1qcbe4b6jOC7+6OrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h/hT+stm; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aaecf50578eso97283166b.2
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 02:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741257985; x=1741862785; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k9jmbAtkWcX3aIfTXb+ZS5XnwnXJn6Hdi83Ai2OZSyc=;
        b=h/hT+stmK8ca2JhGtjYPU1DwwzmS9BfQAHmORQhH3tsBeQyZq7R590+Nj6uxcSbld1
         NZoOGhhimoFgp0m7W0ri5XP590pynGi97Umin8hftACJCrHzMqICqkoHZH0LUQwniVZ9
         oEq10bZng3+FIcT2Y6KqzvCth7L6Um4KXRWZy6+tVWkG3MBk1YqdmqMUa3ydQQdbA3Ks
         YRINOpCoF7Tjn9YH6qjgGmTvHfAPRF5rqpS6UuYsCW3aidGunZdN1v5JJiI2Va55Me5L
         q5+30QKnpEC7yZ6QF/lnZprT25GoqeAuThyPy2VYNG55qJziKYO9Jxej0mD2NFdoR2t/
         1TWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741257985; x=1741862785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9jmbAtkWcX3aIfTXb+ZS5XnwnXJn6Hdi83Ai2OZSyc=;
        b=X9UY6DTzUerOC8ETGU8Q+zQBRbEjanNm33n1mG0364m37mqx+JiW9a+SrMj4k/nr/Q
         VZyK0jlZSyFgULqk+PyJuikuHq1NaMxyXAEtGJ4k80vKdPS8y9NDP3ny7I5XYWblInPh
         ZQ8T1RNMn/Mw91qahC2eHl9cVwsMD3hwekWIUZUSAEq45ahUMxv8ma7/0pAPOBoHuFuN
         BYj0ySuyBGd2pQNfQI7QzM+s1pPfsCJvGOYB7Zo2vmtS0es2feo8H+eWnAVgfOFczkUT
         C8Jjce0TgOfW5JQwhQ61OdZfQr7eA6V+z2NErLB6kL2WGeyDgemDrwcjeCkcD906vq/b
         iuOA==
X-Gm-Message-State: AOJu0Yyem09lDBWAumJZVZTqKA+qBMentIaXwb1+XrTxo16nqUc+ROSd
	AG0p5QgcGmVtiJFizMTeXm1SIFHyrh/KoOfmC7HlHfNkeLjqrCBbNAdPq/RpWg==
X-Gm-Gg: ASbGncthsB2b99uEErOCdEfasNIzd+XSP/Rm2VBDnpZyG9fvEWcznwajBNHa9T2TkAa
	yePc8SW3S/HydLXPSsWPmocYQKn92z8n3zhgjPWp/f/Ktnr9e3fmopm6QbrsnNiVGK55v+SB1bM
	Pptg1KGgesyqdtqGb4M4+r1xN0kNsKRbZMxYR1/h/wjZ7GMh79JuAzkMWW2qbJfaG41Y3yWbmNv
	QqpdDo9MaoaovPfHhYFgFO9S1RviocoTn/Wd8PCQeyQ7b/ZzPM3mWLxX/vkEpxn7+PDcNFyXCrp
	DDvC+YK8AUjEaq/fA6YCDT3DAOsXIu0GhNDEyakD+7JpvI5UrVm1vJ3VuaxdfXRXOUm/LcsUKjP
	C1CE=
X-Google-Smtp-Source: AGHT+IETwKaeWit7V6acHj/PeTIV3AggcxsBRGA3DBfdPK+S9nl8Tgvfmoy5A96/iD/YcQ6xyu0Sig==
X-Received: by 2002:a17:907:6e93:b0:aa6:b63a:4521 with SMTP id a640c23a62f3a-ac20dababa1mr545816666b.15.1741257985088;
        Thu, 06 Mar 2025 02:46:25 -0800 (PST)
Received: from google.com (140.20.91.34.bc.googleusercontent.com. [34.91.20.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7dadsm74534866b.172.2025.03.06.02.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 02:46:24 -0800 (PST)
Date: Thu, 6 Mar 2025 10:46:20 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, keirf@google.com,
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org,
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com,
	fvdl@google.com, hughd@google.com, jthoughton@google.com,
	peterx@redhat.com
Subject: Re: [PATCH v5 6/9] KVM: arm64: Refactor user_mem_abort() calculation
 of force_pte
Message-ID: <Z8l8_J5ro97MsMuR@google.com>
References: <20250303171013.3548775-1-tabba@google.com>
 <20250303171013.3548775-7-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303171013.3548775-7-tabba@google.com>

On Monday 03 Mar 2025 at 17:10:10 (+0000), Fuad Tabba wrote:
> To simplify the code and to make the assumptions clearer,
> refactor user_mem_abort() by immediately setting force_pte to
> true if the conditions are met. Also, remove the comment about
> logging_active being guaranteed to never be true for VM_PFNMAP
> memslots, since it's not technically correct right now.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1f55b0c7b11d..887ffa1f5b14 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1460,7 +1460,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  bool fault_is_perm)
>  {
>  	int ret = 0;
> -	bool write_fault, writable, force_pte = false;
> +	bool write_fault, writable;
>  	bool exec_fault, mte_allowed;
>  	bool device = false, vfio_allow_any_uc = false;
>  	unsigned long mmu_seq;
> @@ -1472,6 +1472,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	gfn_t gfn;
>  	kvm_pfn_t pfn;
>  	bool logging_active = memslot_is_logging(memslot);
> +	bool force_pte = logging_active || is_protected_kvm_enabled();
>  	long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> @@ -1521,16 +1522,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		return -EFAULT;
>  	}
>  
> -	/*
> -	 * logging_active is guaranteed to never be true for VM_PFNMAP
> -	 * memslots.
> -	 */

Indeed, I tried to add the following snippeton top of upstream:

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..b5c3a6b9957f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1525,6 +1525,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
         * logging_active is guaranteed to never be true for VM_PFNMAP
         * memslots.
         */
+       WARN_ON_ONCE(logging_active && (vma->vm_flags & VM_PFNMAP));
        if (logging_active || is_protected_kvm_enabled()) {
                force_pte = true;
                vma_shift = PAGE_SHIFT;

And I could easily get that thing to trigger --  the trick is to back a
memslot with standard anon memory, enable dirty logging, and then mmap()
with MAP_FIXED on top of that a VM_PFNMAP region, and KVM will happily
proceed. Note that this has nothing to do with your series, it's just an
existing upstream bug.

Sadly that means the vma checks we do in kvm_arch_prepare_memory_region()
are bogus. Memslots are associated with an HVA range, not the underlying
VMAs which are not guaranteed stable. This bug applies to both the
VM_PFNMAP checks and the MTE checks, I think.

I can't immediately think of a good way to make the checks more robust,
but I'll have a think. If anybody has an idea ... :-)

Thanks,
Quentin

> -	if (logging_active || is_protected_kvm_enabled()) {
> -		force_pte = true;
> +	if (force_pte)
>  		vma_shift = PAGE_SHIFT;
> -	} else {
> +	else
>  		vma_shift = get_vma_page_shift(vma, hva);
> -	}
>  
>  	switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
> -- 
> 2.48.1.711.g2feabab25a-goog
> 

