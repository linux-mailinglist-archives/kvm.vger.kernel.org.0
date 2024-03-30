Return-Path: <kvm+bounces-13212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7EAF89337F
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16AAF1F22FDE
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08998149C67;
	Sun, 31 Mar 2024 16:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwZ9MZ1i"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBFA145B35;
	Sun, 31 Mar 2024 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711902983; cv=fail; b=chKky9ipE7r+1I6/gveSxXqkGoKaAQGFj1KfmPcFpcMR4Hy+XWj6C9FLNVTrvG4KX+ckXglP2encBLykp4i6Eq0yS115qLlXO6r6214oS24qQBQ0QuoQm+PudPprflNHnaTHn1LUN3lepP5H9gpOkdtzKa6cTEDNfkEQe5YXRgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711902983; c=relaxed/simple;
	bh=mWEmXIQcymMC7uOzFPmEjmI90H0denh66YcddO/KDUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CuHbBqHUBO0jXZE2KQiHx5AN/1QFSDsjZEy552ipuy7uKeJ+ZTXzkO8OTRYP9z+B5OPxdlMUXamHeFgR4RgM/a717scIJFW6W2RyaUbJ6pWi894h4slzQuhDj4SFS6R+yzlJQ//5ynmwzfRuu9jdPK7p+agDtGrkc4FieKFB8ZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwZ9MZ1i reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 0ACF3207E4;
	Sun, 31 Mar 2024 18:36:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pEbDshQDB3uO; Sun, 31 Mar 2024 18:36:14 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 212B42083E;
	Sun, 31 Mar 2024 18:36:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 212B42083E
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id C45EA800056;
	Sun, 31 Mar 2024 18:27:34 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:27:34 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:53 +0000
X-sender: <linux-crypto+bounces-3135-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAuKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBYAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZlbi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 23407
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3135-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 3C21A2025D
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwZ9MZ1i"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834530; cv=none; b=PgOkXF678W9FwFCPiVKah4oovIgBF8F/JnAjhXPQYadrFMw6s+c93/cpsFP4CCmpp1MvFGZ3gW9RNn4I1KSTSuDG7F8jluCx/viwZsut6QgyteFd/9Q4ZcCd99QNu5td4CEPW8NWs8LY4PcHkUUXf5KTi6LEdxRmTmIHMg205wk=
ARC-Message-Signature: i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834530; c=relaxed/simple;
	bh=g0toAGCQtFi0G3GbWa0Q4HZPWv8jGtxInPF/JxlP71A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VDk1AdWfivfUlDYWWV0aeHeinK3zHP6Dwj3CQ2qewUTiR3JkY389d6bV/9E9OKg2J0ACGBw1DWYUPuF6lGvUnq274kQdBU+HYQaf3VVKagAkxwJnR9csNwkpG3T1KCpCWClj7sLvSTcqgcR3yTTn3MVnPc35I5YZ5/XMmBDm6Vc=
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwZ9MZ1i; arc=none smtp.client-ip=170.10.129.124
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
X-MC-Unique: UBr1dMo2OBao3coasgeSJA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834522; x=1712439322;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EwmuW/k3ZL7znVA8wS56lDlLW9BhS4TEVksrt7Me+Z8=;
        b=kpwxyFUqYeecCfbQoFu2U/Ua5qw/SLCrAg4DrZMom4Utjen+/Hv8fxlS2NszjL0764
         Lg22QDkQYFo2V8TLInInTacQamyzvAdiiW/l+fREsy4nHoQc9cayYJNCX5HmUqKAaz0c
         m1UN/5tm6ea3vepQX7+MeEz+5LoP5Y+tJRKO2T2tbPITyZOUjNdUf2t5cHRAO32qS8ND
         boFuMo9SbnxtUVGO10M1OgG2zGeQthvN9B996/CQJ+YIo1JvujhtxLGK9a55Z/LNEVYP
         s+GgQBTIEOhsLgdGLC2IBIgjZSHWQgoK961MEuZujrww3Lgj6aFdr2OmZ11mvAGmaBFa
         z4eg==
X-Forwarded-Encrypted: i=1; AJvYcCWE0tfK/u9nok79aQR0R+nL9nkCxH4IXe7/ail0UBP1W5Zv1I/BBv5RxxTK4VuJJB9Vopm7mxLNN2mBVQiivCrMhhPL9YcTH8G0712l
X-Gm-Message-State: AOJu0YzcKcrW4oWg39HDo55zSf6XzGTsCk6fumvDf8z9zhmcEIyMEYB+
	k4Sc5+qhHP0r/q6gl5yHb+cqP4PIu3wZc+VwrAryEu7eAWCTwncNh4kjzIhkM3EC1rmoejc/Eho
	JpIPP48OR2I3ifbf6SbScHd0TjF0Ayqp2wFNb6PbXqIfOxhPI503Boq0Ropu5QQ==
