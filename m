Return-Path: <kvm+bounces-63189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64316C5C1F3
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 10:00:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D8673B13AC
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89ACC2FFDDF;
	Fri, 14 Nov 2025 09:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="G1LVtE6C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41E62F6569
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 08:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763110799; cv=none; b=CcWPIAVUVSR4BdM6FcNmq0HtTci/ms36fw3gzQVQDikTlu7wnqxNQxa/bZIxoR1ETzcrYaxtUQ59l1KqXwv2Y5Nqh+1QgRhW3ynYOKG1YgE4XT+YG4dpSYT7D3KH6UYjJy6cmBHLSLWNyf0Q3bktTb7kfbPmJvZpkjXLxDEsRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763110799; c=relaxed/simple;
	bh=f8QN2qi1ZlBA15TCv74bDKURL4tdENc7srx1X0+sS8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YuVzjEJ9clorGM8x7qGo1ubhxaC34VIMwIjvQ8SJyjUuh7aq5ePhHXLppNXToClFxDS7KFDnVvfhkzP7taK5l2FAU/SlApZAe7wpxvkO29mG2z3j5XsHmJwfaFkf9NTcbYLXuyKQW+QrLV9WP3Zitq0XTxIygmw/kl+KrKoAQtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=G1LVtE6C; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed66b5abf7so31489121cf.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763110796; x=1763715596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RT2/0L/Ubdu9wWBOe5CQHX3vnzSuSAeQpmSs569krdE=;
        b=G1LVtE6CcRXDE8E6qdimjr59CLTHK5XQ27ees5W5RIK8SPGkBjHzckoG/0l1tsgVzx
         HKpVv5llniNsocbnqlCluT4/pHsSCHIb0oUATWEZO9UK79WKuv8XUP5SG7jF7Rhhcvz/
         2CsEbr7Ng2F76k+HVGjRUnWcrnpMcyuBYhLZfJzLo7NWHxbOFBlexAUfkEYTDjb2p7ji
         l20pzctDjJFiMfbzMCbAAwiOddvEkJeow7b/u7QC+8Yh7a6TQH6BzhD6l1TukcNdJY8s
         rwRr70NPg0+cXxdCH0DIDN27i3vYLQRM51qVO+cQhqzCp7g6POBN8Vk0SUbpSPwkxE0R
         dMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763110796; x=1763715596;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RT2/0L/Ubdu9wWBOe5CQHX3vnzSuSAeQpmSs569krdE=;
        b=aNiu7uvRR79BC14nUPuCy9JSevxzdfgbg/FVoUM47fomzsc79zPuW3jhlaAJxd60pC
         raH+e5DkP/VDrAR6RLXRgSUoc+V9vZahhNwj8oigzYyFghQfDrw/O7Ah7Y4RgtQ1yvWP
         KzLL930QpSEuJI7LoQ5yToJlWsVF6Vc9UJ2pVauQgv6ZYrKS2bKN3GEfM4aibLWoxyZ3
         IhWBsuyWwscD8HulTYMw40cv/j2OzCN8Lw7C6BZkCBJw0KHKWMaBOhj7FjCfx9KoKNj2
         q6iaVag9/TGMO4FhMyVvZBSstxc6VeJVH+CJvYDNXKdXjRoIMhh0bYeHVa+q5baHRHyt
         2uWA==
X-Gm-Message-State: AOJu0YzrxArD9xLhth6H2/8mlG9oR5PUv3xOFxPTfZY3bhPw4ue8b96n
	TPkSLJGPP7zy4FllR9RvlUVCjQzk4AnTvz3CSHrOBwJw2opmp9JbaLBqhaMa8ry7yCo=
X-Gm-Gg: ASbGncu+u14v5/L1c6aPmhvkunmw/9p//VltZt3ieD4ZXtb3dVIVgH7D2xWO8xj5BRC
	XS1rQedPMVhoiWS8pQThuhfNWGZjW7NULhspKR4Pn0QAuWRhWd+WqZfAX/pTeFDk7sbZi016KEq
	nQTr9AasU5jpp38I4rpnYj68i77nnRbdT7pj2Ig9S8rUkJZM/M6+dzHRKXx8AdOSGLF3hWGhQfa
	LATcYDKUM0YrBCS3ZIvvST7JrYzr4baKe4fMczSXzFvOBFA6LADwDKTgo4326em419xldn6V1oP
	K3DVH133ZCx3N6TNTzzYNzT1coCea7j+1NZZptOrwuE1LoGd3kdpNNzfCWB7I1Ma0dSQn5BTU1W
	j4Il+8d/W0zfEJU58jxdDbGLofpFH3l8sRwLSuv7i+keLlCr0zIFdKaVH0O9JpasSVRVs1Aa7y5
	mjr1BRDBvc/PGQ9/uP+Jq790CZFwtf2I3yWcmRSB2drredmLD2i8hLrdJxRwHe/trnaMhKPmHcP
	M8iO2o66EBpvRUM4GDjGiHE3uJot4JptU8=
