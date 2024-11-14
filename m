Return-Path: <kvm+bounces-31857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 311199C908F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 18:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57038B37B4B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC3F187347;
	Thu, 14 Nov 2024 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cNKTYuXK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD5C14F104
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601132; cv=none; b=cqlry0iX8aldRcdGxzeLvVOKriVCW6CHJ3T05iprLPD1a/hM1Ap+2Ya5sKpwhvVF+1JmII6bFlJyExqqHJPc4HeB3V7xWr3E6GCZ779B7MDR/yOiwUo2c2y9/OuBcE/Y7U9Ur/y6yPATiFWvWpSntSnxjNp7+iFgQ0Ll6gg/fM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601132; c=relaxed/simple;
	bh=lyZC4By9Ar4lY6HLPHxQpNiCLgIv0jeWjlSxPE9suGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TQJqdcfYYaGqGx7S8LU06as1MejlEC+5kf5TgVT/5BAva+b27gQz+LElDzaDv/Tym4HEZ/dndURVlb89NjcMTSHRprjau8RF0v9V0BKE2Th+YCfskWCa2niIuBZX7+GtGqap6znfeii7W1JTTWonLmShGi2fb22P9HKdjp21nSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cNKTYuXK; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4314b316495so7192015e9.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601127; x=1732205927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c7BJqdeVq7UVKuF/HMX90zKjA2XSvBJJooO0qYOgVYo=;
        b=cNKTYuXKtXFcjOBPRnJIe5JEdaB8nMTdu2gcZu4Z89SKXsd3VhtZobgrFLZ649oWsK
         d6zo/GDvvxvpnkgsyBcraFTMogz3K9QctpIzhElYC9G2Ln+IdCvwCfDQfS4A7r53BO6s
         32zL54xRan91QAkTppZjOLyk1os5NSG1ISqykLjnHy/DrYlnckf2icQQQw/gE3ntfJZ+
         W4FcHVMzo8PXw4PwoKzgrLuPeVgbO/UANpi4naPB49BJHE09s99hUw5dF/ZLRWdZz7i7
         Jx8zEh5SP/qkN7h4U0/7X/LOLmC7yryzJTRmBVq3PYuIPLSxIJWVoTE1SrFQHLOaXEmS
         zhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601127; x=1732205927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c7BJqdeVq7UVKuF/HMX90zKjA2XSvBJJooO0qYOgVYo=;
        b=obKLDCSQMzKm6q5QPDRCIrUVzXztfjc3Wrq8s7AyWi9xMN/PScbtt3/F9iVBTo64rB
         FjNX2aeo4GqLlcsdg3sbYlYBQsK3stbCnxsodHIzZnVAqvWxMNRYstnJi1Od+Ds2beHq
         IpPn/Evq2xYHtkV0DegicIROrgiZ7zKnhux9q9ib+nUS6CSXGO2OvY3bUdwf9mlIKGxx
         yy2rFLr0H09VtsyMBbgKFgiR4z3hhLc9H3NfALw9RnNSfiv8CT4hVaQFBtdaVPvx5EMl
         ZfWaBhgJuGtJo6iZ7O8OOINHjl6gnYa+qWpMRAjGIWMBijJfnL+6+7YgipgoB1cusCHf
         qFLA==
X-Forwarded-Encrypted: i=1; AJvYcCX42UUASyHgEi7gfs5/sq5joyo2XK4r2yhtdG76nIRAT98bHklUnFwGym6ZBNEpg1CjPVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAgIgocSF4rcnRanFoUjLn+bc4yDMmVrXLNhhrhju0JiHWIcal
	4IRU1nvpbTx3iJxBJwd/SsWqC4yW1xrDFd9731RY0b/6M3W7pRPDYs1tobLfPQI=
