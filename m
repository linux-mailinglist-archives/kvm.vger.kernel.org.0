Return-Path: <kvm+bounces-13214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71293893389
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 868131C21C0A
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C4414A0B7;
	Sun, 31 Mar 2024 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iMz1hl2M"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390CE148820;
	Sun, 31 Mar 2024 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903046; cv=fail; b=RBwcDQNIGSuKC7Wz3VLVZ2pAtog/R6KZ/W95Sl/x23/CZrWqImUPDh2mnVrMIsbsZeGSTKsPdOiuQsujWq0+Bq/iqEKLeAms4JS22Cw7w21v+RSxF7sleCLMdI8acHDGY2bBxzS6FBOJEkwfoiR9hsDgxQ1gTWvZNcaAj745GsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903046; c=relaxed/simple;
	bh=zDURg6Vssa903sYmJTX+i8ZgxlrTjY8CUfwe3zIFg50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=akBGAEWdq6qGloHQ8VGjsNust7YnoUbiFfyJiyX9j2gMKSLKGgekDwU94lfWM6cM/2aEWknEHyqEtDpFtNEVFBD9TLS0Z7LGlb6F8zegpPCETiyW4x985axJ7UoGbaDlPM9PJ3PXfI/hyUfLfya4q8lTr8ZA00hnJXsMUY0E2Vc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iMz1hl2M reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id F3C6720754;
	Sun, 31 Mar 2024 18:37:20 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TkEyyvAFKbMh; Sun, 31 Mar 2024 18:37:18 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 4A202207BB;
	Sun, 31 Mar 2024 18:37:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 4A202207BB
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 0D5CB800056;
	Sun, 31 Mar 2024 18:28:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:28:14 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:51 +0000
X-sender: <linux-crypto+bounces-3133-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAJKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgATAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZlbi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 27811
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
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On 3/29/24 23:58, Michael Roth wrote:
> This will handle the RMP table updates needed to put a page into a
> private state before mapping it into an SEV-SNP guest.
>=20
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  2 +
>   arch/x86/kvm/svm/svm.h |  5 +++
>   arch/x86/kvm/x86.c     |  5 +++
>   virt/kvm/guest_memfd.c |  4 +-
>   6 files changed, 113 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index d0bb0e7a4e80..286b40d0b07c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -124,6 +124,7 @@ config KVM_AMD_SEV
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=3Dy && CRYPTO_DEV_CCP_DD=3Dm=
)
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
> @@ -4282,3 +4282,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, =
gpa_t gpa, u64 error_code)
>   out:
>   	put_page(pfn_to_page(pfn));
>   }
> +
> +static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	kvm_pfn_t pfn =3D start;
> +
> +	while (pfn < end) {
> +		int ret, rmp_level;
> +		bool assigned;
> +
> +		ret =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> +		if (ret) {
> +			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GF=
N start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
> +					    pfn, start, end, rmp_level, ret);
> +			return false;
> +		}
> +
> +		if (assigned) {
> +			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RM=
P level %d\n",
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
> +	if (order >=3D KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int or=
der)
> +{
> +	kvm_pfn_t pfn_aligned =3D ALIGN_DOWN(pfn, PTRS_PER_PMD);
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
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_=
order)
> +{
> +	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_aligned;
> +	gfn_t gfn_aligned;
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %ll=
x error %d\n",
> +				   gfn, pfn, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (assigned) {
> +		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %=
d\n",
> +			 __func__, gfn, pfn, max_order, level);
> +		return 0;
> +	}
> +
> +	if (is_large_rmp_possible(kvm, pfn, max_order)) {
> +		level =3D PG_LEVEL_2M;
> +		pfn_aligned =3D ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +		gfn_aligned =3D ALIGN_DOWN(gfn, PTRS_PER_PMD);
> +	} else {
> +		level =3D PG_LEVEL_4K;
> +		pfn_aligned =3D pfn;
> +		gfn_aligned =3D gfn;
> +	}
> +
> +	rc =3D rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, se=
v->asid, false);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx=
 level %d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d =
