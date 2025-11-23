Return-Path: <kvm+bounces-64297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A41A4C7DAF5
	for <lists+kvm@lfdr.de>; Sun, 23 Nov 2025 03:35:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C7161353582
	for <lists+kvm@lfdr.de>; Sun, 23 Nov 2025 02:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E018E21B9D2;
	Sun, 23 Nov 2025 02:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zy6HV/LU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C0772617
	for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 02:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763865204; cv=none; b=CkuI+nOLdv+P1RYkv6I0MoPY+wL00U0Aj5sI4mdSa1Da/8LtXVd3wIuUil56xCciKsWXkkl0yqD9rFtE+cpfP5frMYq3dgu+hRbtks0g+quTOI8ADZ/CU/s6Yj+cHNZfTzjvPAcAQ62jyQkAzvlqqx4gXjVdPunnxoCObpIJDO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763865204; c=relaxed/simple;
	bh=rCc4nq3PttRA8+0oSgsrW9Mo0xwldTDWGoI5ab8Qu1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rG7P5+yGFApA6DbItUc+u8G5LVDCXPcMWfTEBKYl0I/SBQ99vKK2EqiQ10yHpZS+Pe80JiEKgFcJ2CNuGCE+m98TRZZ9LuEc3RIDQdOhhPwuwZSB2Oa/AYPTU+3FZPGC9ti703QQSqi6TDG+1LDl0S8ID+Myvum+qnLKpL/ekQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zy6HV/LU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1F1C4AF0B
	for <kvm@vger.kernel.org>; Sun, 23 Nov 2025 02:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763865203;
	bh=rCc4nq3PttRA8+0oSgsrW9Mo0xwldTDWGoI5ab8Qu1Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Zy6HV/LUskZIV9pI7pgm2TEPeb4LQ72q/tyx+nNCuvgxYqPR0TuySDoEP84tsF7Sc
	 2fuV/mfELjNsy+Af53do+7qiv/M0+cfRDToub2NWq73qYBPT9GfEmJ0UyFikKZgFBG
	 dDIL5UEZdvDF6Kht6Kt8FlVRCpJYOdlBfCi0Iv+DHUtT+u/DY2z7de1QJOPHXsrDNH
	 UUbe9MnCRqb4Y4IfaKWLVuNcu12SJgC1A2k5F1Id+yER5cTzJqQAG/rzlcHRExQEtS
	 DGJEFg3YNoRUVkfYlilLb5CK1Itbo2c2+fayxhfmrUjtgh8vt+I9l3Qk+vUt7oU5P5
	 UGJnrh6PSDSOA==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47775fb6cb4so21037945e9.0
        for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 18:33:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUu0f4hTD2zvCsiQzYEO/CD/rsJW/CLj9V1PR4CSH47Vo0qkfXUfGmJytNHU0s9tBFD06M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLl/ws38EKzsuT7c+6BdcDaXFPtJSjH0p2uZBT20dmVuCQQ+34
	ez/DUxfXAse9pPHYN2VSHDD5Cox6I6lAfRm8o8Z4c0zcT4/1ZDufwo7LhClqjWSTJtLhhmrrnC4
	hpYcv4Tjdvia6MTTFMdddzEoab+fro7g=
X-Google-Smtp-Source: AGHT+IFu8+keWKht8NAR12FzNoKQ1ZakL3uoRUW8Qu35TSMqtSJ2/G6S36LtFGsDYOLOjquBzTcDQ3YJIc/S1fXfwQs=
X-Received: by 2002:a05:600c:3590:b0:477:54f9:6ac2 with SMTP id
 5b1f17b1804b1-477c104fc20mr85112725e9.0.1763865201944; Sat, 22 Nov 2025
 18:33:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251122075023.27589-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20251122075023.27589-1-fangyu.yu@linux.alibaba.com>
From: Guo Ren <guoren@kernel.org>
Date: Sun, 23 Nov 2025 10:33:19 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTRBFTnu2pA5rh16EWLvF_Wo=+vpZMUK9roDkDPes4Fpg@mail.gmail.com>
X-Gm-Features: AWmQ_bmTGM3DvVj2QLOaGmzVQQuWw2wC2Ygj63d-XxxSA_PqRhUSHSryftk40Qg
Message-ID: <CAJF2gTTRBFTnu2pA5rh16EWLvF_Wo=+vpZMUK9roDkDPes4Fpg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Allow to downgrade HGATP mode via SATP mode
To: fangyu.yu@linux.alibaba.com
Cc: anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	ajones@ventanamicro.com, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2025 at 3:50=E2=80=AFPM <fangyu.yu@linux.alibaba.com> wrote=
:
>
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> Currently, HGATP mode uses the maximum value detected by the hardware
> but often such a wide GPA is unnecessary, just as a host sometimes
> doesn't need sv57.
> It's likely that no additional parameters (like no5lvl and no4lvl) are
> needed, aligning HGATP mode to SATP mode should meet the requirements
> of most scenarios.
Yes, no5/4lvl is not clear about satp or hgatp. So, covering HGPATP is
reasonable.

Acked-by: Guo Ren <guoren@kernel.org>

>
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> ---
>  arch/riscv/kvm/gstage.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index b67d60d722c2..bff80c80ead3 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -320,7 +320,6 @@ void __init kvm_riscv_gstage_mode_detect(void)
>         csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
>         if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_S=
V57X4) {
>                 kvm_riscv_gstage_mode =3D HGATP_MODE_SV57X4;
> -               kvm_riscv_gstage_pgd_levels =3D 5;
>                 goto done;
>         }
>
> @@ -328,7 +327,6 @@ void __init kvm_riscv_gstage_mode_detect(void)
>         csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
>         if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_S=
V48X4) {
>                 kvm_riscv_gstage_mode =3D HGATP_MODE_SV48X4;
> -               kvm_riscv_gstage_pgd_levels =3D 4;
>                 goto done;
>         }
>
> @@ -336,7 +334,6 @@ void __init kvm_riscv_gstage_mode_detect(void)
>         csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
>         if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_S=
V39X4) {
>                 kvm_riscv_gstage_mode =3D HGATP_MODE_SV39X4;
> -               kvm_riscv_gstage_pgd_levels =3D 3;
>                 goto done;
>         }
>  #else /* CONFIG_32BIT */
> @@ -354,6 +351,10 @@ void __init kvm_riscv_gstage_mode_detect(void)
>         kvm_riscv_gstage_pgd_levels =3D 0;
>
>  done:
> +#ifdef CONFIG_64BIT
> +       kvm_riscv_gstage_mode =3D min(satp_mode >> SATP_MODE_SHIFT, kvm_r=
iscv_gstage_mode);
It's out of the no5/4lvl scope, because we lose (hs-mode)satp=3Dsv39 +
hgatp=3Dsv48x4 combination.

How about re-parsing no5/4lvl parameters?

> +       kvm_riscv_gstage_pgd_levels =3D kvm_riscv_gstage_mode - HGATP_MOD=
E_SV39X4 + 3;
> +#endif
>         csr_write(CSR_HGATP, 0);
>         kvm_riscv_local_hfence_gvma_all();
>  }
> --
> 2.50.1
>


--=20
Best Regards
 Guo Ren

