Return-Path: <kvm+bounces-32092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCEF09D2F6F
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 21:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66E491F2392A
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 20:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12DD1D358B;
	Tue, 19 Nov 2024 20:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fmHXT4yi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1721D318A
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732048251; cv=none; b=pIPX6hM7d0Feyfm3+rJANOrjt/5FiMj7nHwyTWhTY0ghsJNqodtImMefGB5ebv7HMMWPLiWzW5SDD0+3GNdkrRLm2IqO8BSc5sBUr56EqzfNvFSdRWzZocYAF2d4j726Zm0OYtJe1KKByhESyhjlF3g+K5C3u9yEYvuLYoYoyz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732048251; c=relaxed/simple;
	bh=4HC+UgT6IkxJTFVFhoiSL1hEglE73Etwa2rtn3YC0J8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ch6t2SDX43z/yyKDDVFXZO0glP36zsL2qAdTfbht6HkpiHOLRoZz7L14cwiieM5IKB7Vr9rtg9S8O7Js4ae8QBtIdGbEjN3ZTMLDKVchPiplOjubJ7TCUs1EU0Hx0Q1o8wFVS3eU8iZyd1o5Vf9+Gv9Mg4GKuwURsZqfHKPo2hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fmHXT4yi; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7f8cc29aaf2so997276a12.3
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 12:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1732048249; x=1732653049; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c7pVc5JoetXII2KdB/NlP4OQnm3jFWw4yJ8lHbJ+BI8=;
        b=fmHXT4yiz1XKSp8CB+KJk9Gf53O9/Vfe0JtDZmphXrsV9zAN0dpEm3vrcLaieeRw4/
         MyOxtbQ5dcGZhhG8C376hX81T9bs5wVBYs0NtwkCNrMDtqg3v9TxzcQ4Akd1FzGCQWFq
         T0RTIqYMYxVY+JMFMI/UOXjjLqLfEe2NY+c2FXTtPSez5A6PqT5reATS7M7RRN/OJfpn
         rzSp72tW33KGqCmQBE1vrHUU7++EmAB7luDNBvNCIaYaOtUZC8jMYEp5VgVrqExUw+WK
         LtzVN/ZOyTCiKgIElOMx6pZiBQ5LbwAKVLXR83lX+lh97q3KwZTedB9ZZmfdBY553eVx
         VC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732048249; x=1732653049;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c7pVc5JoetXII2KdB/NlP4OQnm3jFWw4yJ8lHbJ+BI8=;
        b=T2YJIpemnuKJxr4wDqfX6sS3zGErTWRw9pRYOJ8T1EDv69/2gDCZ3fY3PRqYQXnduy
         G+HgQBb7x52s5AjGEffTO0MQ2bWAFR97IIK35zUxDnSi6mb64tiPQW8/ZXhy/Scs+Xmi
         mmvXj5ZVpRElCddm5q5bVyEdBtcDeGk8zSv18syhOR6xK5kLcD4nvLr0+O//BHSdpjzv
         ljYIcbrKu+5icFuOmxFcyxHdh5j4sirCJQj+eCJn0OMCmpvoJRLqag7NuQyxpRrDBjcc
         qMgB4H2Oy0Op/Hz82WVZ5+2+0ZaqH4v4VyxTM4k4+ZdrJFcD0kbZihBVQglkwVyXnXy1
         7TXg==
X-Forwarded-Encrypted: i=1; AJvYcCWQgoAod8Sa4OrMDdSyGfkdda1GR6XUDCigbzJqLUv0w1k2zVEwPYZe6iYlyRhtzHnbCIc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+9iaGMWgs/SIN8qZjYptBpncDqL4dSqHHMMFvd4nwOLFy0o95
	eYIMWD3mWbml1t27X3BHuTf8EKdHWJPqKnM3X9iVqnUpEI3u89X/p2UwJIUVP90=
X-Google-Smtp-Source: AGHT+IEGqDbbCzCtdsEZW2eFYW9EW+r2eubpzXN5mXs90RA5OdnIHgt1XlLafqwuVADVSx84uXt6IA==
X-Received: by 2002:a17:90b:1dce:b0:2ea:956b:deb9 with SMTP id 98e67ed59e1d1-2eaca7e8b27mr126213a91.37.1732048249221;
        Tue, 19 Nov 2024 12:30:49 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f34f2fsm79001315ad.159.2024.11.19.12.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 12:30:48 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH 0/8] Add SBI v3.0 PMU enhancements
Date: Tue, 19 Nov 2024 12:29:48 -0800
Message-Id: <20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD31PGcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxNDA0ML3YLc0vjUstS8kvjMvLR8XUsLs1Qjw+RUs6QUYyWgpoKi1LTMCrC
 B0bG1tQC3PSxyYAAAAA==
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

Apart from implementing these new features, this series adds a fix
in firmware event mapping and updates the kvm SBI implementation to
SBI v3.0.

The opensbi patches can be found at [3]. This series can be found at [4].

[1] https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/vv3.0-rc2/riscv-sbi.pdf
[2] https://github.com/riscv/riscv-isa-manual/issues/1578
[3] https://github.com/atishp04/opensbi/tree/b4/pmu_event_info
[4] https://github.com/atishp04/linux/tree/b4/pmu_event_info

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Atish Patra (8):
      drivers/perf: riscv: Add SBI v3.0 flag
      drivers/perf: riscv: Fix Platform firmware event data
      drivers/perf: riscv: Add raw event v2 support
      RISC-V: KVM: Add support for Raw event v2
      drivers/perf: riscv: Implement PMU event info function
      drivers/perf: riscv: Export PMU event info function
      RISC-V: KVM: Implement get event info function
      RISC-V: KVM: Upgrade the supported SBI version to 3.0

 arch/riscv/include/asm/kvm_vcpu_pmu.h |   3 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +-
 arch/riscv/include/asm/sbi.h          |  12 +++
 arch/riscv/kvm/vcpu_pmu.c             |  71 +++++++++++++
 arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
 drivers/perf/riscv_pmu_sbi.c          | 184 +++++++++++++++++++++++++---------
 include/linux/perf/riscv_pmu.h        |   2 +
 7 files changed, 228 insertions(+), 49 deletions(-)
---
base-commit: acb481ddd977ab669128bab61024d05e7dc1654f
change-id: 20241018-pmu_event_info-986e21ce6bd3
--
Regards,
Atish patra