level %d\n",
> +		 __func__, gfn, pfn, pfn_aligned, max_order, level);
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a895d3f07cb8..c099154e326a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5078,6 +5078,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>   	.vcpu_deliver_sipi_vector =3D svm_vcpu_deliver_sipi_vector,
>   	.vcpu_get_apicv_inhibit_reasons =3D avic_vcpu_get_apicv_inhibit_reason=
s,
>   	.alloc_apic_backing_page =3D svm_alloc_apic_backing_page,
> +
> +	.gmem_prepare =3D sev_gmem_prepare,
>   };
>  =20
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0cdcd0759fe0..53618cfc2b89 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
>   void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_c=
ode);
>   void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_=
order);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u64 attr, u64 *va=
l) { return -ENXIO; }
>   static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gp=
a, u64 error_code) {}
>   static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *=
vcpu) {}
> +static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t=
 gfn, int max_order)
> +{
> +	return 0;
> +}
>  =20
>   #endif
>  =20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 617c38656757..d05922684005 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13615,6 +13615,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>  =20
>   #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type =3D=3D KVM_X86_SNP_VM;
> +}
> +
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, in=
t max_order)
>   {
>   	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3e3c4b7fff3b..11952254ae48 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, =
pgoff_t index, struct fol
>   		gfn =3D slot->base_gfn + index - slot->gmem.pgoff;
>   		rc =3D kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_h=
ead(page)));
>   		if (rc) {
> -			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, err=
or %d.\n",
> -					    index, rc);
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN =
%llx PFN %llx error %d.\n",
> +					    index, gfn, pfn, rc);
>   			return rc;
>   		}
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


X-sender: <kvm+bounces-13157-martin.weber=3Dsecunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=3Drfc822;martin.weber@secunet.=
com NOTIFY=3DNEVER; X-ExtendedProps=3DBQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7f=
W2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNS=
ZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAU=
AEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWU=
RJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAA=
LMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0=
cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3Vwcyx=
DTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cm=
F0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ie=
C1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxS=
ZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFg=
AFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYX=
Rpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc=
3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5U=
cmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQA=
jAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAQKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgAUAAAAo4oAAAUABAAUIAEAAAAYAAAAbWFydGlu=
LndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQUAKQACAAEPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwA=
BAAAABQADAAcAAAAAAAUABQACAAEFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 27703
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:05:53 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:05:53 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id 5F057202D2
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:05:53 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.851
X-Spam-Level:
X-Spam-Status: No, score=3D-2.851 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.1, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dunavailable autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PRycOYGK0JkN for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 22:05:52 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.48.161; helo=3Dsy.mirrors.kernel.org; envelope-from=3Dkvm+bounces=
-13157-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber@=
secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 197B92025D
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"Z/bwkp9z"
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 197B92025D
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CF3FB213F1
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 21:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B8C4AEDA;
	Sat, 30 Mar 2024 21:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"Z/bwkp9z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447D31119F
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.129.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711832738; cv=3Dnone; b=3DRgcMHBL5TppxCypWP+MeFLHyN6Y50n0RFy8ilRxIwVy=
yTmkmLr2SdafFzS0/QYhS/Fa1N57WpDpUSl7eNGZvYv1vB6pIfwZzF5Mt0PTZE07unVC7oEUF3t=
HVMODS8y9p8xDv2qzcKUTZkNDh1d6XmBUXLTmozEndaq+EV3J20zc=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711832738; c=3Drelaxed/simple;
	bh=3D3Zs96oVvSrL1EcRD7qOwXkqb76tHEKhezfgjNzTnj6U=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DPNiXqlxdVW1AtHUYT9Lox0RqQ0gOqAH/C12a0WaJ8YJ=
uT3b0WIe95P80NQpBMhIOJjfns+VZLYyFX2C6VDWeA8sxfBd+d0mCSzv9oWwE/aBPYyF9T3LwDu=
420y65l1CuvyN6jvX1SPtSIwerOVlpelaA7xn5Wl3AcKAsdyXFoig=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DZ/bwkp9z; arc=3Dnone smtp.client-ip=3D170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711832735;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3DzvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=3D;
	b=3DZ/bwkp9zeM6aOZHHVlrzAtv4msVYgJudKoGo3HvWI//S6NfoTmg/NiA8TY1vM4ge5cfxPd
	ZY9JuTDXhqV0UWWfzd8gDVJ4kRYtrhtlVmkcfOojWzgkvXJR9f+TO/GsSye690KMIMW9eo
	L1eXzKqiYeKFwr97odtklpwEa0Z3iPw=3D
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-627-GrF2kdagN9aVR0Ep795vZQ-1; Sat, 30 Mar 2024 17:05:33 -0400
X-MC-Unique: GrF2kdagN9aVR0Ep795vZQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4e4a0dcee5=
so55234366b.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711832731; x=3D1712437531;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DzvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=3D;
        b=3DRnpHZC+ZE0uG/fB2COMZLRVQFqwYQujWF2OgEcNc/7KMMPiUvZWkpzPfBVgXqzG=
7XP
         RJuZnGQRFbGG0FlvCRfHH+czWIMZHWk/NulrkY61K6Shq4LQLaWMK5kJXfqmR0uVwA=
E2
         pRiiief7uLtmCf2y+1dOuosjUu6snSU7uhAAJaDnuVsxcRdvD7+rXqCOpK1SrWS/5h=
S/
         +wv4HohG6dZHWeqMjGfZd4w9tEiZjIL67aVpFDQpUJcAtnXMy7N+dxl4ANpXKRIf+d=
Aj
         y6PO/ZkD+rMvAN3qJ4q6bAZTRP40gh1uej7/dJVdNsJzaZoeTnJWptDEMYfq3wISBL=
Uk
         FpYQ=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCWmapTY4WRjne7TrJpioNGm157K7l92NI0vkXpwG=
w/dRQCiL7HXThx1rhAAySIgTjMYQWh9F16OODdGdNeoFj8eSHke
X-Gm-Message-State: AOJu0Yy5mGnc+fyEkQUXvsbrU2f3Ns4/6CU6ZDVUTvlejifN/XtIn7k=
c
	3RD5xS7PNLQPqUWKUehWBB2yJWzaGxxosWLB4A6QFu6GLftPSZ+A9os0f2SpG/s2NlRj2Ixnyv=
