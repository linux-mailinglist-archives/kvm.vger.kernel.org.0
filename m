Return-Path: <kvm+bounces-52157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 731B4B01CF2
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2887164C20
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3792D3EED;
	Fri, 11 Jul 2025 13:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="V+b9QMDX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A470810
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239132; cv=none; b=CDqeNPzFYHgLkTLSrUE094z5kMvuQNNl0ioSatzbquducYjuuVNUD4D6Hl8bdJrrV+QOwF+rY1dk/4YYpGxr5I+wXNEb0pWcBESbpXrMKtJ65t5BWB3NUWnyKhhWTVJTzVSE4YbG6j1PD+y9a2E/5HrwqpcNne8op2YYeBl2PTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239132; c=relaxed/simple;
	bh=xmlK63TB2ec5pcs2W7lC+3QxW8QbBDUxKyEAsD/Q4Mg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qbki7sqjz1rMgiv+Nk4UMBpK8QXhVuowFEc8bWztfljGnUhxeDJm35i6DY+XDSl1nr4AQX29awM+YFQebtEjXZ6XwnO+hCoPyOIc61YE0og8O3TZNUi1Y301lknW6dmoijT7OJ+dFKNDEC1oliDK+3Zdg9+QIQ8JG46ciat+bw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=V+b9QMDX; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-874a68f6516so187797339f.2
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 06:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1752239130; x=1752843930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJE3CLjEeonNUb8mT2xwmsMp3adhwfxqmRNHfpesc2o=;
        b=V+b9QMDXhZYDcnq3D7/UBAtZoBZl7U7BGcLYJkLrpUhPKIHaPmgj8JKX0g5uy1UvIP
         VkkWpR32WEFGU7+ZQenvMjSpd+8BbvPBZaaOD/DhusmlSHQxSGbij9Jv2V9k9BBWo07W
         avnkLNFfDwZRpZ1JFjsCeX2qyYrinkUlEU8lq29YrmfWnkV2D9PkpNs6St5+JvmSrAUK
         PkPL7Hey012cgBc5TdDmBffkZ+58qEq+0LZ5GsmsYVMi1X+3G1R7XIQ/0+pD3t8+436F
         qt2iZ2cwxjHQanJDZ4fanHrsJOcJDgfPdhaJAkyxLkLT8warnW5Ltt1PkGt+q3H5lYCH
         J7vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752239130; x=1752843930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZJE3CLjEeonNUb8mT2xwmsMp3adhwfxqmRNHfpesc2o=;
        b=M+XBO+W3thisnVsfgucwoxdLyIiviqSw2UTHXIT/39aSGs7X4VF8iDC3VIQOa79gSe
         DdF2ZMM76LMJIz2EyV8VnEfj4BzcFNP/JmQc66F/K+LGt+f43xD4QIqoCPar9Bp/QI8T
         Ys1L/ItJF3ZLubrDZtMqL5ZvI8pGMwaUGaCat6o5k/0pclnC3E7XXF4FmlwXskplD45n
         UgfmE3qBYlrO7laFRk3N1P1dlnVoZW5VOw1p0wfSDuZBjsZVYtx/P51C6R2G8VoMFJBK
         5AQUc3JsUjpFqyqjzuL4hf7/wXkGxpT5wkeDL2E0XTqx/flkAGLlTxFElHWuLphMfZws
         YFGg==
X-Forwarded-Encrypted: i=1; AJvYcCWLABQvbn7tu8c8VxsVORfLVkE9nZGc0+pt18V2mOciI2+LdopL3ynQn/Z+9Am1Q6i0NeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+3SZJ2cA1V09HT3+I2im790d0hILEsdlXlf6k1pST6YKmgDIv
	naplADs7eJayIKdiFsqLTKIGYGBjEOJSshuifpR4dLKlRywSgElaQwwj3o24U/pUkJR0Py53vt3
	jtUWehvHw3fBtfpzsIO0LDsUmheICe5HI/M41omQovg==
X-Gm-Gg: ASbGncumV48pnE/e8OshxL+Kvnj8uSlbYxeG9sZ6NQls8nTvfjUe0Wl/IwvRJXoakaI
	rgh9sfMb5ulHeBVXzt9u+WfIncbwcoN5WuBJIOy74JfBdIn4haBkaTRX+/0dWdFPn5sp62rcnuj
	1iL4zU9EDJznrJyarlSrg7IAYugobveyd+lMbJSpBDJih47auRSbI0gSV/ZqsNcTSQpM7tgoFdD
	BuU0TNy
X-Google-Smtp-Source: AGHT+IEPU9SyMA3ByH+HpMG+YsQr79SQw8svyUaMdhj2IE3tiGFc6RjWYvNGPYPV7cSMIf3tPt5HkTmZtilB6ri5/o4=
X-Received: by 2002:a05:6e02:2682:b0:3dd:b5ef:4556 with SMTP id
 e9e14a558f8ab-3e253341fe2mr44338105ab.18.1752239130172; Fri, 11 Jul 2025
 06:05:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707035345.17494-1-apatel@ventanamicro.com>
In-Reply-To: <20250707035345.17494-1-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 11 Jul 2025 18:35:17 +0530
X-Gm-Features: Ac12FXwUE-a6Xf4G6F5Wb87U6THpUu9QoAOdL2yGtZJMrmr3dB1cTnbnWmVVvS8
Message-ID: <CAAhSdy17yUD=7aMcX2VuFHm+1-TQ6jhwsnPJAQsGS_AmmP1WCg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Few timer and AIA fixes for KVM RISC-V
To: Anup Patel <apatel@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 7, 2025 at 9:23=E2=80=AFAM Anup Patel <apatel@ventanamicro.com>=
 wrote:
>
> The RISC-V Privileged specificaiton says the following: "WFI is also
> required to resume execution for locally enabled interrupts pending
> at any privilege level, regardless of the global interrupt enable at
> each privilege level."
>
> Based on the above, if there is pending VS-timer interrupt when the
> host (aka HS-mode) executes WFI then such a WFI will simply become NOP
> and not do anything. This result in QEMU RISC-V consuming a lot of CPU
> time on the x86 machine where it is running. The PATCH1 solves this
> issue by adding appropriate cleanup in KVM RISC-V timer virtualization.
>
> As a result PATCH1, race conditions in updating HGEI[E|P] CSRs when a
> VCPU is moved from one host CPU to another are being observed on QEMU
> so the PATCH2 tries to minimize the chances of these race conditions.
>
> Changes since v1:
>  - Added more details about race condition in PATCH2 commit description.
>
> Anup Patel (2):
>   RISC-V: KVM: Disable vstimecmp before exiting to user-space
>   RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
>
>  arch/riscv/include/asm/kvm_aia.h |  4 ++-
>  arch/riscv/kvm/aia.c             | 51 +++++---------------------------
>  arch/riscv/kvm/aia_imsic.c       | 45 ++++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c            |  2 --
>  arch/riscv/kvm/vcpu_timer.c      | 16 ++++++++++
>  5 files changed, 71 insertions(+), 47 deletions(-)
>

Queued this series as fixes for Linux-6.16

I have taken care of the comment on PATCH2 at the time of queuing.

Thanks,
Anup

