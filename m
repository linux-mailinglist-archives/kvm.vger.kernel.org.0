Return-Path: <kvm+bounces-64589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B6BD7C87BDF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:47:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EDE5F3550CC
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5761230DECE;
	Wed, 26 Nov 2025 01:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pjKVqXDZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8C830CD82
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121513; cv=none; b=oStWTUkieEkQAC8MM4w+8TQbOI0WFVWGY7OvnYervkYCYt3q4IlPDJDf1pkvzi9ozjLr6esnoJAJr65uUMNTyD9jMH/dyTBzisqJCrCcj+b0L41DHmO8nk2KoEeZEXWUoziMcViGOTjb5MjjfUt6Kz5F1u7TdNZ3pjshVNN1W9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121513; c=relaxed/simple;
	bh=fx1V5N+FEkkNG0c9NQYr91Ae4BJtjd9YNXIVru9HkCk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FOcZzFQ3efO8QTain7Zx/07APH1oGds0R7lfUHVuASc/Y40XRhQZPNTuRxGY7cSVOq6aaLoqaFgcqJCf81Td78Zwzp6lgrf5QN41hLz1XPQHa3gZZFrW2AHdUfpwZN4d4h3VsbBEUGfHkAs31vvYMn5NgZiNouoO5vqfqhdM14o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pjKVqXDZ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9c91b814cso18849583b3a.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121510; x=1764726310; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=piqsdEYYlYLVROzcY44x1lmY7qAJy+uoocJvlOwyzrk=;
        b=pjKVqXDZi+XK1lOet8BMrPWDuoDFzbWp0fxf0J0ARHFPUHRRovcRff2M9YNCcwrkD2
         0LnmUvYqf77BPK/QpgkGV1sTuWRqyeyg4SYTdZdFBV6GhUbGg/sg54AgB4q5YwD9JuTY
         2iajkdtk/LaCUijQDLoc4tzn1y7Cq0Q0K+7cEheXx/6fMCIGt8ITH9kA5gUxCnnqDdl8
         MgisKVJdS0GIeJS+Y2gPVFCkBbWSbret7n0pkRAoF1xjR755Ps2IXsxFxF951hdM6GvJ
         PEe1HlGxbhBTE524zPx/gWC2pjyrMLpfZaY0hxd4pnCrCLH14IyPxW9Os2NGcu1GAp2n
         SRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121510; x=1764726310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=piqsdEYYlYLVROzcY44x1lmY7qAJy+uoocJvlOwyzrk=;
        b=J68aWWJkUGNmmBhmUrD+d06XHeLGalxWIoZ4yqAMCPHype0hB1VyxGmGel5Y+nx+rq
         pzi+2iNvzqw3D+JPi4XGNB/HP+uCjYSFFDTgdSSKK2KqUYM1HERaIGPWjItCHkonuPuR
         eCVVTWBYk3RjHpIvqbqkA2PumRQuqg0l5UtTTrc9DNme2eB7EjmGbD+OiwOhajmUurpl
         Ni2Mroe7ca8Hz5CYGoMJOBg8NcGg05w5iy6ZkFgMMmme8yxniEILoUjpF6X3LDw/bicZ
         LdrY2mW4q9OETAx9kqOosBeFdKU/MTtgIVsIWp+jGglbYUgRrA8JS+3PIkeCbEiV+/zO
         BTPQ==
X-Gm-Message-State: AOJu0YzZll8jGvnuSWn3Ko8qfQ2rGrh1IJFNmI7CE6eypA7jvrd9h//7
	LZBDR4mZN/RZAKQ/Wgya6eT9a8OFEwLe/+TenIRNHRsYlg5Rpg69xl7PMl1UANiF39cW3xiZq4j
	QkjvHPw==
X-Google-Smtp-Source: AGHT+IGVh0EDGDAfFeZl9lDq0wkBq+9yAjXLQxC7xKkg3fAe3KVhVoO6RyUyDXqqur+zfnhyksqj+rr2iBQ=
X-Received: from pfqy7.prod.google.com ([2002:aa7:9e07:0:b0:772:3537:d602])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b4d:b0:7a2:7a93:f8c9
 with SMTP id d2e1a72fcca58-7ca89a6c1d3mr4782317b3a.27.1764121510095; Tue, 25
 Nov 2025 17:45:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:54 -0800
In-Reply-To: <20251126014455.788131-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-8-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: TDX changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a large overhaul of lock-related TDX code (particularly in the
S-EPT and mirror SPTE code), along with a few fixes and cleanups.

