Return-Path: <kvm+bounces-51000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF010AEB9ED
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 979B44A467B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 14:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B9827F00F;
	Fri, 27 Jun 2025 14:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="HMbSWjGp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865DFFBF6
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034840; cv=none; b=ctZJDOFnqVuO4ilpdX9DwZpTjvXYCZmN9mNLpRytE+pmJcglBYhG3vqG1bK9x7A7ROaPsBfFIjQ8fBk2TsXw8+JvTLsjHnSjbMWz/M7yKLFXuzBq9xc/ZnNupk+z38rqTR/MpqJcIC34ah0kZF8T37RcWsLmhXa8RoOVG5uy+BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034840; c=relaxed/simple;
	bh=XgcJ41XYavjWsjGb300vbAa5J5pjmsXQAtOO3kle7qk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ou/N/64ZFEXnd7uvJ3TRIQ4RzfQl3QuwQ3AfRBcnzrCFob1W0dhraHi72lJn32+C8PRYiedcLkYX0dogQM/uM1Guco0XY1hgvCr3RGvjmDTHwWm53tL7kmBVeL7telp3noMLB1/kKQlD8dSz1AB34ePcVXxypsoQ4/odfVCzJN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=HMbSWjGp; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-453643020bdso20092815e9.1
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 07:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1751034837; x=1751639637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=x1OPm9epTrnIhQkbrq5MoRnftJ5u+5HolTF6/9Sc+9o=;
        b=HMbSWjGpcrWxmdX7BiMZVmJ1NybX1SDl+2XiwJktPwPGlRFx/7k6oCIAMRTr9GhNVM
         pXFoLzaHKRGS+7uVHCQ0/RRtBaHR64HuFzndL6FdLNz0mmO2mErsExBGRqbb+k63C4fr
         7HNtpke2R3BmJAyNRte8DrTBCikYBUDsTvPmVVu/A5Qiqt1aY7B6A8BWVd0xpeTzhFft
         w/2+z6w3K1l7UsaHhEgJZyr/Jhsr79FSCEMSMEbPsxnvNMiqJIJ55si5x0UE5c3YftNV
         lVoMa7Z7//Ed+GKnOILvq7V30XD3bkmtovMS5Ly9tLRL8K179cxXruQLOGs51UWAD4q3
         edtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751034837; x=1751639637;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1OPm9epTrnIhQkbrq5MoRnftJ5u+5HolTF6/9Sc+9o=;
        b=w2rv33vI/Dseur20r6QFhe177pQL3IexUCmhYVEkkBGleMckal42b/ttLBhiY/wnWt
         sNwCFAdXdpPqNJFs6NvX6SlwdhULJCRE0v2wR6r4rWqOX15mu2SHYsqqylz+utCdjD7d
         j8hVl2n8WlM9eyMX4lOb7NbLtR3p1fIC7Dp6640TBMI5TsmH5tveZwSsspHAMuTn2giJ
         49IsYb5BugHs9b1HMGokvBaJo3y1mGPGyrWPYukvh5V1tLmdxFl9GpzA0OZz4aVxy16i
         mEDv15GfH5AVEoJSCe2jfVAVKezykXLEYHcplkz0D9ZL5q18PD0YgdhPNGWcxeuZo1vT
         thlA==
X-Forwarded-Encrypted: i=1; AJvYcCV45byWmrdJfzvj8HdJNCxaHFbhV73pBulI+RLDb6wNHr5VV7w9GmzKmRBGYR8zwFMLH+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDBaTX6XrXk8QF18/qWYRLD3wj2VGXM46/BDeIb85LSMVMMjMn
	6OBGNWWeAF6DAABhwc1mTUh0bWgpzzWLULu8pA5RFY8yx3vEI8E/pmU2peVGNwjXKF4=
X-Gm-Gg: ASbGncv/QqRPojBpvKn123gvFLrDp6ILM4qmr9r9HDzJNdIXC9huz1mNi0c9urUYuxr
	Y0vmJ1oqaoujjupJy+xlkI243HfgPiB0aAj1ElhLkimPRI96+oVpwryyMJ/cUrgR6Apx3DXxPQx
	+6mBIyaU+8/qHycVxoYc9U6tzM+/EQlcGWCw0GRw/NtpXgRAjlChmoFpp4dkEQuC2xLSXDL4jJt
	1gcbKzGZ58IMuTF8Q7Nnq4Wao5onRaBpZb8kTpV/kXag7vBWaXr3RNBb/7Qm//CPIlq/dxSFn7l
	EoPJH2+lGjHuY9B5dGWYmkux7+tHdoAAOusRd0KPx0n2JvBNJ8GmAdFMKiDgUjtcHu33J5RFf20
	LVEiNaGh1yU9KMynu7pwnPnyVNvSFLrOwxixX5KP2mk8ft9D0AJXnBSBXotI2a829BZ1dxFGoES
	oI7TO+uoxDIjUtVMJYWAI=
X-Google-Smtp-Source: AGHT+IFJgWJ1g3DOTefsZb3iG5PRWs9VYFywk9GsgBP5LmudEQzyNdRV/M6amlrvMvB2S6Rrh9DldA==
X-Received: by 2002:a05:600c:5028:b0:43d:172:50b1 with SMTP id 5b1f17b1804b1-4538ee859f9mr35608205e9.29.1751034836632;
        Fri, 27 Jun 2025 07:33:56 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7e6f23sm2952315f8f.11.2025.06.27.07.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 07:33:56 -0700 (PDT)
