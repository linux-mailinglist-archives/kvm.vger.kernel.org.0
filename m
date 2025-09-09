Return-Path: <kvm+bounces-57052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 976B1B4A29D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 08:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D0CA4E5CE5
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 06:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F707304BCD;
	Tue,  9 Sep 2025 06:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Gbv/GRhV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAE920468E
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 06:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757400599; cv=none; b=hAagHhQFNPQ5c/0G+zCmodWFzjhZ2uw/c4kmWS9B9EPrHB98G3oQ1hCxkwUlmmbubWhgTvW880w+Ug1J1cGeVj9Ii2ckH4VhYpBj0aO05JeUz/8ssOJBaZobF6lf0ZJ2DdkWFoSrJtOUGFc6wwoNX/vdy/5DjTDL8nCVCtoyt7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757400599; c=relaxed/simple;
	bh=z3lPcgUpFdgNzRk9Ka3bnYhy9MqRzRRv3vxQ4+/4kF4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uVeqsvQ5+umMM7YDL9mXJFSfIfq04xk8nkuq90F/+h7cDyXdqbmICd+bxiWtwnwDbSlIu55H/NeJqxD/B1gjV96OI8mXnlJSubEDsOZY8b2I3D72FlyDv9RiEGSiZhJBzsiFJW62fcUiRoIWxT9AvuMnZf24zirlh+rbNYHop54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Gbv/GRhV; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-4135366c20fso30515ab.0
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 23:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1757400595; x=1758005395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tMGMIIAM6sHy/Zxv5pxoK3ri8eUb3ls0915OVi+tjo=;
        b=Gbv/GRhV3l0vHSDfFtWi1ASX6m/3oEvIc3r6QxT3wBsV+U/CSQ+3+6h68oZp+a5obk
         LwqRDL78aik80kgrZxRNQLc69LNrU2g3Xz5Ju3asPmKLdtwMHKWSIFCW+Ab+1mBRKTGf
         +hSkq4pe9Feg9myXEaEbOQfx9Z4tPjdkymiRaOzQchFzIz47/9GAoi5SOKe/ezpkrR4G
         9+VjpaOxFrdnKH1rNoUR4WoOLa26h0BJYS9ebPY1g7GB8DxP1pWkfZdPZL/JRqK1pCvu
         QlS2F+wk5Y+YxjJizYIM9xe+DiWABdoHSXGxMkonl98J7mPSrHUtit/Qul3AjloIvtBj
         iqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757400595; x=1758005395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tMGMIIAM6sHy/Zxv5pxoK3ri8eUb3ls0915OVi+tjo=;
        b=cUzBSww913t/zBODSE4cPKqXyHzWmmGBUoYUYqvQvqISEp8fy0bGi29uGJ5G8nojyY
         uW+8Z8Bq+0v/13PIZLwVOH6psrlqVCmZRh8Rffy5ulnPgC9DFTtpvaSM+apvPZDGv8XY
         fEW6GoNVoZC8Ql0IrCPyzUFxnoohuc/LuZYmKo4iPQlYc/rHzi2OxOR+6zAcBQrpnWGg
         viBpZ5naFHPoHPWH2B+rexy0G8zTT+eNSTHsECfbM+LCUGujFPJirsblzstMA5FATSxh
         KZEU3mTM4rPb8lD3AlqrH2IwKQbVkBDnJATrYrX+tRnAoqByRULJ0/dVm5J2joO5ZaLG
         W3Dg==
X-Forwarded-Encrypted: i=1; AJvYcCWAG6Evjyi6UUxhll8e3y7lHOdoLqaaYlXrjsnY86m+85kLDPfe/MbUSp2DJ6dKXGDTO5E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFHWZCUNm8kXvV5xOuYNDzjeiWPYE1iI7OMdaLXzq6OpxozcBp
	SRDHjNTtticjjlMc12ffEfydZN3UnYaMOmcMttoSEsIjG26sPws7HwjzelHEy1P3mF1rhEWLEpI
	6e7VUPFI6tzLqm5Gs0cg3R3LaMzfazxNJF5clAfOHCQ==
X-Gm-Gg: ASbGncuHpVoTqPnXFxlmdK0oxp/UCOgrx/JiH9WgvarCvoePiUaBdhBR4oFtQ1W5+Y9
	lXCprURaPzVrJkvTwZlMxPn6IDY81s5NXRJwdbkfQ4Qgw0/wGtEWWaYiVM1VxRGFZHaGxa7nGCN
	Qh9N/8Kz6aVBmXk6veGmHwzzx/cukveBNI5e1Hwz1TzTz8CGHbHZd4IttcBgE0nSRS8lLka40Rk
	mULwyQuKEULkfXF97aG1POq7Tc7kN2fozuqJqYCt9KvF6lMDhk=
X-Google-Smtp-Source: AGHT+IHApbelfKr9iZjlbPLT4hrwWMN2zK90Qp74CPK8qggzSmBY3zhKklG8kN1niPRcRUYYEKR1Dn+Se41EF7a7fAk=
X-Received: by 2002:a05:6e02:1a2e:b0:3f6:5f12:2905 with SMTP id
 e9e14a558f8ab-3fd8672ce38mr131687095ab.23.1757400595369; Mon, 08 Sep 2025
 23:49:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250825121411.86573-1-tjytimi@163.com>
In-Reply-To: <20250825121411.86573-1-tjytimi@163.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 9 Sep 2025 12:19:43 +0530
X-Gm-Features: Ac12FXxC3F2KfRE7z4xEWUZppWNrpTWEFb52_Lgv63sTz9df23xVkubP9_GJqjA
Message-ID: <CAAhSdy27hnGS3HOazwnR4Y+SCk94RLnz5CA1kDkzsx7QH3dmwA@mail.gmail.com>
Subject: Re: [PATCH v3] riscv: skip csr restore if vcpu preempted reload
To: Jinyu Tang <tjytimi@163.com>
Cc: Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	Conor Dooley <conor.dooley@microchip.com>, Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Nutty Liu <nutty.liu@hotmail.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2025 at 5:44=E2=80=AFPM Jinyu Tang <tjytimi@163.com> wrote:
>
> The kvm_arch_vcpu_load() function is called in two cases for riscv:
> 1. When entering KVM_RUN from userspace ioctl.
> 2. When a preempted VCPU is scheduled back.
>
> In the second case, if no other KVM VCPU has run on this CPU since the
> current VCPU was preempted, the guest CSR (including AIA CSRS and HGTAP)
> values are still valid in the hardware and do not need to be restored.
>
> This patch is to skip the CSR write path when:
> 1. The VCPU was previously preempted
> (vcpu->scheduled_out =3D=3D 1).
> 2. It is being reloaded on the same physical CPU
> (vcpu->arch.last_exit_cpu =3D=3D cpu).
> 3. No other KVM VCPU has used this CPU in the meantime
> (vcpu =3D=3D __this_cpu_read(kvm_former_vcpu)).
>
> This reduces many CSR writes with frequent preemption on the same CPU.

Currently, I see the following issues with this patch:

1) It's making Guest usage of IMSIC VS-files on the QEMU virt
    machine very unstable and Guest never boots. It could be
    some QEMU issue but I don't want to increase instability
    on QEMU since it is our primary development vehicle.

2) We have CSRs like hedeleg which can be updated by KVM
    user space via set_guest_debug() ioctl.

The direction of the patch is fine but it is very fragile at the moment.

Regards,
Anup

>
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
> ---
>  v2 -> v3:
>  v2 was missing a critical check because I generated the patch from my
>  wrong (experimental) branch. This is fixed in v3. Sorry for my trouble.
>
>  v1 -> v2:
>  Apply the logic to aia csr load. Thanks for
>  Andrew Jones's advice.
>
>  arch/riscv/kvm/vcpu.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index f001e5640..66bd3ddd5 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -25,6 +25,8 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>
> +static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_former_vcpu);
> +
>  const struct _kvm_stats_desc kvm_vcpu_stats_desc[] =3D {
>         KVM_GENERIC_VCPU_STATS(),
>         STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
> @@ -581,6 +583,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int c=
pu)
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>         struct kvm_vcpu_config *cfg =3D &vcpu->arch.cfg;
>
> +       if (vcpu->scheduled_out && vcpu =3D=3D __this_cpu_read(kvm_former=
_vcpu) &&
> +               vcpu->arch.last_exit_cpu =3D=3D cpu)
> +               goto csr_restore_done;
> +
>         if (kvm_riscv_nacl_sync_csr_available()) {
>                 nsh =3D nacl_shmem();
>                 nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
> @@ -624,6 +630,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cp=
u)
>
>         kvm_riscv_mmu_update_hgatp(vcpu);
>
> +       kvm_riscv_vcpu_aia_load(vcpu, cpu);
> +
> +csr_restore_done:
>         kvm_riscv_vcpu_timer_restore(vcpu);
>
>         kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
> @@ -633,8 +642,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cp=
u)
>         kvm_riscv_vcpu_guest_vector_restore(&vcpu->arch.guest_context,
>                                             vcpu->arch.isa);
>
> -       kvm_riscv_vcpu_aia_load(vcpu, cpu);
> -
>         kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>
>         vcpu->cpu =3D cpu;
> @@ -645,6 +652,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>         void *nsh;
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>
> +       __this_cpu_write(kvm_former_vcpu, vcpu);
> +
>         vcpu->cpu =3D -1;
>
>         kvm_riscv_vcpu_aia_put(vcpu);
> --
> 2.43.0
>

