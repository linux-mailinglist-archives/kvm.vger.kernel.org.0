Return-Path: <kvm+bounces-56858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26BE8B44E45
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 08:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D89A617EED5
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 06:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB122D2483;
	Fri,  5 Sep 2025 06:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="EH98wxpk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97F723B605
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 06:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055095; cv=none; b=aQ6BCNWgKT55N5A/KxGosuLPuGoEsL4TAy6oEwxLGu89gYBUsu9A5DBEXlZEYtkSIifuqUMldO8y0Lu6u09NUk4qZepkyE8tFH0wZkynyggDMRY2e2lRP0+6AQHY7lhfhL0vbtR6gDRF4PeToZrZUcl7MaJ3kHSqwV3EkpUcZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055095; c=relaxed/simple;
	bh=DOYG52bm3R+MHg5vqoPm6DS0MWor4RL65odaaxJDZfY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tHc55NJcLeC7fvud+PIXHpDS3zW81HS0Xt1Lme9ZfYZV821Ytdhu7jFHfqeONAdkI9txuaM0Gh4UBLc2jk4EDoulYbHQAcEled18EvwhGP7ZdacX3rdsU2RBe5nreFv/+4t7tqQhqV30rzbB/6spKxslZL0TcHkiKZv7PvnvYxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=EH98wxpk; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3f669e78eadso9000885ab.1
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 23:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1757055093; x=1757659893; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgikJ/iqkuT1625UVuOS4SU35VzBlFe8raMxnT2R3Dc=;
        b=EH98wxpkzEtsErwGa9o0g+6kFTQt9ydIyfcoiMQF3rprhozSjhT2/qE7w2hvg7yNKu
         aQnUhGDTpDQtvVQJEVsNTM3p8XWdOX9uwrNe0wW7LnApnym6Pd887cAURFGEnoIZrrH0
         g3/a7dIHYC39ovY+Ylu6eTQ1xiuuOYeslosGV/1Gi8RagAqG7PJUcVp4/Kn2ExBV3ebV
         i1B4XJ62+6wgiqlpP+dfKJeezmgdtf94xOGJab64RZrWu2AXAzaPaNEFCEPEUxyjliCB
         EQCRaMqrLLUapQGqWHEfa5MS/eorP6vLBal8K3Vu5eRR+ID6RDGIiQsHsu+tHO2tAtpx
         5Cew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757055093; x=1757659893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DgikJ/iqkuT1625UVuOS4SU35VzBlFe8raMxnT2R3Dc=;
        b=SmTYsXeaNhXlUrYv+sOoT2vERrfvlNszLizQHZEyf+Mqk1yO0Q+u0rvtACBom8J/0M
         dcyHfcndMcvxKyAwZ25+70Rwr0SOc0jpTzAMiYtP5iHd2xSpEOfyIAV7Wl5rM4xdhPVj
         wz6NtM1wsyI6J0tMDRe0kbI/osXQ/QKed3F8gioE5qI+rhgtjSCnpUwg9cvEcCP4c0E5
         vkPxsNdq5gC20Phca+yKJcGiRGgJUN0GJnqT6kzz4859QsaHs9GBgsgeU5dGGNPWZX0b
         dpSbcBWa4KNfFhlBW4G3SfoaZpTjddM4aDjvngHW783w7ajnwjlZbEvNwjMNOs+3bwn9
         ig6A==
X-Forwarded-Encrypted: i=1; AJvYcCW/+30vEvJUcO0ZEJlGJWAXY70bHAdh2GETP9Ltaf1/pY8FTl3M5kA7fXWFExxXDrtvFl0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9MscTWdSkR41H2EblPpgtFrcOQOn7K42ADBYeb9M9e/XSzUlq
	4f7mDAN1z9/IZwKSN8nmpAF05HDCk81B1gJbSaHX4PYr/H0BUy+qXV2Ff8vLOaMGfdYZDCPuUUS
	4aZVq7T5GQ7+LR+7NojcCWRAFo7eOAdPOgfMCUGosGGPaubFNbuJVQZc=
X-Gm-Gg: ASbGncuRxXXGn5nF4Y7uTis8bdmnY6ierIpR42gcjdU43kGosihWiH7oBxFg4l2WAc+
	oDpie26cozTGEtbjfS5s0rvw1PcebpxKfMT5LmNpjoWQO4YFPvYahIjxH7prjJgE6l6mTO7FhIa
	GtTL/fi4r8h+yLSJ3+o9w+LfPGH5tUUAl3Y8an/2yvKgRfHwc+xiwBAml8fX6uOfwlJxYIPi+aw
	Ws8tWomDSYXz21Kdse5DL/4EkGdiFqJ7lyKluWkGhfe5Ef/Mwc=
X-Google-Smtp-Source: AGHT+IE0GkMpVI891j1Kf9mcve+BS80twMvgJMvqpPq6yQxysHrWNfdqH0YTTj+8Uuey/zDVOIAMoM8LYJUem+o/IZw=
X-Received: by 2002:a92:c26d:0:b0:3ec:4b19:1cff with SMTP id
 e9e14a558f8ab-3f7c4fe66a2mr38800885ab.7.1757055092738; Thu, 04 Sep 2025
 23:51:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821142542.2472079-1-guoren@kernel.org> <20250821142542.2472079-4-guoren@kernel.org>
In-Reply-To: <20250821142542.2472079-4-guoren@kernel.org>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 5 Sep 2025 12:21:20 +0530
X-Gm-Features: Ac12FXxkuV6dW8S9O6tABOo6HAbMSLVVmeuqhJ5kGcoNWolAeIVa3ME0D57bFtU
Message-ID: <CAAhSdy2yFQYbrp8npzBUwtviJYVQ=vv1F_k3jybYBvheYMgaZQ@mail.gmail.com>
Subject: Re: [PATCH V4 RESEND 3/3] RISC-V: KVM: Prevent HGATP_MODE_BARE passed
To: guoren@kernel.org
Cc: troy.mitchell@linux.dev, alex@ghiti.fr, aou@eecs.berkeley.edu, 
	atish.patra@linux.dev, fangyu.yu@linux.alibaba.com, guoren@linux.alibaba.com, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	palmer@dabbelt.com, paul.walmsley@sifive.com, 
	Nutty Liu <nutty.liu@hotmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 7:56=E2=80=AFPM <guoren@kernel.org> wrote:
>
> From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
>
> urrent kvm_riscv_gstage_mode_detect() assumes H-extension must

s/urrent/Current/

> have HGATP_MODE_SV39X4/SV32X4 at least, but the spec allows
> H-extension with HGATP_MODE_BARE alone. The KVM depends on
> !HGATP_MODE_BARE at least, so enhance the gstage-mode-detect
> to block HGATP_MODE_BARE.
>
> Move gstage-mode-check closer to gstage-mode-detect to prevent
> unnecessary init.
>
> Reviewed-by: Troy Mitchell <troy.mitchell@linux.dev>
> Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
> Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
> ---
>  arch/riscv/kvm/gstage.c | 27 ++++++++++++++++++++++++---
>  arch/riscv/kvm/main.c   | 35 +++++++++++++++++------------------
>  2 files changed, 41 insertions(+), 21 deletions(-)
>
> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> index 24c270d6d0e2..b67d60d722c2 100644
> --- a/arch/riscv/kvm/gstage.c
> +++ b/arch/riscv/kvm/gstage.c
> @@ -321,7 +321,7 @@ void __init kvm_riscv_gstage_mode_detect(void)
>         if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_S=
V57X4) {
>                 kvm_riscv_gstage_mode =3D HGATP_MODE_SV57X4;
>                 kvm_riscv_gstage_pgd_levels =3D 5;
> -               goto skip_sv48x4_test;
> +               goto done;
>         }
>
>         /* Try Sv48x4 G-stage mode */
> @@ -329,10 +329,31 @@ void __init kvm_riscv_gstage_mode_detect(void)
>         if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_S=
V48X4) {
>                 kvm_riscv_gstage_mode =3D HGATP_MODE_SV48X4;
>                 kvm_riscv_gstage_pgd_levels =3D 4;
> +               goto done;
>         }
> -skip_sv48x4_test:
>
> +       /* Try Sv39x4 G-stage mode */
> +       csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
> +       if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_S=
V39X4) {
> +               kvm_riscv_gstage_mode =3D HGATP_MODE_SV39X4;
> +               kvm_riscv_gstage_pgd_levels =3D 3;
> +               goto done;
> +       }
> +#else /* CONFIG_32BIT */
> +       /* Try Sv32x4 G-stage mode */
> +       csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
> +       if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) =3D=3D HGATP_MODE_S=
V32X4) {
> +               kvm_riscv_gstage_mode =3D HGATP_MODE_SV32X4;
> +               kvm_riscv_gstage_pgd_levels =3D 2;
> +               goto done;
> +       }
> +#endif
> +
> +       /* KVM depends on !HGATP_MODE_OFF */
> +       kvm_riscv_gstage_mode =3D HGATP_MODE_OFF;
> +       kvm_riscv_gstage_pgd_levels =3D 0;
> +
> +done:
>         csr_write(CSR_HGATP, 0);
>         kvm_riscv_local_hfence_gvma_all();
> -#endif
>  }
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index 67c876de74ef..8ee7aaa74ddc 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -93,6 +93,23 @@ static int __init riscv_kvm_init(void)
>                 return rc;
>
>         kvm_riscv_gstage_mode_detect();
> +       switch (kvm_riscv_gstage_mode) {
> +       case HGATP_MODE_SV32X4:
> +               str =3D "Sv32x4";
> +               break;
> +       case HGATP_MODE_SV39X4:
> +               str =3D "Sv39x4";
> +               break;
> +       case HGATP_MODE_SV48X4:
> +               str =3D "Sv48x4";
> +               break;
> +       case HGATP_MODE_SV57X4:
> +               str =3D "Sv57x4";
> +               break;
> +       default:

Need kvm_riscv_nacl_exit() here.

> +               return -ENODEV;
> +       }
> +       kvm_info("using %s G-stage page table format\n", str);

Moving the kvm_info() over here now prints G-stage mode
before announcing availablity of h-extension which looks odd.
It's better to keep kvm_info() in the same location and only
move the switch-case.

>
>         kvm_riscv_gstage_vmid_detect();
>
> @@ -135,24 +152,6 @@ static int __init riscv_kvm_init(void)
>                          (rc) ? slist : "no features");
>         }
>
> -       switch (kvm_riscv_gstage_mode) {
> -       case HGATP_MODE_SV32X4:
> -               str =3D "Sv32x4";
> -               break;
> -       case HGATP_MODE_SV39X4:
> -               str =3D "Sv39x4";
> -               break;
> -       case HGATP_MODE_SV48X4:
> -               str =3D "Sv48x4";
> -               break;
> -       case HGATP_MODE_SV57X4:
> -               str =3D "Sv57x4";
> -               break;
> -       default:
> -               return -ENODEV;
> -       }
> -       kvm_info("using %s G-stage page table format\n", str);
> -
>         kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits(=
));
>
>         if (kvm_riscv_aia_available())
> --
> 2.40.1
>

Otherwise, this looks good to me.

I will take care of minor comments mentioned above at the
time of merging this series.

Regards,
Anup

