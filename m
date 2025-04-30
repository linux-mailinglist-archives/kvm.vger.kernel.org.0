Return-Path: <kvm+bounces-44836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12414AA3F7F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 02:40:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0142517537C
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 00:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FD2296FB0;
	Wed, 30 Apr 2025 00:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="iSQJT8CE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F229F111AD
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 00:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745972334; cv=none; b=CirLUeVcGyhdmG/iORRWfWyMA24l4ZnfbkKVLs6vKuNgbZjTU5Twb+ic0l7xfSoPIX2C/gO0RaPhBhyw31exueGNkfCqOQvkiqCi6pEYgx4Yh/DKayLi/sr/dzI8w0ETeLA2zIHDSzhlpz6AqL5yWcvMGhny4ycC/jT3Rnt3ixA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745972334; c=relaxed/simple;
	bh=KXd/3V6PehhhU+w4DD08sX0JcXGyOTe6/oYAxTzMw+k=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=e7b0sUOviZRyvE1j+jknw/ZuFtZfn0cWS/SHlhwSao3g3Z/wxcjFOK6nvVE5EtagT4zsdpaFRUpAIbf4pZ6QtPpuAOW/TUuMPt/9q2DIl/wNyAl1g8kKZivEzBRwd0vHR6a7ZMtntYZ3DLbgHhrx29kJrkVBK+wS4aHg3TUmZoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=iSQJT8CE; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22c33e4fdb8so71140565ad.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 17:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745972332; x=1746577132; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h9CDC77dPHm0sLL9zARbZU/pLEdmRrLjaN9hFpvRuxw=;
        b=iSQJT8CEgHwqsU+qituaKviji7nMZZH+ctnwFZQGPvBROOGwknlkseOf55UGltC8D8
         F5ShiJ7xd0KZkA4F/9tRjQbqYr02GtyIpGlGBxyODjUTzk7XwJWyQv59Cj10erkz4Lct
         dsM+hnOIv0dFwW5UJezZdRTnV4reFsNk+nz2Hp9mtYPQrkhLUu63J1aKUbdeajR1Ap1F
         bVRQ79IfAZGhaAkvaB0Fl42236fdnV7gXKpabUTCwZGyivDLuGQBKqDRsYMsbZ2QciJA
         FO/SJHseulh7vOVk6duPK4mh54ITubQo4ALT4kvO6tBFZVMu6O0QQJD+cuVnBOiBJJf4
         2ATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745972332; x=1746577132;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h9CDC77dPHm0sLL9zARbZU/pLEdmRrLjaN9hFpvRuxw=;
        b=IvPnu4qdAZZqAoJzCzzQEJ98V3u6MeCwxGCQFT/jHwegESCXElu0q5qqvpm/yHPeFJ
         mWh9FxEwBuSqdggRbPugk3VQF1hWZB6nikhLSEOFKXQDSLOAB1WLC8lWpyFKKpUuD8FF
         zLu5THGWvBpEQNWyd/lM60bPVtUR0qPWLQwIOGrGz6F4+u2x1xHkfECeUpiPhzYF7i0G
         8E7162qzBFfADCiwrnHbUzyu2YmZWc1vwqMtm1Xa4OyxOb+Ebc/5bBWmzwKwgR8Kaai/
         8yiugw6XDHOe4vKEmGhFGQJRtvzGKID/X1AEjerLbi5LIxkR9aNdrhE56JtJJ7RbajMJ
         RjMQ==
X-Gm-Message-State: AOJu0YyKVvpAUjb+FyAkQucjnDSbj0jPPcU74Nl1vlwKs9x7BC8kCjsU
	1vQbku8YRkNmnngLlIgIT+g8/Lv/8mdmCXkVB1nvD6ADtJrw2CiwBgk8/8bPUKE=
X-Gm-Gg: ASbGncsiTE8JWlw2+YoEZQctEYsdiT4S+HrJWzQ2ESLq+w9VjoRJEH20TmUuEPharQC
	PbPG+buJH3oztEOkRo8ZRS0AeTeqgPGwobrnerm6++hn+8R/aqpWEDBg+BNTkSJTvJNdyelqK87
	wTnnVYViZma4srzD0x59qRaHgxxLHExgoP4w0ACwHyyirTkfGkwzIgYyPzf/Avuz6pbNVwmKYC7
	UQYpmETgh91BRh02SBEW1Qk53ZgmKq9L94/sK8AzJ1NMbiAWDmZhjaRE7tGv2AbfgyuOmsifMHB
	6P9+hpwdw8gpDg+XNpCPHfmEwci02ll9Fjn6T+enMk2yKoBWiyoQLQ==
X-Google-Smtp-Source: AGHT+IGcjNS30ZUbgOqbJ+3hZtDKq2g7yhYNKy+e5TbCHxGgjZoKOda+bZdglX1wUFE80tZeA/2XMA==
X-Received: by 2002:a17:903:1aaf:b0:224:1e7a:43fe with SMTP id d9443c01a7336-22df3585814mr19158975ad.46.1745972332359;
        Tue, 29 Apr 2025 17:18:52 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1f68988ca4sm1907790a12.74.2025.04.29.17.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 17:18:52 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 0/3] RISC-V KVM selftests improvements
Date: Tue, 29 Apr 2025 17:18:44 -0700
Message-Id: <20250429-kvm_selftest_improve-v2-0-51713f91e04a@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGRsEWgC/4WNXQ6CMBCEr0L22ZpSfiI+eQ9DCLRb2Sgt6TaNh
 nB3Kxfw8ZvMfLMBYyBkuBYbBEzE5F0GdSpAz6N7oCCTGZRUjaxULZ5pGRhfNiLHgZY1+ISim9B
 MnZVjayrI0zWgpfehvfeZZ+Low+d4SeUv/SNMpZCiuVRtrpWdqe0tUPJMTp+1X6Df9/0LFkf1c
 rsAAAA=
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

 .../selftests/kvm/include/riscv/processor.h        |  23 ++-
 tools/testing/selftests/kvm/lib/riscv/handlers.S   | 164 ++++++++++++---------
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   2 +-
 tools/testing/selftests/kvm/riscv/arch_timer.c     |   2 +-
 tools/testing/selftests/kvm/riscv/ebreak_test.c    |   2 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   | 133 +++++++++++++++++
 tools/testing/selftests/kvm/riscv/sbi_pmu_test.c   |  24 ++-
 7 files changed, 270 insertions(+), 80 deletions(-)
---
base-commit: f15d97df5afae16f40ecef942031235d1c6ba14f
change-id: 20250324-kvm_selftest_improve-9bedb9f0a6d3
--
Regards,
Atish patra


