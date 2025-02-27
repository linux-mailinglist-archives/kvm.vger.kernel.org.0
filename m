Return-Path: <kvm+bounces-39552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F962A4781C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 09:44:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A819188AC0E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0FE5225A34;
	Thu, 27 Feb 2025 08:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RHIADAo0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5920E2222A5
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 08:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740645861; cv=none; b=e7ZGi39xW08MPoi6FqpjLgr4SSOwQhdyXe91xybrBBkT2AwgOVavzzkiJkflwdQl3BvpfuvNKiQjEHascw+y+KS998oIzbLMN8734R/cfop5jDDi58GtYFKbS8NL6NOMCd7qFmogPMciB9qNmngSYItdmRPFiCvB7dKrz88h37M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740645861; c=relaxed/simple;
	bh=q5DyFV5gTaMxqJ16Z1qIG2jXFLnd0OlbWwYkvNtHfZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AakbFyhTs5ADE72ejbIevjqX5f1V20/WeEUUzKukqZKKj+OV/mcvCX/9rn3qhwIfsI+73GKt0hLrT3LCwqriCrT1vLRXlVA/NO6yXZrv8MdzXOjsGcgYTgayu1LZ4bd6iXNrs9XzLgqobjKSiI/aqAGI6YA20ByxfEkEWVQdYvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RHIADAo0; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4394036c0efso3973985e9.2
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740645858; x=1741250658; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0eD4WdY2Ar0Qpt9c3iLvWQtqo0+f9AP00jRPqQ8lu4I=;
        b=RHIADAo0VDugGIIeAcng1OLrH5DX8+FoJnJV6CA3b7I3oQKeOu9D15rnJfjHZNbPJ0
         iULCF9ZDS+pCiTLwTwTBAFfdPOBHs5Wc0Egy6mcUxj77XXKFOZPqkub6A1FD6hVACOp9
         TVFDHp1RRBvMe1DMB6ul0FSPNU0Fs3xX1CyBe4Iu0cuy3F0V5iYmA2x+vnAilHXl2dyO
         mGn3IgmNKNy3xDKsKEBkPFSbD/Nx70OWEt8GcBSTAl7uIMWWMc4l9cHMPlf9jK229Fxu
         fk6enje3N8CqylKl6I71O6+mcjZ8AOyttkU+T9vZXtvKLx4kr08M0FiN7YRy/dfpTTjq
         Dc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740645858; x=1741250658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0eD4WdY2Ar0Qpt9c3iLvWQtqo0+f9AP00jRPqQ8lu4I=;
        b=TR7oPh+UNE7FKJPWghSFrTT3i7RHecQIzCU/40TRJLazwXEf4RWzYVLr2jd99uCAyQ
         bYT42hEks9An1BqweAgxiv1sah/5Nn5Jztmm5luulQ1nKTce1jq5XP/imRgxYluNLWdn
         nSERa4hJYalnjvhvswCmBiqV7W1SRKmEHVXV/wUSyYnJgT0p/Z9wPeQIYS4juPuSW13i
         eJFbSj7iZFKTjMAcgjOm0GpmVONp+yI5zR8G0uRhlPM44Unscx+F2IPRh5+Gu4s/V+xk
         MAeSkKP6SoZnWmjGRmf8Y9Tpg7JlLZAgcOdso+q8EwH7k/McWvgSj2aIviX5a/Fy/BnT
         h4DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXu8zMFJF299T2M+QWsnDzsAYufmaEw8KFg3dKzjHQG8I49vUK/zl/t8MRBN3x4VLnQk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwyXW0yU9oTixMC9oZDzHq4KyorNYqPX9ooVVfmkQKrvmwDgPU
	HeBXmRRl41nl+bxjEJUjOUPHJ5Mqs4FijoMe1IT8gO6razHbHr5JHH0rQSnzUt0=
X-Gm-Gg: ASbGncs8UeGJgDzQA+YZwZ0LhBhnyggCOkkSGyw5tfaImL/t+v5yEEUSEjUUFhxFaD+
	Uj3he2RYvT0/2vT9LDcKEyhMiajxRzmtykFev1PwPXcw3k1YpRbt/pRDAHP9mwvmEhI2AdPBT7L
	xXTGodFgbmVRhbs93/joMfwxcblP08SDO9DLtVqnONskM7xXE3GRqVQ1gjZFdQQODGAef0+EZ4M
	FIm/Q38H7EemTlXs55bNCFN8mwifZxCEovW7Uq2D/Ph/0hVS94OBm5EfdPusJFd8JwuOkt0vKuq
	x0z2w13xJSOFnQ==
X-Google-Smtp-Source: AGHT+IG7ml0QUrxxm1q148UuaevZWwyImW/BG/iHf4sSOi4FAdGUGP1loq2o5+xFJijpyPDy5kgSvA==
X-Received: by 2002:a05:600c:3c86:b0:439:9377:fa29 with SMTP id 5b1f17b1804b1-43ab903fe5bmr54754285e9.31.1740645857622;
        Thu, 27 Feb 2025 00:44:17 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::8cf0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b736f990esm15612155e9.5.2025.02.27.00.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 00:44:16 -0800 (PST)
Date: Thu, 27 Feb 2025 09:44:15 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: riscv: selftests: Do not start the counter in
 the overflow handler
Message-ID: <20250227-3799414d0651c86f6a815046@orel>
References: <20250226-kvm_pmu_improve-v1-0-74c058c2bf6d@rivosinc.com>
 <20250226-kvm_pmu_improve-v1-2-74c058c2bf6d@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226-kvm_pmu_improve-v1-2-74c058c2bf6d@rivosinc.com>

On Wed, Feb 26, 2025 at 12:25:04PM -0800, Atish Patra wrote:
> There is no need to start the counter in the overflow handler as we
> intend to trigger precise number of LCOFI interrupts through these
> tests. The overflow irq handler has already stopped the counter. As
> a result, the stop call from the test function may return already
> supported error which is fine as well.
  ^ stopped

> 
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  tools/testing/selftests/kvm/riscv/sbi_pmu_test.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> index f45c0ecc902d..284bc80193bd 100644
> --- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> +++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
> @@ -118,8 +118,8 @@ static void stop_counter(unsigned long counter, unsigned long stop_flags)
>  
>  	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_STOP, counter, 1, stop_flags,
>  			0, 0, 0);
> -	__GUEST_ASSERT(ret.error == 0, "Unable to stop counter %ld error %ld\n",
> -			       counter, ret.error);
> +	__GUEST_ASSERT(ret.error == 0 || ret.error == SBI_ERR_ALREADY_STOPPED,
> +		       "Unable to stop counter %ld error %ld\n", counter, ret.error);
>  }
>  
>  static void guest_illegal_exception_handler(struct ex_regs *regs)
> @@ -137,7 +137,6 @@ static void guest_irq_handler(struct ex_regs *regs)
>  	unsigned int irq_num = regs->cause & ~CAUSE_IRQ_FLAG;
>  	struct riscv_pmu_snapshot_data *snapshot_data = snapshot_gva;
>  	unsigned long overflown_mask;
> -	unsigned long counter_val = 0;
>  
>  	/* Validate that we are in the correct irq handler */
>  	GUEST_ASSERT_EQ(irq_num, IRQ_PMU_OVF);
> @@ -151,10 +150,6 @@ static void guest_irq_handler(struct ex_regs *regs)
>  	GUEST_ASSERT(overflown_mask & 0x01);
>  
>  	WRITE_ONCE(vcpu_shared_irq_count, vcpu_shared_irq_count+1);
> -
> -	counter_val = READ_ONCE(snapshot_data->ctr_values[0]);
> -	/* Now start the counter to mimick the real driver behavior */
> -	start_counter(counter_in_use, SBI_PMU_START_FLAG_SET_INIT_VALUE, counter_val);
>  }
>  
>  static unsigned long get_counter_index(unsigned long cbase, unsigned long cmask,
> 
> -- 
> 2.43.0
>

Other than the commit message,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

