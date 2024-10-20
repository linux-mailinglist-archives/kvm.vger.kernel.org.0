Return-Path: <kvm+bounces-29210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7DC9A566F
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 21:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2792B226AD
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 19:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FC3196450;
	Sun, 20 Oct 2024 19:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="hy6cGHu9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B5F11C83
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 19:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729453666; cv=none; b=Vh1HKIMydR/KNRiHwGSBmJ2aOc4X2V9CstFu9VHOLNBl/KEiWDQOvrRA/FLxsUs5UkbDqgib/KRRXziFaBtnz2UW5XrR9wMiftMmyC6eAGYdD5Rx61agh3ZHP2AjuFw0I3oRTdYZ0We/gN2M/BRsZM79tnXf98iSNr9mklSk81k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729453666; c=relaxed/simple;
	bh=2vXGW0g/tW2P+bx5yRe+z+osOaGlXSw3nlcoDTM8LQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hQgHuyghCVfjt8mkN9QbuFtHpzzB4o02uyd1bkpt/2OJnZRHrFUUXx3sR/rjz4s41vyFT2CealkIkb9h6ZvAFPUMHxUTx+q0xGfvJKU7MT18h0sf+inykOULSiPsvH3K6EiD5wPJu8wmNnmWKevKq6a59KEQmu093NrKDPGVbVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=hy6cGHu9; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e2ad9825a7so2492852a91.0
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 12:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1729453664; x=1730058464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+ivURfBSvioRGHQ9UQ83vIOIrYF8b7wh/zY/rzLMXhM=;
        b=hy6cGHu9SyVjIFVS5XNJb02SMYVfD6C9SmUwqKwSZCElU496Kol5eCdCv/yvy+2ZZ4
         H2kRbRYIuFtq0mHLhWRBD5x2nKDdvhw9VyPVaCJ/T4kcGY8U6WdGkvGfJ9i+7RuROt6n
         ZYA3UXy3LVGiMbvRV/QdwxyMKvM5aipmm70dTOf9LMYI+74Tgm2n8QzXXd72SCouv+eC
         HHYSJE50tV4MfpjHKi/XSaJRrJWy3c0Tt5ZbAri4ImqWjIV9YIQvT83VO/b0XV1BusiX
         W88sQx7N+GOe9Uu4uMqV5AZB486CNe15oppwjNnF2+fKQHFM2gVL+kfzdieh6XBGhnk7
         2qtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729453664; x=1730058464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ivURfBSvioRGHQ9UQ83vIOIrYF8b7wh/zY/rzLMXhM=;
        b=PDTn0Q7y4iv+OQ0o8OmvXpUHIkpDJSakmlyPsxG/APCUoHuWx6zt7hFWKYBc9PzSyu
         MyxtA4K8dfuoCf8aMYqMi0+XAEZcVZEsxBrQZKW0ZGVkXV3uKBYgs+5G11ujKbylWYrH
         lhDd9I9/81A1dYsN8tBYj+JUiYZufixn3LfrG4S4iV1MulHdvmP+JGEmr5Qxc2NwCW/I
         ht3YpVQrLvmGk4eqv3DvePPbhvk+nWA/1lBc33m5R5QSQt0QEh/t6ZSj2ib7cztcH/Dq
         xO6pQMjr0jcFISy5d49smNt+F091veSBTMxudRfG23ewcWJmCy8OsJvbxI16kGsycxpe
         s0gw==
X-Forwarded-Encrypted: i=1; AJvYcCVy9kdSOdMQeUpKvTuq0JU6E3NpE+VFDK/gsojepShLFSSiKA+nX5vqy1MjgHmQHyTqLqI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+YknC4jqbuBDccyzHIhknIWQ/3tCW4dD33sSDqRy62KZYiyij
	FYPOmg0YgVN8HnGaKxP/H5u50tC10YgemSkNEIVyGJB09j8rKcFrBrFSILPrBm0uD5M7TPU7fAz
	w0nbzxg==
