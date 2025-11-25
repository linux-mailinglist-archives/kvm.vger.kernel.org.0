Return-Path: <kvm+bounces-64482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD74C846BA
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 948B93B046C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0C025A2DE;
	Tue, 25 Nov 2025 10:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E9J6QlrG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A7C231836
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764065978; cv=none; b=MU2afYrwxwn+mE22KTl03HW2BoII8vpZgBwWdJdRQyJ2+vZHf92JH+IEn4OE/23b1RpNcLgaTCu0RGnIwl+VozAeLqEzCUq+/zw54A3/lFPq7klGZZdcf1J6dbQxq3yaX+faAbsCH09YU2UW1xsOBr5nfPFnSFyW72zLbEbDbX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764065978; c=relaxed/simple;
	bh=73wVfPno0wQcookdVqT5/p7wBQHro2hIk0Y/VvxdwaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YFm0zFqjf5zHG5CS5udNfej3KmGLWSFLF7V6MSgKro9c+g115NuPjrNpciSK1ddBrraLjtiZ6jfRElhN3ayE728foswFZHOe4B8/oipp32BcMbVW7Q6DoEn8IvIWsjAfmX6Qvn7THJTBWJwXBPXlmRDatqAktNyrNLtYubfV+Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E9J6QlrG; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7633027cb2so960740566b.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 02:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764065974; x=1764670774; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yIMSsJySte+KTCdc/08zeoYNJkejZ3jDLpSNroCq3SQ=;
        b=E9J6QlrGFunSnz174NGZUot3dyL4gjOHCykiRdfyGFrPg3xHAoy7DwC3+8MINqfe+9
         F9zVzBY5Hk8P5pLPAHyKXJHZUsyTEVm4HHMCKCVkF8RaEVGOK5n+xQ9D4nBDmAxv3mHz
         kJ7pxXiLO1hCpqZwIgvQGWEaxp8NTNEhwPy/rRroKqBRLCoB2EwgQbilw+w6UwZ9Do8B
         Ft9n3Zz5n3D2V6wGV8MMCvWV75yLlvZPfGrQ90MVbC9BCoCUmWi05CwJ0bsHB9csFWYw
         DlZQ0fON/YxvSvZqLoKmGC/91F6m6/cgkeg2p7OAw0NWxnAVlCLrZxo1uXYf3Soz2K36
         CjZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764065974; x=1764670774;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIMSsJySte+KTCdc/08zeoYNJkejZ3jDLpSNroCq3SQ=;
        b=epcSpEDx00o40O2Ac+TRh3PErbAUgFLNcwnXSQF/+56sDDdIORCyMeplnySGpFIYRv
         bXGYabDYJp4w0dWT0JH39AD6zCMlp8QtoC4ABIpSK1UbJNv1bukCAMHYwcmeeVpLzEMv
         qzA+ifPR0suLFreHDCiA4ZSjsIs+/H8U5ZPSs8bokP7hhLqD0qiEIE0NZw14cWnPUBI8
         KR0QC9xwbfo4EEpy4uBczTbugeg9v50tYM6w1jp8yJesjBy+YwbltKYR8C5EE4o88gR7
         pzhHn2OOO1ZHZgcscQp3PGKjUFcWP9AsVbUiXitqeVvsddVwNWaMNZztJjjgL8HJMfxB
         pZEw==
X-Forwarded-Encrypted: i=1; AJvYcCXxfrazJZM0I9UmRHWAD/bXO9yyEPfgofrkAx80WfsOvY0eDzRnMQxPXfRyPu8heGivbkY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpQBYvhMI9jt40G64yW5VBAyHd+Rdc1cxYfWY0VMLZ4xNOjk8w
	0Vgecokep1gKx4e9Q+V+HtnetMcL6Rfy4+5KC2HWS69hVqbaBRn9RL0PWALNmdr5tKU=
X-Gm-Gg: ASbGnctUkRJIHPWXN/T6LrrH+dmUrXroUngayZp8xASTL6XfE32iC/XQF7zykjEzFBo
	dMqFhauLaFKJgV0rF/0vBMz/CDEHYBYpFtjD5l9ccPHMlEMk29p18059TmhhzbhY5xA3xRu48ad
	XMjedU546cWX2yhz8BpxwZ5g/HfKXf/B1oBJUwaUZNESmLiMt2/e5uQSIq/mF1eon9ytDrwdgKV
	W3Keiifzk5lP3h4VVisuCtwgUrzCCbi81J+ewj5kIc196fxnOMHv/qlokfZgq20sGfI6JgDupV1
	H77wKFzhB2uJ/MeyvyTbJKCCBXzegn0E/lrxK7nIvtuPCBuQWSv9Xb4gSyRo1Xm/OGnTFr0VzrJ
	paHSU+186a6ljcdV5Vj3jZRtd06U2Ferv8zFvhEaVScsmZRx4ARYlq2kuAhm+qbFyKdoVzv/3Zv
	Nnr5uxghKN7XneHFybXJ8lNDX5w0zlauZZ5n0E
