Return-Path: <kvm+bounces-35585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04828A12AE0
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:31:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D38353A68EF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237611D63F9;
	Wed, 15 Jan 2025 18:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="JZIZ8WpP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455D3161321
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736965858; cv=none; b=fgNVFrzHMX2k7bgOYtj9JgSEdh8EZtc4YuJEMb0nkQMqpJZ+Uf3HJw3VBstwDshDHSkz5BnoZiTXRMHe1Y8ybzDWkBFK/6miK2BevqSBsQ/JIS0Mi5INjbJlVwWGmiD68bgvUY4ofXoOXv7FX4p8yfvGM+wG1k0E2p+onzA0UaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736965858; c=relaxed/simple;
	bh=43OBilrV18+B5fdkEVcCHjSJ8iWjDPj4M//wXsiMjWE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=eWoldXb8le615gS396UeA56fZkFEHSMEQAeYLl2xBNpyHzpnEUyQZ8mcAynxCG0qG7ouo8F3CkEN6sj2LdmtZ/dsFQhXmGwE1sgGGH/S3naxp4xpIuotnP+cwdnE19CPexQSYHJGWl3+fgOSiCLqFjVXxjK+HQAbrf6eAeAzK0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=JZIZ8WpP; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21654fdd5daso122338635ad.1
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736965855; x=1737570655; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/ajGRMGn1FxbsN+PpYAIsQKTZUngiruAaZC1M7x3JFs=;
        b=JZIZ8WpPERLiAapvWO2r5Zb5bd7aKQ5oJa4cR9dfKR3Bd/Xs2igJEUM+BkfudBvfoP
         ZEX2b251XdQyvErJ2A4ZVpbOLUWo7UoY+ISHtluck8wmNmcDmDLdo4xC4EBdctgM/dVM
         kcqlV/yO33xxVu3oIUTejidVo+R4ItQJnBNX67c/HCV95RVJzV3KLt+A3jQa8677PgP6
         JtMAKudZBSd91nJBSYr5ipCiB1iusqMZvRHnFVp3KGKPG2+hGKCHffTM4Nt9WBrXLWWH
         UPGNznKk/0DODull2p416BSog/YLYt9cpoU4can1tx6v77SQUXWfO+2V5YetLnXpmrzM
         eG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736965855; x=1737570655;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ajGRMGn1FxbsN+PpYAIsQKTZUngiruAaZC1M7x3JFs=;
        b=oJ3qasa8BZZ6UsadBLWSitX8uGS25QyXGQ9TkliwwigAig0oFPjgx8cbCd/U7jD36f
         m0hIzXtRARgC79Lp+NPrHK9q9FqPO1FscghuSyQc8PxXUqhcqftu//H6X4dKzExxfE+i
         o4OHH60mnd0orU23zA04AFEIfllBTzS3djRfDs15yY/DHxm1mInpotimzKPcKrstTNdx
         R5DRzlfZBiRP9IH1YmI0T6KBjF+FLlA1QbYwZDn9Lr9rYqSjt0uNKKwQmYXYiZ1JD46E
         sheOIqidDTz1fkWJWpPRH+874LjIiqH4BiNxu6A112o/a+/e9ITVhMbqU/VTreAtfvau
         agqw==
X-Forwarded-Encrypted: i=1; AJvYcCWQ81SHt9OZeSAlSkE2WT5vlnXFz7EBKCL2bgdq56fqt7s9W2ky1YIcBHNvQFMVH3moh/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+5Fafi/C41QoHGOlDYqFYRJSPUiGh1cxDb0r0D5OtpBMSidpk
	BGmZHOTLaCbdg9aBv2e6OWh6HTFNYheMVNLUk9ygM5w1pSCZlVpQiqiOAniK0Rk=
X-Gm-Gg: ASbGnctBerbLl3/VO3pdy4f6h1ARdgJwaN1FeYG6zna7XRc+2gYAkt8X27i1MQEUjdo
	NfwY2EpwmyHxiTXkroy1FdKoo3JuZnBsExo1iKSIvUUhXeGvQW8yy3Yga8gYqhJbpSp5MI4pI6x
	8/WKU4XP+O59SVyq4LydTxx3r0jXBpiQaWpihv2XjMKKiTdQJUyTDsq7D4Ft8+iBeUFHr/Cn6yc
	C/mUC3oJi0HHyZ1nqvEe6ahdPCEyV4iTaBIxUoGFJGTDuk5+h0u58jRV2iV3rXeTl154g==
