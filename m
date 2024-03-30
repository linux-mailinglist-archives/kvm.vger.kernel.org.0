Return-Path: <kvm+bounces-13159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7D8892D81
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 22:35:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56AD4B21B08
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 21:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FAB4CDEC;
	Sat, 30 Mar 2024 21:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwZ9MZ1i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ECB43AC2
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834530; cv=none; b=PgOkXF678W9FwFCPiVKah4oovIgBF8F/JnAjhXPQYadrFMw6s+c93/cpsFP4CCmpp1MvFGZ3gW9RNn4I1KSTSuDG7F8jluCx/viwZsut6QgyteFd/9Q4ZcCd99QNu5td4CEPW8NWs8LY4PcHkUUXf5KTi6LEdxRmTmIHMg205wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834530; c=relaxed/simple;
	bh=g0toAGCQtFi0G3GbWa0Q4HZPWv8jGtxInPF/JxlP71A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VDk1AdWfivfUlDYWWV0aeHeinK3zHP6Dwj3CQ2qewUTiR3JkY389d6bV/9E9OKg2J0ACGBw1DWYUPuF6lGvUnq274kQdBU+HYQaf3VVKagAkxwJnR9csNwkpG3T1KCpCWClj7sLvSTcqgcR3yTTn3MVnPc35I5YZ5/XMmBDm6Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwZ9MZ1i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711834527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EwmuW/k3ZL7znVA8wS56lDlLW9BhS4TEVksrt7Me+Z8=;
	b=PwZ9MZ1iyCAVzBUash6/9hnMVBP48I4GsfrdulDjf7X0dySw+dhCyQuoNF9cRn97oZnC0V
	cTOQYa0rlarrHCAeQS/Hszk96ip36xl7O644Vw+ylUW0h4uRIhxuKMLJ1NrVHXnq/yslBs
	rhet5l0+ntjKgvhS1bHVq1nOKnn3br4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-Z1cutKDMPAqZsj1hS9Y4tQ-1; Sat, 30 Mar 2024 17:35:23 -0400
X-MC-Unique: Z1cutKDMPAqZsj1hS9Y4tQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5681b29771fso2713252a12.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834522; x=1712439322;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EwmuW/k3ZL7znVA8wS56lDlLW9BhS4TEVksrt7Me+Z8=;
        b=nzCRUS20ImCAW2h2K5GoL6qVk3nAr99hKcLBSSqCe3IyM8m2GI6s2dERA7joPIeggi
         CMiXYCjsP8xOJ1mO289qN6dczcnwI+vFzFsMSS+NJR+rp2/pXByFXgzVe+AjusVdDUEg
         iKZUJpF/Kt15I0AedM3sTJqZAi1ZSnddDYBD5zL7/X/qlmppeMGOrTAPeNN37PfBQwPE
         zdiAq9FUWoYTeq9GB+tDL6ymyw6FikEOUpfhMekKSB4xcvomqjpGiLSl2Xwb+Z+jfS1f
         trWPxxxvq6dp5z6jCU7JFiZHI+tiI6iblXgMZzxJ506R9e7gEM0zUmHTQP9pjP0fvOIg
         IBvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVDt3jH5NKl/MGHyzEugLs33le86iNvLjQspEcRQzKog1U4wrqsbKd2XbBxiRn46WvGdEQ+Mr2CpNLtehpxAD3xXt9
X-Gm-Message-State: AOJu0YxDRJwX1L4tYkKr7mz+XPL/Dtq0B7tTTD3b1qBrpT4Lxtz6YzrT
	nNw9rjmeGmQmu+ixJCjiIJ+mX+H/khlSownsdst1V9PcufXw+BEJkuWgzulSLyNIOoxmAnAn6xe
	KmLZ6GRFxU+QtOhjBnFX3YF5noQ8bQPSObqNIXqvKsyvHXtNLVA==
X-Received: by 2002:a50:bb44:0:b0:567:23a2:5b1e with SMTP id y62-20020a50bb44000000b0056723a25b1emr4176641ede.23.1711834522682;
        Sat, 30 Mar 2024 14:35:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4Y1Y1ai02PAHKv5gHHk8E9vouw7+IeXJOAyuQtq3+b2c4PJy15b2ZKcJKFYMqFhtFpYJu6A==
X-Received: by 2002:a50:bb44:0:b0:567:23a2:5b1e with SMTP id y62-20020a50bb44000000b0056723a25b1emr4176630ede.23.1711834522369;
        Sat, 30 Mar 2024 14:35:22 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id cy14-20020a0564021c8e00b0056bf31fa2a3sm3688481edb.80.2024.03.30.14.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:35:21 -0700 (PDT)
Message-ID: <4e89479a-e170-403a-b2eb-ce7b895e55a3@redhat.com>
Date: Sat, 30 Mar 2024 22:35:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 23/29] KVM: x86: Implement gmem hook for determining
 max NPT mapping level
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-24-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-24-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table. The existing mixed-attribute tracking in KVM is
> insufficient here, for instance:
> 
>    - gmem allocates 2MB page
>    - guest issues PVALIDATE on 2MB page
>    - guest later converts a subpage to shared
>    - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
>    - KVM MMU splits NPT mapping to 4K
>    - guest later converts that shared page back to private
> 
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.
> 
> Implement a kvm_x86_ops.gmem_validate_fault() hook for SEV that checks
> for this condition and adjusts the mapping level accordingly.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  1 +
>   arch/x86/kvm/svm/svm.h |  7 +++++++
>   3 files changed, 40 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 87d621d013a4..31f6f4786503 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4443,3 +4443,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>   		pfn += use_2m_update ? PTRS_PER_PMD : 1;
>   	}
>   }
> +
> +/*
> + * Re-check whether an #NPF for a private/gmem page can still be serviced, and
> + * adjust maximum mapping level if needed.
> + */
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
> +			    u8 *max_level)
> +{
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level %d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (!assigned) {
> +		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx level %d\n",
> +				   gfn, pfn, level);
> +		return -EINVAL;
> +	}
> +
> +	if (level < *max_level)
> +		*max_level = level;
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b456906f2670..298b4ce77a5f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5081,6 +5081,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   
>   	.gmem_prepare = sev_gmem_prepare,
>   	.gmem_invalidate = sev_gmem_invalidate,
> +	.gmem_validate_fault = sev_gmem_validate_fault,
>   };
>   
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 3f1f6d3d3ade..746f819a6de4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>   int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>   void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, bool is_private,
> +			    u8 *max_level);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
>   	return 0;
>   }
>   static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
> +static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
> +					  bool is_private, u8 *max_level)
> +{
> +	return 0;
> +}
>   
>   #endif
>   


