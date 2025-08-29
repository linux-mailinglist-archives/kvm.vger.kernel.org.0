Return-Path: <kvm+bounces-56310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E4BDB3BE15
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 16:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB50A168AE6
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 14:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B8631E0E5;
	Fri, 29 Aug 2025 14:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="atKwZJaR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD4E29E110
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478471; cv=none; b=EfxNRXx+hLmjib8bqr38SJ+0ebQsjHAikMba7+/OdZdLINl6/j4Cvy6ApsY8G6SBKaq43ALE9AZ+9V6OIhNSxbwhWgGa5jPjqK0YBGPNqKe3IhN8S7bwP0YipleyGjlSOG2ELSoP/X+dHnAxYMJHace0pWrJ7/8emgC2DqNLNE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478471; c=relaxed/simple;
	bh=7IkrvrDV7cSoQssT0NirSi0XvDjmOWIRETuOhZnQfEA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=IxgK+c4uOUbV0sgPKmd/oYVaUSwvPo2aAiCjuNRHhBS76Kvlk7+n4aX564i2q6abZKhukNg39LvEIwGuGLyHr1Hcz6YSGmwSw67KdoCObsD9d0h9L5g9f/jUwnINurtsNZURwGThYVHs1tZSFvLcpKYq7BYoTvdxbbPqXBM4fhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=atKwZJaR; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e6cbb991aso2065094b3a.1
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756478468; x=1757083268; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oF5TQ5tmAgJotT6TBzfmeh55EB+gENZQcbLkBFQiOtM=;
        b=atKwZJaRz57g9S7/aqHOQWhaCO3efFhJo/snYdnShTXeLTf/v3EKH/v4ikZthyEvAR
         tjtbfMk73BghAvYwTK1M1TXe20oo0lbEc8SKIh6pW0KtXfB8cdBBom8rQ6lc68yzWTiQ
         p0dQKKQX6rTqCJbXVJTxaHVkhtdW8DNnZ3TSIcwD+nxr1NHBuONOJC5j083Coaik/TFK
         GivDlUqTqJNiiHCuwWmwk8el6Wpq4qXqu/Hh3q1gSOTagZmqeP/xv2DgvTz2caMIroOS
         lWIjnqm+0nTUR4F/YgH+JKzUxPurpOorZp5mQ5a94xBsGkE7iAhqX3XHjoVYbDZs7zfA
         0z5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478468; x=1757083268;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oF5TQ5tmAgJotT6TBzfmeh55EB+gENZQcbLkBFQiOtM=;
        b=wNgf9g9eb/tbo0wmRcU7GsimWG+4oDNn6oghrm8gywmMCIo7g6EJsocbDrbgPazn87
         ODygs/lQuE88nTPjJVg7Up0yIKx99DdQvCDUQT4WA5BuhFo1g13Dn+Aw2csIQijyuXU5
         e2AchIVl+HxM85ao+D+pkDRN0ycRYab37Ab3b0kxTTpIRzgkLUukGbJ/8Gc8nCccDSEB
         XXThc86l+eue85whh/GQphCcjksMHfRCmhLXLprG8+KQcxLbFqFHw6yGgeAvwqzVkaTT
         Y+yRdTQPX//95mQUvjktI/n9rTR0r0d5W1hxuertJcGXHyrTDC8NSv8YbH3n1iuVT6rj
         PiAw==
X-Forwarded-Encrypted: i=1; AJvYcCU1AQd7DI3DDt5rmIRANG+dDAwu8JmXUu35o9Hvpyfqd3bziVbl9Yu4ZLKFJPMU8jlC7vM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcwWQyAHEvLMaihas6WM6OPcQFAplyDzaMYB1s55vlg3ICcjhn
	uw6aHCn0TW20eqHqLawTzAWtafaON8GxjeDIzBCv+Yqs+Cm71Gv+h+1jDgdSDfhZjQE=
