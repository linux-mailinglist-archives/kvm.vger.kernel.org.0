Return-Path: <kvm+bounces-65653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED57CB2E52
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 13:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5850A300BA00
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 12:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37473233F4;
	Wed, 10 Dec 2025 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A1rVkAK6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797B81F3BA2
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 12:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765369897; cv=none; b=NwdbyTrf1BOtu0/h2PwNi+5c45UIuuqJnqWce2+NHOj1tlZGL4ceLLhVR0fhbJPRwtAZrr8Vy5fUOtukLat7ExGJRSUBBJbp1L3L2Mh1CsQdb6DhM4wh4KOjxsNmN30f9TWgT/ed43FFa0nUgNSTIvTm3JKBOUVqvh1aeQrkpuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765369897; c=relaxed/simple;
	bh=EnxQ7+j7c0/T9vlpjPn2CKwVrPO89szqVESVHadPlL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eQ7N8oWUsrlnpclNXft0LEMwTJuTvRUh9rabW3MmrDZevNZ8rGd81e6puTqH82i3uJVqMLNdxs7n1eWb0kooRqB+aD6YelxZ+geeo164jYH2ITFZiH0xzYzwWK3nByWqUe2U3A+cZSprK7qLCGglH9CgYAuH9A+UTX2wzK1q1LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A1rVkAK6; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so12038845a12.0
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 04:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765369894; x=1765974694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eVr/YoB9YqZwfyTNCf6R5H8DydHWbJpQ1eeeaAEh2UE=;
        b=A1rVkAK67MNjjAWT3NkGZJESxAa6kYG8r0sXjyRbvtlytcP24ujNe4ZdVgm7IjH4Eq
         BCm/YD7FLWssR3ybKMXRtJTssyP8Wj5XVVqdIkvz4eo/y0AYAFZX5PEvJ6V/SgAA/Azd
         qRbayEEBxBw1RDiIPieJYvjkdAA54FO/p+g61B97yxZIMbxK1AvsbHoEEktwZYhsCxPn
         pN6kaKnGwvYTP1AoMbttGzRSGVe9d0SW3ljyLFRjvLZikjYrGnCCgnPx8nooGNZEnRij
         Fzqg3BWSyS8IUhOVseB8wYkuEILDtqJ1ZCUOZLg/JeZ+eFHg3WyBeBLHXR1UCoz99+MC
         zgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765369894; x=1765974694;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVr/YoB9YqZwfyTNCf6R5H8DydHWbJpQ1eeeaAEh2UE=;
        b=s2cttQdhEPs4CsFUmvbv9sA7YWd6kMSFrwLrqSXSkiG5ON2lElpwxGQSs5Q4XPQu05
         gjZ9vKcLkhw439sJUC7xALnNq4AKTcz6MaLNkFHWbfNL8gnxX/jb5IBVq95z03TEfffV
         NqJJBVDMlmSD3sY76ar2e44mtSbTFrFeuo/rpTbBVfjvfutB1A3wL3SxEnf9BGWNRZon
         1HnjQUsUZTTEAKESCgfX/d+/tUFahdaKHKHVDNDtWtlw0steTO+A4MFtA5veKsI0mQqc
         B++9kDzMVsboPJv15eux0cuRtj+HRwD+wwehilYhy5XXPsfX+FJT0WhN/NH7xPnEOmmm
         KgIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ4bq+rDxndGcV432/Zn/yHiGAOSaLS1Wz1l/ECtZnMfD+oFCxSyzl+NVBmlj2f3bQjDI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgz4QRmCieeoNvamjngrKylwtXfXGECSC8cYUi6ZMporkWO4VC
	sjyi1XGIV+wnR+BQjjwHu/s4RiZQ8VeN3p7uKrxXSRutV9KETd2Gnzy4zlNS9/O1XZc=