8
	Tnl02rGW/lX+e+jnWSaVdhLgi0J0eaggLB8bKXvK+64vsMdcQsHQpwE9gHQ=3D=3D
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a17=
0906a40d00b00a4e253d9641mr4204855ejz.8.1711832731490;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTeU1CiYPB2ByqnXfgbHYLBnkSUxAq1ZyFzRHCPzV8G1WZI=
tagAlUo3C1OjOvbzmRD+zOCDA=3D=3D
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a17=
0906a40d00b00a4e253d9641mr4204815ejz.8.1711832731102;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id lb14-20020a170906adce00b00a4=
e57805d79sm513857ejb.181.2024.03.30.14.05.28
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:05:30 -0700 (PDT)
Message-ID: <a0799504-385b-40d8-a84c-eddb1bae930d@redhat.com>
Date: Sat, 30 Mar 2024 22:05:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 21/29] KVM: SEV: Implement gmem hook for initializi=
ng
 private pages
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org=
,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com=
,
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
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=3D
In-Reply-To: <20240329225835.400662-22-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: kvm+bounces-13157-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:05:53.4483
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: d57deb7e-197f-4f11-4852-08dc=
50fd2f8d
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.439|SMR=3D0.345(SMRDE=3D0.036|SMRC=3D0.30=
9(SMRCL=3D0.102|X-SMRCR=3D0.309))|CAT=3D0.092(CATOS=3D0.012
 (CATSM=3D0.011(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.042(CATRESLP2R=3D0.018)|CATORES=3D0.037
 (CATRS=3D0.037(CATRS-Index Routing Agent=3D0.036)));2024-03-30T21:05:54.02=
7Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 19529
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.140|SMR=3D0.009(SMRPI=3D0.006(SMRPI-FrontendProxyAgent=3D0.006))=
|SMS=3D0.131
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAaUOAAAPAAADH4sIAAAAAAAEAMVZC3PT=
SBKWn7ED4f262z
 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
 oRCUjxzJDF1BRSRdgmildYvy5MYR5erCTYpc65yEsy+ZjORA6P+ok0
 xz9sB7fUhHJLUIgzLcO/CFSW1wuSvJkikqfRQRk6pefITWCYfwKRoQ
 v2m0OQ86A5h0eUPAn8mergD/IRPU1LJ6XDHpU5XrNAd40e755jSmqm
 gPrTxbnlLs16mEOI8kk//+dzqJmfe3OZ/wCG+iXTvC8AAAEK2wE8P3
 htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxF
 bWFpbFNldD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8L1ZlcnNpb24+DQ
 ogIDxFbWFpbHM+DQogICAgPEVtYWlsIFN0YXJ0SW5kZXg9IjIwMSI+
 DQogICAgICA8RW1haWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb2
 08L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogIDwvRW1haWxz
 Pg0KPC9FbWFpbFNldD4BDPEDPD94bWwgdmVyc2lvbj0iMS4wIiBlbm
 NvZGluZz0idXRmLTE2Ij8+DQo8Q29udGFjdFNldD4NCiAgPFZlcnNp
 b24+MTUuMC4wLjA8L1ZlcnNpb24+DQogIDxDb250YWN0cz4NCiAgIC
 A8Q29udGFjdCBTdGFydEluZGV4PSIxODciPg0KICAgICAgPFBlcnNv
 biBTdGFydEluZGV4PSIxODciPg0KICAgICAgICA8UGVyc29uU3RyaW
 5nPk1pY2hhZWwgUm90aDwvUGVyc29uU3RyaW5nPg0KICAgICAgPC9Q
 ZXJzb24+DQogICAgICA8RW1haWxzPg0KICAgICAgICA8RW1haWwgU3
 RhcnRJbmRleD0iMjAxIj4NCiAgICAgICAgICA8RW1haWxTdHJpbmc+
 bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWlsU3RyaW5nPg0KICAgIC
 AgICA8L0VtYWlsPg0KICAgICAgPC9FbWFpbHM+DQogICAgICA8Q29u
 dGFjdFN0cmluZz5NaWNoYWVsIFJvdGggJmx0O21pY2hhZWwucm90aE
 BhbWQuY29tPC9Db250YWN0U3RyaW5nPg0KICAgIDwvQ29udGFjdD4N
 CiAgPC9Db250YWN0cz4NCjwvQ29udGFjdFNldD4BDs8BUmV0cmlldm
 VyT3BlcmF0b3IsMTAsMDtSZXRyaWV2ZXJPcGVyYXRvciwxMSwxO1Bv
 c3REb2NQYXJzZXJPcGVyYXRvciwxMCwwO1Bvc3REb2NQYXJzZXJPcG
 VyYXRvciwxMSwwO1Bvc3RXb3JkQnJlYWtlckRpYWdub3N0aWNPcGVy
 YXRvciwxMCwzO1Bvc3RXb3JkQnJlYWtlckRpYWdub3N0aWNPcGVyYX
 RvciwxMSwwO1RyYW5zcG9ydFdyaXRlclByb2R1Y2VyLDIwLDI0
X-MS-Exchange-Forest-IndexAgent: 1 4695
X-MS-Exchange-Forest-EmailMessageHash: 57C8C240
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> This will handle the RMP table updates needed to put a page into a
> private state before mapping it into an SEV-SNP guest.
>=20
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  2 +
>   arch/x86/kvm/svm/svm.h |  5 +++
>   arch/x86/kvm/x86.c     |  5 +++
>   virt/kvm/guest_memfd.c |  4 +-
>   6 files changed, 113 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index d0bb0e7a4e80..286b40d0b07c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -124,6 +124,7 @@ config KVM_AMD_SEV
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=3Dy && CRYPTO_DEV_CCP_DD=3Dm=
)
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
> @@ -4282,3 +4282,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, =
gpa_t gpa, u64 error_code)
>   out:
>   	put_page(pfn_to_page(pfn));
>   }
> +
> +static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	kvm_pfn_t pfn =3D start;
> +
> +	while (pfn < end) {
> +		int ret, rmp_level;
> +		bool assigned;
> +
> +		ret =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> +		if (ret) {
> +			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GF=
N start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
> +					    pfn, start, end, rmp_level, ret);
> +			return false;
> +		}
> +
> +		if (assigned) {
> +			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RM=
P level %d\n",
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
> +	if (order >=3D KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int or=
der)
> +{
> +	kvm_pfn_t pfn_aligned =3D ALIGN_DOWN(pfn, PTRS_PER_PMD);
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
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_=
order)
> +{
> +	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_aligned;
> +	gfn_t gfn_aligned;
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %ll=
x error %d\n",
> +				   gfn, pfn, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (assigned) {
> +		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %=
d\n",
> +			 __func__, gfn, pfn, max_order, level);
> +		return 0;
> +	}
> +
> +	if (is_large_rmp_possible(kvm, pfn, max_order)) {
> +		level =3D PG_LEVEL_2M;
> +		pfn_aligned =3D ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +		gfn_aligned =3D ALIGN_DOWN(gfn, PTRS_PER_PMD);
> +	} else {
> +		level =3D PG_LEVEL_4K;
> +		pfn_aligned =3D pfn;
> +		gfn_aligned =3D gfn;
> +	}
> +
> +	rc =3D rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, se=
v->asid, false);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx=
 level %d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d =
