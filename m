Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB47D9C929
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbfHZGVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:17 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33894 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZGVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:17 -0400
Received: by mail-pl1-f196.google.com with SMTP id d3so9512940plr.1;
        Sun, 25 Aug 2019 23:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PZm+QjbJpeqBhVMu1MgOUk3rJy79ptucuxQ3qToi7dY=;
        b=Hm/X9JFGAExB7v8O1zPkr2MP7YgJz3Rq+tx1WCNg56+4Ygck/hNaQd4g220ucrh7tA
         Va1+RBGcZuLZ54MO0BDbJBUUtMFimlPCl0Jm5SNkSGHHXbQV0+mEtsFbqE6Y0EN15yrA
         Cfew6qngvpq9DSIXSqtXSmBW8zBroGj7c575FcONqI2YvYywCJj7vWpHDumYLFKIYalM
         PKczgpO1341w/1ZRQFQ8nVtG6TlJEniMRrVTXQ2qp22PldfDLNdBmFzFsdzVcuxevVaW
         jcEY2vdYJfQCsdIqbFvYukGLVP/0dLHWaMQ0zO8gXvHqrQ6vrhfwCN2YizeDuYghfzWF
         UzTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PZm+QjbJpeqBhVMu1MgOUk3rJy79ptucuxQ3qToi7dY=;
        b=WCerSDS3HQ+OqDOI0AjwzGtxgOfKpirleBhDzIG69+cf4GGuRy0yxuKi5nTH1r2WcR
         UH1YVpAIZCoQYtzdUS+W2Eng8cXXsHh8on3iP0pd77T/b0o+Z/V7f0ijRkiiPAAFulbI
         G1yK0C4tSgW7tWAOT7mHd4e2r3b/P9cTZopc9f0jn6Qeu9kSvVpSLt4/p5KKsuDPnyvb
         bBnP1p8fvv/YFsHDGLzlrkJPPrp9vpAEOWGjIzLoY9Q8J/9t+16JFxDfIRojkfU1gv5V
         /WxR2zAWCLzZ+I5R5fC93/CKa42r04P79XSN3SRWAXVYyDOsEeG0H9slfJcw3DwR56vc
         d8kA==
X-Gm-Message-State: APjAAAWK536hcK048in4HHj1X2bKSQUavkxCZAqicYkRLWP6C82ZSTIk
        3uTLvh+fPRPWB0kBWGtHGA/VW8sHdAM=
X-Google-Smtp-Source: APXvYqy4Pxq8ePvhXfj+ZAEL0ONi8PwLIYEp460xuzoWgKidEAPDA9nf2CvkvUf9XQZ7ySRjIOHSAQ==
X-Received: by 2002:a17:902:96a:: with SMTP id 97mr10343227plm.264.1566800476205;
        Sun, 25 Aug 2019 23:21:16 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:15 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 00/23] KVM: PPC: BOok3S HV: Support for nested HPT guests
Date:   Mon, 26 Aug 2019 16:20:46 +1000
Message-Id: <20190826062109.7573-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series adds support for running a nested kvm guest which uses the hpt
(hash page table) mmu type.

Patch series based on v5.3-rc6.

The first 8 patches in this series enable a radix guest (L1) running under a
radix hypervisor (L0) to act as a guest hypervisor for it's own nested (L2)
guest where the nested guest is using hash page table translation. This mainly
involved ensuring that the guest hypervisor uses the new run_single_vcpu()
entry path and ensuring that the appropriate functions which are normally
called in the real mode entry path in book3s_hv_rmhandlers.S are called on the
new virtual mode entry path when a hpt guest is being run.

The remainder of the patches enable a (L0) hypervisor to perform hash page
table translation for a nested (L2) hpt guest which is running under one of
it's radix (L1) it's which is acting as a guest hypervisor. This primarily
required changes to the nested guest entry patch to ensure that a shadow hpt
would be allocated for the nested hpt guest, that the slb was context switched
and that the real mode entry path in book3s_hv_rmhandlers.S could be used to
enter/exit a nested hpt guest.

It was also necessary to be able to create translations by inserting ptes into
the shadow page table which provided the combination of the translation from L2
virtual address to L1 guest physical address and the translation from L1 guest
physical address to L0 host real address. Additionally invalidations of these
translations need to be handled at both levels, by L1 via the H_TLB_INVALIDATE
hcall to invalidate a L2 virtual address to L1 guest physical address
translation, and by L0 when paging out a L1 guest page which had been
subsequently mapped through to L2 thus invalidating the L1 guest physical
address to L0 host real address translation.

Still lacking support for:
Passthrough of emulated mmio devices to nested hpt guests since the current
method of reading nested guest memory relies on using quadrants which are only
available when using radix translation.

Paul Mackerras (1):
  KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT page fault
    handler

Suraj Jitindar Singh (22):
  KVM: PPC: Book3S HV: Increment mmu_notifier_seq when modifying radix
    pte rc bits
  KVM: PPC: Book3S HV: Nested: Don't allow hash guests to run nested
    guests
  KVM: PPC: Book3S HV: Handle making H_ENTER_NESTED hcall in a separate
    function
  KVM: PPC: Book3S HV: Enable calling kvmppc_hpte_hv_fault in virtual
    mode
  KVM: PPC: Book3S HV: Allow hpt manipulation hcalls to be called in
    virtual mode
  KVM: PPC: Book3S HV: Make kvmppc_invalidate_hpte() take lpid not a kvm
    struct
  KVM: PPC: Book3S HV: Nested: Allow pseries hypervisor to run hpt
    nested guest
  KVM: PPC: Book3S HV: Nested: Improve comments and naming of nest rmap
    functions
  KVM: PPC: Book3S HV: Nested: Increase gpa field in nest rmap to 46
    bits
  KVM: PPC: Book3S HV: Nested: Remove single nest rmap entries
  KVM: PPC: Book3S HV: Nested: add kvmhv_remove_all_nested_rmap_lpid()
  KVM: PPC: Book3S HV: Nested: Infrastructure for nested hpt guest setup
  KVM: PPC: Book3S HV: Nested: Context switch slb for nested hpt guest
  KVM: PPC: Book3S HV: Store lpcr and hdec_exp in the vcpu struct
  KVM: PPC: Book3S HV: Nested: Make kvmppc_run_vcpu() entry path nested
    capable
  KVM: PPC: Book3S HV: Nested: Rename kvmhv_xlate_addr_nested_radix
  KVM: PPC: Book3S HV: Separate out hashing from
    kvmppc_hv_find_lock_hpte()
  KVM: PPC: Book3S HV: Nested: Implement nested hpt mmu translation
  KVM: PPC: Book3S HV: Nested: Handle tlbie hcall for nested hpt guest
  KVM: PPC: Book3S HV: Nested: Implement nest rmap invalidations for hpt
    guests
  KVM: PPC: Book3S HV: Nested: Enable nested hpt guests
  KVM: PPC: Book3S HV: Add nested hpt pte information to debugfs

 arch/powerpc/include/asm/book3s/64/mmu-hash.h |   15 +
 arch/powerpc/include/asm/book3s/64/mmu.h      |    9 +
 arch/powerpc/include/asm/hvcall.h             |   36 -
 arch/powerpc/include/asm/kvm_asm.h            |    5 +
 arch/powerpc/include/asm/kvm_book3s.h         |   30 +-
 arch/powerpc/include/asm/kvm_book3s_64.h      |   87 +-
 arch/powerpc/include/asm/kvm_host.h           |   57 +
 arch/powerpc/include/asm/kvm_ppc.h            |    5 +-
 arch/powerpc/kernel/asm-offsets.c             |    5 +
 arch/powerpc/kvm/book3s.c                     |    1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |  136 ++-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |  167 +--
 arch/powerpc/kvm/book3s_hv.c                  |  327 ++++--
 arch/powerpc/kvm/book3s_hv_builtin.c          |   33 +-
 arch/powerpc/kvm/book3s_hv_interrupts.S       |   25 +-
 arch/powerpc/kvm/book3s_hv_nested.c           | 1381 ++++++++++++++++++++++---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c           |  298 ++++--
 arch/powerpc/kvm/book3s_hv_rmhandlers.S       |  126 ++-
 arch/powerpc/kvm/book3s_xive.h                |   15 +
 arch/powerpc/kvm/powerpc.c                    |    3 +-
 20 files changed, 2136 insertions(+), 625 deletions(-)

-- 
2.13.6