X-Gm-Gg: AY/fxX4/yZ1ciEYVAyDfrNijCjBW97e+Ubln/OFkcklppcFANwPEhF2ecmnXWqRaeMO
	CWGgesExjBmFCEhuDJx9SpQckKqYnaSj5h0kd7cdGVtUbHMqwP0pItXRBbbeYHxaQFP4dO2uSt9
	qY3m34yzA4xi4GNIb9vLEOt2dSh9F28lGq9mMKu1eqK/e/Fi/n68Rcs9lqMuIiKliCEC3YBcCf3
	Gy8A0lApOjIwe+Am2sU5bJQnVc8sM4oUQ6lC63o7W6fcvIO+SMXVm16VptFMmi6SkpQFkpJteWv
	OeIJVr65y4XGp2wpTY5bt8jwCLPNJj6JUEPFHYkkmEKlI43RFE6DMz3UCwJ5cdxEE57Z6mDR0dP
	KunlEe/V5UsMXKmiQVjDFGtZMAkuY+mUibyjSYhlPgOJ3vKMxRmshiucYHqhGZjAftAiuN3SQB9
	foSPHjMPYmC+1Fhg==
X-Google-Smtp-Source: AGHT+IHLw3qSVktTGwEHIgnTe7O2rSBAPhtt5q8MfURnABHy8XYIpIgwk83c2V039BPtulBr4rfgHw==
X-Received: by 2002:a05:6402:1941:b0:640:c8b7:f2bd with SMTP id 4fb4d7f45d1cf-6496cbe463emr1811758a12.29.1765369893790;
        Wed, 10 Dec 2025 04:31:33 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b412146bsm16725327a12.23.2025.12.10.04.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 04:31:33 -0800 (PST)
Message-ID: <fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
Date: Wed, 10 Dec 2025 14:31:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] x86/bhi: Make clear_bhb_loop() effective on newer
 CPUs
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, Nikolay Borisov <nik.borisov@suse.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.12.25 г. 8:19 ч., Pawan Gupta wrote:
> As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
> the Branch History Buffer (BHB). On Alder Lake and newer parts this
> sequence is not sufficient because it doesn't clear enough entries. This
> was not an issue because these CPUs have a hardware control (BHI_DIS_S)
> that mitigates BHI in kernel.
> 
> BHI variant of VMSCAPE requires isolating branch history between guests and
> userspace. Note that there is no equivalent hardware control for userspace.
> To effectively isolate branch history on newer CPUs, clear_bhb_loop()
> should execute sufficient number of branches to clear a larger BHB.
> 
> Dynamically set the loop count of clear_bhb_loop() such that it is
> effective on newer CPUs too. Use the hardware control enumeration
> X86_FEATURE_BHI_CTRL to select the appropriate loop count.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

nit: My RB tag is incorrect, while I did agree with Dave's suggestion to 
have global variables for the loop counts I haven't' really seen the 
code so I couldn't have given my RB on something which I haven't seen 
but did agree with in principle.

Now that I have seen the code I'm willing to give my :

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> ---
>   arch/x86/entry/entry_64.S | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 886f86790b4467347031bc27d3d761d5cc286da1..9f6f4a7c5baf1fe4e3ab18b11e25e2fbcc77489d 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1536,7 +1536,11 @@ SYM_FUNC_START(clear_bhb_loop)
>   	ANNOTATE_NOENDBR
>   	push	%rbp
>   	mov	%rsp, %rbp
> -	movl	$5, %ecx
> +
> +	/* loop count differs based on BHI_CTRL, see Intel's BHI guidance */
> +	ALTERNATIVE "movl $5,  %ecx; movl $5, %edx",	\
> +		    "movl $12, %ecx; movl $7, %edx", X86_FEATURE_BHI_CTRL

nit: Just

> +
>   	ANNOTATE_INTRA_FUNCTION_CALL
>   	call	1f
>   	jmp	5f
> @@ -1557,7 +1561,7 @@ SYM_FUNC_START(clear_bhb_loop)
>   	 * but some Clang versions (e.g. 18) don't like this.
>   	 */
>   	.skip 32 - 18, 0xcc
> -2:	movl	$5, %eax
> +2:	movl	%edx, %eax
>   3:	jmp	4f
>   	nop
>   4:	sub	$1, %eax
> 


