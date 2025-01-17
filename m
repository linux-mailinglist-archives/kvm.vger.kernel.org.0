Return-Path: <kvm+bounces-35730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F78A149F1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 08:06:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9C3B3A7BCB
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 07:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3174C1F76D7;
	Fri, 17 Jan 2025 07:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="FhPOibNV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3153A1D6DBF
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 07:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737097599; cv=none; b=FQRNoaoJ0I20NH1LfxaRpnMAUH7kR9vEhaUTaXXb1waMy8OwX+HUyaq4pxH7/zEyhqWavvmhWJBD0PDODKCadFVgxdyIt2+OeVh7QkOSt7wgJgqSCcfAp6pGI6Zh7Uwv5EkHoLzbxJtw4SaDtN7glrWB6EG/HXudjszzGt+PCUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737097599; c=relaxed/simple;
	bh=mTDjaC6HpLnOsXoFVd0zRCF3zzfZavhEPJ3YTAXHll4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=i5cFJoJyg7aGMKE8ybPhflpa+NhZnTQ0dRxQe+c9BKQ/JeE58LbA4Sl40RM/k2K/e1MpTMZ8tJlA7vSDWTUQMYSQM5bh/0EPhXmxkndGfg7c4A6MmsgA/3bgMVcu7Qmc37+WnazrbHpignpWJ73YmF0mF2WL6WFlbIA/gIRRvBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=FhPOibNV; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3ce8a4e95f3so16156185ab.2
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 23:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1737097595; x=1737702395; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LfYpH+Y1jpQO12PadF3pL3zexhSFdkqlBmV2LuVWqDs=;
        b=FhPOibNVQKTH3KRto8pB2n+wj9fn5UNrfSqV9W6Xn4Mjl9JrTNHQGdnAHbGng5b9RL
         Iz3Po8nDsWzqq5/J+0rnNq8q815tuMVFS6LY2C/28MwqsVuW4zm+SeWWvBvOI9W9M3qy
         56oaOAyKUgHAXB2Z7J0BhkzjSU6VIOqhgOhXvkbcfWhiZwmNKEPAsHWaPnIoQnEj0QsM
         KXcXHgeqf4fJRGvZs7T+pMCvb2Al3Hmpo4b5m5UPYkxgdh9FheSkta8YBRKQD/nnDNAv
         iLiDYq0XOAX4wlxIxCzRYneVzt6svrh42Mn5w0X76FD5XxA8f9lvOSvBwEuIVcOx4mSh
         0oOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737097595; x=1737702395;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LfYpH+Y1jpQO12PadF3pL3zexhSFdkqlBmV2LuVWqDs=;
        b=qM36AdHdcJItkztaKNHOmArFXLoplWeYkjEM8n4VRb5GwMAh2vZO4lzaYe4toPf/Xn
         tB+0E+dgb34Ob8Nrske8oRy5gPR8C2fwdRWLRA5u/DVenfwnQ5jqczwaOkBKqAQ3nINN
         0qjb/SSavza6MRQaxnSY+w6PGKn0zUNS6hwgBaF6P4Q1zTCXjvSQFxz9NbFPxGoP6ls2
         4z8QH+cgM5td1I6aFfNNFwq3k5MIKlQIudCowNZrW7J3KexxnIQ6Qqur0cIfGM6mj3G0
         +VEF8pkX4dk7mcKRc+0EwffUD4xO27GIoWhStEarM3jLPXCKqpTu1GTdlbSlsFfDzjJd
         soPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbJ4PQHcGDI1d9xS50qpfdCZb6CfwGGNUJxzEdUNj5oHaLY3QVIWh+KrNTjxmrTbyszAI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDnNIPfyQrN1gS+XXFL4lDMoILt4ZRAU4unEsyb4WnhiL5Nze4
	yhQIahhCyah7lMxERPKLl6EJkD9mOEMnEm54vdjOwzAzHUyCghXmNh75uV89rX91Clfo8YOeE2P
	Q3DFbZLycEHvTalKOwOnWSLTvIuQQeVimLIUheZHeu0898gGK7w8=