X-Received: by 2002:a50:bb44:0:b0:567:23a2:5b1e with SMTP id y62-20020a50bb44000000b0056723a25b1emr4176642ede.23.1711834522683;
        Sat, 30 Mar 2024 14:35:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4Y1Y1ai02PAHKv5gHHk8E9vouw7+IeXJOAyuQtq3+b2c4PJy15b2ZKcJKFYMqFhtFpYJu6A==
X-Received: by 2002:a50:bb44:0:b0:567:23a2:5b1e with SMTP id y62-20020a50bb44000000b0056723a25b1emr4176630ede.23.1711834522369;
        Sat, 30 Mar 2024 14:35:22 -0700 (PDT)
Message-ID: <4e89479a-e170-403a-b2eb-ce7b895e55a3@redhat.com>
Date: Sat, 30 Mar 2024 22:35:17 +0100
Precedence: bulk
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
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On 3/29/24 23:58, Michael Roth wrote:
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table. The existing mixed-attribute tracking in KVM is
> insufficient here, for instance:
>=20
>    - gmem allocates 2MB page
>    - guest issues PVALIDATE on 2MB page
>    - guest later converts a subpage to shared
>    - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
>    - KVM MMU splits NPT mapping to 4K
>    - guest later converts that shared page back to private
>=20
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.
>=20
> Implement a kvm_x86_ops.gmem_validate_fault() hook for SEV that checks
> for this condition and adjusts the mapping level accordingly.
>=20
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  1 +
>   arch/x86/kvm/svm/svm.h |  7 +++++++
>   3 files changed, 40 insertions(+)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 87d621d013a4..31f6f4786503 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4443,3 +4443,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_=
t end)
>   		pfn +=3D use_2m_update ? PTRS_PER_PMD : 1;
>   	}
>   }
> +
> +/*
> + * Re-check whether an #NPF for a private/gmem page can still be service=
d, and
> + * adjust maximum mapping level if needed.
> + */
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, b=
ool is_private,
> +			    u8 *max_level)
> +{
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level =
%d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (!assigned) {
> +		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx =
level %d\n",
> +				   gfn, pfn, level);
> +		return -EINVAL;
> +	}
> +
> +	if (level < *max_level)
> +		*max_level =3D level;
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b456906f2670..298b4ce77a5f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5081,6 +5081,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>  =20
>   	.gmem_prepare =3D sev_gmem_prepare,
>   	.gmem_invalidate =3D sev_gmem_invalidate,
> +	.gmem_validate_fault =3D sev_gmem_validate_fault,
>   };
>  =20
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 3f1f6d3d3ade..746f819a6de4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>   int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max=
_order);
>   void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, b=
ool is_private,
> +			    u8 *max_level);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, =
kvm_pfn_t pfn, gfn_t gfn, in
>   	return 0;
>   }
>   static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) =
{}
> +static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn=
, gfn_t gfn,
> +					  bool is_private, u8 *max_level)
> +{
> +	return 0;
> +}
>  =20
>   #endif
>  =20


X-sender: <kvm+bounces-13159-martin.weber=3Dsecunet.com@vger.kernel.org>
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
X-ExtendedProps: BQBjAAoAuKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBZAAAAo4oAAAUABAAUIAEAAAAYAAAAbWFydGlu=
LndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQUAKQACAAEPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwA=
BAAAABQADAAcAAAAAAAUABQACAAEFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 23284
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:35:40 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:35:40 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id EA64D2025D
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:35:40 +0100 (CET)
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
	with ESMTP id XCp5nsS-qjhA for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 22:35:39 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dkvm+bounces=
-13159-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber@=
secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 7487520322
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"PwZ9MZ1i"
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 7487520322
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10EC11F21A86
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 21:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905934B5CD;
	Sat, 30 Mar 2024 21:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"PwZ9MZ1i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ECB43AC2
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.129.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711834530; cv=3Dnone; b=3DPgOkXF678W9FwFCPiVKah4oovIgBF8F/JnAjhXPQYad=
rFMw6s+c93/cpsFP4CCmpp1MvFGZ3gW9RNn4I1KSTSuDG7F8jluCx/viwZsut6QgyteFd/9Q4Zc=
Cd99QNu5td4CEPW8NWs8LY4PcHkUUXf5KTi6LEdxRmTmIHMg205wk=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711834530; c=3Drelaxed/simple;
	bh=3Dg0toAGCQtFi0G3GbWa0Q4HZPWv8jGtxInPF/JxlP71A=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DVDk1AdWfivfUlDYWWV0aeHeinK3zHP6Dwj3CQ2qewUT=
