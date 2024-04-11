Return-Path: <kvm+bounces-14229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 460E48A0B89
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 10:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65C961C20E90
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 08:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABC5140394;
	Thu, 11 Apr 2024 08:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="jvKLLlyy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4611413CAA2
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 08:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712824990; cv=none; b=P7+a5fnsIUTIendWt9hEfla/gmlc2EFpboYjNLjDnbpdyr33zisLMHmg6jeoWKHaHufFMmmcW+XAb8pBSmaaRfHxkgWgsei/P48jzYhYytJDIq/J0C7XtwZ8+u5D7zxPGNzAOXHqSpTr6H9+X/pVtxAOoOz2Gcl1vECCJxt/aPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712824990; c=relaxed/simple;
	bh=rFnbY6the2DTWFxqzWAWtQZuwY6LG4HwFJznztvQg34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aCKrfgCjUyA6kvlvheWVMLIAWC6eoCzo7LGNxVg+rhoRXIY/2J7sbekkcyvr4/b52ZIrJkocvaCgkBPlxbpehkFvD39wJR2BsvRbuVb8iiQ9Y0rjF/qrBpYH3q8Q9Gf0SIwc5cI7P83hXmKYZwB5+aaODbGiFdyCx8+PpIbE+ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=jvKLLlyy; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-344047ac7e4so353130f8f.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 01:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1712824986; x=1713429786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0Lvrzy6gsavLoDn3zewsR3l1JDkSncM7fI8dzkelxIo=;
        b=jvKLLlyyHphQ25WDhJSDv5Oc/4VUi5WPWl8712/+0hCu8iShkFGQGpmzy/8wmbBCOF
         UKIF1bM3mMZFqiZrfiIgZxdOBZDODhxPqjq+GGLUIwpyqzRN1R4EjX84Q7Y/nDaoPLa4
         OjawMbdi91/JYJunfHuCQiV0Bg2NFdHVuXsVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712824986; x=1713429786;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Lvrzy6gsavLoDn3zewsR3l1JDkSncM7fI8dzkelxIo=;
        b=VbB1l9asnoFijor9dw6nuTckbvnNfsme1I9dyihQ8DfOGFz0ei+5q8/MS5EgVKQeRo
         9a8YiaOr/Bwq43OpwTd14JjaMWXxWZcMLS3AqfY+srpjs/lLhj02XQ3KaBOwL4VRHt3O
         WtwmfggmVi3Fi9Cku2U9EvCfYGNI2FGz2dx4hIt8sofsENj6bbT0aNCedbz5j/88kdL9
         mYXv9X54C5H4MoTLhLmurbABgsbPDRMBSgapd79zJWW2BQs3n48pEEmRmdkuKQybVhPt
         JQU1E/O6BUFT0Ed8qPZKWKMebw9ulsLJWa3aW7J3pGhVSvmbojpOpGSKRESpdonnkpCk
         +D8A==
X-Forwarded-Encrypted: i=1; AJvYcCWOR3zBTx1WoCb/sSSc95HIsZhQrR5OM/SXoL9G8ASGHbjqz+ZqhT8RTGVBPUuElOD3yfY93UrMMtPbC6oCLqrPNBPW
X-Gm-Message-State: AOJu0YztxR1WWGZHW7BfRqfqRqbby3Fwq8Bqd5PJkS6wocMPnfxXQ527
	jCwbSzsAjqojUpX/9XbSYOKyz1koRyqiVvxFIozIRsl73wksU2XcgXJFYtsY6zk=
X-Google-Smtp-Source: AGHT+IHg6r4Nu48iUIY9mqggSJ51l+wAjek6iP5pLQCoBO8qkh2HNS3T+3YcH8NVO0akPaYU8J2LdA==
X-Received: by 2002:a5d:588b:0:b0:33e:c91b:9083 with SMTP id n11-20020a5d588b000000b0033ec91b9083mr1765564wrf.16.1712824986611;
        Thu, 11 Apr 2024 01:43:06 -0700 (PDT)
Received: from [192.168.1.10] (host-92-3-248-192.as13285.net. [92.3.248.192])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d660e000000b003433a379a51sm1223176wru.101.2024.04.11.01.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 01:43:06 -0700 (PDT)
Message-ID: <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
Date: Thu, 11 Apr 2024 09:43:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>, x86@kernel.org,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, gregkh@linuxfoundation.org,
 seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
 kpsingh@kernel.org, longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <20240411072445.522731-1-alexandre.chartre@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/04/2024 8:24 am, Alexandre Chartre wrote:
> When a system is not affected by the BHI bug then KVM should
> configure guests with BHI_NO to ensure they won't enable any
> BHI mitigation.
>
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 984ea2089efc..f43d3c15a6b7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1678,6 +1678,9 @@ static u64 kvm_get_arch_capabilities(void)
>  	if (!boot_cpu_has_bug(X86_BUG_GDS) || gds_ucode_mitigated())
>  		data |= ARCH_CAP_GDS_NO;
>  
> +	if (!boot_cpu_has_bug(X86_BUG_BHI))
> +		data |= ARCH_CAP_BHI_NO;

This isn't true or safe.

Linux only sets X86_BUG_BHI on a subset of affected parts.

Skylake for example *is* affected by BHI.  It's just that existing
mitigations are believed to suffice to mitigate BHI too.

"you happen to be safe if you're doing something else too" doesn't
remotely have the same meaning as "hardware doesn't have a history based
predictor".

~Andrew

