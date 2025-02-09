Return-Path: <kvm+bounces-37660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2FAAA2DB76
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 08:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97EEC165C2E
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2025 07:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9028513AA31;
	Sun,  9 Feb 2025 07:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S5XLYX/x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C274339A8
	for <kvm@vger.kernel.org>; Sun,  9 Feb 2025 07:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739085296; cv=none; b=anwloVx/QyRzZnAPWLT5CRzcHV/apHAzkcjYUbc6kyffFaR2B1y8tV+w9wVetp+DuB33UfroukOaLWJ6KdB16M9N/+tbkHIBe8oY2JN+45ftpoW7q8Ap1+qot1BNnA3tZahoMM9i4b5B6e9eoDaMNn7itS8iN2nIMn3QVnyUUu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739085296; c=relaxed/simple;
	bh=lO7zeNf+AukrMePtcOx0V4gLj9XuS/wR/UvZ8nuw1fw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xxk1fKpsp+Y02YdHgetncOrjrMCjDrDFe8lgX2kxkv0QZ8G12keoiZAeTwP+obfalGyUcJh0qo6iA8ILL06oF4dYMZ5KWVA0Ho2luYOeTZ50zCzbWuCh7Qu3X7yYdY1GPZ50m90tYZ2ZC1BwgFTLwzv2j6Zh6xLgfFWQNyYjhVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S5XLYX/x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739085293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lm19PGgaLb/LKlk3YdVmYU6gr7xJiy7Qyybmv8dY9Q4=;
	b=S5XLYX/xV9I4unUz3N5H5NIXXXcBK/6fib9Tl4zSAi6dCQix8OvMTSTFBbwbyJGO775Ygo
	UkpotrdCMlXFySHAU3Ue/5FJcY7Ml4PKkUeuAx09/tBT7pF+e3VCajCoC9ROw+5U6i2Z5D
	SxSphjAg8lPMWLDV5L6FmnvAQkx8X7M=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-QnUeNDBUMTKJN4a3V3cssg-1; Sun, 09 Feb 2025 02:14:50 -0500
X-MC-Unique: QnUeNDBUMTKJN4a3V3cssg-1
X-Mimecast-MFC-AGG-ID: QnUeNDBUMTKJN4a3V3cssg
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ab341e14e27so362063866b.3
        for <kvm@vger.kernel.org>; Sat, 08 Feb 2025 23:14:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739085290; x=1739690090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lm19PGgaLb/LKlk3YdVmYU6gr7xJiy7Qyybmv8dY9Q4=;
        b=aFM/oMokpf9M4g5HGdOaq3tyB6FOX7jXJ6L1p0Lso57DW1SqMJYT5JPzVK4pDctybN
         2QkS6UVnGcJJoq31tbuCAb10mAaEX1nkD2KVfGRLCz+qUFcF38tuYVErsUuCxjD76fSO
         DMGkaFccXLZkINyJTQvYe51x1aqh1cociOwptmrFJfocUnPIFPYfPB/MIsx/KfBTCBTa
         SlkRI95c8esK0ySIsb9X+fAh2caZTfML7++HypQl0H71OjfGkwQ3LhxHgKYfuXoOX/OP
         lbUFF42T19Z1UAnFQwZora11A/mV0KJJzhVHNQREbpW7IumtTJbo9l4C6mNDIVMyMRA1
         PRMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUk/9EGN0KHyjrpbqX9oe3RrOspTIS+bBmarxJcjC5dYUG1dYViISV9CNoI1YhUhKidpC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqGznoQLEVAxJyT6nFq8q8cBKkBHjx35YdzPD3UaKq9qB/vSXU
	kpHZhqW+RkCrp0klkxm2Wswe4IWCAZt3J+pRmeEYFNbiW4TzeXaO10F8bJtKbH3rJMoDRxr6ecE
	rU9iJCUxLeyWU4scqhXKr7zZ797xOBkSv4vUBvB4R/Skn2sHG+A==
