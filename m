Return-Path: <kvm+bounces-61529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A86AC2220F
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 646BD188750D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2A436E379;
	Thu, 30 Oct 2025 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qd+iX+HR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A138736B98D
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855001; cv=none; b=lnFzPvW79jWGifoLbYHmIT1Y87STDbNG7jYTeiAB4/PFBfvlLKeSq2XfX7SsCG3jBDy6Ck/JWMfKmkJf9lRQWj3F/ZHhtR7PJ69qNYUdPNMRj3K/owil5F0kqbMDpMkuOAzS1UpuR8ojq39pGH82a0MvUcc81vkxamXXjWEVaWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855001; c=relaxed/simple;
	bh=iWqK9o5Q9lSs0dNS4loIwGhdjpS9qDnFS67Z8kLa5ZY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=u3GVurx5bJGzj/MLC0qL5u2BXLkg9SQCEhgzHKpl/VKTwy9FJez2Wc6g1/buAtyUuT0Pj8F2T80ncGcepO+v+WnHbtqKx3NANZqXKeAxb9TF4dl0nOwq3TmyGag5vAZtJmVF6PHdSnaIasQ0GouUgnzNazyldixzv1Rv9O/LNbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qd+iX+HR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb779733so1397512a91.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761854999; x=1762459799; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zrcNX0WZe6UQQAW+Y1acRpaDavildHCqqfp5zf8UBT8=;
        b=qd+iX+HRguzV8RHinP+d64sx44ccYmm2BMsrzhS4vENzeN1SWeqaQgPgtyV/DWAvKj
         jTwUwkJdsnBsZbSb/qeJSqq6GedxUJxf1SRgeUh//DgC5OL5iSMRGngr4uPB3KngiC9E
         5C7xYqTKnnCeqWDxTEW0d4YPSujcz7B17Z40W4rPGyS7uNVgp+MHXyFP9WOJrMbujgRk
         dNLYzzVOVd/6/WrCNM9aiUVmouZm3NQAZhl9ODa8LaWBivC4+1JMOXpfFO1R5VHRoK18
         4/K0HRXfJ+8Mb2nVbRUq0sxgOndVg5T3n+0/BerK58U7Wl1jzTICoL9pLv4J3G59RXjX
         KCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761854999; x=1762459799;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zrcNX0WZe6UQQAW+Y1acRpaDavildHCqqfp5zf8UBT8=;
        b=JQtLZsYzYAF1DQJbnYNjuOJBfeN5e4rXtTYBzJUIEUN1JWo1AWXpl4dRdLIolPQXw+
         E+q/qGIaR4fHQOw6vPkcixILADYTJRnlm8sx4YqjbuKUXfG0LSh+ILwPvkgE1N7uCqwS
         a25GsujzV5vpSOZARbHPIu1r1HcBByhQaV0YtBxtHxtznxlMAN+Ceh2co46XwsSmcd3o
         Ns/cKTY/LI01I4eBV67MMOSqM3nIgQsYJWV3P9Y5+la2S878jdcYwAsjGHN/caIUp0Nh
         wptGfwJxiqHdUXOPJfrIInc+S9bZsI/p/UzpgixEnAaCdPLFVTT5BOATteWhu4qiwzUM
         l++Q==
X-Forwarded-Encrypted: i=1; AJvYcCXVbJdaPSbadDZmNJQUKHZ7jH7cJWhBL0TydVme/sGIRa6MaoN0lOJuzydUBkkmg/wFQw0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz99mDsdiBOH2GmuRRBlMmMLJ5+GLYGX7YPC6JIb7vrn0Drzasx
	aaRSpoeGcaXWAEF+/Q2av2U+2js077PxAdbNTcFpsDQv3d9UXbd7CQPOCndUYoeX5hGNA8jMO35
	vhSWfQw==
