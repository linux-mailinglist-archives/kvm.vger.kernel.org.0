Return-Path: <kvm+bounces-38362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB91A38075
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9E80188990F
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE10217646;
	Mon, 17 Feb 2025 10:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="sRuV87fP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA1423CE
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739789037; cv=none; b=m61TvLBX4+YMScCzHo74n2oSdOHiAXP7VS8D5b6qoPGv+aXFT1f+4/rAShabxD9/msTXllyRSYObsQMO7O4wQp9/T4esCSLZjswj6MMgu8YC3unb8Szs4c5igFMilREePBPXQ1Yyzxss1ryrBELxk62L+414MsiSh2tLBhGJw4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739789037; c=relaxed/simple;
	bh=FQirNy5/YZ2Udw0QG05Iu/DFbMb3O8n2UUEVTfF3dbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AhwjMYwY2SxLu6jirZqK14/QZdtgfKTVEzSkf/1RFt+DG0BaKzYbhy5tlIiEKTroxHQVc/IxwvLSg0jPuh0XXhekw3yTrsaPvs6PX0N103cTV9Gg7DYwF1q67BoGCOUwxI8nTQPbn9LQDgI4Za9CzwQATMHAhLcTes/6OIpL/ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=sRuV87fP; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ce873818a3so39224725ab.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 02:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1739789035; x=1740393835; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2V99WRo5v5Q3MzOC1ebd9Y57LboqQs5ifLF7qebM8M=;
        b=sRuV87fPerUMyoBYsY9aM5xJw+dTqaSHBlAOF6+OGbqn3JukStestV5ppOQAuMYrmv
         YCWKuTo3lcQJHXEbSZjKe4GC75FHinRE1O0+bWC7uxUgCa9hTipowyXyNJBpPhcNyTQr
         ad0AFbNZmr3XoIbc4dgBYwftzMy3vawJ03+JQTiMqSjIW3wxKIKFVCF6RCdnvldEILvx
         RUrbbXr5relQUrxka5UcVXk5irl5its7vG1ZF8JwLnNPdnPQLn4OL0/WyTr59dYBxEuT
         qVGe6hsJGSjBHM0yMUoIWLFrNABI8BkA72jj0TPoccVKvjqgNRWazgEajXCQ/P0iRBc+
         SpUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739789035; x=1740393835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y2V99WRo5v5Q3MzOC1ebd9Y57LboqQs5ifLF7qebM8M=;
        b=cic0BDEWp7QIcH6NASXF2V8CM7mV4Yu+do54uTPzn7bk1XJ6qJoKtMbBpYlGwVi9h+
         POMAukk3rgb1NQ7EstDNqYP2dFLncHjCaSYSM+Y4H5Uru35scC5BrGcFA1E5uQShxBQH
         C5J3fBVTJOTSDUQilAnE0OjyYY1nJ3gkncGCk4fc0kCx1wEhQAHGS4LGbSvdVdIaLFCY
         XtS1d++BZICKRjDK5i7vt6F8COqMHY0Z74FHglfvyhvylMPbRINoFrraT2KvsAwnM0W6
         6ZXx7NzhhMMG3cVYOOi1srcGjMDo5bud50/xQ8+yTZGaFh1s8Ig4aT5CiHO/wWQRfHpp
         MrgA==
X-Gm-Message-State: AOJu0Yw5eUncnCGwPD1JMZMdk2ZYQe0ZyW02YApHXsUui1M20V+WcuoC
	2/gOZdfYe5o974Y0z+2wXBpMTNBw6E/BtJDZGeCiSdlX4CPlnnPYuh1oDwmoei1uGI2X5fS0VHN
	02C5PRmbCmxONjkbiCqXDn7jWmkqH7MzQVTVcZQ==
X-Gm-Gg: ASbGnct73t4krhS8eIIZ9sFq/gu07pRdSX3yqH27co2zs23yfVN1Bd9FLIe+ARjlkMo
	D2Tjn81jLhNjADAnwW3x5ryrptFoaWbP+NRox0IRs+YU03AD+Z8hlj409PL6yGDIsuh6ABzdxhA
	==
X-Google-Smtp-Source: AGHT+IHJJbyqVqnP4ZBh9F+JcrnyLgJr4c9SSZEBg9w0f79c3TFGGpdX5idQXZEwUkQrhZCz3XZ7Xbwuvzc/pn7T5Xg=
X-Received: by 2002:a92:ca4f:0:b0:3d1:9fd0:a898 with SMTP id
 e9e14a558f8ab-3d2807fe646mr61148335ab.6.1739789035598; Mon, 17 Feb 2025
 02:43:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217084506.18763-7-ajones@ventanamicro.com> <20250217084506.18763-10-ajones@ventanamicro.com>
In-Reply-To: <20250217084506.18763-10-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 17 Feb 2025 16:13:44 +0530
X-Gm-Features: AWEUYZm5Tu9EOU6io4oCKCd5uKf8WCJJPGpCQR8aWoZNoElVhT-bBEGNz1aiL1E
Message-ID: <CAAhSdy0SScanoz9Q_dm9YBP3bkoGGnM5AXGVWhtUrMcUZ9_=Nw@mail.gmail.com>
Subject: Re: [PATCH 3/5] riscv: KVM: Fix SBI IPI error generation
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, cleger@rivosinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 2:15=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> When an invalid function ID of an SBI extension is used we should
> return not-supported, not invalid-param. Also, when we see that at
> least one hartid constructed from the base and mask parameters is
> invalid, then we should return invalid-param. Finally, rather than
> relying on overflowing a left shift to result in zero and then using
> that zero in a condition which [correctly] skips sending an IPI (but
> loops unnecessarily), explicitly check for overflow and exit the loop
> immediately.
>
> Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions de=
fined in v0.2")
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_sbi_replace.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_=
replace.c
> index 9c2ab3dfa93a..74e3a38c6a29 100644
> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> @@ -51,9 +51,10 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
>         unsigned long hmask =3D cp->a0;
>         unsigned long hbase =3D cp->a1;
> +       unsigned long hart_bit =3D 0, sentmask =3D 0;
>
>         if (cp->a6 !=3D SBI_EXT_IPI_SEND_IPI) {
> -               retdata->err_val =3D SBI_ERR_INVALID_PARAM;
> +               retdata->err_val =3D SBI_ERR_NOT_SUPPORTED;
>                 return 0;
>         }
>
> @@ -62,15 +63,23 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *v=
cpu, struct kvm_run *run,
>                 if (hbase !=3D -1UL) {
>                         if (tmp->vcpu_id < hbase)
>                                 continue;
> -                       if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
> +                       hart_bit =3D tmp->vcpu_id - hbase;
> +                       if (hart_bit >=3D __riscv_xlen)
> +                               goto done;
> +                       if (!(hmask & (1UL << hart_bit)))
>                                 continue;
>                 }
>                 ret =3D kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
>                 if (ret < 0)
>                         break;
> +               sentmask |=3D 1UL << hart_bit;
>                 kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RCVD);
>         }
>
> +done:
> +       if (hbase !=3D -1UL && (hmask ^ sentmask))
> +               retdata->err_val =3D SBI_ERR_INVALID_PARAM;
> +
>         return ret;
>  }
>
> --
> 2.48.1
>

