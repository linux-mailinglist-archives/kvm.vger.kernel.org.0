Return-Path: <kvm+bounces-50163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED194AE2376
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 22:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1976C5A3492
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF482E9EB4;
	Fri, 20 Jun 2025 20:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="wz6jXaMt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A7233721
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 20:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750450935; cv=none; b=jerIOm3OMpMYkveInJl3yZeKY3LstShm8WPsbRdvZB4XTzV8eSvTHjHsrmT1AkVdK6lqhxDnKG/9shp74Sm1MY+ZoJBLPuK+ILWFswo9ZORymdYv8ZXTF7F3/yS4SK58svsuXZ2dEl0kpK2vKrocy0IBndpsUOsIlvAfcuh7S5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750450935; c=relaxed/simple;
	bh=zNnEbdShfnt7dg6Wnhs4FrAsA8snzs7PQOci4sCR+Cw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=MVxyt3vIcrewcsP3tm7dtUumggkxmADsV9jWwdl8AK7rITSRvTcRc1jlELpUXQFmFPtDzGXlaEkW+gQ2UnyBMP5wtmL6bAMpHDr+ZKffu1TOx0iQ5B7L6N4lvPCA6P3+sViIKyK1B0n+al/cEEVACpOYEBKbVGm/B9sk3fJ7t9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=wz6jXaMt; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2353a2bc210so20501355ad.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750450932; x=1751055732; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zR93x1w6dXrRMkMadRB1UTNlrKc0W0v3FGDIv1ERUx4=;
        b=wz6jXaMtkTctUGKPZhVGymmCUm9FRFeXkZf1glEuZ4AlRHUMZ/HtTiAcdjkrlOZ2MC
         stN59+AYKHwHqnlXUKkhcIwICHuuahgGus//GX+wfD8UXF/dd8kSwEN3vkQXUk77E5ix
         QjHxQNcwFC7tCERxKm7uAWvAwhw+fAPhp5Ivb3P10AqONPatlZNL9Fms6lszoSDe81DV
         ef69Qm5ONZys8rMg1IOGbgsWb31bX+DOn/k/u4iWkXrKjTQGJz3UkF3xS0xGMcUpWEMi
         JLPdzPGdir6VU0IEV2aWVBV27+WnHB1uwqcIEutH4KsgYvfc79tsw/29MybrFYkm8GRO
         boWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750450932; x=1751055732;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zR93x1w6dXrRMkMadRB1UTNlrKc0W0v3FGDIv1ERUx4=;
        b=Q+6HsDLI7H3x6iKqhHHJjGaP9S5JJdjYAE+2TsMBScgoSH4ntx9cvC2CbSSv2tj/FL
         79wW+xRktJELQXETgKZNEmUFqwZEx7mIr3wE0AXEId4JUZtO7j/fBaMt1KuSRPHbC496
         NNHCqFjGLA848a9UitLfy3ecW3m4JxewYtF/2ekHJXKMmeFl79eTW1JW4izLvYYozqV+
         8AzBiA3v/XkG3/EQEdCfE89s+F2Jxw/UE0cd4lWn/v79bWU97A3tbd+lGQtJhlMzOZgA
         D69WmxRNqlSZZ6/SIUpIiSzheL9w0vmofDMRJR0bMtSFtRy/Ngpi/B+h7KYXebTUuDwq
         flRw==
X-Forwarded-Encrypted: i=1; AJvYcCWwh9+QVWZgO1XsYyVQVkqJ3bO2cSh5h8B6n2HxXH121/iiSjEndx5l/qM5KNv/aRMeP2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMlQhkCCWouR41MI5Iq/Zjes/fZTsLgYmIWNuaCko2fv5npYwS
	iLl9yPSxGjwZra+WaLLSkM5X/fEPIlwEn6PsQyvzqMmnu/iPbqJIxxzf+IPMmWJuqPM=
X-Gm-Gg: ASbGncs9DuX3LXeLLpjWb37/mVgZVWvjkNblTOEE9x3YKWlfDuVIoyFiGyoWFmPUBHX
	i/H0l2OQR+IHbgFM0Wgu0l/Qw4ni2ANdVjrITojLxk+Uw05b+UPykoGFHXtlb9sWJ+HPChIES98
	nx7REGseCgFkFFgdmr1Rs9nk0Z4eJmkCEzu6+F2vEBqBemPcRpho7Vb7SxH8nKIutihEcsvkkbE
	+AF60U47cLyAMieLpCArQ+AO7yu1Iw6xfrLJghjMwDdogBierAPtWosVc0YzWe9dpvPtVCSm08o
	LFCIlz6KapRjgwVYXuHn3XbDP85EHeZJQssLP7/QZnemsTTDNHYN7EEj056Yt7F2XczlMOLfujq
	4qfNFGij0lY6sCwm0VRK9FDctSbcm9Bf84A==
