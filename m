Return-Path: <kvm+bounces-8660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F5F854918
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:22:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7DC728E96A
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3A91B96E;
	Wed, 14 Feb 2024 12:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OpvMs7hN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E064A19
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913312; cv=none; b=miAwYRpKXNV5+E2Bfa1cDrXLf8ZKeb5v87JzqMsc2KsjgD+GWlTuDbGWcjQ2G+3w2i1bDZDdaGmP+9Tm/Be8skLqAmdXosRcp1erFyNwH+vopK4ea+1oPwCvF8uSUopb4+x3W0/Qi4bJ7vB8/oWES7ioK3lgliXDl/MTkhVpfrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913312; c=relaxed/simple;
	bh=Cq0UxcVr8tx5pWC9EGJg72brKJYDwM0KRQYQGfepb0A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qBm+H/wo9JPMeQK55JwgQ6ybmAgI+EetzKgsvpC3IL/ssKa4BgwExMQN4MFUIxMmRBC2FI6dQYOnWS5dit3HQYbT/r5H4mveZKYWv6vGFsS4vQm+t3p+Ndyo76+2yqOQovnntVuX5YGxyECO6NqnwN5a89zOASaKbjLPtVByuKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=OpvMs7hN; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e0f5934813so1508185b3a.2
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913310; x=1708518110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u68231bLleqBaxygAmpN2bjiigQ0k1UWMWbFaTBnESU=;
        b=OpvMs7hNaCE5DPIluuZwBTmeYDMua/DQYHBzda3ysUe7YZVqnLHlvqRWezIIdbOOS2
         tw0oLJZD71UT26kg9TtdMvoh2x4zD5llKbn4sf4gzpeiMaj4zZu8ZFHCmY1FQloeeKdp
         +SHLvs44iFheVPRSqQZCyNonY2mRNG650XwC2i7+BjzkiId4TUKw+nNumDGeOlMtIXsQ
         Z0Fl+7THOJ6EZFlixuKUALYiS2q4tyCvRNz5827zKjn6ytDEjnJAeillDjukLIpk7bRd
         D9pRnw+FbzQ183svYP07ADUPjf75qV1h1ROHsvSrG+HH6D3bNAVH/mXAJkTPYaCQXT/W
         XQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913310; x=1708518110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u68231bLleqBaxygAmpN2bjiigQ0k1UWMWbFaTBnESU=;
        b=FW8hjlww9J++iZHKAxT8DSKC7qOO742DkrhAqZXVz1UGfhyhdBOsBc70/8zxfRFCvM
         m1+VEwD0PKIv6wHyf43i3d0Lj2zAhZwhNsI9aR1LG7zu4iGNetPGAdN1mCWfQSuIZU5c
         glDKEkOT+CjqzkZNy08QzIBhB70OKOq0uig6ga9VQB9SBT5yvFQ76l2pRl66BYmT7z8X
         uMcSqGg17WI/oE6y1blLrWklionJzG4PNu23Brfp1sdBiXK5Aa78e27GkTRlBtQLoKCU
         1TRu1neoV3lHIiw56XVJ6pzsR0hs++SCJxdIDnIPHFPuhjv5A9YYLr4VzV12wwVqtOZr
         /DKA==
X-Forwarded-Encrypted: i=1; AJvYcCVM1s80Shnk5KypsGar+gOmnLNTBPUh8wHe/PVq+vfoprAo+2kIMtiemEkSp6gUrjN9d2d/ANFUpbhDBav2T/0WnFpZ
X-Gm-Message-State: AOJu0Ywa0Bf810D5p4Pdp7E1eW6IOxi2Dab/i5p9ACHJLZ/eaTSt4C9K
	cko5e6YcjlMvG34Rgdq1RCBil5AW8T0ifYXkUtWnMCZnzdTkyqlqmqBVqVqbTRM=
X-Google-Smtp-Source: AGHT+IHi0tc8FDguo7rGj60b44XxrHqJqAOVz9tcujGDi/0weOi4Xd3g81BNizaVHeY/bBm2Q2I14A==
X-Received: by 2002:a05:6a20:c90e:b0:1a0:6856:d19b with SMTP id gx14-20020a056a20c90e00b001a06856d19bmr2160786pzb.6.1707913309897;
        Wed, 14 Feb 2024 04:21:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUbzwL6RgL/cDlhnopG/qkdCR1fYSDnDvR9xQdPABqjjLFElHJoBQHBpkLQWBFXXdeFP3NiV4zkvNZYm492YZHh5YDHLw3kPTgEnafbAlpev+VyiobttaS06gbWMikSJa9oCkp5N+Aa47Z1gT+ms6KR4lutZant6rv7BlacYcS+VEe5jOD0RnWRN4Yt41xRMliOSqgDFDb7+Di2xxLVHHDvt+HePIyDVgN3IfbKGRh9ecbivTwIl3XJMUWNCPnaljGSb5eR9e1QKRTzuHxqO0SVIyF4zqdSC4oYtMsr9WQ1Domvvso3vYqJpbmBTurTlw==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:21:49 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 00/10] More ISA extensions
Date: Wed, 14 Feb 2024 17:51:31 +0530
Message-Id: <20240214122141.305126-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support more ISA extensions namely: Zbc, scalar crypto,
vector crypto, Zfh[min], Zihintntl, Zvfh[min], and Zfa. The series also
adds a command-line option to disable SBI STA extension for Guest/VM.

These patches can also be found in the riscv_more_exts_v1 branch at:
https://github.com/avpatel/kvmtool.git

Anup Patel (10):
  Sync-up header with Linux-6.8-rc4 for KVM RISC-V
  kvmtool: Fix absence of __packed definition
  riscv: Add Zbc extension support
  riscv: Add scalar crypto extensions support
  riscv: Add vector crypto extensions support
  riscv: Add Zfh[min] extensions support
  riscv: Add Zihintntl extension support
  riscv: Add Zvfh[min] extensions support
  riscv: Add Zfa extensiona support
  riscv: Allow disabling SBI STA extension for Guest

 include/kvm/compiler.h              |   2 +
 include/linux/kvm.h                 | 140 ++++++++++------------------
 include/linux/virtio_config.h       |   8 +-
 include/linux/virtio_pci.h          |  68 ++++++++++++++
 riscv/fdt.c                         |  27 ++++++
 riscv/include/asm/kvm.h             |  40 ++++++++
 riscv/include/kvm/csr.h             |  15 +++
 riscv/include/kvm/kvm-config-arch.h |  86 ++++++++++++++++-
 riscv/kvm-cpu.c                     |  31 ++++++
 x86/include/asm/kvm.h               |   3 +
 10 files changed, 328 insertions(+), 92 deletions(-)
 create mode 100644 riscv/include/kvm/csr.h

-- 
2.34.1


