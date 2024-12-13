Return-Path: <kvm+bounces-33734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95BFA9F1132
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D49E18839AC
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 15:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E10C1E32A0;
	Fri, 13 Dec 2024 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="lplstBUW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE51C3BE7
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734104608; cv=none; b=aR5oNspuZnWxyFI9za/g6MG3heboYKPLWwZicldmtNLGza+y2XIXIu3xyBdNB7KtEye6WfgS5z3KL1eFJrobwudeugd1/1Nv21+AlUXp6bJLYjRPZMfVR6AAoXnzDBzv7iysmQ2euPofMvfje9qD98Gw/LMmoVU+BdhNGQIq8RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734104608; c=relaxed/simple;
	bh=/IUppeNCZlmJuJ0gNrwjX5pU673/GgMw4qpOrFg1H88=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=AaSf8mX41NyVraCG9Ub1KFp1rX827jJLYGBc9fycYTyznBrQ6rL/GzwSVp1ymY9CR/adlRWihi1Gy7nW4um/sAtiUixRyUaAJDkmpJO1H0sJOIN5vZ05hLuFIuUGpmdZU85kllgbXTMn99dcFv5uXNpCcGZERKQZXCs3MA+Clxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=lplstBUW; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a816cc9483so12088745ab.3
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1734104605; x=1734709405; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iwjoP0Rbkuiwb4EhGyP5yHnBvkPf6hPIeiHA6s05heM=;
        b=lplstBUWUgu+m6GhBzK2HAvqJyAi1168yDpRsK+cv0gllDW9p8MntE9WvpQ57GhyJn
         f4/JFJ2otQ7ajApM246F/jcQFIYZwnWtlPI9BzMYhSRnpa1lG/v9uwxRQMA5UC2tBaVs
         YUvrwe6fJTEtyq33saT3kjZI2XDTccMERUkxADIXzTRT3gYcgfZVpypUWmkiENa9YWd1
         qgHBmE7a5p9wtHUgXp3KOU2RM6VzGzBGpm3hz4ypulaOn3tJQDN7pA0L54Kbo5UaSps8
         A0vVW7/wfcgGWu/gKwVfroRLjsQqNypQU9dgm5cKsS9tFFTOXMHX46tjAqjC0RpWRv9l
         LzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734104605; x=1734709405;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iwjoP0Rbkuiwb4EhGyP5yHnBvkPf6hPIeiHA6s05heM=;
        b=N4Dq1us9UmRBgIsQN9NRNEufv3k+9hP5g5x9vzH/suNUxyHHKo5kbcQGegl53DS7mW
         7xcA5z7lMUdb6fKTSgUfOerGYsU94DgmXzjZP2wOyvMmW12Km5IKBXhbUnJH2tBvPeYe
         +SYkDFEVe4gDYbLUYlXCcBlLUPJ+VySICf9bC7ABt0x/tI6NNEgS0chEpwDQd455dOjz
         CMDKQkxdhHOenHhi2+1ZyhIEvJ5D7Q4LEhbmrvOkkchJekz1gMybhXNjqx8UVGY5QnXN
         NT1xmZ0dLxyS2gCUsl3IOrRkNTRaWfhG5RH9hZywSDqCLbf+SBGJegBHtmf7DfyXzgBR
         BzQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRHQTVpFKhrSi4k6FOZ5yci44HCTz5Auj7RimbdYHQLtf2lEQ6xijWPsukdFHy5hZMIk4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3fFbZUtdharf5PLsNNS8cfx+jLtp7FDL3qm4+Bh5w5uBcgtVS
	tgdbv2fk8RVSi0B+0aYKRcw1FS6q6GHxD1aEqbvNU5B+WvwHKOgHqQAvpLnFvVG6VjtoadEwRpO
	8N5036wvwQBRN5hDW8PPMFm9fIlEDyeQM6mWWvg==
X-Gm-Gg: ASbGncsMWudrAV7+zk85I/6WmCC7D5LJ+9kkYQ0Ygpx1kRy71A9DzpfX+G91LevAqBr
	o7t3vgzDErifg34bZWOs9GdsfOB+xfF+4ettSvGk=
X-Google-Smtp-Source: AGHT+IHszYtma7y6OUpPC8sx00Gd9GpsiqMRXevKniZfSrxLywefwvvNPxXnHXUXuYGvWK0JHf7Ffw8UvhWyAl7zeRk=
X-Received: by 2002:a05:6e02:18cd:b0:3a7:e0e6:65a5 with SMTP id
 e9e14a558f8ab-3aff52a260cmr44535365ab.6.1734104605585; Fri, 13 Dec 2024
 07:43:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 13 Dec 2024 21:13:14 +0530
Message-ID: <CAAhSdy35NO2fUrgER57qgOHRSZYbGLvmKDPjdfpXOP04C1AhMg@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv fixes for 6.13 take #1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have just one fix related to the HVIEN CSR update
for the 6.13 kernel.

Please pull.

Regards,
Anup

The following changes since commit 40384c840ea1944d7c5a392e8975ed088ecf0b37:

  Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.13-1

for you to fetch changes up to ea6398a5af81e3e7fb3da5d261694d479a321fd9:

  RISC-V: KVM: Fix csr_write -> csr_set for HVIEN PMU overflow bit
(2024-12-06 18:42:38 +0530)

----------------------------------------------------------------
KVM/riscv fixes for 6.13, take #1

- Replace csr_write() with csr_set() for HVIEN PMU overflow bit

----------------------------------------------------------------
Michael Neuling (1):
      RISC-V: KVM: Fix csr_write -> csr_set for HVIEN PMU overflow bit

 arch/riscv/kvm/aia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

