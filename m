Return-Path: <kvm+bounces-64142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EA29CC7A29F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CDC6B3672D5
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A4E345CC4;
	Fri, 21 Nov 2025 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EeuvzBeh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987EA34DB54
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763735045; cv=none; b=GGaGhT3HgBKLYHQmyZFU2N71r45EsEFVT+w7tCsf42c0llNK6/sSDEH7JoTc+XIEC02T55NBTi9UhzuAVgV72LPAqs6NoT1ZpgRSy3FNMnrWmLUhp1QIOIKD/mGJGb9IIcORKNFMoeIBo1sWxb0lsBFGv0XgSkULjTwg5IyWMmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763735045; c=relaxed/simple;
	bh=YIxXEq1Wrr3cuWLRtmh8tL1Uhv5SxGHX+umFKagy9j4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDSIhRGT6LE772cJ6v7WOpnormSt8n5d1+jzBQ1FMIjcPJ/L6JahquPpee0AHQOE1IQ0Htmxj2SCQQEjjMnUkQdRZ0bZmk+/iFxKW+FiXAw9zdKjqyBOyhjgqeb0YFCOmlbcy1QT7sYdKntGCVypW91/i6rj6uUOvsmZ3ysXVTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EeuvzBeh; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b472842981fso262432566b.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763735039; x=1764339839; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=t881KxFUzRujLjhV9ZX3kz66RFHsd4YsmBuH4axVx8A=;
        b=EeuvzBeh9+Tz7YjBTGQibpVKy/Keqhfs6IcY0aymBbpFxoLFMug+GAtxuabbFLyYlG
         Gofz5tSC/8sGuq7KJHeTqwKHWUGTzdHysm8ONRS542zmHqj2khOP011GuQcy41xIyh0p
         SoBoq/Rjx4YxmXVdM804NQQR1yfEyfV5Z2SBDcyUnDqtIINRR3nEwqDAgsOA0lnqin0t
         f+clr/rFtTvjQfw0SHbrjXpdvC4fbXjH+hUW/m4rdb+Y7pWjIyyQOvqVlwQm6QYA9jmp
         dJgCYAk7mad5I6DkaoD9/ezb3htBHXye4iC/lmEs9mQQ/8JVah4HL9Qx/K1ndj3LdghK
         uD9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763735039; x=1764339839;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t881KxFUzRujLjhV9ZX3kz66RFHsd4YsmBuH4axVx8A=;
        b=BssHFwdsHYRPjqsH2/DzUgFY3AFzNzvOVlRE3HfY9LkxDj6A+VY9vhyVQdTMAKeCQZ
         SgY5hjU6YjFHmPcg8U6nkGJZTXTdNLvPJ9tA0oTXoXd8/4/qGnuLuhk6i0nS2HTmpG0K
         Rq0t8dmSOZfxgwikCD6trWuUPwUIbTeCXlwaX9kD47kZkKuu+GcqbLBjeVPOJwZCKWBW
         3U2bNzN8zEvSDMJmAcV3wgKDuFPAzJYEAlWg8hCTR4yQXk3nHVMkcUY9T3Njf2svLvB3
         01m+Uha/qeQLq8fcvu8zzfLOkq4hz/jkscg/O3m9p7XrOMr101//cXMTaxn0vc5LFD2n
         R69w==
X-Forwarded-Encrypted: i=1; AJvYcCXx5TjCp0gScoTb98t5KnxknTBgBLV36+g1wBh9Tc1iZxKlU9Yvnf6NmQ9yTxdYVCJJ0WM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4+a1d4BYUtjg7NiFP84OonAjE+h4q0WLjzEDOCMeFowrKXyCM
	E2VUmpJfbwi81IvMZSMFytFa2fczyNNN11vip+VYO34lhwimabJSWaG9wwhMcgo2kDk=
X-Gm-Gg: ASbGncupHNK8E4ndyxF6H1HJMhO9ONjcvN20Geo6DesLgC/yfa2dRZ9Sz8WgpdBT6az
	cXbBbpXlz+qhRClYkaH9IGgBxFGU6r1txJvlz5SaV2fRlFtYAWeP37ZEdKeNgyyoyoJJ/yDeebn
	oyDYfNxXY2K4iTj7kDzKRKccx4SDzgeuRPooELjWSEgUqreWohxGCQuOfdPdHZxiZ7ZskQl1n7V
	qvSIRgoaM/ZU4bIWSES+1RhOBxSd7s3inCQUpbuCOKNcm9B/IoOi6yCaM554xoLelHaQ6vQNGQf
	T15fhfjyZ/LmaAtfSbRpzsfD+Z3EWMDEpsU7yd0UFZk+xRWqA1zr6iEe7K5zcUYPRXt0vdtcdNe
	ZO2u3GPeFOFXu/myPzHuZTTBH0zRDFrF+sZiFUlF4Xt55isDcNBVIngY3g2LbuJfh5p1vGVNY1r
	HC16O1X9RPSYNimf49kQ0eSOGqLMWZDaQ9fJe/
