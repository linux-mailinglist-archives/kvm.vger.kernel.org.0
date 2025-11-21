Return-Path: <kvm+bounces-64145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C07C7A333
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6D8AA362A2D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAC234F26F;
	Fri, 21 Nov 2025 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FJfReBze"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB3C34E76E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763735230; cv=none; b=Hlvnraf3186j1JtvROKusSdZLllsVc0OE5dVsT/d5eaKqSiVJ4IrGsoMjSbQeiOnlGda2Vll/VdB8pmYa0RVt5sUbfr6TtEDNxXoWqcJHVgi77hCPQmqoTukXNLbFK3mybDXQ5p9pL7PWuOvQFqCEkUEeA+7T3bqKVLG52KHdSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763735230; c=relaxed/simple;
	bh=qPMrK+rk+XwTygt2H6To4pOjPYjqzyqk4bZptS9Yjqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iAmDeTNqMk7+hM9iL6+uWuZ8kCsyQvaH0OpXZkDrHr9bbeDxo57Wt2ijKXjgzql2orBk8SvZx7XlHcerB8PUEDDMXaPvfIBUd4rHWQ4O1vzS6TnwIloB17ILw/qUF5YVM6FMXg/sB4RgWQtaRNYcVEPzg3HIQElLcWB2s/toB8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FJfReBze; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b736ffc531fso310572866b.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 06:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763735227; x=1764340027; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8OzFM3E3+mURGYLN/FfH5S6zddEzct5iHVH1JcGFjyA=;
        b=FJfReBzeabV5GBYIaNYk7iosWXkYgjHmJtuHJUE3x9ELXVHgWADgtD9OZ5dcdx/WJG
         DbobM+P7W6STEsbUZMcKqYingIl0F7xR6YX5yMCQghiw/lsXhf0+y7Ss3oKDNEJgkqiD
         TlnkXgx1MN7wte64VkHAaeaoaABszLF7zW/Jn4Z7jd9P7FOo8F3mRNDQSKwqgGLZDSYy
         miq36Gm1hwMNa+oLZSLDlQeQ7kTjeaJyOUBdr1IzVpqQmGjgBu7EsTKSidWL0uyHIflF
         /z9P1jDUYtvaypkNPpei1hi8vojb5EhFX7kD+I5tH43av/lWwCRpiV9536jTCYYy4Xlu
         U6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763735227; x=1764340027;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OzFM3E3+mURGYLN/FfH5S6zddEzct5iHVH1JcGFjyA=;
        b=oNL+yazo/LDvWw7jcReZTGPDa4G8kwdvUtZX9SHqpB/hUz0rxgTfn/sP3f9XITJNk3
         II0NivJNcJoSPkJS7TwiX4p3nd8sb2j3A/GsXXLdTKRp7M/K1UHkn/0GGYkh3JSxXxGX
         Mrp4VLsFGWuB9QZ3DjkRiif6X3y2P9ZZrQvV6VsAO2DvruhwyNlhPR4eJCqVmmbJos6y
         VKAFU0ubwNc55ZlC7Hii9hoA7vY1wiZKWCmBlrBwyBDzalWEGz/FL/XGp78PmJLf4GRh
         RrF+NL+akUpbVChzIhlWHeAPHEQASP6ZX2QiJ2y2agEoVnAQYwg2NMpWWAu39MQ/bOoi
         sR4A==
X-Forwarded-Encrypted: i=1; AJvYcCUrEy6B2YWo/IjsPDITEwk57FdOiLsfzWbstc1O/8L+3YcXmzPqYGjbJ5AwpAP1Wh/xFHs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXWIYeZYi5P5m8miypByqRLXeitRYQg3AORLYDERs/VUP3XcKF
	Aw6WbZ5mtf/GJvMALzYgvhEG+CTts4ttjwXsQLmzVATMgYcU5lLmr9OERzZHcjOyomg=
