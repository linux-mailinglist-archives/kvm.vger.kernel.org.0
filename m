Return-Path: <kvm+bounces-10656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B20886E604
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 249441F26D33
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 16:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619C725619;
	Fri,  1 Mar 2024 16:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Rw3Dwuqs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235C22097
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 16:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709311239; cv=none; b=NrxObrEdPODgLkzaE0baBkIBg6tTjNkKwdpbJxeyT8nXTKfHkjGRyB7OmhZBE2b5KfahgG5J1BNeZExIYlQi4VZRzNWDQSva3M6wFQWPuT8+SPM0UbOHcRDINysk7CYpv4GJgcMTmLMxzRVF6cGl279mk7OXMHG7aNVsxgipYZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709311239; c=relaxed/simple;
	bh=1DFl0ZbNmoHHCDx2NBctdiyCsC0l1eSWBPINNTEml0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XNwz+wxT740eJ631iuDCOoYKTfIW86eado4aHv0ouO86cJ2JmfzsHzIQgxQMEwJVhySCfd0tXEwtqInK1gHFpBL6qqD7iaicwvSR4lV7Fu4pFM3fIA4N8q8m4tFFbRdBVnfEgnmXnnFZJwc5qbJ6noxQ5nvIbUoAnbwYrgjzpZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Rw3Dwuqs; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-365c8257940so6718015ab.2
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 08:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709311236; x=1709916036; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xpVEUPupFJ4mY5Qxb0D2y0+A3GchrSV23FNcC1i+jo=;
        b=Rw3DwuqsCzOiiHT9eSWMkJ0EoDc2l/s02nmZMNiKrWNT0TvusHRfdWpiAQ83kdmuRx
         rUHmdSHs/wzp72ezfdcdGhWx8w8MDKJFExTF/BVL9ObWk8mXTOULJ737uoNBfJxUOken
         AiTV8q3mNkZ1c9K6xH8aKqxzMzX8qXX+PFKtvpMClg/RnXdDgd583FGupCY0obX4Bg/p
         V1/gvvPIdh0MB7Lg1TsUEDxm8w2it0DaUVIor6lX6mHmUv74yizHzVqA9zdpxgEb03ym
         qD722WaHHwtLNJs2904i9eyEUjdJhQEGe1oPLVABAAR/bTjjSvUdERHeHKW2Chwm+RVJ
         dH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709311236; x=1709916036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0xpVEUPupFJ4mY5Qxb0D2y0+A3GchrSV23FNcC1i+jo=;
        b=WhUvz40hVo91EPQAqICssZ2fCwK+hx3BNYLtF+00i8aMrSm4WiqjpfY5t5ITyF4Bi+
         kKwXivxkcgrHKyPEdB8oZBhhKCJCkceL5H87BVqEaS3bhK1HdlzVDgFdzZVULVCtNC1V
         oXjdNfHWi5Fs6Ag8W14d1RLaN7SYOmydbxYe+yY1eP/SV3apepPPVp0owJNJr3b82SNJ
         xzJDrZOOKnSIRbImFVzPFY6FvwYLL7Y38UzQa0+dvJ0BMrVJYIGpnQcr1Q3t7WNlDvpC
         krM7Hgl05DHuhVX2W0n8v+lhrlTheYt6idMLkjl6Zqp5+qBG5rcnG9Va+usnyD4h6ZCg
         Fl4A==
X-Forwarded-Encrypted: i=1; AJvYcCVlllP/ICgZ6LLMbL3m1rMN7hjVMkpBzDVyDk6St6+oHfvVQgR6SbDYzm6T9P2c8SDs88+2u1+/SkD/SAnFwqe4F26j
X-Gm-Message-State: AOJu0Yz83s4cgto8FPrFXvIlmYMcPROjRamySdRB7XAI+ltQMOBMEJ20
	xTn1Fg4uMVMnEVG6byWRLzi2hW0zMQ/Fo609D1Aw2CqtjwMmn0dUwYsGZVf00+NXql/1tIGFzeT
	HUs12BJnHs3hT0pv1v9hZ1AXTUt9SdqsJQwO/7A==
X-Google-Smtp-Source: AGHT+IFA/8ZsTPlrzqpqMe1C7sAim+Tu77L5L4EC5Mu3PiP55/jHP04OSuPWwGne0ZjJhx4bUxIrY3D6GoIF2d46Q1U=
X-Received: by 2002:a92:c24e:0:b0:365:c1fc:dc07 with SMTP id
 k14-20020a92c24e000000b00365c1fcdc07mr2509460ilo.0.1709311235987; Fri, 01 Mar
 2024 08:40:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240214123757.305347-1-apatel@ventanamicro.com>
In-Reply-To: <20240214123757.305347-1-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 1 Mar 2024 22:10:25 +0530
Message-ID: <CAAhSdy3ObzJHgF0QL9QqKVm37F83HzdF28A5107fm0dLFxoOLQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM RISC-V report few more ISA extensions through ONE_REG
To: Anup Patel <apatel@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Atish Patra <atishp@atishpatra.org>, 
	Shuah Khan <shuah@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14, 2024 at 6:08=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> This series extends the KVM RISC-V ONE_REG interface to report few more
> ISA extensions namely: Ztso and Zacas. These extensions are already
> supported by the HWPROBE interface in Linux-6.8 kernel.
>
> To test these patches, use KVMTOOL from the riscv_more_exts_round2_v1
> branch at: https://github.com/avpatel/kvmtool.git
>
> These patches can also be found in the riscv_kvm_more_exts_round2_v1
> branch at: https://github.com/avpatel/linux.git
>
> Anup Patel (5):
>   RISC-V: KVM: Forward SEED CSR access to user space
>   RISC-V: KVM: Allow Ztso extension for Guest/VM
>   KVM: riscv: selftests: Add Ztso extension to get-reg-list test
>   RISC-V: KVM: Allow Zacas extension for Guest/VM
>   KVM: riscv: selftests: Add Zacas extension to get-reg-list test

Queued this series for Linux-6.9

Thanks,
Anup

>
>  arch/riscv/include/uapi/asm/kvm.h                |  2 ++
>  arch/riscv/kvm/vcpu_insn.c                       | 13 +++++++++++++
>  arch/riscv/kvm/vcpu_onereg.c                     |  4 ++++
>  tools/testing/selftests/kvm/riscv/get-reg-list.c |  8 ++++++++
>  4 files changed, 27 insertions(+)
>
> --
> 2.34.1
>

