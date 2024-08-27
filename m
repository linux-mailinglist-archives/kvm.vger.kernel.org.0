Return-Path: <kvm+bounces-25135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78BC4960626
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 11:47:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABD431C221D1
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42F919CCE8;
	Tue, 27 Aug 2024 09:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XUFCTeM/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18B41714B8
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 09:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752033; cv=none; b=QqwTj6C36UYTuVrEmm4kTbYQYo4Zn4EWcoVmKLwIx0F4rLDTBQUCCrmQ+E4U+iyBCjHEwodHcCRod2HIBcq2VvyhmrrTzcilwng9G/ZEe/05Fsk1ZUDYg3pILYTVU9c16+ZEHgcavYLdbaWqFz0m5bt1qO5WsV1GXSAqNYjpJl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752033; c=relaxed/simple;
	bh=k9WFqgJq8YNLY3yLPeuESnqQ1zu1uRGqh/F3oNxP25M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oncMMCAKSfliRK3aS9Y1tdI9V3EwKvIe32Jm8Rv19pBO9kDN8Cx4mRgEL4eIX9CDglwEKXQHW1epACQSaGA9bvqe61s7jgCzfnN4ZXIGp8YXKeaYL6ObdmVWXbVGBx2gKeiFP6bPHYKhxK1fPwMFxJYMxqyy+MIzqUDsumwH+5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=XUFCTeM/; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-533496017f8so7019652e87.0
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 02:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1724752030; x=1725356830; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krcYT+Sxx9cy7wZ+GDpDwQzl7KC29Uxl2v0I2FW7x8E=;
        b=XUFCTeM/vAx5FwX9juhM0D7dylaPR6ZA+ujb5OY3efo4U1Y41v0QDYUJRDh5ajJNKa
         R7hm1+ympgZylG67fcoPZpBcaDZMObLqL64fcUKwOWXbI1/A3h45/PKF1KHaQtV/bsQA
         wuZGYZTJKbxiCkhx4k59PiPHKBo2Mz601ZJneLl/MHxg70jDtUP8ULyjwrVQf1qMxhHt
         dnjG35FRT17/xnBLOzo3pP16Ucn0fo1KzLnJ1NXPzhuCh5MXVzydg9K32cyeOSpXOuXA
         Tc7gxzvZiMtSMeWcP0kd1N18PYtPCQK00meOp86ciFlM1VsPe/4rs9mgKdZAJGXULE8y
         ssCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724752030; x=1725356830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krcYT+Sxx9cy7wZ+GDpDwQzl7KC29Uxl2v0I2FW7x8E=;
        b=LRgGcPQFVfcDnNYcGcbBw6hK1eKEMAT5qTwm9EVi07ZzI3YKppkA2hpvB7Pa4zGaeX
         ui/YCnKU0bTukd73RPBxepbCuz+SlDGN2MpCsvK8PZ34k5baATSnBFCoj5E9sAGx1jek
         EvZ0tYGNw9R20G21Z+rAleGnscjE0bCBkb3YWWMTJRApWQor61XVBXfHv9Vfzhbpxup1
         3jzzJFhZzfa1/CTQ5zDpwl1y1gOG/EfnjsszXi6BPMGRyWiQI8TmfYxEqaPYTtEsjvpa
         pj1pdnbaUyiMaa54rsi6+OZAygSp9iPD3MLCOQbCcaxXRIqdl1LrlY/aPhdnDL2rpABj
         ZTCA==
X-Forwarded-Encrypted: i=1; AJvYcCW0r7TkfgXyf4ai4AHSDlFJWUveN39oO4JdE7wIENojHndRw5ylyQ255DzzE+49wNnnBts=@vger.kernel.org
X-Gm-Message-State: AOJu0YztcbGlgpBtFuSsEaJqk6+FjvRWeDG3mW3c485J8sCmwxknfvGE
	poPHahEVgFgu3hQwRkO6yBNbugKe65Uxmodbz6q2sqG0H3jXPRJRNIqScLItQLhCO9CIT1t7/Jy
	ng3bVRv0IVtLRDahwS2LmXk8A6UtQsMmgk5Ccrg==
X-Google-Smtp-Source: AGHT+IFgN4uMe/TWUtfkDg07dHpPLo6hNrgMOHYVjIlq8Xhi7pFABHxjFQUMcZGkoMK5OcZVtPCtjeXUXupsy9bTO6o=
X-Received: by 2002:a05:6512:b96:b0:52e:7448:e137 with SMTP id
 2adb3069b0e04-5343882d163mr9112183e87.6.1724752029279; Tue, 27 Aug 2024
 02:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821142610.3297483-1-apatel@ventanamicro.com>
In-Reply-To: <20240821142610.3297483-1-apatel@ventanamicro.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 27 Aug 2024 15:16:57 +0530
Message-ID: <CAK9=C2VkPGvCikBox33xxCUXjpFnsfKU7DefuWpXtUki+X7-Hw@mail.gmail.com>
Subject: Re: [kvmtool PATCH v3 0/4] Add RISC-V ISA extensions based on Linux-6.10
To: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

On Wed, Aug 21, 2024 at 7:56=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> This series adds support for new ISA extensions based on Linux-6.10 namel=
y:
> Sscofpmf.
>
> These patches can also be found in the riscv_more_exts_round3_v3 branch
> at: https://github.com/avpatel/kvmtool.git
>
> Changes since v2:
>  - Include a fix to correct number of hart bits for AIA
>
> Changes since v1:
>  - Included a fix for DBCN
>
> Andrew Jones (2):
>   riscv: Set SBI_SUCCESS on successful DBCN call
>   riscv: Correct number of hart bits
>
> Anup Patel (1):
>   Sync-up headers with Linux-6.10 kernel
>
> Atish Patra (1):
>   riscv: Add Sscofpmf extensiona support
>
>  include/linux/kvm.h                 |   4 +-
>  include/linux/virtio_net.h          | 143 ++++++++++++++++++++++++++++
>  riscv/aia.c                         |   2 +-
>  riscv/fdt.c                         |   1 +
>  riscv/include/asm/kvm.h             |   1 +
>  riscv/include/kvm/kvm-config-arch.h |   3 +
>  riscv/kvm-cpu.c                     |   1 +
>  x86/include/asm/kvm.h               |  22 ++++-
>  8 files changed, 172 insertions(+), 5 deletions(-)

Friendly ping !

Regards,
Anup

