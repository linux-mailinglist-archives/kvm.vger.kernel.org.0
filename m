Return-Path: <kvm+bounces-52850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77872B09AA0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:45:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A65C3B1DCE
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 04:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB3EB1DE4E1;
	Fri, 18 Jul 2025 04:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="IfIPHnpC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B134817A2FC
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 04:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752813898; cv=none; b=JZbDGn6YWbWdvjjFk/K89f6K44mtEGaOPvwHsyriyATtrzafejoB4eM0GXTsKxyO0H0Q602lPc2rq968GDRpSTwmq57OqitQ0cJeMy6nL/jyvZHfDVu6LC+8pAPOsUSGUMySF//G/kXtoYg9fFpIy4apaclgA6eTOFPvUQbb/M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752813898; c=relaxed/simple;
	bh=w/7oCVtNwSLYmdO52IwOKE+LWKzNYeup6Zag8FPSZps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=drZ8Ev9tDbVeNpCTsdjjkCA3Saeo4Rrayv4gZEnaTMIGXj5v3wCpokQ0cOKsMzlOWveM0UGK7RTRmCHb2ADjW8ZP/LDsBnuIIgyA615WiuQZRZ1oL7R5Qwaz+kxB8vTpOCQq7rBVeHGci2UcH+riC24OBfYE/bSgVrDACLkLM2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=IfIPHnpC; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3df2ddd39c6so7504735ab.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 21:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752813896; x=1753418696; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=83O1oRzrZe3Tf7Tu6tuN/pr1ROh0NC7/xEo52yjes5Y=;
        b=IfIPHnpCl16Y66VtARHuK2s88cNz7MGUUJ16JjKhWMW0Etz+kfzVObcwbh7lI3NLXa
         gJ9QPCKi9K42ljzfK0iL3xUPTIoBSif/KHyRlSac3UDsfSwjDj3F6c+0dxhq9H4wfxN/
         tt4sieBuzyT74pltu6kDfinfYQyMN4HNK+qJEZJFDUIq1qmwYEy1PQAa2z0ZSsBhkK/o
         WT/F7D8uWyaqaS8Fm3S3R3deaOEtbCQGX/u/DFL48l+c2MxFlFEEFbaNQpGoSQxhgKqo
         6kOFXdTYsP0Lr+6fNcY7A1y0m32L74lH4ABf+6OBw7iAaWqtD2qrTdDPpzwzcq9Exjsg
         yI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752813896; x=1753418696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=83O1oRzrZe3Tf7Tu6tuN/pr1ROh0NC7/xEo52yjes5Y=;
        b=JtwFpgfOmStqloM0P2+UKELV1WVnNuP/TVOp1v7p4ZH2pyQE/UBPgAn63Ag89MsQeD
         DIcNvOtXWBfs99UeL0FiHRWvyFEOECeHPKTJ89dGf6mCIgDzRpqn3Fm7hs8abY9IqvIU
         5oPXShhY2lT2gIfwlwf6EpSvKCz09n9HxZY4MiprnYolWXzWh7nifc2xtp5nJLp25pcX
         4ueTqUjCXhh/jnZZqOWh68ZBIglylwrExRB72wm0S7VU84bGGt6BYoj1bbrlFlNdrunL
         3CXoyFnZnCfzJsH2h0/7/6TMwfn3gjUt9yV+6wrt+AuN+cpvXpOKemtxPGsn+rfnJfhm
         rkCA==
X-Forwarded-Encrypted: i=1; AJvYcCUTKABuAceuA5b/BFQPkBQ0qpkDqUOcaAZ2Ct4ZAi1tXy6TRLJ+S65F2pJVVtbrFaEhzhI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzSNm99azvx7l/fSOQS5s146724CpeCLS2GRdIqZmwV1vUeVvT
	qC/B0/v/CeV0bH1PeNyFKbu/VclIih0Y6VAYmNBMQhH9ib4fe9ItI1zKh/7z16cMAu2PwSYK9G3
	MxMr8X1xX+hCBEPtgD3TyBcuQh+x+OPUQ/faga273bw==
X-Gm-Gg: ASbGncvwsrOq9GLEHwYbcjP9FvEc6EbGVqT4nH4iFAx1ZnqdKjdSDWp+wW71nCCxyF7
	EyOWfvzSVDzqGqHHbF7HdMR6DTpKcy6intuCXpddviBtFxYdqSNJhyHaUE8cacWbSvCN0PloLym
	oTG+jiClcCWiS2lGkYOecwb4e6B/RA+ATakcav9jaci7abJfTyMwbnVfNJPvBJvgnhIx7G+sQT2
	0+RoNv4
X-Google-Smtp-Source: AGHT+IEQ4otNtt6pp4gCO0IAJF0iXhgJzg+MtD1U6+aiOibg4+X80HGU1rRgRl9yQCkoPHu/mILJDq3l2KjWUtT69q8=
X-Received: by 2002:a05:6e02:3786:b0:3e2:9193:f37b with SMTP id
 e9e14a558f8ab-3e29193f441mr38720145ab.16.1752813895694; Thu, 17 Jul 2025
 21:44:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com> <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
In-Reply-To: <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 18 Jul 2025 10:14:43 +0530
X-Gm-Features: Ac12FXwDM51LcC52YMXP6x19jKkago_UCHpgC4vfOjbMUKEF0l7xeNYNTebWdEY
Message-ID: <CAAhSdy0t0UuLwBD5abY52dEaHtcai0uVDucY+vtrtxNj0uYQOw@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version to 3.0
To: Atish Patra <atishp@rivosinc.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 12:33=E2=80=AFAM Atish Patra <atishp@rivosinc.com> =
wrote:
>
> Upgrade the SBI version to v3.0 so that corresponding features
> can be enabled in the guest.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Extending the ONE_REG interface to allow KVM user-space select
SBI version can be done as a separate series.

For this series, we can go ahead with this patch.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> index 4ed6203cdd30..194299e0ab0e 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -11,7 +11,7 @@
>
>  #define KVM_SBI_IMPID 3
>
> -#define KVM_SBI_VERSION_MAJOR 2
> +#define KVM_SBI_VERSION_MAJOR 3
>  #define KVM_SBI_VERSION_MINOR 0
>
>  enum kvm_riscv_sbi_ext_status {
>
> --
> 2.43.0
>

