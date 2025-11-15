Return-Path: <kvm+bounces-63287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 02782C60036
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 06:40:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 24F5635DCEA
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 05:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E019C1DD9AC;
	Sat, 15 Nov 2025 05:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="E8FYm9IX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B1211CBA
	for <kvm@vger.kernel.org>; Sat, 15 Nov 2025 05:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763185212; cv=none; b=MU+Grotqju0DFeik7gB50lJxrIK/0IWVp/imAcVY9zrjNV89w7P/H/Th/7gi96M2VZ75A00Ku/21W9jX0cpG6HNS5dlbnBBVhslSEHBwuSWYcZXBRRp9C+umVa8Utvb42vj0UWS6wm5fIb8ODD6Q+eHlFi4Rv/PB7O4R6lqjmVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763185212; c=relaxed/simple;
	bh=yCYm4hfXn5uiYOXKkDrDGgaIohWse4QiUd3w9GV/rdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qPC4KvOsTqALQF3riyu9Ra/sHSCYgf1RfFfVolwsz4Z0+PoqFtDnFWR+ZWR8xfrm7HF3X/n7pFIdU+UH+4OM9/w/Bn42sjaBoxr6pAOvCijHH9JrBbgxnXMSFO6q/YKOrjwLRjjO/LeE5AfVzRC1YHQvtp3b4XuAao8gaEDsnYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=E8FYm9IX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4777771ed1aso18301425e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 21:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763185207; x=1763790007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KuttQir3A/X6/JgT7xeJd5GPLTJ/cpNCaxd0BTn84F0=;
        b=E8FYm9IX3xJHH8eJRfsfTjUOQmfKZq7Ew6xfsXSPFVK4JM2c2qZAokOw+1bskT9GT1
         VPR3eWWwWVPXSdY8Shf+pGwgYUflSy0+ZOxxlpVYXw3a/45UqzGcTL1XppLhjdrNcr4D
         9Pq6KvRsWOkQ240oRYqBB2/BM6j71cO8o9/B1IRojLIfKaidnnuIUkVmvz5Q4RwBL2D6
         GAUv0ZIj/9MHishhOc9J4dCA2J/M8bOb77AYhquJ4+rDXiPn/b/ZzX9u/62ckWaGP6cW
         UoE1RxKkji6GCmD8BLlAzyWpOYrLwkR9xzrCbgnO3+2wUk5Pq/SI/gN0LxQON66m7Jmn
         D6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763185207; x=1763790007;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KuttQir3A/X6/JgT7xeJd5GPLTJ/cpNCaxd0BTn84F0=;
        b=JO4GwA7szpM/2ZiDafPS/55LsEJcW0BvprHs4KSOXFIa6uymdpHk/IPu62vLz8F5I8
         MwC0ADHZpBO/ZVnBC5Yp3A2SVWf3aQs+GXdYhEmLyxv9/Pgpgndk5rU/mvygIALxn/Iu
         1Rh/2DWP43DpinMo0JwV9c0gnVGAtJxPT5MuF41Z2MWeE+YSuApgsqp+88/b22exJlUQ
         cN99p2tL9BtCoIYiKd5cCY+W6gugsdvQxRvO5uTh6yaYASYjVIW5uk6D3EoAU86RUa6R
         a5d6Rsb5ovXLqxFWiJNeCVcLOpbJGGAEfV33/exH82zIhqZcR1b2afQnUrBWTc68AiPL
         3Kqw==
X-Gm-Message-State: AOJu0YylkwIxvWxXbd98T00ktLoEhcF5xNIzvibeBy6c4QY1cos9Djwq
	f6zQdaFVJ60bc6qSjFPMiDg//HNgDUaKddqiOlJuXdkQX4Gf7U3dAaJKxGIxVfbUBYA=
X-Gm-Gg: ASbGncuQvEdHEwl5sVdfiFRejdKVSDUtAhW4huc7PT5xuHXD2R/tPKn1YiLbyxrepFI
	S9i7BbHE/HRP7qqUtLNURokUNQSFp4DC0Dunk2LwQbCpjwz//ZGsZ1FSc6FIUN5okBMjfoW5F8Z
	RbTIk0yFdiZb9Ac+bF5N9MCVNoP7dYuv8kiXs8tLfSJdUJYhj8y/50IVDRVOf/e4i5WqUfpITOn
	1kP/yCegx0XG/z7eZB6TQLFv6i6OqIVrp0vgj6UGoNvYxMhknFVNpRCQiPCZn5IsYjRPb+0F3Pw
	r3cxUPrqz4CcXc7BA3dfU2cYN47Jlqv099diioapHRHlbi+duJdjQ1Pq8crkRQDAl4PI0oIPHIO
	JD6jyEcNSCpeDJ6zSAMI+EEtnAjuSVl8LlCFpWpjJzEYC3J3GzSiKCeGiIWA37Bom4IrJwvXbhs
	qZkWu3y3UqXdyZqjggvSyo2rrOM+GZ+lDKzBMNTdXz1C7jAEUFXIpWgNQ+bi8HIVKyhobA7Zh4a
	kIhrKAN/jkg6JI//N+wZXC/3x4omILPXSE=
X-Google-Smtp-Source: AGHT+IEEYT89vuxP3qFa197L8rY0ZOPNbwU9OSFw/814a8qSGcGoyV0nkbUS1/lOfLjABZCGiq7sVg==
X-Received: by 2002:a05:6000:1a8b:b0:42b:2f90:bd05 with SMTP id ffacd0b85a97d-42b59374c07mr4997978f8f.45.1763185206886;
        Fri, 14 Nov 2025 21:40:06 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f206e2sm13941645f8f.41.2025.11.14.21.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 21:40:06 -0800 (PST)
Message-ID: <6bfc1419-c037-4c14-86af-7f404b5e906a@grsecurity.net>
Date: Sat, 15 Nov 2025 06:40:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 17/18] x86: cet: Reset IBT tracker state
 on #CP violations
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114205100.1873640-1-seanjc@google.com>
 <20251114205100.1873640-18-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20251114205100.1873640-18-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 21:50, Sean Christopherson wrote:
> Reset the IBT tracker state back to IDLE on #CP violations to not
> influence follow-up tests with a poisoned starting state.

Again, maybe missing a "From: Mathias Krause <minipli@grsecurity.net>"?

> 
> Opportunistically rename "rvc" to "got_cp" to make it more obvious what
> the flag tracks ("rvc" is presumably "raised vector CP"?).
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> [sean: add helper, align indentation, use handler+callback instead of "extra"]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/usermode.c | 12 +++++++++---
>  lib/x86/usermode.h | 13 ++++++++++---
>  x86/cet.c          | 31 +++++++++++++++++++++++++++----
>  3 files changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index f896e3bd..b65c5378 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -21,12 +21,17 @@ static void restore_exec_to_jmpbuf(void)
>  	longjmp(jmpbuf, 1);
>  }
>  
> +static handler ex_callback;
> +
>  static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
>  {
>  	this_cpu_write_exception_vector(regs->vector);
>  	this_cpu_write_exception_rflags_rf((regs->rflags >> 16) & 1);
>  	this_cpu_write_exception_error_code(regs->error_code);
>  
> +	if (ex_callback)
> +		ex_callback(regs);
> +
>  	/* longjmp must happen after iret, so do not do it now.  */
>  	regs->rip = (unsigned long)&restore_exec_to_jmpbuf;
>  	regs->cs = KERNEL_CS;
> @@ -35,9 +40,9 @@ static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
>  #endif
>  }
>  
> -uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
> -		uint64_t arg1, uint64_t arg2, uint64_t arg3,
> -		uint64_t arg4, bool *raised_vector)
> +uint64_t run_in_user_ex(usermode_func func, unsigned int fault_vector,
> +			uint64_t arg1, uint64_t arg2, uint64_t arg3,
> +			uint64_t arg4, bool *raised_vector, handler ex_handler)
>  {
>  	extern char ret_to_kernel;
>  	volatile uint64_t rax = 0;
> @@ -45,6 +50,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>  	handler old_ex;
>  
>  	*raised_vector = 0;
> +	ex_callback = ex_handler;
>  	set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
>  	old_ex = handle_exception(fault_vector,
>  				  restore_exec_to_jmpbuf_exception_handler);
> diff --git a/lib/x86/usermode.h b/lib/x86/usermode.h
> index 04e358e2..7eca9079 100644
> --- a/lib/x86/usermode.h
> +++ b/lib/x86/usermode.h
> @@ -20,11 +20,18 @@ typedef uint64_t (*usermode_func)(void);
>   * Supports running functions with up to 4 arguments.
>   * fault_vector: exception vector that might get thrown during the function.
>   * raised_vector: outputs true if exception occurred.
> + * ex_handler: optiona handler to call when handling @fault_vector exceptions
                  ^^^^^^^ optional

>   *
>   * returns: return value returned by function, or 0 if an exception occurred.
>   */
> -uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
> -		uint64_t arg1, uint64_t arg2, uint64_t arg3,
> -		uint64_t arg4, bool *raised_vector);
> +uint64_t run_in_user_ex(usermode_func func, unsigned int fault_vector,
> +			uint64_t arg1, uint64_t arg2, uint64_t arg3,
> +			uint64_t arg4, bool *raised_vector, handler ex_handler);
>  
> +static inline uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
> +				   uint64_t arg1, uint64_t arg2, uint64_t arg3,
> +				   uint64_t arg4, bool *raised_vector)
> +{
> +	return run_in_user_ex(func, fault_vector, arg1, arg2, arg3, arg4, raised_vector, NULL);
> +}
>  #endif
> diff --git a/x86/cet.c b/x86/cet.c
> index 74d3f701..7ffe234b 100644
> --- a/x86/cet.c
> +++ b/x86/cet.c
> @@ -1,4 +1,3 @@
> -
>  #include "libcflat.h"
>  #include "x86/desc.h"
>  #include "x86/processor.h"
> @@ -85,6 +84,8 @@ static uint64_t cet_ibt_func(void)
>  #define CET_ENABLE_SHSTK			BIT(0)
>  #define CET_ENABLE_IBT				BIT(2)
>  #define CET_ENABLE_NOTRACK			BIT(4)
> +#define CET_IBT_SUPPRESS			BIT(10)

CET_IBT_SUPPRESS isn't needed (not used in the code), but doesn't hurt
either to have it.

> +#define CET_IBT_TRACKER_WAIT_FOR_ENDBRANCH	BIT(11)
>  
>  static void test_shstk(void)
>  {
> @@ -132,9 +133,31 @@ static void test_shstk(void)
>  	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
>  }
>  
> +static void ibt_tracker_cp_fixup(struct ex_regs *regs)
> +{
> +	u64 cet_u = rdmsr(MSR_IA32_U_CET);
> +
> +	/*
> +	 * Switch the IBT tracker state to IDLE to have a clean state for
> +	 * following tests.
> +	 */
> +	if (cet_u & CET_IBT_TRACKER_WAIT_FOR_ENDBRANCH) {
> +		cet_u &= ~CET_IBT_TRACKER_WAIT_FOR_ENDBRANCH;
> +		printf("CET: suppressing IBT WAIT_FOR_ENDBRANCH state at RIP: %lx\n",
> +		       regs->rip);
> +		wrmsr(MSR_IA32_U_CET, cet_u);
> +	}
> +}
> +
> +static uint64_t ibt_run_in_user(usermode_func func, bool *got_cp)
> +{
> +	return run_in_user_ex(func, CP_VECTOR, 0, 0, 0, 0, got_cp,
> +			      ibt_tracker_cp_fixup);
> +}

Ahh, yeah. Nice indirection, helps making the code less cluttered :)

> +
>  static void test_ibt(void)
>  {
> -	bool rvc;
> +	bool got_cp;
>  
>  	if (!this_cpu_has(X86_FEATURE_IBT)) {
>  		report_skip("IBT not supported");
> @@ -144,8 +167,8 @@ static void test_ibt(void)
>  	/* Enable indirect-branch tracking (notrack handling for jump tables) */
>  	wrmsr(MSR_IA32_U_CET, CET_ENABLE_IBT | CET_ENABLE_NOTRACK);
>  
> -	run_in_user(cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
> -	report(rvc && exception_error_code() == CP_ERR_ENDBR,
> +	ibt_run_in_user(cet_ibt_func, &got_cp);
> +	report(got_cp && exception_error_code() == CP_ERR_ENDBR,
>  	       "Indirect-branch tracking test");
>  }
>  
LGTM!

Thanks,
Mathias

