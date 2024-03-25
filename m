Return-Path: <kvm+bounces-12593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40EFF88AA8B
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB09C1F336D7
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266133F9E1;
	Mon, 25 Mar 2024 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BTw6DqGM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35E246AF
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380714; cv=none; b=FZJ2yiG09PcSuPgtYz0YQDy2avyggU9+SlRAxxz9palyXJ1oiJBra8Ls4BB/bJVs5mOb5E7EIwW6IstXZtOFibHqRBVVgkN586lK24dyv7OxH3QcFYS0nB095qG0lr0CpPb8Xzl/jphBJCldpn4O9NZimJ7eCTk+MzS3xy1tdHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380714; c=relaxed/simple;
	bh=LckTZ9wKkaZXqL2Mn57MIcb6O/xWrvCGZakLrtPZXg8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ARg4busYbFH749KdEKPUb7eTXCTpOHnmjinyct7/Y4FhLuUR38WwhdJc4aTI+DzKYUSiUzkqc8ewRUOXC07gaTC6Rc4a8DQ/P6pUd8CB4GntQfQLHWH6kYVTJtWXiI+EYl+52hOQOLZ3K9H2/IW5qrkcAI5S8imTKBl+AmqAb8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BTw6DqGM; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1def142ae7bso38675735ad.3
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380712; x=1711985512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jr+p/IjPsBq9GTQHQz+oXofKWOSV+QOJbV+y/AyTrto=;
        b=BTw6DqGMKjtCKHWKMibqr6LmcjWAMmWGVfVRvH/Yb3qLJ6Gw4G8L+RbTneH9W8A9xr
         aIvw5rAJaXOfAtYJ1dcpyXf7/aK9lH3fobElQIf4Muf53XVr96zM5azjuAt04FRDh8CL
         eAlF7t//IJS7MtgBDY4XAOZMG2PX1XgGVr7FskUxhL3AVrLtwbYvDuDur4OzMUqUjV1J
         ym+jxu5DpyPRhuDXpoFpsJ7fQvWlkJQvQuDh1UGHmUGxZYmgcS19OSiT8cT6iShZpZaH
         b5lM7dZv25Iy/SuyQFPHxVwuoOp3gIuyXV2hxVO7HLWErqqr/4N/hDjYn8nuc3HNuNf2
         JJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380712; x=1711985512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jr+p/IjPsBq9GTQHQz+oXofKWOSV+QOJbV+y/AyTrto=;
        b=mkJKYNLaTCyH7RfuJ+5DO6mJEV464JrvHHz6up1E4p6wBsXiILRUXfaEuJGSuyX2nV
         UIxT0vJ1NhB7bnW2bWaLdrFP17+Ug+RykjERCWkW3yK0OODoL7Ib2qtVg4yuz7Koe+ij
         QRB4mSPvWA9ntUdG8f1SPF6lxkH/6bBBr3THFLoLb38y0eDMMngD8XkxkwaCPVyfizqL
         S3iTYA8Z47FryuvzonvhdiJH6PpSP0NTtyUw9/qgaeCULdRFFyLqo48Z7li6ugdocXm1
         zSKq7bwEjEZoSV/T9UXvO5//cTLKadKGunNeIlqcdNFOGksgb9a6CZPhsSUUIg8Ij4Dw
         JpjA==
X-Forwarded-Encrypted: i=1; AJvYcCV+4CUn08se4ogj09OndAD38UPUBSkAFttA796GSi8lgPCBniYxFcgWm0k8MZkVdgYqPXmiVq1LpLfzJuDxkwq2lTnM
X-Gm-Message-State: AOJu0YyM9d5RzZNVm1N2cfpLIMnKYsHmQLeAWqp31qVZ8/Fjw82T13Bx
	EUxcAYOruSfOQ7w3OG89n8/B8hnzheEGQQca0NG2d0L893uz4+tvGAU4JiSEj2Y=
X-Google-Smtp-Source: AGHT+IFWfH4QFpMkO0DZydKJWuDlfCT/oEi6iJDRNi3EjEGGXf1O+4tiaeXd3ASN3hiReco5Kk5htQ==
X-Received: by 2002:a17:902:8bc8:b0:1dd:c24d:4d1f with SMTP id r8-20020a1709028bc800b001ddc24d4d1fmr6087277plo.67.1711380711809;
        Mon, 25 Mar 2024 08:31:51 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:31:51 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 00/10] More ISA extensions
Date: Mon, 25 Mar 2024 21:01:31 +0530
Message-Id: <20240325153141.6816-1-apatel@ventanamicro.com>
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

These patches can also be found in the riscv_more_exts_v2 branch at:
https://github.com/avpatel/kvmtool.git

Changes since v1:
 - Rebased on commit 4d2c017f41533b0e51e00f689050c26190a15318
 - Addressed Drew's comments on PATCH4

Anup Patel (10):
  Sync-up headers with Linux-6.8 for KVM RISC-V
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
 riscv/include/kvm/csr.h             |  16 ++++
 riscv/include/kvm/kvm-config-arch.h |  86 ++++++++++++++++-
 riscv/kvm-cpu.c                     |  32 +++++++
 x86/include/asm/kvm.h               |   3 +
 10 files changed, 330 insertions(+), 92 deletions(-)
 create mode 100644 riscv/include/kvm/csr.h

-- 
2.34.1