X-Google-Smtp-Source: AGHT+IGty73AwBBfirp3HEL/1fIA6AdDg92NXbUl1OQ1Pud+/vkQQ7l0j5MCAG86unmyRPnlvZnu0Q==
X-Received: by 2002:a05:622a:52:b0:4ed:806c:69e2 with SMTP id d75a77b69052e-4ede6fa953bmr74969351cf.7.1763110796528;
        Fri, 14 Nov 2025 00:59:56 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ede881ac9esm25114321cf.27.2025.11.14.00.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 00:59:56 -0800 (PST)
Message-ID: <e3a82783-efff-445f-bc79-99e7ee7d34d5@grsecurity.net>
Date: Fri, 14 Nov 2025 09:59:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 15/17] x86/cet: Run SHSTK and IBT tests
 as appropriate if either feature is supported
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114001258.1717007-1-seanjc@google.com>
 <20251114001258.1717007-16-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20251114001258.1717007-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 01:12, Sean Christopherson wrote:
> Run the SHSTK and IBT tests if their respective feature is supported, as
> nothing in the architecture requires both features to be supported.
> Decoupling the two features allows running the SHSTK test on AMD CPUs,
> which support SHSTK but not IBT.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/cet.c | 50 +++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/x86/cet.c b/x86/cet.c
> index eeab5901..26cd1c9b 100644
> --- a/x86/cet.c
> +++ b/x86/cet.c
> @@ -85,7 +85,7 @@ static uint64_t cet_ibt_func(void)
>  #define ENABLE_SHSTK_BIT 0x1
>  #define ENABLE_IBT_BIT   0x4
>  
> -int main(int ac, char **av)
> +static void test_shstk(void)
>  {
>  	char *shstk_virt;
>  	unsigned long shstk_phys;
> @@ -94,17 +94,10 @@ int main(int ac, char **av)
>  	bool rvc;
>  
>  	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
> -		report_skip("SHSTK not enabled");
> -		return report_summary();
> +		report_skip("SHSTK not supported");
> +		return;
>  	}
>  
> -	if (!this_cpu_has(X86_FEATURE_IBT)) {
> -		report_skip("IBT not enabled");
> -		return report_summary();
> -	}
> -
> -	setup_vm();
> -
>  	/* Allocate one page for shadow-stack. */
>  	shstk_virt = alloc_vpage();
>  	shstk_phys = (unsigned long)virt_to_phys(alloc_page());
> @@ -124,9 +117,6 @@ int main(int ac, char **av)
>  	/* Store shadow-stack pointer. */
>  	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
>  
> -	/* Enable CET master control bit in CR4. */
> -	write_cr4(read_cr4() | X86_CR4_CET);
> -
>  	printf("Unit tests for CET user mode...\n");
>  	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
>  	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
> @@ -136,19 +126,45 @@ int main(int ac, char **av)
>  	report(rvc && exception_error_code() == CP_ERR_FAR_RET,
>  	       "FAR RET shadow-stack protection test");
>  
> +	/* SSP should be 4-Byte aligned */
> +	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
> +	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
> +}
> +
> +static void test_ibt(void)
> +{
> +	bool rvc;
> +
> +	if (!this_cpu_has(X86_FEATURE_IBT)) {
> +		report_skip("IBT not supported");
> +		return;
> +	}
> +
>  	/* Enable indirect-branch tracking */
>  	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
>  
>  	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
>  	report(rvc && exception_error_code() == CP_ERR_ENDBR,
>  	       "Indirect-branch tracking test");
> +}
> +
> +int main(int ac, char **av)
> +{
> +	if (!this_cpu_has(X86_FEATURE_SHSTK) && !this_cpu_has(X86_FEATURE_IBT)) {
> +		report_skip("No CET features supported");
> +		return report_summary();
> +	}
> +
> +	setup_vm();
> +
> +	/* Enable CET global control bit in CR4. */
> +	write_cr4(read_cr4() | X86_CR4_CET);
> +
> +	test_shstk();
> +	test_ibt();
>  
>  	write_cr4(read_cr4() & ~X86_CR4_CET);
>  	wrmsr(MSR_IA32_U_CET, 0);
>  
> -	/* SSP should be 4-Byte aligned */
> -	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
> -	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
> -
>  	return report_summary();
>  }

Looks good to me!

Successfully tested on Intel ADL, selectively disabling IBT (-cpu
host,-ibt), shadow stacks (-cpu host,-shstk) or both (-cpu
host,-ibt,-shstk), each doing "The Right Thing," therefore:

Reviewed-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>

Thanks,
Mathias

