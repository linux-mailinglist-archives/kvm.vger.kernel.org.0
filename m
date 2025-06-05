Return-Path: <kvm+bounces-48472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B27A5ACE9E1
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 344B97A8943
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFAFC1F4C94;
	Thu,  5 Jun 2025 06:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="fR+SElK0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3141F1927
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104107; cv=none; b=J8L7crIVXm4rUNDrJrTmaoyTVDrMTJW2/GBidTxJ622J2Zh+CW3xTOSACw82SDVgPuJv9mbyq7L52E2EIHRlZL00B9KmExfDXC8C9XCykCj0qJZzbBv5mGYVW2EojgE1vOkpfYzxYXmn5oyT/Jt8m4CxbpXZrQe82wSDqN4DCSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104107; c=relaxed/simple;
	bh=5i7+RsVOCq4JG6AwAlf/qvPA4TN75OLrYIXjlJcGIwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NIXReF03FKdS9FvfFzT6/1aXu/TC7+uMoTzjHFjX/U08JpshHmSU0PKycpJRYb5XfM2x50dezGpV325Zth9ag4j3Y1fWOtDWltfiAIqSlqnJjEK6oiO46jjomXbiCtoXPTBMnLTLM7T1gKT/HvvMI7fY/h8TRBMPUwmQtHxsfvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=fR+SElK0; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-31329098ae8so494089a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104106; x=1749708906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IYCdKhY8aW9URe8Blmx5TcE5ZqYHha77HAw4jeob92E=;
        b=fR+SElK0+TvZ25dEdIXaaFxma5pusCuX2q14ua5qsx4sq9DiTrnqn9/FloQNT2HMEK
         yt9cWnkQU9r9VPOvhqn9pjMlDkpeha8INZHVJZnS2M6lxcUDnA9XtFWVoddZcUak67PU
         CWC/2pmYacFo7+bkmeA2P7Vc7b4FkKDOp6l0iBXQwxntnDUUvjLbIjf8RPDdlqGLRPIS
         MpAnCcIvZWok1NgRxSeQi1GOUitXu57MP8ND/dLMSwFT3/Gt0s/WtND29qLScN+Jlgrz
         5BFII5wnmxPQAj1ShOHLOV+mIuvA/UNHarvvxICwfo5PuAyKmto8Qj0tohr/qm0PB0G0
         zwIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104106; x=1749708906;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IYCdKhY8aW9URe8Blmx5TcE5ZqYHha77HAw4jeob92E=;
        b=bM/+sgXfM8j9waRRozjYYeFfUO/GVQKhKJ8AoqShNzcL5nidDCe7INFDBucECvx/kd
         ib0mqqCbAchT0h217sMRbuqaFT88CSUrkkoguqWkxw0vcK17vMwGhGN/I7E7mJRMFA3b
         XE7DcM49tV0p141T5HqjhlAP5BlLPVVdHVW2s7+x/ZIWmLY817GLMTZkUDftQfg9hei9
         MvgH1gr/2PBKOEoD64Lhdq0LflldoAKxPPNBlGAfVpVMmmMzNibyZd4yBD8h4WboaKP5
         HjwOEsq/sTaDjtXKfqeAzTLrgfv5O811h+CI5H3yFGtKrw50tLfjAY+EnIT8EWu5TIej
         zQTA==
X-Forwarded-Encrypted: i=1; AJvYcCXFcGkV6gCjJRFJLtgoNAqei0n9gwx12rPL3Qn2yBkY6XSkDe+L7I28vEFxcEX40r7vrjw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvDMk6NZJbMfs4BR0kk2gfIhiJOJ/aHeI1EPY38hT4mLJDfId4
	/d2ssQpe29TkXA0hy5oM/VYCQRUYSyKu4DiOo+1JDM3mgwCo7YSbrjAPOHxdKOJnryp0rShdIbN
	l6Qzk
X-Gm-Gg: ASbGnctwT5OyhtW9lyLovCYHwozKIK+2tKXxljvc5q99k4qcMRMUJ6gJwJXSaSok7f8
	VYGx132TTbg4FZvCxnz3yaHbnWX78tXO7OX49wpp6yPqJ2AsChg3u0NbPQxLgaGrqNK8cbNf+zP
	V6bghWBz4BpHle3X6dpLZh3otEcgRvB8ClUf9kVqmknwMIjrGJ7SaXaAsQf14858vIAInV8UeEs
	3bfzogl3SaZFlpA6LPtgqrIDBZuKZ1tNjPwMIAuDfMLYsfnQZgJySqljWXcViBPQZYspyqoUpYU
	8q6cbCIudBC4jcr/WIfmNqB9JQ4YaeueGtUqRA0eiwBgzUQCQ0XytUrlViVVyWJPyj+lhcXVGQU
	yb7JLEg==
X-Google-Smtp-Source: AGHT+IEERT0Tj/0eAgp/ef6xa8y7k+Vq1PulNXuIhfC0x9NWeX6p07jWalxiSI7B9LR8eu0ziMDdUA==
X-Received: by 2002:a17:90b:1d07:b0:310:8d4a:4a97 with SMTP id 98e67ed59e1d1-3132903824dmr3193484a91.15.1749104105532;
        Wed, 04 Jun 2025 23:15:05 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:04 -0700 (PDT)
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
Subject: [PATCH 00/13] MMU related improvements for KVM RISC-V
Date: Thu,  5 Jun 2025 11:44:45 +0530
Message-ID: <20250605061458.196003-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series primarily has various MMU improvements for KVM RISC-V
and it also serves as a preparatory series for the upcoming nested
virtualization support.

PATCH1 to PATCH2: SBI spec related fixes in SBI RFENCE extension
PATCH3 to PATCH6: Few cosmetic improvements
PATCH7 to PATCH8: TLB maintenance related improvements
PATCH9 to PATCH13: MMU related preparatory work for nested virtualization

These patches can also be found in the riscv_kvm_mmu_imp_v1 branch
at: https://github.com/avpatel/linux.git

Anup Patel (13):
  RISC-V: KVM: Fix the size parameter check in SBI SFENCE calls
  RISC-V: KVM: Don't treat SBI HFENCE calls as NOPs
  RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
  RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
  RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
  RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with
    KVM_REQ_TLB_FLUSH
  RISC-V: KVM: Don't flush TLB in gstage_set_pte() when PTE is unchanged
  RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
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
 arch/riscv/kvm/gstage.c             | 336 +++++++++++++++++++
 arch/riscv/kvm/main.c               |   3 +-
 arch/riscv/kvm/mmu.c                | 499 ++++++----------------------
 arch/riscv/kvm/tlb.c                | 110 +++---
 arch/riscv/kvm/vcpu.c               |  27 +-
 arch/riscv/kvm/vcpu_exit.c          |   7 +-
 arch/riscv/kvm/vcpu_sbi_replace.c   |  25 +-
 arch/riscv/kvm/vcpu_sbi_v01.c       |  25 +-
 arch/riscv/kvm/vm.c                 |   7 +-
 arch/riscv/kvm/vmid.c               |  25 ++
 19 files changed, 791 insertions(+), 601 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_gstage.h
 create mode 100644 arch/riscv/include/asm/kvm_mmu.h
 create mode 100644 arch/riscv/include/asm/kvm_tlb.h
 create mode 100644 arch/riscv/include/asm/kvm_vmid.h
 create mode 100644 arch/riscv/kvm/gstage.c

-- 
2.43.0


