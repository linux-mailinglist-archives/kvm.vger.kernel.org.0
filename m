Return-Path: <kvm+bounces-40833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AEB0A5E1C8
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 17:29:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10A4E189F310
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 16:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408F223ED56;
	Wed, 12 Mar 2025 16:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pVFgoTVC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D4F1DFF7
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741796957; cv=none; b=hMMh4g0JJMuFCY7uEEHmg5dneVWLt2PhYYsA8EWMp8RO0l0IQkQi0BLTpbwkaNKEVdJe/OLxUwq7PkCGKJbxczH5bAboeggT4YG0GKnmvFSa1SGddOU+ctrMgOiccyDzdNQItjJQw5PAIMyGk2Q+RFIdon9r1eFeLSnEL1CHdQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741796957; c=relaxed/simple;
	bh=mWGhI49i6UgGfjNzGzJkbGoCU3DcP3jqtupC6ccNRAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQsOPa+5dBs+UdA6piczsMDc1I2Ocf7y6mpUziO4LYHv1sMk+mtW81yqaUGDCTd6JWQNIAK7RwSz0yE1J7nOuk7ZJJBhq9LKFuNI8XKsKAXUyanPjSwVMIM9Nh2fJN79mvTF60tudFf8yU8D9eA2khhLaX2JNldOdA4g7FOfjrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pVFgoTVC; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4394036c0efso42357495e9.2
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 09:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741796952; x=1742401752; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fOnSpbCHIVScbDy74xUesrpWh1zALxdGl2tg20/LxlI=;
        b=pVFgoTVCCg/OncDFEL6yAntENqSsdSOyArApxSNH8smBSzpFOog0CEsaq3kHzkG9hP
         HLW5ATRy0tReYSgI+vxqNg0qx385Fzh9zTy3ADYj/c0oPm1ESaVXWpX3HNzqnZTjqwnE
         3IvnRu711hNMr3pPxbeOpECxJ+FsLxIQR9YEElqob9wWt+K9674RuZVK9JyJmf78gU51
         PpY0LXWqFTrf+9sgnofjm5arEADhVF0bxq5zxjgeqUrt5EhjyYtyrltuKsEnpYtPGyWC
         gP0Tmh+0XN1e7LGkcNY+8iBdH+xXOjeBu96sEC/8YMSx236s72zZp8k65/NuBptYNJZ4
         mV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741796952; x=1742401752;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fOnSpbCHIVScbDy74xUesrpWh1zALxdGl2tg20/LxlI=;
        b=vusA+d+c2jScDdgq3dOCzk8hvZpVGv2jDIx2TWT2w1IgfRceES0YEZ0UaoQxGFTGs1
         LYJa/T0H4nvnPBEyNgZdzx5ZJCzoUWQ3BL2yYYU0/1lJb7+U/PrOdf0R+uGkjQ6Sh4Cg
         WsQvvlPagXlGlZ1D1lmrcZnzS/4HiI6fvtXQ6eX5OyZQHVUdjehewV1WvRfJe1mwMd6t
         TD+Ho5rdvrLTk5bzqcCMnl9pitfst8uGY18CoKo+hfH9Kc1Eo+mgKGUYIveYhSEXBdpJ
         Ya96RGhhoksX+LEBP+gUZ8THSD4HDT+n0u4sLzghqIfn8Mvj3/G5KvBb23WshCQAdAqi
         mdHQ==
X-Gm-Message-State: AOJu0Yz+zPMghHfIuRKyWDI+jez93UCZBf+YrUWVSW8voF5W/A+FGX8f
	n7QXuS6hR9z6vJmru/mN+1gzgXmmG8rPQ5RMiFOTriQIWs/kIn1qiq2u5XM6jA0=
X-Gm-Gg: ASbGncsrftIj878ASKj3amby0UBhkJbZDIFCtWJ8EcwF7yDGLpIZ0iuwXnwhOj/D+vd
	s3HRzC0z/VXz1IAZS7iV8MYb81jT+UhmkYNV7CHR+DF1vMkwOpZUPekHiIgcOCHDmy02cYApus/
	oLYMaO1lo7UKEcKhtJm+2SHFwx/DciFIaLgi+MtiBJwgxS4tXPhmLQN66LtkQj7G0y6VI05HmU1
	ceRxk8G998whyB019ZpktZa2vjfLpMiv2ilY1KkJj2YcXPUfVytQ5fVlGoRrtWuXfUBCQbY+89L
	rZXRw0MFWWQhfGUzLKP44K20BHdONjYO