X-Gm-Gg: ASbGncsVtvLFo21hP/Ql2C+EayEhJPgqByJrgDwroASx/if6Ren0+1PeVELhG++hgOW
	Asvmdzjl28zPuckcufGXkhDmb2Tot/TarAmFXWKRdhQdlR6kqu4LO1d1/sj2XMI3o4F3vUapgv/
	7hCt/Nl5Kgy6wtFq33igWACjwl4PWC23aHm9spXAu6Ia4LYAxxnmXzUKxK8XHToyeIm4FetylUZ
	DP1qGThrUJy2HiAKsRutGqoZEi2U4IhWGQEVtgSkdmlGSvRXplW0Q5jdmMpdwCwcfb4QfKNYAlC
	eyCXmg==
X-Received: by 2002:a17:907:a684:b0:ab7:b3f8:bcae with SMTP id a640c23a62f3a-ab7b3f92d9amr116377066b.12.1739085289580;
        Sat, 08 Feb 2025 23:14:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGaJ4ioKanHq/dFVGaq6D1haduLLzqCD5fDcFssWk7vHNrESutMprRa6xXPDMUWRYzPAgjaoA==
X-Received: by 2002:a17:907:a684:b0:ab7:b3f8:bcae with SMTP id a640c23a62f3a-ab7b3f92d9amr116375466b.12.1739085289190;
        Sat, 08 Feb 2025 23:14:49 -0800 (PST)
