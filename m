Return-Path: <kvm+bounces-58320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A73EB8D0D1
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 22:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4751C6214A1
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 20:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15392D5C78;
	Sat, 20 Sep 2025 20:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="o61Gmnya"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C792D46B5
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 20:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758400735; cv=none; b=RQUgLlaL5mrbDHqxfW7f0NglbE6oDWJIqO4qGC0kYhfRNy1pQ+pfF1cjeThwAqlLwgtJZyDWOvfJqdUEXYR3FXkEPhJ5+LaCRqH/htXjl/onzciFRrXFJE/hrd/fRMJwM874KZHspFLXDPxEm5QNq4T0qyXCPEk4erwdcntRi7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758400735; c=relaxed/simple;
	bh=2Sx9zLC5MnnSHjXWv4RQRnUE5L1eBh4YFr1Q8/QsiLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M3YeX854U7EPV20l4jn3ivh8yjF+6ODWaSWEsP+ynmHhlj/PHHttDXtluszg1YVu1/oIB4FdBdsgaZECKjNwxzYPn5nAGYpqcQ+42KvrQ0kJS9p/AizEHBHdzbKtmD4Zw36zbclQrEIfgHrAUa4Hs5VNvArwnxHb/tiCEoaJlpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=o61Gmnya; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-4247d991161so13735015ab.3
        for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 13:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758400733; x=1759005533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QhhBAyqrQkktxGVEvf+eNDaA1KtGAPXA3DGbaEzOigo=;
        b=o61GmnyazyiUHgeI8rP/7N9HHWL8GJBtmanOKnLkms2fKtg0p8PxY9YSj18Yb+GSsV
         x01QXE90xMQn8i5mIUHvbFaqZs0roPh8O7RJuT0o0k5yuhHYUbj4ldK650/MKX3cHtvD
         /ExLwC9/imjkl66zD743yjvauBwCbeolN7Xa9URr6I6hk77NnRqaF3dx/asPAGCe0oq7
         7uMtYGNpKby4D3PT/0slHAh6B7bUqGrT06guX4EV0VWkE1wVW+PX4r64DaVRmfNT2GCH
         UxtTCvH94/Uu2EXyu4iZ6VHuWYGVmvIOtC60MJPjoWkwONsQ8mhw2HW+0Hq+2l10sS2V
         v9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758400733; x=1759005533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QhhBAyqrQkktxGVEvf+eNDaA1KtGAPXA3DGbaEzOigo=;
        b=oSmBxz5R4ahhK6j8zVcyLiLouHK4hpxgkuO8saKK0p70/liER3GsQqwifM9PpXICiQ
         Lpjo1Mew3C0uvHn8Sy78R0OAxZnkOi0VuyOVnRxpD8xVr/DV4LS4pBZ8cXyGXj0xqVJV
         xaQtUfxdCibL+LCxPMt/dvAQgVYSbcL++Q+JGEoktXZ+zuY+xDZPH4BuxIr2W/x7DhqE
         p3nyELhhApisvsO30VJmlGsEXoO2+dVNB0PPUIV/YfBoxEtBzTot9Q/Teah61TVWrAya
         7vbp+mIY7mXxWmhzpcOUDM9G2hKxej0vqFWiwFMj4wzEZSvC78H2ICug9SL8loKG849l
         sJmw==
X-Forwarded-Encrypted: i=1; AJvYcCWFBSLjq4bUNyI1gKJTmGj3OVAxr2ehHZWOdI7ZIvXS2jLKPgst2GZksSoI5ogphQlIkhI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSMF5q181VeYbWhu/9CPHzQL6oBqjfpeMBHFb15qrv7ms33beL
	WHCCL8d9sHHTJv2zLLeOBkgl+FouxRXJCyuP2qmomZ7M+RXkSsbu2kCtxoTOpB6NCfQ=
X-Gm-Gg: ASbGncsrNZ3eNJ5R3NALgmRFKl2HUiUCwY61NiboUG8ZsQmYjpc42PnMpOkfOu2znZ6
	YCUbC2S1Zhx7wvIian6VxHWJcaF2D1FA/KSxM9ldzfTyzML501tWotawLKqqswwXdKf36zxagS+
	Og9A3hac7oKxn1iEYH4OUYm3mavhqNxOuNkS6Ppk7Z688khORSDgYbOvFUiHU3Jc9Q6U6U7n693
	5/N0hxlKtE3e34vQzUyEn+tmJn+qGBPXONAjlG27fJjPCJAYlfu0S4llX2nffjAjBOxTvbHq+O5
	eyOLsmkX5i2keUkSDK/oXs6nb+RqoSxUr0XGI6kHtT9QCxUoQYHMqyEXpAQQUE8W33dTdMXul8u
	yht3u4TjkWFzRqb2zNOSpKA/2
X-Google-Smtp-Source: AGHT+IGwK4PrAd7CyoBUGRZ3PUQqWIF5Zj/5N9zpz7O49heeJaggKCpHt+afTDzWqXDEvIoleQehPQ==
X-Received: by 2002:a05:6e02:12e9:b0:424:bec:4a01 with SMTP id e9e14a558f8ab-424819743bbmr104189845ab.16.1758400733061;
        Sat, 20 Sep 2025 13:38:53 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4244afa9fbfsm39814525ab.26.2025.09.20.13.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 13:38:52 -0700 (PDT)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: jgg@nvidia.com,
	zong.li@sifive.com,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	alex@ghiti.fr
