Return-Path: <kvm+bounces-29120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F7359A3182
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 01:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8C2F1F2384E
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 23:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FE9200B93;
	Thu, 17 Oct 2024 23:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="IuCAEbAD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAFC20E30A
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 23:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729209331; cv=none; b=ib62O7acgDD2+hj4fMMKZjoPsOSNOXWmCAeTKmbN+4od7dmLpWQg3wuGCcSpmK+xLWRhaEHwqzam58ivJwD6BLMZvk5RqC4epdcz6cZmEDeKCK2XsI/AqhTHVK5zAN+4mwC+q+R68xB64W86gX8JQp+kdi1SjIHG07ALlFovZ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729209331; c=relaxed/simple;
	bh=ttVT//6SOV1llrYR/MA7CtzyvkHnpfmNPPULVHmCYK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lLXCmiQltWOjLAFQgVcuG89V2BNArZlY0EM/A1SnFUc/LJkZTTqNeaMaMwQQOqPGyRVjFul9snHJVM67Ct5aD3No8dP6P334UQcsjDSnThpJnjMujwaXiTH+U1jXJcNDVs8XepdsIYO4yxdk9eXSJc7E4Eis43Y6YZeRbBV8SgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=IuCAEbAD; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539e7e73740so1416926e87.3
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 16:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729209326; x=1729814126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uFhqsamjD0SMhzdfzPtmk29EXMRuhu+6CqUAUkCoVbQ=;
        b=IuCAEbADGqTP67cjzEqSzszmWbybF8VI8PMFXQgPswZxZe8LVNH9/GINO4+ZLwslJL
         GyFTHJoFfcYBh0EQAXw5Q5SjiK8OeJqpvInfmY+WMx0fFhK7ph3tTf4whoIW73cMp2RD
         +o7mT45sj9mro7UKN6BfXKHU59nC+a3xbSlAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729209326; x=1729814126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uFhqsamjD0SMhzdfzPtmk29EXMRuhu+6CqUAUkCoVbQ=;
        b=gj7kQ1diLz8E8mY6BXLN+5U4ONwc2xHR36ifVkSMTBReGGrxm+Rt1Ui0HldN8WJMld
         i/cn815gbFMmluvoAwMMmS+ySnodWliQPpLb6Hmu9v59JKFVScBQSbfb4i4rKHrF6sPv
         zGnRH1SxssbJbiGo76e4PUG4JQaK4/rq+0PC7vy4uCQD4hDdO+pa5Zp+h3oGSU21tltT
         e2y54UxwEJOS4gejBhfn2+U0kiT+s3r80YjAnqNo6UiH7lfP7XLIUho466TSgwYf6VZ0
         /Xq8ls/24K3eA3wZL4IxLSg2f9bv5N+BHKKqwf8pDv/su3vgY+7Z/pa+4EpyokHig100
         z56A==
X-Forwarded-Encrypted: i=1; AJvYcCVsrQikE/Mv5eJlO1RfZ4/r4UeqLT6T1IcSx1Agiu20vB7hy+yELgZGrMp540GWJznUtos=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY90POk80gWYa7uhRHhix2sDS7QfATGknHALGfvK+m1YSDALMw
	xsEKoKuCAXbssjIzr5+5AM+YQDIFviz360v/RVbKMf3m2zOUN0lTCP84ktcD+yBNtI2wDB1QAMW
	81XrmUXxqGI+4in5LW53U0PoTY/MJTP5l5BiB
X-Google-Smtp-Source: AGHT+IFfavOLQH5lk4D6zPJWCHlvDUam0vrMnnqxXT2a99DOrAAj8R1edWukPti7f53E+Dm8plX4tDMSBeJ397PTZtc=
X-Received: by 2002:a05:6512:3095:b0:539:ff5a:7ea5 with SMTP id
 2adb3069b0e04-53a15218abamr247138e87.15.1729209326192; Thu, 17 Oct 2024
 16:55:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-8-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-8-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Thu, 17 Oct 2024 16:55:14 -0700
Message-ID: <CAOnJCUJUUtRhkroxJ-Kvah7qRfsAApi_5dbrmAWsdObr-KjRfw@mail.gmail.com>
Subject: Re: [PATCH 07/13] RISC-V: Add defines for the SBI nested acceleration extension
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 9:09=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> Add defines for the new SBI nested acceleration extension which was
> ratified as part of the SBI v2.0 specification.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/sbi.h | 120 +++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)
>
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 1079e214fe85..7c9ec953c519 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -33,6 +33,7 @@ enum sbi_ext_id {
>         SBI_EXT_PMU =3D 0x504D55,
>         SBI_EXT_DBCN =3D 0x4442434E,
>         SBI_EXT_STA =3D 0x535441,
> +       SBI_EXT_NACL =3D 0x4E41434C,
>
>         /* Experimentals extensions must lie within this range */
>         SBI_EXT_EXPERIMENTAL_START =3D 0x08000000,
> @@ -279,6 +280,125 @@ struct sbi_sta_struct {
>
>  #define SBI_SHMEM_DISABLE              -1
>
> +enum sbi_ext_nacl_fid {
> +       SBI_EXT_NACL_PROBE_FEATURE =3D 0x0,
> +       SBI_EXT_NACL_SET_SHMEM =3D 0x1,
> +       SBI_EXT_NACL_SYNC_CSR =3D 0x2,
> +       SBI_EXT_NACL_SYNC_HFENCE =3D 0x3,
> +       SBI_EXT_NACL_SYNC_SRET =3D 0x4,
> +};
> +
> +enum sbi_ext_nacl_feature {
> +       SBI_NACL_FEAT_SYNC_CSR =3D 0x0,
> +       SBI_NACL_FEAT_SYNC_HFENCE =3D 0x1,
> +       SBI_NACL_FEAT_SYNC_SRET =3D 0x2,
> +       SBI_NACL_FEAT_AUTOSWAP_CSR =3D 0x3,
> +};
> +
> +#define SBI_NACL_SHMEM_ADDR_SHIFT      12
> +#define SBI_NACL_SHMEM_SCRATCH_OFFSET  0x0000
> +#define SBI_NACL_SHMEM_SCRATCH_SIZE    0x1000
> +#define SBI_NACL_SHMEM_SRET_OFFSET     0x0000
> +#define SBI_NACL_SHMEM_SRET_SIZE       0x0200
> +#define SBI_NACL_SHMEM_AUTOSWAP_OFFSET (SBI_NACL_SHMEM_SRET_OFFSET + \
> +                                        SBI_NACL_SHMEM_SRET_SIZE)
> +#define SBI_NACL_SHMEM_AUTOSWAP_SIZE   0x0080
> +#define SBI_NACL_SHMEM_UNUSED_OFFSET   (SBI_NACL_SHMEM_AUTOSWAP_OFFSET +=
 \
> +                                        SBI_NACL_SHMEM_AUTOSWAP_SIZE)
> +#define SBI_NACL_SHMEM_UNUSED_SIZE     0x0580
> +#define SBI_NACL_SHMEM_HFENCE_OFFSET   (SBI_NACL_SHMEM_UNUSED_OFFSET + \
> +                                        SBI_NACL_SHMEM_UNUSED_SIZE)
> +#define SBI_NACL_SHMEM_HFENCE_SIZE     0x0780
> +#define SBI_NACL_SHMEM_DBITMAP_OFFSET  (SBI_NACL_SHMEM_HFENCE_OFFSET + \
> +                                        SBI_NACL_SHMEM_HFENCE_SIZE)
> +#define SBI_NACL_SHMEM_DBITMAP_SIZE    0x0080
> +#define SBI_NACL_SHMEM_CSR_OFFSET      (SBI_NACL_SHMEM_DBITMAP_OFFSET + =
\
> +                                        SBI_NACL_SHMEM_DBITMAP_SIZE)
> +#define SBI_NACL_SHMEM_CSR_SIZE                ((__riscv_xlen / 8) * 102=
4)
> +#define SBI_NACL_SHMEM_SIZE            (SBI_NACL_SHMEM_CSR_OFFSET + \
> +                                        SBI_NACL_SHMEM_CSR_SIZE)
> +
> +#define SBI_NACL_SHMEM_CSR_INDEX(__csr_num)    \
> +               ((((__csr_num) & 0xc00) >> 2) | ((__csr_num) & 0xff))
> +
> +#define SBI_NACL_SHMEM_HFENCE_ENTRY_SZ         ((__riscv_xlen / 8) * 4)
> +#define SBI_NACL_SHMEM_HFENCE_ENTRY_MAX                \
> +               (SBI_NACL_SHMEM_HFENCE_SIZE /   \
> +                SBI_NACL_SHMEM_HFENCE_ENTRY_SZ)
> +#define SBI_NACL_SHMEM_HFENCE_ENTRY(__num)     \
> +               (SBI_NACL_SHMEM_HFENCE_OFFSET + \
> +                (__num) * SBI_NACL_SHMEM_HFENCE_ENTRY_SZ)
> +#define SBI_NACL_SHMEM_HFENCE_ENTRY_CONFIG(__num)      \
> +               SBI_NACL_SHMEM_HFENCE_ENTRY(__num)
> +#define SBI_NACL_SHMEM_HFENCE_ENTRY_PNUM(__num)\
> +               (SBI_NACL_SHMEM_HFENCE_ENTRY(__num) + (__riscv_xlen / 8))
> +#define SBI_NACL_SHMEM_HFENCE_ENTRY_PCOUNT(__num)\
> +               (SBI_NACL_SHMEM_HFENCE_ENTRY(__num) + \
> +                ((__riscv_xlen / 8) * 3))
> +
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_BITS 1
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_SHIFT        \
> +               (__riscv_xlen - SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_BITS)
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_MASK \
> +               ((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_BITS) - 1)
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_PEND              \
> +               (SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_MASK << \
> +                SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_SHIFT)
> +
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD1_BITS        3
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD1_SHIFT \
> +               (SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_SHIFT - \
> +                SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD1_BITS)
> +
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_BITS 4
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_SHIFT        \
> +               (SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD1_SHIFT - \
> +                SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_BITS)
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_MASK \
> +               ((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_BITS) - 1)
> +
> +#define SBI_NACL_SHMEM_HFENCE_TYPE_GVMA                0x0
> +#define SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_ALL    0x1
> +#define SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_VMID   0x2
> +#define SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_VMID_ALL 0x3
> +#define SBI_NACL_SHMEM_HFENCE_TYPE_VVMA                0x4
> +#define SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ALL    0x5
> +#define SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ASID   0x6
> +#define SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ASID_ALL 0x7
> +
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD2_BITS        1
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD2_SHIFT \
> +               (SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_SHIFT - \
> +                SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD2_BITS)
> +
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_BITS        7
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_SHIFT \
> +               (SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD2_SHIFT - \
> +                SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_BITS)
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_MASK        \
> +               ((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_BITS) - 1)
> +#define SBI_NACL_SHMEM_HFENCE_ORDER_BASE       12
> +
> +#if __riscv_xlen =3D=3D 32
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_BITS 9
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_BITS 7
> +#else
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_BITS 16
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_BITS 14
> +#endif
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_SHIFT        \
> +                               SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_BITS
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_MASK \
> +               ((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_BITS) - 1)
> +#define SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_MASK \
> +               ((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_BITS) - 1)
> +
> +#define SBI_NACL_SHMEM_AUTOSWAP_FLAG_HSTATUS   BIT(0)
> +#define SBI_NACL_SHMEM_AUTOSWAP_HSTATUS                ((__riscv_xlen / =
8) * 1)
> +
> +#define SBI_NACL_SHMEM_SRET_X(__i)             ((__riscv_xlen / 8) * (__=
i))
> +#define SBI_NACL_SHMEM_SRET_X_LAST             31
> +
>  /* SBI spec version fields */
>  #define SBI_SPEC_VERSION_DEFAULT       0x1
>  #define SBI_SPEC_VERSION_MAJOR_SHIFT   24
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish

