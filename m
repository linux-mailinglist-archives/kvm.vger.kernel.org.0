Return-Path: <kvm+bounces-40940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 957ADA5F998
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2054A3B712A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB355267F4F;
	Thu, 13 Mar 2025 15:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OmgUpnoH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31FB268C57
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741879138; cv=none; b=aF8eYguzsajoXCXWAVpTAsz0dyO/IliE22IdXw7PgiXh4828cHFl/4eksOxIH+ydhpQ3rkkY6Gg1I0J5lNRRbHIDps5jKgMNAPcqTlXpT3mM6dUpXl+j+lwPERRe9S3CsJZr+YegV0kgZXT97yHP8BH9sd6Qj95JhKTLHloEgdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741879138; c=relaxed/simple;
	bh=biOFOrjyNPGux6ayj9B/Vw3H0Xwu5Q1ON2XruTCXOwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JRQQCRZG2beNNGsUZTqL+TPjMYYczoPfqxu74Nz4bBN9USO9CzaBltfAZw04jNR6L87gVnx7Vx5uv+zp68xThZYxpF6irS0TgPu28KiwZsfE4srac3q3YzVVxCfbsji4LzUEov9J0Tn4eKqifFF3BvICV68IDB/7iApk3LKYaL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OmgUpnoH; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43bc21f831bso1142845e9.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741879134; x=1742483934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0kcZ+FBM98/4axxtkg6aqj2pEYbsSfE5zT+MBkVn5yg=;
        b=OmgUpnoHPdIt0cLlMFDm3cUpvXPEk3ylN9ZEbnQf4wdFP5XpFvGDjzlExxXU+bFM6A
         DqRVKWrB+FJNGBCKBgMps9Y6VJgB7Ii1G2EIqjd8b/ueddOBuUZotfZe7KLtSV+Mea4v
         hWWJu2Y3Td2unBQURdI8Ya5BhkgAGNBY8rX405L/o3SY9EDkyAKIJ+nCupiR9x+BDj7/
         VmXJnFeVI6JqyJLgdGQrBjg2vS6vIYwRE2EkPOrwfjaPek2ZvLmqr0bxKLR+eZrq7hEK
         OruzrM3rmIx8Ee2rKmv2YSqpmCtEgc+2tzeqPAQBQR8csWJRGHemzPhF1aGU43mNtpIv
         UHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741879134; x=1742483934;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kcZ+FBM98/4axxtkg6aqj2pEYbsSfE5zT+MBkVn5yg=;
        b=GXHem7n6FYpUVw3FBb6od0dEG+OTkN4Ok9l+8SsBLVHIAiLFapuuODDexi0zcZxxzo
         ncgZBQ7h/35PgurMlAn9I5fc/6vGgQ3G5rtpk7Pg612X1aju/r4XljFIltkn4RkT+J8c
         gSOeJM7LcMeCJQkQtOBeB5F9TMho82N1Yiiv5E7F9qmZ8BD2LpBo6W7NoGWL/aeju2jA
         +wqse5d4dJ0to+9ViLP3tUVi0fCo+db/GiD69pJtVlweGNrmpTj+TSRwwdQ1h7RtKgYu
         18T5tSRZEnZV6wFzH14OHZl0dMfiqnTNDINkBveSmU+JdR6+U4BvbMoX+6EmrbrD5pdf
         TjBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpa65jXgZ7GqjIxGzZBnOuaHwJG2dhTfqZBdj7fo8O58Hly3Qbk9TUZ6ci388ByrjlXIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuaHDXRmHj0cCTOQ7v2hf1a6/qh2I3wBO/g8x+HN0yWZAjRIr/
	lgsGTUCLrrbe+y5z32g0w/gplCIdw5V7HvzLwvwQsJHbToNF+FIyGQ9MvfpJM9w=
X-Gm-Gg: ASbGncvlECjNRUUIVChTAMKBZmGCx8dxxAHF2ThagfGUUNQDTfkpQhK7HG/u5ZCrM0O
	sa5F2Z2DyiQrZkRqGtA0gSA0hIJ/Wh5wm61XE0x98muZhMxRNYDpuiiQmLmKWwri1xd6uisYiXc
	4pCQvJ8e+8Sm8sS+Ia4FhhbRAFiZuRk2qA+5FE4bTou94dBfOr92wdcr8nxCJzoKx1iE7z4s19F
	KlH89qHtY1IvmtXn+NOf73R7GTGpuJm7kpIxpB1I+DEMHKPZC5e5d7vJ853VJz/6qdskxuECk0y
	6t4ovZmF55LiCw1MQckP/0Q5aumMtdIXDtRuLfCdQabMw+ckjJpYdkllHw==
X-Google-Smtp-Source: AGHT+IFuiE/TPd27taMk5bm0/KPQ4wp3wcXBQii+r1oDJiSuQgGt+ivOM3POiTOkLLaolsP9KHUozQ==
X-Received: by 2002:a05:600c:1da2:b0:43b:c0fa:f9bf with SMTP id 5b1f17b1804b1-43ce6d2d117mr68729855e9.3.1741879134210;
        Thu, 13 Mar 2025 08:18:54 -0700 (PDT)