iR3JkY389d6bV/9E9OKg2J0ACGBw1DWYUPuF6lGvUnq274kQdBU+HYQaf3VVKagAkxwJnR9csNw=
kpG3T1KCpCWClj7sLvSTcqgcR3yTTn3MVnPc35I5YZ5/XMmBDm6Vc=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DPwZ9MZ1i; arc=3Dnone smtp.client-ip=3D170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711834527;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3DEwmuW/k3ZL7znVA8wS56lDlLW9BhS4TEVksrt7Me+Z8=3D;
	b=3DPwZ9MZ1iyCAVzBUash6/9hnMVBP48I4GsfrdulDjf7X0dySw+dhCyQuoNF9cRn97oZnC0V
	cTOQYa0rlarrHCAeQS/Hszk96ip36xl7O644Vw+ylUW0h4uRIhxuKMLJ1NrVHXnq/yslBs
	rhet5l0+ntjKgvhS1bHVq1nOKnn3br4=3D
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-597-Z1cutKDMPAqZsj1hS9Y4tQ-1; Sat, 30 Mar 2024 17:35:23 -0400
X-MC-Unique: Z1cutKDMPAqZsj1hS9Y4tQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5681b29771f=
so2713252a12.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:35:23 -0700 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711834522; x=3D1712439322;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DEwmuW/k3ZL7znVA8wS56lDlLW9BhS4TEVksrt7Me+Z8=3D;
        b=3DnzCRUS20ImCAW2h2K5GoL6qVk3nAr99hKcLBSSqCe3IyM8m2GI6s2dERA7joPIe=
ggi
         CMiXYCjsP8xOJ1mO289qN6dczcnwI+vFzFsMSS+NJR+rp2/pXByFXgzVe+AjusVdDU=
Eg
         iKZUJpF/Kt15I0AedM3sTJqZAi1ZSnddDYBD5zL7/X/qlmppeMGOrTAPeNN37PfBQw=
PE
         zdiAq9FUWoYTeq9GB+tDL6ymyw6FikEOUpfhMekKSB4xcvomqjpGiLSl2Xwb+Z+jfS=
1f
         trWPxxxvq6dp5z6jCU7JFiZHI+tiI6iblXgMZzxJ506R9e7gEM0zUmHTQP9pjP0fvO=
Ig
         IBvQ=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCVVDt3jH5NKl/MGHyzEugLs33le86iNvLjQspEcR=
QzKog1U4wrqsbKd2XbBxiRn46WvGdEQ+Mr2CpNLtehpxAD3xXt9
X-Gm-Message-State: AOJu0YxDRJwX1L4tYkKr7mz+XPL/Dtq0B7tTTD3b1qBrpT4Lxtz6Yzr=
T
	nNw9rjmeGmQmu+ixJCjiIJ+mX+H/khlSownsdst1V9PcufXw+BEJkuWgzulSLyNIOoxmAnAn6x=
e
	KmLZ6GRFxU+QtOhjBnFX3YF5noQ8bQPSObqNIXqvKsyvHXtNLVA=3D=3D
X-Received: by 2002:a50:bb44:0:b0:567:23a2:5b1e with SMTP id y62-20020a50bb=
44000000b0056723a25b1emr4176641ede.23.1711834522682;
        Sat, 30 Mar 2024 14:35:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4Y1Y1ai02PAHKv5gHHk8E9vouw7+IeXJOAyuQtq3+b2c4P=
Jy15b2ZKcJKFYMqFhtFpYJu6A=3D=3D
X-Received: by 2002:a50:bb44:0:b0:567:23a2:5b1e with SMTP id y62-20020a50bb=
44000000b0056723a25b1emr4176630ede.23.1711834522369;
        Sat, 30 Mar 2024 14:35:22 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id cy14-20020a0564021c8e00b0056=
