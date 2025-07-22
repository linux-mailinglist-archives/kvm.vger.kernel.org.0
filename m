Return-Path: <kvm+bounces-53056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C33B0D01C
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 05:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C655E3A8ABA
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 03:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1E028C2BE;
	Tue, 22 Jul 2025 03:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="vX5ZPBpF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1022222D7
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 03:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753154128; cv=none; b=orQGmOjsbdkzadylXRd1sROk2oji7b1i4u7n3ZjrG2uqCC0ZC2R9rc0uubuey4oyQ23yaAjvdt3ghLEOJaiKIASIicf3X7HzKi6MNUsQC9dAQZcolM9vY3BVlzESbAeMqxtHNDW5oYRPEu+aJvOfr9eOEwnDxDfn2dEkL/rEmng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753154128; c=relaxed/simple;
	bh=JzkBOKAgWdiUJQ2g/MaoHxtIyReucIXiIAdcpENkXdg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GPBrc8AdWGqXO3NemLKhsco0wB74SWwSFoHKLq1NA2W8m1BflZSoVMlar6z3wwDLvTKXSkGOaDH18s0/X8T5nMtdxafudwMMQCnEwHhpIySakqsiORmGkAoi4Q0P5FPgaG5Nt9QJGoerAuONkPMizXFil09PAWiK8AaMI1IxOhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=vX5ZPBpF; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-749248d06faso4227533b3a.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753154125; x=1753758925; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N3ro4Yyao5uXofBVuxsMuyd3IafrNj++K0PwR4Tt2N0=;
        b=vX5ZPBpFcQlouuvkn+JhlTYT+QKdqXD0kYgt2NV2gvr+PVMCIPJJl5ibjRFpcAukZs
         SgfJPkzjekrNSlKeeyy+Oh0iD1bPnnHltkgFTbyc9N/B/Fvp0U/LURfqQQhj4rE1eiAW
         krvNRoVg/M5P5EO4y3MZzSEjGV748i9ewk2Dm4v2vUPVS3fpHP+9wlu3W91p4WsIM0/8
         InEkAPPFgvf9qXJPiY/Xk3EdhqcLGwMFeg+wejJrqVyvrZWRMw4rDdplK/v0900BeTKA
         tgw2rsa/Zlv/ZVfCN445OHQ1dI3jpTcd8sr17IRcGSztBPzPy9cfCD0dRjrY+nb7bhF8
         +l0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753154125; x=1753758925;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N3ro4Yyao5uXofBVuxsMuyd3IafrNj++K0PwR4Tt2N0=;
        b=Q/JGTFHyQtxMMJiZHOGDv5y/PtQXxXM6rerw8QboHGo4UiigoN2ZmmUDyjpPzgSbwa
         8VbWPaKE5nFgi5/nWVKxw++nyQ+NSDqpdKh7bhqJ4S3LWUAeUnokklsCh2mu1er2+v47
         0vu6UHSZtVmlS9kNylETjB4yWD8JsXFrHB//qYIMEp1qJzQjWJA4DqyrSfqegv77cXIb
         AofELiMBSw5o6t7Xhwhaoh1NzZcOaSQdcFMZdx8s3MeXcHkDH19WVB3qCOl07DlVGMwJ
         0tsl3e1qbr71zCak8GuxStOF0SFZnTDryEpvwQfNH2vWcCAeq78u7+dlqgkUKs21+4im
         jeQQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+byNnR5fX6rt6Uh1XBypp0O6ZCel0nNcHWECOGbJiyjBqf5Ok5Wn3sD083YZXeGN6CAc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKIjOpfe2PAoBnRFe7fn/b8b6WM38rzTfOUaJpsCV2zL5JnRhY
	QU+ZZ3vVq4OWKDvXnukZbB6rGYUAT2qeY8XCk1jE76YPHwYhTxiXePj0oNexzergbsQ=
X-Gm-Gg: ASbGnctCeJgJtl0EDqNKXdJpKZJWKpIrVWApwHRxcYnblmdY3j3Ig/Aemj3jQ0HyA0m
	avjrI94oBilGLT/0L2qW2NdQJlOdaeLQxclkpHdNr6BK31a5wFvPr0IKfLkn7wX3W/R3iXCCPJe
	fSckcv8Cq1LC6pMqV4BQc9CzZxQY2FjyLb8ceyyzsQw3wXfVVnhsbe2kcCxcB/3b6ni0lRLhZHF
	6WWwj/0yx/UaogenbDnkhHqop2r4VMHc4y4wbZL19FjKx5B0RlATQ4MYo0vTLihZxG4Mn8g1bsg
	o2ns5kp+5A21IqjxIFWexuuicKlGO98zTttTdCMk1oGFKzaZP4SM6Jho25Pcw379bgxYrxan1ZI
	+QbDeK8ymi9WYwB5Zoz56aTg6FirPE2n2lyo=
X-Google-Smtp-Source: AGHT+IE5Vc7OGRx4QhLjcitwZKIWZGvajhiltbo4bWSxvPQDoCrplva3mLaEOWP7EA2twj6pT6oskw==
X-Received: by 2002:a05:6a21:6b02:b0:21f:5598:4c2c with SMTP id adf61e73a8af0-2390db673cfmr29574196637.13.1753154125053;
        Mon, 21 Jul 2025 20:15:25 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2feac065sm6027612a12.33.2025.07.21.20.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 20:15:24 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v4 0/9] Add SBI v3.0 PMU enhancements
Date: Mon, 21 Jul 2025 20:15:16 -0700
Message-Id: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEQCf2gC/23Q3U7EIBAF4FdpuJZNB/oDjTG+hzFNoYPLRekKX
 aLZ7Ls7bWPUXS8PCR+cc2EJo8fEuuLCImaf/BwoVA8Fs8chvCH3I2UmSlFBCYqfpnOPGcPS++B
 mrlWDAiw2ZpSMLp0iOv+xgS+vlI8+LXP83PwM6+lOAehbKgMv+VA53WioBDj1HH2ekw/2YOeJr
 VoW30JdAtR3giBBVQpq05ZSSfOPIH+EWog7QZLgWmOG1o3aOrwRrnvFiO9nmmrZe7IJUxq2qbr
 icasn4De9LdLT7/YPgkRFPWvdiD/80zqgGRJyCpNfuiI3B5A8WkEvX78A6qJO7qwBAAA=
X-Change-ID: 20241018-pmu_event_info-986e21ce6bd3
To: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, 
 Mayuresh Chitale <mchitale@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

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
[3] https://github.com/atishp04/linux/tree/b4/pmu_event_info_v4

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
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
 arch/riscv/kvm/vcpu_pmu.c             |  75 ++++++++++++-
 arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
 arch/riscv/kvm/vcpu_sbi_sta.c         |   6 +-
 drivers/perf/riscv_pmu_sbi.c          | 191 +++++++++++++++++++++++++---------
 include/linux/kvm_host.h              |   2 +
 include/linux/perf/riscv_pmu.h        |   1 +
 virt/kvm/kvm_main.c                   |  21 ++++
 10 files changed, 258 insertions(+), 59 deletions(-)
---
base-commit: e32a80927434907f973f38a88cd19d7e51991d24
change-id: 20241018-pmu_event_info-986e21ce6bd3
--
Regards,
Atish patra