X-Gm-Gg: ASbGncu4HdO8qsllWYTy4/vc13qj8vQN57OxIQrVcO2o6oEtCszokUvtqbjvyB4NdSc
	BdSczLtlP4X/LlITU3dO/PWcjDOR3kOl8pp79akWj4y4a8TBgFwzhakrUTg52zaVebz3EqF/Btr
	2KYJu75pfpTTq5ntoNCxMErfcWrKoIlxUDpHAsrbBNFGnyNTQViwtxgs0Oae1hex773bYcQmmji
	WzcYu0EO1r/TuyW34NMxy2EbQxXWlfZqE72PaJWoGiLj8zIYqSGbWfaR70/K8UPdrMukcSe9b2Y
	RD/BRx+s7u/+LbkQ5yckKsgYsVq4c/PJ5iQwmSF78m7M3uf+7QINN4gTfsG2w9oT6Qi1upZbk26
	EwEakV/DT7b0Z7v9hjYt94uFVSELckwvaWyu9a02UzQikVoxN6+MBiOxL+rhevMCLC5EbNzxDT4
	kzZQFDBJdJt0Fos0HqAWSjPvN8kU5WESH3Ii3rhqXbdYE9ufA=
X-Google-Smtp-Source: AGHT+IF8TqotYSI4c/9fHV9nLsepKGssoWDg1LXWbHmTpCK39BMbp3yQfyXqaiRwZ1+tXZ7NloQmrQ==
X-Received: by 2002:a17:907:97d0:b0:b73:6b85:1a8f with SMTP id a640c23a62f3a-b767170ae15mr267413466b.49.1763735227097;
        Fri, 21 Nov 2025 06:27:07 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363ac996sm4573185a12.7.2025.11.21.06.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 06:27:06 -0800 (PST)
Message-ID: <c8d197cb-bd8d-42b0-a32b-8d8f77c96567@suse.com>
Date: Fri, 21 Nov 2025 16:27:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/11] x86/vmscape: Move mitigation selection to a
 switch()
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-6-1adad4e69ddc@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251119-vmscape-bhb-v4-6-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:19, Pawan Gupta wrote:
> This ensures that all mitigation modes are explicitly handled, while
> keeping the mitigation selection for each mode together. This also prepares
> for adding BHB-clearing mitigation mode for VMSCAPE.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>   arch/x86/kernel/cpu/bugs.c | 22 ++++++++++++++++++----
>   1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 1e9b11198db0fe2483bd17b1327bcfd44a2c1dbf..233594ede19bf971c999f4d3cc0f6f213002c16c 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -3231,17 +3231,31 @@ early_param("vmscape", vmscape_parse_cmdline);
>   
>   static void __init vmscape_select_mitigation(void)
>   {
> -	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
> -	    !boot_cpu_has(X86_FEATURE_IBPB)) {
> +	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
>   		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
>   		return;
>   	}
>   
> -	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
> -		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
> +	if ((vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) &&
> +	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
> +		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> +
> +	switch (vmscape_mitigation) {
> +	case VMSCAPE_MITIGATION_NONE:
> +		break;
> +
> +	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
> +	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
> +		if (!boot_cpu_has(X86_FEATURE_IBPB))
> +			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> +		break;
> +
> +	case VMSCAPE_MITIGATION_AUTO:
> +		if (boot_cpu_has(X86_FEATURE_IBPB))
>   			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;


IMO this patch is a net-negative because as per my reply to patch 9 you 
have effectively a dead branch:

The clear BHB_CLEAR_USER one, however it turns out you have yet another 
one: VMSCAPE_MITIGATION_IBPB_ON_VMEXIT as it's only ever set in 
vmscape_update_mitigation() which executes after '_select()' as well and 
additionally you duplicate the FEATURE_IBPB check.

So I think either dropping it or removing the superfluous branches is in 
order.

>   		else
>   			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> +		break;
>   	}
>   }
>   
> 


