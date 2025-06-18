Return-Path: <kvm+bounces-49848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 480C1ADEA4D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88C9C189E1EB
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0162D12F6;
	Wed, 18 Jun 2025 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LB/7iXR1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E52C2BE7DA
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246547; cv=none; b=ZTvbuqpdG5sYegpimE+GmvncMXjbHBlAeYPCqd1w7kMO9mkDssqe0oPFvELBcfK0qJP/IBKyCUuzP7k7HnYDTwOz4346/v2tu1tZexXWnKL7IsM3qpdu2t/LoLAbBMbVWc6lahENWZrG+fDzVy0Y8ayU9vU+qr3ygqwSmdJMAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246547; c=relaxed/simple;
	bh=kUeIya0giwpxu7KpfTx3sDDPSqXKgY3zIth7tPtJyY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ckoRq/YeweQpkmnebuIZSfX1uXWyZm/GIm+xH7Dcc2VQK6WvW+IoSu7KLd4Oxc6ZNbHi183jc1++lRsf6riw0PvTxqq/kSDwxeqtpwkDOjm5rY0OvVoFIdpJ7Lu7xBBYp6VJ84ku4kTL6YurvN0In5odXZ3WxlTk/5wc3RC+cc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LB/7iXR1; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-237311f5a54so8223035ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246545; x=1750851345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O8iWAhDJxETW40ym1irbHf7bY4A+gmTdzotzkqqzyxY=;
        b=LB/7iXR1ozX7RBwCJjZGFfIWGtKN4W5SCCTg++bjlDLtIDZkyOm0HTFeOoVZTVk9Ik
         0cJCUsReUbXuGFRPXq0RJinCG9OEzxiuuPzd/EOndb7CRCAiN5Tf7KuPE1l82oYnjRVN
         iaS4J4zkeJul80wlctg2ByUswCKRKnh0L6/z0HDmXx6MsEJurn3iqd3R90BopeIIeAF1
         7s/qyQiHzfpIqAqd74wDy89JtaTa2YhXu0w8vCeKE83paje7TYLxN+0pi8pfo2z0HD3Q
         ZIXn4cNT3v/cJOESDgqE7bUFvlBbTeO+QQjmeQx+6CWr0/2LHqpJ3l69ufnnee8YHnNk
         e6Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246545; x=1750851345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O8iWAhDJxETW40ym1irbHf7bY4A+gmTdzotzkqqzyxY=;
        b=vGDaIKE/ds2RUg8Ggs0L3+BoIF/R3ykSquEYAXfQyOv+e0iNwxoOmukfYPKlOj1e9I
         eg+uFGMAKLTOfOQLD1OgO6KHplMDXc3xkSrkuHTrfYRjaaEf5J0G8chQtkoHZzK+tdqn
         H1MZiuiq8RBjp9ZVE2vYHu/BX3MpOGI0s50X9z427Nwa1tYf769Zq3u2d9kUhHnmI4qc
         O/wpJm+oupKMXA/3h/+49RWEo8Jk55X/eHcw31b6EZjk0D8HnQrOPbn0EgFLG1tb9+WE
         Dw7YH9tknWCu2NM1UG7o7UeWAjd8DVzUXLSTsVcl5b2KdN98HyS5guAJwYwRPe9kCo32
         Sgvg==
X-Forwarded-Encrypted: i=1; AJvYcCVATnI/j8xnDNU5+JD4UaPPLhr2L4qdhz789nfnznHgULJQJbDFiMiX/mcSdC3hq0wqpgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh09xoZfFizwAzmj2RsCdVhvyrHGaeqs2CksHraSDP8pvWwwrA
	TGmrRW1oLV4FNo7QcOoYndxVPppLIjeOYviV53Jr1FmYPJ/rj2V7/KHKHE1U3mirzzI=
X-Gm-Gg: ASbGncu378/uNddSbBJFI+pIGLFAn+61vdeMkn11/pS0j/uUUtllm/qVWMQ+DGMZ97Z
	gr0yajJvrsbiELlxuGkhueUptBI/HKzWp2RjAIXeHM/9+5ZMjMn5bc8gRgaud48mh1nykpFrYUU
	A9SMXohcfJ0YlW1caFLnQJnPgwvsQLeyUk8OUfYlDX4nofxdQuFqtOGsoo6/MQgN3qanTso4tKO
	n3DLAhIB0Wo0W/EFLHyIGXwb024Uw+4toVO205gz8rGvlRD+UBPJYTsZJT3+YzLrnCwMomlJarq
	jJesGFN6kZ8GW6SONpPj+6qy0GfqR972fWDeobqjora4iwA7iaCKoPBH92KC6NpAFRdiItkaLJh
	zxx26YgRZHZ82g6Qclg==
X-Google-Smtp-Source: AGHT+IHPnSOG9Zfjo3AXh1Ue9MlaL5hmmABB22HqQcHI7XHuRT4ee8G3zhSleCl++zcQ0XmNSUBiMg==
X-Received: by 2002:a17:902:ba83:b0:236:6f43:7047 with SMTP id d9443c01a7336-2366f43724emr191830325ad.9.1750246545357;
        Wed, 18 Jun 2025 04:35:45 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:35:44 -0700 (PDT)
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
Subject: [PATCH v3 00/12] MMU related improvements for KVM RISC-V
Date: Wed, 18 Jun 2025 17:05:20 +0530
Message-ID: <20250618113532.471448-1-apatel@ventanamicro.com>
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

PATCH1 to PATCH4: Few cosmetic improvements
PATCH5 to PATCH7: TLB maintenance and SBI NACL related improvements
PATCH8 to PATCH12: MMU related preparatory work for nested virtualization

These patches can also be found in the riscv_kvm_mmu_imp_v3 branch
at: https://github.com/avpatel/linux.git

Changes since v2:
 - Rebased upon Linux-6.16-rc2 and latest riscv_kvm_queue branch
 - Added Reviewed-by tags to appropriate patches

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


