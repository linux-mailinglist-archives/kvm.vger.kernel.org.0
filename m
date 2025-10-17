Return-Path: <kvm+bounces-60271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52448BE634D
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 05:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF9B01A63F59
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 03:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6B525393B;
	Fri, 17 Oct 2025 03:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VPH59p0c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A30E33F9
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 03:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760671435; cv=none; b=J0KeSYSwUAVPE8xAPi6C0VZi0S4kf7KABz2YR+s0GRdpZUvMNq+Lc3huJ8gFvy9xYg7hO2egSd3zXl/fyCkoRh2p9bGAsxsKCOKZvuK3frW9sKkWIdLqWnJHu/9qu3aItfE77myC9JszdaL3guBaVRXRdLNwWI1m5LYv18Xufg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760671435; c=relaxed/simple;
	bh=nxjOPyq7o8O+c0jeIf8RgCVbVleVOizSHv6JGkn8fP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tebf4OceUjHvm0dK9F34X1tJbeu+fDjkItxUuPY/MnurnTKyqrbjjZ+zwC/0ggNc3nU65gp9egJkqOaNH18ghkDno5fg/T8vzoQt5OXKPiqwIj62LdZe3kRzt4Ia7eVSh+C+rpti8I88WJVL14TlFUQyg8W6VQw7h8kkwEzBHRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=VPH59p0c; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-57992ba129eso1761618e87.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 20:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760671431; x=1761276231; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zgJbpEilKc76eN6ORe40tn9wWSRIn1nbjUiD28It3k8=;
        b=VPH59p0czOSHS0RL1EC2ApNNOWmyb4H1IoISge2HbT/tpRtSIjuVfYH5sbF8o3MJEn
         siN+ZvUTGkHpHxuh8GxBRn+ck4lhq4Pl6Ff8MfQCGJ8LPHWeZyCCLT0SQrs9wb0RdjBP
         ILtNG4EPfj0syJvflGOALJ+qAzlVZUdTZ6ObWXfidnz6ZG4+P4jJXdYENPaFoPaBlOrr
         A835+vMd2FchLzjgRO+gKxwIv5wNHv8cUHjwPOY4cfB2Oh8kuy6oWl9evkxpTzaSz+bt
         qMp/icukGEa3D2WjgPypYOPhZArE1av7zr9WFzSQOeJTxPNsDsEe8eZ/Ax8aF3Q7PLKx
         9V5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760671431; x=1761276231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zgJbpEilKc76eN6ORe40tn9wWSRIn1nbjUiD28It3k8=;
        b=vgn+mYhb/Gwi0Kt4Drg3+uxxJEH8qhFslZdm2pszwuHavQ2J+r1poEqnJo5iFhJUK0
         i+nhUUWKmr9rzs0IGsmPXW0aXtF9sAuAmGOhkG0IKv9d6kNyjK3mpYszTz7u2R7Oi/+k
         LgqkG9qxFovJLFt+7rBBxCxcRO4F0Tdt4llfCde/ttDd9Bss2uUA1pEdiaueinmpYNpr
         75K0tSeOXlKdgbiup7YxmNOxH9i2hA6o6tz0CN5NvjMoy1OxQKCamu31xLpgjPRGR2OC
         XaAKf8VzNNi1f1qjOJVtEd6etOdiWd+UbFFKFGQP1hNqzm5hYkpQFrlJCEMam9gl2g2M
         6H7g==
X-Forwarded-Encrypted: i=1; AJvYcCVVaWOBUGMbhIQYKk1EnPkdRmTMOx9w5haLZ01hkPs0DOFgT3uA0su5JpGQ7ViMIVpwZkU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNioDk1OBtx20uXbK1KNbFsSkaAEJuMoPTeTc4ug5BmCoFRIYt
	PcpUeulBBTLN8OCDpUoI36g+vbVPlzr0ElIXl9fTBiwFQT9qCZkV3XdkIRwYkhA092w63SAfJnH
	gfIbhne3TKdsknl2mq5RF91/t7IoTPytM/kQhry0K4A==
X-Gm-Gg: ASbGncsvCKi7FxoIIzgmZ6ht5bu08Adp/rD1HnzPCxtU9TnESp7RcDjWDlSm6wsi52c
	g9VAJxMTNYWduO70q0gEstv+PbNBJ3cf95tFFtEXH3WpOZ4Lzqn+wyKkyM1vaLF9bt2yQdi3Q99
	eW0oApWCoGUGqk2AG4AgL9Mj/ZsGf9Qg0/cdlFEketzd0SbgjaA1x+i27VvnDQLHtWsHXWISQdY
	yFuOeIhR/dWCZr69ZPrqlsk8I4pGfrMwr/DIAn2NpCHnLBuOUSO/aNtyyz8HukGLO+GX2YF
X-Google-Smtp-Source: AGHT+IElSKtdIpALk1nSLovdiSg+YYsyRQZSurzM1kakr9yrGs4N9sEcb79hjU8qjRKyDo4eqHVmU9r98WccWB5VKkE=
X-Received: by 2002:a05:6512:3f12:b0:577:9ee:7d57 with SMTP id
 2adb3069b0e04-591d85a2146mr785397e87.46.1760671431298; Thu, 16 Oct 2025
 20:23:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016001714.3889380-1-samuel.holland@sifive.com>
In-Reply-To: <20251016001714.3889380-1-samuel.holland@sifive.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 17 Oct 2025 08:53:39 +0530
X-Gm-Features: AS18NWAHiotLWgrvaFJ0yhxbbAeGChAh_woFA4Y002T2jSkQKffZFvzyYjf0LZs
Message-ID: <CAK9=C2W7-+UnWHZyTNkwTRy-=E5vjUNTjvq9PSCrLVZsY4b56g@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix check for local interrupts on riscv32
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 5:47=E2=80=AFAM Samuel Holland
<samuel.holland@sifive.com> wrote:
>
> To set all 64 bits in the mask on a 32-bit system, the constant must
> have type `unsigned long long`.
>
> Fixes: 6b1e8ba4bac4 ("RISC-V: KVM: Use bitmap for irqs_pending and irqs_p=
ending_mask")
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>

Queued this patch for Linux-6.18 fixes.

Thanks,
Anup

> ---
>
>  arch/riscv/kvm/vcpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index bccb919ca615..5ce35aba6069 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -212,7 +212,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  {
> -       return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
> +       return (kvm_riscv_vcpu_has_interrupts(vcpu, -1ULL) &&
>                 !kvm_riscv_vcpu_stopped(vcpu) && !vcpu->arch.pause);
>  }
>
> --
> 2.47.2
>
> base-commit: 5a6f65d1502551f84c158789e5d89299c78907c7
> branch: up/kvm-aia-fix
>

