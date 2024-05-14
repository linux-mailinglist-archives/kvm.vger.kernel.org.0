Return-Path: <kvm+bounces-17363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 358AA8C4C11
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 07:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94F6CB23AD0
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 05:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA00318E11;
	Tue, 14 May 2024 05:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KZ2PnQ0w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43F1802B
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 05:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715665845; cv=none; b=nLialkAU/9E0LfRQ62ZrX8vty+GHFxoXQ6ucnBdGh4ra7chGvMy4x5mpvr3QOliKwiPDuciF5RcqkUOang1ML11JUuHVTfNIuVVtlCJXBb8chfzx7eBumYTfY8n9KEUPPc9w3od0jox+wTxwPFz7ko/mgmFOYNKw82GZMicrpIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715665845; c=relaxed/simple;
	bh=01ah1XdL950HqoMn7JlwMjOxV4LqSK8fjIWXASecoWs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NEB/V/r+66TZoSc9kvzEzDCah8CobtV9zhx4qM0K14ZKcKZ11ze7mXrWCMN9jZXfbaEvbsgDtBJGm4qQtQluaSy2BH1tZBg9A9yeLAkklYXybJCHQWZ6BgMLrzEJWyBl4y/z0XdI+mVUTr0aB4XTn4aHguhMu+Jw96LDusCHvW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KZ2PnQ0w; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f453d2c5a1so4150775b3a.2
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 22:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1715665843; x=1716270643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u5aoGArXiS8yBxJgx0+jL49twQOKVJmJlDWyfC/LBbw=;
        b=KZ2PnQ0w5xReuC6WXW1KatymUH/qTm0YAorAp2nT09lZ/bhkktC/enEuB8luBJmcUu
         BxVcFk0nUqxiRCh7+59ZTp5El7g5xQUxYNDU+dNDLcisl8zPWHnU0PbYEF7zvIwYbe0w
         Dszh5ggY6yL13hQQSzZXS928Lq5BVEREjkP9uQ2FW4PMOgD7xl1x5FLMoQVvow1Q5luV
         7xlYoadeM2tBimyHt+nOslnejynL7piqKOZ7LxfuLSFhvbIFRay1i1tiDPeSW/hDg/ex
         DKE3dXRuZzUXnWSV0pXIpTJJC2h8rYYCqqIk33qacOP0V/b52G4w3m1dWRalG/tHDo3g
         AQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715665843; x=1716270643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u5aoGArXiS8yBxJgx0+jL49twQOKVJmJlDWyfC/LBbw=;
        b=VoSU4N9auTohg5s7tQT8Sej2wLKnx+aG6EpinF2ElWj6kdm5aCs/46b8cIGUpaGRsn
         k2ycjRtz5+0FjLf8DjFoVQCKSoPP/yVNFiL2YfhcvdbH7TNf8GG3H5vnaaZergMpzmv2
         VRo2OQiIqJb+Yf5LrtOy9pli9BBq47ZJBSDZQL2RhneaBGhndWId6kqYDoANvs2XSz96
         QzU89+qjPogcvZdSEeZuZFrqnUHSx3HQF960zSpL1hDiDlU4bo7nnk8ikgkbpvzP2i6V
         9qazB4JWBgg+QNfw9RSxdx7Kw1vbAmiGQEMTnZwwG4DIlMo/iUmgoHWQTZ7RZSTDr7E+
         VkGg==
X-Forwarded-Encrypted: i=1; AJvYcCU1kWRiw6XZ1bTezTqYlFBVhP4uFTL5eXagE3cXx2y7JNyc6xSD7DlwzNPS9jWwS0Ryt0sHM5bTSvOYNzvY6j/Ia9CI
X-Gm-Message-State: AOJu0YzxewGv0ZepD4efaX4PJfKzrvfm8cGadfJ+KnJU15rO6sPDLiqC
	i/9PuZq7yrApLRXa0ClUWBiiLu8VngJMt5ptSjN/2LMgagYTRQBThfdnAJXkEh4=
X-Google-Smtp-Source: AGHT+IENwFUL6gGvF8NsJrp6IjTGtprRrcWGAHOVPTXNGiZR+sAGlaO04Vzp8JyDfJscMqYK9m6FTA==
X-Received: by 2002:a05:6a00:39a0:b0:6f3:8aa5:829f with SMTP id d2e1a72fcca58-6f4e03298c9mr15330231b3a.33.1715665842693;
        Mon, 13 May 2024 22:50:42 -0700 (PDT)
Received: from localhost.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2b2de1csm8689246b3a.204.2024.05.13.22.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 22:50:42 -0700 (PDT)
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
Subject: [kvmtool PATCH 0/3] Add RISC-V ISA extensions based on Linux-6.9
Date: Tue, 14 May 2024 11:19:25 +0530
Message-Id: <20240514054928.854419-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for new ISA extensions based on Linux-6.9 namely:
Ztso and Zacas.

These patches can also be found in the riscv_more_exts_round2_v1 branch
at: https://github.com/avpatel/kvmtool.git

Anup Patel (3):
  Sync-up headers with Linux-6.9 kernel
  riscv: Add Ztso extensiona support
  riscv: Add Zacas extensiona support

 arm/aarch64/include/asm/kvm.h         |  15 +-
 arm/aarch64/include/asm/sve_context.h |  11 +
 include/linux/kvm.h                   | 689 +-------------------------
 include/linux/virtio_pci.h            |  10 +-
 mips/include/asm/kvm.h                |   2 -
 powerpc/include/asm/kvm.h             |  45 +-
 riscv/fdt.c                           |   2 +
 riscv/include/asm/kvm.h               |   3 +-
 riscv/include/kvm/kvm-config-arch.h   |   6 +
 x86/include/asm/kvm.h                 | 308 +++++++++++-
 10 files changed, 384 insertions(+), 707 deletions(-)

-- 
2.34.1


