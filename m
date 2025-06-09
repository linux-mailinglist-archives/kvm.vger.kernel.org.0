Return-Path: <kvm+bounces-48714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39874AD1810
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 06:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34EC73ABE58
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 04:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBBD627FD50;
	Mon,  9 Jun 2025 04:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="kxFj+wGs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE612F2E
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 04:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444197; cv=none; b=C8gWzEND1xr0TgBdUBoRtFp8L1h53Ys0T0C1IL2qxiQLnjjumPlCvNe3bjSqNzTVBz+hiQqWW8Gs4qZd0BOvlfpT76Q5ySnSZQJZaK1APbG80ouU8/aipo6JH3PKZDFru7k3xGv2jpzLUO9y/Xz3NyGv0+j3iHKnVZ3L47AQmDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444197; c=relaxed/simple;
	bh=XzAJgPdBBnmkzunedSqvjUymGxpV7sHfPAEWvIEeanM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SCPbfPysbkuhRcSNFmEoA//dEmudLP6n9K9vHpKICAMTKfzm/L60AwZG83HMXYBpSa/+w14eyc91068f/z2QecEBZS8VE9fA4TjEklFEmU23CuCD0IpBf87Q5+/ffff/g5CYHS+tNSevZaXkT2lGqCBO1Meh3t7icarAhgrV5dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=kxFj+wGs; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3dc8265b9b5so36954825ab.1
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 21:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1749444194; x=1750048994; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LLPCYr5e6u6vsBLYdaChBsgJrVajuCmHnbhRzhd1SBo=;
        b=kxFj+wGsJ1R80zCJwr4N4apb1ooS3BBGXddVs2QsAhAiO571nzz0lCgb11pPIzG+H4
         xM7HM3pjiMVXleEBb90x4jdNe3wyFHQwdYAPuM+MqMyw0wQ8msy513eJmuBQeJwz33za
         9ApgSDNWgcxrljkWtPsTwAlP2kDhq3rDdhJ6vXi523hY8vPNtLfnPNdGtwvZziD4M7UD
         iiF5bCp3rvOCMMtyhJ0IxqiAXxZPzi/RcI7nx2VJlr68/BqIz7+6iJUpSkYVpScqdPsW
         ZXFMvwR3ZwezxIL/W9+7Hfr/mgjWxdNhDOQbxoR0EqRYo9qljMhhUWFyY2XQCwQ/VEjz
         HARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749444194; x=1750048994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LLPCYr5e6u6vsBLYdaChBsgJrVajuCmHnbhRzhd1SBo=;
        b=B9fgwAf1VaIKKQvT7WZc2lWyHI6lu0gUSnlkttWbkamuWEEblXDCg1Hm8reRK+lPto
         7J+0nbgyL3JS7anRUfGgAIsfrtfhYBkJAq2NRYW7n4HHgNuaPFKsQ2JWPXXE0BbdiuN+
         YvYmS55XK4ENTmU2/eONnAQ3p47KyhGy7vxcx310FWAiuK3Pcbva5fjKpQysuUEclYRS
         WeOdPILvS5OEkEBZldD/lI6yxZyjgyjLiQcs/HNm3YMsfncAmu7AAeKM1CDOM827Gxa3
         Dm0uR6dIn/2VZvs/JWBxsj2yyktd90JioX0x+ssvMrkkXdkV9JMGB/UjbvShtdc3pbqb
         V6FQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy4y3tkJs9oUBX71KL+VG1597yRqesWrrnhT5tkZjxAnXZniYkSeKOP+oM5U+uRJcJHoY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7TYavb341CLlmyAPb5AqxQYhpsniy+9gXPd7tYK1Y9BQm5iWv
	V/S7ULCSX88tTKz5/hUooca19tHDF2Brxvm9P3NDqEfAEqD2Imw9PQZ2lPBqb74q84A3whSWfrv
	YWwtqBXkrXMwqJmuLs/+nPX72dqwfYauTxazSM/rj0w==
X-Gm-Gg: ASbGncuulemCbUBoSznsp8nNbZ3XpyJCB9kbUOktWgha2XU5P3MmCoQ1Cy+VXAkD5Zr
	DLuP6BIrV1NZJgHIVYBqYnOARcV0GDuGNYEDQ4EdIk2D8Ki6inwRKM2Dvnve/8Buf2kw/vZtoZj
	kugpIX8saXkXwy9FKWoKVR//oFssMD5NLbjXgzFSnoGnv0larPNlklS1D82047vwEpcu/aQl4Y+
	0g05dzfiLJGylo=
X-Google-Smtp-Source: AGHT+IFFQRtEtS/hG2Tw2Y3tZ7JBIHK8O7AtEvWbVFh3c/WKDcNmXYTLq1lKt0Z4JpmLj9iCX/JRFdqRRAtWqZiaZsc=
X-Received: by 2002:a05:6e02:148e:b0:3dc:8075:ccde with SMTP id
 e9e14a558f8ab-3ddce3ed62emr126702145ab.4.1749444194076; Sun, 08 Jun 2025
 21:43:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605061458.196003-1-apatel@ventanamicro.com> <20250605061458.196003-2-apatel@ventanamicro.com>
In-Reply-To: <20250605061458.196003-2-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 9 Jun 2025 10:13:02 +0530
X-Gm-Features: AX0GCFtusVCpQiVS1V0qV1zXXOQlncy-D3d7CPodLU4fm3d-HJJqnbKjeEFLTPI
Message-ID: <CAAhSdy1O+MvJ6nr0D2+8_9cQ=hT+zW0f-rcg7sw8uP_kuzd25g@mail.gmail.com>
Subject: Re: [PATCH 01/13] RISC-V: KVM: Fix the size parameter check in SBI
 SFENCE calls
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 11:45=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> As-per the SBI specification, an SBI remote fence operation applies
> to the entire address space if either:
> 1) start_addr and size are both 0
> 2) size is equal to 2^XLEN-1
>
> From the above, only #1 is checked by SBI SFENCE calls so fix the
> size parameter check in SBI SFENCE calls to cover #2 as well.
>
> Fixes: 13acfec2dbcc ("RISC-V: KVM: Add remote HFENCE functions based on V=
CPU requests")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

Queued as a fix for Linux-6.16

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_replace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_=
replace.c
> index 5fbf3f94f1e8..9752d2ffff68 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -103,7 +103,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu=
 *vcpu, struct kvm_run *run
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT)=
;
>                 break;
>         case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
> -               if (cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0)
> +               if ((cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0) || cp->a3 =3D=3D=
 -1UL)
>                         kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask=
);
>                 else
>                         kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask=
,
> @@ -111,7 +111,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu=
 *vcpu, struct kvm_run *run
>                 kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_S=
ENT);
>                 break;
>         case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
> -               if (cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0)
> +               if ((cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0) || cp->a3 =3D=3D=
 -1UL)
>                         kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
>                                                        hbase, hmask, cp->=
a4);
>                 else
> --
> 2.43.0
>