X-Gm-Gg: ASbGnctEa8GcZOJ0R+4m8FMopcVwswRIkfqpXeRd+dxyfOhQ6If0JoLE3sEHDRdNBcf
	rRp/zDiiBK5Ipery+zZbosiV37KKRTaBWNI/jIwo=
X-Google-Smtp-Source: AGHT+IF+AL3eLH94oddazC6IWMSZ5U/suLVNW1B+QIp0pFHRGvcni4BJzwXCFG3UMDaASPRqHB6/9Ut3S6E7Kq7eQYM=
X-Received: by 2002:a05:6e02:2402:b0:3a7:e0c0:5f27 with SMTP id
 e9e14a558f8ab-3cf743df906mr16474775ab.2.1737097595136; Thu, 16 Jan 2025
 23:06:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Fri, 17 Jan 2025 12:36:23 +0530
X-Gm-Features: AbW1kvZIPS-DR3om7fqXj69kIV9exvX1qxrHBy8YHvK5NBpiQJVs4OBbEUSSQSw
Message-ID: <CAAhSdy1ekLq08nByCh9E-ZZsMcm7rCpkA+FyAPwvQctEgjwFZA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.14
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

Hi Paolo,

We have the following KVM RISC-V changes for 6.14:
1) Svvptc, Zabha, and Ziccrse extension support
2) Virtualize SBI system suspend extension
3) Trap related exit statistics as SBI PMU firmware counters

Please pull.

Regards,
Anup

The following changes since commit fc033cf25e612e840e545f8d5ad2edd6ba613ed5:

  Linux 6.13-rc5 (2024-12-29 13:15:45 -0800)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.14-1

for you to fetch changes up to af79caa83f6aa41e9092292a2ba7f701e57353ec:

  RISC-V: KVM: Add new exit statstics for redirected traps (2024-12-30
14:01:02 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.14

- Svvptc, Zabha, and Ziccrse extension support for Guest/VM
- Virtualize SBI system suspend extension for Guest/VM
- Trap related exit statstics as SBI PMU firmware counters for Guest/VM

----------------------------------------------------------------
Andrew Jones (2):
      RISC-V: KVM: Add SBI system suspend support
      KVM: riscv: selftests: Add SBI SUSP to get-reg-list test

Atish Patra (2):
      RISC-V: KVM: Update firmware counters for various events
      RISC-V: KVM: Add new exit statstics for redirected traps

Quan Zhou (5):
      RISC-V: KVM: Allow Svvptc extension for Guest/VM
      RISC-V: KVM: Allow Zabha extension for Guest/VM
      RISC-V: KVM: Allow Ziccrse extension for Guest/VM
      KVM: riscv: selftests: Add Svvptc/Zabha/Ziccrse exts to get-reg-list test
      RISC-V: KVM: Redirect instruction access fault trap to guest

 arch/riscv/include/asm/kvm_host.h                |  5 ++
 arch/riscv/include/asm/kvm_vcpu_sbi.h            |  1 +
 arch/riscv/include/uapi/asm/kvm.h                |  4 ++
 arch/riscv/kvm/Makefile                          |  1 +
 arch/riscv/kvm/vcpu.c                            |  7 ++-
 arch/riscv/kvm/vcpu_exit.c                       | 37 ++++++++++--
 arch/riscv/kvm/vcpu_onereg.c                     |  6 ++
 arch/riscv/kvm/vcpu_sbi.c                        |  4 ++
 arch/riscv/kvm/vcpu_sbi_system.c                 | 73 ++++++++++++++++++++++++
 tools/testing/selftests/kvm/riscv/get-reg-list.c | 18 +++++-
 10 files changed, 150 insertions(+), 6 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_system.c

