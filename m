Return-Path: <kvm+bounces-4331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C71D811223
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:54:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 904301F2143C
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590452C193;
	Wed, 13 Dec 2023 12:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bo7/GC8+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFA13269
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702471924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q9EqIwf08LmEIH+cEN/dULDXznjNTZrCAOaSTuIwhOA=;
	b=Bo7/GC8+1FoKU5ZcOlKjxScKJEDHPoF6vC9rlmxFWye4/ZwVBzIswa74+yQKdfo1YKiujJ
	8V1EkiNoDPrNz//bOMVVXw/+8z9b0sfbehjAQEgzQqt/Kf8O0ECyx7uUB9jiPhY/P7FuaV
	2AVjYRj06Mi3OK7yOTpQkC1gdOsDwEs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-vVOfmfv-PHeEDjwWqSNcEw-1; Wed, 13 Dec 2023 07:52:02 -0500
X-MC-Unique: vVOfmfv-PHeEDjwWqSNcEw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33637be635aso607229f8f.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 04:52:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702471921; x=1703076721;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q9EqIwf08LmEIH+cEN/dULDXznjNTZrCAOaSTuIwhOA=;
        b=qzgT7So0+7YKDa9UUVxPKd1FbyQHi6cbr0kd0pyfy1vAW3xHtafo8ttxBTJ3tjkqSA
         t5eksBlX7BneNOK+XNoqC7V35GjqakWxjV4FwTPBaKQMnEhdU+Xhq4UJF7ErRsXyMbRI
         gp0BEWIO5eKuGyqa7U79M2thqtjG+sUQLqdu6I39ZiTNI+khWKi+6uJn7ZzlBtRaKT2v
         HJN4UhUHxWb7maxgkuOE0QDmyiRVodnITIdwWoxmrEf9ZuUjP+VDh8wULO6u/gClOJCF
         qecvKKszIMXaXorO04T2RdKpSHsGme/4ilgRQoahPPQ41jtkeDtzXmWwGJiRDtl/y9Uv
         Q3Wg==
X-Gm-Message-State: AOJu0YwL5zi9tOe+lleWnq9nAjG8/RIBlYYZ805RXKcEW3f0FU4qFvbI
	Bul2sx2O9ZK/e4ikVQxsOoaDSvfRezeZBpzMfSkrTSMUL29+oLCFCln6JN/n4xRjTrvzCqkdCdN
	wZ6ZLB8ajgXyc
X-Received: by 2002:adf:f5c3:0:b0:336:42b3:e6fc with SMTP id k3-20020adff5c3000000b0033642b3e6fcmr221047wrp.139.1702471921737;
        Wed, 13 Dec 2023 04:52:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGS9kEb5NuIiXVIRCHPgHr8JyshyCNd1dXxmiolZKU6PUXqbebhVxtgWC/2E00NW6AGSO/0RQ==
X-Received: by 2002:adf:f5c3:0:b0:336:42b3:e6fc with SMTP id k3-20020adff5c3000000b0033642b3e6fcmr221030wrp.139.1702471921394;
        Wed, 13 Dec 2023 04:52:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id h3-20020a5d4303000000b0033629538fa2sm4664964wrq.18.2023.12.13.04.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 04:52:00 -0800 (PST)
Message-ID: <0b2eb374-356c-46c6-9c4a-9512fbfece7a@redhat.com>
Date: Wed, 13 Dec 2023 13:51:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/50] x86/cpufeatures: Add SEV-SNP CPU feature
Content-Language: en-US
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
 tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
 pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-5-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231016132819.1002933-5-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/23 15:27, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Add CPU feature detection for Secure Encrypted Virtualization with
> Secure Nested Paging. This feature adds a strong memory integrity
> protection to help prevent malicious hypervisor-based attacks like
> data replay, memory re-mapping, and more.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> Signed-off-by: Ashish Kalra <Ashish.Kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Queued, thanks.

Paolo

> ---
>   arch/x86/include/asm/cpufeatures.h       | 1 +
>   arch/x86/kernel/cpu/amd.c                | 5 +++--
>   tools/arch/x86/include/asm/cpufeatures.h | 1 +
>   3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 58cb9495e40f..1640cedd77f1 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -437,6 +437,7 @@
>   #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>   #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>   #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
>   #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>   #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>   #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index dd8379d84445..14ee7f750cc7 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -630,8 +630,8 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>   	 *	      SME feature (set in scattered.c).
>   	 *	      If the kernel has not enabled SME via any means then
>   	 *	      don't advertise the SME feature.
> -	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
> -	 *            SEV and SEV_ES feature (set in scattered.c).
> +	 *   For SEV: If BIOS has not enabled SEV then don't advertise SEV and
> +	 *	      any additional functionality based on it.
>   	 *
>   	 *   In all cases, since support for SME and SEV requires long mode,
>   	 *   don't advertise the feature under CONFIG_X86_32.
> @@ -666,6 +666,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
>   clear_sev:
>   		setup_clear_cpu_cap(X86_FEATURE_SEV);
>   		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
> +		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>   	}
>   }
>   
> diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
> index 798e60b5454b..669f45eefa0c 100644
> --- a/tools/arch/x86/include/asm/cpufeatures.h
> +++ b/tools/arch/x86/include/asm/cpufeatures.h
> @@ -432,6 +432,7 @@
>   #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualization */
>   #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is supported */
>   #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
> +#define X86_FEATURE_SEV_SNP		(19*32+ 4) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
>   #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
>   #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
>   #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */


