Return-Path: <kvm+bounces-62285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7877BC3F9FF
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 12:04:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E63C71890DEF
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 11:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C880C31DD98;
	Fri,  7 Nov 2025 11:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="FT/csjbq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D2031A571
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 11:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762513443; cv=none; b=qmulm90PMaALTriD12YEUo/I/VfjaoxHRQW2ib2tkoiRPax1dRui5sVhnqAXrM+xNYJD3KZJQG0KubDf4QT1i2p+ga2Vt0NO6guJOLbavcyaR5fA3G91Vy2pG/nDEfLbJCt4Zuo/Y2qeWoDKW1vU2b73tkasjuzkugqhFIw6XeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762513443; c=relaxed/simple;
	bh=N00Ucd856bSWhiBAjcJFbc+enaLUyVUPZnhock7gOjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qeJmUAKUP6nkNEV8lWLguGfPi2RXPXXovanYaHKHMRl4EMm0IZtSBwXSofrIwSPt8hRiYZ5Mx3u3Im0038PhYDWofXyI1JZ8Ypep2oIqLEaW8+d5djiyac18CLty9ebB47kZMuUlY2vzu6OokCCwJQ+KruX4YBn1M/h9hNIW7aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=FT/csjbq; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-9487e2b95f1so20963039f.2
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 03:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1762513440; x=1763118240; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L5VodCG3bTal5vrS9k2SlGtZ950F4z5chIAl+OKVPjk=;
        b=FT/csjbqPjXHu4j+S/opnVm2SNJGIq2x0f+HOOKEisK2soNU19trNmGfnEOyyymdON
         syXZ0NS+Z1BaEvgrTa3TDFzLOQJ/IeT7IMUwV4dTsHScPA9pKZwD5GwQRIdsBxtTMW5F
         1lOzZwN5m4AEAtn7Ez9eHZ7vjQVZ/xbL3OUDyxEGFYof/Csy30wj5XE4Jh49iw5kyU51
         yYiWpoAYUMO6016bfPRLrMJcr/DJuMObsaxtVKe12BoiwiYjWdEn3gC5VO5rxYaZoP5w
         vKpfFvLowsNDgnD1dodlW+31apQ3uhk0zJrFxO5bDp5Xmr0o4vSTRruVIj1/OA9Kw0ru
         xUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762513440; x=1763118240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L5VodCG3bTal5vrS9k2SlGtZ950F4z5chIAl+OKVPjk=;
        b=XEpgPhN+btd3KULa124x/zzAQ5q4G8IVtSzImxylAigPI27H0qfEp2Oz120evS5QSv
         btCpVXz2KbZ6+KH1kaL7A3F/P4cuM0bOIyqoJM1vig6wI96lZuZzZCzYJzeO6QHYUI+m
         b/pSGB3KE2pPCiwFLa0XvqDa+5DBi+lzh3eSsF8Uv3V3l2Dggb3O0TSaW9CV/0HBIlb6
         S154pd+1Hbwq2khXJLY4/L7fXL2SgfCGz9BYg5V0IDLiW24cCSw5WG7fuhAoklpfNCIM
         7Qh94f9G7TBlDmMn/sCbxKTg8PJmQD3erPtOpjjSp7KOr6m6ZEB6U+Cy/hCuwJOUPxs2
         ZQ8A==
X-Forwarded-Encrypted: i=1; AJvYcCUjUHtStBcUyPA7xYxiXhIq0gwlztYmsw43djj956UDIFz0IfPjLOIaOykRYl0SBCoIG/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYgu5daecndFYgFJ/NERQPPcKrlQhuxy4XDOPLp+9uPYyL2Uyc
	yvg+MLJF8qugEB1Mslfu+L9yobq955kxeCJMtMSQV6YE6TPPyjKZzEZBTwE4d9JOXIc6/rmJd8o
	fUroejrbFhB0S22ujvZmXt7+3Tc5+DAZgfK+jxmADXszHfpqYSWGr