level %d\n",
> +		 __func__, gfn, pfn, pfn_aligned, max_order, level);
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a895d3f07cb8..c099154e326a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5078,6 +5078,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>   	.vcpu_deliver_sipi_vector =3D svm_vcpu_deliver_sipi_vector,
>   	.vcpu_get_apicv_inhibit_reasons =3D avic_vcpu_get_apicv_inhibit_reason=
s,
>   	.alloc_apic_backing_page =3D svm_alloc_apic_backing_page,
> +
> +	.gmem_prepare =3D sev_gmem_prepare,
>   };
>  =20
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0cdcd0759fe0..53618cfc2b89 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
>   void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_c=
ode);
>   void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_=
order);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u64 attr, u64 *va=
l) { return -ENXIO; }
>   static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gp=
a, u64 error_code) {}
>   static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *=
vcpu) {}
> +static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t=
 gfn, int max_order)
> +{
> +	return 0;
> +}
>  =20
>   #endif
>  =20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 617c38656757..d05922684005 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13615,6 +13615,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>  =20
>   #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type =3D=3D KVM_X86_SNP_VM;
> +}
> +
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, in=
t max_order)
>   {
>   	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3e3c4b7fff3b..11952254ae48 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, =
pgoff_t index, struct fol
>   		gfn =3D slot->base_gfn + index - slot->gmem.pgoff;
>   		rc =3D kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_h=
ead(page)));
>   		if (rc) {
> -			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, err=
or %d.\n",
> -					    index, rc);
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN =
%llx PFN %llx error %d.\n",
> +					    index, gfn, pfn, rc);
>   			return rc;
>   		}
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo


X-sender: <linux-kernel+bounces-125884-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com NOTIFY=3DNEVER; X-ExtendedProps=3DBQAVABYAAgAAAAUAFAARAPDFCS25B=
AlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURh=
dGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQB=
HAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3=
VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4Y=
wUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5n=
ZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl=
2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ0=
49Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAH=
QAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5z=
cG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAw=
AAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbi=
xPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQ=
XV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1p=
Y3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmV=
yc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAQKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgAVAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 27632
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:05:59 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:05:59 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id EFF4C20883
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:05:58 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.151
X-Spam-Level:
X-Spam-Status: No, score=3D-5.151 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.1, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jPyHFIQzS7lk for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 22:05:58 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125884-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com D7FCA20520
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id D7FCA20520
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A319282BFF
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 21:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E9B4D9E7;
	Sat, 30 Mar 2024 21:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"iMz1hl2M"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB243ADA
	for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.133.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711832736; cv=3Dnone; b=3DmYjoV2BWBEI3RSD/GVtT3x+lj2mN83O7o83HDNjGWcc=
t/RiBj4fT+oMsIBQgHT3p9EpmRhcxvnErkql3acDjfK6TpFr87TVQT4gp1phG18GrBRhsY79AAG=
QA8In3tU6xs+OPVpW4a+iVftFNYidhZZZ+6S0OgwBWulAld1Pu7xk=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711832736; c=3Drelaxed/simple;
	bh=3D3Zs96oVvSrL1EcRD7qOwXkqb76tHEKhezfgjNzTnj6U=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3Dae1wa1GswZJRlxxXgy8YycVkEJOthYG2FpAKTw0BDXa=
