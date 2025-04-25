Return-Path: <kvm+bounces-44322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA6AA9CA7C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 15:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DFBB1892AC3
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 13:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531C625229A;
	Fri, 25 Apr 2025 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Pw1N19uc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9580B2F85B
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 13:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745588039; cv=none; b=EFzLQ2F0b5ITVMEUvopMqyrCvMCRTArKQHFuFWtIfDaCssFDRIeHsnanelu+YnDc7U9xNgGrrS0e46RJOGTAAxCg0tr4sugkh534Rs2DMSdIbjouJvvidGbBaG1uvnIKNy0E8lFS5pPtxBlAwwoeZM+nxyW5VaM4pArHHLrD1Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745588039; c=relaxed/simple;
	bh=cduZd8Ltq5422qMan5ANCK5a+bkT5I0nJA5znBziT9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpUYD/UUoAJVd2eK6Y/1/nUrDFcxcYmQmyvegftXUM/lyaWLjrkX7p+ICIJrHyFyRPyudzrSnqPMuTJym2rJ1GjHI0fRxeDn4jAUl9Hr7YAdGEfA2dWts6YgQBiCj2xBF33EFUKUyWLmO69M0RsZX2ed3ECN9PvqgWnD+TqLzyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Pw1N19uc; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39c266c1389so1606126f8f.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 06:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745588036; x=1746192836; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fvxSe8a/Se9B7XO1sswsds6D5F7SBQkR6pj1GPZGuF4=;
        b=Pw1N19ucwGhqAJdGkL62h6/+hmhQcY2/cCmKVMpDC1L7PsS56S7nIwFkEJgV8JTBXq
         u9+hKmZBcKFnImyQviGrDxPzguGM9zumbxkjXalN9eE9PEs7dSMGDIzZ/jC1m7E0P78g
         poEsVvzXyHHXeRGwHDBKHL+FhAjnyWK6md/7TlIh39e3QMKwGrC4W+2uTdHp5u83TKuL
         kVuX6fnO6g1aXnKlvUqjA2nLkJPgyJkufmrZiIFoC9tzDq6g7tJEIvkWtYXt/04RIXk4
         7BCpw24SG1pDqge6qxBpl8NaFYqOO8eW70b59oCl+CaX3oiDsFx4o+PdzY+AOBMXrr99
         fnxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745588036; x=1746192836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvxSe8a/Se9B7XO1sswsds6D5F7SBQkR6pj1GPZGuF4=;
        b=dQ9e1jEjpiR04rskBS6t41SH1nhJquJYsW7m/2dPtY4dPJwiK4nzyrq2IzgoUKGeM4
         tHTd+Z703IsowmjxceGpXvcnXgVR9K+1y9QRL4SZRKlgBshRXp42i5hIRUuE+A8Ie5ze
         gDfyzGNDPu2ATF3q3/qwSSd3XjJQMP5wORrHnenP/KfvxSE+Ev5rSDrqziY3ScFEXNDs
         ZicblmBTvN5TYjQs/70tjr2o43CFtXOKsW/sLk5XQgfkoVXukFE75NrfgrIC2hqifPZ4
         QkPo5bry8Nfj8HadvaflsL3JzQPVrHE14sOCydxkU2CqBDDUsbrI/QZJQHxfbVPjSTkh
         S/4g==
X-Forwarded-Encrypted: i=1; AJvYcCWmomjP3Dafkt0TEjaUSPdPVfhJrdDQAnqfiOTbv1lNSDmHiqFc5mxuW5JTNAqFwbdwiYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YylMFKVuYhojPa3xEkfYvPUfFtsj4zBdkjBIT2mNS4qxk6NT1ww
	7WQZsnxPzwHVtWPe9U4n25LnSLQaB8Dog4t3PtMK/P1+0NVWYwpYAW/llLY6Pxo=
X-Gm-Gg: ASbGncvPGPmiCJccHxvJFae4jA84s2W18t6Exc42UwiPWPDDycbPUZ6z/CefJs9Ymnq
	c2rSqFSgwMc2f3MIYPyaL/uEfg8St3om0X456KX/i4Ik1SmBq6ii4juMpKlECkbjEolRPsYr6vD
	9vcrgIPyzJTj45i2pw5A99xy6hWL0DxsSXpI4zbDE5BmroXLN0jwi26ybZcQcRpzng1h8EjnLnx
	Ut0lcFGGLCTC7fSxy7/tKQ0sfdByNskyyTTFxTYO+iRGdkjqH5m+Qtkdxlu/G8FfG/ulczjkq1U
	LqzLiFZWbcxBHy+jDIiUqut0aTj+
