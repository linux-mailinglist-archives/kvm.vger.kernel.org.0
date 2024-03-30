Return-Path: <kvm+bounces-13249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4DD389351B
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 334541F246D1
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5418D153818;
	Sun, 31 Mar 2024 16:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iMz1hl2M"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B33514883A;
	Sun, 31 Mar 2024 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903879; cv=fail; b=Ii1mVrL550BakL8CVTHduwwPhgLYklufvsNVL1EMq8t2sq0oGUi3YadF7PXC7nMPhTKjyIoidXohE2WpwsTVsmkLgpOuWUCuhfilW3P/1pW5oeBfQFiz3VOKG9/Cx4WKqNoKNGXnxNF0o07XNRz/sWzAkVmFB1R4VVcxsKmIIAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903879; c=relaxed/simple;
	bh=SJLn22HHh3H9F/vDAmYonmzBjjNKKncpccp6Ncmn6H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DjzXKl8YYSLuuHxaFOn4XXOptV7/6xcG9rw5VVSahHkysyMMAeF5Fy8GvIht+ENMiL70R+Gbv336eLbOus909CrOfg+Qz1bb1Es5NYqtLStBlD6y3qqFed/vyUc5m30He0CqLtYhU7UgS3lasiUcH0738QYpctRAVgZ8GOApOjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iMz1hl2M reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id BA95B207C6;
	Sun, 31 Mar 2024 18:51:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yutl_2zcRN_P; Sun, 31 Mar 2024 18:51:13 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 1C1A0201C7;
	Sun, 31 Mar 2024 18:51:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 1C1A0201C7
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 703A280005E;
	Sun, 31 Mar 2024 18:43:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:43:09 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:37:05 +0000
X-sender: <linux-crypto+bounces-3133-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=rfc822;steffen.klassert@secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-dresden-01.secunet.de
X-ExtendedProps: BQBjAAoAS2QFfe5Q3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAAAAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.199
X-EndOfInjectedXHeaders: 20196
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3133-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 469D52025D
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iMz1hl2M"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711832736; cv=none; b=Fe3OA4BZh4bT45Nrus/p+ESHNgtWzKUcACrRid6OHlKyWX86IHJ5UAX3GCveE7WhHTVE08SlKNpLc/RNWQ+ivUWzN9WL9P0aUMNkvFm4jHgJrEsfzmpbTmgb5wV/VaGfo2j4lt9GQNu6fpo+r694NR7Yu68fHAkhGsx8YzuW1YA=
ARC-Message-Signature: i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711832736; c=relaxed/simple;
	bh=3Zs96oVvSrL1EcRD7qOwXkqb76tHEKhezfgjNzTnj6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ae1wa1GswZJRlxxXgy8YycVkEJOthYG2FpAKTw0BDXaPo1s30spPmdjif6fpbGfKo9tco6Ud2fa1IoHDYqcTptQOUOKVKIjmgUK7mOC8bUvXSMFCBIcDt+Krm2/802IiwANql4OgOx0ziO2IdVIjlXvxSf//LwzMBq7arunpDY4=
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iMz1hl2M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711832734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=;
	b=iMz1hl2Mf/psN5Od7gln/fDHfKpEbYKAoJhvY6cNexwhZrtJjVZGFsdCoZU3kWgWk1RIwh
	LKspXOWtfajfLA4pTm8k/VRcwb5l74UdyiTt8ptTmcNAW0OGRYJqcF18jP49JFR4Zcw1uK
	+iZjx/537Gyk0TR70Zvl0/odzcpHB4c=
X-MC-Unique: k8-GmMkPO0O1QYJRvck7Gg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711832731; x=1712437531;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=;
        b=XPQZC++4NBIClwnwEWCOT/bxHuM5IXZnj6Ix2/+M2l6lHaYI1WKLwI0FFp8K7nruuW
         6JiyaKbsclCWKXITmvNGaiMn/0Mkj+KTeLA03OPiKHHlQzKqY/KrWYuFqZ37nfcnJWFA
         NH72NOFNICY3WixD7rEAN8P3uf6UdtH8bArIkyZZs7x+vSswDWMvw2gvzeBd5fejNJiB
         17s4KZpOHYl6EG4XTWjYC8QDsdoItf9vRR75bMRzDgKkQk+/W0zeMZ6O93CBvm1iiyEg
         5J3dvupAjUkw9PybM2gkZwrYEZH2JqlgMYDoAo7MN997tA3XaYnpqTpf5qG56n6aoN/v
         su+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVUirNiSP5mSIP24Z2cJxHx6RS/4jBPP9oRbE+oenYVo5YYS6Uu7f/HP1mYXzgLpocOB8IcJo/dq9Q9WFxCf33evpVb+eBCf3RlrseR