X-Google-Smtp-Source: AGHT+IHc8EpNIG4cxuPPSWYSwyRFGGdAIA0LCRbEBlPg4hgpbqDCLbDFmReBz0mcS83oLAFqOhYDNQ==
X-Received: by 2002:a5d:648f:0:b0:391:3150:96ff with SMTP id ffacd0b85a97d-39132d57d7emr17431954f8f.32.1741796952214;
        Wed, 12 Mar 2025 09:29:12 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d0a72eeecsm26070745e9.3.2025.03.12.09.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 09:29:11 -0700 (PDT)
Date: Wed, 12 Mar 2025 17:29:10 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v8 5/6] lib: riscv: Add SBI SSE support
Message-ID: <20250312-cf0b7348207165c9dceddd56@orel>
References: <20250307161549.1873770-1-cleger@rivosinc.com>
 <20250307161549.1873770-6-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250307161549.1873770-6-cleger@rivosinc.com>

On Fri, Mar 07, 2025 at 05:15:47PM +0100, Clément Léger wrote:
> Add support for registering and handling SSE events. This will be used
> by sbi test as well as upcoming double trap tests.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/Makefile          |   1 +
>  lib/riscv/asm/csr.h     |   1 +
>  lib/riscv/asm/sbi.h     |  38 ++++++++++++++-
>  lib/riscv/sbi-sse-asm.S | 103 ++++++++++++++++++++++++++++++++++++++++
>  lib/riscv/asm-offsets.c |   9 ++++
>  lib/riscv/sbi.c         |  76 +++++++++++++++++++++++++++++
>  6 files changed, 227 insertions(+), 1 deletion(-)
>  create mode 100644 lib/riscv/sbi-sse-asm.S
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 02d2ac39..16fc125b 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -43,6 +43,7 @@ cflatobjs += lib/riscv/setup.o
>  cflatobjs += lib/riscv/smp.o
>  cflatobjs += lib/riscv/stack.o
>  cflatobjs += lib/riscv/timer.o
> +cflatobjs += lib/riscv/sbi-sse-asm.o
>  ifeq ($(ARCH),riscv32)
>  cflatobjs += lib/ldiv32.o
>  endif
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index c7fc87a9..3e4b5fca 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -17,6 +17,7 @@
>  #define CSR_TIME		0xc01
>  
>  #define SR_SIE			_AC(0x00000002, UL)
> +#define SR_SPP			_AC(0x00000100, UL)
>  
>  /* Exception cause high bit - is an interrupt if set */
>  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 780c9edd..acef8a5e 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -230,5 +230,41 @@ struct sbiret sbi_send_ipi_broadcast(void);
>  struct sbiret sbi_set_timer(unsigned long stime_value);
>  long sbi_probe(int ext);
>  
> -#endif /* !__ASSEMBLER__ */
> +typedef void (*sbi_sse_handler_fn)(void *data, struct pt_regs *regs, unsigned int hartid);
> +
> +struct sbi_sse_handler_arg {
> +	unsigned long reg_tmp;
> +	sbi_sse_handler_fn handler;
> +	void *handler_data;
> +	void *stack;
> +};
> +
> +extern void sbi_sse_entry(void);
> +
> +static inline bool sbi_sse_event_is_global(uint32_t event_id)
> +{
> +	return !!(event_id & SBI_SSE_EVENT_GLOBAL_BIT);
> +}
> +
> +struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
> +				     unsigned long attr_count, unsigned long phys_lo,
> +				     unsigned long phys_hi);
> +struct sbiret sbi_sse_read_attrs(unsigned long event_id, unsigned long base_attr_id,
> +				 unsigned long attr_count, unsigned long *values);
> +struct sbiret sbi_sse_write_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
> +				      unsigned long attr_count, unsigned long phys_lo,
> +				      unsigned long phys_hi);
> +struct sbiret sbi_sse_write_attrs(unsigned long event_id, unsigned long base_attr_id,
> +				  unsigned long attr_count, unsigned long *values);
> +struct sbiret sbi_sse_register_raw(unsigned long event_id, unsigned long entry_pc,
> +				   unsigned long entry_arg);
> +struct sbiret sbi_sse_register(unsigned long event_id, struct sbi_sse_handler_arg *arg);
> +struct sbiret sbi_sse_unregister(unsigned long event_id);
> +struct sbiret sbi_sse_enable(unsigned long event_id);
> +struct sbiret sbi_sse_disable(unsigned long event_id);
> +struct sbiret sbi_sse_hart_mask(void);
> +struct sbiret sbi_sse_hart_unmask(void);
> +struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id);
> +
> +#endif /* !__ASSEMBLY__ */

When rebasing on latest master this should have been left as
__ASSEMBLER__

>  #endif /* _ASMRISCV_SBI_H_ */
> diff --git a/lib/riscv/sbi-sse-asm.S b/lib/riscv/sbi-sse-asm.S
> new file mode 100644
> index 00000000..e4efd1ff
> --- /dev/null
> +++ b/lib/riscv/sbi-sse-asm.S
> @@ -0,0 +1,103 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * RISC-V SSE events entry point.
> + *
> + * Copyright (C) 2025, Rivos Inc., Clément Léger <cleger@rivosinc.com>
> + */
> +#define __ASSEMBLY__

