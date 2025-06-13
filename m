Return-Path: <kvm+bounces-49373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3E80AD836B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F7E217970A
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334A325B2E7;
	Fri, 13 Jun 2025 06:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="drF97ypt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1312580E2
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749797879; cv=none; b=iBV6fmPkmu8n06SnVJrXQ4wvq+tcLHLfd0lpWBAP/UMY0U6ZUc4eq2hkVl1yYY9Q2w6NqxQMlwzOS6mF3JrRgnol8y5fOUHPp6lWVdq6wZhtXcnKuw85XzgH+pCg0/9Q/dQ8G+hC+Svoh9rsZ8JZZ9LnGNRmobRp9P/0KeUmotY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749797879; c=relaxed/simple;
	bh=OzxxhvnXD4pJdWD/IczN9cmkZHmzL3IvfnlClBASSBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n5TNLYUTdKJTgYQIh5lRg12NyVFExseXKji5RUzk1894LjJUKMkzSMYYlvnhhfxA4AnLa7g+ENv3m70QWIvHdGf/OjzjKeiDBfl+nCwaWx5uJvPIPkjpNTU9DXvc/Ma92WcUjaeqRNYRtw3DTOb/axnCNeSJezfCMU3qjf9loTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=drF97ypt; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-313910f392dso1713377a91.2
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 23:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749797875; x=1750402675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fS5629Jr+WvAX+3s1UFysCJ0aoAPCHlpZZzgXeCc68k=;
        b=drF97yptGlc77hHH7NEOS/m0EQQv0OHTTxYcdwiAlDtTAETVOdJIlH3GDK2A6jyEqp
         VqitUlU3Fq0w9S8PmlxxbQfGHK23JKwSR5jpgO8IXgFLrrsYY28mhmsUmZ+E1/1NynG1
         MRucD25YJ4zjKcIv2hZQ7YvtD2qi6iUCPwFmH5fCB3bspq5xTs1cdrDAINCeHnGgqS4b
         v6TgQ4wrXruOJjOZLiRUP3Owbf6VFAeBZ9fwERTFBCpn1H2fSk9nkORjKyc/VeQhlcfa
         tc2Lqvu93eSn6iOjqQWJfJ1K+Z+3N/uX8g1DUORUE5YOlYtIw0Dn7GQu8UUw2lqJfZQX
         89Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749797875; x=1750402675;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fS5629Jr+WvAX+3s1UFysCJ0aoAPCHlpZZzgXeCc68k=;
        b=J3PcGUBw6mGjIq3+VkaxTdaVanjXeRjrkBLGugcwlVS0yM3Y7izHOsvFPL+jms3pGW
         oJpPKTV9AWBZbUkn570nK3TEMIiLhQ4EElMFxB/smJ5KcHOAzjofGDYf+0jhmR/STe50
         5ASdxNQQ2K7whfdlTPw2ll+ZPe2sYS0LPvflb2npeO+PpAkFbQiZ+CAzBNhLuwAujoB7
         L3vHtra5XaMukBuiy2WOqzO8jfOCBfvTKHw/CiRV1pl7VFuGTccogPIvNoTgG2axZd2K
         b72iLcA0T+7oUTaCKvA8AbwPdpPeFZYGl4JjxU5ObKTjAjzJUw19UjFP4DnNZEHWkr2o
         0ocw==
X-Forwarded-Encrypted: i=1; AJvYcCVSUb4abPit1bhpg0jO/J/vKgPbO7z8jQarACWzIaZb5qnGVIQZMWrw8pYqP191J6X4qTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmE8tLvTRbP2NU6MOhb7RC89y28WApx6ZKcX0oHOrLvs06hyne
	hOMXP1UZWF5d8gxEx1KKUYfqZmOZE0nHixBznYkYZkBy8tvH0NjoFqsLInd+Q+mJfA8=
X-Gm-Gg: ASbGncuMIAoE/HuH4vGtIbxpal8l1kehxHBTzNKjPUFhHidGUpi85I/h6rml9foIAe2
	I0TjSjozh2eUwA5TN2ATrqO6YibrqyDnkTmflDda/O2gvclMoWLVd9B0VvutNu5RUvHmq8kH12Q
	eQmTOceio3CFjW5Ty+1AD8d4sXMY+GDmAIt7PSk7eX/IdSgi/Ss84hb+BbYooqZjRXDUkZ2+E62
	7Nr6FJ4mb+LU2214idrxV39pnN1GJzZM1Zv7XzHgXTG3g8Hr8jRPLAFmYyTKdkZLEFRJUEu0zL1
	iBuSH2SXWmeAgsXyuqvokZf3iVo4SrjEFXzvDKTAmYpec8vKt+sTj13don8/qTw8ABhIG9QXd+/
	pRPgGH6iLX3lXzYEfroE=
X-Google-Smtp-Source: AGHT+IGbcwSxBXFORB1F4UP8rztiMzZ/iN/4l/08KXt3P8+HxU0t7mDVGHn5YSyDBavfM4IMvKl4yQ==
X-Received: by 2002:a17:90b:184e:b0:311:ea13:2e6d with SMTP id 98e67ed59e1d1-313d9ec5adamr2880839a91.29.1749797874839;
        Thu, 12 Jun 2025 23:57:54 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b49b7fsm2653022a91.24.2025.06.12.23.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 23:57:54 -0700 (PDT)
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
Subject: [PATCH v2 00/12] MMU related improvements for KVM RISC-V
Date: Fri, 13 Jun 2025 12:27:31 +0530
Message-ID: <20250613065743.737102-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series primarily has various MMU improvements for KVM RISC-V
and it also serves as a preparatory series for the upcoming nested
virtualization support.

PATCH1 to PATCH2: SBI spec related fixes in SBI RFENCE extension
PATCH3 to PATCH6: Few cosmetic improvements
PATCH7 to PATCH8: TLB maintenance related improvements
PATCH9 to PATCH13: MMU related preparatory work for nested virtualization

These patches can also be found in the riscv_kvm_mmu_imp_v2 branch
at: https://github.com/avpatel/linux.git

Changes since v1:
 - Rebased upon Linux-6.16-rc1
 - Dropped PATCH1 and PATCH2 of v1 series since these are queued
   as fixes for Linux-6.16
 - Addressed Atish's comment on PATCH1 in this series
 - Added new PATCH7 in this series

Anup Patel (12):
  RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
  RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
  RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
  RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with
    KVM_REQ_TLB_FLUSH
  RISC-V: KVM: Don't flush TLB when PTE is unchanged
  RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
  RISC-V: KVM: Use ncsr_xyz() in kvm_riscv_vcpu_trap_redirect()
  RISC-V: KVM: Factor-out MMU related declarations into separate headers
  RISC-V: KVM: Introduce struct kvm_gstage_mapping
  RISC-V: KVM: Add vmid field to struct kvm_riscv_hfence
  RISC-V: KVM: Factor-out g-stage page table management
  RISC-V: KVM: Pass VMID as parameter to kvm_riscv_hfence_xyz() APIs

 arch/riscv/include/asm/kvm_aia.h    |   2 +-
 arch/riscv/include/asm/kvm_gstage.h |  72 ++++
 arch/riscv/include/asm/kvm_host.h   | 103 +-----
 arch/riscv/include/asm/kvm_mmu.h    |  21 ++
 arch/riscv/include/asm/kvm_tlb.h    |  84 +++++
 arch/riscv/include/asm/kvm_vmid.h   |  27 ++
 arch/riscv/kvm/Makefile             |   1 +
 arch/riscv/kvm/aia_device.c         |   6 +-
 arch/riscv/kvm/aia_imsic.c          |  12 +-
 arch/riscv/kvm/gstage.c             | 338 +++++++++++++++++++
 arch/riscv/kvm/main.c               |   3 +-
 arch/riscv/kvm/mmu.c                | 499 ++++++----------------------
 arch/riscv/kvm/tlb.c                | 110 +++---
 arch/riscv/kvm/vcpu.c               |  26 +-
 arch/riscv/kvm/vcpu_exit.c          |  20 +-
 arch/riscv/kvm/vcpu_sbi_replace.c   |  17 +-
 arch/riscv/kvm/vcpu_sbi_v01.c       |  25 +-
 arch/riscv/kvm/vm.c                 |   7 +-
 arch/riscv/kvm/vmid.c               |  25 ++
 19 files changed, 795 insertions(+), 603 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_gstage.h
 create mode 100644 arch/riscv/include/asm/kvm_mmu.h
 create mode 100644 arch/riscv/include/asm/kvm_tlb.h
 create mode 100644 arch/riscv/include/asm/kvm_vmid.h
 create mode 100644 arch/riscv/kvm/gstage.c

-- 
2.43.0