X-Gm-Message-State: AOJu0YwQbMQjSoJUX8EPP663QsFlgIenNv0RbEBGDkiWhmU7aGcnrQgV
	W+rIvQxn6qwqWm0bvxvUVPt5V9GROqFwx4u5oRIxA9J2UAElXTeY+FVhAmh9BYU8PzcewmYUrsZ
	GHIoNQV+74BYXz2ajAVHo6qK2WXe7WT68H9aAqjCk0uX+tfrR953ZCOSyulFY1Q==
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a170906a40d00b00a4e253d9641mr4204830ejz.8.1711832731476;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTeU1CiYPB2ByqnXfgbHYLBnkSUxAq1ZyFzRHCPzV8G1WZItagAlUo3C1OjOvbzmRD+zOCDA==
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a170906a40d00b00a4e253d9641mr4204815ejz.8.1711832731102;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
Message-ID: <a0799504-385b-40d8-a84c-eddb1bae930d@redhat.com>
Date: Sat, 30 Mar 2024 22:05:28 +0100
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 21/29] KVM: SEV: Implement gmem hook for initializing
 private pages
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
 <20240329225835.400662-22-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-22-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On 3/29/24 23:58, Michael Roth wrote:
> This will handle the RMP table updates needed to put a page into a
> private state before mapping it into an SEV-SNP guest.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  2 +
>   arch/x86/kvm/svm/svm.h |  5 +++
>   arch/x86/kvm/x86.c     |  5 +++
>   virt/kvm/guest_memfd.c |  4 +-
>   6 files changed, 113 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index d0bb0e7a4e80..286b40d0b07c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -124,6 +124,7 @@ config KVM_AMD_SEV
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
>   	select KVM_GENERIC_PRIVATE_MEM
> +	select HAVE_KVM_GMEM_PREPARE
>   	help
>   	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
>   	  with Encrypted State (SEV-ES) on AMD processors.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9ea13c2de668..e1f8be1df219 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4282,3 +4282,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>   out:
>   	put_page(pfn_to_page(pfn));
>   }
> +
> +static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	kvm_pfn_t pfn = start;
> +
> +	while (pfn < end) {
> +		int ret, rmp_level;
> +		bool assigned;
> +
> +		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> +		if (ret) {
> +			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
> +					    pfn, start, end, rmp_level, ret);
> +			return false;
> +		}
> +
> +		if (assigned) {
> +			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
> +				 __func__, pfn, start, end, rmp_level);
> +			return false;
> +		}
> +
> +		pfn++;
> +	}
> +
> +	return true;
> +}
> +
> +static u8 max_level_for_order(int order)
> +{
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
> +{
> +	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +
> +	/*
> +	 * If this is a large folio, and the entire 2M range containing the
> +	 * PFN is currently shared, then the entire 2M-aligned range can be
> +	 * set to private via a single 2M RMP entry.
> +	 */
> +	if (max_level_for_order(order) > PG_LEVEL_4K &&
> +	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
> +		return true;
> +
> +	return false;
> +}
> +
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_aligned;
> +	gfn_t gfn_aligned;
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
> +				   gfn, pfn, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (assigned) {
> +		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
> +			 __func__, gfn, pfn, max_order, level);
> +		return 0;
> +	}
> +
> +	if (is_large_rmp_possible(kvm, pfn, max_order)) {
> +		level = PG_LEVEL_2M;
> +		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
> +	} else {
> +		level = PG_LEVEL_4K;
> +		pfn_aligned = pfn;
> +		gfn_aligned = gfn;
> +	}
> +
> +	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
> +		 __func__, gfn, pfn, pfn_aligned, max_order, level);
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a895d3f07cb8..c099154e326a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5078,6 +5078,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>   	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>   	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
> +
> +	.gmem_prepare = sev_gmem_prepare,
>   };
>   
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0cdcd0759fe0..53618cfc2b89 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
>   void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>   void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
>   static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
>   static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
> +static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> +{
> +	return 0;
> +}
>   
>   #endif
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 617c38656757..d05922684005 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13615,6 +13615,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>   
>   #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type == KVM_X86_SNP_VM;
> +}
> +
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
>   {
>   	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3e3c4b7fff3b..11952254ae48 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>   		gfn = slot->base_gfn + index - slot->gmem.pgoff;
>   		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
>   		if (rc) {
> -			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
> -					    index, rc);
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
> +					    index, gfn, pfn, rc);
>   			return rc;
>   		}
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