Po1s30spPmdjif6fpbGfKo9tco6Ud2fa1IoHDYqcTptQOUOKVKIjmgUK7mOC8bUvXSMFCBIcDt+=
Krm2/802IiwANql4OgOx0ziO2IdVIjlXvxSf//LwzMBq7arunpDY4=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DiMz1hl2M; arc=3Dnone smtp.client-ip=3D170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711832734;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3DzvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=3D;
	b=3DiMz1hl2Mf/psN5Od7gln/fDHfKpEbYKAoJhvY6cNexwhZrtJjVZGFsdCoZU3kWgWk1RIwh
	LKspXOWtfajfLA4pTm8k/VRcwb5l74UdyiTt8ptTmcNAW0OGRYJqcF18jP49JFR4Zcw1uK
	+iZjx/537Gyk0TR70Zvl0/odzcpHB4c=3D
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-256-PGYr2KPYOiO_h0SY5dI7dA-1; Sat, 30 Mar 2024 17:05:32 -0400
X-MC-Unique: PGYr2KPYOiO_h0SY5dI7dA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a4e4a0dcee5=
so55232866b.1
        for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 14:05:32 -0700=
 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711832731; x=3D1712437531;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DzvlmNpxIDJrnhPj/YKT8a7uMmKqBTvBD1u10rPEnCzE=3D;
        b=3DQxMFlo5ug4ZHZZGO5wWoALQQRlOPeUYjaulSwfIzWR7oJlOJZUfEcJb4tKgifu9=
IV/
         CWrr9zfXXJ+DF3eXPyeblWXVdK0S2qBJE7wDsixX4eH0+G7Gz2Z1SlPSiXMYd0Qwjo=
ln
         tKeyZ74tNMi8tW8LcpBSMKrLsBlpZyl67z98q+iG5LAWWQv5tm1GC/nATwdb2KcT0x=
UH
         tUmQunTYQJ3WpIJ23zjsru60aJBbQ+YXbM+xtNCOL5IhkRIKT2UTKK42tEv/sG+PUY=
ur
         e1FD3kzb5/i1RNzn/olY8riuKcgvK20Ad3rqi6RPG24rU0HZi7Jhjq0zTwHOgJtznw=
Xd
         q7WA=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCV2MbwO/cLEokR4NZioslecqzrHxS9Vf9nnhhREr=
bbfBZv3hRg9v4WmYxhiwj4OjRJPt6S8x6Cu5+FARLAGKnfAY4t+DSNSzNAzVkZK
X-Gm-Message-State: AOJu0YzKWQ4KhkKs0FzBu8Nr7LqQ+U2x7HqthkZw8l5f+HdZCRoD+Xd=
m
	koNmfBvn5I5GTrYHYjd3uuWdYqQ3QGcX9b5gyl1MmAtCfHswZOthI42mOl3wSebasWF2MeQDNW=
n
	9CsiOuZHW0eGHn1B+kjh+kHhkuFfDc6IWa+lyaLzuqC9LF36lVCo1UFYnFvl2sA=3D=3D
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a17=
0906a40d00b00a4e253d9641mr4204826ejz.8.1711832731470;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTeU1CiYPB2ByqnXfgbHYLBnkSUxAq1ZyFzRHCPzV8G1WZI=
tagAlUo3C1OjOvbzmRD+zOCDA=3D=3D
X-Received: by 2002:a17:906:a40d:b0:a4e:253d:9641 with SMTP id l13-20020a17=
0906a40d00b00a4e253d9641mr4204815ejz.8.1711832731102;
        Sat, 30 Mar 2024 14:05:31 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id lb14-20020a170906adce00b00a4=
