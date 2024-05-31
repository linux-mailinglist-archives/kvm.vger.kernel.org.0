Return-Path: <kvm+bounces-18532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F058D609B
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 314ED285BBE
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81A915749C;
	Fri, 31 May 2024 11:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="ppd2+7hU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1645E156F5B
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717154753; cv=none; b=L29lEMOl1a3SFtowNAoQxy/XvgsD0kdbdkLl9KwFpatIyQz5prVCOORwfNyv43KammwKbCKiJZFsJiYV9bU7IzIBjVghSjXWQljnKnyuk0a2XnSmnWBVJqXBd/CNiHn3t2ROl32oPgzj0cWgC5Xdy/C9/Jb4VHgoeXNWN7sfPtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717154753; c=relaxed/simple;
	bh=PTcYzuOXIlbRXgshrnBY0/SLFiYOVAKnmSmP2I+XI48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NSZPj0WP0RjHCEIfLkH2jFlP5m3LBYXyw0eGn9G/sA4jMXjRDVS8HAuxUs6u8DvoMaCLYCu73svFtbd1x8BgsDezJdI9aNzCTjGgOs5JmCLBj+fUB4sm3lEHUMVh0j8in9fQfUeL09hwX/4WCpQnXIOCDeKdcmMIzApqfqejoTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=ppd2+7hU; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3748ca2a21eso1996725ab.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1717154750; x=1717759550; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRu+fvt96wDh21HWdZk+AUFYcHjCXJ/UFo9OhBPmYL4=;
        b=ppd2+7hUDcVX+OqQVYDt/gOrV3Ych2vIDHqsq/VJGLEMQLSxadOLha38PrzIb2nMhq
         GSd1F5hpyOaN/aVIp5wzxtoLWzqTRRAJvznVf4zGd9QqRYopUaYt8AjPmF0gNsx9+QXF
         Xdfhpn+GOWY41auXSJ18PcHrLQ5lakkp/d0cE7EzuR7qlGvpfZXIir0U6JDD/Eu71772
         xnfNlMcfur3vXZZa526DQRPn4hc+IYgOJNAou1V5dsbFmInswVZDrRQOYjZF1h/JiM5c
         IKbHRnfeRjVV7lB1VLNWBnABw40Lmtuf+S2s8tmna2efutfUCrSJIZg4OcXQA/GCg5L3
         s3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717154750; x=1717759550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iRu+fvt96wDh21HWdZk+AUFYcHjCXJ/UFo9OhBPmYL4=;
        b=YNSUPyK3GnFGiGAtael6TAG7bEAI57eI6pEZ5nmbKRZwYL1dTJS7r2mqqeF66qk6Jw
         o9fnPxaQo8d6nYzHf0NUJL9n958bLY4N+Nd9VTkIsQfNl0cVkoVq1x81Nf8hd5fqhGr/
         7rqjrdQ2y0qKaxkIPTE+ZDLpuvcheGQT4fWx8BVycCUN+Vw42SB/ttnLeSmsn8xqYNrj
         zG8/nUnSVhlzN/8T6Mq4iX5tSrNRMmgVuiKOVJYJwWCPHin7uXF8C2h5BdnOou1TpIO2
         dY+QB4vNfnSuHKC4ITFT21+1VStag6rFP3+2aVUJDwSi6jMqPvb684fx0lacujsgOwdq
         Wlqw==
X-Forwarded-Encrypted: i=1; AJvYcCWC2PBdRoNvV/J6ZVEQJm0F7R6X9rJtP3Wp0zRO1O1f/3OjQK73H8TsTojrUeOoBGMgy2KYEiJJ4iMVHsMQzHq1wlWc
X-Gm-Message-State: AOJu0YyWumaPv77HBqGxKPUl4tspQiYa+h5ishsMMTTfwBLqGZ4/6sZa
	zPerZ+unxXA9fHTAmuwACQ4q/yhKJ6LZjGTEao3hSOToFf2MaFCUk1N1vkm73ldigFoPUNgmQUH
	vTErH++07elvrRvX1Cph4cIzT8oSZCp1QfrNkKg==
X-Google-Smtp-Source: AGHT+IERmtusbSx5VguMq+IRGISAME3Fo9I1nHszmWxBFaYwO8ur28ukLLI5CchbhXRWskUNyQH3RjcBWJXIgZMDsHc=
X-Received: by 2002:a05:6e02:b27:b0:374:6472:d923 with SMTP id
 e9e14a558f8ab-3748b8fd182mr18921045ab.0.1717154750045; Fri, 31 May 2024
 04:25:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411090639.237119-1-apatel@ventanamicro.com>
In-Reply-To: <20240411090639.237119-1-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 31 May 2024 16:55:37 +0530
Message-ID: <CAAhSdy3+q1aLgTro5N_UerXjaW7fTGxjpOPKkyR+-GMru-gZMw@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM RISC-V HW IMSIC guest files
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Atish Patra <atishp@atishpatra.org>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 2:36=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> This series extends the HWACCEL and AUTO modes of AIA in-kernel irqchip
> to use HW IMSIC guest files whenever underlying host supports it.
>
> This series depends upon the "Linux RISC-V AIA support" series which
> is already queued for Linux-6.10.
> (Refer, https://lore.kernel.org/lkml/20240307140307.646078-1-apatel@venta=
namicro.com/)
>
> These patches can also be found in the riscv_kvm_aia_hwaccel_v1 branch
> at: https://github.com/avpatel/linux.git
>
> Anup Patel (2):
>   RISC-V: KVM: Share APLIC and IMSIC defines with irqchip drivers
>   RISC-V: KVM: Use IMSIC guest files when available

Queued this series for Linux-6.11

Regards,
Anup

>
>  arch/riscv/include/asm/kvm_aia_aplic.h | 58 --------------------------
>  arch/riscv/include/asm/kvm_aia_imsic.h | 38 -----------------
>  arch/riscv/kvm/aia.c                   | 35 +++++++++-------
>  arch/riscv/kvm/aia_aplic.c             |  2 +-
>  arch/riscv/kvm/aia_device.c            |  2 +-
>  arch/riscv/kvm/aia_imsic.c             |  2 +-
>  6 files changed, 24 insertions(+), 113 deletions(-)
>  delete mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
>  delete mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
>
> --
> 2.34.1
>