X-Google-Smtp-Source: AGHT+IHHZpNGbgjLGw+ZYpoCrFPTV304XH1EL6WE9wIH48O/1tSukWUG1dLDd7KIv/LOoUL3Sr92aGNZzYE=
X-Received: from pjvp23.prod.google.com ([2002:a17:90a:df97:b0:339:e59f:e26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d40c:b0:33b:b020:5968
 with SMTP id 98e67ed59e1d1-34083071b1emr1223925a91.21.1761854998946; Thu, 30
 Oct 2025 13:09:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:23 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-1-seanjc@google.com>
Subject: [PATCH v4 00/28] KVM: x86/mmu: TDX post-populate cleanups
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Non-x86 folks, as with v3, patches 1 and 2 are likely the only thing of
interest here.  They make kvm_arch_vcpu_async_ioctl() mandatory and then
rename it to kvm_arch_vcpu_unlocked_ioctl().

As for the x86 side...

Clean up the TDX post-populate paths (and many tangentially related paths) to
address locking issues between gmem and TDX's post-populate hook[*], and
within KVM itself (KVM doesn't ensure full mutual exclusivity between paths
that for all intents and purposes the TDX-Module requires to be serialized).

I apologize if I missed any trailers or feedback, I think I got everything...

[*] http://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com

v4:
 - Collect reviews/acks.
 - Add a lockdep assertion in kvm_tdp_mmu_map_private_pfn(). [Yan]
 - Wrap kvm_tdp_mmu_map_private_pfn() with CONFIG_KVM_GUEST_MEMFD=y. [test bot]
 - Improve (or add) comments. [Kai, and probably others]
 - s/spte/mirror_spte to make it clear what's being passed in
 - Update set_external_spte() to take @mirror_spte as well. [Yan]
 - Move the KVM_BUG_ON() on tdh_mr_extend() failure to the end. [Rick]
 - Take "all" the locks in tdx_vm_ioctl(). [Kai]
 - WARN if KVM attempts to map SPTEs into an invalid root. [Yan]
 - Use tdx_flush_vp_on_cpu() instead of tdx_disassociate_vp() when freeing
   a vCPU in VCPU_TD_STATE_UNINITIALIZED state. [Yan]

v3:
 - https://lore.kernel.org/all/20251017003244.186495-1-seanjc@google.com
 - Collect more reviews.
 - Add the async_ioctl() => unlocked_ioctl() patches, and use the "unlocked"
   variant in the TDX vCPU sub-ioctls so they can take kvm->lock outside of
   vcpu->mutex.
 - Add a patch to document that vcpu->mutex is taken *outside* kvm->slots_lock.
 - Add the tdx_vm_state_guard CLASS() to take kvm->lock, all vcpu->mutex locks,
   and kvm->slots_lock, in order to make tdx_td_init(), tdx_td_finalize(),
   tdx_vcpu_init_mem_region(), and tdx_vcpu_init() mutually exclusive with
   each other, and mutually exclusvie with basically anything that can result
   in contending one of the TDX-Module locks (can't remember which one).
 - Refine the changelog for the "Drop PROVE_MMU=y" patch. [Binbin]

v2:
 - Collect a few reviews (and ignore some because the patches went away).
   [Rick, Kai, Ira]
 - Move TDH_MEM_PAGE_ADD under mmu_lock and drop nr_premapped. [Yan, Rick]
 - Force max_level = PG_LEVEL_4K straightaway. [Yan]
 - s/kvm_tdp_prefault_page/kvm_tdp_page_prefault. [Rick]
 - Use Yan's version of "Say no to pinning!".  [Yan, Rick]
 - Tidy up helpers and macros to reduce boilerplate and copy+pate code, and
   to eliminate redundant/dead code (e.g. KVM_BUG_ON() the same error
   multiple times).
 - KVM_BUG_ON() if TDH_MR_EXTEND fails (I convinced myself it can't).

v1: https://lore.kernel.org/all/20250827000522.4022426-1-seanjc@google.com


Sean Christopherson (26):
  KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
  KVM: Rename kvm_arch_vcpu_async_ioctl() to
    kvm_arch_vcpu_unlocked_ioctl()
  KVM: TDX: Drop PROVE_MMU=y sanity check on to-be-populated mappings
  KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
  KVM: x86/mmu: WARN if KVM attempts to map into an invalid TDP MMU root
  Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP
    MMU"
  KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
  KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
  KVM: TDX: Fold tdx_sept_drop_private_spte() into
    tdx_sept_remove_private_spte()
  KVM: x86/mmu: Drop the return code from
    kvm_x86_ops.remove_external_spte()
  KVM: TDX: WARN if mirror SPTE doesn't have full RWX when creating
    S-EPT mapping
  KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
  KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
  KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole caller
  KVM: TDX: ADD pages to the TD image while populating mirror EPT
    entries
  KVM: TDX: Fold tdx_sept_zap_private_spte() into
    tdx_sept_remove_private_spte()
  KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error() into TDX_BUG_ON()
  KVM: TDX: Derive error argument names from the local variable names
  KVM: TDX: Assert that mmu_lock is held for write when removing S-EPT
    entries
  KVM: TDX: Add macro to retry SEAMCALLs when forcing vCPUs out of guest
  KVM: TDX: Add tdx_get_cmd() helper to get and validate sub-ioctl
    command
  KVM: TDX: Convert INIT_MEM_REGION and INIT_VCPU to "unlocked" vCPU
    ioctl
  KVM: TDX: Use guard() to acquire kvm->lock in tdx_vm_ioctl()
  KVM: TDX: Don't copy "cmd" back to userspace for KVM_TDX_CAPABILITIES
  KVM: TDX: Guard VM state transitions with "all" the locks
  KVM: TDX: Bug the VM if extending the initial measurement fails

Yan Zhao (2):
  KVM: TDX: Drop superfluous page pinning in S-EPT management
  KVM: TDX: Fix list_add corruption during vcpu_load()

 arch/arm64/kvm/arm.c               |   6 +
 arch/loongarch/kvm/Kconfig         |   1 -
 arch/loongarch/kvm/vcpu.c          |   4 +-
 arch/mips/kvm/Kconfig              |   1 -
 arch/mips/kvm/mips.c               |   4 +-
 arch/powerpc/kvm/Kconfig           |   1 -
 arch/powerpc/kvm/powerpc.c         |   4 +-
 arch/riscv/kvm/Kconfig             |   1 -
 arch/riscv/kvm/vcpu.c              |   4 +-
 arch/s390/kvm/Kconfig              |   1 -
 arch/s390/kvm/kvm-s390.c           |   4 +-
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   7 +-
 arch/x86/kvm/mmu.h                 |   3 +-
 arch/x86/kvm/mmu/mmu.c             |  87 +++-
 arch/x86/kvm/mmu/tdp_mmu.c         |  50 +--
 arch/x86/kvm/vmx/main.c            |   9 +
 arch/x86/kvm/vmx/tdx.c             | 659 ++++++++++++++---------------
 arch/x86/kvm/vmx/tdx.h             |   8 +-
 arch/x86/kvm/vmx/x86_ops.h         |   1 +
 arch/x86/kvm/x86.c                 |  13 +
 include/linux/kvm_host.h           |  14 +-
 virt/kvm/Kconfig                   |   3 -
 virt/kvm/kvm_main.c                |   6 +-
 24 files changed, 468 insertions(+), 424 deletions(-)


base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057
-- 
2.51.1.930.gacf6e81ea2-goog


