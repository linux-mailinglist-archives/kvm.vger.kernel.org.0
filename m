Return-Path: <kvm+bounces-64176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3B2C7AEFB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 17:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D09644ED61A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 16:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258532F0699;
	Fri, 21 Nov 2025 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cBe6vFL5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DE32853E0
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 16:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763743560; cv=none; b=WNqLHkX+V8G2llgcm0zw94YRc61+tcCxWrphQFtA2pkjyvO4OirecWVxbW79z3W8+CFpe5b3euxmDyNyznBnJk7rvsnvdihF/z/zoaIvoXtyxkngI4+NAukSWQQP/eHGSUPGCofs/4YGoKXH6344zZzd+he6djbjbAfr1mCLrAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763743560; c=relaxed/simple;
	bh=k/FqFxuRBoSgt8q6bUtFdmNppTd524En0NlEF8Hhe5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KAIKS1PmHW0Lshy1UaYCzCPle5GFHS/PA3MsaBGSw8U6GjSoibsTWg+KdzGDMJP6AIfggUciSI8EO1usyJ2b/l2efLdoJbaZlq2VzhYN2l2uiDv+RR9kapM+2BHz2sFTJeU7RvyAyF3qhl4pl1ZgUl/0HQEe2rwY1kUTWpgAOIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cBe6vFL5; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso4031707a12.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 08:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763743556; x=1764348356; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mbdx/pwSTHT2XoZ60wBvSJJHeBLVuIaWD3kGl0+OuSA=;
        b=cBe6vFL5b1okO7NSV61uA5a3GuvDoEAV5zsSqxF9cl6c+ggRBAMysdq/TcUl3Bfscx
         F6h5+icS3fbXRaF/vypze6uN9cqRWbA8mrcItnGLZMHdLOGg5b7fYzO9q6d2TdcoaFVK
         m4R1WS6p2iRvzJG+g8QEIN7yqW2+mzz5GwNKFqflM9jM5AkdiuOQskCe3zO1SekZdK4o
         3KKWcyidfiFtJmiDhoEXuC2OmsPBXl40RS4329FnYNEMQKCAKUifR1JofAKXhSzudOTI
         Xs/pRDrCU0mZkpS3eRPHG5BCCL5cN5sNdIjA/5talgBdXeOuw9D1tbyCHzrxjEiz7kYT
         mufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763743556; x=1764348356;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbdx/pwSTHT2XoZ60wBvSJJHeBLVuIaWD3kGl0+OuSA=;
        b=q4gjusfivb31juZLIKt3JErsW/x392nNa9QYfHYTKOkFEFpB57BF76BvsYhjW5Letl
         uEl5Obv9WbmGJaMsGkUdISeT0JFMu3pvvaVdIfgHw3JCGFF2TqE50BHo0un5wDazQyLO
         liiMhOI25r/Wp4LgwA1eOlqsstxHX0MykJj63KoAD5zlNyuIXF6OgevTKKdhyAAvJ7rc
         4swblA0CCIHFjIWZpMS5G8dDJdqyMx5nxEh2bG5hinNT15gE4Om0JMVZB7D5H1oGUTQw
         NxU1X+699V9E8lTvzAX8OtZiuBjvLvWtOZYnlAdJExRwJFqg9bMn0zeSOZYosMibvKFn
         mJPA==
X-Forwarded-Encrypted: i=1; AJvYcCUXaQM0T8CMEG3Mmp/XCQ7Txw7dz//fOc8ACp5m6cezd3G2Hj7LPOJfuJnmyNdvqLmAuj8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzK+mLSeeMHDfIpxB0BlWAM4B2EII+t3Snk+OC2lZwaSNQ945w
	8SOxG8wimcAf71Q2E2Yme6Y8dhonWh4ZKHCSq2uQWSo8tkP/n0+e8MzmMNGM9vchVDw=
X-Gm-Gg: ASbGncsy1XdqaraL+9lgYBjGmpUzqMSoJp/QyumngdiD/aHOnrIhd4b3VUH49xLBVRf
	OfAvjvVAKVvNzvQmbczxk4YiEtH8NLT3nU08rs+Rg5A5fUC8mL7uVxXFEaMJ4zvZytOxS+VZ8x3
	K7/Vlsg7OiJa9q5t4ItLLnHtXLMurZZo1xrCZeCwCIV1vFqfajljBl850iCZ3BrzcD37ZBI2gvF
	ylQKFjecFe4GHNoUo0jeZReaZHCZImfH7YN7ojTY5c3cvl16ahbyJ6POWndt6emTGqOEhRAQwK5
	3T8Ez3Wk/DtYrE9DwOt7b7SP73o38SzQDTraxHSUHEQN8s79j/Y6ukB9rf4YHDtSVZxM+qgaCUN
	9M2GP0TxUEiVqVn/3dvBHMQQS9AZ9PSZGKB4aiQOyisb7+8kXQbwftVkPlDExvFXWf6ukFkj4cu
	kYq9z2N0GfNP4qmKCp07Mm7X9WpHpysTK2mJP+
X-Google-Smtp-Source: AGHT+IFUhtxnTWEgYbiepq2jGVepveL+2G4t9EyzUqc055PoS6kuHxlSpVbG2sdpiuahMzdaMmfouw==
X-Received: by 2002:a05:6402:27d3:b0:640:3210:6e48 with SMTP id 4fb4d7f45d1cf-64554339c49mr2575116a12.4.1763743556524;
        Fri, 21 Nov 2025 08:45:56 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363ac96dsm4819572a12.4.2025.11.21.08.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 08:45:56 -0800 (PST)
Message-ID: <e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
Date: Fri, 21 Nov 2025 18:45:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
To: Dave Hansen <dave.hansen@intel.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>,
 Peter Zijlstra <peterz@infradead.org>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/21/25 18:40, Dave Hansen wrote:
> On 11/19/25 22:18, Pawan Gupta wrote:
>> -	CLEAR_BHB_LOOP_SEQ 5, 5
>> +	/* loop count differs based on CPU-gen, see Intel's BHI guidance */
>> +	ALTERNATIVE (CLEAR_BHB_LOOP_SEQ 5, 5),  \
>> +		    __stringify(CLEAR_BHB_LOOP_SEQ 12, 7), X86_FEATURE_BHI_CTRL
> 
> There are a million ways to skin this cat. But I'm not sure I really
> like the end result here. It seems a little overkill to use ALTERNATIVE
> to rewrite a whole sequence just to patch two constants in there.
> 
> What if the CLEAR_BHB_LOOP_SEQ just took its inner and outer loop counts
> as register arguments? Then this would look more like:
> 
> 	ALTERNATIVE "mov  $5, %rdi; mov $5, %rsi",
> 		    "mov $12, %rdi; mov $7, %rsi",
> 	...
> 
> 	CLEAR_BHB_LOOP_SEQ
> 
> Or, even global variables:
> 
> 	mov outer_loop_count(%rip), %rdi
> 	mov inner_loop_count(%rip), %rsi

nit: FWIW I find this rather tacky, because the way the registers are 
being used (although they do follow the x86-64 calling convention) is 
obfuscated in the macro itself.

> 
> and then have some C code somewhere that does:
> 
> 	if (cpu_feature_enabled(X86_FEATURE_BHI_CTRL)) {
> 		outer_loop_count = 5;
> 		inner_loop_count = 5;
> 	} else {
> 		outer_loop_count = 12;
> 		inner_loop_count = 7;
> 	}

OTOH: the global variable approach seems saner as in the macro you'd 
have direct reference to them and so it will be more obvious how things 
are setup.

<snip>

