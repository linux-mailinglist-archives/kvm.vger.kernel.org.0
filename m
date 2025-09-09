Return-Path: <kvm+bounces-57053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45957B4A2D7
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBB84E2480
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 07:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20201305942;
	Tue,  9 Sep 2025 07:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="Xz6nUsID"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974502FF64E
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 07:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757401407; cv=none; b=Zix/1q4HbNsawz18jEGsKV+8YuMca+SyWZYRzL4EX/SLamPSbkUzY5Bpah4RcIGweQvqWwTOjg5GAWsZ+eZrsOSSnLTjUiopbCuvxEw8aDaE0+7Fw8tUWSHFwCZUetIl5vI2upxSxiUAHrte7TjeN3HUX2FMCrSzJfhoqAWlnhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757401407; c=relaxed/simple;
	bh=YiWO+f6yiqoYUMb8nGevg0JVmM0gfAGm3UgzoJnSL1M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Pm0s0gi30sAcLGZ7XCCaFAsMGeTCt1AAYj30vRttj/mIS4qQZ3rYqAPh5Mpfoe4H3cnpHSISMnJG64ser2ppQMNCIL7yIp657XIiO4CQiZB1h1rHViS1rrK2drdYWqAvXHJWAI4JCGLh0lFaYZbTdulK4PubfltXJ+7k/nw4H+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=Xz6nUsID; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7726c7ff7e5so4457978b3a.3
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 00:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1757401405; x=1758006205; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RNthXv7xmnVgNBJdwKS6Eu1LchZyxPFP+JzXVAI2vr4=;
        b=Xz6nUsIDThbqFGkYrfKSLt7MJaFlvG+Hs5SlmAYVFjYVSITUv5gQnvxcg3S28GyMy/
         CaauypcbSSpPR69RWsLVdzxngKgEaUnMEIxXy0UTpd87ZT9YF2FW3ZJZuFmYecoktXAl
         qBz0J41vkACew89/QMqu05ctVdi8muNiedUDgjImgyzsEzDz9ajQ6mA0VuhMvQO2F1Iq
         aZcXyzbdHgb8JsTJoTWjNBMsMikbbZLKvQsnFJQbYDXvLw8f66lWQNv2S5+2K9a6yeMK
         HB2W9CR0ARfblg7Az5yuX1eg9ilyrSpkSXFB3rMqqKdMtEWMKTUrB5nl2+v5SjDp/HGW
         8dHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757401405; x=1758006205;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RNthXv7xmnVgNBJdwKS6Eu1LchZyxPFP+JzXVAI2vr4=;
        b=U8PyZouiqsSTMI+CU2b+BP+IpSmmrUjMFeEjniEIpqb6JIX+2pM7wok23jNCJLs9Co
         i5grcapRfGsf4EFaSbBdY90LZBHRl2VkOWOs/HD29x1eNfMNphW6Oy3gRniWHw6+y6Dm
         FWEM2apax+fqNRvA6hiZEPSEGemT3+k8BFv7KxXP3FKtP05R5A/fBO4KyQEJnhoXb8GB
         ldf88uw+vLDsITHBuR77lt4Sb1T8DV/u4BGjW6XovBRS6QI0o+FEAcy55B9R4MXlcw5M
         PpovjhUjFtgY0WgbvfunjjOPNFEom9/cW7034N0JFNZNL4cfSPNOuBDa9smKf8auLEA3
         jLYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoOiQuSySZttV20eRD1rMNJFYCd/JHjqsjsF43qs+NOifd21deyZslVMT4BC0VrFS7HF8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz+lWGG+qA7AwQgo69d7N3mrPWTAzLkkL9EZ8n60HbLramXZ0i
	uCSHx3qM0o0JI1geoz07iRCIuVnKOUy+EFXF7eLjuI6suEUN+qZkSIqu/HhQfDfvX94=
X-Gm-Gg: ASbGncsTqVkrlpBDXCg/KtVE7alazxxZOv65El+vuVukn4t/OJLgjuxZVEDRxE5Yi45
	Spno7/68N+CU9Snq4o3ftHTJQQPd7eJRL5Ic2RbhPxJ/MdpS5ktcOrlhFkKAf2Upm/WC8Q4otyU
	lnUnFgWeQtLTHYabeSmaZf7PAZuSCQMbY4HDs4NLUJwEc0RhaZzK2Cl0EVuf5KYBQHoz7sQsnD7
	h4jxbXAUx7In21q3z4Bvy2MSAOysMjDdSo8EhDkGQ6qdfEhVgTFPRJRzuHpIP+NAnDGAogf5Bro
	4ze3t7eVNY58au7bqIm7WCBbgnUVoeDzZ1ANsvLWJgcw5WSIr2azKJ+bc1apbsOHiKHM37RLvTM
	IVj6exmFNUbXdjWOyCbVTfQBfyBIMZJLaJZ0=
