Return-Path: <kvm+bounces-29035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0C409A14F9
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 23:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5DC12860F4
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9F71D2F5F;
	Wed, 16 Oct 2024 21:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="lW0IonHC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41F01D2B2F
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 21:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729114835; cv=none; b=FyFjmr9nMUA1RudzWH56q1VMsN0MyRXOl4L7L4BKpRKVzCGDEYLBzB8eCzZwxXK4PRZQwdXv3ZkdwQoWD81pzI4K8XqxbVHdbnteJHSiqBoCPE2j4sU2Fs0CGXyMzTsI9SNA3YLXf/elmTD9UxDGtP2NklJtrZE2QjKgJspmh6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729114835; c=relaxed/simple;
	bh=wfvdwbqhSSF47yDMIkeJXITavFjKyTiIRpRSxc4gHJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u3LBOoR9PeicsJngBpUaDs2DJyTQS/Yt5Z6oNM+z/iTny8uErPIMl/yOi7A0Vwcc25kRGciFKTTPpSaRqcany+QjfKRAb+j36z699/qa3oAyg3po8HE8gOxPCiTfz/tzQLySxoVgCkeXEZhua4gqJBR3JDnkdhAsJ3g75BbXAEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=lW0IonHC; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539f8490856so322562e87.2
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 14:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729114832; x=1729719632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aK/FMBO41F0k5XVWKFVW2dU30aEpK/ecSDxmrBc+uhE=;
        b=lW0IonHCK57Zy6zpC9ZK/nXP3OWlah+MT8POeJYS+707z+NJ2QOVjPagPzVWdB4OOO
         7U0yOAiryTY5tP0GM9c6xkIg6ETsTMshQpHBNfsz/qhjBL3+YdJkUFcQ3PPeE3GeFcd2
         9OxXhOSetbZtaWB9rMwqtumDiu2eKf1Kl9ZhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729114832; x=1729719632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aK/FMBO41F0k5XVWKFVW2dU30aEpK/ecSDxmrBc+uhE=;
        b=rf5Chc/WXCLKeXe5j/9YOzHEEzV9Umd4rzziVdidt1msuqv8UBJ6h9M2ldWgXxAhuT
         I+jc04sYhlqIYuHmaaG7dJsS4VBYg7ZsuF7FH192Fae9zT4XprxVmWT0VBtj5aAbQ1Hs
         37Brahdpboz42HYXJa3ZMEV/Xr92xMV3ba4onS66k9fVLqNq7vtJexLpU4lvJyDRySMZ
         jOwbhQQE4Q48tJZ1W/E0oeIHX65nfRIHAB+CjwJnThVPmN0XXRd2cnwAexlhDrGFW+dR
         pnsIXsLOEXiFIkboS+2yswa1YKsg23eKawr+VHjyQFtWWM804h/yrA3BlRMxyM1gAm0B
         MS4A==
X-Forwarded-Encrypted: i=1; AJvYcCWr5txSIicmReki/ctKa7MXu8jqfKX4ySXC0CWxMFvUVKjQXhYQStr4vPTqLd1nWatJ2lw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5HD/iDZ3c/5fBI5ToCX79zHy9nTtDwQXrb87mi+P7/dwEjwjw
	2nfkLu+qYt6UXMNfwFq+Ktkw0FsXfPoIBN4ckRJx7WbjgHXMXWHikfHJLpMfOKcDAQrMOuyWy12
	VUJfUIi7Wt33hZLC7KNTKCJP0H1j7iiJZoKaT
X-Google-Smtp-Source: AGHT+IHm+rppT2jBLrv4MJVazg4/+Wq/0WmR8zBCpedbjekw1BVdrrjEVCQASyp+Ge+wyK6mNgZuORoIrxTa5tX2vRE=
X-Received: by 2002:a05:6512:3e1f:b0:539:fa3d:a73 with SMTP id
 2adb3069b0e04-539fa3d0be6mr6343173e87.39.1729114831422; Wed, 16 Oct 2024
 14:40:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-7-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-7-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Wed, 16 Oct 2024 14:40:20 -0700
Message-ID: <CAOnJCUKugAua2ooQL5tJCNFr27pCrsQ53YJuKEs11UYJdVkAPw@mail.gmail.com>
Subject: Re: [PATCH 06/13] RISC-V: KVM: Don't setup SGEI for zero guest
 external interrupts
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
> No need to setup SGEI local interrupt when there are zero guest
> external interrupts (i.e. zero HW IMSIC guest files).
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/aia.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index 17ae4a7c0e94..8ffae0330c89 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -499,6 +499,10 @@ static int aia_hgei_init(void)
>                         hgctrl->free_bitmap =3D 0;
>         }
>
> +       /* Skip SGEI interrupt setup for zero guest external interrupts *=
/
> +       if (!kvm_riscv_aia_nr_hgei)
> +               goto skip_sgei_interrupt;
> +
>         /* Find INTC irq domain */
>         domain =3D irq_find_matching_fwnode(riscv_get_intc_hwnode(),
>                                           DOMAIN_BUS_ANY);
> @@ -522,11 +526,16 @@ static int aia_hgei_init(void)
>                 return rc;
>         }
>
> +skip_sgei_interrupt:
>         return 0;
>  }
>
>  static void aia_hgei_exit(void)
>  {
> +       /* Do nothing for zero guest external interrupts */
> +       if (!kvm_riscv_aia_nr_hgei)
> +               return;
> +
>         /* Free per-CPU SGEI interrupt */
>         free_percpu_irq(hgei_parent_irq, &aia_hgei);
>  }
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish

