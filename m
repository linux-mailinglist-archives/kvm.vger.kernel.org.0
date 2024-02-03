Return-Path: <kvm+bounces-7875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D8F0847D88
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A87DF282596
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1182EA9;
	Sat,  3 Feb 2024 00:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fnz7lasK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E270643
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918963; cv=none; b=DDxr0z/gcmiOooWZqRGx9W4YDv+IdHaZze6jbDX6LpRJcKEu3OITRVvm3Lwsi/AqHMZ53ty7rhrajWljnC1Y3aJEglg2kB2fPnl0MeOlUsQgWgEoWFZeYuxay9nHb1reh8VakIVt+VXxt3YrZV4OmoKX0W+jA9YVs7msXYX47fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918963; c=relaxed/simple;
	bh=x1BTam7mSj4YBuat3i1LceUOU7iyCLkuBarnLQ8SIT8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LmwrmozJKGgXLmsEeAsCQQ26SJCZSbTiUhug2xuNNFkagLCr/PBKfAxeZmmqvQjM8Xrfp4caMAqu+Ak8VDKt8PQ/QFKhwEJDV3mW4OnuFT24ykTZoDewXJWsFcWfdIreOppU6WZs5PGjl3VuWCyWrFhLxU6cOgG0LrLvwnAt10o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fnz7lasK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d43d0d6024so2751774a12.3
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918961; x=1707523761; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tvzfq6Tb+/LmzZGCY47OcGl4Yg3FqwT4x8FVTh6/pw0=;
        b=fnz7lasKqlUD1c6funXNmg8HkvxAZVDwO5fmWhA9NPEPcStttMDvXmbBAeAbmFP9ob
         rfUcnFxNMmfeQdpFTihmXe+HPaRWhJXPsgdz2nC9uSjr6va7J6HL3TXc6DczvOcsWPVJ
         nJy30ZQqSLPkwVziTAw/g1JGoLvwuxpCD6nnf/a06uEUR5a1Dbt6XPWRlWr/fglcR+NT
         C6qCWOV9uSXGp/TKbMwQM+yKCS11hX/tR8vZ5ojdWhk/K7UYdOz76FqKeqQMIowfV/tL
         8rGNv+vQ4djhSzUlIkTdXj4cviZ7eDUDVaNBypYrJJG+hUF6m/75iB1mdRojFwu6ryId
         m4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918961; x=1707523761;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tvzfq6Tb+/LmzZGCY47OcGl4Yg3FqwT4x8FVTh6/pw0=;
        b=YGAALetznEhk4Y0t0fxtiEI5XyR2B1FkIGpmcYJYXxYixYBuAHRD9bPwDYvFyD9fty
         Q+jNFshvhi77eTSmdRJU0DVFXUijSQ4kdwyKWBiJSxwkV7sPO/AT86iPZL+5ctG7Pv2B
         RXdFEUP3PjjKc80n4m0hlUCG+hTsFZWEkCbd3ey8V18ooXO15jYw7bytkYOdTOu9mtFP
         Bj0NT4hxI6AXK97/7Ub86+/wh9zgzFTqrK0zkL8zWS2xagAWZgbAM0ugTadux5WSt9jT
         ZJzxWA5LAoT2xsWxYHDHtGrg3QPW06Kp7WLN+IW+Dwyp3orxKIOtjmobmRryWTONGIVJ
         aLkw==
X-Gm-Message-State: AOJu0YyG4cxcu9IXNZiK+UJAMb/utUZMYDLYO0ZAfuT1DbY7oSdxgXKO
	oNIVjST6iRpKpolN5XE24ZPGvXSDwA+VL04hNhXRiLP/26lrznBdHRVknUVV03fn53oJziNi3da
	ZOw==
X-Google-Smtp-Source: AGHT+IEqzXCmN6ReYMmNGcuC8mmtBhOi0vEe5B/tBx3edOgmg4Vw4BtLnbB387naOpc+iWQYiMA/3I2Kvpo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:670b:0:b0:5d7:9b27:8ad4 with SMTP id
 u11-20020a65670b000000b005d79b278ad4mr18346pgf.3.1706918960728; Fri, 02 Feb
 2024 16:09:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:06 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-1-seanjc@google.com>
Subject: [PATCH v8 00/10] KVM: selftests: Add SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a basic SEV smoke test.  Unlike the intra-host migration tests, this
one actually runs a small chunk of code in the guest.

v8:
 - Undo the kvm.h uAPI breakage.
 - Take advantage of "struct vm_shape", introduced by the guest_memfd
   selftests, to simply tracking the SEV/SEV-ES subtypes.
 - Rename the test to "sev_smoke_test" instead of "sev_all_boot_test",
   as the "all" is rather nonsensical, and the test isn't booting anything
   in the traditional sense of the word.
 - Drop vm->protected and instead add an arch hook to query if the VM has
   protected memory.
 - Assert that the target memory region supports protected memory when
   allocating protected memory.
 - Allocate protected_phy_pages for memory regions if and only if the VM
   supports protected memory.
 - Rename kvm_host.h to kvm_util_arch.h, and move it to selftests/kvm where
   it belongs.
 - Fix up some SoB goofs.
 - Convert the intrahost SEV/SEV-ES migration tests to use common ioctl()
   wrappers.

V7
 * https://lore.kernel.org/all/20231218161146.3554657-1-pgonda@google.com
 * See https://github.com/sean-jc/linux/tree/x86/sev_selftests_for_peter.
 * I kept is_pt_protected because without it the page tables are never
 readable. Its used for the elf loading in kvm_vm_elf_load().

V6
 * Updated SEV VM create function based on Seanjc's feedback and new
   changes to VM creation functions.
 * Removed pte_me_mask based on feedback.
 * Fixed s_bit usage based on TDX
 * Fixed bugs and took Ackerly's code for enc_region setup code.

V5
 * Rebase onto seanjc@'s latest ucall pool series.
 * More review changes based on seanjc:
 ** use protected instead of encrypted outside of SEV specific files
 ** Swap memcrypt struct for kvm_vm_arch arch specific struct
 ** Make protected page table data agnostic of address bit stealing specifics
    of SEV
 ** Further clean up for SEV library to just vm_sev_create_one_vcpu()
 * Due to large changes moved more authorships from mroth@ to pgonda@. Gave
   originally-by tags to mroth@ as suggested by Seanjc for this.

V4
 * Rebase ontop of seanjc@'s latest Ucall Pool series:
   https://lore.kernel.org/linux-arm-kernel/20220825232522.3997340-8-seanjc@google.com/
 * Fix up review comments from seanjc
 * Switch authorship on 2 patches because of significant changes, added
 * Michael as suggested-by or originally-by.

V3
 * Addressed more of andrew.jones@ in ucall patches.
 * Fix build in non-x86 archs.

V2
 * Dropped RFC tag
 * Correctly separated Sean's ucall patches into 2 as originally
   intended.
 * Addressed andrew.jones@ in ucall patches.
 * Fixed ucall pool usage to work for other archs

V1
 * https://lore.kernel.org/all/20220715192956.1873315-1-pgonda@google.com/

Ackerley Tng (1):
  KVM: selftests: Add a macro to iterate over a sparsebit range

Michael Roth (2):
  KVM: selftests: Make sparsebit structs const where appropriate
  KVM: selftests: Add support for protected vm_vaddr_* allocations

Peter Gonda (5):
  KVM: selftests: Add support for allocating/managing protected guest
    memory
  KVM: selftests: Explicitly ucall pool from shared memory
  KVM: selftests: Allow tagging protected memory in guest page tables
  KVM: selftests: Add library for creating and interacting with SEV
    guests
  KVM: selftests: Add a basic SEV smoke test

Sean Christopherson (2):
  KVM: selftests: Extend VM creation's @shape to allow control of VM
    subtype
  KVM: selftests: Use the SEV library APIs in the intra-host migration
    test

 tools/testing/selftests/kvm/Makefile          |   2 +
 .../kvm/include/aarch64/kvm_util_arch.h       |   7 +
 .../selftests/kvm/include/kvm_util_base.h     |  50 ++++++-
 .../kvm/include/riscv/kvm_util_arch.h         |   7 +
 .../kvm/include/s390x/kvm_util_arch.h         |   7 +
 .../testing/selftests/kvm/include/sparsebit.h |  56 +++++---
 .../kvm/include/x86_64/kvm_util_arch.h        |  23 ++++
 .../selftests/kvm/include/x86_64/processor.h  |   8 ++
 .../selftests/kvm/include/x86_64/sev.h        | 110 +++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  67 +++++++--
 tools/testing/selftests/kvm/lib/sparsebit.c   |  48 +++----
 .../testing/selftests/kvm/lib/ucall_common.c  |   3 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  32 ++++-
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 128 ++++++++++++++++++
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |  67 +++------
 .../selftests/kvm/x86_64/sev_smoke_test.c     |  58 ++++++++
 16 files changed, 570 insertions(+), 103 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_smoke_test.c


base-commit: 60eedcfceda9db46f1b333e5e1aa9359793f04fb
-- 
2.43.0.594.gd9cf4e227d-goog