X-Gm-Gg: ASbGncv10c/uJqZMBTgs4H4fOKTTiCO8ceQRhT/vc3B/y/TUqZBPAgeyi31Jxtz9src
	CvaD75jUn09SvZ3L1AupusibSmSZ866S3ftU59irx1UhCGVH2XNGP8nWGO8DiEANt5xqZn2o8pU
	sHMdGoFb6RMa2YI8UK67vDtMsYG/dKJ7P2+fsGXHY6T6RHXsPXp9VxXSrTh/Eq04pZKovYyNX5s
	JLq4ve20pWeAcFNF8teoNBstlmEyhVu2tMSZkj4xhyHMaeIF18kUiATce7Rfss+LCY3MRoBIZlh
	+E3ubCiSdZI132hoiJ5xD4GnESGMN3xzczXp4QCt6WM4bUqU3HPNb/K61DeoW1t/WtykSARvfnO
	5wzKefrOw6qF4zO1HU4SdRqE7QEszj/tlFe4=
X-Google-Smtp-Source: AGHT+IGfKLBhrAwQIfIo51JxqP/Uh80E+uh15u67yO328vBecr+7D5ezoUnfonrgJ2TgVx7Oab+e/A==
X-Received: by 2002:a05:6a20:12d1:b0:243:98b1:395c with SMTP id adf61e73a8af0-24398b13d1cmr16044556637.31.1756478468352;
        Fri, 29 Aug 2025 07:41:08 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1f86sm2560999b3a.72.2025.08.29.07.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 07:41:07 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v5 0/9] Add SBI v3.0 PMU enhancements
Date: Fri, 29 Aug 2025 07:41:01 -0700
Message-Id: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP27sWgC/23RTW7DIBAF4KtYrEvkGX4MUVX1HlUV2WRoWNhOw
 UGtoty92FaVNsnyIfHBvDmzRDFQYtvqzCLlkMI4lKCeKuYO7fBBPOxLZlijhBoMP/anHWUapl0
 Y/Mit0YTgSHd7wcqlYyQfvhbw7b3kQ0jTGL8XP8N8ulIA9pbKwGveSm+1BYngzWsMeUxhcBs39
 mzWMv4KqgZQdwIWwUgDqmtqYUT3QBBXQSHeCaIIvum6tvF76zw9EORVaBDuBDlP4RrdKNNK1PZ
 GuKwlRfo8lbKntSnWU0rtUva2el4KQvj7uaXTXZlvHREEFdwrq/Ef/zKvoGsT8RL6MG2rrDcge
 HRYXr78APgRHZ3uAQAA
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
[3] https://github.com/atishp04/linux/tree/b4/pmu_event_info_v4

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
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
Atish Patra (9):
      drivers/perf: riscv: Add SBI v3.0 flag
      drivers/perf: riscv: Add raw event v2 support
      RISC-V: KVM: Add support for Raw event v2
      drivers/perf: riscv: Implement PMU event info function
      drivers/perf: riscv: Export PMU event info function
      KVM: Add a helper function to check if a gpa is in writable memselot
      RISC-V: KVM: Use the new gpa validate helper function
      RISC-V: KVM: Implement get event info function
      RISC-V: KVM: Upgrade the supported SBI version to 3.0

 arch/riscv/include/asm/kvm_vcpu_pmu.h |   3 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +-
 arch/riscv/include/asm/sbi.h          |  13 +++
 arch/riscv/kvm/vcpu_pmu.c             |  77 +++++++++++++-
 arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
 arch/riscv/kvm/vcpu_sbi_sta.c         |   6 +-
 drivers/perf/riscv_pmu_sbi.c          | 191 +++++++++++++++++++++++++---------
 include/linux/kvm_host.h              |   8 ++
 include/linux/perf/riscv_pmu.h        |   1 +
 9 files changed, 245 insertions(+), 59 deletions(-)
---
base-commit: e32a80927434907f973f38a88cd19d7e51991d24
change-id: 20241018-pmu_event_info-986e21ce6bd3
--
Regards,
Atish patra