X-Gm-Gg: ASbGnctXllvz0+U1aGR7BqwlD/P/zYs6zfGb5uUVWxUGfEw3lu/TEJsvV7hqfdWEdVd
	G+U17nM+NYbZfjIn7FzgXIP7Ikz4d4KsGN1p2K3FD0fC4ogKnTGxc2Z+QBfjK+tHVKIQnDqUH5T
	JXEvrtn9DC/MXLRs+rIJ4RbTshm4h1dkJ7AdjqGDFxKsRiQrKy/udYJXKSp+TCQIdZ/+Yc852gE
	tLXU0yvy92eM5dHpI7CEdzo9+mMx3bxB88tKy7czYNXxB+zC4VPp+1dEDj+taV+1i3utjlv
X-Google-Smtp-Source: AGHT+IEq9I1p8OP3yDbh00Mj9+qoqszlTYDSFXyp8DuqLQvxre/JkxTDPf1QjwQFRLpKChHb1al8+Tk6n1fWExeFbow=
X-Received: by 2002:a05:6e02:3044:b0:433:258e:5a92 with SMTP id
 e9e14a558f8ab-4335f479c79mr44021005ab.32.1762513440480; Fri, 07 Nov 2025
 03:04:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103062825.9084-1-dayss1224@gmail.com>
In-Reply-To: <20251103062825.9084-1-dayss1224@gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 7 Nov 2025 16:33:48 +0530
X-Gm-Features: AWmQ_bktMTn5j_WJdcxCdJE6SpTHSxLvgVWZIkGAWguCXPvlqqDsCY8TuZP0sdM
Message-ID: <CAAhSdy01XGT6psT+3EgHbgyyOhuXP63Zv1K2acvDZKD0LxxQ=w@mail.gmail.com>
Subject: Re: [PATCH] KVM: riscv: Support enabling dirty log gradually in small chunks
To: dayss1224@gmail.com
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Quan Zhou <zhouquan@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 11:58=E2=80=AFAM <dayss1224@gmail.com> wrote:
>
> From: Dong Yang <dayss1224@gmail.com>
>
> There is already support of enabling dirty log gradually in small chunks
> for x86 in commit 3c9bd4006bfc ("KVM: x86: enable dirty log gradually in
> small chunks") and c862626 ("KVM: arm64: Support enabling dirty log
> gradually in small chunks"). This adds support for riscv.
>
> x86 and arm64 writes protect both huge pages and normal pages now, so
> riscv protect also protects both huge pages and normal pages.
>
> On a nested virtualization setup (RISC-V KVM running inside a QEMU VM
> on an [Intel=C2=AE Core=E2=84=A2 i5-12500H] host), I did some tests with =
a 2G Linux
> VM using different backing page sizes. The time taken for
> memory_global_dirty_log_start in the L2 QEMU is listed below:
>
> Page Size      Before    After Optimization
>   4K            4490.23ms         31.94ms
>   2M             48.97ms          45.46ms
>   1G             28.40ms          30.93ms
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> Signed-off-by: Dong Yang <dayss1224@gmail.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this patch for Linux-6.19

Thanks,
Anup


> ---
>  Documentation/virt/kvm/api.rst    | 2 +-
>  arch/riscv/include/asm/kvm_host.h | 3 +++
>  arch/riscv/kvm/mmu.c              | 5 ++++-
>  3 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 57061fa29e6a..3b621c3ae67c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8028,7 +8028,7 @@ will be initialized to 1 when created.  This also i=
mproves performance because
>  dirty logging can be enabled gradually in small chunks on the first call
>  to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
>  KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
> -x86 and arm64 for now).
> +x86, arm64 and riscv for now).
>
>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the nam=
e
>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that m=
ake
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 4d794573e3db..848b63f87001 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -59,6 +59,9 @@
>                                          BIT(IRQ_VS_TIMER) | \
>                                          BIT(IRQ_VS_EXT))
>
> +#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE=
 | \
> +       KVM_DIRTY_LOG_INITIALLY_SET)
> +
>  struct kvm_vm_stat {
>         struct kvm_vm_stat_generic generic;
>  };
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 525fb5a330c0..a194eee256d8 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -161,8 +161,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>          * allocated dirty_bitmap[], dirty pages will be tracked while
>          * the memory slot is write protected.
>          */
> -       if (change !=3D KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_P=
AGES)
> +       if (change !=3D KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_P=
AGES) {
> +               if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +                       return;
>                 mmu_wp_memory_region(kvm, new->id);
> +       }
>  }
>
>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
> --
> 2.34.1
>

