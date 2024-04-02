Return-Path: <kvm+bounces-13327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E5A894A25
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4B3D1F232FE
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0688517730;
	Tue,  2 Apr 2024 03:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="kPdVsclW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A6C1426F
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 03:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712029701; cv=none; b=u4PBNVDq0sKCSjG9dOBf7gD/KOy6cTP9NWM7UyoRaE7dE56OiTDbXhN+9BgQ3x1nDVlJDLeLllpLOpRLbZfkrodRvQc92Wn3j+q4CrCH6in2qtHmf1p08L3WKsXEn1/aGOS1DWixLC2nVZ8UcitfR68TgSInW2dJZH9shXyQaqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712029701; c=relaxed/simple;
	bh=kI815bMsDbY8kqaxKHfdXHWZVEEVlQcFE4nyQHcP1xI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VtMTXUPAETqayrE0khRl5yG6PzS3b36GJSyB2+cgvu9YwBgz8W6oC7ckiEX9YfdNOO7VXz2xGrjuvi7YRSl9Y6mGpDQ3crKh3yqIzv9pISw3LKDM9HqGO30Xrm67ZbojXbft3IhhgBdp/xouPS+FbYuwPbLDALMNDgDy0/LZJXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=kPdVsclW; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7d03a66e895so151348439f.1
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 20:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1712029698; x=1712634498; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRXP8PEDy6HBuySOmMSBHLD3rej3TEfmNESOFzF7VxM=;
        b=kPdVsclWsnDlAEdgnECcDO1yc/IEBO4zwRrgbVXFCaZXlfa8RUx1YgtQBxcroTJ/Hd
         axZorULK0FAi/1FFpzRcE+glfxiBhOpvtKwlys9Ae2a/vnqUwOKCdWNbyHXyz6Zc9p6e
         KqDe4u2qeJPMBfazVZ2OR564Es1zvEjtk2C7eGPLE7IXl2vi2VecV0sftqyKjgpnzJ81
         geS3YWgs9w2CEk7Vogd5QNNaT7wgd7eZrWhPhshk31E7GqsSA4cPoA2OUvu04GGU9X5C
         ufamJkHzJPbULzClaL+U4CnhxMZ4GJrLTmJVyYCeI5s9ffTUS5kQkmmGZdruAjYjMZ7z
         KcmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712029698; x=1712634498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRXP8PEDy6HBuySOmMSBHLD3rej3TEfmNESOFzF7VxM=;
        b=DZb9Z1mcLqZBuokuLCGAVxTb6LdOpkgxRSHQIbUpbPxgeb1qXmMzp5fhGI+WEgJ4lM
         JJBjsTsc0iwA6pcp00x0f8jl78z8U+MCkqqTLrBnUxiWDwP5Hawmeg2JfDZawKMWHFPf
         WbGqCs8zMhHKY+GPk8/B4pCuGFK1Si9c+oRTHQEQofohiJN3EJuOT+4PaOtflhpjgsnf
         XgZlp61NhIqvKiSzU11XlMh2es1KPgQS0nA45rO9VaXY5f5uolFfyDLD3KNJLHTScHTO
         5Yv7iur+JAq5kiJpT+xCAdg4A+BwHnHHEqz7YCpC4jaITiGYNa20B9w3fmvntIRabKqd
         kAUg==
X-Forwarded-Encrypted: i=1; AJvYcCVwWLQBadso6lFA7DmQPtJP4K/Q9UV+K1N4aJkqrw4dTrpBtKUoqQuoK6bT6YbM6suNoULCNPetkJwSAz1QJC2tiZvO
X-Gm-Message-State: AOJu0YxQRwkAhL4KE8eGahCHkMJL5mwjTXVOr47kv/p+OsrL4eGJ/unm
	9Ch8lB1blGIkPSzb58uZ5mLHd0o+eRGKv2O5uUwvZVBO4GBVeg3E/irKHJToRH41nqXW3Jh7iWp
	EjADgZ8m1B6jAzGzSTa/Fw1W79nQfpdUlqphnqA==
X-Google-Smtp-Source: AGHT+IF1duoALxvuX8eHPfl9RZKHZIUXolYB8P0dgKvksS2q8ui5gKbpX3zdmcEpcaLgyqrviWZN37MNZIPjYy3xMFs=
X-Received: by 2002:a05:6e02:339b:b0:369:943c:d35 with SMTP id
 bn27-20020a056e02339b00b00369943c0d35mr6053675ilb.11.1712029697835; Mon, 01
 Apr 2024 20:48:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240326101054.13088-1-yongxuan.wang@sifive.com>
In-Reply-To: <20240326101054.13088-1-yongxuan.wang@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 2 Apr 2024 09:18:06 +0530
Message-ID: <CAAhSdy1EOyzg+Sdx5-uJJqFipehde+zGic8jNnnTXBEj7k4P3g@mail.gmail.com>
Subject: Re: [PATCH 1/1] RISC-V: KVM: Avoid lock inversion in SBI_EXT_HSM_HART_START
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2024 at 3:41=E2=80=AFPM Yong-Xuan Wang <yongxuan.wang@sifiv=
e.com> wrote:
>
> Documentation/virt/kvm/locking.rst advises that kvm->lock should be
> acquired outside vcpu->mutex and kvm->srcu. However, when KVM/RISC-V
> handling SBI_EXT_HSM_HART_START, the lock ordering is vcpu->mutex,
> kvm->srcu then kvm->lock.
>
> Although the lockdep checking no longer complains about this after commit
> f0f44752f5f6 ("rcu: Annotate SRCU's update-side lockdep dependencies"),
> it's necessary to replace kvm->lock with a new dedicated lock to ensure
> only one hart can execute the SBI_EXT_HSM_HART_START call for the target
> hart simultaneously.
>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  arch/riscv/include/asm/kvm_host.h | 1 +
>  arch/riscv/kvm/vcpu.c             | 1 +
>  arch/riscv/kvm/vcpu_sbi_hsm.c     | 5 ++---
>  3 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index 484d04a92fa6..537099413344 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -254,6 +254,7 @@ struct kvm_vcpu_arch {
>
>         /* VCPU power-off state */
>         bool power_off;
> +       struct mutex hsm_start_lock;

Instead of a mutex hsm_start_lock, let's introduce spinlock mp_state_lock
which needs to be taken whenever power_off is accessed. Also, we should
rename "power_off" to "mp_state" with two possible values.

>
>         /* Don't run the VCPU (blocked) */
>         bool pause;
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index b5ca9f2e98ac..4d89b5b5afbf 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -119,6 +119,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         spin_lock_init(&vcpu->arch.hfence_lock);
>
>         /* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
> +       mutex_init(&vcpu->arch.hsm_start_lock);
>         cntx =3D &vcpu->arch.guest_reset_context;
>         cntx->sstatus =3D SR_SPP | SR_SPIE;
>         cntx->hstatus =3D 0;
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.=
c
> index 7dca0e9381d9..b528f6e880ae 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -71,14 +71,13 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *v=
cpu, struct kvm_run *run,
>  {
>         int ret =3D 0;
>         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
> -       struct kvm *kvm =3D vcpu->kvm;
>         unsigned long funcid =3D cp->a6;
>
>         switch (funcid) {
>         case SBI_EXT_HSM_HART_START:
> -               mutex_lock(&kvm->lock);
> +               mutex_lock(&vcpu->arch.hsm_start_lock);
>                 ret =3D kvm_sbi_hsm_vcpu_start(vcpu);
> -               mutex_unlock(&kvm->lock);
> +               mutex_unlock(&vcpu->arch.hsm_start_lock);

The use of kvm->lock over here was also protecting
simultaneous updates to VCPU reset context. It's better
to introduce a separate lock for protecting VCPU reset
context access.

>                 break;
>         case SBI_EXT_HSM_HART_STOP:
>                 ret =3D kvm_sbi_hsm_vcpu_stop(vcpu);
> --
> 2.17.1
>

I think this patch can be broken down into two patches:
1) Patch replacing VCPU "power_off" with "enum mp_state"
    and introducing "mp_state_lock"
2) Patch introducing VCPU reset context lock

Regards,
Anup

