Return-Path: <kvm+bounces-63288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 238F5C60061
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 07:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CE62B4E3792
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 06:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B145621E091;
	Sat, 15 Nov 2025 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="G5de0XYy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809861459F6
	for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 06:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763187320; cv=none; b=g/cECSKxOxDKBJ/D5LUzRqjxQHXWDDKUz0I3L0mFDUVzaxXyW+qQOY+19vyKz2TLbkOfmznYqvfymAnzpQsbHnk863sBb2gQWUE2LWC5x90vRBcvBxtiwqRYIXhGdmaMiQVnjYm+f7260r4HECJNyd2sOj9zjblgJs2VLPYR5Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763187320; c=relaxed/simple;
	bh=svFZbTddyNRuKGFS/UtoSjZLG+kdTi3weIWDF2R6IAo=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=r+7zrzv5Pj4TaDh9g8ISdV3YgFewlW42FVOAO2RubaBcvaFF+PSgNrsdpfYl40L1VulhVfxoRngN8rB1orJuDhCzPEOxoWyx8LUCSnFiJxtnls69Ogdpm2bSVPlvhiRSou4raSn8eICyReHmGmCpD6Jz0O19grPpS5Tn//HXOmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=G5de0XYy; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47789cd2083so19650035e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 22:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763187316; x=1763792116; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uBIBuUnNKlKylBvYgDadNc2A+EkwSCnbG8/Home0x/g=;
        b=G5de0XYyNqPOZewljohaktMuZVwmhAPI2UbcqKKl3np79I2ReZFXodbaBJXxceKnoZ
         V/qvpbWDXL3wGWr4SGdp9nYtlFp0tPTgxUXX3Xe0zMGPp8+/d8RmY5Sv9WvIdrNGCtdK
         d/UT+kYttk1Vur43lY7tN4ELa+TbTpOjFtJY7FX66GfZ17YvGW/R4QWPEIIRYIv82ELT
         Y2d+pmgHWiifcUOgeXj3bg3lVJOFOKgQKxqgqcRDUeEoXmDXVjnFPjG/sPu2Id3uRldi
         t2dDKhwmIB0ZW3zNH82SOTySeSYEXkSssbFffYVD1R6ToCsPR2beJ6iCXn8pG0omrvD9
         16mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763187316; x=1763792116;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uBIBuUnNKlKylBvYgDadNc2A+EkwSCnbG8/Home0x/g=;
        b=a175pqtxqJCD3Hi83IoREL1wuV2zbxvwNSqQ+apPPA5iMJI1CzVJTuyfCkmzy7w/S6
         jTIP0B5lBrGwQjhx3CIs02ynC+0KpYRhaghBlJRG7OfC5uyRGt4z5YkIt4lMs25/qQlM
         0YeGbWlztB1J8KWJLaFDtL0wrikzAybrNpznx0DcvlVKXonLfi/Rc2UMzIihPZTV9RfX
         3Ek7T1DyixzVheEAL3yPXHxzedjuBSaEbgrcIhhHJ2DWu3SOVHXu1P+EdZE6XUA9ItDq
         sUyEjXBX6SRZwo4t30D68++9BxN79dDy7dQEcnNUzPuPD2KBCtcJGICSFy215tvZAwQO
         O2tA==
X-Gm-Message-State: AOJu0YxQLw+kdG0d9wr0e1dO+ssNwkkne86WT2OBdFtV59JQAoiMlNNQ
	gDMi7otOaeb7RLn6wsw7Thrq5AuDR5KniWKLkoJ4dO6ckqxNWW1dLybgZdW8/gxtNEw=
X-Gm-Gg: ASbGncs54aw8Pl/eRSbUO1Kzq4/yWyTwf3LYB1iodsGK8lrU8+0NNlDYhL5VYf58zuf
	iS7fxOz0aBniXHI2IY+PGNjvfJEUkDH/jFWkB5gJ9ToqO8+7hWeUdlEVXvdMU0QfyV1Z6Ow3AyM
	1wSRHNCdrZLGuJ2s7bR7xpCnIqEhzpgL9ad46CGWiKU+wNjlXCtE6zF27qvJyLT8D+tRtWtMBU4
	cR2Kp9FB04V9lG6jqnmWPnzhbek/HswKOvsKPYdf8hMJF/AcpmIwXvgVPiY5tthykC5XcaEvorz
	kBjRANsPbzqwSf/EBRjQ71CtS129iN0Y2dWPcyr0HATG2lTI4g/yuOheWuOgLLBgX83x4sPOOlt
	t2F+orXaP//ClyKeYYwXZea6FlNxLH1p/X4MGH3gV4CTCzE3SRTyYwZc0ZqPUdGAwl9v0YQ+CQr
	vqrvEhGuZceBF8V56JcGksdaD98dPgVCzmD7EX2+tWjrO1WecKe0po/FCxTxncnTsdFgGnECw9V
	sDlYe0I3RVvclDdJFAygaP04E6JXitTHCaW1bnClKA1w3Tr5I+gVkDs
X-Google-Smtp-Source: AGHT+IE7WtEWs8kiZCTa2x9F6Ec3ri57gy2b+EQTTsMzrQ5UoFrRLfdtBQ7APbehCQbYFiG5bqThRA==
X-Received: by 2002:a05:600c:4f4c:b0:477:e66:4077 with SMTP id 5b1f17b1804b1-4778fea8848mr54112205e9.29.1763187315565;
        Fri, 14 Nov 2025 22:15:15 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47796a8a695sm26477615e9.13.2025.11.14.22.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 22:15:14 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------o3EE3lz7B0rymzPOWCfATNmi"
Message-ID: <6bbcd6bb-f514-498d-8f3f-50934587099a@grsecurity.net>
Date: Sat, 15 Nov 2025 07:15:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 18/18] x86: cet: Add testcases to verify
 KVM rejects emulation of CET instructions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114205100.1873640-1-seanjc@google.com>
 <20251114205100.1873640-19-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20251114205100.1873640-19-seanjc@google.com>

This is a multi-part message in MIME format.
--------------o3EE3lz7B0rymzPOWCfATNmi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 21:51, Sean Christopherson wrote:
> Add SHSTK and IBT testcases to verify that KVM rejects (forced) emulation
> of instructions that interact with SHSTK and/or IBT state, as KVM doesn't
> support emulating SHSTK or IBT (rejecting emulation is preferable to
> compromising guest security).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/cet.c | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 124 insertions(+), 1 deletion(-)
> 
> diff --git a/x86/cet.c b/x86/cet.c
> index 7ffe234b..e94ffb72 100644
> --- a/x86/cet.c
> +++ b/x86/cet.c
> @@ -74,6 +74,116 @@ static uint64_t cet_ibt_func(void)
>  	return 0;
>  }
>  
> +#define __CET_TEST_UNSUPPORTED_INSTRUCTION(insn)			\
> +({									\
> +	struct far_pointer32 fp = {					\
> +		.offset = 0,						\
> +		.selector = USER_CS,					\
> +	};								\
> +									\
> +	asm volatile ("push %%rax\n"					\
> +		      ASM_TRY_FEP("1f") insn "\n\t"			\
> +		      "1:"						\
> +		      "pop %%rax\n"					\
> +		      : : "m" (fp), "a" (NONCANONICAL) : "memory");	\
> +									\
> +	exception_vector();					\
> +})
> +
> +#define SHSTK_TEST_UNSUPPORTED_INSTRUCTION(insn)			\
> +do {									\
> +	uint8_t vector = __CET_TEST_UNSUPPORTED_INSTRUCTION(insn);	\
> +									\
> +	report(vector == UD_VECTOR, "SHSTK: Wanted #UD on %s, got %s",	\
> +	       insn, exception_mnemonic(vector));			\
> +} while (0)
> +
> +/*
> + * Treat IRET as unsupported with IBT even though the minimal interactions with
> + * IBT _could_ be easily emulated by KVM, as KVM doesn't support emulating IRET
> + * outside of Real Mode.
> + */
> +#define CET_TEST_UNSUPPORTED_INSTRUCTIONS(CET)				\
> +do {									\
> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("callq *%%rax");		\
> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("lcall *%0");		\
                                            ^^^^^
I meant that this one should be "calll *%0" (three Ls). But yeah, could
easily be seen as a typo, so we can just leave it as-is.

> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("syscall");			\
> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("sysenter");			\
> +	CET##_TEST_UNSUPPORTED_INSTRUCTION("iretq");			\
> +} while (0)
> +
> +static uint64_t cet_shstk_emulation(void)
> +{
> +	CET_TEST_UNSUPPORTED_INSTRUCTIONS(SHSTK);
> +
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("call 1f");
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("retq");
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("retq $10");
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("lretq");
> +	SHSTK_TEST_UNSUPPORTED_INSTRUCTION("lretq $10");
> +
> +	/* Do a handful of JMPs to verify they aren't impacted by SHSTK. */
> +	asm volatile(KVM_FEP "jmp 1f\n\t"
> +		     "1:\n\t"
> +		     KVM_FEP "lea 2f(%%rip), %%rax\n\t"
> +		     KVM_FEP "jmp *%%rax\n\t"
> +		     "2:\n\t"
> +		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
> +		     KVM_FEP "lea 3f(%%rip), %%rax\n\t"
> +		     KVM_FEP "push %%rax\n\t"
> +		     /*
> +		      * Manually encode ljmpq, which gas doesn't recognize due

Well, it does, if explicitly told so:

$ echo 'ljmpq *(%rax)' | as
{standard input}: Assembler messages:
{standard input}:1: Error: invalid instruction suffix for `ljmp'
$ echo 'ljmpq *(%rax)' | as -mintel64 && objdump -d -Mintel64 | tail -1
   0:	48 ff 28             	ljmpq  *(%rax)

But lets not split hairs!

> +		      * to AMD not supporting the instruction (64-bit JMP FAR).
> +		      */
> +		     KVM_FEP ".byte 0x48\n\t"
> +		     "ljmpl *(%%rsp)\n\t"
> +		     "3:\n\t"
> +		     KVM_FEP "pop %%rax\n\t"
> +		     KVM_FEP "pop %%rax\n\t"
> +		     ::: "eax");
> +
> +	return 0;
> +}
> +

> +/*
> + * Don't invoke printf() or report() in the IBT testcase, as it will likely
> + * generate an indirect branch without an endbr64 annotation and thus #CP.
> + * Return the line number of the macro invocation to signal failure.
> + */

That comment is outdated and can simply be dropped now.

> +#define IBT_TEST_UNSUPPORTED_INSTRUCTION(insn)				\
> +do {									\
> +	uint8_t vector = __CET_TEST_UNSUPPORTED_INSTRUCTION(insn);	\
> +									\
> +	report(vector == UD_VECTOR, "IBT: Wanted #UD on %s, got %s",	\
> +	       insn, exception_mnemonic(vector));			\
> +} while (0)
> +
> +static uint64_t cet_ibt_emulation(void)
> +{
> +	CET_TEST_UNSUPPORTED_INSTRUCTIONS(IBT);
> +
> +	IBT_TEST_UNSUPPORTED_INSTRUCTION("jmp *%%rax");
> +	IBT_TEST_UNSUPPORTED_INSTRUCTION("ljmpl *%0");
> +
> +	/* Verify direct CALLs and JMPs, and all RETs aren't impacted by IBT. */
> +	asm volatile(KVM_FEP "jmp 2f\n\t"
> +		     "1: " KVM_FEP " ret\n\t"
> +		     "2: " KVM_FEP " call 1b\n\t"
> +		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
> +		     KVM_FEP "lea 3f(%%rip), %%rax\n\t"
> +		     KVM_FEP "push %%rax\n\t"
> +		     KVM_FEP "lretq\n\t"
> +		     "3:\n\t"
> +		     KVM_FEP "push $0x55555555\n\t"
> +		     KVM_FEP "push $" xstr(USER_CS) "\n\t"
> +		     KVM_FEP "lea 4f(%%rip), %%rax\n\t"
> +		     KVM_FEP "push %%rax\n\t"
> +		     KVM_FEP "lretq $8\n\t"
> +		     "4:\n\t"
> +		     ::: "eax");
> +	return 0;
> +}
> +
>  #define CP_ERR_NEAR_RET	0x0001
>  #define CP_ERR_FAR_RET	0x0002
>  #define CP_ERR_ENDBR	0x0003
> @@ -119,7 +229,7 @@ static void test_shstk(void)
>  	/* Store shadow-stack pointer. */
>  	wrmsr(MSR_IA32_PL3_SSP, (u64)(shstk_virt + 0x1000));
>  
> -	printf("Unit tests for CET user mode...\n");
> +	printf("Running user mode Shadow Stack tests\n");
>  	run_in_user(cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
>  	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
>  	       "NEAR RET shadow-stack protection test");
> @@ -128,6 +238,12 @@ static void test_shstk(void)
>  	report(rvc && exception_error_code() == CP_ERR_FAR_RET,
>  	       "FAR RET shadow-stack protection test");
>  
> +	if (is_fep_available &&
> +	    (run_in_user(cet_shstk_emulation, CP_VECTOR, 0, 0, 0, 0, &rvc) || rvc))
> +		report_fail("Forced emulation with SHSTK generated %s(%u)",
> +			    exception_mnemonic(exception_vector()),
> +			    exception_error_code());
> +
>  	/* SSP should be 4-Byte aligned */
>  	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
>  	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
> @@ -158,6 +274,7 @@ static uint64_t ibt_run_in_user(usermode_func func, bool *got_cp)
>  static void test_ibt(void)
>  {
>  	bool got_cp;

> +	uint64_t l;

>  
>  	if (!this_cpu_has(X86_FEATURE_IBT)) {
>  		report_skip("IBT not supported");
> @@ -170,6 +287,12 @@ static void test_ibt(void)
>  	ibt_run_in_user(cet_ibt_func, &got_cp);
>  	report(got_cp && exception_error_code() == CP_ERR_ENDBR,
>  	       "Indirect-branch tracking test");
> +
> +	if (is_fep_available &&
> +	    ((l = ibt_run_in_user(cet_ibt_emulation, &got_cp)) || got_cp))
> +		report_fail("Forced emulation with IBT generated %s(%u) at line %lu",
> +			    exception_mnemonic(exception_vector()),
> +			    exception_error_code(), l);

cet_ibt_emulation() returns no line information any more, so that should
be simplified.

>  }
>  
>  int main(int ac, char **av)
With something like the attached diff as a fixup:
Reviewed-by: Mathias Krause <minipli@grsecurity.net>

Thanks,
Mathias
--------------o3EE3lz7B0rymzPOWCfATNmi
Content-Type: text/x-patch; charset=UTF-8; name="fep_fixup.diff"
Content-Disposition: attachment; filename="fep_fixup.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3g4Ni9jZXQuYyBiL3g4Ni9jZXQuYwppbmRleCBlOTRmZmI3MjVlODgu
LjlhNTkxM2Y3NjRlYSAxMDA2NDQKLS0tIGEveDg2L2NldC5jCisrKyBiL3g4Ni9jZXQuYwpA
QCAtMTQ1LDExICsxNDUsNiBAQCBzdGF0aWMgdWludDY0X3QgY2V0X3Noc3RrX2VtdWxhdGlv
bih2b2lkKQogCXJldHVybiAwOwogfQogCi0vKgotICogRG9uJ3QgaW52b2tlIHByaW50Zigp
IG9yIHJlcG9ydCgpIGluIHRoZSBJQlQgdGVzdGNhc2UsIGFzIGl0IHdpbGwgbGlrZWx5Ci0g
KiBnZW5lcmF0ZSBhbiBpbmRpcmVjdCBicmFuY2ggd2l0aG91dCBhbiBlbmRicjY0IGFubm90
YXRpb24gYW5kIHRodXMgI0NQLgotICogUmV0dXJuIHRoZSBsaW5lIG51bWJlciBvZiB0aGUg
bWFjcm8gaW52b2NhdGlvbiB0byBzaWduYWwgZmFpbHVyZS4KLSAqLwogI2RlZmluZSBJQlRf
VEVTVF9VTlNVUFBPUlRFRF9JTlNUUlVDVElPTihpbnNuKQkJCQlcCiBkbyB7CQkJCQkJCQkJ
XAogCXVpbnQ4X3QgdmVjdG9yID0gX19DRVRfVEVTVF9VTlNVUFBPUlRFRF9JTlNUUlVDVElP
TihpbnNuKTsJXApAQCAtMTk0LDcgKzE4OSw2IEBAIHN0YXRpYyB1aW50NjRfdCBjZXRfaWJ0
X2VtdWxhdGlvbih2b2lkKQogI2RlZmluZSBDRVRfRU5BQkxFX1NIU1RLCQkJQklUKDApCiAj
ZGVmaW5lIENFVF9FTkFCTEVfSUJUCQkJCUJJVCgyKQogI2RlZmluZSBDRVRfRU5BQkxFX05P
VFJBQ0sJCQlCSVQoNCkKLSNkZWZpbmUgQ0VUX0lCVF9TVVBQUkVTUwkJCUJJVCgxMCkKICNk
ZWZpbmUgQ0VUX0lCVF9UUkFDS0VSX1dBSVRfRk9SX0VOREJSQU5DSAlCSVQoMTEpCiAKIHN0
YXRpYyB2b2lkIHRlc3Rfc2hzdGsodm9pZCkKQEAgLTI3NCw3ICsyNjgsNiBAQCBzdGF0aWMg
dWludDY0X3QgaWJ0X3J1bl9pbl91c2VyKHVzZXJtb2RlX2Z1bmMgZnVuYywgYm9vbCAqZ290
X2NwKQogc3RhdGljIHZvaWQgdGVzdF9pYnQodm9pZCkKIHsKIAlib29sIGdvdF9jcDsKLQl1
aW50NjRfdCBsOwogCiAJaWYgKCF0aGlzX2NwdV9oYXMoWDg2X0ZFQVRVUkVfSUJUKSkgewog
CQlyZXBvcnRfc2tpcCgiSUJUIG5vdCBzdXBwb3J0ZWQiKTsKQEAgLTI4OSwxMCArMjgyLDEw
IEBAIHN0YXRpYyB2b2lkIHRlc3RfaWJ0KHZvaWQpCiAJICAgICAgICJJbmRpcmVjdC1icmFu
Y2ggdHJhY2tpbmcgdGVzdCIpOwogCiAJaWYgKGlzX2ZlcF9hdmFpbGFibGUgJiYKLQkgICAg
KChsID0gaWJ0X3J1bl9pbl91c2VyKGNldF9pYnRfZW11bGF0aW9uLCAmZ290X2NwKSkgfHwg
Z290X2NwKSkKLQkJcmVwb3J0X2ZhaWwoIkZvcmNlZCBlbXVsYXRpb24gd2l0aCBJQlQgZ2Vu
ZXJhdGVkICVzKCV1KSBhdCBsaW5lICVsdSIsCisJICAgIChpYnRfcnVuX2luX3VzZXIoY2V0
X2lidF9lbXVsYXRpb24sICZnb3RfY3ApIHx8IGdvdF9jcCkpCisJCXJlcG9ydF9mYWlsKCJG
b3JjZWQgZW11bGF0aW9uIHdpdGggSUJUIGdlbmVyYXRlZCAlcygldSkiLAogCQkJICAgIGV4
Y2VwdGlvbl9tbmVtb25pYyhleGNlcHRpb25fdmVjdG9yKCkpLAotCQkJICAgIGV4Y2VwdGlv
bl9lcnJvcl9jb2RlKCksIGwpOworCQkJICAgIGV4Y2VwdGlvbl9lcnJvcl9jb2RlKCkpOwog
fQogCiBpbnQgbWFpbihpbnQgYWMsIGNoYXIgKiphdikK

--------------o3EE3lz7B0rymzPOWCfATNmi--

