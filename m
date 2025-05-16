Return-Path: <kvm+bounces-46813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFEBAB9E37
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 16:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E4C01BA03BB
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF85249EB;
	Fri, 16 May 2025 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="yB0Sksp9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5057149C64
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747404492; cv=none; b=R/OBRlizQlUe6CNfx2nwJj9l5xHJ/qJIiIRo8ocqYCrINBXmXJAM5ULhF6BtOmvTq06aK7OJLbnKE03pTTorczTK5/zVUQ9wnf7KSj2dzdZSOnWxcNGhdxd96kt7k6hXKX4MT6TdUGijyFJnmAiqJLE7HyEOZocJKR2bF78XEtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747404492; c=relaxed/simple;
	bh=DXpfUEqmMwiHoVPoyi3gyAWljWV8OEGPJZUtzaWkZv0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ciSs8XwlMF0j8UEmaTBVZp51S4dwxLSOouZsy6JbFxWjgYaYnjlcEvePnYYXdUqtPg6cwgS7hOPQtAOcuN4E/bBlZYl5uhNN8etcpAkgDHFK4OCobXUteFyccmTNVtgHht3s9q/QetMMI8lsszIMCHX51HxiH52cXQpHLvj9tFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=yB0Sksp9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-442f5b3c710so16400835e9.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 07:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747404488; x=1748009288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k/BNsmKtmxng+uJwxYfVRzr1UYXziJ1APu78MxCAAdI=;
        b=yB0Sksp9G24lEji1n0UPBCF92UhV3PWtmTBm7zeweG6J87Bu2sa2A3C2F8GrhCEN3q
         flHy4VSJs9hA+mu8M5Ee/rLYJz9YvHomDjXQciP/ilxtzE7eh4UOI7t4asxuxN9qgO1H
         c1WfU8s/eeRjEFOb5tlRTNyYAkIxBKj2rr/RkQ1DDqd9wvzN70RejjTDQn3xdy6evfmJ
         vbC8yjwhsW3e4nKGTQCXNOMQZ3sttZgn+7U+d6iBLhZpIq2jtWjZxEwlUWwjvWaLeyHU
         2vysnxWmwwkk0L83OfV7s9q3WeDf9b0C897LLmuL18Ghu+w2tQ/bgnbxk2RwzJCbuexE
         49IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747404488; x=1748009288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/BNsmKtmxng+uJwxYfVRzr1UYXziJ1APu78MxCAAdI=;
        b=jGC5+duT6DXeexV7fSWGNPtms6rP9cKV1lLOgNcGYqFv5RYY5uKMLhDV5vEJ2QVcst
         aW3d26oSlVFZBR130TV98JliGGzfJ9l/QUqdWnHfdcQOlwPEDyp7R8SbyCuIjY39A2u9
         Px5BzvSuGzDD9gI/gAzRJ23ZxnRoKosBsa6QM/aXbKhbw8WNwQGkUfJT8uhqI3V66wWz
         /7LNcwTcJEnAqxNwkllVYrPKlKOAWYYPS0mFTiCABCHVZsLISr6ddN0zbdQeCnBqjcnZ
         tCMeQf5R/jTADA5DIr4qfEbLsYAHXRmOyWDNvMdnc5iWNdDiEvcaLekDoXP7B8xbi4D2
         TfYA==
X-Forwarded-Encrypted: i=1; AJvYcCWV9P/T1/wavAHJI6SVZSsEDj334pe7E3wL/o3ORrO0Tae+FtBFaaEj4TfRjgkdbgg3E0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNZkwpRoW7djGyY+Y3pPBWY26uP/vWoNqAMlj8GYxZHBRv1/Hf
	vPh8Tq93vTvOek0ml6q+H1IUWjWKWx7papYNU5UFwXuHBpojHaCIXwsG8qgp5myU4IM=
X-Gm-Gg: ASbGnctC3TKpl50SB0l+fBtlqsIFiiriM64gp4bSLqCJ4Uy+qDPxqXBF9kZRuxD40Vu
	FiMpo/vW2FAUVgaR8B9aMhnplY3FhnzIy8k9DzOH+4sWe+LSHQoBBU6mKN4kDQerjIbgthAkGnK
	fZLBsZDikXPxzVB8NfEAMyVnUjmJNIw1ooEl75I4kLChCMqVk2UZl2KUvxH/Zn9UuSFN41veB4b
	UNg1aBtJ9Axn30QyvHahttnROwmnMfjmPBbwpt/v/9Us+QrHrQL6YFs7Xe96AkyU3rne/+JtsUv
	3yMwvpfizi+pX228oyGhpyMpoLXUETC9GqVS0K4tz61JvSH6PRgj8ogDbfHs/4lVJ9RTBO0B
X-Google-Smtp-Source: AGHT+IGq36WEEdwcj2F1kc98tOimoY9E+6SHXs/IqyOGwvA6IL+/S0Nt0+GgQYvZ1hvDj9xey6cGow==
X-Received: by 2002:a05:600c:524d:b0:442:e109:3027 with SMTP id 5b1f17b1804b1-442fd6649bdmr38117515e9.24.1747404487692;
        Fri, 16 May 2025 07:08:07 -0700 (PDT)
Received: from alex-rivos.lan ([2001:861:3382:ef90:b6d5:4f19:6a91:78f0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f39e852fsm113910005e9.27.2025.05.16.07.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 07:08:07 -0700 (PDT)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v4 0/3] Move duplicated instructions macros into asm/insn.h
Date: Fri, 16 May 2025 16:08:02 +0200
Message-Id: <20250516140805.282770-1-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The instructions parsing macros were duplicated and one of them had different
implementations, which is error prone.

So let's consolidate those macros in asm/insn.h.

v1: https://lore.kernel.org/linux-riscv/20250422082545.450453-1-alexghiti@rivosinc.com/
v2: https://lore.kernel.org/linux-riscv/20250508082215.88658-1-alexghiti@rivosinc.com/
v3: https://lore.kernel.org/linux-riscv/20250508125202.108613-1-alexghiti@rivosinc.com/

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

Alexandre Ghiti (3):
  riscv: Fix typo EXRACT -> EXTRACT
  riscv: Strengthen duplicate and inconsistent definition of RV_X()
  riscv: Move all duplicate insn parsing macros into asm/insn.h

 arch/riscv/include/asm/insn.h          | 206 ++++++++++++++++++++++---
 arch/riscv/kernel/machine_kexec_file.c |   2 +-
 arch/riscv/kernel/traps_misaligned.c   | 144 +----------------
 arch/riscv/kernel/vector.c             |   2 +-
 arch/riscv/kvm/vcpu_insn.c             | 128 +--------------
 5 files changed, 188 insertions(+), 294 deletions(-)

-- 
2.39.2