X-Google-Smtp-Source: AGHT+IHG9XXvm9AJ2oRMr/j3vJjm8TDJeXCKSU0fNmuN70GfoPp1Bf8M19KyxCwvXuMkl6hkr0LMHg==
X-Received: by 2002:a17:90b:4c8b:b0:2c9:9658:d704 with SMTP id 98e67ed59e1d1-2e5617331b4mr9148581a91.40.1729453664025;
        Sun, 20 Oct 2024 12:47:44 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([50.238.223.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad365d4dsm1933188a91.14.2024.10.20.12.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:47:43 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 00/13] Accelerate KVM RISC-V when running as a guest
Date: Mon, 21 Oct 2024 01:17:21 +0530
Message-ID: <20241020194734.58686-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM RISC-V hypervisor might be running as a guest under some other
host hypervisor in which case the complete H-extension functionality will
be trap-n-emulated by the host hypervisor. In this case, the KVM RISC-V
performance can be accelerated using the SBI nested acceleration (NACL)
extension if the host hypervisor provides it.

These series extends KVM RISC-V to use SBI NACL extension whenever
underlying SBI implementation (aka host hypervisor) provides it.

These patches can also be found in the riscv_sbi_nested_v2 branch at:
https://github.com/avpatel/linux.git

To test these patches, run KVM RISC-V as Guest under latest Xvisor
found at: https://github.com/xvisor/xvisor.git

For the steps to test on Xvisor, refer the Xvisor documentation
<xvisor_source>/docs/riscv/riscv64-qemu.txt with two small changes:

1) In step#11, make sure compressed kvm.ko, guest kernel image, and
   kvmtool are present in the rootfs.img
2) In step#14, make sure AIA is available to Xvisor by using
   "virt,aia=aplic-imsic" as the QEMU machine name.

Changes since v1:
 - Dropped nacl_shmem_fast() macro from PATCH8
 - Added comments in PATCH8 about which back-to-back ncsr_xyz()
   macros are sub-optimal
 - Moved nacl_scratch_xyz() macros to PATCH8

Anup Patel (13):
  RISC-V: KVM: Order the object files alphabetically
  RISC-V: KVM: Save/restore HSTATUS in C source
  RISC-V: KVM: Save/restore SCOUNTEREN in C source
  RISC-V: KVM: Break down the __kvm_riscv_switch_to() into macros
  RISC-V: KVM: Replace aia_set_hvictl() with aia_hvictl_value()
  RISC-V: KVM: Don't setup SGEI for zero guest external interrupts
  RISC-V: Add defines for the SBI nested acceleration extension
  RISC-V: KVM: Add common nested acceleration support
  RISC-V: KVM: Use nacl_csr_xyz() for accessing H-extension CSRs
  RISC-V: KVM: Use nacl_csr_xyz() for accessing AIA CSRs
  RISC-V: KVM: Use SBI sync SRET call when available
  RISC-V: KVM: Save trap CSRs in kvm_riscv_vcpu_enter_exit()
  RISC-V: KVM: Use NACL HFENCEs for KVM request based HFENCEs

 arch/riscv/include/asm/kvm_nacl.h | 245 ++++++++++++++++++++++++++++++
 arch/riscv/include/asm/sbi.h      | 120 +++++++++++++++
 arch/riscv/kvm/Makefile           |  27 ++--
 arch/riscv/kvm/aia.c              | 114 +++++++++-----
 arch/riscv/kvm/main.c             |  51 ++++++-
 arch/riscv/kvm/mmu.c              |   4 +-
 arch/riscv/kvm/nacl.c             | 152 ++++++++++++++++++
 arch/riscv/kvm/tlb.c              |  57 ++++---
 arch/riscv/kvm/vcpu.c             | 184 ++++++++++++++++------
 arch/riscv/kvm/vcpu_switch.S      | 137 +++++++++++------
 arch/riscv/kvm/vcpu_timer.c       |  28 ++--
 11 files changed, 941 insertions(+), 178 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_nacl.h
 create mode 100644 arch/riscv/kvm/nacl.c

-- 
2.43.0