bf31fa2a3sm3688481edb.80.2024.03.30.14.35.18
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
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
Subject: Re: [PATCH v12 23/29] KVM: x86: Implement gmem hook for determinin=
g
 max NPT mapping level
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
 <20240329225835.400662-24-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-24-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: kvm+bounces-13159-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:35:40.9329
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: d2540025-1aa6-41fa-c753-08dc=
510158f9
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.435|SMR=3D0.348(SMRDE=3D0.035|SMRC=3D0.31=
2(SMRCL=3D0.101|X-SMRCR=3D0.313))|CAT=3D0.086(CATOS=3D0.011
 (CATSM=3D0.011(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.039(CATRESLP2R=3D0.020)|CATORES=3D0.033
 (CATRS=3D0.033(CATRS-Index Routing Agent=3D0.032)));2024-03-30T21:35:41.39=
8Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 16300
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.030|SMR=3D0.023(SMRPI=3D0.021(SMRPI-FrontendProxyAgent=3D0.020))=
|SMS=3D0.007
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAScJAAAPAAADH4sIAAAAAAAEAM1XbXPb=
xhE+kiJFUqTd2I
 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
 NdYtfYuLaAr7zRAu6VUilpUxqJXqaZLIsFZGBMl4aUZ0mCFn8FJrmC
 hFDgMmIh2R1jdl/kGUNRR1MjKcRMxpRqMHhHOwvifiEjqow5y0IEgI
 n0YGKhWKQtEOEch75UpF10uO+Pd9G/TAaNYEIunZNjwEWG3blAnrnL
 s1mynymxhVxZPJiL8zA7qyWyFwmJqIq4U8lUC0IUxJ2L1pQuEGaKVC
 yZAiPJ6jFjoEzOkbNEHYYGx6UEAEU59ZoTD3MsqcYVVEJpRW+kLYtF
 BF3k/OFQTnzRxaJR6VgXKUwLBa5fHSa2+YCtiUeMh6Nc4Cjkc4wzBY
 Ze88mYUjEjypRC32XZQok2eqjrMUtFh9b+mGWtapKlOfGokJln5F9k
 Ex5wO85ezGGsGpSjs4/Q+D3O2AVRzSVeJMWuqdbCec0bh29Rw2YADw
 vUW77JEoyvL7SmK4JpmTWYMvVVYgenSombXyUDpPHLxKPK/zC1GEDc
 o9LFmxojvX/S+TOPLmfEHzji81hu1DYxFauptHyYrvrp9Pj6v+bmnM
 CHruXsZKyzOlVB2uUivVIH07OPkzaF3Ul32pllmpyEhOJNcj43yfPq
 baq4/B8tsTtzoqwDzcdKYQxDn5LTbn6Br3kyErede1xu85lyWZ/Ome
 p5knWbinPp9ixlRSWpiLsJyJtzVUnve0vGGinGSummlOC5l/83zkEU
 IeEZAAABCtQCPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idX
 RmLTE2Ij8+DQo8RW1haWxTZXQ+DQogIDxWZXJzaW9uPjE1LjAuMC4w
 PC9WZXJzaW9uPg0KICA8RW1haWxzPg0KICAgIDxFbWFpbCBTdGFydE
 luZGV4PSIxMTM5Ij4NCiAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVs
 LnJvdGhAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD
 4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMTE5MiIgUG9zaXRpb249
 IlNpZ25hdHVyZSI+DQogICAgICA8RW1haWxTdHJpbmc+cGJvbnppbm
 lAcmVkaGF0LmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4N
 CiAgPC9FbWFpbHM+DQo8L0VtYWlsU2V0PgEMpwc8P3htbCB2ZXJzaW
 9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxDb250YWN0U2V0
 Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPENvbn
 RhY3RzPg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9IjExMjUiPg0K
 ICAgICAgPFBlcnNvbiBTdGFydEluZGV4PSIxMTI1Ij4NCiAgICAgIC
 AgPFBlcnNvblN0cmluZz5NaWNoYWVsIFJvdGg8L1BlcnNvblN0cmlu
 Zz4NCiAgICAgIDwvUGVyc29uPg0KICAgICAgPEVtYWlscz4NCiAgIC
 AgICAgPEVtYWlsIFN0YXJ0SW5kZXg9IjExMzkiPg0KICAgICAgICAg
 IDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdGhAYW1kLmNvbTwvRW1haW
 xTdHJpbmc+DQogICAgICAgIDwvRW1haWw+DQogICAgICA8L0VtYWls
 cz4NCiAgICAgIDxDb250YWN0U3RyaW5nPk1pY2hhZWwgUm90aCAmbH
 Q7bWljaGFlbC5yb3RoQGFtZC5jb208L0NvbnRhY3RTdHJpbmc+DQog
 ICAgPC9Db250YWN0Pg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9Ij
 ExNzciIFBvc2l0aW9uPSJTaWduYXR1cmUiPg0KICAgICAgPFBlcnNv
 biBTdGFydEluZGV4PSIxMTc3IiBQb3NpdGlvbj0iU2lnbmF0dXJlIj
 4NCiAgICAgICAgPFBlcnNvblN0cmluZz5QYW9sbyBCb256aW5pPC9Q
 ZXJzb25TdHJpbmc+DQogICAgICA8L1BlcnNvbj4NCiAgICAgIDxFbW
 FpbHM+DQogICAgICAgIDxFbWFpbCBTdGFydEluZGV4PSIxMTkyIiBQ
 b3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAgICAgICAgICA8RW1haWxTdH
 Jpbmc+cGJvbnppbmlAcmVkaGF0LmNvbTwvRW1haWxTdHJpbmc+DQog
 ICAgICAgIDwvRW1haWw+DQogICAgICA8L0VtYWlscz4NCiAgICAgID
 xDb250YWN0U3RyaW5nPlBhb2xvIEJvbnppbmkgJmx0O3Bib256aW5p
 QHJlZGhhdC5jb208L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YW
 N0Pg0KICA8L0NvbnRhY3RzPg0KPC9Db250YWN0U2V0PgEOzwFSZXRy
 aWV2ZXJPcGVyYXRvciwxMCwxO1JldHJpZXZlck9wZXJhdG9yLDExLD
 E7UG9zdERvY1BhcnNlck9wZXJhdG9yLDEwLDA7UG9zdERvY1BhcnNl
 ck9wZXJhdG9yLDExLDA7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY0
 9wZXJhdG9yLDEwLDE7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09w
 ZXJhdG9yLDExLDA7VHJhbnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMj E=3D
X-MS-Exchange-Forest-IndexAgent: 1 3848
X-MS-Exchange-Forest-EmailMessageHash: DDBAC2FC
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table. The existing mixed-attribute tracking in KVM is
> insufficient here, for instance:
>=20
>    - gmem allocates 2MB page
>    - guest issues PVALIDATE on 2MB page
>    - guest later converts a subpage to shared
>    - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
>    - KVM MMU splits NPT mapping to 4K
>    - guest later converts that shared page back to private
>=20
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.
>=20
> Implement a kvm_x86_ops.gmem_validate_fault() hook for SEV that checks
> for this condition and adjusts the mapping level accordingly.
>=20
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  1 +
>   arch/x86/kvm/svm/svm.h |  7 +++++++
>   3 files changed, 40 insertions(+)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 87d621d013a4..31f6f4786503 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4443,3 +4443,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_=
t end)
>   		pfn +=3D use_2m_update ? PTRS_PER_PMD : 1;
>   	}
>   }
> +
> +/*
> + * Re-check whether an #NPF for a private/gmem page can still be service=
d, and
> + * adjust maximum mapping level if needed.
> + */
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, b=
ool is_private,
> +			    u8 *max_level)
> +{
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level =
%d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (!assigned) {
> +		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx =
level %d\n",
> +				   gfn, pfn, level);
> +		return -EINVAL;
> +	}
> +
> +	if (level < *max_level)
> +		*max_level =3D level;
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b456906f2670..298b4ce77a5f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5081,6 +5081,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>  =20
>   	.gmem_prepare =3D sev_gmem_prepare,
>   	.gmem_invalidate =3D sev_gmem_invalidate,
> +	.gmem_validate_fault =3D sev_gmem_validate_fault,
>   };
>  =20
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 3f1f6d3d3ade..746f819a6de4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>   int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max=
_order);
>   void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, b=
ool is_private,
> +			    u8 *max_level);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, =
kvm_pfn_t pfn, gfn_t gfn, in
>   	return 0;
>   }
>   static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) =
{}
> +static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn=
, gfn_t gfn,
> +					  bool is_private, u8 *max_level)
> +{
> +	return 0;
> +}
>  =20
>   #endif
>  =20