X-Google-Smtp-Source: AGHT+IE3CLLWZAmaYSIyhcCfzmFZQ3sVyDULm2d/taqCcr54KN900XlExdWFp9wysaVm9ZHoED20Kw==
X-Received: by 2002:a17:907:2da8:b0:b72:d8da:7aac with SMTP id a640c23a62f3a-b7671a2a2f4mr258262666b.56.1763735038756;
        Fri, 21 Nov 2025 06:23:58 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654d502cfsm469617166b.19.2025.11.21.06.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 06:23:58 -0800 (PST)
Message-ID: <5cdca004-5228-4f07-b9b8-901880f59bb7@suse.com>
Date: Fri, 21 Nov 2025 16:23:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/11] x86/vmscape: Deploy BHB clearing mitigation
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-9-1adad4e69ddc@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251119-vmscape-bhb-v4-9-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:19, Pawan Gupta wrote:
> IBPB mitigation for VMSCAPE is an overkill on CPUs that are only affected
> by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> indirect branch isolation between guest and host userspace. However, branch
> history from guest may also influence the indirect branches in host
> userspace.
> 
> To mitigate the BHI aspect, use clear_bhb_loop().
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>   Documentation/admin-guide/hw-vuln/vmscape.rst |  4 ++++
>   arch/x86/include/asm/nospec-branch.h          |  2 ++
>   arch/x86/kernel/cpu/bugs.c                    | 30 ++++++++++++++++++++-------
>   3 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst b/Documentation/admin-guide/hw-vuln/vmscape.rst
> index d9b9a2b6c114c05a7325e5f3c9d42129339b870b..dc63a0bac03d43d1e295de0791dd6497d101f986 100644
> --- a/Documentation/admin-guide/hw-vuln/vmscape.rst
> +++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
> @@ -86,6 +86,10 @@ The possible values in this file are:
>      run a potentially malicious guest and issues an IBPB before the first
>      exit to userspace after VM-exit.
>   
> + * 'Mitigation: Clear BHB before exit to userspace':
> +
> +   As above, conditional BHB clearing mitigation is enabled.
> +
>    * 'Mitigation: IBPB on VMEXIT':
>   
>      IBPB is issued on every VM-exit. This occurs when other mitigations like
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 15a2fa8f2f48a066e102263513eff9537ac1d25f..1e8c26c37dbed4256b35101fb41c0e1eb6ef9272 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -388,6 +388,8 @@ extern void write_ibpb(void);
>   
>   #ifdef CONFIG_X86_64
>   extern void clear_bhb_loop(void);
> +#else
> +static inline void clear_bhb_loop(void) {}
>   #endif
>   
>   extern void (*x86_return_thunk)(void);
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index cbb3341b9a19f835738eda7226323d88b7e41e52..d12c07ccf59479ecf590935607394492c988b2ff 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -109,9 +109,8 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
>   EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
>   
>   /*
> - * Set when the CPU has run a potentially malicious guest. An IBPB will
> - * be needed to before running userspace. That IBPB will flush the branch
> - * predictor content.
> + * Set when the CPU has run a potentially malicious guest. Indicates that a
> + * branch predictor flush is needed before running userspace.
>    */
>   DEFINE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
>   EXPORT_PER_CPU_SYMBOL_GPL(x86_predictor_flush_exit_to_user);
> @@ -3200,13 +3199,15 @@ enum vmscape_mitigations {
>   	VMSCAPE_MITIGATION_AUTO,
>   	VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
>   	VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
> +	VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
>   };
>   
>   static const char * const vmscape_strings[] = {
> -	[VMSCAPE_MITIGATION_NONE]		= "Vulnerable",
> +	[VMSCAPE_MITIGATION_NONE]			= "Vulnerable",
>   	/* [VMSCAPE_MITIGATION_AUTO] */
> -	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]	= "Mitigation: IBPB before exit to userspace",
> -	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT",
> +	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]		= "Mitigation: IBPB before exit to userspace",
> +	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]		= "Mitigation: IBPB on VMEXIT",
> +	[VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]	= "Mitigation: Clear BHB before exit to userspace",
>   };
>   
>   static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
> @@ -3253,8 +3254,19 @@ static void __init vmscape_select_mitigation(void)
>   			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
>   		break;
>   
> +	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
> +		if (!boot_cpu_has(X86_FEATURE_BHI_CTRL))
> +			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> +		break;

Am I missing something or this case can never execute because 
VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER is only ever set if mitigation 
is VMSCAPE_MITIGATION_AUTO in the below branch? Perhaps just remove it? 
This just shows how confusing the logic for choosing the mitigations has 
become....



>   	case VMSCAPE_MITIGATION_AUTO:
> -		if (boot_cpu_has(X86_FEATURE_IBPB))
> +		/*
> +		 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
> +		 * clear sequence. These CPUs are only vulnerable to the BHI variant
> +		 * of the VMSCAPE attack and does not require an IBPB flush.
> +		 */
> +		if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
> +			vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
> +		else if (boot_cpu_has(X86_FEATURE_IBPB))
>   			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
>   		else
>   			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;


<snip>