Message-ID: <8fce2f73-3b4f-4451-b4c7-733fa245b7fa@grsecurity.net>
Date: Fri, 27 Jun 2025 16:33:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] x86/emulator64: Extend non-canonical
 memory access tests with CR2 coverage
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20250612141637.131314-1-minipli@grsecurity.net>
 <aF1d7rh_vbr8cr7j@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aF1d7rh_vbr8cr7j@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26.06.25 16:49, Sean Christopherson wrote:
> On Thu, Jun 12, 2025, Mathias Krause wrote:
>> Extend the non-canonical memory access tests to verify CR2 stays
>> unchanged.
>>
>> There's currently a bug in QEMU/TCG that breaks that assumption.
>>
>> Link: https://gitlab.com/qemu-project/qemu/-/issues/928
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>>  x86/emulator64.c | 26 ++++++++++++++++++++++++++
>>  1 file changed, 26 insertions(+)
>>
>> diff --git a/x86/emulator64.c b/x86/emulator64.c
>> index 5d1bb0f06d4f..abef2bda29f1 100644
>> --- a/x86/emulator64.c
>> +++ b/x86/emulator64.c
>> @@ -325,16 +325,39 @@ static void test_mmx_movq_mf(uint64_t *mem)
>>  	report(exception_vector() == MF_VECTOR, "movq mmx generates #MF");
>>  }
>>  
>> +#define CR2_REF_VALUE	0xdecafbadUL
>> +
>> +static void setup_cr2(void)
>> +{
>> +	write_cr2(CR2_REF_VALUE);
>> +}
>> +
>> +static void check_cr2(void)
>> +{
>> +	unsigned long cr2 = read_cr2();
>> +
>> +	if (cr2 == CR2_REF_VALUE) {
>> +		report(true, "CR2 unchanged");
>> +	} else {
>> +		report(false, "CR2 changed from %#lx to %#lx", CR2_REF_VALUE, cr2);
>> +		setup_cr2();
> 
> Writing CR2 isn't expensive in the grand scheme, so rather than conditionally
> re-write CR2, I think it makes sense to write CR2 at the start of every testcase,
> and then just do "report(cr2 == CR2_REF_VALUE".

Probably makes sense.

> 
>> +	}
>> +}
>> +
>>  static void test_jmp_noncanonical(uint64_t *mem)
>>  {
>> +	setup_cr2();
>>  	*mem = NONCANONICAL;
>>  	asm volatile (ASM_TRY("1f") "jmp *%0; 1:" : : "m"(*mem));
>>  	report(exception_vector() == GP_VECTOR,
>>  	       "jump to non-canonical address");
>> +	check_cr2();
>>  }
>>  
>>  static void test_reg_noncanonical(void)
>>  {
>> +	setup_cr2();
>> +
>>  	/* RAX based, should #GP(0) */
>>  	asm volatile(ASM_TRY("1f") "orq $0, (%[noncanonical]); 1:"
>>  		     : : [noncanonical]"a"(NONCANONICAL));
>> @@ -342,6 +365,7 @@ static void test_reg_noncanonical(void)
>>  	       "non-canonical memory access, should %s(0), got %s(%u)",
>>  	       exception_mnemonic(GP_VECTOR),
>>  	       exception_mnemonic(exception_vector()), exception_error_code());
>> +	check_cr2();
> 
> And then rather than add more copy+paste, what if we add a macro to handle the
> checks?  Then the CR2 validation can slot in nicely (and maybe someday the macro
> could be used outside of the x86/emulator64.c).
> 
> Attached patches yield:	
> 
> #define CR2_REF_VALUE	0xdecafbadUL
> 
> #define ASM_TRY_NONCANONICAL(insn, inputs, access, ex_vector)			\
> do {										\
> 	unsigned int vector, ec;						\
> 										\
> 	write_cr2(CR2_REF_VALUE);						\
> 										\
> 	asm volatile(ASM_TRY("1f") insn "; 1:" :: inputs);			\
> 										\
> 	vector = exception_vector();						\
> 	ec = exception_error_code();						\
> 										\
> 	report(vector == ex_vector && !ec,					\
> 	      "non-canonical " access ", should %s(0), got %s(%u)",		\
> 	      exception_mnemonic(ex_vector), exception_mnemonic(vector), ec);	\
> 										\
> 	if (vector != PF_VECTOR) {						\
> 		unsigned long cr2  = read_cr2();				\
> 										\
> 		report(cr2 == CR2_REF_VALUE,					\
> 		       "Wanted CR2 '0x%lx', got '0x%lx", CR2_REF_VALUE, cr2);	\
> 	}									\
> } while (0)
> 
> static void test_jmp_noncanonical(uint64_t *mem)
> {
> 	*mem = NONCANONICAL;
> 
> 	ASM_TRY_NONCANONICAL("jmp *%0", "m"(*mem), "jmp", GP_VECTOR);
> }
> 
> static void test_reg_noncanonical(void)
> {
> 	/* RAX based, should #GP(0) */
> 	ASM_TRY_NONCANONICAL("orq $0, (%[nc])", [nc]"a"(NONCANONICAL),
> 			     "memory access", GP_VECTOR);
> 
> 	/* RSP based, should #SS(0) */
> 	ASM_TRY_NONCANONICAL("orq $0, (%%rsp,%[nc],1)", [nc]"r"(NONCANONICAL),
> 			     "rsp-based access", SS_VECTOR);
> 
> 	/* RBP based, should #SS(0) */
> 	ASM_TRY_NONCANONICAL("orq $0, (%%rbp,%[nc],1)", [nc]"r"(NONCANONICAL),
> 			     "rbp-based access", SS_VECTOR);
> }

Yeah, looks much nicer indeed!

Both patches:

Reviewed-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>

Thanks a lot,
Mathias

