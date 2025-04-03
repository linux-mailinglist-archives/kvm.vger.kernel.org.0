Return-Path: <kvm+bounces-42612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D516A7AFFB
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:05:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 976667A7BC4
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2B125DD17;
	Thu,  3 Apr 2025 20:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DpckcA8a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA89E255223
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743711048; cv=none; b=FwW6wKQCQrr18VWSvDqmIAqppl0KmjijPTkCPXXc9O3sYuPckEnyh+3BMGFr58RF5pyIUQf9onqmzHOlHRwkgwDgbsWxCJtCj/I1VfXIh68x3gK4L5vg4lXNFup4QQqacSKR4ZN16DPNC4bOYspuiAWlZRvu7hQXN23CqGieGD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743711048; c=relaxed/simple;
	bh=SPOVjcAHbQRY7+bX10sPikw86DsNl3RI9h6UGXg4HhY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EMqBonuE/XSHZnwvZc1wgUfw24eyI8ArfS0J225tNoWZC6EN6EcoUroo3UXcteE6OMPyvdHA47SWGookkBITgHLb5rmRl33PZ5JahjE5nAwwEMnQCT5r6AwMtu3K+dlyPOYOoZXElfcYr5Xo4fPQBBEMHepHLtzl/qj8VBZs72U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DpckcA8a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743711045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TnbZk/hwm7isyZAJpssZA00cxnMk4ANrtEE+YOpk+K8=;
	b=DpckcA8aeayo6PvN5eQHqcDeeh4gT/oZpmWvu9j232Bo5jd7KgK37sWJMQp2lgeDhyLazQ
	MiruSbmaknSytK7umvU53u/BnHD1w6gnVuVpp51ra2+oODl6egIfhnpw3UKppBpxxHsc8E
	koDZOeNgDGxzC8DzdUlPj0wil6UpKR8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-MzftMRb0Mt2BGtlJ8DVeHA-1; Thu, 03 Apr 2025 16:10:44 -0400
X-MC-Unique: MzftMRb0Mt2BGtlJ8DVeHA-1
X-Mimecast-MFC-AGG-ID: MzftMRb0Mt2BGtlJ8DVeHA_1743711044
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6e8f99a9524so37252426d6.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743711044; x=1744315844;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TnbZk/hwm7isyZAJpssZA00cxnMk4ANrtEE+YOpk+K8=;
        b=m+50eH5HYlS+9sW+QC9D5ucOvDB3Cjj+kROI2GEbmLnpvZu2RrJI2vJTLmbA24ZtM2
         O98+ICeMffZJF4N8oHz+Ady9GlLyvlR0l1WZ03wBykV572rCG8KYNFTQztM9VBgQfG8b
         +SU3AlGoMtWcAZABRoaLsmwufvZNnWykoHeuC3tsX8rWw2982lR4sl0LDTmBWTPJ3eD5
         OY+I5JUSh2EXov2HCBM0mVnZ8nDryHjswP3XGWNqr3s7kUZ4b4i+u+QV7/vGYVnsrB2s
         0iV6BmfdLQEjeT1HrbBCGZTExnYGY4Sx3sv83T5BVc4BOhHqNO0WotQT+wpAuviU2/+r
         ibVA==
X-Forwarded-Encrypted: i=1; AJvYcCUj0RCjW7e9r6Nsxyjl7UgdVD9nyuI6pxrwaci0uHUdEC/RnuIuNS9CVaE8iO0bOYibYgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO7T8xBUXlFMx8dZJuwZYQAe+wY+F+Pn3zA8jlJjfxu6CYsGcq
	EdNrt1QCOBzqfl/53MyD4LHDUf5QMAO6VDgoj2upZx5YxnlsGbdXC7JuifGRnxDYL80wZQqkOj/
	oucslpqILYcixD2X8y7lW9DsCA7oEg+sab2DKbPpYnUJgjH3ysw==
X-Gm-Gg: ASbGnctShb4q3rmhPd7r8ab97viUFmMb6lqCziyP+YyPft7/5sTo4QFAU81BOaa2Swp
	KUTB07sRMBg2WMZLXZ9FLxF05L6nSwOFMzu2D8LIxN9HLDDTr/+A8Vgexqvk0knvaErPvkc/MyZ
	W14S0cJocnD/MXbWPWRAG0jLn7Moz4ZquLL6j3oltXPMJKqbHDJOppSQWVM2NPbYxzXWPYOLqmK
	zvW068DvyCBxrDDYWDrqVJb4wjYb7lujzTEIzujyHA7BNPY7sADcSpQknB+MbS4yJDdjLVIADmK
	+/7CBGCADsZDbfk=