__ASSEMBLER__

> +#include <asm/asm.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/csr.h>
> +#include <generated/sbi-asm-offsets.h>
> +
> +.section .text
> +.global sbi_sse_entry
> +sbi_sse_entry:
> +	/* Save stack temporarily */
> +	REG_S	sp, SBI_SSE_REG_TMP(a7)
> +	/* Set entry stack */
> +	REG_L	sp, SBI_SSE_HANDLER_STACK(a7)
> +
> +	addi	sp, sp, -(PT_SIZE)
> +	REG_S	ra, PT_RA(sp)
> +	REG_S	s0, PT_S0(sp)
> +	REG_S	s1, PT_S1(sp)
> +	REG_S	s2, PT_S2(sp)
> +	REG_S	s3, PT_S3(sp)
> +	REG_S	s4, PT_S4(sp)
> +	REG_S	s5, PT_S5(sp)
> +	REG_S	s6, PT_S6(sp)
> +	REG_S	s7, PT_S7(sp)
> +	REG_S	s8, PT_S8(sp)
> +	REG_S	s9, PT_S9(sp)
> +	REG_S	s10, PT_S10(sp)
> +	REG_S	s11, PT_S11(sp)
> +	REG_S	tp, PT_TP(sp)
> +	REG_S	t0, PT_T0(sp)
> +	REG_S	t1, PT_T1(sp)
> +	REG_S	t2, PT_T2(sp)
> +	REG_S	t3, PT_T3(sp)
> +	REG_S	t4, PT_T4(sp)
> +	REG_S	t5, PT_T5(sp)
> +	REG_S	t6, PT_T6(sp)
> +	REG_S	gp, PT_GP(sp)
> +	REG_S	a0, PT_A0(sp)
> +	REG_S	a1, PT_A1(sp)
> +	REG_S	a2, PT_A2(sp)
> +	REG_S	a3, PT_A3(sp)
> +	REG_S	a4, PT_A4(sp)
> +	REG_S	a5, PT_A5(sp)
> +	csrr	a1, CSR_SEPC
> +	REG_S	a1, PT_EPC(sp)
> +	csrr	a2, CSR_SSTATUS
> +	REG_S	a2, PT_STATUS(sp)
> +
> +	REG_L	a0, SBI_SSE_REG_TMP(a7)
> +	REG_S	a0, PT_SP(sp)
> +
> +	REG_L	t0, SBI_SSE_HANDLER(a7)
> +	REG_L	a0, SBI_SSE_HANDLER_DATA(a7)
> +	mv	a1, sp
> +	mv	a2, a6
> +	jalr	t0
> +
> +	REG_L	a1, PT_EPC(sp)
> +	REG_L	a2, PT_STATUS(sp)
> +	csrw	CSR_SEPC, a1
> +	csrw	CSR_SSTATUS, a2
> +
> +	REG_L	ra, PT_RA(sp)
> +	REG_L	s0, PT_S0(sp)
> +	REG_L	s1, PT_S1(sp)
> +	REG_L	s2, PT_S2(sp)
> +	REG_L	s3, PT_S3(sp)
> +	REG_L	s4, PT_S4(sp)
> +	REG_L	s5, PT_S5(sp)
> +	REG_L	s6, PT_S6(sp)
> +	REG_L	s7, PT_S7(sp)
> +	REG_L	s8, PT_S8(sp)
> +	REG_L	s9, PT_S9(sp)
> +	REG_L	s10, PT_S10(sp)
> +	REG_L	s11, PT_S11(sp)
> +	REG_L	tp, PT_TP(sp)
> +	REG_L	t0, PT_T0(sp)
> +	REG_L	t1, PT_T1(sp)
> +	REG_L	t2, PT_T2(sp)
> +	REG_L	t3, PT_T3(sp)
> +	REG_L	t4, PT_T4(sp)
> +	REG_L	t5, PT_T5(sp)
> +	REG_L	t6, PT_T6(sp)
> +	REG_L	gp, PT_GP(sp)
> +	REG_L	a0, PT_A0(sp)
> +	REG_L	a1, PT_A1(sp)
> +	REG_L	a2, PT_A2(sp)
> +	REG_L	a3, PT_A3(sp)
> +	REG_L	a4, PT_A4(sp)
> +	REG_L	a5, PT_A5(sp)
> +
> +	REG_L	sp, PT_SP(sp)
> +
> +	li	a7, ASM_SBI_EXT_SSE
> +	li	a6, ASM_SBI_EXT_SSE_COMPLETE
> +	ecall
> +
> diff --git a/lib/riscv/asm-offsets.c b/lib/riscv/asm-offsets.c
> index 6c511c14..a96c6e97 100644
> --- a/lib/riscv/asm-offsets.c
> +++ b/lib/riscv/asm-offsets.c
> @@ -3,6 +3,7 @@
>  #include <elf.h>
>  #include <asm/processor.h>
>  #include <asm/ptrace.h>
> +#include <asm/sbi.h>
>  #include <asm/smp.h>
>  
>  int main(void)
> @@ -63,5 +64,13 @@ int main(void)
>  	OFFSET(THREAD_INFO_HARTID, thread_info, hartid);
>  	DEFINE(THREAD_INFO_SIZE, sizeof(struct thread_info));
>  
> +	DEFINE(ASM_SBI_EXT_SSE, SBI_EXT_SSE);
> +	DEFINE(ASM_SBI_EXT_SSE_COMPLETE, SBI_EXT_SSE_COMPLETE);
> +
> +	OFFSET(SBI_SSE_REG_TMP, sbi_sse_handler_arg, reg_tmp);
> +	OFFSET(SBI_SSE_HANDLER, sbi_sse_handler_arg, handler);
> +	OFFSET(SBI_SSE_HANDLER_DATA, sbi_sse_handler_arg, handler_data);
> +	OFFSET(SBI_SSE_HANDLER_STACK, sbi_sse_handler_arg, stack);
> +
>  	return 0;
>  }
> diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
> index 02dd338c..1752c916 100644
> --- a/lib/riscv/sbi.c
> +++ b/lib/riscv/sbi.c
> @@ -2,6 +2,7 @@
>  #include <libcflat.h>
>  #include <cpumask.h>
>  #include <limits.h>
> +#include <asm/io.h>
>  #include <asm/sbi.h>
>  #include <asm/setup.h>
>  
> @@ -31,6 +32,81 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>  	return ret;
>  }
>  
> +struct sbiret sbi_sse_read_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
> +				     unsigned long attr_count, unsigned long phys_lo,
> +				      unsigned long phys_hi)
                   extra space here ^

> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_READ_ATTRS, event_id, base_attr_id, attr_count,
> +			 phys_lo, phys_hi, 0);
> +}
> +
> +struct sbiret sbi_sse_read_attrs(unsigned long event_id, unsigned long base_attr_id,
> +				 unsigned long attr_count, unsigned long *values)
> +{
> +	phys_addr_t p = virt_to_phys(values);
> +
> +	return sbi_sse_read_attrs_raw(event_id, base_attr_id, attr_count, lower_32_bits(p),
> +				      upper_32_bits(p));
> +}
> +
> +struct sbiret sbi_sse_write_attrs_raw(unsigned long event_id, unsigned long base_attr_id,
> +				      unsigned long attr_count, unsigned long phys_lo,
> +				      unsigned long phys_hi)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_WRITE_ATTRS, event_id, base_attr_id, attr_count,
> +			 phys_lo, phys_hi, 0);
> +}
> +
> +struct sbiret sbi_sse_write_attrs(unsigned long event_id, unsigned long base_attr_id,
> +				  unsigned long attr_count, unsigned long *values)
> +{
> +	phys_addr_t p = virt_to_phys(values);
> +
> +	return sbi_sse_write_attrs_raw(event_id, base_attr_id, attr_count, lower_32_bits(p),
> +				       upper_32_bits(p));
> +}
> +
> +struct sbiret sbi_sse_register_raw(unsigned long event_id, unsigned long entry_pc,
> +				   unsigned long entry_arg)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_REGISTER, event_id, entry_pc, entry_arg, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_register(unsigned long event_id, struct sbi_sse_handler_arg *arg)
> +{
> +	return sbi_sse_register_raw(event_id, (unsigned long) sbi_sse_entry, (unsigned long) arg);

nit: no spaces after casts

> +}
> +
> +struct sbiret sbi_sse_unregister(unsigned long event_id)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_UNREGISTER, event_id, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_enable(unsigned long event_id)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_ENABLE, event_id, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_disable(unsigned long event_id)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_DISABLE, event_id, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_hart_mask(void)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_MASK, 0, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_hart_unmask(void)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_HART_UNMASK, 0, 0, 0, 0, 0, 0);
> +}
> +
> +struct sbiret sbi_sse_inject(unsigned long event_id, unsigned long hart_id)
> +{
> +	return sbi_ecall(SBI_EXT_SSE, SBI_EXT_SSE_INJECT, event_id, hart_id, 0, 0, 0, 0);
> +}
> +
>  void sbi_shutdown(void)
>  {
>  	sbi_ecall(SBI_EXT_SRST, 0, 0, 0, 0, 0, 0, 0);
> -- 
> 2.47.2
>

Thanks,
drew

