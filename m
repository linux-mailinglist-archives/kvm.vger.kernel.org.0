Return-Path: <kvm+bounces-44863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE58BAA44F7
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39FBE4A6881
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 08:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F8421885D;
	Wed, 30 Apr 2025 08:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="SoVdaUFp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9DA1C8623
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 08:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746000997; cv=none; b=ZQ+AJzmbhc5JaHP9NgbUv4SHmemJ/rDBnj0/jR2W5HaXZ2TANZ1c37U4PR20RagDjNlGpUjnmMToCEf9f5UPR2MV1tAIio/Q52tcqHow5Q/g4rbAtZ5LVIMuGk2FHekvZdYfxNu57Sa2k9t2XOjvX0HGxJnOiygxZr0C6MW/LBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746000997; c=relaxed/simple;
	bh=Fp3GCul0xLHijr/kSvFB7BX5T/aXnL8fUJ9m9B3qidg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=VAQxu1kTT3OGfHoL+b8tpuexO9PSJjXkwB00QJ+Hxe+wp35ONDPzc9tlwFPS3Ed4O3CR+g6TdaN6TC4krZQXv9inEXLuCgh8Yj+94IUbjzA557Ak9pufg09f0lvEWsc16qPZPm4zxuhO1UWJM81Nw0ohf6cjperqhpCkEmlHS14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=SoVdaUFp; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso7007819b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 01:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746000994; x=1746605794; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qsXzG0OPFSj9Y/N7ILSDxyejpILMY8rt11Cw8ETnit0=;
        b=SoVdaUFpU8Euu4kN22zzABwj7RTqH+sw67jyoOFXhmddQV4uQz1f5dS1E8+b75jc1Z
         WNJarKsmS1lZxqDjl1S1JJVIdOfA5k+8YG/cqnzSCMzC6Uxd7qRYKFPbEdkdN3j9TFep
         iCNSo2ViHZIAjptPBRhHo8GbTkOQR/jsO2i8edivf4rJ1wmZpymiZgIZm0Fz6fiCU+gQ
         0551SjaQJ8inJXP33vC8y/C2AE8jFQqm0+fpvI+JfNv5ErARxsWaD+Y0WThclTTwodZJ
         aYz7LM/nLhpVd+CXSBYsAQJVOEEoYCBR3CljnPnS6Dvy+T1RUzBpZgkQcqRokMCCrenY
         UxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746000994; x=1746605794;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qsXzG0OPFSj9Y/N7ILSDxyejpILMY8rt11Cw8ETnit0=;
        b=v0Icxxok4CtNjjz98+/VeEEjoKBtRiLuPm9G65DgiLwUF2LHvypVZ/2XZSYBBODHCT
         kx0yRWYIOQSjoI/1miOlXApHkpHAZS/66EIgDPxGrtAYQgaINsAnJkAYYVfLA5jo/fBa
         sUC+XFTnMuqsQQ1JUI1fgH1BK1OuHCqBDSU0dI9O5iLIQPk0wAOVQHkfSvo3DN4srO9D
         yxT9S/R/rkUXtgTBNDuYjPh9ju5cnu+egyiuXrpOPq8pe2zv+5TR2HzEaqdPyg7InpXg
         fKXv2VfhjlE2YKD1SHL82zaaDEaeSg0n/hLLDqN1ua7ENDHQ55wY5cj13QAKCSzUOj26
         6neA==
X-Gm-Message-State: AOJu0YxyokYuz9ptB5zXbd/e5IH9GbOaZfS8tfBTZ59CXqk/rqDaROkm
	1qGsifshf7ZaNpRarHy5/K0rwcUdl33ZayBNzbJkRP7yXcTQBYYoU0FzXfb0zxg=
X-Gm-Gg: ASbGncsIYla5fIR6VP9PHiOzrbay/F2lIaGOjxm88uUk/kcTpx56pIKiwh4vC2VpVNX
	BAA1o787oHtokZ5OOTyl/g2QsqQs6FnBwJWKeFQd70HADJsjrHwDrWvCCTZf9VTOZZA0IGAipVM
	6ll/DGGZsi4zLU7LX7PNg9k0yXCFVZkXFS8W8uBkerA6GhpVloo1vQ+uEUQwkkPHu5jEOjk/rJE
	ZFguqPQ6Vp01WkMHM35PqOYuf0C8BVie7qQRGaor00xZaTh3HfwCUlFHeIjGldyMKy/e6QXBzyb
	tVQxhITw89OWxLwSUbc9/tISw0F4nPXOiRZUJrw3Pxq1O0n6v0o1Bw==
X-Google-Smtp-Source: AGHT+IH6seQgwJqi/FP/vswGEFmbX1nzlJ/wu6PVrapojvhfM+Yipa5sWjHxHBJfv7qDYrJjbCoowA==
X-Received: by 2002:a05:6a00:1146:b0:736:7270:4d18 with SMTP id d2e1a72fcca58-740389bbc36mr3347820b3a.14.1746000994070;
        Wed, 30 Apr 2025 01:16:34 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a309edsm1073084b3a.91.2025.04.30.01.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 01:16:33 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 0/3] RISC-V KVM selftests improvements
Date: Wed, 30 Apr 2025 01:16:27 -0700
Message-Id: <20250430-kvm_selftest_improve-v3-0-eea270ff080b@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFvcEWgC/4XNSwrCMBCA4auUrI3k1WpceQ+R0jYTO2iakpSgl
 N7dtBtBEJf/MPPNTCIEhEhOxUwCJIzohxxyV5Cub4YbUDS5iWCiZFIoek+ujvCwE8SpRjcGn4D
 qFkyrLWsqI0k+HQNYfG7s5Zq7xzj58Nq+JL5O/4CJU0bLo6zyGtdG2XPA5CMO3b7zjqxmEh9HC
 f3DEavDD1xazYGp5stZluUNvbqg9gMBAAA=
X-Change-ID: 20250324-kvm_selftest_improve-9bedb9f0a6d3
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

This series improves the following tests.
1. Get-reg-list : Adds vector support
2. SBI PMU test : Distinguish between different types of illegal exception

The first patch is just helper patch that adds stval support during
exception handling.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Changes in v3:
- Dropped the redundant macros and rv32 specific csr details. 
- Changed to vcpu_get_reg from __vcpu_get_reg based on suggestion from Drew.
- Added RB tags from Drew.
- Link to v2: https://lore.kernel.org/r/20250429-kvm_selftest_improve-v2-0-51713f91e04a@rivosinc.com

Changes in v2:
- Rebased on top of Linux 6.15-rc4
- Changed from ex_regs to pt_regs based on Drew's suggestion. 
- Dropped Anup's review on PATCH1 as it is significantly changed from last review.
- Moved the instruction decoding macros to a common header file.
- Improved the vector reg list test as per the feedback.
- Link to v1: https://lore.kernel.org/r/20250324-kvm_selftest_improve-v1-0-583620219d4f@rivosinc.com

---
Atish Patra (3):
      KVM: riscv: selftests: Align the trap information wiht pt_regs
      KVM: riscv: selftests: Decode stval to identify exact exception type
      KVM: riscv: selftests: Add vector extension tests

 .../selftests/kvm/include/riscv/processor.h        |  23 +++-
 tools/testing/selftests/kvm/lib/riscv/handlers.S   | 139 +++++++++++----------
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   2 +-
 tools/testing/selftests/kvm/riscv/arch_timer.c     |   2 +-
 tools/testing/selftests/kvm/riscv/ebreak_test.c    |   2 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   | 132 +++++++++++++++++++
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |  24 +++-
 7 files changed, 247 insertions(+), 77 deletions(-)
---
base-commit: f15d97df5afae16f40ecef942031235d1c6ba14f
change-id: 20250324-kvm_selftest_improve-9bedb9f0a6d3
--
Regards,
Atish patra