X-sender: <linux-kernel+bounces-125884-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=rfc822;steffen.klassert@secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-dresden-01.secunet.de
X-ExtendedProps: BQBjAAoATGQFfe5Q3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAAAAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.199
X-EndOfInjectedXHeaders: 20017
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:05:59 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Frontend
 Transport; Sat, 30 Mar 2024 22:05:59 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id EFF4C20883
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:05:58 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.151
X-Spam-Level:
X-Spam-Status: No, score=-5.151 tagged_above=-999 required=2.1
	tests=[BAYES_00=-1.9, DKIMWL_WL_HIGH=-0.1, DKIM_SIGNED=0.1,
	DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=0.249, MAILING_LIST_MULTI=-1,
	RCVD_IN_DNSWL_MED=-2.3, SPF_HELO_NONE=0.001, SPF_PASS=-0.001]
	autolearn=ham autolearn_force=no
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=pass (1024-bit key) header.d=redhat.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jPyHFIQzS7lk for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 22:05:58 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=linux-kernel+bounces-125884-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com D7FCA20520
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id D7FCA20520
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A319282BFF
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 21:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E9B4D9E7;
	Sat, 30 Mar 2024 21:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iMz1hl2M"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB243ADA
	for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711832736; cv=none; b=mYjoV2BWBEI3RSD/GVtT3x+lj2mN83O7o83HDNjGWcct/RiBj4fT+oMsIBQgHT3p9EpmRhcxvnErkql3acDjfK6TpFr87TVQT4gp1phG18GrBRhsY79AAGQA8In3tU6xs+OPVpW4a+iVftFNYidhZZZ+6S0OgwBWulAld1Pu7xk=
ARC-Message-Signature: i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711832736; c=relaxed/simple;
	bh=3Zs96oVvSrL1EcRD7qOwXkqb76tHEKhezfgjNzTnj6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ae1wa1GswZJRlxxXgy8YycVkEJOthYG2FpAKTw0BDXaPo1s30spPmdjif6fpbGfKo9tco6Ud2fa1IoHDYqcTptQOUOKVKIjmgUK7mOC8bUvXSMFCBIcDt+Krm2/802IiwANql4OgOx0ziO2IdVIjlXvxSf//LwzMBq7arunpDY4=
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iMz1hl2M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711832734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=;
	b=iMz1hl2Mf/psN5Od7gln/fDHfKpEbYKAoJhvY6cNexwhZrtJjVZGFsdCoZU3kWgWk1RIwh
	LKspXOWtfajfLA4pTm8k/VRcwb5l74UdyiTt8ptTmcNAW0OGRYJqcF18jP49JFR4Zcw1uK
	+iZjx/537Gyk0TR70Zvl0/odzcpHB4c=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-PGYr2KPYOiO_h0SY5dI7dA-1; Sat, 30 Mar 2024 17:05:32 -0400
X-MC-Unique: PGYr2KPYOiO_h0SY5dI7dA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a4e4a0dcee5so55232866b.1
        for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 14:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711832731; x=1712437531;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=;
        b=QxMFlo5ug4ZHZZGO5wWoALQQRlOPeUYjaulSwfIzWR7oJlOJZUfEcJb4tKgifu9IV/
         CWrr9zfXXJ+DF3eXPyeblWXVdK0S2qBJE7wDsixX4eH0+G7Gz2Z1SlPSiXMYd0Qwjoln
         tKeyZ74tNMi8tW8LcpBSMKrLsBlpZyl67z98q+iG5LAWWQv5tm1GC/nATwdb2KcT0xUH
         tUmQunTYQJ3WpIJ23zjsru60aJBbQ+YXbM+xtNCOL5IhkRIKT2UTKK42tEv/sG+PUYur
         e1FD3kzb5/i1RNzn/olY8riuKcgvK20Ad3rqi6RPG24rU0HZi7Jhjq0zTwHOgJtznwXd
         q7WA==
X-Forwarded-Encrypted: i=1; AJvYcCV2MbwO/cLEokR4NZioslecqzrHxS9Vf9nnhhRErbbfBZv3hRg9v4WmYxhiwj4OjRJPt6S8x6Cu5+FARLAGKnfAY4t+DSNSzNAzVkZK
X-Gm-Message-State: AOJu0YzKWQ4KhkKs0FzBu8Nr7LqQ+U2x7HqthkZw8l5f+HdZCRoD+Xdm
	koNmfBvn5I5GTrYHYjd3uuWdYqQ3QGcX9b5gyl1MmAtCfHswZOthI42mOl3wSebasWF2MeQDNWn
	9CsiOuZHW0eGHn1B+kjh+kHhkuFfDc6IWa+lyaLzuqC9LF36lVCo1UFYnFvl2sA==
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a170906a40d00b00a4e253d9641mr4204826ejz.8.1711832731470;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTeU1CiYPB2ByqnXfgbHYLBnkSUxAq1ZyFzRHCPzV8G1WZItagAlUo3C1OjOvbzmRD+zOCDA==
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a170906a40d00b00a4e253d9641mr4204815ejz.8.1711832731102;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id lb14-20020a170906adce00b00a4e57805d79sm513857ejb.181.2024.03.30.14.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 14:05:30 -0700 (PDT)
Message-ID: <a0799504-385b-40d8-a84c-eddb1bae930d@redhat.com>
Date: Sat, 30 Mar 2024 22:05:28 +0100
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 21/29] KVM: SEV: Implement gmem hook for initializing
 private pages
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
 <20240329225835.400662-22-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-22-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-Path: linux-kernel+bounces-125884-steffen.klassert=secunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:05:59.0559
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: f33a2ab5-8d5d-4b0d-edfc-08dc50fd32e4
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.secunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=cas-essen-02.secunet.de:TOTAL-FE=0.010|SMR=0.010(SMRPI=0.007(SMRPI-FrontendProxyAgent=0.007));2024-03-30T21:05:59.066Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 19470
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=Low
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

