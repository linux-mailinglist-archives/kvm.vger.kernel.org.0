Return-Path: <kvm+bounces-21939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D55937A65
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75CFBB211F3
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5024A145FEA;
	Fri, 19 Jul 2024 16:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="UABdf/i3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131461448E0
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405367; cv=none; b=PPg2PCkARXqy27Obz6+j8ze4XOo6jliZo5pg0pswBsN+UuTyw56gUuE8NiR6tkcsQpdChEVT1vsgOqfQR2WYO3EH189A6UFuyzL/MZS4ZXvj/A04TBIoqjEatoL3Zs8sOC5wdGQjM8vvBGq8We5ShZno2DvafPz/z8WyE64rxWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405367; c=relaxed/simple;
	bh=hQ3ruD4qAjQfF2Nf3WejfEE5T7kt5QJVJnhVKCdchec=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aCDRBOChBSP2FvGiNiso5mjtvApdXGSYOr3QZf2WICxLtfSSduJ81igiKF4GR54FyGj+TUCdCWZPL9wnFgu9QiifuGTiUUh3me/rxabRXz16CC4+H7zqCpnjtQgWMJtDjTsGopCeSA8t+x1zikDrJZW55r+2hz7jit3UzjN/2fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=UABdf/i3; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fd65aaac27so4898545ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405365; x=1722010165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xYWKSzPxNF1FBMt6vsXOOAcJiLP6695b+s20Dc1fH5Y=;
        b=UABdf/i3seo97NspoBzODW1tZ5pWY5H96F8qY7sqPwqVD99eNJhbNCt9rdk/8jXkFl
         oJeg192b1jmRmm7SrOj9MvELLhoQK1QWXQnNl7eO4yy5LJwCzMUF+jjaMQs5DFaDrw5X
         CnKcJK6U+uMeC5Nc46QYJRm2nCWAc48+SaPkI/8VbxVDjkUIE+so2jZP1gJT5a7XtpuP
         /AgVJKAGAwYicd9bX+sCYOJabYWMsiLAe9G32hpysxfvik8xVj9DaGfFdEO6uXZmFmlH
         5oB8AbxxCKAGU2C0QS+i+0f7DMHhLMgDe0ZDfpzeQz1HFJm5bWYRnza7zUZSJx3U/pjk
         4c1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405365; x=1722010165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xYWKSzPxNF1FBMt6vsXOOAcJiLP6695b+s20Dc1fH5Y=;
        b=uWf4dlee8GkFJJNTSVU4sqAlermnWsYePhjt25AyzAI4BQAoXpAtlDBLguODro1sU3
         9pt5tUrJ9ZSgJesf+EPY8Lht/v7nGozwDi3E7Xmq96eKLnvyJf4GmX9YrjN4mUtxeibO
         IJArBVYsvENXgXCUDFFZ4WeFGJqMygIFbkPjhW41aF2uyvfZzm0prKS9fKA/JfKR3rRV
         7j6vpg+LWHWOV/X8EUulFUxuHj7J3d/TruECMuyCI1InfDvw8dBipgQWn0kKahK4on/V
         eVKVp/w//OWfnG6Kk3odUJHL0Wk33+qG2S2ajqXDX2/6ww93gOjANvUnhUqvMXYQMux5
         B6UA==
X-Forwarded-Encrypted: i=1; AJvYcCX7FNMnFgoySADXO4KC5iDeptxW1xAClfTTOTuGmixIuPPGJgdWviG8oii2PnK5LNvvgDYtJldZmVyF8TYVmisL6/aE
X-Gm-Message-State: AOJu0YxbTKvPJt4Lp429dJ8sf0/dKw3VAU6AEW+9ArWBceGwKDDsBpfI
	wCJYK7fejbtjLcshYbuadE+i0PzYgFNdtPXLzDQuutpPDFQ6YAL6KXCqsHMVKdU=
X-Google-Smtp-Source: AGHT+IEDU6P9hJ2nz3TyZ6kiWvc/ZyeAut4s//9AkbdAxAzckMrzsXplgQo8noxdWpSASQCmveYruw==
X-Received: by 2002:a17:903:98d:b0:1fc:58b7:ae66 with SMTP id d9443c01a7336-1fd74d366dcmr1596895ad.17.1721405364733;
        Fri, 19 Jul 2024 09:09:24 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:09:24 -0700 (PDT)
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
Subject: [PATCH 00/13] Accelerate KVM RISC-V when running as a guest
Date: Fri, 19 Jul 2024 21:39:00 +0530
Message-Id: <20240719160913.342027-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
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

These patches can also be found in the riscv_sbi_nested_v1 branch at:
https://github.com/avpatel/linux.git

To test these patches, run KVM RISC-V as Guest under latest Xvisor
found at: https://github.com/xvisor/xvisor.git

For the steps to test on Xvisor, refer the Xvisor documentation
<xvisor_source>/docs/riscv/riscv64-qemu.txt with two small changes:

1) In step#11, make sure compressed kvm.ko, guest kernel image, and
   kvmtool are present in the rootfs.img
2) In step#14, make sure AIA is available to Xvisor by using
   "virt,aia=aplic-imsic" as the QEMU machine name.

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

 arch/riscv/include/asm/kvm_nacl.h | 237 ++++++++++++++++++++++++++++++
 arch/riscv/include/asm/sbi.h      | 120 +++++++++++++++
 arch/riscv/kvm/Makefile           |  27 ++--
 arch/riscv/kvm/aia.c              | 114 +++++++++-----
 arch/riscv/kvm/main.c             |  53 ++++++-
 arch/riscv/kvm/mmu.c              |   4 +-
 arch/riscv/kvm/nacl.c             | 152 +++++++++++++++++++
 arch/riscv/kvm/tlb.c              |  57 ++++---
 arch/riscv/kvm/vcpu.c             | 184 +++++++++++++++++------
 arch/riscv/kvm/vcpu_switch.S      | 137 ++++++++++-------
 arch/riscv/kvm/vcpu_timer.c       |  28 ++--
 11 files changed, 935 insertions(+), 178 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_nacl.h
 create mode 100644 arch/riscv/kvm/nacl.c

-- 
2.34.1