Received: from [192.168.10.3] ([151.62.97.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab78da1f953sm456326166b.59.2025.02.08.23.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2025 23:14:48 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	imbrenda@linux.ibm.com
Subject: [GIT PULL] KVM changes for Linux 6.14-rc2
Date: Sun,  9 Feb 2025 08:14:47 +0100
Message-ID: <20250209071447.2521861-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit 2014c95afecee3e76ca4a56956a936e23283f05b:

  Linux 6.14-rc1 (2025-02-02 15:39:26 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 43fb96ae78551d7bfa4ecca956b258f085d67c40:

  KVM: x86/mmu: Ensure NX huge page recovery thread is alive before waking (2025-02-04 11:28:21 -0500)

One thing that stands out here is an s390 cleanup to the page table
management code, which is quite different from everyone else's in
KVM land.  This came in a bit late due to the holidays and I initially
wanted to hold it until 6.15; on the other hand it would block some
of the page descriptor work due to how KVM/s390 used page->index and
page->lru for its own stuff; so, here it is.  The rest is bugfixes,
mostly ARM.

----------------------------------------------------------------
ARM:

* Correctly clean the BSS to the PoC before allowing EL2 to access it
  on nVHE/hVHE/protected configurations

* Propagate ownership of debug registers in protected mode after
  the rework that landed in 6.14-rc1

* Stop pretending that we can run the protected mode without a GICv3
  being present on the host

* Fix a use-after-free situation that can occur if a vcpu fails to
  initialise the NV shadow S2 MMU contexts

* Always evaluate the need to arm a background timer for fully emulated
  guest timers

* Fix the emulation of EL1 timers in the absence of FEAT_ECV

* Correctly handle the EL2 virtual timer, specially when HCR_EL2.E2H==0

s390:

* move some of the guest page table (gmap) logic into KVM itself,
  inching towards the final goal of completely removing gmap from the
  non-kvm memory management code. As an initial set of cleanups, move
  some code from mm/gmap into kvm and start using __kvm_faultin_pfn()
  to fault-in pages as needed; but especially stop abusing page->index
  and page->lru to aid in the pgdesc conversion.

x86:

* Add missing check in the fix to defer starting the huge page recovery
  vhost_task

* SRSO_USER_KERNEL_NO does not need SYNTHESIZED_F

----------------------------------------------------------------
Christoph Schlameuss (1):
      KVM: s390: selftests: Streamline uc_skey test to issue iske after sske

Claudio Imbrenda (14):
      KVM: s390: wrapper for KVM_BUG
      KVM: s390: fake memslot for ucontrol VMs
      KVM: s390: selftests: fix ucontrol memory region test
      KVM: s390: move pv gmap functions into kvm
      KVM: s390: use __kvm_faultin_pfn()
      KVM: s390: get rid of gmap_fault()
      KVM: s390: get rid of gmap_translate()
      KVM: s390: move some gmap shadowing functions away from mm/gmap.c
      KVM: s390: stop using page->index for non-shadow gmaps
      KVM: s390: stop using lists to keep track of used dat tables
      KVM: s390: move gmap_shadow_pgt_lookup() into kvm
      KVM: s390: remove useless page->index usage
      KVM: s390: move PGSTE softbits
      KVM: s390: remove the last user of page->index

Colin Ian King (1):
      KVM: selftests: Fix spelling mistake "initally" -> "initially"

David Hildenbrand (4):
      KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
      KVM: s390: vsie: stop using page->index
      KVM: s390: vsie: stop messing with page refcount
      KVM: s390: vsie: stop using "struct page" for vsie page

Lokesh Vutla (1):
      KVM: arm64: Flush hyp bss section after initialization of variables in bss

Marc Zyngier (4):
      KVM: arm64: Fix nested S2 MMU structures reallocation
      KVM: arm64: timer: Always evaluate the need for a soft timer
      KVM: arm64: timer: Correctly handle EL1 timer emulation when !FEAT_ECV
      KVM: arm64: timer: Don't adjust the EL2 virtual timer offset

Oliver Upton (2):
      KVM: arm64: Flush/sync debug state in protected mode
      KVM: arm64: Fail protected mode init if no vgic hardware is present

Paolo Bonzini (4):
      kvm: x86: SRSO_USER_KERNEL_NO is not synthesized
      Merge tag 'kvm-s390-next-6.14-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvmarm-fixes-6.14-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: remove kvm_arch_post_init_vm

Sean Christopherson (2):
      KVM: Do not restrict the size of KVM-internal memory regions
      KVM: x86/mmu: Ensure NX huge page recovery thread is alive before waking

 Documentation/virt/kvm/api.rst                   |   2 +-
 arch/arm64/kvm/arch_timer.c                      |  49 +-
 arch/arm64/kvm/arm.c                             |  20 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c               |  24 +
 arch/arm64/kvm/nested.c                          |   9 +-
 arch/arm64/kvm/sys_regs.c                        |  16 +-
 arch/s390/include/asm/gmap.h                     |  20 +-
 arch/s390/include/asm/kvm_host.h                 |   6 +-
 arch/s390/include/asm/pgtable.h                  |  21 +-
 arch/s390/include/asm/uv.h                       |   6 +-
 arch/s390/kernel/uv.c                            | 292 +---------
 arch/s390/kvm/Makefile                           |   2 +-
 arch/s390/kvm/gaccess.c                          |  44 +-
 arch/s390/kvm/gmap-vsie.c                        | 142 +++++
 arch/s390/kvm/gmap.c                             | 212 +++++++
 arch/s390/kvm/gmap.h                             |  39 ++
 arch/s390/kvm/intercept.c                        |   7 +-
 arch/s390/kvm/interrupt.c                        |  19 +-
 arch/s390/kvm/kvm-s390.c                         | 237 ++++++--
 arch/s390/kvm/kvm-s390.h                         |  19 +
 arch/s390/kvm/pv.c                               |  21 +
 arch/s390/kvm/vsie.c                             | 106 ++--
 arch/s390/mm/gmap.c                              | 681 +++++------------------
 arch/s390/mm/pgalloc.c                           |   2 -
 arch/x86/kvm/cpuid.c                             |   2 +-
 arch/x86/kvm/mmu/mmu.c                           |  33 +-
 arch/x86/kvm/x86.c                               |   7 +-
 include/linux/kvm_host.h                         |   1 -
 tools/testing/selftests/kvm/s390/cmma_test.c     |   4 +-
 tools/testing/selftests/kvm/s390/ucontrol_test.c |  32 +-
 virt/kvm/kvm_main.c                              |  25 +-
 31 files changed, 1093 insertions(+), 1007 deletions(-)
 create mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h