X-Google-Smtp-Source: AGHT+IGMjAKS+ZR6xDwRzLnhzjJTUfYEfrwovg8rbA1ebQN5xfuztY8xY8dqTmR5sIFHBMzmyc1fcA==
X-Received: by 2002:a17:903:3bc4:b0:224:10a2:cae7 with SMTP id d9443c01a7336-237d9981dc9mr67398695ad.40.1750450932143;
        Fri, 20 Jun 2025 13:22:12 -0700 (PDT)
Received: from alexghiti.eu.rivosinc.com (alexghiti.eu.rivosinc.com. [141.95.202.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d860fb58sm24239005ad.99.2025.06.20.13.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 13:22:11 -0700 (PDT)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v5 0/3] Move duplicated instructions macros into asm/insn.h
Date: Fri, 20 Jun 2025 20:21:56 +0000
Message-Id: <20250620-dev-alex-insn_duplicate_v5_manual-v5-0-d865dc9ad180@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAOTCVWgC/x3N0QrCMAxA0V8ZeTbQZVTQXxEpsc00UONoXRmM/
 bvFx/Ny7w5VikqF67BDkaZVP9bhTwPEF9tTUFM3kCPvzuQwSUPOsqFatZDWJWvkr4Tmw5tt5Yw
 UaRovY5zc/IDeWYrMuv0ft/tx/ADolUImcwAAAA==
X-Change-ID: 20250620-dev-alex-insn_duplicate_v5_manual-2c23191c30fb
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
 Andrew Jones <ajones@ventanamicro.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1777;
 i=alexghiti@rivosinc.com; h=from:subject:message-id;
 bh=zNnEbdShfnt7dg6Wnhs4FrAsA8snzs7PQOci4sCR+Cw=;
 b=owGbwMvMwCGWYr9pz6TW912Mp9WSGDJCD72P8Dn9w+tB9qn6mgksQSULDE+I5Uh+Cv1r/Vl9V
 zyHwHKNjlIWBjEOBlkxRRYF84SuFvuz9bP/XHoPM4eVCWQIAxenAExEO4Lhn2L99duffV9+4rU4
 c++cq1De1m3/N17SqX9TLrJw5+2jH7wYGZYK1y25xpz/NbrjiP2VGt+AsASb1/PY1jKVBUxeHRu
 TyA4A
X-Developer-Key: i=alexghiti@rivosinc.com; a=openpgp;
 fpr=DC049C97114ED82152FE79A783E4BA75438E93E3

The instructions parsing macros were duplicated and one of them had different
implementations, which is error prone.

So let's consolidate those macros in asm/insn.h.

v1: https://lore.kernel.org/linux-riscv/20250422082545.450453-1-alexghiti@rivosinc.com/
v2: https://lore.kernel.org/linux-riscv/20250508082215.88658-1-alexghiti@rivosinc.com/
v3: https://lore.kernel.org/linux-riscv/20250508125202.108613-1-alexghiti@rivosinc.com/
v4: https://lore.kernel.org/linux-riscv/20250516140805.282770-1-alexghiti@rivosinc.com/

Changes in v5:
- Rebase on top of 6.16-rc1

Changes in v4:
- Rebase on top of for-next (on top of 6.15-rc6)

Changes in v3:
- Fix patch 2 which caused build failures (linux riscv bot), but the
  patchset is exactly the same as v2

Changes in v2:
- Rebase on top of 6.15-rc5
- Add RB tags
- Define RV_X() using RV_X_mask() (Clément)
- Remove unused defines (Clément)
- Fix tabulations (Drew)

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
Alexandre Ghiti (3):
      riscv: Fix typo EXRACT -> EXTRACT
      riscv: Strengthen duplicate and inconsistent definition of RV_X()
      riscv: Move all duplicate insn parsing macros into asm/insn.h

 arch/riscv/include/asm/insn.h          | 206 +++++++++++++++++++++++++++++----
 arch/riscv/kernel/machine_kexec_file.c |   2 +-
 arch/riscv/kernel/traps_misaligned.c   | 144 +----------------------
 arch/riscv/kernel/vector.c             |   2 +-
 arch/riscv/kvm/vcpu_insn.c             | 128 +-------------------
 5 files changed, 188 insertions(+), 294 deletions(-)
---
base-commit: 731e998c429974cb141a049c1347a9cab444e44c
change-id: 20250620-dev-alex-insn_duplicate_v5_manual-2c23191c30fb

Best regards,
-- 
Alexandre Ghiti <alexghiti@rivosinc.com>


