Return-Path: <kvm+bounces-58715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B63B9DBD9
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 09:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27C5419C5EE6
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 07:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B32A2E8E04;
	Thu, 25 Sep 2025 07:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="hBWYHRwQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12B41CAA92
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 07:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758783641; cv=none; b=TzjGSj+1KE9v3v5IDbrjtA6KDVUCbgyREobuQeYuD2DxEBCzcjy/c4W0pOwZAEk1ClDLpWcVzOY1gOxzTvxt6YQmaihK+B3AitSYuPbMlRg7M5xt4Bv5nsv6iv+4Cdru4iuvC1tZ2z2+7C2sBba2AoSV9uLMckTo5/bJnNwbXl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758783641; c=relaxed/simple;
	bh=oQuoD2aN3UlYm8Bjag3CGmhu/Y5HvkMpKqzWrQNnn8s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QjbKs1/Sv3VHwexNrF42y8O6DkpgORM/wjmYPpct8ehxdyMnfKEebVr7MgZ2M+xCJws161QaVBgGIbPNfk0XPLOaRygnC3wM2x61LcJpULWS7K9WZiz6VHg3BG96LRGm3yZTIST9zI+yqqPZCUF4USBnj3xrF98JR9Zck1Zm6xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=hBWYHRwQ; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-425715aeccdso3109525ab.2
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 00:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1758783639; x=1759388439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MmyT2DQ8FjwtnIvToh+8LVARVJ88hd64Mv9gPij29H0=;
        b=hBWYHRwQwkG5EKuhiYFywjEs9mBsK2EDhuKYJ5LdCeZ1K93b/5HJ/VoIfhAWkYPbuM
         MxGxsKMgMuH3HE0d4RkhGeI0noCjBMM3orHwzjpt/4Ajm6Ruh0yGxtvpIizaAqDQf7Yk
         IFDdjI/lpktdZZ/s2tErqxDmtNDbrWnojayS3Rw4dRkxnQFvY4eajQGTsX9vv9kkmJcs
         tptyckWKSp3uSTiJAFNrDQXH6M+ExUVjc9439Ao1Ml5kny6OsWumRC+2/eGrN+dcuyeo
         IWaVxArKqwz4GB7tJW9y3Pz8SjnSWemART/6kstFYF62OLEE3xAJCHG0xH2gJerJq5IL
         mT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758783639; x=1759388439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MmyT2DQ8FjwtnIvToh+8LVARVJ88hd64Mv9gPij29H0=;
        b=iIuPpBXUbnX+m1jpU7ehbDj5zJJWInfqyJJbyD4UjKZLXj8rBvzHiAfAJaIQ9scn+4
         lexG5rIU62i29zpmZVp5W9lzweIczZ2shMCPGN57r+V2/Vb4C4f/FNLTY3ojsoiOHih/
         m2TkuqEY934DuSzNcWpjAVsxqvfeV6fkpMWHt79uG3dQ4p26PwjbZfgJKwhGRYANPy97
         i3sK74PTw2My258EFG5cjpc0fe6kkWH5Zlr+NukJeFptBTUace2A6BY/hUcss0Dwd+tU
         AMsc5XzryrprFhzUFt1na51zaYegXaHPYUd1QpkfbiMX6LPPE99oVKy1kSxT3BZAT92Q
         cWNg==
X-Forwarded-Encrypted: i=1; AJvYcCVDMIsZvzeNPmLmI6ZR4fK3ZOx9MyKUd/g2oGB/6dk2xqqqyRAvVd7UNZ4YBEFkvknYTKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBMc98w1r+WHW/G5hPgRR2MA1w4pt01tEe9WirDed/XMa4CC4+
	in9Jix4yxHSy+tH5JKs1pKWE3OKYcIGjx0ojtQUKoX72kLQPjlMjCK7i4Z0YgYRS62ThoJ/y13D
	tc0VlstIPOb+zwfBKUMZLNcSI/Jzl61pyYHh0PRTF7A==
X-Gm-Gg: ASbGncu248suBOxkS+vIcxhW/sDC8xi08zN3gSVojoXZuJuWnpDrrA2epZj8bO5iB1/
	+UeGP1OvkQWSfdp8ArK8wYIaSTdhgOIgifL4ZHaIVQmyHVnkRVA18IRC/AZP5wbQpucCGbknSkd
	UJl8wJXfKMfhRP1Qssgzm6Qu2K/GfybzAoJ10iAjwTK3kfmj7/p3xM2Apid7esbDdJyKkftQt4n
	uocwg4sDwWCOfRVWeq8qrvhjUhMFs+NCq6kYQ==
X-Google-Smtp-Source: AGHT+IHZRb9CK/OmyBqOaD/n1EoZIqcM4pae02poytMs04HVBkLjaVLzPJP9OpaAHZ4GqnnqxcX2Onw45K5JIuhAveI=
X-Received: by 2002:a05:6e02:3cc1:b0:424:8d44:a267 with SMTP id
 e9e14a558f8ab-4259566089fmr35271475ab.29.1758783638175; Thu, 25 Sep 2025
 00:00:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anup Patel <anup@brainfault.org>
Date: Thu, 25 Sep 2025 12:30:26 +0530
X-Gm-Features: AS18NWBoHJSdz0RKFWvagHmEkQT_MCXcW0bn11BwoOh7tEVjSPPT1943J8gh5oY
Message-ID: <CAAhSdy3pXsGfFi-A1jFsO3UJsjomJ1y3Z8F73xe0xuftzLHBLA@mail.gmail.com>
Subject: [GIT PULL] KVM/riscv changes for 6.18
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