Received: from [192.168.178.35] ([37.120.43.178])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d188bb81bsm23300605e9.23.2025.03.13.08.18.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 08:18:53 -0700 (PDT)
Message-ID: <63bc72ee-4959-4f08-8db4-2bf6634dc1a6@suse.com>
Date: Thu, 13 Mar 2025 16:15:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] x86/cpufeatures: Add SNP Secure TSC
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064347.13986-1-nikunj@amd.com>
Content-Language: en-US
From: Vaishali Thakkar <vaishali.thakkar@suse.com>
Autocrypt: addr=vaishali.thakkar@suse.com; keydata=
 xsDNBGeOHMwBDACuVdsLLmhsOFjtms7h9Am//KfWX2c8pP0jB9lucUNkga77im/LfKwj+NR1
 FBVU93Ufm71ggzUC1WazE/OZa9pOx7xYGJutIRaA/aWhW+Tr+EnsMf8mxrdgbKN2Q5yCOXJm
 qJo3N7jFdU8wm9qjvqnqmq3waObBDRL4a27MSnBdm2Tjh8jN5Xgt55oXZaAkswfdRKneW/VL
 8RY5fI6NQZ7hrpY7ke3St5Gzpw9/ra12mnMF+LHPTCtn4fCrfoiJfSexE/klGp4da2qlreDd
 qsCHEKQh0B+9Y/OZOpsLT8ifSU3vHqgU0hh37I1scdDsA2cbgaIjrnq/+8PJO7rywL7kUJJD
 eN9X6n6CNpObdT9S+waq/otNaS+O5xwK5zNk8RFTLLdD6051AckLFNHvZKQA3w59/8dCxKNP
 4Bs5L4qGWR57DB19rsG/fhME1kqQvvCqOnvLLmBf8nUYIZH0lkXz1Ba0HOWvLxPIsvZyyIUE
 YYtPcq9/SeBoJdhcMqt1kyEAEQEAAc0sVmFpc2hhbGkgVGhha2thciA8dmFpc2hhbGkudGhh
 a2thckBzdXNlLmNvbT7CwRcEEwEIAEEWIQSZ0luu4I2PpSnupn2b0L6zv+fJ6wUCZ44czAIb
 AwUJCWYBgAULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgAAKCRCb0L6zv+fJ6+M1C/9K7DjJ
 5LZJyCisdI1RmpHNluQlpUq9KWpEYHnnFV66tYr8Y9Snle2iCwKqu5B4tMPkHjRcDP0ySe0L
 1R4hpGqx3GclX74Ajw0oJvOpfAXYp9u+A0bsNSTTxoQSN7r9k8dFee39paYhArvXjSRTFfUg
 kWKNG0dwo6khtSe9+Q7cs7B+9qffmId/w17Z7XkPnquZcFb9PyFbiPoCb7lQ52vXXWPmkldF
 MkySnJUdoLMnACy7rYhY1b27wrGzU63tf5m8tgxBBooDTPU9x0DHV+2MROES2fCu9A8hbFPI
 xuguGKCPQYa5K8wb+9MmXdIX8Rfc8nBstJGmEbI2U5saHj2XGiYG7Jg5t4DjqUY/OObANXue
 Vt6d/CCg/ilvBnTjcJttZk18P7RRSZZG96mkIUNg8xJXRds5Bekvvcc0Ewslw2CHhQb/PzN2
 TLOC28evVr3dCPJGK6AQysaJoEGPx2qPcsC7i1cIqT2QsNjrCbHWjDILDacGp/XAmPuh9aDC
 SsjOwM0EZ44czAEMAMLfIvRlDkNu6lZBHpGLxuZMOZiFAWZIPTrTmOGJKVMJSQuKZXPIqmM7
 rsAKq/zjyaMHaybAK0P7d0wiHg7GgBzvobk01GEut1sLeVkynAltWHZOyUveuyzoQbbGADoX
 kbWbLltND3/y74bet7DrE3QctIxYO+ufGDMiLcfZFqWTbaZK15uXXtKnPKRiZwwW0iQCkQnd
 6AsGy5xx5PaiO6adUR6UbaD+vJKTRA84RDeASsG2izoOpQGN04ezd0nzaJKSDxncqXoqEmDD
 /gTXkWWFxL4JzR+lgSljJWgEDL1AMKPsYgngQljOBXvVpIq5JveHlTPmZ3qCS4v8RVquUtAC
 KEP2lphCOln4thtblHPTIkkBDJj/Ngtf840yHPaiZyvfxgQ5I6X7CPSxUrG+KU7in9adQc1o
 1ftkm64tZ9WL4Ywiqqfj2ZhAWHEG50gNFAfTuaaubC1826gq/63dz9J9CmtFvrL30WO0fB5v
 tkL1wmTEzbT8orFA4s0y3ZS19wARAQABwsD8BBgBCAAmFiEEmdJbruCNj6Up7qZ9m9C+s7/n
 yesFAmeOHMwCGwwFCQlmAYAACgkQm9C+s7/nyeucwwv+OcIc1zryV0geciNIxEfdHUqDrIWC
 9MSJD7vK9fHp/fUCtwxr015GZGa5NvWsbpSW9a/IcYridRFqKWjAXtRoCDOp6k3u8zEThvQW
 1KM+pqsQl1C9c0+iDLmTX2xFhATlJj9UXLDngf/rjNFsjkK/J+GGITCQKu3GRvZEmzx0eEjf
 A5gkX/QLYoU1O0+OWzY31xLmataarOO1W2JOPvY0Xrasxx9wk73sE5ejFsrEqWl61v53eifa
 y7dR0GDj0YqyCrChpwpD1oEPsHzFnvID4pzWDV3ygk10so4yGr6Kw+d5MpqU59wYCrKfXIUL
 Npanrg0h1uBGm2KTg8zaphl/lA7oXyoE3oFvVQzcA8lhGbqGeA4f7jMHeOe7oD+yVmGXh1sr
 1qMGItDswWXZjzovXbKgKVmbBuNJkvLxMbOdG+w4wVFFLYviFz5IIwBDQXkpamfUyfsFCzsh
 8pENixmdxYkl4CAYz8qc1tEY6D3RLspjeE7UIvhuEKM9w9KXlK9t
In-Reply-To: <20250310064347.13986-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 7:43 AM, Nikunj A Dadhania wrote:
> The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
> and RDTSCP instructions, ensuring that the parameters used cannot be
> altered by the hypervisor once the guest is launched. For more details,
> refer to the AMD64 APM Vol 2, Section "Secure TSC".
> 

Hi Nikunj,

Glad to see Secure TSC so close to being enabled upstream.

> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
> ---
>   arch/x86/include/asm/cpufeatures.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 8f8aaf94dc00..68a4d6b4cc11 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -449,6 +449,7 @@
>   #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
>   #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
>   #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
> +#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */

I think it'll be nice to add this as a flag for /proc/cpuinfo. (similar to
"svsm" and "debug_swap"). And regardless, shouldn't it also be added to
tools/arch/x86/include/asm/cpufeatures.h?

Thanks!

>   #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
>   #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
>   #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */


