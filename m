Return-Path: <kvm+bounces-15030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1728A8F23
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A274B1F21C02
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B703285297;
	Wed, 17 Apr 2024 23:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JS0fmU7U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D97179C8
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 23:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395508; cv=none; b=W06IvyraJrW9USjretgZx4Us3v6wEd6WRVpQZe6RpI4dRkhfjeC2BOWuwELAGzLhAepVk8oLkH2ne4FZxQatjisbIEkrtMPgTnqyUXNpAhfG7VRJhQWtDOQBAqLZ4hrWu55jFYbMO0RqcD6ZcDOPyGhfkBIeeF/9a6aI2CTG310=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395508; c=relaxed/simple;
	bh=oNdCx80C856RTWnN8JuE5CtARwLd5sIwDWjLYgG9s5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FC1eNe4po4BbCjpN6l3W6YESZo4/PHFqilRi7wjaINWsNGi54TkuuavHkGq049F+Py29Tu9EVxdD7ZNHzxJzLYYyu/Wigm9PS9uTM0GOioWmSnMDDEofKniajleV9Swsl/WbtTb4Cc5czVt9rIP2DjkkiX/4qdMjawCfK38UKdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JS0fmU7U; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ed691fb83eso299311b3a.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713395506; x=1714000306; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WDEQNAoYNlRT/tCG4E+zr2OPdV3cIDvK0F0Tz/De9sE=;
        b=JS0fmU7UpKcCzkW4Lg2i+ICBWO8xwvLpNcw/xUfYgi91wLtQXA2S5zXAJGxptZr0Zj
         z4Ehvz89tdnvD9O+6aEHhMq1bRZIgWi9YmZrabwxPP96WNhQfSnbqfPN2tQSaZFv8hvK
         Y5ylB4yzyvtv8/Jh0jS5lz6J5O+F8/vSoSBEF6lRnxiO0pl3+XG4ZyENwDYO2axeil8b
         XlR/xqdEfd90x8uqzwV5lZYS0YMHUy5Lk3i6Bpl4tZmNq/w2t2hPIze6dlaF+PU+4Lks
         LXQ0rWaqsiXX63oiKvbplRdK6sTh8JIPP1Hh2XEQjZpSHimFDmCiYLv9ACJ++SdPF2QW
         OpqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713395506; x=1714000306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDEQNAoYNlRT/tCG4E+zr2OPdV3cIDvK0F0Tz/De9sE=;
        b=f/uUkQIb9WfrF7cA3f4cJcuOp2LdcmWqpLym2ZHsV0wTY6RERbBSBOWsNaJJZnSWqu
         fLly8Vxnyx3E0f31odzJVQcxpZkHkBhFjZxSrGGSroGPg3UqTUjM0QJx0BQTn+xYq+Jz
         BdoRADieNwTgbJniyzy+nAHBIfDMMjmjHahW9ZtEE3+jNSXMOwWE5lYh5Zo3kVfyvQBf
         SU/g0+UmhA/PiW3iBT+kwBOZY3nidyTG/DwS6PXhC1OYC2gJXvObpETNTFHx5EXsklPM
         vcRpSJRFMQmvKZjxcVc0g3Z/sTPKe5WSyBLlCXYjliKCszl5niq2PRGpB/2rfkiRWxgH
         nAmA==
X-Forwarded-Encrypted: i=1; AJvYcCXJly0zsooh1tOncH9T78MMUexTWVaEmSwMOLtecoKKCD+wSOPyfzcxxvW+FyMprspyiH2bjC3GdaTKIO6+L88fYkFG
X-Gm-Message-State: AOJu0YyXE0mHeHyb1oKs3MRfVBkBcy8sqoDkCgXIvuj10Oqd6ZTunAsj
	Xka7NHrX20geNEQNeeBlBTuNFZVeBhNtMJwUZqQDDEhwAySC8hhEZVxErtll0w==
X-Google-Smtp-Source: AGHT+IHiJTrHCyJ+purlro9U8tyOMuKDMSMjZou53yWbw6hoOBMZed+uj11RDumfPQug4qIVeJVtAg==
X-Received: by 2002:a05:6a21:2b13:b0:1aa:6612:fea5 with SMTP id ss19-20020a056a212b1300b001aa6612fea5mr1217099pzb.59.1713395505389;
        Wed, 17 Apr 2024 16:11:45 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902bd8500b001db8145a1a2sm170114pls.274.2024.04.17.16.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 16:11:44 -0700 (PDT)
Date: Wed, 17 Apr 2024 23:11:39 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: msr: Remove the loop for testing
 reserved bits in MSR_IA32_FLUSH_CMD
Message-ID: <ZiBXK43AcxAxKuSE@google.com>
References: <20240415172542.1830566-1-mizhang@google.com>
 <Zh6liyoOJL9_Wifg@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh6liyoOJL9_Wifg@google.com>

On Tue, Apr 16, 2024, Sean Christopherson wrote:
> On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> > Avoid testing reserved bits in MSR_IA32_FLUSH_CMD. Since KVM passes through
> > the MSR at runtime, testing reserved bits directly touches the HW and
> > should generate #GP. However, some older CPU models like skylake with
> > certain FMS do not generate #GP.
> > 
> > Ideally, it could be fixed by enumerating all such CPU models. The value
> > added is would be low. So just remove the testing loop and allow the test
> > pass.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  x86/msr.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/x86/msr.c b/x86/msr.c
> > index 3a041fab..76c80d29 100644
> > --- a/x86/msr.c
> > +++ b/x86/msr.c
> > @@ -302,8 +302,6 @@ static void test_cmd_msrs(void)
> >  		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", 0);
> >  		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
> >  	}
> > -	for (i = 1; i < 64; i++)
> > -		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
> 
> Rather than remove this entirely, what forcing emulation?  E.g. (compile tested
> only, and haven't verified all macros)

For sure. Nice, thank you! I think this FEP thing also benefits other
tests like PMU.

Thanks.
-Mingwei
> 
> ---
>  lib/x86/desc.h      | 30 ++++++++++++++++++++++++------
>  lib/x86/processor.h | 18 ++++++++++++++----
>  x86/msr.c           | 16 +++++++++++++++-
>  3 files changed, 53 insertions(+), 11 deletions(-)
> 
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index 7778a0f8..92c45a48 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -272,9 +272,9 @@ extern gdt_entry_t *get_tss_descr(void);
>  extern unsigned long get_gdt_entry_base(gdt_entry_t *entry);
>  extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
>  
> -#define asm_safe(insn, inputs...)					\
> +#define __asm_safe(fep, insn, inputs...)				\
>  ({									\
> -	asm volatile(ASM_TRY("1f")					\
> +	asm volatile(__ASM_TRY(fep, "1f")				\
>  		     insn "\n\t"					\
>  		     "1:\n\t"						\
>  		     :							\
> @@ -283,9 +283,15 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
>  	exception_vector();						\
>  })
>  
> -#define asm_safe_out1(insn, output, inputs...)				\
> +#define asm_safe(insn, inputs...)					\
> +	__asm_safe("", insn, inputs)
> +
> +#define asm_fep_safe(insn, output, inputs...)				\
> +	__asm_safe_out1(KVM_FEP, insn, output, inputs)
> +
> +#define __asm_safe_out1(fep, insn, output, inputs...)			\
>  ({									\
> -	asm volatile(ASM_TRY("1f")					\
> +	asm volatile(__ASM_TRY(fep, "1f")				\
>  		     insn "\n\t"					\
>  		     "1:\n\t"						\
>  		     : output						\
> @@ -294,9 +300,15 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
>  	exception_vector();						\
>  })
>  
> -#define asm_safe_out2(insn, output1, output2, inputs...)		\
> +#define asm_safe_out1(insn, output, inputs...)				\
> +	__asm_safe_out1("", insn, output, inputs)
> +
> +#define asm_fep_safe_out1(insn, output, inputs...)			\
> +	__asm_safe_out1(KVM_FEP, insn, output, inputs)
> +
> +#define __asm_safe_out2(fep, insn, output1, output2, inputs...)		\
>  ({									\
> -	asm volatile(ASM_TRY("1f")					\
> +	asm volatile(__ASM_TRY(fep, "1f")				\
>  		     insn "\n\t"					\
>  		     "1:\n\t"						\
>  		     : output1, output2					\
> @@ -305,6 +317,12 @@ extern unsigned long get_gdt_entry_limit(gdt_entry_t *entry);
>  	exception_vector();						\
>  })
>  
> +#define asm_safe_out2(fep, insn, output1, output2, inputs...)		\
> +	__asm_safe_out2("", insn, output1, output2, inputs)
> +
> +#define asm_fep_safe_out2(insn, output1, output2, inputs...)		\
> +	__asm_safe_out2(KVM_FEP, insn, output1, output2, inputs)
> +
>  #define __asm_safe_report(want, insn, inputs...)			\
>  do {									\
>  	int vector = asm_safe(insn, inputs);				\
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 44f4fd1e..d20496c0 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -430,12 +430,12 @@ static inline void wrmsr(u32 index, u64 val)
>  	asm volatile ("wrmsr" : : "a"(a), "d"(d), "c"(index) : "memory");
>  }
>  
> -#define rdreg64_safe(insn, index, val)					\
> +#define __rdreg64_safe(fep, insn, index, val)				\
>  ({									\
>  	uint32_t a, d;							\
>  	int vector;							\
>  									\
> -	vector = asm_safe_out2(insn, "=a"(a), "=d"(d), "c"(index));	\
> +	vector = __asm_safe_out2(fep, insn, "=a"(a), "=d"(d), "c"(index));\
>  									\
>  	if (vector)							\
>  		*(val) = 0;						\
> @@ -444,13 +444,18 @@ static inline void wrmsr(u32 index, u64 val)
>  	vector;								\
>  })
>  
> -#define wrreg64_safe(insn, index, val)					\
> +#define rdreg64_safe(insn, index, val)					\
> +	__rdreg64_safe("", insn, index, val)
> +
> +#define __wrreg64_safe(fep, insn, index, val)				\
>  ({									\
>  	uint32_t eax = (val), edx = (val) >> 32;			\
>  									\
> -	asm_safe(insn, "a" (eax), "d" (edx), "c" (index));		\
> +	__asm_safe(fep, insn, "a" (eax), "d" (edx), "c" (index));	\
>  })
>  
> +#define wrreg64_safe(insn, index, val)					\
> +	__wrreg64_safe("", insn, index, val)
>  
>  static inline int rdmsr_safe(u32 index, uint64_t *val)
>  {
> @@ -462,6 +467,11 @@ static inline int wrmsr_safe(u32 index, u64 val)
>  	return wrreg64_safe("wrmsr", index, val);
>  }
>  
> +static inline int wrmsr_fep_safe(u32 index, u64 val)
> +{
> +	return __wrreg64_safe(KVM_FEP, "wrmsr", index, val);
> +}
> +
>  static inline int rdpmc_safe(u32 index, uint64_t *val)
>  {
>  	return rdreg64_safe("rdpmc", index, val);
> diff --git a/x86/msr.c b/x86/msr.c
> index 3a041fab..2830530b 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -112,6 +112,16 @@ static void test_rdmsr_fault(u32 msr, const char *name)
>  	       "Expected #GP on RDSMR(%s), got vector %d", name, vector);
>  }
>  
> +static void test_wrmsr_fep_fault(u32 msr, const char *name,
> +				 unsigned long long val)
> +{
> +	unsigned char vector = wrmsr_fep_safe(msr, val);
> +
> +	report(vector == GP_VECTOR,
> +	       "Expected #GP on emulated WRSMR(%s, 0x%llx), got vector %d",
> +	       name, val, vector);
> +}
> +
>  static void test_msr(struct msr_info *msr, bool is_64bit_host)
>  {
>  	if (is_64bit_host || !msr->is_64bit_only) {
> @@ -302,8 +312,12 @@ static void test_cmd_msrs(void)
>  		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", 0);
>  		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
>  	}
> +
> +	if (!is_fep_available())
> +		return;
> +
>  	for (i = 1; i < 64; i++)
> -		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
> +		test_wrmsr_fep_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
>  }
>  
>  int main(int ac, char **av)
> 
> base-commit: 38135e08a580b9f3696f9b4ae5ca228dc71a1a56
> -- 
> 