We have the following KVM RISC-V changes for 6.18:
1) Added SBI FWFT extension for Guest/VM along with
    corresponding ONE_REG interface
2) Added Zicbop and bfloat16 extensions for Guest/VM
3) Enabled more common KVM selftests for RISC-V
4) Added SBI v3.0 PMU enhancements in KVM and
    perf driver

The perf driver changes in #4 above are going through
KVM RISC-V tree based discussion with Will and Paul [1].

Please pull.

[1] - https://lore.kernel.org/all/CAAhSdy3wJd5uicJntf+WgTaLciiQsqT1QfUmrZ1J=
k9qEONRgPw@mail.gmail.com/

Regards,
Anup

The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c=
:

  Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)

are available in the Git repository at:

  https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.18-1

for you to fetch changes up to dbdadd943a278fb8a24ae4199a668131108034b4:

  RISC-V: KVM: Upgrade the supported SBI version to 3.0 (2025-09-16
11:49:31 +0530)

----------------------------------------------------------------
KVM/riscv changes for 6.18

- Added SBI FWFT extension for Guest/VM with misaligned
  delegation and pointer masking PMLEN features
- Added ONE_REG interface for SBI FWFT extension
- Added Zicbop and bfloat16 extensions for Guest/VM
- Enabled more common KVM selftests for RISC-V such as
  access_tracking_perf_test, dirty_log_perf_test,
  memslot_modification_stress_test, memslot_perf_test,
  mmu_stress_test, and rseq_test
- Added SBI v3.0 PMU enhancements in KVM and perf driver

----------------------------------------------------------------
Anup Patel (6):
      RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
      RISC-V: KVM: Introduce feature specific reset for SBI FWFT
      RISC-V: KVM: Introduce optional ONE_REG callbacks for SBI extensions
      RISC-V: KVM: Move copy_sbi_ext_reg_indices() to SBI implementation
      RISC-V: KVM: Implement ONE_REG interface for SBI FWFT state
      KVM: riscv: selftests: Add SBI FWFT to get-reg-list test

Atish Patra (8):
      drivers/perf: riscv: Add SBI v3.0 flag
      drivers/perf: riscv: Add raw event v2 support
      RISC-V: KVM: Add support for Raw event v2
      drivers/perf: riscv: Implement PMU event info function
      drivers/perf: riscv: Export PMU event info function
      RISC-V: KVM: No need of explicit writable slot check
      RISC-V: KVM: Implement get event info function
      RISC-V: KVM: Upgrade the supported SBI version to 3.0

Cl=C3=A9ment L=C3=A9ger (2):
      RISC-V: KVM: add support for FWFT SBI extension
      RISC-V: KVM: add support for SBI_FWFT_MISALIGNED_DELEG

Dong Yang (1):
      KVM: riscv: selftests: Add missing headers for new testcases

Fangyu Yu (1):
      RISC-V: KVM: Write hgatp register with valid mode bits

Guo Ren (Alibaba DAMO Academy) (2):
      RISC-V: KVM: Remove unnecessary HGATP csr_read
      RISC-V: KVM: Prevent HGATP_MODE_BARE passed

Quan Zhou (8):
      RISC-V: KVM: Change zicbom/zicboz block size to depend on the host is=
a
      RISC-V: KVM: Provide UAPI for Zicbop block size
      RISC-V: KVM: Allow Zicbop extension for Guest/VM
      RISC-V: KVM: Allow bfloat16 extension for Guest/VM
      KVM: riscv: selftests: Add Zicbop extension to get-reg-list test
      KVM: riscv: selftests: Add bfloat16 extension to get-reg-list test
      KVM: riscv: selftests: Use the existing RISCV_FENCE macro in
`rseq-riscv.h`
      KVM: riscv: selftests: Add common supported test cases

Samuel Holland (1):
      RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN

 arch/riscv/include/asm/kvm_host.h                  |   4 +
 arch/riscv/include/asm/kvm_vcpu_pmu.h              |   3 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |  25 +-
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h         |  34 ++
 arch/riscv/include/asm/sbi.h                       |  13 +
 arch/riscv/include/uapi/asm/kvm.h                  |  21 +
 arch/riscv/kvm/Makefile                            |   1 +
 arch/riscv/kvm/gstage.c                            |  27 +-
 arch/riscv/kvm/main.c                              |  33 +-
 arch/riscv/kvm/vcpu.c                              |   3 +-
 arch/riscv/kvm/vcpu_onereg.c                       |  95 ++--
 arch/riscv/kvm/vcpu_pmu.c                          |  74 ++-
 arch/riscv/kvm/vcpu_sbi.c                          | 176 ++++++-
 arch/riscv/kvm/vcpu_sbi_fwft.c                     | 544 +++++++++++++++++=
++++
 arch/riscv/kvm/vcpu_sbi_pmu.c                      |   3 +
 arch/riscv/kvm/vcpu_sbi_sta.c                      |  72 +--
 arch/riscv/kvm/vmid.c                              |   8 +-
 drivers/perf/riscv_pmu_sbi.c                       | 191 ++++++--
 include/linux/perf/riscv_pmu.h                     |   1 +
 tools/testing/selftests/kvm/Makefile.kvm           |   6 +
 .../selftests/kvm/access_tracking_perf_test.c      |   1 +
 .../selftests/kvm/include/riscv/processor.h        |   1 +
 .../kvm/memslot_modification_stress_test.c         |   1 +
 tools/testing/selftests/kvm/memslot_perf_test.c    |   1 +
 tools/testing/selftests/kvm/riscv/get-reg-list.c   |  60 +++
 tools/testing/selftests/rseq/rseq-riscv.h          |   3 +-
 26 files changed, 1188 insertions(+), 213 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
 create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c

