Return-Path: <kvm+bounces-28005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05E0699152D
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBB3F1C21CB1
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4553C25634;
	Sat,  5 Oct 2024 08:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VAont5DN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115923F9C5
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115236; cv=none; b=sh/YlxDrkrhxELuFkIcb4LrARhY6IqmTu7gfPAHjWDqsYgHpo7suV5YW18xUFHrDyot02lkGSFjNJ/HC7ykdoAUmpCMrOurjLP2MXcXXohZD6NQN3FjJMfNgVdJMH+WS0WhA/y4KG4l5q7r1y6F0i+w1B+dxCmqlyII4spxz3a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115236; c=relaxed/simple;
	bh=cOr6gLqsU4vlonYBYS9lXUEmo4bSzHBeR/r+LnxjwBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hraNcYL4dLm8v+Uwl6O+ooFQ0fWnIZ1UwpzdGrfiH0/1npd+HKwRm+G+npY77lkMg5XXfkrguY+MdQcV+8iaVV7lLcE+Nr3Fk0FyjR2gv/faRDVn0pxr0C1yKbkP00PGNebMd4+0iWhQqwwmjtiD1M+LKuQuqQElZ8tL/Ru2tiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=VAont5DN; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2e1c91fe739so1996603a91.2
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115234; x=1728720034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RmFoWuVk6kEXGWW7zHMED7qjE1ysCIRqCOVUSssqr7c=;
        b=VAont5DNvm2wYQAEVX5D2wPbnMS+ytZteR2R+n3Xt/sJSWM3HbGOzCW2hMMzNl+dhA
         LoR+QbNvMGldoEd6qexDXibITBl/JWlYpGUUdOEWhxtJ04+03CiMbgC1BzUwYXmaBZj1
         xAmBRBZD82HkOivJ9KHTTUqKqkp76ECcxk/dbwiAgIhiAya8L5F6bmmLecjR/P8lDGVJ
         Olq52w0d5r3IDQ0HxugONkIzO3n5lOWAPZagvS05/atu/bdXbHd0uPCliK1U8hnSBMlX
         VfffFDVV+dZSrGcFeA7UUmczQ7aZfr9s0G+WIS57moEBaJKRcsANirDk8fnXAOV0Zpii
         wgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115234; x=1728720034;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RmFoWuVk6kEXGWW7zHMED7qjE1ysCIRqCOVUSssqr7c=;
        b=MJf+oLj1FRoNWzatHBrMYKufm0eEvSNLe6rsaQih618a4T5fAsdzcMh8F1no8p3Zys
         9SnFkVauhRwjU+rYaUT3F4d3w9ZkP4zkvozCaxpBSCR7AQJ+rx2yPrZp05WdkgB8um7H
         iT+M5nEj3YFJkl2Pvu3wp5HVUgB1aDKSYh4zzIdVr3VtCfXds1pztMbQRyTBROezdhd4
         Vt4THIYjcpq1t91+/O2pOJa+aAEZ/nMvSOs4mSksKvHWB5xBTRRIZ/ftEwhp/yQ0VvNZ
         276wL/WRZnEsC1NkuamDy7450kJAY5UJvnJWb6isQLr3EPmkNlHBJDZcf66JkU3vxQZP
         HxaA==
X-Forwarded-Encrypted: i=1; AJvYcCWpFnwiTei9fYf8SlcitCmWItySTdKVRpr8TWMzff7w4nm+ZHkCm9+ADcCVIxvH0VK8RyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP1Um/KSZMCox05gaFdya/YUI+vixYVgr5SMZ0kwYk/zjISNYH
	rRMzT0A6m184UukmAmPwNjtEHes9vUdPexfqgnDbS13Oue6ik6TMEUkB2qPRwXY=
X-Google-Smtp-Source: AGHT+IHB25FHaQJdiFtQl8kmtVQrcoYla/icx2AzjRyz18LX9CcBHWRR/qJbL9XkaDkfBhQR0+sujQ==
X-Received: by 2002:a17:90b:19d6:b0:2e0:855a:ab31 with SMTP id 98e67ed59e1d1-2e20e07b04dmr2311380a91.12.1728115234097;
        Sat, 05 Oct 2024 01:00:34 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:00:33 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 0/8] Add RISC-V ISA extensions based on Linux-6.11
Date: Sat,  5 Oct 2024 13:30:16 +0530
Message-ID: <20241005080024.11927-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for new ISA extensions based on Linux-6.11
namely: Zawrs, Zca, Zcb, Zcd, Zcf, Zcmop, and Zimop.

These patches can also be found in the riscv_more_exts_round4_v2 branch
at: https://github.com/avpatel/kvmtool.git

Changes since v1:
- Updated PATCH1 to sync-up header with released Linux-6.11 kernel

Anup Patel (8):
  Sync-up headers with Linux-6.11 kernel
  riscv: Add Zawrs extension support
  riscv: Add Zca extension support
  riscv: Add Zcb extension support
  riscv: Add Zcd extension support
  riscv: Add Zcf extension support
  riscv: Add Zcmop extension support
  riscv: Add Zimop extension support

 include/linux/kvm.h                 | 27 +++++++++++++++-
 powerpc/include/asm/kvm.h           |  3 ++
 riscv/fdt.c                         |  7 +++++
 riscv/include/asm/kvm.h             |  7 +++++
 riscv/include/kvm/kvm-config-arch.h | 21 +++++++++++++
 x86/include/asm/kvm.h               | 49 +++++++++++++++++++++++++++++
 6 files changed, 113 insertions(+), 1 deletion(-)

-- 
2.43.0