X-Google-Smtp-Source: AGHT+IGmsJWy6Z+mGpYkwKc89nKAhzRkstEPPTX+iWcGxi/SAriHdno919nTAwdEP/fS42LcKsW+QA==
X-Received: by 2002:a05:600c:1d88:b0:431:5a27:839c with SMTP id 5b1f17b1804b1-432d4a98364mr70171705e9.5.1731601126807;
        Thu, 14 Nov 2024 08:18:46 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da265f28sm28998355e9.17.2024.11.14.08.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:18:46 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com,
	zong.li@sifive.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 00/15] iommu/riscv: Add irqbypass support
Date: Thu, 14 Nov 2024 17:18:45 +0100
Message-ID: <20241114161845.502027-17-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Platforms with implementations of the RISC-V IOMMU and AIA support
directly delivering MSIs of devices assigned to guests to the VCPUs.
VFIO and KVM have a framework to enable such support, which is called
irqbypass. This series enables irqbypass for devices assigned to KVM
guests when all VCPUs are allocated guest interrupt files. The RISC-V
IOMMU and AIA also support MRIFs (memory-resident interrupt files),
but support for those will be posted as a follow-on to this series.

The patches are organized as follows:
  1-3:  Prepare to create an MSI remapping irqdomain parented by the IMSIC
  4-6:  Prepare the IOMMU driver for VFIO domains which will use a single
        stage of translation, but G-stage instead of the first stage
  7-8:  Add support to the IOMMU driver for creating irqdomains
  9-10: Prepare KVM to enable irqbypass
 11-13: Add irqbypass support to the IOMMU driver and KVM
 14-15: Enable VFIO by default

This series is also available here [1] and may be tested with QEMU recent
enough to have the IOMMU model.

Based on linux-next commit 28955f4fa282 ("Add linux-next specific files for 20241112")

[1] https://github.com/jones-drew/linux/commits/riscv/iommu-irqbypass-rfc-v1/

Thanks,
drew


Andrew Jones (10):
  irqchip/riscv-imsic: Use hierarchy to reach irq_set_affinity
  genirq/msi: Provide DOMAIN_BUS_MSI_REMAP
  irqchip/riscv-imsic: Add support for DOMAIN_BUS_MSI_REMAP
  iommu/riscv: Move definitions to iommu.h
  iommu/riscv: Add IRQ domain for interrupt remapping
  RISC-V: KVM: Add irqbypass skeleton
  RISC-V: Define irqbypass vcpu_info
  iommu/riscv: Add guest file irqbypass support
  RISC-V: KVM: Add guest file irqbypass support
  RISC-V: defconfig: Add VFIO modules

Tomasz Jeznach (3):
  iommu/riscv: report iommu capabilities
  RISC-V: KVM: Enable KVM_VFIO interfaces on RISC-V arch
  vfio: enable IOMMU_TYPE1 for RISC-V

Zong Li (2):
  iommu/riscv: use data structure instead of individual values
  iommu/riscv: support GSCID and GVMA invalidation command

 arch/riscv/configs/defconfig               |   2 +
 arch/riscv/include/asm/irq.h               |   9 +
 arch/riscv/include/asm/kvm_host.h          |   3 +
 arch/riscv/kvm/Kconfig                     |   3 +
 arch/riscv/kvm/aia_imsic.c                 | 136 +++++++-
 arch/riscv/kvm/vm.c                        |  60 ++++
 drivers/iommu/riscv/Makefile               |   2 +-
 drivers/iommu/riscv/iommu-bits.h           |  11 +
 drivers/iommu/riscv/iommu-ir.c             | 360 +++++++++++++++++++++
 drivers/iommu/riscv/iommu.c                | 183 ++++++-----
 drivers/iommu/riscv/iommu.h                |  78 +++++
 drivers/irqchip/irq-riscv-imsic-platform.c |  18 +-
 drivers/vfio/Kconfig                       |   2 +-
 include/linux/irqdomain_defs.h             |   1 +
 14 files changed, 776 insertions(+), 92 deletions(-)
 create mode 100644 drivers/iommu/riscv/iommu-ir.c

-- 
2.47.0


