Return-Path: <kvm+bounces-46793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F4BAB9C4C
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CECDB7A2244
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 12:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E794623F40E;
	Fri, 16 May 2025 12:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Qt/ouTEV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390C723E34F
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 12:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747399154; cv=none; b=doitYY7Zc/8zdLNray7TGwJ587hp4MFIXn+qezo33XOAef/fT87eIalF076daWAZZvW2k4U5MBvY9qkOqmajI94G7srgueLAK0GZABX1Hpi6sp60l6G2HcFi5BctdfKd8rjqX+CqWc+CUhmzk4hEkmFA6icObt/H1ow1mXNSg1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747399154; c=relaxed/simple;
	bh=EJwk/S74Tk8TsCRaHdTbe0SsIDSdi41vlf8wb2CeuBA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=ffj4sYHN272B20TZk3OYqUOZwbLg5lKFjDM1MKzoJkt/kSrWeiMBJQ9M3cqrVHvEj9wnEsvY1UXmUzkt2O7Hquhgn3b25jtrIbYZ/hgkGX4Iy8QKhBq3i7xnbOTJwpZqoMQFkJyE9IqiapuUMk0Py09lgjvHUvsTF7sjT6SJrSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Qt/ouTEV; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad21a5466f6so617622266b.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 05:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1747399150; x=1748003950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7oP/zLljTZnogybPTM7wMGdNzWkdEVn7QUgHEuDqyw=;
        b=Qt/ouTEVLJDsHQ9aQJ3monBHWNLyVJTQHLcYS8FPvlnRdtdrRNNo/lUwrHdLggSrkW
         MJ+b94Ly1n5d7TWn8Wzr3L5ZhLA0XeNEWdRe6tWUVg7Evr8EMFTKBi1ZXxerUHQJJJrL
         xe/exjxZsZTSuYzosqot1huz+xrqUIgoZjV1A89+/a93ScE9jFeyI3P1GedxjcNTvN5t
         px+4yOWUzff90Pm8XJlrTV9NSZjVCT1ZAAUzc0/Nhq65efj9q3JUMX8qYrklmXNjn15J
         +6AtTKSBaViyM5F1+71Q8GrPve6d3rVOjHz2ZQiVjWCLRbCHh5UMSSDGQvHG8n+IPi0w
         auqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747399150; x=1748003950;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7oP/zLljTZnogybPTM7wMGdNzWkdEVn7QUgHEuDqyw=;
        b=Dl4IOeeXAaykBAqlorxZMf7oehrYi79m5OZTj3LSTUaQ5nwGiH/uWvz2k/nh9C45bW
         6jAkKC4E1B2i23AsVT5+hUcpexbeMRWzRAJFs+MbNZZEKIyBhHp6hoOTj/1dCZKjlC3Y
         5kJJ4fyx3Le4e86Yw/XwNzjUjhmLSJPpJUbQzNhQFqWhNkRliFHC/bT7z4ALNSPeWFWo
         YIGNcTvoTG8CIKxWccHEr6oqEPLZpsxGmfhSKY8HoIeyXPwYc6FZ5VkTjxtMtaRJ3iMU
         jaqLvrb1ppkPrKfmlLAZJYsb9auE6nFTMq+4eqkDeEzBZQWZRdVx8a1wegTUxoAWkrA0
         mbQw==
X-Forwarded-Encrypted: i=1; AJvYcCUUd626RoLZZgXygXNPidSqUIbC+2LIbefMrjFOwJXaGWG6HfSnvfdFKvqvcQDeAJDnMGM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0PdO3fZwhRna8aIaOs94kSdcnBrRgpAlKQ170Z2MiRhfkwKyF
	JM2gm2atex61ht1+zayRW7PLcREgZCaEdD0//u75aQ5ksXsQzSXVoLPBBnGD0fwHtpU=
X-Gm-Gg: ASbGncsW/ohch9Q1l+DDpOZWRh2bLPGjaXWtTxx0ucZU72hLO7TKQ575sIv7NHTOoeg
	K6qwzI9ycF0qOmu++4tmn97vSv90Dywp0pQqElJ7Qw0Jc6u6jvG6a0uNeo1e8yLblwvd6JAlSVR
	hkoO25JbD4PCQjftCo5AQYT51SjRQtx9GiaYMF3ZDLzrOQ/t0ZMvydae/Al8AjH7G2zC2PlpidX
	LA/joBsCg/C+q0tOA7akSLDqn86j08lwgScLQZcCMDTATHfSfl36xFsKiPqddwy1VwfdWNwa55b
	7H39hnmZ7ozW2y8jx8/HSaGD0WfEcNUwetc6UUEzStFtQvUjWqQKy7mIZg==
X-Google-Smtp-Source: AGHT+IEIP3JUo4/gXsU3fbvKdiE+stLoARyyOdwaLPtOpDK0xW0RFEgVI9pNgG5UTxsDu4I2grbQIg==
X-Received: by 2002:a17:907:3fa0:b0:ad4:f5f1:28cf with SMTP id a640c23a62f3a-ad50f82067fmr632543466b.25.1747399150339;
        Fri, 16 May 2025 05:39:10 -0700 (PDT)
Received: from ?IPv6:::1? ([2a00:11b1:101e:447e:2959:9e3d:ac05:c19d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d4383a6sm153554466b.120.2025.05.16.05.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 05:39:09 -0700 (PDT)
Date: Fri, 16 May 2025 14:39:06 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm-riscv@lists.infradead.org, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@rivosinc.com>
CC: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>,
 kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] RISC-V: KVM: Remove scounteren initialization
In-Reply-To: <CAAhSdy38s0WWc7Cv4KF+0_pGC3xKU3_PLgeedz7Pu04-xKm4jw@mail.gmail.com>
References: <20250515-fix_scounteren_vs-v3-1-729dc088943e@rivosinc.com> <CAAhSdy38s0WWc7Cv4KF+0_pGC3xKU3_PLgeedz7Pu04-xKm4jw@mail.gmail.com>
Message-ID: <70DD7215-76A0-493C-87CA-60A605842B44@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On May 16, 2025 2:18:18 PM GMT+02:00, Anup Patel <anup@brainfault=2Eorg> wr=
ote:
>On Fri, May 16, 2025 at 4:41=E2=80=AFAM Atish Patra <atishp@rivosinc=2Eco=
m> wrote:
>>
>> Scounteren CSR controls the direct access the hpmcounters and cycle/
>> instret/time from the userspace=2E It's the supervisor's responsibility
>> to set it up correctly for it's user space=2E They hypervisor doesn't
>> need to decide the policy on behalf of the supervisor=2E
>>
>> Signed-off-by: Atish Patra <atishp@rivosinc=2Ecom>
>> ---
>> Changes in v3:
>> - Removed the redundant declaration
>> - Link to v2: https://lore=2Ekernel=2Eorg/r/20250515-fix_scounteren_vs-=
v2-1-1fd8dc0693e8@rivosinc=2Ecom
>>
>> Changes in v2:
>> - Remove the scounteren initialization instead of just setting the TM b=
it=2E
>> - Link to v1: https://lore=2Ekernel=2Eorg/r/20250513-fix_scounteren_vs-=
v1-1-c1f52af93c79@rivosinc=2Ecom
>> ---
>>  arch/riscv/kvm/vcpu=2Ec | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/arch/riscv/kvm/vcpu=2Ec b/arch/riscv/kvm/vcpu=2Ec
>> index 60d684c76c58=2E=2E9bfaae9a11ea 100644
>> --- a/arch/riscv/kvm/vcpu=2Ec
>> +++ b/arch/riscv/kvm/vcpu=2Ec
>> @@ -111,7 +111,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>  {
>>         int rc;
>>         struct kvm_cpu_context *cntx;
>> -       struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch=2Eguest_reset_cs=
r;
>>
>>         spin_lock_init(&vcpu->arch=2Emp_state_lock);
>>
>> @@ -146,9 +145,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>         if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
>>                 return -ENOMEM;
>>
>> -       /* By default, make CY, TM, and IR counters accessible in VU mo=
de */
>> -       reset_csr->scounteren =3D 0x7;
>> -
>>         /* Setup VCPU timer */
>>         kvm_riscv_vcpu_timer_init(vcpu);
>>
>>
>> ---
>> base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
>> change-id: 20250513-fix_scounteren_vs-fdd86255c7b7
>> --
>
>Overall, this looks good=2E
>
>Reviewed-by: Anup Patel <anup@brainfault=2Eorg>
>
>Currently, the scounteren=2ETM bit is only set by the Linux SBI PMU
>driver but KVM RISC-V only provides SBI PMU for guest when
>Sscofpmf is available in host so we need the below hunk to
>completely get rid-off scounteren initialization in KVM RISC-V=2E
>
>diff --git a/arch/riscv/kernel/head=2ES b/arch/riscv/kernel/head=2ES
>index 356d5397b2a2=2E=2Ebdf3352acf4c 100644
>--- a/arch/riscv/kernel/head=2ES
>+++ b/arch/riscv/kernel/head=2ES
>@@ -131,6 +131,12 @@ secondary_start_sbi:
>     csrw CSR_IE, zero
>     csrw CSR_IP, zero
>
>+#ifndef CONFIG_RISCV_M_MODE
>+    /* Enable time CSR */
>+    li t0, 0x2
>+    csrw CSR_SCOUNTEREN, t0
>+#endif
>+
>     /* Load the global pointer */
>     load_global_pointer
>
>@@ -226,6 +232,10 @@ SYM_CODE_START(_start_kernel)
>      * to hand it to us=2E
>      */
>     csrr a0, CSR_MHARTID
>+#else
>+    /* Enable time CSR */
>+    li t0, 0x2
>+    csrw CSR_SCOUNTEREN, t0
> #endif /* CONFIG_RISCV_M_MODE */
>
>     /* Load the global pointer */
>
>I have queued this patch for Linux-6=2E16 with the above hunk squashed=2E
>
>Thanks,
>Anup
>
>--=20
>kvm-riscv mailing list
>kvm-riscv@lists=2Einfradead=2Eorg
>http://lists=2Einfradead=2Eorg/mailman/listinfo/kvm-riscv

Yup, I had planned to post something like that too, but didn't get to it=
=2E

Thanks,
drew