Subject: [RFC PATCH v2 00/18] iommu/riscv: Add irqbypass support
Date: Sat, 20 Sep 2025 15:38:50 -0500
Message-ID: <20250920203851.2205115-20-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changelog
---------
This is v2 of the RFC for adding interrupt remapping support to the
RISC-V IOMMU driver along with support for KVM in order to apply it
to irqbypass. v1 of the series was discussed here[1] where a couple
large design flaws were pointed out. Those, along with a v1 TODO of
referencing counting MSI PTEs in order to track when they may be
unmapped, have been addressed in v2. Additionally, v2 is based on
msi-lib, which didn't exist at the time of the v1 posting, and on
the recent KVM irqbypass rework.

Description
-----------
Platforms with MSI support (IMSICs) and implementations of the RISC-V
IOMMU with an MSI table can control device MSI delivery, including
directly delivering MSIs of devices assigned to guests to VCPUs. This
series enables that control and enables IOMMU_DMA in order to use
paging IOMMU domains by default. When the IOMMU doesn't support an MSI
table (it's an optional IOMMU capability) then paging domains are still
used, but the system does not have isolated MSIs. For direct delivery
to VCPUs an MSI table is required and thanks to KVM+VFIO it's possible
to determine when and how to map guest IMSIC addresses to host guest
interrupt files. The RISC-V IOMMU and AIA also support MRIFs (memory-
resident interrupt files), but support for those will be posted as a
follow-on to this series. Also, additional work will be done in order
to take advantage of the RISC-V IOMMU's second stage of paging. At
this time, the series just uses the first stage which allows testing
with unmodified KVM userspace and VFIO.

The patches are organized as follows:
  1-4:  Create an irq domain and some function stubs for an initial
        interrupt remapping support skeleton
  5-9:  Add MSI table management to enable host interrupt remapping
        and enable IOMMU_DMA
 10-13: Add IOMMU driver support for directly delivering MSIs to VCPUs
 14-17: Add KVM support for directly delivering MSIs to VCPUs

The last patch is a workaround for a KVM bug not introduced by this series
which is needed to enable testing of the series -- I still need to debug
and fix that properly.

There series is also available here[2].

Based on commit 39879e3a4106.

[1] https://lore.kernel.org/all/20241114161845.502027-17-ajones@ventanamicro.com/
[2] https://github.com/jones-drew/linux/commits/riscv/iommu-irqbypass-rfc-v2/


Andrew Jones (13):
  genirq/msi: Provide DOMAIN_BUS_MSI_REMAP
  iommu/riscv: Move struct riscv_iommu_domain and info to iommu.h
  iommu/riscv: Add IRQ domain for interrupt remapping
  iommu/riscv: Prepare to use MSI table
  iommu/riscv: Implement MSI table management functions
  iommu/riscv: Export phys_to_ppn and ppn_to_phys
  iommu/riscv: Use MSI table to enable IMSIC access
  RISC-V: Define irqbypass vcpu_info
  iommu/riscv: Maintain each irq msitbl index with chip data
  iommu/riscv: Add guest file irqbypass support
  RISC-V: KVM: Add guest file irqbypass support
  RISC-V: defconfig: Add VFIO modules
  DO NOT UPSTREAM: RISC-V: KVM: Workaround kvm_riscv_gstage_ioremap()
    bug

Tomasz Jeznach (4):
  iommu/dma: enable IOMMU_DMA for RISC-V
  iommu/riscv: report iommu capabilities
  RISC-V: KVM: Enable KVM_VFIO interfaces on RISC-V arch
  vfio: enable IOMMU_TYPE1 for RISC-V

Zong Li (1):
  iommu/riscv: Use data structure instead of individual values

 arch/riscv/configs/defconfig     |   2 +
 arch/riscv/include/asm/irq.h     |   9 +
 arch/riscv/kvm/Kconfig           |   3 +
 arch/riscv/kvm/aia_imsic.c       | 143 ++++++-
 arch/riscv/kvm/mmu.c             |   2 +-
 arch/riscv/kvm/vm.c              |  31 ++
 drivers/iommu/Kconfig            |   2 +-
 drivers/iommu/riscv/Makefile     |   2 +-
 drivers/iommu/riscv/iommu-bits.h |  11 +
 drivers/iommu/riscv/iommu-ir.c   | 698 +++++++++++++++++++++++++++++++
 drivers/iommu/riscv/iommu.c      | 158 +++----
 drivers/iommu/riscv/iommu.h      |  75 ++++
 drivers/irqchip/irq-msi-lib.c    |   8 +-
 drivers/vfio/Kconfig             |   2 +-
 include/linux/irqdomain_defs.h   |   1 +
 15 files changed, 1063 insertions(+), 84 deletions(-)
 create mode 100644 drivers/iommu/riscv/iommu-ir.c

-- 
2.49.0


