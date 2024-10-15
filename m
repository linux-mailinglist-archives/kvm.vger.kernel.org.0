Return-Path: <kvm+bounces-28840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB4999DEA8
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 08:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CEBDB2229C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 06:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D6818A6DE;
	Tue, 15 Oct 2024 06:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="muNHin34"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E4116C6B7
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 06:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728974717; cv=none; b=d+mb8m37qiCyHr0xkS7aHnnUcFza6vl8Q6AbxFoxbdYno4Ylo2AUOZHJ1UpkZ2mESE9XKFL+XCoyku51SlBn09MPqo6BhqHY7zrRXNk4eLoAZs+WRGcXFRgCSPU5B5WD0RLMICukCa8woMlZiWSV3Ks0ZzozoVbrBv4V0SHsMe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728974717; c=relaxed/simple;
	bh=cygSbdL1l01PDza4eT3vUI2V72T4WMHSiJjgEk2Kvzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YCsTkKJZ3oeLTJ9tKu4nKJapnWWzfpni2CxYNdCdraMs7kG7meeVF8zgg2KhNMpoupcgycB03LnnLq39sOapHg6GuWzm4BGVcLYYyuyQeZ7iN5C1pA6M+YGNL0T/VTWaLMSulEtNYrLoql6hv+M/ZRWsCpIvKYp1LqAZMgnnx0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=muNHin34; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-837ec133784so133126739f.3
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 23:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1728974715; x=1729579515; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTOjdDeupMvfI1VTnlp57mS+VDL1wc+Sjs4FCRiPhYg=;
        b=muNHin34gOp/KOx28BzPv57yrdXSBdo6cbeKyAzwkHCwr/E8ZyFFe2VI+nEijv0GM/
         ddwIXm+eLXio1vkeDenYw4BHacTC+bom652aaVzCrHYboXd/e3weWq9VHZkiAmbTlOi1
         i0K+sMeXDopwjkZciqXhGqvDHqRHEFDpqSVL506lkXy3uM0HQb9Mm7SOwD8VeXiRbMMW
         qZjwpIjLd8aDhpkcHEp+cC1SZOIXXyysi3fHDq7NVcNExv9lr0yina9fCvhSu0gcyFRQ
         yIlGl22hfHg/9WwlIj9wWmMPGtJNbA9MBZMy14/iqTZnKSwuoxU+xhpnCc3CqS/EYnxG
         p+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728974715; x=1729579515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTOjdDeupMvfI1VTnlp57mS+VDL1wc+Sjs4FCRiPhYg=;
        b=A0HJA/LaX8s1xF4E/29nMU1xrAn0GtOptuuQGfizyGGhgsF8nAtU/jQyaRHaZAahQl
         mv1+gXAViq80Sh1x4cuRg+dhAQ/GAx1V88ZsVlLUZLSX3Dl+4UQPHf9zZnJgrhzNzMc6
         S0TKo4P1tegGJXhtPWGvmBoxCTbH4UyQKB4Tgj0ywrmZ9OC5iAS0n8FWzR0MMOwcXk6R
         EgEGkyFhDGlD1N51of/AjUrboNKs5KojI3UUmeQFitnD9I6NtSwtzrdYE8VbcCMrn2Jf
         EXVKdienPpQgphAcFZkYH5MYwqUYetJWVChXkdnTRr/B0LXkBe9uZ+QEEE5OmZhxihTr
         PPHA==
X-Forwarded-Encrypted: i=1; AJvYcCXCRVsHkwNssZda3KBpIVmoCmRhrWULO1KMASHe6rNLMuMaOE4VYhi7KtHRghZdTnnke3I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4kVUKvqzn5EnaqZ/IayaB/F9Se+fXK2P80Yc/lPgvfxCQT/vh
	v6r8NWYV3PXHCxOn+8ovI09y+wEuRnukfEEM5BKxbFOO3UueQjh9fupDEOepipBLEOXd77M1zdd
	CpBia72lCbXIYDKWtjOqI8X/5qpSACHY9+cGmgw==
X-Google-Smtp-Source: AGHT+IF+6ytBf2/P7xS3z4FPEZJZLcGyWg4N3M08mx1lsLaOIO9RQVHctNrSJxlvVx8vLnBAocKVchobXr+NRQLS1Xg=
X-Received: by 2002:a05:6e02:3b0a:b0:3a1:a57a:40a1 with SMTP id
 e9e14a558f8ab-3a3b5f233a9mr120319715ab.5.1728974714838; Mon, 14 Oct 2024
 23:45:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240919160126.44487-1-cyan.yang@sifive.com>
In-Reply-To: <20240919160126.44487-1-cyan.yang@sifive.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 15 Oct 2024 12:15:04 +0530
Message-ID: <CAAhSdy3x680G2cXqam0uc1kAAg_Cd1tFhBVygOrLZ0bL9ztDBg@mail.gmail.com>
Subject: Re: [PATCH] RISCV: KVM: use raw_spinlock for critical section in imsic
To: Cyan Yang <cyan.yang@sifive.com>
Cc: atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Yong-Xuan Wang <yongxuan.wang@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2024 at 9:32=E2=80=AFPM Cyan Yang <cyan.yang@sifive.com> wr=
ote:
>
> For the external interrupt updating procedure in imsic, there was a
> spinlock to protect it already. But since it should not be preempted in
> any cases, we should turn to use raw_spinlock to prevent any preemption
> in case PREEMPT_RT was enabled.
>
> Signed-off-by: Cyan Yang <cyan.yang@sifive.com>
> Reviewed-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>

LGTM.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/aia_imsic.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
> index 0a1e85932..a8085cd82 100644
> --- a/arch/riscv/kvm/aia_imsic.c
> +++ b/arch/riscv/kvm/aia_imsic.c
> @@ -55,7 +55,7 @@ struct imsic {
>         /* IMSIC SW-file */
>         struct imsic_mrif *swfile;
>         phys_addr_t swfile_pa;
> -       spinlock_t swfile_extirq_lock;
> +       raw_spinlock_t swfile_extirq_lock;
>  };
>
>  #define imsic_vs_csr_read(__c)                 \
> @@ -622,7 +622,7 @@ static void imsic_swfile_extirq_update(struct kvm_vcp=
u *vcpu)
>          * interruptions between reading topei and updating pending statu=
s.
>          */
>
> -       spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
> +       raw_spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
>
>         if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
>             imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
> @@ -630,7 +630,7 @@ static void imsic_swfile_extirq_update(struct kvm_vcp=
u *vcpu)
>         else
>                 kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
>
> -       spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
> +       raw_spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
>  }
>
>  static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
> @@ -1051,7 +1051,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *=
vcpu)
>         }
>         imsic->swfile =3D page_to_virt(swfile_page);
>         imsic->swfile_pa =3D page_to_phys(swfile_page);
> -       spin_lock_init(&imsic->swfile_extirq_lock);
> +       raw_spin_lock_init(&imsic->swfile_extirq_lock);
>
>         /* Setup IO device */
>         kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
> --
> 2.39.5 (Apple Git-154)
>

