Return-Path: <kvm+bounces-45088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E750AA5F44
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 130F7467E1F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D821C84C9;
	Thu,  1 May 2025 13:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Nmax+CAQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2071A19F101
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 13:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106581; cv=none; b=pQGF+yzC4lixqoqnrW/R6QhRc+rWuNCqRJFB0o8qHJ/PNAZg7wAXn73NL2zFXfiRD8Zrox5DkxrsOdMs/JMuja+rtlzmITCn4wpmm0qgE2BygG34m2o7TR3FKzf38vPN8FEIXZ3EWLFhYC60eqsc2Q+gxYTqD9ZnUO4jHH1GZrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106581; c=relaxed/simple;
	bh=fr8LlzXOX1DDJ3UKB4yXhV7JJkyml63H3YQLUXm/grs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BXivupFGiXxOFyUe4XyRJ7/ec2y3ddh5PS0Rug/YszNYMhp0SLGTarsjXro5fucVYb4JYwNzR02CoBAcO9P0lJjiSf3peN5wrBpgpgq1yiUHUGaN0ioerGCgoBWqtS5gT57czKrPbYeQZNBPPPh3jfJY5c3KjgzxstwNmJpr5xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Nmax+CAQ; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d6d162e516so8260915ab.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 06:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746106577; x=1746711377; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5HbFwwkJF2Y2R1Vbj0ljcnhgzUV/rgTcfz1KnrFhCo=;
        b=Nmax+CAQD2omOzlkuMUvXJ2NitDOMGG+9XPZyvZjH+Gpb7NPmVKXLKJxjX6+UPumZK
         4J+iWgyVq3u5F9dd31/B0kQDC3pADSWcSWr+eYdTYWiPg7Cjic0AfteEj1nAn61sy1qb
         BDGUaiPPsgJduY/Mfe/iTJPbSavP3yj2JGiASCxO4G2te5ydNq5AOUDR3E3wZ+fLN4bv
         g3olmQUMsn/QGEohWiTaYdb4qik6AWDQKUMBu2JuFh8Uma4AKt0phgbqO44+SL9Ll+28
         YZS7DMqn8PrxqNDWrOo9aC9jkKpshaDSjF2+YlwpUtLXNA0vDhwMleyL1jrCXuiUznrX
         joog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746106577; x=1746711377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R5HbFwwkJF2Y2R1Vbj0ljcnhgzUV/rgTcfz1KnrFhCo=;
        b=RChabE4sk/F8cW3oqK+DtcuPQ9hA47ab7DghKzGc+s7bfTCoiU1oCCZ7TDWbwg4vps
         T97JGdfTI+kjYulOx6XeotJHemGuQNL4ge5A2drdW3+zNZrqvm4M4/Wb5TnjtFNMzCzq
         jus8lZpcyCMc1E58sS0AjKXz2Dy/xUooCuzFw8PS/lJQ+N3bMoJYTpvPJMAP5XMc2YoW
         3NdnqX5c308y2RONAox8hBs2xEVzR7CbS02Eko0G09fpzufJGVKTQhsFpOgeJ263sdf7
         h+mdz2UoEiNgWdm63p8mWcEMAYZ+wh7j7PpnAlK/Fms7hC4LDzMV31wNrrc+uN8ximXZ
         3clQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRfC00xFmOM7mCQzdwGatn3W/r4nnptN1lFnilWpzxuN8Xfi4/jWq9AucWqtvt3BHqeag=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdice9VoyyzbY2fkRw1eXgbPzZJvPzSkfwrMcKW6sQpp6lNaic
	q717CxIQPi6ezRFuKwTqwKfYBTLLSDLsHgZk8PEQcwftyAnXt35vclhFPqsOfWncdjBfcHn19Zh
	QZViCL/yNI3A6bdiGl9z7vCHT6IOvC/UnMqCPzw==
X-Gm-Gg: ASbGnctlPPe0vtwZgNu0zJLJcFuJwUHTPt+6jBX+jgnZawCBCA6UW1JJeYtgROBSFwX
	lr7sJMHYCtCERW1JeIq7O1UDeweAr/QOpiOrCldR3Zp4x/z5ypr8+KK7JPngIMsZenVtNPxvRj1
	Ye+j2N/cTNaUc3p268vhCpBg==
X-Google-Smtp-Source: AGHT+IHY7gd5DfteiMffTuTR2BB5tAOFnK6ac9kV3ASNuI57T6S+/lfY0TuUH0M3Tjf2aq1tEUdaJ7qOsG8AOHYTWno=
X-Received: by 2002:a05:6e02:1b0b:b0:3d5:eb14:9c85 with SMTP id
 e9e14a558f8ab-3d9676c6669mr79049245ab.6.1746106577095; Thu, 01 May 2025
 06:36:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430-kvm_selftest_improve-v3-0-eea270ff080b@rivosinc.com>
In-Reply-To: <20250430-kvm_selftest_improve-v3-0-eea270ff080b@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 1 May 2025 19:06:06 +0530
X-Gm-Features: ATxdqUElPYmtqqRS47Feed2BMb796DJHZOR_NiIu4niYbEKvJ9Q_aHmmUyE0IV4
Message-ID: <CAAhSdy0UAnmNHWNJBysuH93Mok5_AQB88uy0nHuiumpfGgiJfQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] RISC-V KVM selftests improvements
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 1:46=E2=80=AFPM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> This series improves the following tests.
> 1. Get-reg-list : Adds vector support
> 2. SBI PMU test : Distinguish between different types of illegal exceptio=
n
>
> The first patch is just helper patch that adds stval support during
> exception handling.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> Changes in v3:
> - Dropped the redundant macros and rv32 specific csr details.
> - Changed to vcpu_get_reg from __vcpu_get_reg based on suggestion from Dr=
ew.
> - Added RB tags from Drew.
> - Link to v2: https://lore.kernel.org/r/20250429-kvm_selftest_improve-v2-=
0-51713f91e04a@rivosinc.com
>
> Changes in v2:
> - Rebased on top of Linux 6.15-rc4
> - Changed from ex_regs to pt_regs based on Drew's suggestion.
> - Dropped Anup's review on PATCH1 as it is significantly changed from las=
t review.
> - Moved the instruction decoding macros to a common header file.
> - Improved the vector reg list test as per the feedback.
> - Link to v1: https://lore.kernel.org/r/20250324-kvm_selftest_improve-v1-=
0-583620219d4f@rivosinc.com
>
> ---
> Atish Patra (3):
>       KVM: riscv: selftests: Align the trap information wiht pt_regs
>       KVM: riscv: selftests: Decode stval to identify exact exception typ=
e
>       KVM: riscv: selftests: Add vector extension tests

Queued this series for Linux-6.16.

Thanks,
Anup