X-sender: <linux-kernel+bounces-125895-steffen.klassert=3Dsecunet.com@vger.=
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
X-ExtendedProps: BQBjAAoAtaNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBaAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 23237
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:35:58 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:35:58 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 8EC8920883
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:35:58 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.851
X-Spam-Level:
X-Spam-Status: No, score=3D-2.851 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.1, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WvBMAZHTwSqc for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 22:35:57 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dlinux-kern=
el+bounces-125895-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 135CB2076B
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 135CB2076B
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDEB11C21721
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 21:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EA04F5FD;
	Sat, 30 Mar 2024 21:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"PwZ9MZ1i"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A388345948
	for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.133.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711834530; cv=3Dnone; b=3DfO/lEHbAvPLPvD4Czk3OqRCafqKiRL8iA0CO8q3eZQU=
N1kteZWed50dTZAyxTZuCdaX9qS/XnXuBeW5qVjX9QR8/wTnWHHzz2AMuaZjzC3tb1Dr6TyQ2Sm=
NypR8s7rZVDdK6ARJUpxAZud/DR7rrr/s5fFn/Kmo2G7UC5c5imR4=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711834530; c=3Drelaxed/simple;
	bh=3Dg0toAGCQtFi0G3GbWa0Q4HZPWv8jGtxInPF/JxlP71A=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DVDk1AdWfivfUlDYWWV0aeHeinK3zHP6Dwj3CQ2qewUT=