e57805d79sm513857ejb.181.2024.03.30.14.05.28
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
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
Subject: Re: [PATCH v12 21/29] KVM: SEV: Implement gmem hook for initializi=
ng
 private pages
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org=
,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com=
,
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
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-22-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: linux-kernel+bounces-125884-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:05:59.0559
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: f33a2ab5-8d5d-4b0d-edfc-08dc=
50fd32e4
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.438|SMR=3D0.338(SMRDE=3D0.036|SMRC=3D0.30=
2(SMRCL=3D0.102|X-SMRCR=3D0.302))|CAT=3D0.098(CATOS=3D0.012
 (CATSM=3D0.012(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.043(CATRESLP2R=3D0.019)|CATORES=3D0.041
 (CATRS=3D0.041(CATRS-Index Routing Agent=3D0.040)));2024-03-30T21:05:59.49=
4Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 19470
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.010|SMR=3D0.010(SMRPI=3D0.007(SMRPI-FrontendProxyAgent=3D0.007))
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAaUOAAAPAAADH4sIAAAAAAAEAMVZC3PT=
SBKWn7ED4f262z
 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
 oRCUjxzJDF1BRSRdgmildYvy5MYR5erCTYpc65yEsy+ZjORA6P+ok0
 xz9sB7fUhHJLUIgzLcO/CFSW1wuSvJkikqfRQRk6pefITWCYfwKRoQ
 v2m0OQ86A5h0eUPAn8mergD/IRPU1LJ6XDHpU5XrNAd40e755jSmqm
 gPrTxbnlLs16mEOI8kk//+dzqJmfe3OZ/wCG+iXTvC8AAAEK2wE8P3
 htbCB2ZXJzaW9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxF
 bWFpbFNldD4NCiAgPFZlcnNpb24+MTUuMC4wLjA8L1ZlcnNpb24+DQ
 ogIDxFbWFpbHM+DQogICAgPEVtYWlsIFN0YXJ0SW5kZXg9IjIwMSI+
 DQogICAgICA8RW1haWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb2
 08L0VtYWlsU3RyaW5nPg0KICAgIDwvRW1haWw+DQogIDwvRW1haWxz
 Pg0KPC9FbWFpbFNldD4BDPEDPD94bWwgdmVyc2lvbj0iMS4wIiBlbm
 NvZGluZz0idXRmLTE2Ij8+DQo8Q29udGFjdFNldD4NCiAgPFZlcnNp
 b24+MTUuMC4wLjA8L1ZlcnNpb24+DQogIDxDb250YWN0cz4NCiAgIC
 A8Q29udGFjdCBTdGFydEluZGV4PSIxODciPg0KICAgICAgPFBlcnNv
 biBTdGFydEluZGV4PSIxODciPg0KICAgICAgICA8UGVyc29uU3RyaW
 5nPk1pY2hhZWwgUm90aDwvUGVyc29uU3RyaW5nPg0KICAgICAgPC9Q
 ZXJzb24+DQogICAgICA8RW1haWxzPg0KICAgICAgICA8RW1haWwgU3
 RhcnRJbmRleD0iMjAxIj4NCiAgICAgICAgICA8RW1haWxTdHJpbmc+
 bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWlsU3RyaW5nPg0KICAgIC
 AgICA8L0VtYWlsPg0KICAgICAgPC9FbWFpbHM+DQogICAgICA8Q29u
 dGFjdFN0cmluZz5NaWNoYWVsIFJvdGggJmx0O21pY2hhZWwucm90aE
 BhbWQuY29tPC9Db250YWN0U3RyaW5nPg0KICAgIDwvQ29udGFjdD4N
 CiAgPC9Db250YWN0cz4NCjwvQ29udGFjdFNldD4BDs8BUmV0cmlldm
 VyT3BlcmF0b3IsMTAsMDtSZXRyaWV2ZXJPcGVyYXRvciwxMSwxO1Bv
 c3REb2NQYXJzZXJPcGVyYXRvciwxMCwwO1Bvc3REb2NQYXJzZXJPcG
 VyYXRvciwxMSwwO1Bvc3RXb3JkQnJlYWtlckRpYWdub3N0aWNPcGVy
 YXRvciwxMCwzO1Bvc3RXb3JkQnJlYWtlckRpYWdub3N0aWNPcGVyYX
 RvciwxMSwwO1RyYW5zcG9ydFdyaXRlclByb2R1Y2VyLDIwLDI3
X-MS-Exchange-Forest-IndexAgent: 1 4695
X-MS-Exchange-Forest-EmailMessageHash: 57C8C240
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> This will handle the RMP table updates needed to put a page into a
> private state before mapping it into an SEV-SNP guest.
>=20
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/Kconfig   |  1 +
>   arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  2 +
>   arch/x86/kvm/svm/svm.h |  5 +++
>   arch/x86/kvm/x86.c     |  5 +++
>   virt/kvm/guest_memfd.c |  4 +-
>   6 files changed, 113 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index d0bb0e7a4e80..286b40d0b07c 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -124,6 +124,7 @@ config KVM_AMD_SEV
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=3Dy && CRYPTO_DEV_CCP_DD=3Dm=
)
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
> @@ -4282,3 +4282,101 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, =
gpa_t gpa, u64 error_code)
>   out:
>   	put_page(pfn_to_page(pfn));
>   }
> +
> +static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	kvm_pfn_t pfn =3D start;
> +
> +	while (pfn < end) {
> +		int ret, rmp_level;
> +		bool assigned;
> +
> +		ret =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> +		if (ret) {
> +			pr_warn_ratelimited("SEV: Failed to retrieve RMP entry: PFN 0x%llx GF=
N start 0x%llx GFN end 0x%llx RMP level %d error %d\n",
> +					    pfn, start, end, rmp_level, ret);
> +			return false;
> +		}
> +
> +		if (assigned) {
> +			pr_debug("%s: overlap detected, PFN 0x%llx start 0x%llx end 0x%llx RM=
P level %d\n",
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
> +	if (order >=3D KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static bool is_large_rmp_possible(struct kvm *kvm, kvm_pfn_t pfn, int or=
der)
> +{
> +	kvm_pfn_t pfn_aligned =3D ALIGN_DOWN(pfn, PTRS_PER_PMD);
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
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_=
order)
> +{
> +	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
> +	kvm_pfn_t pfn_aligned;
> +	gfn_t gfn_aligned;
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to look up RMP entry: GFN %llx PFN %ll=
x error %d\n",
> +				   gfn, pfn, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (assigned) {
> +		pr_debug("%s: already assigned: gfn %llx pfn %llx max_order %d level %=
d\n",
> +			 __func__, gfn, pfn, max_order, level);
> +		return 0;
> +	}
> +
> +	if (is_large_rmp_possible(kvm, pfn, max_order)) {
> +		level =3D PG_LEVEL_2M;
> +		pfn_aligned =3D ALIGN_DOWN(pfn, PTRS_PER_PMD);
> +		gfn_aligned =3D ALIGN_DOWN(gfn, PTRS_PER_PMD);
> +	} else {
> +		level =3D PG_LEVEL_4K;
> +		pfn_aligned =3D pfn;
> +		gfn_aligned =3D gfn;
> +	}
> +
> +	rc =3D rmp_make_private(pfn_aligned, gfn_to_gpa(gfn_aligned), level, se=
v->asid, false);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: Failed to update RMP entry: GFN %llx PFN %llx=
 level %d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -EINVAL;
> +	}
> +
> +	pr_debug("%s: updated: gfn %llx pfn %llx pfn_aligned %llx max_order %d =
level %d\n",
> +		 __func__, gfn, pfn, pfn_aligned, max_order, level);
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a895d3f07cb8..c099154e326a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5078,6 +5078,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>   	.vcpu_deliver_sipi_vector =3D svm_vcpu_deliver_sipi_vector,
>   	.vcpu_get_apicv_inhibit_reasons =3D avic_vcpu_get_apicv_inhibit_reason=
s,
>   	.alloc_apic_backing_page =3D svm_alloc_apic_backing_page,
> +
> +	.gmem_prepare =3D sev_gmem_prepare,
>   };
>  =20
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0cdcd0759fe0..53618cfc2b89 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -730,6 +730,7 @@ extern unsigned int max_sev_asid;
>   void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_c=
ode);
>   void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
> +int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_=
order);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -746,6 +747,10 @@ static inline int sev_dev_get_attr(u64 attr, u64 *va=
l) { return -ENXIO; }
>   static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gp=
a, u64 error_code) {}
>   static inline void sev_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *=
vcpu) {}
> +static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t=
 gfn, int max_order)
> +{
> +	return 0;
> +}
>  =20
>   #endif
>  =20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 617c38656757..d05922684005 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13615,6 +13615,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>  =20
>   #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
> +bool kvm_arch_gmem_prepare_needed(struct kvm *kvm)
> +{
> +	return kvm->arch.vm_type =3D=3D KVM_X86_SNP_VM;
> +}
> +
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, in=
t max_order)
>   {
>   	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 3e3c4b7fff3b..11952254ae48 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -46,8 +46,8 @@ static int kvm_gmem_prepare_folio(struct inode *inode, =
pgoff_t index, struct fol
>   		gfn =3D slot->base_gfn + index - slot->gmem.pgoff;
>   		rc =3D kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_h=
ead(page)));
>   		if (rc) {
> -			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, err=
or %d.\n",
> -					    index, rc);
> +			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN =
%llx PFN %llx error %d.\n",
> +					    index, gfn, pfn, rc);
>   			return rc;
>   		}
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo



