Return-Path: <kvm+bounces-52698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1246B084A3
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AE6A3AB0E8
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 06:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BB520A5DD;
	Thu, 17 Jul 2025 06:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="BVz9XR6G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE761FDE14
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 06:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752732673; cv=none; b=BjqZ+uM2R2jxEIYLUkF4WJ8mvh8ldcFwHHyR11+9P94STIhAF3FQDOuxKNMmnm8P4cdPb0lLQwXVysKZfncrEI1ZxB+twKcB42tqJqRksw1lxGmApkHIz3aJTuUMpTTbFxdhLcL88LAzRMkcXO2qrRIeDSCeIjuCKmwlSkvXhKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752732673; c=relaxed/simple;
	bh=r/ELqY9p9UrCGq6No1E+wq/GOusuftqIaLK1wJc+CGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OvW2zvxF5rFj9lbWO5N2GR82eDvRbBaBPdnl81gh+VUF2S0tPF7fHTC+eiJ6/eYGwvUPb8DW4kfR3x4Bd8QsojwdxzTTJiWoUzkMjqNTBROEjrxnRpW9X3TAHUrOjr7lbWORygsyAwZTA46TtkZq0dsb4mLznEFHHnAb+Tvm7K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=BVz9XR6G; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-87653e3adc6so21363539f.3
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 23:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752732670; x=1753337470; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFXDSElKOOqp2lhmXXGsXGr9VDCoQ/FfrBr7vY0pwQs=;
        b=BVz9XR6GVUjZQhiGSk3iw/1L80E3WcyEf91W+lPBVE3gpMIUP9OzNMAxdPNCTFhYIt
         hKIO2mwmyP97lQLWuqCbHy1jeXLn+zXEUVmhXJ7ZkBPnhgLUYK5ksiKgTDe2PjzXFrPq
         5N99sAn663QkZtJumhdyqrMOZjeQPdwK86oyJ/QGKMMJKvpdlkclMXyJ3M6p5X8buSrS
         zPgOCfUm3Kotcqoz2ojdH23D/ja67b/gFIJrNN6S8eJpGb6dYIS28GdbRWKxHVS1NkR8
         8fcM/EfczS9MQ65WWtaVVDiUa4blR8bLApSWVCUwgeP7+zb8HrFVwVjzIS1XhLDYD3yP
         XdRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752732670; x=1753337470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZFXDSElKOOqp2lhmXXGsXGr9VDCoQ/FfrBr7vY0pwQs=;
        b=fmWFfashnr4TaBxQpFe60gFYFimxfTIPn4nrUtUht9mZPo/zBH8HSFCIjYyYzH9LSC
         xcMDFbxt9/dmE9njZC45skhBiCQDBv3/O37GfWluHz/712YPjt6NIeshbCJ6vAus7ccW
         Jey82CEHG08rLifWeQM5AMFFGZqXYrjglTCddntV9c2ECf6hy2H5nrTK/rlU7ngMmyzM
         5ewuinoPaOGroD3tgMkgkEDEYUqh4kEL4wl13dcSXzChavJHRxAxzH+wPC+OfAZhT+IQ
         BTw3BP7n5F/+MEjknnDDytI8OegaXwoQzt1BL6VexqhkEcd/p3wtRq95JNa0WmxE0SDe
         r+lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjsMq0C1utEtiaV4dNQkAEAgmqtO5d5vZsdcK62cGDGw1uR2FnzsxL+NQGJF/xvZVmnx8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrh/QgfTdMo5HsSogPijbbZ6UXUoUG15vlfStl2zlMyVnqCC3Y
	eS18Zgqv8BUVpU80KXul//tA4uXngyeeVLrVJIYCRnuke+7icVaA/8+VPQxRJ650ycX5YBoayhT
	f8nLZu/t77xeg9rQbRAVIohXM6pgKZwb+QaS1VLrMSQ==
X-Gm-Gg: ASbGnctBJQ01WfauspvoaKH4OFdxXr0jai8TvYwqHADaB8QZS1GRNl2QNsYABR+i8HD
	WKen6lBdqV4rZ29IuJXMfox20kmAERVt4DUo0eqy4aLrBVDzLzFKCmUzr/MF3cVL/F/v9jFUTpN
	WD1XJlIaJ+77Qf18WrdBRqXI1ouDRBGGpE0C8iotig8RtxQiBiE54UlXCRq7cpHm0N0WuwPOH6R
	dLjdQ==
X-Google-Smtp-Source: AGHT+IF01QfJyQMefqtK6K31hKuroqHVJNbfRoBUWtdmJCmhcOeVgxFHACALHAoTtmmMAVZj3g7jLJEfDcjT3Imbm5Y=
X-Received: by 2002:a05:6602:164a:b0:879:c4a1:1020 with SMTP id
 ca18e2360f4ac-879c4a1138amr581946839f.9.1752732670109; Wed, 16 Jul 2025
 23:11:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749810735.git.zhouquan@iscas.ac.cn> <20e116efb1f7aff211dd8e3cf8990c5521ed5f34.1749810735.git.zhouquan@iscas.ac.cn>
In-Reply-To: <20e116efb1f7aff211dd8e3cf8990c5521ed5f34.1749810735.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 17 Jul 2025 11:40:58 +0530
X-Gm-Features: Ac12FXzV5Y-LW3CLzhO1n-a_ZnyRISIIMhwEfUeHXAPilMPIemTKisuILYRl6qQ
Message-ID: <CAAhSdy3yjCXHucCzQzXg2BUJM7aYrb2Fd0taJQw=AEnvfnsNAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] RISC-V: KVM: Enable ring-based dirty memory tracking
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2025 at 5:08=E2=80=AFPM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Enable ring-based dirty memory tracking on riscv:
>
> - Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL as riscv is weakly
>   ordered.
> - Set KVM_DIRTY_LOG_PAGE_OFFSET for the ring buffer's physical page
>   offset.
> - Add a check to kvm_vcpu_kvm_riscv_check_vcpu_requests for checking
>   whether the dirty ring is soft full.
>
> To handle vCPU requests that cause exits to userspace, modified the
> `kvm_riscv_check_vcpu_requests` to return a value (currently only
> returns 0 or 1).
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.17

Thanks,
Anup

> ---
>  Documentation/virt/kvm/api.rst    |  2 +-
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/Kconfig            |  1 +
>  arch/riscv/kvm/vcpu.c             | 18 ++++++++++++++++--
>  4 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 1bd2d42e6424..5de0fbfe2fc0 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8316,7 +8316,7 @@ core crystal clock frequency, if a non-zero CPUID 0=
x15 is exposed to the guest.
>  7.36 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>  ----------------------------------------------------------
>
> -:Architectures: x86, arm64
> +:Architectures: x86, arm64, riscv
>  :Type: vm
>  :Parameters: args[0] - size of the dirty log ring
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index 5f59fd226cc5..ef27d4289da1 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -18,6 +18,7 @@
>  #define __KVM_HAVE_IRQ_LINE
>
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> +#define KVM_DIRTY_LOG_PAGE_OFFSET 64
>
>  #define KVM_INTERRUPT_SET      -1U
>  #define KVM_INTERRUPT_UNSET    -2U
> diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
> index 704c2899197e..5a62091b0809 100644
> --- a/arch/riscv/kvm/Kconfig
> +++ b/arch/riscv/kvm/Kconfig
> @@ -25,6 +25,7 @@ config KVM
>         select HAVE_KVM_MSI
>         select HAVE_KVM_VCPU_ASYNC_IOCTL
>         select HAVE_KVM_READONLY_MEM
> +       select HAVE_KVM_DIRTY_RING_ACQ_REL
>         select KVM_COMMON
>         select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>         select KVM_GENERIC_HARDWARE_ENABLING
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index e0a01af426ff..0502125efb30 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -690,7 +690,14 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>         }
>  }
>
> -static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
> +/**
> + * check_vcpu_requests - check and handle pending vCPU requests
> + * @vcpu:      the VCPU pointer
> + *
> + * Return: 1 if we should enter the guest
> + *         0 if we should exit to userspace
> + */
> +static int kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
>  {
>         struct rcuwait *wait =3D kvm_arch_vcpu_get_wait(vcpu);
>
> @@ -735,7 +742,12 @@ static void kvm_riscv_check_vcpu_requests(struct kvm=
_vcpu *vcpu)
>
>                 if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
>                         kvm_riscv_vcpu_record_steal_time(vcpu);
> +
> +               if (kvm_dirty_ring_check_request(vcpu))
> +                       return 0;
>         }
> +
> +       return 1;
>  }
>
>  static void kvm_riscv_update_hvip(struct kvm_vcpu *vcpu)
> @@ -917,7 +929,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>
>                 kvm_riscv_gstage_vmid_update(vcpu);
>
> -               kvm_riscv_check_vcpu_requests(vcpu);
> +               ret =3D kvm_riscv_check_vcpu_requests(vcpu);
> +               if (ret <=3D 0)
> +                       continue;
>
>                 preempt_disable();
>
> --
> 2.34.1
>