X-Google-Smtp-Source: AGHT+IFVlHtNE2LMGS7gSQLQT0W4LugB0ERiut2YB2J1SVxQq4kRk0S88rF/oo0Map16D7hoJpjjYQ==
X-Received: by 2002:a05:6a00:c94:b0:772:332c:7976 with SMTP id d2e1a72fcca58-7742db6308dmr11948119b3a.0.1757401404738;
        Tue, 09 Sep 2025 00:03:24 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662c7158sm1025535b3a.72.2025.09.09.00.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 00:03:24 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v6 0/8] Add SBI v3.0 PMU enhancements
Date: Tue, 09 Sep 2025 00:03:19 -0700
Message-Id: <20250909-pmu_event_info-v6-0-d8f80cacb884@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADfRv2gC/23R32rDIBQG8FcJXs+Sc/wTLWPsPcYoxujqRZJOU
 9koffeZhNGt6eUR/On5vgtJLgaXyL66kOhySGEcyiCfKmKPZvhwNHRlJlgjhxoUPfXng8tumA5
 h8CPVSjoE62TbMVIunaLz4WsB397LfAxpGuP34meYT1cKQN9TGWhNDfdaauAIXr3GkMcUBruzY
 09mLeOvIGoAsRGwCIorEG1TM8XaBwK7CQJxI7Ai+KZtTeM7bb17IPCb0CBsBD5vYRvZCGU4Sv1
 AEDdB4TYHUQTdWYMSmDaM3QnXNeboPs+lrmnNmvQuJbPUta+el4gR/q63tHIoCa0hAXPle15oi
 f/4l7nE1iRHy9CHaV9luQNGo8Xy8vUHDuHwgjACAAA=
X-Change-ID: 20241018-pmu_event_info-986e21ce6bd3
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>, 
 Sean Christopherson <seanjc@google.com>
X-Mailer: b4 0.15-dev-50721

SBI v3.0 specification[1] added two new improvements to the PMU chaper.
The SBI v3.0 specification is frozen and under public review phase as
per the RISC-V International guidelines. 

1. Added an additional get_event_info function to query event availablity
in bulk instead of individual SBI calls for each event. This helps in
improving the boot time.

2. Raw event width allowed by the platform is widened to have 56 bits
with RAW event v2 as per new clarification in the priv ISA[2].

Apart from implementing these new features, this series improves the gpa
range check in KVM and updates the kvm SBI implementation to SBI v3.0.

The opensbi patches have been merged. This series can be found at [3].

[1] https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/v3.0-rc7/riscv-sbi.pdf 
[2] https://github.com/riscv/riscv-isa-manual/issues/1578
[3] https://github.com/atishp04/linux/tree/b4/pmu_event_info_v6

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Changes in v6:
- Dropped the helper function to check writable slot 
- Updated PATCH 7 to return invalid address error if vcpu_write_guest fails
- Link to v5: https://lore.kernel.org/r/20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com

Changes in v5:
- Rebased on top of v6.17-rc3
- Updated PATCH 6 as per feedback to improve the generic helper function
- Adapted PATCH 7 & 8 as per PATCH 6.
- Link to v4: https://lore.kernel.org/r/20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com

Changes in v4:
- Rebased on top of v6.16-rc7 
- Fixed a potential compilation issue in PATCH5.
- Minor typos fixed PATCH2 and PATCH3.
- Fixed variable ordering in PATCH6 
- Link to v3: https://lore.kernel.org/r/20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com

Changes in v3:
- Rebased on top of v6.15-rc7 
- Link to v2: https://lore.kernel.org/r/20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com

Changes in v2:
- Dropped PATCH 2 to be taken during rcX.
- Improved gpa range check validation by introducing a helper function
  and checking the entire range.
- Link to v1: https://lore.kernel.org/r/20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com

---
Atish Patra (8):
      drivers/perf: riscv: Add SBI v3.0 flag
      drivers/perf: riscv: Add raw event v2 support
      RISC-V: KVM: Add support for Raw event v2
      drivers/perf: riscv: Implement PMU event info function
      drivers/perf: riscv: Export PMU event info function
      RISC-V: KVM: No need of explicit writable slot check
      RISC-V: KVM: Implement get event info function
      RISC-V: KVM: Upgrade the supported SBI version to 3.0

 arch/riscv/include/asm/kvm_vcpu_pmu.h |   3 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +-
 arch/riscv/include/asm/sbi.h          |  13 +++
 arch/riscv/kvm/vcpu_pmu.c             |  74 +++++++++++--
 arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
 arch/riscv/kvm/vcpu_sbi_sta.c         |   9 +-
 drivers/perf/riscv_pmu_sbi.c          | 191 +++++++++++++++++++++++++---------
 include/linux/perf/riscv_pmu.h        |   1 +
 8 files changed, 229 insertions(+), 67 deletions(-)
---
base-commit: e32a80927434907f973f38a88cd19d7e51991d24
change-id: 20241018-pmu_event_info-986e21ce6bd3
--
Regards,
Atish patra