On 3/29/24 23:58, Michael Roth wrote:
> This will handle the RMP table updates needed to put a page into a
> private state before mapping it into an SEV-SNP guest.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  2 +
>   arch/x86/kvm/svm/svm.h |  5 +++
>   arch/x86/kvm/x86.c     |  5 +++
>   virt/kvm/guest_memfd.c |  4 +-
>   6 files changed, 113 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index d0bb0e7a4e80..286b40d0b07c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -124,6 +124,7 @@ config KVM_AMD_SEV
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
>   	select KVM_GENERIC_PRIVATE_MEM
> +	select HAVE_KVM_GMEM_PREPARE
>   	help
>   	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
>   	  with Encrypted State (SEV-ES) on AMD processors.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 9ea13c2de668..e1f8be1df219 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4282,3 +4282,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>   out:
>   	put_page(pfn_to_page(pfn));
>   }
> +
> +static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	kvm_pfn_t pfn = start;
> +
> +	while (pfn < end) {
> +		int ret, rmp_level;
> +		bool assigned;
> +
> +		ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> +		if (ret) {
> +			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GFN start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
> +					    pfn, start, end, rmp_level, ret);
> +			return false;
> +		}
> +
> +		if (assigned) {
> +			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RMP level %d\n",
> +				 __func__, pfn, start, end, rmp_level);
> +			return false;
> +		}
> +
> +		pfn++;
> +	}
> +
> +	return true;
> +}
> +
> +static u8 max_level_for_order(int order)
> +{
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int order)
> +{
> +	kvm_pfn_t pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +
> +	/*
> +	 * If this is a large folio, and the entire 2M range containing the
> +	 * PFN is currently shared, then the entire 2M-aligned range can be
> +	 * set to private via a single 2M RMP entry.
> +	 */
> +	if (max_level_for_order(order) > PG_LEVEL_4K &&
> +	    is_pfn_range_shared(pfn_aligned, pfn_aligned + PTRS_PER_PMD))
> +		return true;
> +
> +	return false;
> +}
> +
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_aligned;
> +	gfn_t gfn_aligned;
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc = snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %llx error %d\n",
> +				   gfn, pfn, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (assigned) {
> +		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %d\n",
> +			 __func__, gfn, pfn, max_order, level);
> +		return 0;
> +	}
> +
> +	if (is_large_rmp_possible(kvm, pfn, max_order)) {
> +		level = PG_LEVEL_2M;
> +		pfn_aligned = ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +		gfn_aligned = ALIGN_DOWN(gfn, PTRS_PER_PMD);
> +	} else {
> +		level = PG_LEVEL_4K;
> +		pfn_aligned = pfn;
> +		gfn_aligned = gfn;
> +	}
> +
> +	rc = rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, sev->asid, false);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx level %d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d level %d\n",
> +		 __func__, gfn, pfn, pfn_aligned, max_order, level);
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a895d3f07cb8..c099154e326a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5078,6 +5078,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>   	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
>   	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
> +
> +	.gmem_prepare = sev_gmem_prepare,
>   };
>   
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0cdcd0759fe0..53618cfc2b89 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
>   void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>   void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u64 attr, u64 *val) { return -ENXIO; }
>   static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
>   static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
> +static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
> +{
> +	return 0;
> +}
>   
>   #endif
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 617c38656757..d05922684005 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13615,6 +13615,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>   
>   #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type == KVM_X86_SNP_VM;
> +}
> +
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
>   {
>   	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3e3c4b7fff3b..11952254ae48 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
>   		gfn = slot->base_gfn + index - slot->gmem.pgoff;
>   		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
>   		if (rc) {
> -			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
> -					    index, rc);
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
> +					    index, gfn, pfn, rc);
>   			return rc;
>   		}
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo



