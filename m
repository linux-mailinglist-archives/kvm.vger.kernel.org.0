Return-Path: <kvm+bounces-34344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 544149FAEFC
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 14:53:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C79DC165A2C
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 13:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A86E1AB6CB;
	Mon, 23 Dec 2024 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="H6+4GOQW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97D215C14B
	for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 13:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734962023; cv=none; b=LwaoCUzY53cvwK/4uKSon4VxtxpUU2nv9m6Y/ydW6ZDgU1co34IASwBJ8nby4kCee4XaFL7m/mITepbQ+g6RNg4YgwY6znV/fR6KxkdeRoc9QzU2GUuxgmPeqmA83h8h/EBPmN9nFzRUAiHwaAy40bdB/g4lJT2mf1/4tlAJRSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734962023; c=relaxed/simple;
	bh=3FphSFWK1Phcz+xMoTNKeuLZnOnmpVK5ROWemGjNq1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BnV0ftINYaPrbg15CfaDAHIZTL4hrZznABKT7GXtWw+SnjV2dnbePF7ZuUBNOq8U+yCpUQHvgoBRAG24ln4s7ivfLiGFHdqmoYGdgQYPKQD8yU4Tk7B64Q9wbwYIFwY73YXY4VVrI4unrty5JtzPgq8WPbirIhYyMnMOuaulytM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=H6+4GOQW; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a814831760so14735965ab.1
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2024 05:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1734962021; x=1735566821; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hnkagdjwjgNIPob+6WBvRRH+hXkhhZ41YnFLVb4sL9g=;
        b=H6+4GOQWY4JwG/OZN2v23k/ASE3NVhUJY3hiThyBhBCKcOANC+/AeYEogdkmJXfl00
         IzeJTfIgSP3Ik2CO2PEr+UjoqoPtvVNUjJhKiw8Mcu7LYdsw7TK6l0XDaauDvLfqqIOh
         QDK7l9tr7BsU5IgJoKAfh+d5RbNkfr2rSPjxDdEzLYjRYc5IK5I4K3xvZD4HY3rEUPmN
         Zn17Qspdevgydo8qk9+zk4iE9dvxu+GTqppMsp7TovS2v9KD+WeAd3MlJszRDO1q3RdU
         ynjv3uY5fdxE5gQ8BL2NgIHVqZT56xTnvxvrYxOwKjmVr/0SklPoXfV+UOQZ9dFW7DJV
         9//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734962021; x=1735566821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hnkagdjwjgNIPob+6WBvRRH+hXkhhZ41YnFLVb4sL9g=;
        b=Hykxvac098GF9Hz6T1WUlq9aHHHnHW1Prkqgz9nVsBRYNcjvQEDPnhZUgfzdxp4a8D
         bLiPZXXemzdl2rJNgPpye/7PO9kNiqlvTu2lAjDxrC+WEz4joafWVo0Lzi4MhOBM8Wux
         afPegcA1HBog9g0B/DTbgst8b0/Fx69N105wEekcDGh5jIfVeBmIHj5BrVYxVm/r+k3I
         bukmAtokYw73fqsMz8bPRZX96nqmt9Fw490ZffakBzcoe4W/2Y+P3NeGYIhmuJd4xrfL
         nNqImvpPmwH1dLrG8jHyjYwm+V4S136LN5Vhqf93tYYr7SbT+r4X6yNCiv/k1zLuQgbY
         GR4A==
X-Forwarded-Encrypted: i=1; AJvYcCXnKYbHpdtTWGUPCneImqHXgyhxJKg8bMMhivJ4D6nTJOwsJxBKGHSCLcZuUAdnzzLSFvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIw2nj0lIQH7Ag3gGjpXycdSjFRp+JdlY50tJAx16rWPzzj2Bd
	uDC9h7Q+6C7Bk0rN9oUWUg1cOo+s/ezyT7tJe9FJtUK3TKLUKaVa+vVs/F38Wm+IHqWdlP3ewY3
	97QhZAax35Et4pbFETx4DKYswCL69ASqRfDQ2eQ==
X-Gm-Gg: ASbGnctJowm+4yd/xdSWYErKOldEZRPksQ2MhzBH5mVcT1lv4rsBsJaAsVKD3/LbJQY
	R0hdQ+95ni/tjZxFY88CFa8cG/OwUT2WDbCcvXdQ=
X-Google-Smtp-Source: AGHT+IEwvacBcq9kn3WJJuHdSOtxROX9WlmJfaZm50Reex04d1j/d8xnGQEJRsPYoiEuXLYBTkoaA6s0B8KwuzpOaHE=
X-Received: by 2002:a92:cda6:0:b0:3a7:a738:d9c8 with SMTP id
 e9e14a558f8ab-3c2d14d1839mr94678015ab.2.1734962021044; Mon, 23 Dec 2024
 05:53:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241212-kvm_guest_stat-v1-0-d1a6d0c862d5@rivosinc.com> <20241212-kvm_guest_stat-v1-2-d1a6d0c862d5@rivosinc.com>
In-Reply-To: <20241212-kvm_guest_stat-v1-2-d1a6d0c862d5@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 23 Dec 2024 19:23:29 +0530
X-Gm-Features: AbW1kvZ80UCq3C-ao5tldPIkaQ5px9K8zD2jwUzYIr5JIMryNiwwWqsoNWNGfbo
Message-ID: <CAAhSdy065Gk9jiMns+NMED4nOR20=ii0_rVrJZc+_EJ1DmkXVw@mail.gmail.com>
Subject: Re: [PATCH 2/3] RISC-V: KVM: Update firmware counters for various events
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 2:27=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> SBI PMU specification defines few firmware counters which can be
> used by the guests to collect the statstics about various traps
> occurred in the host.
>
> Update these counters whenever a corresponding trap is taken
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_exit.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index c9f8b2094554..acdcd619797e 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -165,6 +165,17 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *v=
cpu,
>         vcpu->arch.guest_context.sstatus |=3D SR_SPP;
>  }
>
> +static inline int vcpu_redirect(struct kvm_vcpu *vcpu, struct kvm_cpu_tr=
ap *trap)
> +{
> +       int ret =3D -EFAULT;
> +
> +       if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
> +               kvm_riscv_vcpu_trap_redirect(vcpu, trap);
> +               ret =3D 1;
> +       }
> +       return ret;
> +}
> +
>  /*
>   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) =
on
>   * proper exit to userspace.
> @@ -183,15 +194,27 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run,
>         run->exit_reason =3D KVM_EXIT_UNKNOWN;
>         switch (trap->scause) {
>         case EXC_INST_ILLEGAL:
> +               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN)=
;
> +               ret =3D vcpu_redirect(vcpu, trap);
> +               break;
>         case EXC_LOAD_MISALIGNED:
> +               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LO=
AD);
> +               ret =3D vcpu_redirect(vcpu, trap);
> +               break;
>         case EXC_STORE_MISALIGNED:
> +               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_ST=
ORE);
> +               ret =3D vcpu_redirect(vcpu, trap);
> +               break;
>         case EXC_LOAD_ACCESS:
> +               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD);
> +               ret =3D vcpu_redirect(vcpu, trap);
> +               break;
>         case EXC_STORE_ACCESS:
> +               kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STORE)=
;
> +               ret =3D vcpu_redirect(vcpu, trap);
> +               break;
>         case EXC_INST_ACCESS:
> -               if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
> -                       kvm_riscv_vcpu_trap_redirect(vcpu, trap);
> -                       ret =3D 1;
> -               }
> +               ret =3D vcpu_redirect(vcpu, trap);
>                 break;
>         case EXC_VIRTUAL_INST_FAULT:
>                 if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>
> --
> 2.34.1
>

