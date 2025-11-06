Return-Path: <kvm+bounces-62148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 217E4C39301
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 06:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDEBF1897237
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 05:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED5C2D8DC4;
	Thu,  6 Nov 2025 05:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="jwMybd2v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDDE24166C
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 05:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762408086; cv=none; b=FyuQZRbaqqsI/kVY7HB2U6Bu6JcGZcmkdFlZ+FHHuCMf4NGVBVVAXFw5yQwYH0H5up/Ng8C34po330yc3NCAV0zm2KDpo7ToF2ivxF6ibCJwQaF7wDGoqcR+XaRtUrakTybV9eH37HWQLJIqzF6LnkP5V1fMv3eP/FWiQI8+s5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762408086; c=relaxed/simple;
	bh=8XRNkDGcev4wjXeN5rtSeb2UjJZSMlpIuFc4FifvGkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZhnNTlO5ZZIk6f7tp6KwN6aM7w8QUiUq2N6Me1a+31k1LsgQMM2+jkpt1d/riHGnY8Njb2MUV54jE9/k+XJj+a486ELKD76uPfl0RzN9YaiDOj093m+D0KsDvwF0swvdHdMTXE2uVOxN1Cacr4vGTGY4GTB/RYeaSUbo0KQWWL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=jwMybd2v; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-9486251090eso46130739f.2
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 21:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1762408083; x=1763012883; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3uoew2SarmiylnjDmk3L9GFoWwHK51enAJRQNH2IHjc=;
        b=jwMybd2vspIS0ixUv3Vji9As6RoIfO1BG8XcrHsra78OiMmKRs9+XZlyJhcpGjHtHZ
         CiiRoFnrBAtxS1+vxsfzyp2fWM4XudwlvK5fnbsBk8QrH2oyoFxot17LbLQw0QJ6BgVa
         WDZQfdUA69kP8YnaWCDx8kLtz6vW6FsDJgTOk/h030PMWqPnYFt6vJEMCQfgOct7aXbe
         EomTu4ruux8PhFNHcNc5bNH6nyVcJVOcIs7Q/JW1UsYZGnGmMXsn/xMJ0hBicLdgGLTo
         CcP1C9+DH4wYOWnXd57nBwt/+svRR205yDq9z76DLHoNV3MaO1LD5UvW11ZXwB4mseJK
         3ejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762408083; x=1763012883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3uoew2SarmiylnjDmk3L9GFoWwHK51enAJRQNH2IHjc=;
        b=USpwz7KSRutLRy54T45rrz+e312PvMGvjS+BWIhRHL5zxs4scIkgKOHX2U83IdDX5y
         oXgYRcZvkdtDTRluO6jTfqnzDEJQ2w9DLlrLSCbKBUJ6lxttCOndRojKFZQjw6crUolI
         pQMkK1AP1/kiuBjQhI82b6Is0gPAHYgRL0S9FZNv8pjL9TOMuePluLI7wNS8gZrCwAfg
         IYPQ8nt8iXVOLqYfOMINAiD8ADc6ZuP0JUx9FxJNtnp5nWjRxr9j1RdTt29d2h4v2/7Q
         wumNjpEEQExOKy+pEhWRwhsBAWhJfXf2UTi5bCZOklhLGoVQzAZ/iemqjfI6f6iw7/F7
         6imw==
X-Forwarded-Encrypted: i=1; AJvYcCWD8mapTmGhQl1dr3Fvqe+brMdEZWWKV2hnbbTK9h6rocZBcQfE81af+LCbGuOXBwk/YUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPs2UCiS8RJDqcENYzUuJo/592IMoAE3FqFSLo+k89fQPlIYRZ
	PMAtANi6gDbVQDBZr0CFDhNec/anj2NLAqDd26UmQpS1NDcFMBNR12f7z8HplHh0ZK/4+AR7nni
	dVC3ET39+al1labt9f573hLP5bJhl/RYIg7i0XEc1ag==
X-Gm-Gg: ASbGnctTAWX+8dyuUSN/LPGQQZHrpvh8g1LHwXJVSyWgUjp5IV+JIQlDseMXjrxCYIT
	yi4fteOBeXuGJ2Zp++Kou+o6nszzF2exVU7TylN5DN0uNZzvHPyVFTII7iADBAQl/U4sIk2J1eg
	nvz2UvGlFR2EAw+PRG/axDBklnNBLjmMBZxTzDyyc+ybd8ZQmijkAGKVslnsJl3o5dXAy5dEpoN
	XU//a+g2fk1x4DonjHqdQvWlu1ayGtaPB0b2pP35x1co+tx44xnuX4m3AANFw==
X-Google-Smtp-Source: AGHT+IFbNEYpDbiUd8mOqCap1mJWhYJV/tTSDvIy+00/QF2eXniMKHHbQXm4twuBcloi6qoxWYJp8gwaXR8SH9byI/k=
X-Received: by 2002:a05:6e02:240b:b0:433:23f0:1ebf with SMTP id
 e9e14a558f8ab-43340779d13mr96165935ab.9.1762408083096; Wed, 05 Nov 2025
 21:48:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250923053851.32863-1-xiangwencheng@lanxincomputing.com>
In-Reply-To: <20250923053851.32863-1-xiangwencheng@lanxincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 6 Nov 2025 11:17:51 +0530
X-Gm-Features: AWmQ_bllfHXAxLhpsO6n51JY0CLvNreW7JWG-sL9GnCN1uB2qpTsPmrk7YdRxzE
Message-ID: <CAAhSdy0OSCxo2oPYEhWjUJbOfx3HJ7Ak4KoVv4fi3ukKm6dRCg@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: Introduce KVM_EXIT_FAIL_ENTRY_NO_VSFILE
To: BillXiang <xiangwencheng@lanxincomputing.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, atish.patra@linux.dev, ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 11:09=E2=80=AFAM BillXiang
<xiangwencheng@lanxincomputing.com> wrote:
>
> Currently, we return CSR_HSTATUS as hardware_entry_failure_reason when
> kvm_riscv_aia_alloc_hgei failed in KVM_DEV_RISCV_AIA_MODE_HWACCEL
> mode, which is vague so it is better to return a well defined value
> KVM_EXIT_FAIL_ENTRY_NO_VSFILE provided via uapi/asm/kvm.h.
>
> Signed-off-by: BillXiang <xiangwencheng@lanxincomputing.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Queued this for Linux-6.19

Thanks,
Anup

> ---
>  arch/riscv/include/uapi/asm/kvm.h | 2 ++
>  arch/riscv/kvm/aia_imsic.c        | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index ef27d4289da1..068d4d9cff7b 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -23,6 +23,8 @@
>  #define KVM_INTERRUPT_SET      -1U
>  #define KVM_INTERRUPT_UNSET    -2U
>
> +#define KVM_EXIT_FAIL_ENTRY_NO_VSFILE  (1ULL << 0)
> +
>  /* for KVM_GET_REGS and KVM_SET_REGS */
>  struct kvm_regs {
>  };
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index fda0346f0ea1..937963fb46c5 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -802,7 +802,7 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *=
vcpu)
>                 /* For HW acceleration mode, we can't continue */
>                 if (kvm->arch.aia.mode =3D=3D KVM_DEV_RISCV_AIA_MODE_HWAC=
CEL) {
>                         run->fail_entry.hardware_entry_failure_reason =3D
> -                                                               CSR_HSTAT=
US;
> +                                                               KVM_EXIT_=
FAIL_ENTRY_NO_VSFILE;
>                         run->fail_entry.cpu =3D vcpu->cpu;
>                         run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
>                         return 0;
> --
> 2.43.0