iR3JkY389d6bV/9E9OKg2J0ACGBw1DWYUPuF6lGvUnq274kQdBU+HYQaf3VVKagAkxwJnR9csNw=
kpG3T1KCpCWClj7sLvSTcqgcR3yTTn3MVnPc35I5YZ5/XMmBDm6Vc=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DPwZ9MZ1i; arc=3Dnone smtp.client-ip=3D170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711834527;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3DEwmuW/k3ZL7znVA8wS56lDlLW9BhS4TEVksrt7Me+Z8=3D;
	b=3DPwZ9MZ1iyCAVzBUash6/9hnMVBP48I4GsfrdulDjf7X0dySw+dhCyQuoNF9cRn97oZnC0V
	cTOQYa0rlarrHCAeQS/Hszk96ip36xl7O644Vw+ylUW0h4uRIhxuKMLJ1NrVHXnq/yslBs
	rhet5l0+ntjKgvhS1bHVq1nOKnn3br4=3D
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-112-tSJu9a0cMgmQB3On25fBYg-1; Sat, 30 Mar 2024 17:35:23 -0400
X-MC-Unique: tSJu9a0cMgmQB3On25fBYg-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5689f41cf4d=
so2408093a12.3
        for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 14:35:23 -0700=
 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711834522; x=3D1712439322;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DEwmuW/k3ZL7znVA8wS56lDlLW9BhS4TEVksrt7Me+Z8=3D;
        b=3DjTT2FBgSYMoeJE5ccOi5DsUyE0juZB4gBpRsaeSs9kH9ALQmj2ilHm8toqrL4cy=
yRv
         Ofppy6SnyGFp2zfcHgVCc/EKCvuOaQZK6JLnQl8X2ElNIadsNZPGYktkgwtSlkzXYk=
vz
         CLb+Mcn2pOShlO2CvLTXusmuKk3Y/Zt5FdLpngbspaovc+VJ1pXRCKMkKMylEO5vme=
tk
         Hny51o7yTwHFWOegSUEFqtPM2imlks1J7mBZ0WuWiM7shRLBCiY9cNmWZLphMb+nEs=
9a
         ipG4IOi+Wmp8zeHIcqDBWl6+wdAwUQO1tV70NDjBvGynKbt8FATmGTDxCv+bQ1fv2r=
IQ
         GuZQ=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCX4Pp+/19Mb2juuK84MNGHHMO5BHtlVbuQw6u4Zj=
A70d901hLiKrIUob09YFXAiG9zaWUumWi5S5A3ycfm7kpmU1INlD4mcb72VKS3k
X-Gm-Message-State: AOJu0YzQvpxLO0QoT38CtX9+7v5jgy51U7OMzC5vh+PxRqnKlxdZhHH=
8
	6ZlZLqCDd5Th1F5x22MqKJ+q7SSedAzc4vh61ECYbvvQsECUlrHUi24/Y+QP5l0Lt05efWXFOn=
w
	NWMVbeMVoNNqFiKg+nNGL//njdocX9xu1QzBM7wXulm42lMtfWzkkBnz5rJgmgA=3D=3D
X-Received: by 2002:a50:bb44:0:b0:567:23a2:5b1e with SMTP id y62-20020a50bb=
44000000b0056723a25b1emr4176662ede.23.1711834522688;
        Sat, 30 Mar 2024 14:35:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4Y1Y1ai02PAHKv5gHHk8E9vouw7+IeXJOAyuQtq3+b2c4P=
Jy15b2ZKcJKFYMqFhtFpYJu6A=3D=3D
X-Received: by 2002:a50:bb44:0:b0:567:23a2:5b1e with SMTP id y62-20020a50bb=
44000000b0056723a25b1emr4176630ede.23.1711834522369;
        Sat, 30 Mar 2024 14:35:22 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id cy14-20020a0564021c8e00b0056=
bf31fa2a3sm3688481edb.80.2024.03.30.14.35.18
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:35:21 -0700 (PDT)
Message-ID: <4e89479a-e170-403a-b2eb-ce7b895e55a3@redhat.com>
Date: Sat, 30 Mar 2024 22:35:17 +0100
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 23/29] KVM: x86: Implement gmem hook for determinin=
g
 max NPT mapping level
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
 <20240329225835.400662-24-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-24-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: linux-kernel+bounces-125895-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:35:58.5206
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 240c94ed-22c0-47b6-7326-08dc=
51016375
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.435|SMR=3D0.348(SMRDE=3D0.035|SMRC=3D0.31=
2(SMRCL=3D0.101|X-SMRCR=3D0.313))|CAT=3D0.086(CATOS=3D0.011
 (CATSM=3D0.011(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.040(CATRESLP2R=3D0.021)|CATORES=3D0.032
 (CATRS=3D0.032(CATRS-Index Routing Agent=3D0.031)));2024-03-30T21:35:59.00=
4Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 16255
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.049|SMR=3D0.008(SMRPI=3D0.005(SMRPI-FrontendProxyAgent=3D0.005))=
|SMS=3D0.041
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAScJAAAPAAADH4sIAAAAAAAEAM1XbXPb=
xhE+kiJFUqTd2I
 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
 NdYtfYuLaAr7zRAu6VUilpUxqJXqaZLIsFZGBMl4aUZ0mCFn8FJrmC
 hFDgMmIh2R1jdl/kGUNRR1MjKcRMxpRqMHhHOwvifiEjqow5y0IEgI
 n0YGKhWKQtEOEch75UpF10uO+Pd9G/TAaNYEIunZNjwEWG3blAnrnL
 s1mynymxhVxZPJiL8zA7qyWyFwmJqIq4U8lUC0IUxJ2L1pQuEGaKVC
 yZAiPJ6jFjoEzOkbNEHYYGx6UEAEU59ZoTD3MsqcYVVEJpRW+kLYtF
 BF3k/OFQTnzRxaJR6VgXKUwLBa5fHSa2+YCtiUeMh6Nc4Cjkc4wzBY
 Ze88mYUjEjypRC32XZQok2eqjrMUtFh9b+mGWtapKlOfGokJln5F9k
 Ex5wO85ezGGsGpSjs4/Q+D3O2AVRzSVeJMWuqdbCec0bh29Rw2YADw
 vUW77JEoyvL7SmK4JpmTWYMvVVYgenSombXyUDpPHLxKPK/zC1GEDc
 o9LFmxojvX/S+TOPLmfEHzji81hu1DYxFauptHyYrvrp9Pj6v+bmnM
 CHruXsZKyzOlVB2uUivVIH07OPkzaF3Ul32pllmpyEhOJNcj43yfPq
 baq4/B8tsTtzoqwDzcdKYQxDn5LTbn6Br3kyErede1xu85lyWZ/Ome
 p5knWbinPp9ixlRSWpiLsJyJtzVUnve0vGGinGSummlOC5l/83zkEU
 IeEZAAABCtQCPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idX
 RmLTE2Ij8+DQo8RW1haWxTZXQ+DQogIDxWZXJzaW9uPjE1LjAuMC4w
 PC9WZXJzaW9uPg0KICA8RW1haWxzPg0KICAgIDxFbWFpbCBTdGFydE
 luZGV4PSIxMTM5Ij4NCiAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVs
 LnJvdGhAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD
 4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMTE5MiIgUG9zaXRpb249
 IlNpZ25hdHVyZSI+DQogICAgICA8RW1haWxTdHJpbmc+cGJvbnppbm
 lAcmVkaGF0LmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4N
 CiAgPC9FbWFpbHM+DQo8L0VtYWlsU2V0PgEMpwc8P3htbCB2ZXJzaW
 9uPSIxLjAiIGVuY29kaW5nPSJ1dGYtMTYiPz4NCjxDb250YWN0U2V0
 Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPENvbn
 RhY3RzPg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9IjExMjUiPg0K
 ICAgICAgPFBlcnNvbiBTdGFydEluZGV4PSIxMTI1Ij4NCiAgICAgIC
 AgPFBlcnNvblN0cmluZz5NaWNoYWVsIFJvdGg8L1BlcnNvblN0cmlu
 Zz4NCiAgICAgIDwvUGVyc29uPg0KICAgICAgPEVtYWlscz4NCiAgIC
 AgICAgPEVtYWlsIFN0YXJ0SW5kZXg9IjExMzkiPg0KICAgICAgICAg
 IDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdGhAYW1kLmNvbTwvRW1haW
 xTdHJpbmc+DQogICAgICAgIDwvRW1haWw+DQogICAgICA8L0VtYWls
 cz4NCiAgICAgIDxDb250YWN0U3RyaW5nPk1pY2hhZWwgUm90aCAmbH
 Q7bWljaGFlbC5yb3RoQGFtZC5jb208L0NvbnRhY3RTdHJpbmc+DQog
 ICAgPC9Db250YWN0Pg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9Ij
 ExNzciIFBvc2l0aW9uPSJTaWduYXR1cmUiPg0KICAgICAgPFBlcnNv
 biBTdGFydEluZGV4PSIxMTc3IiBQb3NpdGlvbj0iU2lnbmF0dXJlIj
 4NCiAgICAgICAgPFBlcnNvblN0cmluZz5QYW9sbyBCb256aW5pPC9Q
 ZXJzb25TdHJpbmc+DQogICAgICA8L1BlcnNvbj4NCiAgICAgIDxFbW
 FpbHM+DQogICAgICAgIDxFbWFpbCBTdGFydEluZGV4PSIxMTkyIiBQ
 b3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAgICAgICAgICA8RW1haWxTdH
 Jpbmc+cGJvbnppbmlAcmVkaGF0LmNvbTwvRW1haWxTdHJpbmc+DQog
 ICAgICAgIDwvRW1haWw+DQogICAgICA8L0VtYWlscz4NCiAgICAgID
 xDb250YWN0U3RyaW5nPlBhb2xvIEJvbnppbmkgJmx0O3Bib256aW5p
 QHJlZGhhdC5jb208L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YW
 N0Pg0KICA8L0NvbnRhY3RzPg0KPC9Db250YWN0U2V0PgEOzwFSZXRy
 aWV2ZXJPcGVyYXRvciwxMCwwO1JldHJpZXZlck9wZXJhdG9yLDExLD
 E7UG9zdERvY1BhcnNlck9wZXJhdG9yLDEwLDA7UG9zdERvY1BhcnNl
 ck9wZXJhdG9yLDExLDA7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY0
 9wZXJhdG9yLDEwLDE7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09w
 ZXJhdG9yLDExLDA7VHJhbnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMj A=3D
X-MS-Exchange-Forest-IndexAgent: 1 3848
X-MS-Exchange-Forest-EmailMessageHash: DDBAC2FC
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table. The existing mixed-attribute tracking in KVM is
> insufficient here, for instance:
>=20
>    - gmem allocates 2MB page
>    - guest issues PVALIDATE on 2MB page
>    - guest later converts a subpage to shared
>    - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
>    - KVM MMU splits NPT mapping to 4K
>    - guest later converts that shared page back to private
>=20
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.
>=20
> Implement a kvm_x86_ops.gmem_validate_fault() hook for SEV that checks
> for this condition and adjusts the mapping level accordingly.
>=20
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c |  1 +
>   arch/x86/kvm/svm/svm.h |  7 +++++++
>   3 files changed, 40 insertions(+)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 87d621d013a4..31f6f4786503 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4443,3 +4443,35 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_=
t end)
>   		pfn +=3D use_2m_update ? PTRS_PER_PMD : 1;
>   	}
>   }
> +
> +/*
> + * Re-check whether an #NPF for a private/gmem page can still be service=
d, and
> + * adjust maximum mapping level if needed.
> + */
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, b=
ool is_private,
> +			    u8 *max_level)
> +{
> +	int level, rc;
> +	bool assigned;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
> +	if (rc) {
> +		pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PFN %llx level =
%d error %d\n",
> +				   gfn, pfn, level, rc);
> +		return -ENOENT;
> +	}
> +
> +	if (!assigned) {
> +		pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %llx PFN %llx =
level %d\n",
> +				   gfn, pfn, level);
> +		return -EINVAL;
> +	}
> +
> +	if (level < *max_level)
> +		*max_level =3D level;
> +
> +	return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b456906f2670..298b4ce77a5f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5081,6 +5081,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>  =20
>   	.gmem_prepare =3D sev_gmem_prepare,
>   	.gmem_invalidate =3D sev_gmem_invalidate,
> +	.gmem_validate_fault =3D sev_gmem_validate_fault,
>   };
>  =20
>   /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 3f1f6d3d3ade..746f819a6de4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -732,6 +732,8 @@ void sev_vcpu_unblocking(struct kvm_vcpu *vcpu);
>   void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>   int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max=
_order);
>   void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> +int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, b=
ool is_private,
> +			    u8 *max_level);
>   #else
>   static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
>   	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -753,6 +755,11 @@ static inline int sev_gmem_prepare(struct kvm *kvm, =
kvm_pfn_t pfn, gfn_t gfn, in
>   	return 0;
>   }
>   static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) =
{}
> +static inline int sev_gmem_validate_fault(struct kvm *kvm, kvm_pfn_t pfn=
, gfn_t gfn,
> +					  bool is_private, u8 *max_level)
> +{
> +	return 0;
> +}
>  =20
>   #endif
>  =20



