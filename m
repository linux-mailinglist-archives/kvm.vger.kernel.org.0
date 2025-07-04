Return-Path: <kvm+bounces-51605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACBBDAF970E
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 394111882555
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 15:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A21F92D46A7;
	Fri,  4 Jul 2025 15:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="R4y/NarH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE2A16A956
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751643531; cv=none; b=hu/Ct2PsczEI+/IOxnz1//WYF+Q6oGsWKVcbGDFx3l+zv2oxS8iotFJjeK7mzAT7U5N6cpZqCyUMbRZl0AWLfD/W+07gvWk3ktXzTzhs2f6O6pSh5Y7Rrfa+5TduhCzKcrFPpzHDORynyRSkzmLaQYO0u2oIHsmGSdGOhnzi/Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751643531; c=relaxed/simple;
	bh=U+nb8Prm9jbvIa4V3r3B7Mc4wIjR+TJy9ILGIET1irc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BCXn/AEKfgs7Q2WWLP4yixJpKvbQcOu1Zw696LADwPoNw7lCITHrUmX84AI+E60XCylK1wocNniPHlywEojFDWoRTfBu+ejfjFlrlhi+zoyvmEGl6dL9GlZHbCC0aoAk9isYhI7OfGJ6mIEkRQwxaUvBdyMHrVueLt5Lna/9KF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=R4y/NarH; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2352400344aso10699645ad.2
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 08:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751643529; x=1752248329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CcyVISN67taC6h/BgRmPM88r/wN68xhaL4uppVs0AxI=;
        b=R4y/NarHmfq04wjTJNIztowTtO2zOTbTbtz/xHIqvePZ3jqjgA8qTDB9wjBvFe8VVc
         mMqbCPFnDlp7hoqhZHSF1MDawJQQstiQRAqTvteNXwepvYMGO5rmS7WKP3F3Dkj7kUhm
         CKdc8chMH1GnQkDVCD+EjOtfsPbv2y4i7IkmgdFOcKm1OT9b27HcYcIt/8tzaBwbuXGw
         1Xkg7MP1mklFJmvfkZNRtouweijWwsA95Z0Lq4Tma23/zXSyRGOcLX9if3bBx5PWVe8x
         Y4Ulzz1JjBe2lfEdaGrem65Hlfk3OPWnAWIZ5IY/ouK+Dwlh7YXBzk6gnkxVA8H/aDDl
         4gBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751643529; x=1752248329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CcyVISN67taC6h/BgRmPM88r/wN68xhaL4uppVs0AxI=;
        b=ircLXgwpjusit7Dpn6fVeK0leQUaGx5mgWnGrpV8asPOokCNZl77RbOrOTbGihFx5K
         CZ7ve8/tw/z1ivrFNA/tu+VEkagHTt3SLi1bsJ7FnZsz7pxz9nRyc3bTssFPAscN43JP
         eMzhagoQh3BBb0jgDb77q6jQPptdAFDhfApOW1T0yvl9YKCYwwD19Ta/leWSKksTPElJ
         DZQJYCe8oOJ8n/mLuQ5iZFFXx8lXB/y/7H8gltI5a/++d5sxDtVEY7Zgcl2oQRgngISo
         Ptp1gPg0SeOj7QHvjp1vNvcUSx3ceVdzwb+OPhCzDuTN+bDYZn24R41AioQri1F0YKik
         YNww==
X-Forwarded-Encrypted: i=1; AJvYcCWm/fboOJKAqa5icmKmi0bWgD+SNmWfstmo2OXEJiixTAsIvSigp+rWFBnb8SeYggfjxPM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUIiXfgP7WklUie4mnNyhKoHkcdPLoBleue+th8KkyL4sNOgx0
	1sZ9mo111N3/mMFcQbr0qIexQnzzYUssZtAvYP5s9GmnnYPne0zoXz4+1czFOPH/kNA=
X-Gm-Gg: ASbGnctEOCxtJvwDEfqnDf6CiOn57u5HQA8WlMahfLJTidr5GqTJptcDtCxmG0yU6Vp
	OTBidPOaPHKPAqHuvYhzJVhxx0snfs9SDh9iWJVElUIsy2T+7MH5H1cmFbBKUj6Lug2G9ainF8d
	mX95BaNE/cDMID7UYFo++bZAtxqfVmj2S1dx6bCjE2hbjUieUiyqQCrImELQIKLCChPd+TCPi2H
	3ISsdzIEtGToFA/XPqDmPHbnDBBGXRXGdb1DXlXSZ8EPfRnCUwAj2Irq8l9jxRhmVgU9ZOtuF+e
	a9Kwyvgg8y4pc8cWlMlMobUxDg6f1h0hx9jworKiyiLpW3CJf1bYsQpHFHny8crO4Q6Ay9Iswbj
	jhzW5P4nx6AFgHgnDh/uXh5OmRA0Dnw==
X-Google-Smtp-Source: AGHT+IHCoNM/FN2r7kAw4r3sBqbkqR7ZPm3zgW5FYxH7kU0oFHIRlx/vujAnKCk/T1gpdC5+o539qA==
X-Received: by 2002:a17:902:ebc6:b0:231:e331:b7df with SMTP id d9443c01a7336-23c8624cbeemr60131625ad.29.1751643529473;
        Fri, 04 Jul 2025 08:38:49 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee63003bsm2084818a12.62.2025.07.04.08.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 08:38:49 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 0/2] Few timer and AIA fixes for KVM RISC-V
Date: Fri,  4 Jul 2025 21:08:36 +0530
Message-ID: <20250704153838.6575-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RISC-V Privileged specificaiton says the following: "WFI is also
required to resume execution for locally enabled interrupts pending
at any privilege level, regardless of the global interrupt enable at
each privilege level."

Based on the above, if there is pending VS-timer interrupt when the
host (aka HS-mode) executes WFI then such a WFI will simply become NOP
and not do anything. This result in QEMU RISC-V consuming a lot of CPU
time on the x86 machine where it is running. The PATCH1 solves this
issue by adding appropriate cleanup in KVM RISC-V timer virtualization.

As a result PATCH1, race conditions in updating HGEI[E|P] CSRs when a
VCPU is moved from one host CPU to another are being observed on QEMU
so the PATCH2 tries to minimize the chances of these race conditions.

Anup Patel (2):
  RISC-V: KVM: Disable vstimecmp before exiting to user-space
  RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization

 arch/riscv/include/asm/kvm_aia.h |  4 ++-
 arch/riscv/kvm/aia.c             | 51 +++++---------------------------
 arch/riscv/kvm/aia_imsic.c       | 45 ++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c            |  2 --
 arch/riscv/kvm/vcpu_timer.c      | 16 ++++++++++
 5 files changed, 71 insertions(+), 47 deletions(-)

-- 
2.43.0


