Return-Path: <kvm+bounces-45708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0EAAADDA2
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 13:44:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C7EE17D136
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 11:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913E9234970;
	Wed,  7 May 2025 11:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="gU1jYMHt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6952233701
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 11:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746618245; cv=none; b=ZpA/dul/JnZXhQeEngl+f9RQ6bZG6TZCu1EfrK0RjHqeiL0pdQWwZ1ya733jWGhOafkDcL2SM/3zD4ElwBWyCoPqAhVO8O75apfBRGtluYBr7f4IwmMHt005mFzgkPgctdub9ceIvX9DQToglYViv3IqxmF7yvfKP99u0jDL1wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746618245; c=relaxed/simple;
	bh=qEEBf/EvhFb5+S8vt2g6XJwST6O0nTQJRpn12U1g7EA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZHKnqUV9h0YFaQ9+YX8PlcO0wLLCLzRTmcdjwqR8WKrui4ZYHp3ivwENe87hbPqZrdEl3qa1mb0EbTB2EG1bL3xG4HbDtQpskNbD6oFj1vztVK++XZ7XHoSLT7oQA63hsRHQdldwA3j0EwA6aaM8MtzES7FPG36wgk5/eV///n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=gU1jYMHt; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86135af1045so780171839f.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 04:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746618243; x=1747223043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bVz2E+K/uMAryK5WXZfBalhzFkygNbdnQ6nqZ/JT97Y=;
        b=gU1jYMHtLBX/bg6svOh/7/0bsT6Z+HrtMQzz7sSs+MZt1TfP1dglBLOf69poDnGZKN
         rGGzzdWiMTgzVDiLw7vgrMpVRWE+1J74dwaV1KTqsnVjik5t+NuxzGiSUQ2ZGnqCIxNp
         VXa8wyN+oH6CKLiCNzpnoxi88jnA5qACOS3BAagy2svsLUdUYPbe0PBSU/678M5grmac
         CP5jSi5Y9JDkKVdXRfHqwNXY0OaiOG6skPI2gvMB0phNILSWNOhUn67LfSapnmwMlbbb
         8BndgiZM/syqMYPm2tzvwYob1FQfT31nsoj5ZY9u9SQYiL6abQjzgCQ33ZczPsfdMsXE
         Ar0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746618243; x=1747223043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVz2E+K/uMAryK5WXZfBalhzFkygNbdnQ6nqZ/JT97Y=;
        b=EJgGjsA+MJHEFUbzesxAjGMDUE/EkuHYan6vO5Y+6nPcfz+56ClCttxwz18x/HSpDc
         SpkjWkFTGstIT6Wn4Z4hBxYBKNwnhWY7FyVymyqp4Fz1mA+BmKTGjgC748RymDQS6w8i
         07+bIfeLheFk+2s7vlf+JT04GUqHyvmCd0J4NURqwPurEkxGX/A9ot4qpI/2ZwodMc4S
         PFpwoaPKRhurjy7ZR1V9YgzFSCUOiKDjRMQVomOo6Y0yaW8YhjApc4G3/x2uGDo0wqYA
         rtSq3nBbgk8klc2E9w0g56yhYO0/y7Wm1rydnU0qlmaW4Y0vvrIaHsjnZbwKe4eC2Fuf
         iGiQ==
X-Forwarded-Encrypted: i=1; AJvYcCW88F7r1WNMpJ2WhSv8ErnCF8cT6/XZ4wrFLBdaOgn3owFt1o7FbJlnQQo6SJMPFO9WbnM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSM2WbiEFyBtYWlt/SI6rloBK9hFE3bbm3JBMAB8t8S8s847nP
	HAPECh5HR5R8AcVEg1qJ9izCTQRrStUOqHLGcboQ46VjvLaPnZAspNq9G6vtO82g5LXDKLfIlHT
	m/9NooZRHudIOUnMW4++ScFEA5gDMhXwVnIil3w==
X-Gm-Gg: ASbGncs0irdANTjqa9FRUzG27oXkdMKm00O5oSmeFE8zavJ1xICb3IiI2EAvzHletu0
	cbRlRPtHh9O2Ry6VpieTNwiwgmZeyPe6HWO84CKjwIPlp3FuBQ6Gm16KxLgBkyPSsIzuKiWjT6e
	dGUICDQzamt70Z5oark4H+RcknkI12jtb46w==
X-Google-Smtp-Source: AGHT+IEqTEU3gW24Jmigd2cIa8Pl0Ves+lUOw1f5tu/7B6fJK/PzbflFbxkax13tPvkDxDTPwZvRy4srBUyjnSLHpH0=
X-Received: by 2002:a05:6e02:1529:b0:3d8:21ae:d9c with SMTP id
 e9e14a558f8ab-3da738e9934mr32539925ab.5.1746618242847; Wed, 07 May 2025
 04:44:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com> <20250403112522.1566629-4-rkrcmar@ventanamicro.com>
In-Reply-To: <20250403112522.1566629-4-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 7 May 2025 17:13:51 +0530
X-Gm-Features: ATxdqUETEm-yQn1qrwlBDD0f3dy7uLqyAaalj3uycXV7-PAmSrqpx552FKWRajk
Message-ID: <CAAhSdy0XBTW1FUuUwSBanspDwpHMRbBL-8oSiRR1R=5SgF1+hw@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: RISC-V: refactor vector state reset
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar=
@ventanamicro.com> wrote:
>
> Do not depend on the reset structures.
>
> vector.datap is a kernel memory pointer that needs to be preserved as it
> is not a part of the guest vector data.
>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>

Queued this patch for Linux-6.16

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_vector.h |  6 ++----
>  arch/riscv/kvm/vcpu.c                    |  5 ++++-
>  arch/riscv/kvm/vcpu_vector.c             | 13 +++++++------
>  3 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_vector.h b/arch/riscv/includ=
e/asm/kvm_vcpu_vector.h
> index 27f5bccdd8b0..57a798a4cb0d 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_vector.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_vector.h
> @@ -33,8 +33,7 @@ void kvm_riscv_vcpu_guest_vector_restore(struct kvm_cpu=
_context *cntx,
>                                          unsigned long *isa);
>  void kvm_riscv_vcpu_host_vector_save(struct kvm_cpu_context *cntx);
>  void kvm_riscv_vcpu_host_vector_restore(struct kvm_cpu_context *cntx);
> -int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
> -                                       struct kvm_cpu_context *cntx);
> +int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu);
>  void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu);
>  #else
>
> @@ -62,8 +61,7 @@ static inline void kvm_riscv_vcpu_host_vector_restore(s=
truct kvm_cpu_context *cn
>  {
>  }
>
> -static inline int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *v=
cpu,
> -                                                     struct kvm_cpu_cont=
ext *cntx)
> +static inline int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *v=
cpu)
>  {
>         return 0;
>  }
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 60d684c76c58..2fb75288ecfe 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -57,6 +57,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>         struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch.guest_reset_csr;
>         struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
>         struct kvm_cpu_context *reset_cntx =3D &vcpu->arch.guest_reset_co=
ntext;
> +       void *vector_datap =3D cntx->vector.datap;
>         bool loaded;
>
>         /**
> @@ -79,6 +80,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>
>         kvm_riscv_vcpu_fp_reset(vcpu);
>
> +       /* Restore datap as it's not a part of the guest context. */
> +       cntx->vector.datap =3D vector_datap;
>         kvm_riscv_vcpu_vector_reset(vcpu);
>
>         kvm_riscv_vcpu_timer_reset(vcpu);
> @@ -143,7 +146,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         cntx->hstatus |=3D HSTATUS_SPV;
>         spin_unlock(&vcpu->arch.reset_cntx_lock);
>
> -       if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
> +       if (kvm_riscv_vcpu_alloc_vector_context(vcpu))
>                 return -ENOMEM;
>
>         /* By default, make CY, TM, and IR counters accessible in VU mode=
 */
> diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
> index d92d1348045c..a5f88cb717f3 100644
> --- a/arch/riscv/kvm/vcpu_vector.c
> +++ b/arch/riscv/kvm/vcpu_vector.c
> @@ -22,6 +22,9 @@ void kvm_riscv_vcpu_vector_reset(struct kvm_vcpu *vcpu)
>         struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
>
>         cntx->sstatus &=3D ~SR_VS;
> +
> +       cntx->vector.vlenb =3D riscv_v_vsize / 32;
> +
>         if (riscv_isa_extension_available(isa, v)) {
>                 cntx->sstatus |=3D SR_VS_INITIAL;
>                 WARN_ON(!cntx->vector.datap);
> @@ -70,13 +73,11 @@ void kvm_riscv_vcpu_host_vector_restore(struct kvm_cp=
u_context *cntx)
>                 __kvm_riscv_vector_restore(cntx);
>  }
>
> -int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu,
> -                                       struct kvm_cpu_context *cntx)
> +int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu *vcpu)
>  {
> -       cntx->vector.datap =3D kmalloc(riscv_v_vsize, GFP_KERNEL);
> -       if (!cntx->vector.datap)
> +       vcpu->arch.guest_context.vector.datap =3D kzalloc(riscv_v_vsize, =
GFP_KERNEL);
> +       if (!vcpu->arch.guest_context.vector.datap)
>                 return -ENOMEM;
> -       cntx->vector.vlenb =3D riscv_v_vsize / 32;
>
>         vcpu->arch.host_context.vector.datap =3D kzalloc(riscv_v_vsize, G=
FP_KERNEL);
>         if (!vcpu->arch.host_context.vector.datap)
> @@ -87,7 +88,7 @@ int kvm_riscv_vcpu_alloc_vector_context(struct kvm_vcpu=
 *vcpu,
>
>  void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
>  {
> -       kfree(vcpu->arch.guest_reset_context.vector.datap);
> +       kfree(vcpu->arch.guest_context.vector.datap);
>         kfree(vcpu->arch.host_context.vector.datap);
>  }
>  #endif
> --
> 2.48.1
>

