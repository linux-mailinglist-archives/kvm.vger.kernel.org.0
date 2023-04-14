Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24ADA6E295E
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 19:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjDNR3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 13:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjDNR3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 13:29:31 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB41572BE
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 10:29:26 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id i4-20020a056e020d8400b00325a80f683cso10926239ilj.22
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 10:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681493366; x=1684085366;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CdxlV/qJrfbk0nmBBq3BbD9lwu2BbDaIMqWYUqH+F9E=;
        b=YBajYMfiNBNMEPbqFMBxhQPNT80i6TrlD4ptmctM/MvszB5WlyTwGDbo7Lp97K1paI
         nms7vQX+AcU5hnIEwRxnhTMfEOFbEfGx7Xuh+zXn5Ybn8jKzIYZPSeUChNG0eMp+ZBbH
         wHepQxfSrO/LiedtmYgJmxZhYpU1M3aWIAukJP606zr5J9Im6rx0Ts25pOcmHxYGV7fX
         b/tsfu/ameXybvTPEUETBC35ydE2Xm/MpTsrWuoBa1kMg81hR8zfXOG3knS4MnkHT6cM
         j7SKFTxWJBVD53SK40/yx5I5d0u5w3iMwb2TgxjmIA07RnwmKlxFkxX5VN+/KHmK5UDV
         t1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493366; x=1684085366;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CdxlV/qJrfbk0nmBBq3BbD9lwu2BbDaIMqWYUqH+F9E=;
        b=iQ7ESqK6ck8+W6TAh64poBcZdkprmcdhgQiSh8annSdQoroOHPtH79PH1ATCw+EPYp
         SVP9HGlw2dR3tphvy32gNT5gRCbqoSzUT8FxW/N33xHFRXkz+VOxyUZ7PZj/mzWjBKdQ
         e6fO+zQoaHopfKEXD7ccDcbywehrvEyVl6h4CTj1QZoPPEJWlvRaI8PWsebdyiL7UlkM
         TfNnARzB8LIRabWNf1kM0El2mI+P7HM3isC02WaYI0N3DzvSMSqgkzUMDulwtO/NXHZI
         i/JBXthaPv1TD7oHRXGZMIHXppL+DACCen8kxSTbY283gbEmWuCik5/lF7UOPG82dres
         HmWQ==
X-Gm-Message-State: AAQBX9fKFDucdsSzTpVrmlOSsworYlGzINHNLoIvqN8YcFjL1P8eNcXS
        onZx45u3OPo1t7aTXYsp7X0eVU9kVaEz
X-Google-Smtp-Source: AKy350ZqA0XvOrP3OpRUR21SX5idv3uGJPyhkyL2LFX2G4N9rIvOMTEo6SfxQbbGKJpn8Iwoxk1/N0HpjjZ/
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5e:da44:0:b0:752:f092:3ddd with SMTP id
 o4-20020a5eda44000000b00752f0923dddmr2453614iop.1.1681493366319; Fri, 14 Apr
 2023 10:29:26 -0700 (PDT)
Date:   Fri, 14 Apr 2023 17:29:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230414172922.812640-1-rananta@google.com>
Subject: [PATCH v3 0/7] KVM: arm64: Add support for FEAT_TLBIRANGE
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In certain code paths, KVM/ARM currently invalidates the entire VM's
page-tables instead of just invalidating a necessary range. For example,
when collapsing a table PTE to a block PTE, instead of iterating over
each PTE and flushing them, KVM uses 'vmalls12e1is' TLBI operation to
flush all the entries. This is inefficient since the guest would have
to refill the TLBs again, even for the addresses that aren't covered
by the table entry. The performance impact would scale poorly if many
addresses in the VM is going through this remapping.

For architectures that implement FEAT_TLBIRANGE, KVM can replace such
inefficient paths by performing the invalidations only on the range of
addresses that are in scope. This series tries to achieve the same in
the areas of stage-2 map, unmap and write-protecting the pages.

Patch-1 refactors the core arm64's __flush_tlb_range() to be used by
other entities.

Patch-2 adds a range-based TLBI mechanism for KVM (VHE and nVHE).

Patch-3 implements the kvm_arch_flush_remote_tlbs_range() for arm64.

Patch-4 aims to flush only the memslot that undergoes a write-protect,
instead of the entire VM.

Patch-5 operates on stage2_try_break_pte() to use the range based
TLBI instructions when collapsing a table entry. The map path is the
immediate consumer of this when KVM remaps a table entry into a block.

Patch-6 Adds a 'skip_flush' parameter to stage2_put_pte() for the next
patch to take advantage of during TLB invalidations in unmap path.

Patch-7 modifies the stage-2 unmap path in which, if the system supports
FEAT_TLBIRANGE, the TLB invalidations are skipped during the page-table.
walk. Instead it's done in one go after the entire walk is finished.

The series is based off of upstream v6.3-rc5, and applied David
Matlack's common API for TLB invalidations[1] on top.

The performance evaluation was done on a hardware that supports
FEAT_TLBIRANGE, on a VHE configuration, using a modified
kvm_page_table_test.
The modified version updates the guest code in the ADJUST_MAPPINGS case
to not only access this page but also to access up to 512 pages
backwards
for every new page it iterates through. This is done to test the effect
of TLBI misses after KVM has handled a fault.

The series captures the impact in the map and unmap paths as described
above.

$ kvm_page_table_test -m 2 -v 128 -s anonymous_hugetlb_2mb -b $i

+--------+------------------------------+------------------------------+
| mem_sz |    ADJUST_MAPPINGS (s)       |      Unmap VM (s)            |
|  (GB)  | Baseline | Baseline + series | Baseline | Baseline + series |
+--------+----------|-------------------+------------------------------+
|   1    |   5.25   |   5.42            | 0.007     | 0.005            |
|   2    |   9.40   |   7.23            | 0.010     | 0.006            |
|   4    |  20.96   |  13.09            | 0.015     | 0.008            |
|   8    |  41.32   |  26.06            | 0.025     | 0.012            |
|  16    |  76.00   |  53.40            | 0.045     | 0.017            |
|  32    |  85.92   |  82.87            | 0.077     | 0.028            |
|  64    | 178.99   | 168.45            | 0.142     | 0.049            |
| 128    | 359.76   | 316.66            | 0.280     | 0.082            |
+--------+----------+-------------------+----------+-------------------+

$ kvm_page_table_test -m 2 -b 128G -s anonymous_hugetlb_2mb -v $i

+--------+------------------------------+
| vCPUs  |    ADJUST_MAPPINGS (s)       |
|        | Baseline | Baseline + series |
+--------+----------|-------------------+
|   1    | 130.84   | 139.65            |
|   2    |  91.42   | 105.49            |
|   4    |  98.83   |  97.68            |
|   8    | 108.28   | 104.90            |
|  16    | 110.69   | 108.28            |
|  32    | 146.47   | 120.02            |
|  64    | 204.04   | 185.88            |
| 128    | 359.76   | 316.66            |   
+--------+----------+-------------------+

For the ADJUST_MAPPINGS cases, which maps back the 4K table entries to
2M hugepages, the series sees an average improvement of ~15%. For
unmapping
2M hugepages, we see at least a 3x improvement.

$ kvm_page_table_test -m 2 -b $i

+--------+------------------------------+
| mem_sz |      Unmap VM (s)            |
|  (GB)  | Baseline | Baseline + series |
+--------+------------------------------+
|   1    |  1.03    |  0.58             |
|   2    |  1.57    |  0.72             |
|   4    |  2.65    |  0.98             |
|   8    |  4.77    |  1.54             |
|  16    |  9.06    |  2.57             |
|  32    | 17.60    |  4.41             |
|  64    | 34.72    |  8.92             |
| 128    | 68.92    | 17.70             |   
+--------+----------+-------------------+

The series sees an average gain of 4x when the guest backed by
PAGE_SIZE (4K) pages.

v3:
Thanks, Oliver for all the suggestions.
- The core flush API (__kvm_tlb_flush_vmid_range()) now checks if
  the system support FEAT_TLBIRANGE or not, thus elimiating the
  redundancy in the upper layers.
- If FEAT_TLBIRANGE is not supported, the implementation falls
  back to invalidating all the TLB entries with the VMID, instead
  of doing an iterative flush for the range.
- The kvm_arch_flush_remote_tlbs_range() doesn't return -EOPNOTSUPP
  if the system doesn't implement FEAT_TLBIRANGE. It depends on
  __kvm_tlb_flush_vmid_range() to do take care of the decisions
  and return 0 regardless of the underlying feature support.
- __kvm_tlb_flush_vmid_range() doesn't take 'level' as input to
  calculate the 'stride'. Instead, it always assumes PAGE_SIZE.
- Fast unmap path is eliminated. Instead, the existing unmap walker
  is modified to skip the TLBIs during the walk, and do it all at
  once after the walk, using the range-based instructions.

v2:
https://lore.kernel.org/all/20230206172340.2639971-1-rananta@google.com/
- Rebased the series on top of David Matlack's series for common
  TLB invalidation API[1].
- Implement kvm_arch_flush_remote_tlbs_range() for arm64, by extending
  the support introduced by [1].
- Use kvm_flush_remote_tlbs_memslot() introduced by [1] to flush
  only the current memslot after write-protect.
- Modified the __kvm_tlb_flush_range() macro to accepts 'level' as an
  argument to calculate the 'stride' instead of just using PAGE_SIZE.
- Split the patch that introduces the range-based TLBI to KVM and the
  implementation of IPA-based invalidation into its own patches.
- Dropped the patch that tries to optimize the mmu notifiers paths.
- Rename the function kvm_table_pte_flush() to
  kvm_pgtable_stage2_flush_range(), and accept the range of addresses to
  flush. [Oliver]
- Drop the 'tlb_level' argument for stage2_try_break_pte() and directly
  pass '0' as 'tlb_level' to kvm_pgtable_stage2_flush_range(). [Oliver]

v1:
https://lore.kernel.org/all/20230109215347.3119271-1-rananta@google.com/

Thank you.
Raghavendra

[1]:
https://lore.kernel.org/linux-arm-kernel/20230126184025.2294823-1-dmatlack@google.com/

Raghavendra Rao Ananta (7):
  arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
  KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
  KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
  KVM: arm64: Flush only the memslot after write-protect
  KVM: arm64: Invalidate the table entries upon a range
  KVM: arm64: Add 'skip_flush' arg to stage2_put_pte()
  KVM: arm64: Use TLBI range-based intructions for unmap

 arch/arm64/include/asm/kvm_asm.h   |   3 +
 arch/arm64/include/asm/kvm_host.h  |   3 +
 arch/arm64/include/asm/tlbflush.h  | 108 +++++++++++++++--------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  11 +++
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  39 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c       |  49 ++++++++++---
 arch/arm64/kvm/hyp/vhe/tlb.c       |  35 ++++++++++
 arch/arm64/kvm/mmu.c               |  13 +++-
 8 files changed, 198 insertions(+), 63 deletions(-)

-- 
2.40.0.634.g4ca3ef3211-goog