X-Google-Smtp-Source: AGHT+IH345KXBx7WTUF/NPXxKh0vTQxkkkmRW+ErxhOe06A807pl+3G2m+RyiKZsRHwXpurwjK/pVQ==
X-Received: by 2002:a05:6000:1867:b0:391:3cb7:d441 with SMTP id ffacd0b85a97d-3a074e37776mr2084638f8f.25.1745588035744;
        Fri, 25 Apr 2025 06:33:55 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::f716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073ca4e50sm2467062f8f.30.2025.04.25.06.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 06:33:55 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:33:54 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: riscv: selftests: Decode stval to identify
 exact exception type
Message-ID: <20250425-f458b9801a83cc35bda55c74@orel>
References: <20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com>
 <20250324-kvm_selftest_improve-v1-2-583620219d4f@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324-kvm_selftest_improve-v1-2-583620219d4f@rivosinc.com>

On Mon, Mar 24, 2025 at 05:40:30PM -0700, Atish Patra wrote:
> Currently, the sbi_pmu_test continues if the exception type is illegal
> instruction because access to hpmcounter will generate that. However, we
> may get illegal for other reasons as well which should result in test
> assertion.
> 
> Use the stval to decode the exact type of instructions and which csrs are
> being accessed if it is csr access instructions. Assert in all cases
> except if it is a csr access instructions that access valid PMU related
> registers.
> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 32 ++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> index 03406de4989d..11bde69b5238 100644
> --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> @@ -128,11 +128,43 @@ static void stop_counter(unsigned long counter, unsigned long stop_flags)
>  		       "Unable to stop counter %ld error %ld\n", counter, ret.error);
>  }
>  
> +#define INSN_OPCODE_MASK	0x007c
> +#define INSN_OPCODE_SHIFT	2
> +#define INSN_OPCODE_SYSTEM	28
> +
> +#define INSN_MASK_FUNCT3	0x7000
> +#define INSN_SHIFT_FUNCT3	12
> +
> +#define INSN_CSR_MASK		0xfff00000
> +#define INSN_CSR_SHIFT		20
> +
> +#define GET_RM(insn)            (((insn) & INSN_MASK_FUNCT3) >> INSN_SHIFT_FUNCT3)
> +#define GET_CSR_NUM(insn)       (((insn) & INSN_CSR_MASK) >> INSN_CSR_SHIFT)

It'd be good to put these macros in include/riscv/processor.h or some new
include/riscv/ header to be shared with other tests that may want to
decode stval.

Thanks,
drew

> +
>  static void guest_illegal_exception_handler(struct ex_regs *regs)
>  {
> +	unsigned long insn;
> +	int opcode, csr_num, funct3;
> +
>  	__GUEST_ASSERT(regs->cause == EXC_INST_ILLEGAL,
>  		       "Unexpected exception handler %lx\n", regs->cause);
>  
> +	insn = regs->stval;
> +	opcode = (insn & INSN_OPCODE_MASK) >> INSN_OPCODE_SHIFT;
> +	__GUEST_ASSERT(opcode == INSN_OPCODE_SYSTEM,
> +		       "Unexpected instruction with opcode 0x%x insn 0x%lx\n", opcode, insn);
> +
> +	csr_num = GET_CSR_NUM(insn);
> +	funct3 = GET_RM(insn);
> +	/* Validate if it is a CSR read/write operation */
> +	__GUEST_ASSERT(funct3 <= 7 && (funct3 != 0 || funct3 != 4),
> +		       "Unexpected system opcode with funct3 0x%x csr_num 0x%x\n",
> +		       funct3, csr_num);
> +
> +	/* Validate if it is a HPMCOUNTER CSR operation */
> +	__GUEST_ASSERT(csr_num == CSR_CYCLE || csr_num <= CSR_HPMCOUNTER31,
> +		       "Unexpected csr_num 0x%x\n", csr_num);
> +
>  	illegal_handler_invoked = true;
>  	/* skip the trapping instruction */
>  	regs->epc += 4;
> 
> -- 
> 2.43.0
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