X-Google-Smtp-Source: AGHT+IGYmFskiHfa4/E1/neLmiMDPqxoViEsBkCue2XNF3bz7i8Fb3d9jLZ7gj1dYP5cXdO2qF6z9g==
X-Received: by 2002:a17:906:fe47:b0:b76:2667:7717 with SMTP id a640c23a62f3a-b76718ab19cmr1737777266b.56.1764065974110;
        Tue, 25 Nov 2025 02:19:34 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654fd4275sm1500974766b.37.2025.11.25.02.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 02:19:33 -0800 (PST)
Message-ID: <c1b67fb1-0ef9-4f23-9e09-c5eecc18f595@suse.com>
Date: Tue, 25 Nov 2025 12:19:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/11] x86/vmscape: Move mitigation selection to a
 switch()
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>,
 Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-6-1adad4e69ddc@linux.intel.com>
 <c8d197cb-bd8d-42b0-a32b-8d8f77c96567@suse.com>
 <20251124230917.7wxvux5s6j6f5tuz@desk>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251124230917.7wxvux5s6j6f5tuz@desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/25/25 01:09, Pawan Gupta wrote:
> On Fri, Nov 21, 2025 at 04:27:05PM +0200, Nikolay Borisov wrote:
>>
>>
>> On 11/20/25 08:19, Pawan Gupta wrote:
>>> This ensures that all mitigation modes are explicitly handled, while
>>> keeping the mitigation selection for each mode together. This also prepares
>>> for adding BHB-clearing mitigation mode for VMSCAPE.
>>>
>>> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>>> ---
>>>    arch/x86/kernel/cpu/bugs.c | 22 ++++++++++++++++++----
>>>    1 file changed, 18 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
>>> index 1e9b11198db0fe2483bd17b1327bcfd44a2c1dbf..233594ede19bf971c999f4d3cc0f6f213002c16c 100644
>>> --- a/arch/x86/kernel/cpu/bugs.c
>>> +++ b/arch/x86/kernel/cpu/bugs.c
>>> @@ -3231,17 +3231,31 @@ early_param("vmscape", vmscape_parse_cmdline);
>>>    static void __init vmscape_select_mitigation(void)
>>>    {
>>> -	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
>>> -	    !boot_cpu_has(X86_FEATURE_IBPB)) {
>>> +	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
>>>    		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
>>>    		return;
>>>    	}
>>> -	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
>>> -		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
>>> +	if ((vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) &&
>>> +	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
>>> +		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
>>> +
>>> +	switch (vmscape_mitigation) {
>>> +	case VMSCAPE_MITIGATION_NONE:
>>> +		break;
>>> +
>>> +	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
>>> +	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
>>> +		if (!boot_cpu_has(X86_FEATURE_IBPB))
>>> +			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
>>> +		break;
>>> +
>>> +	case VMSCAPE_MITIGATION_AUTO:
>>> +		if (boot_cpu_has(X86_FEATURE_IBPB))
>>>    			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
>>
>>
>> IMO this patch is a net-negative because as per my reply to patch 9 you have
>> effectively a dead branch:
>>
>> The clear BHB_CLEAR_USER one, however it turns out you have yet another one:
>> VMSCAPE_MITIGATION_IBPB_ON_VMEXIT as it's only ever set in
>> vmscape_update_mitigation() which executes after '_select()' as well and
> 
> Removed VMSCAPE_MITIGATION_IBPB_ON_VMEXIT.
> 
>> additionally you duplicate the FEATURE_IBPB check.
> 
> FEATURE_IBPB check is still needed for VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER.
> I don't think we can drop that.

But if X86_FEATURE_IBPB is not present then all branches boil down to 
setting the mitigation to NONE. What I was suggesting is to not remove 
the that check at the top.

> 
>> So I think either dropping it or removing the superfluous branches is in
>> order.
>>
>>>    		else
>>>    			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
>>> +		break;
>>>    	}
>>>    }
>>>
>>


