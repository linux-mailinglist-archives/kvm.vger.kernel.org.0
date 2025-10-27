Return-Path: <kvm+bounces-61130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 666DDC0BC36
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 04:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 438BC4E9F9B
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 03:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7AA2D3724;
	Mon, 27 Oct 2025 03:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="1pdv+HQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EC0155326
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 03:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761536313; cv=none; b=F6YGRZH2NqaJ9oDQtql7zwbUyoCRrxo2LcCrgjlj+t2oFS+6iA6OyGRLrmw10qbl441NOFmHE1NDE7VdryskOsxtYuRi3q4WpxTzvNI+onx5eJJsAqHWD4aZbXeehRfduzu0AEp5WBs3wmfniz+u7Vxlib3FdWExhWoGQDrwiJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761536313; c=relaxed/simple;
	bh=ykqsBz7ltNcPXKuQY9/QTGVQNnJRyRhhtKcA12vcA/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZ/h5csdvK9crPCwXmedz1nuBkIBxu+/YuJh9X3hKAShSG5LrvPa7pN74NqopNLwG2I1WwurnRq5ch2OeujUgQF24lcJf3CW6rt7afwC8oO6iEcQI8JxdyoS26vjbG0KvRRKkii4z/VLD72vY6bcfRnryZkZly8UNkr1vnE/rAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=1pdv+HQ4; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-945a33e0d55so50077039f.1
        for <kvm@vger.kernel.org>; Sun, 26 Oct 2025 20:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1761536311; x=1762141111; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLv/abQqhTrjCuxnsZKW6XWrZqaImCMO0bBeDuN7Ur0=;
        b=1pdv+HQ4aRXCgsmvJPnow+5C4Cz+nYqKSF84oWDwNrqZkzWOgY1vJpCSBoUQHvFaKb
         qTeZTgwpuIlaowcY9aganZJuJFKxNGadAK3y0Jr1vdnPJIH67l+oipfUDPeWoa3YJHo+
         AJzJkeRMGpzaC3+MSNgzg8RR71I/mVIRpFRUTH/Ikk3yaoT3FhmIdpeg7U7g8kqk7UGb
         xWMoIprbGVhBpwuAWutla9g0ZXsoGRsGgpHMn4g4afs5QHwKw3VfanFz9wihmHestkJl
         Vhj5bbfVt/2rTDFHgambTncdd5iKkWp3Jkzk+ahYDuyv3/cuR9uBScjGYrn7TVB6SffO
         DRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761536311; x=1762141111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lLv/abQqhTrjCuxnsZKW6XWrZqaImCMO0bBeDuN7Ur0=;
        b=nQqJQpYwWUhhKFyZJDCNjvEAkcvISHfP+PHAYlrYPEhgGtJKWStP4yFK6JAZj+eRWv
         XxvziTi+nkXEayIZNEPYvgkLn0sJ7YrgHeQ15GoGe9RoxgEg85WAyF2TrezAKsISXRR2
         ekbkCJS6bhLQPKxHV00AlqUXxFlKBsqQUOosz19Fc48UhWYspIc6VYPBSv4NGVj6pbSq
         9rrAZjjWyL9QweHxSxbIa8WC9VjGLXSDoH1i68xSkG/x5ccmc2sRdtim550egADKIa6z
         NL++3kog5FEiJZ0ZmipWBxkeZ7fLH/Y54VkknCHq6c5k8WOUgPix5kMiCQwGW7Nxpzy3
         JSqw==
X-Forwarded-Encrypted: i=1; AJvYcCXzwfhCaiRDcaRUVTjWqXWqPflgC7vhQOHodSIzGpMF3o/B6B7M67WlPS1dkOOU5tFUxKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhXQighPKk2+nPp/KNTElbRbUMYxRRd+GCQ2tYkqLmAUVZxUrD
	Cy1hISBzsTZyDmm+fZ7h4icQX6y1OljqyQZl8YwpSAz2pwrawe7nFhx7g380yONW6RWNwH7A/ZR
	Lp4pSEG+vOAirlJjhF0x2+87bpifVyBEbDR2ttLjCNA==
X-Gm-Gg: ASbGncupfbSLi2tLKQez5IOhST34c+UEcw6kQppZauWw199pqE11/poaMqcsiicUzEY
	vwCdQF4v2YA9qzqPwF5R5iiZPoaU2EE1xvRPl/J7OpUk08wQoWSO/dkRHzqbjOCz1bdTPPDcjxG
	x4iynfVGjbYHy8IhduBGjNjuZvLWxZScch1lRjagciHoPPHiE8WX7rRJ+lY4mmOawDkgCfQTocf
	4aUPaeyIAb2h3tfRczfzAD8+kkQ7yjhDfd3PBpbNCtY5/mWMIXp1KEwWso2t7qtjoll/JtpyhdS
	5iXEhL0Lp7f5FC7w493Mqbe3V2gcnGmYw+EP0KEMvhdkLVFBE2oHw0v2CVsJ
X-Google-Smtp-Source: AGHT+IFXk1YUaLAdhvo8rgPkIKe5gLo/c+djIhEIA40LWqKcizzRXoBKOFj4cyggO2AuZkgxTRXbB8jToGSbWYc3oMw=
X-Received: by 2002:a05:6e02:190c:b0:42f:9eb7:759b with SMTP id
 e9e14a558f8ab-430c5306894mr466704455ab.28.1761536310727; Sun, 26 Oct 2025
 20:38:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251017155925.361560-1-apatel@ventanamicro.com>
In-Reply-To: <20251017155925.361560-1-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 27 Oct 2025 09:08:19 +0530
X-Gm-Features: AWmQ_bleYZ_iePePDvRC5d6Pe5JA_nbAbhQUpFmow4pTKUmpRz54E4-TMp1PLS4
Message-ID: <CAAhSdy1+AFQepjrfKrcQvC8cxDpjOHfF500O6FXTYzf-iksCfw@mail.gmail.com>
Subject: Re: [PATCH 0/4] SBI MPXY support for KVM Guest
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Andrew Jones <ajones@ventanamicro.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 9:29=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> This series adds SBI MPXY support for KVM Guest/VM which will
> enable QEMU-KVM or KVMTOOL to emulate RPMI MPXY channels for the
> Guest/VM.
>
> These patches can also be found in riscv_kvm_sbi_mpxy_v1 branch
> at: https://github.com/avpatel/linux.git
>
> Anup Patel (4):
>   RISC-V: KVM: Convert kvm_riscv_vcpu_sbi_forward() into extension
>     handler
>   RISC-V: KVM: Add separate source for forwarded SBI extensions
>   RISC-V: KVM: Add SBI MPXY extension support for Guest
>   KVM: riscv: selftests: Add SBI MPXY extension to get-reg-list
>
>  arch/riscv/include/asm/kvm_vcpu_sbi.h         |  5 ++-
>  arch/riscv/include/uapi/asm/kvm.h             |  1 +
>  arch/riscv/kvm/Makefile                       |  1 +
>  arch/riscv/kvm/vcpu_sbi.c                     | 10 +++++-
>  arch/riscv/kvm/vcpu_sbi_base.c                | 28 +--------------
>  arch/riscv/kvm/vcpu_sbi_forward.c             | 34 +++++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_replace.c             | 32 -----------------
>  arch/riscv/kvm/vcpu_sbi_system.c              |  4 +--
>  arch/riscv/kvm/vcpu_sbi_v01.c                 |  3 +-
>  .../selftests/kvm/riscv/get-reg-list.c        |  4 +++
>  10 files changed, 56 insertions(+), 66 deletions(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_forward.c
>

Queued this series for Linux-6.19

Thanks,
Anup