X-Received: by 2002:ad4:5d6e:0:b0:6e8:9843:ec99 with SMTP id 6a1803df08f44-6f01e7996demr6927106d6.41.1743711044216;
        Thu, 03 Apr 2025 13:10:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGtaBwUHaPxcz/8ny8zyVnFtQigAZv8hfc7CoSew6QwclpaejB/MMnyRGVUtuqyEM6uqdb/g==
X-Received: by 2002:ad4:5d6e:0:b0:6e8:9843:ec99 with SMTP id 6a1803df08f44-6f01e7996demr6926876d6.41.1743711043893;
        Thu, 03 Apr 2025 13:10:43 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ef0f14e93fsm11280446d6.110.2025.04.03.13.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:10:43 -0700 (PDT)
Message-ID: <11a2ece0061308f7e340529c4c42a9d81bab0045.camel@redhat.com>
Subject: Re: [RFC PATCH 22/24] KVM: nSVM: Handle INVLPGA interception
 correctly
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:10:42 -0400
In-Reply-To: <20250326194423.3717668-3-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326194423.3717668-1-yosry.ahmed@linux.dev>
	 <20250326194423.3717668-3-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:44 +0000, Yosry Ahmed wrote:
> Currently, INVPLGA interception handles it like INVLPG, which flushes
> L1's TLB translations for the address. It was implemented in this way
> because L1 and L2 shared an ASID. Now, L1 and L2 have separate ASIDs. It
> is still harmless to flush L1's translations, but it's only correct
> because all translations are flushed on nested transitions anyway.
> 
> In preparation for stopping unconditional flushes on nested transitions,
> handle INVPLGA interception properly. If L1 specified zero as the ASID,
> this is equivalent to INVLPG, so handle it as such. Otherwise, use
> INVPLGA to flush the translations of the appropriate ASID tracked by
> KVM, if any. Sync the shadow MMU as well, as L1 invalidated L2's
> mappings.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu/mmu.c          |  5 +++--
>  arch/x86/kvm/svm/svm.c          | 36 +++++++++++++++++++++++++++++++--
>  3 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d881e7d276b12..a158d324168a0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2237,6 +2237,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len);
>  void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
> +void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			       u64 addr, unsigned long roots, bool gva_flush);
>  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			     u64 addr, unsigned long roots);
>  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e2b1994f12753..d3baa12df84e7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6355,8 +6355,8 @@ static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  }
>  
> -static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -				      u64 addr, unsigned long roots, bool gva_flush)
> +void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +			       u64 addr, unsigned long roots, bool gva_flush)
>  {
>  	int i;
>  
> @@ -6382,6 +6382,7 @@ static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu
>  			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(__kvm_mmu_invalidate_addr);
>  
>  void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  			     u64 addr, unsigned long roots)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3649707c61d3e..4b95fd6b501e6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2505,6 +2505,7 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
>  
>  static int invlpga_interception(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
>  	gva_t gva = kvm_rax_read(vcpu);
>  	u32 asid = kvm_rcx_read(vcpu);
>  
> @@ -2514,8 +2515,39 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, asid, gva);
>  
> -	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
> -	kvm_mmu_invlpg(vcpu, gva);
> +	/*
> +	 * APM is silent about using INVLPGA to flush the host ASID (i.e. 0).
> +	 * Do the logical thing and handle it like INVLPG.
> +	 */
> +	if (asid == 0) {
> +		kvm_mmu_invlpg(vcpu, gva);
> +		return kvm_skip_emulated_instruction(vcpu);
> +	}
> +
> +	/*
> +	 * Check if L1 specified the L2 ASID we are currently tracking. If it
> +	 * isn't, do nothing as we have to handle the TLB flush when switching
> +	 * to the new ASID anyway.
> +	 */
> +	if (asid == svm->nested.last_asid)
> +		invlpga(gva, svm_nested_asid(vcpu->kvm));
> +
> +	/*
> +	 * If NPT is disabled, sync the shadow page tables as L1 is invalidating
> +	 * mappings for L2. Sync all roots as ASIDs are not tracked in the MMU
> +	 * role.
> +	 *
> +	 * As we are not flushing the current context, skip the gva flush from
> +	 * __kvm_mmu_invalidate_addr(), it would flush the wrong ASID anyway.
> +	 * The correct TLB flush was done above (if needed).
> +	 *
> +	 * This always operates on root_mmu because L1 and L2 share an MMU when
> +	 * NPT is disabled. This can be optimized by invalidating guest roots
> +	 * only.
> +	 */
> +	if (!npt_enabled)
> +		__kvm_mmu_invalidate_addr(vcpu, &vcpu->arch.root_mmu, gva,
> +					  KVM_MMU_ROOTS_ALL, false);
>  
>  	return kvm_skip_emulated_instruction(vcpu);
>  }

Looks good.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