X-Google-Smtp-Source: AGHT+IEFG9EqfNb6O2FfoTObOooM3/6B60y7w3sfOaKZm6tCWCH+RNJht379tQ8uKw/jXGcfHEEVRQ==
X-Received: by 2002:a17:902:f644:b0:212:40e0:9562 with SMTP id d9443c01a7336-21a83f69651mr458458845ad.25.1736965855468;
        Wed, 15 Jan 2025 10:30:55 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f219f0dsm85333195ad.139.2025.01.15.10.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:30:55 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 0/9] Add SBI v3.0 PMU enhancements
Date: Wed, 15 Jan 2025 10:30:40 -0800
Message-Id: <20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAND+h2cC/12OQWrDMBBFr2K07gTP2BWSKaX3CME4yriZhaVUc
 kRKyN2ryJu2oM0TzPvvrhJH4aSG5q4iZ0kSfAF6aZQ7T/6TQU6FFbXUY4sGLst15Mx+HcXPAaz
 RTOhYH0+dKkeXyLPcqnB/KHyWtIb4Xf0Zn7+bCtH+V2WEFqZ+ttpiTzibjyg5JPFu58KiDo9NH
 /nrWjLXbUMtnNJUM4fmraoJ6Ze61oyZoLwWDHZsysar1fRH//6MP06JocAi69BkvcMOoqOy/Pg
 BmvULkCgBAAA=
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

SBI v3.0 specification[1] added two new improvements to the PMU chaper.

1. Added an additional get_event_info function to query event availablity
in bulk instead of individual SBI calls for each event. This helps in
improving the boot time.

2. Raw event width allowed by the platform is widened to have 56 bits
with RAW event v2 as per new clarification in the priv ISA[2].

Apart from implementing these new features, this series improves the gpa
range check in KVM and updates the kvm SBI implementation to SBI v3.0.

The opensbi patches have been merged. This series can be found at [4].
This series will conflict with counter delegation patch series[4]. This
series is gated on SBI v3.0 freeze requirement while counter delegation
series is very early. I will rebase one of them on the other as we gather
more reviews and closer to merge.

[1] https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/vv3.0-rc2/riscv-sbi.pdf
[2] https://github.com/riscv/riscv-isa-manual/issues/1578
[3] https://github.com/atishp04/linux/tree/b4/pmu_event_info_v2
[4] https://lore.kernel.org/kvm/20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com/

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Changes in v2:
- Dropped PATCH 2 to be taken during rcX.
- Improved gpa range check validation by introducing a helper function
  and checking the entire range.
- Link to v1: https://lore.kernel.org/r/20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com

---
Atish Patra (9):
      drivers/perf: riscv: Add SBI v3.0 flag
      drivers/perf: riscv: Add raw event v2 support
      RISC-V: KVM: Add support for Raw event v2
      drivers/perf: riscv: Implement PMU event info function
      drivers/perf: riscv: Export PMU event info function
      KVM: Add a helper function to validate vcpu gpa range
      RISC-V: KVM: Use the new gpa range validate helper function
      RISC-V: KVM: Implement get event info function
      RISC-V: KVM: Upgrade the supported SBI version to 3.0

 arch/riscv/include/asm/kvm_vcpu_pmu.h |   3 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +-
 arch/riscv/include/asm/sbi.h          |  13 +++
 arch/riscv/kvm/vcpu_pmu.c             |  75 +++++++++++++-
 arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
 arch/riscv/kvm/vcpu_sbi_sta.c         |   6 +-
 drivers/perf/riscv_pmu_sbi.c          | 190 +++++++++++++++++++++++++---------
 include/linux/kvm_host.h              |   2 +
 include/linux/perf/riscv_pmu.h        |   2 +
 virt/kvm/kvm_main.c                   |  21 ++++
 10 files changed, 258 insertions(+), 59 deletions(-)
---
base-commit: e32a80927434907f973f38a88cd19d7e51991d24
change-id: 20241018-pmu_event_info-986e21ce6bd3
--
Regards,
Atish patra