*Huge* kudos to Rick, Yan, Binbin, Ira, and Kai (hopefully I didn't forget
anyone) for their meticulous reviews, testing and debug, clever testcases,
and help determining exactly what scenarios KVM needs to deal with in terms
of avoiding lock contention in the TDX Module.

P.S. There are few one-off TDX changes in the "vmx" pull request.  I don't
     expect to have a dedicated TDX pull request for most releases, I created
     one this time around because of the scope of the overhaul.

The following changes since commit 6146a0f1dfae5d37442a9ddcba012add260bceb0:

  Linux 6.18-rc4 (2025-11-02 11:28:02 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-tdx-6.19

for you to fetch changes up to 398180f93cf3c7bb0ee3f512b139ad01843f3ddf:

  KVM: TDX: Use struct_size to simplify tdx_get_capabilities() (2025-11-13 08:30:07 -0800)

----------------------------------------------------------------
KVM TDX changes for 6.19:

 - Overhaul the TDX code to address systemic races where KVM (acting on behalf
   of userspace) could inadvertantly trigger lock contention in the TDX-Module,
   which KVM was either working around in weird, ugly ways, or was simply
   oblivious to (as proven by Yan tripping several KVM_BUG_ON()s with clever
   selftests).

 - Fix a bug where KVM could corrupt a vCPU's cpu_list when freeing a vCPU if
   creating said vCPU failed partway through.

 - Fix a few sparse warnings (bad annotation, 0 != NULL).

 - Use struct_size() to simplify copying capabilities to userspace.

----------------------------------------------------------------
Dave Hansen (2):
      KVM: TDX: Remove __user annotation from kernel pointer
      KVM: TDX: Fix sparse warnings from using 0 for NULL

Rick Edgecombe (1):
      KVM: TDX: Take MMU lock around tdh_vp_init()

Sean Christopherson (27):
      KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
      KVM: Rename kvm_arch_vcpu_async_ioctl() to kvm_arch_vcpu_unlocked_ioctl()
      KVM: TDX: Drop PROVE_MMU=y sanity check on to-be-populated mappings
      KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
      KVM: x86/mmu: WARN if KVM attempts to map into an invalid TDP MMU root
      Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU"
      KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
      KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
      KVM: TDX: Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte()
      KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external_spte()
      KVM: TDX: WARN if mirror SPTE doesn't have full RWX when creating S-EPT mapping
      KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
      KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
      KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole caller
      KVM: TDX: ADD pages to the TD image while populating mirror EPT entries
      KVM: TDX: Fold tdx_sept_zap_private_spte() into tdx_sept_remove_private_spte()
      KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error() into TDX_BUG_ON()
      KVM: TDX: Derive error argument names from the local variable names
      KVM: TDX: Assert that mmu_lock is held for write when removing S-EPT entries
      KVM: TDX: Add macro to retry SEAMCALLs when forcing vCPUs out of guest
      KVM: TDX: Add tdx_get_cmd() helper to get and validate sub-ioctl command
      KVM: TDX: Convert INIT_MEM_REGION and INIT_VCPU to "unlocked" vCPU ioctl
      KVM: TDX: Use guard() to acquire kvm->lock in tdx_vm_ioctl()
      KVM: TDX: Don't copy "cmd" back to userspace for KVM_TDX_CAPABILITIES
      KVM: TDX: Guard VM state transitions with "all" the locks
      KVM: TDX: Bug the VM if extending the initial measurement fails
      KVM: TDX: Use struct_size to simplify tdx_get_capabilities()

Thorsten Blum (1):
      KVM: TDX: Check size of user's kvm_tdx_capabilities array before allocating

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
 arch/x86/kvm/mmu/mmu.c             |  87 ++++-
 arch/x86/kvm/mmu/tdp_mmu.c         |  50 +--
 arch/x86/kvm/vmx/main.c            |   9 +
 arch/x86/kvm/vmx/tdx.c             | 712 ++++++++++++++++++-------------------
 arch/x86/kvm/vmx/tdx.h             |   8 +-
 arch/x86/kvm/vmx/x86_ops.h         |   1 +
 arch/x86/kvm/x86.c                 |  13 +
 include/linux/kvm_host.h           |  14 +-
 virt/kvm/Kconfig                   |   3 -
 virt/kvm/kvm_main.c                |   6 +-
 24 files changed, 496 insertions(+), 449 deletions(-)

