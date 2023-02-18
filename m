Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5212C69B7E4
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 04:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBRDXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 22:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBRDXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 22:23:19 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD1D40E1
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:17 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-53655de27a1so31652507b3.14
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6ZCewEQd5vkrfkBY2DqxPlegfMd8h8RpUWFewGb6TNE=;
        b=OBOyWFM3UWZshRFcdEI8eXdPQ7ySSC7HX1+ng0wa520fiO2Ck958GcKHv2qlHnShDg
         8rUfqT4WxStsnN9ZMYno1keUPh5imI8ccZXm0LPPEPetdeFsjcVm78GsG4PoUIdn4po3
         /PWnVfUt3Qpou+PePKrTnRbDZxkYyMLnAPpuZno7ApJmEtxt9URTowjmLF0PfMUah/B+
         EsZTJhjSQnnaAdXCMFtuMgE4vlgGM1veSPaoaAOVOk+WJGDmxzx6sLlZ+7sJ9qocjRgi
         7lT0D1+UPM4x4C37+KuUKfWGtJlMilnvjJeRv9KsPwUAfg+45z26HqKIjln42V6NLE9z
         6tWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ZCewEQd5vkrfkBY2DqxPlegfMd8h8RpUWFewGb6TNE=;
        b=QnE0wL+nSXis4tcDBtcyvdoNStsYx5PLETf9aIwjQa3fWpjTxUhzu3EagFoB8VBq+f
         itsWLqvQyzMKDqZXhNhY0CkFfcxemeu+Ua3kexgn9SoGvWX8ckcNQ5I6p9b4JCHhLZw6
         Qcnv4nfCvOwwmqk1od+j6bY31jODnXbPpaRbcIKVASJPACGvwRYDIqxOoSXNcOQO2nqv
         1oeGk9lTY5QrXs7A3HWBILRCYjyQCcE54mlsRKKecegNiXZsaQanmJZsnuTIhOTSh7vw
         xH9i7DGUdmKsJ3lsxz2FYeSK9WPKBCNqJlq/wzXl4+mE7xzfOvbsCu904bJg9rCaM0hX
         +sAQ==
X-Gm-Message-State: AO0yUKWXAa3wVGPGFhUWlBB0hX7c2G6Bi9heDHF88DvsIn7W3Y8x0sY5
        afdpC4PLc19mKT6alSBWk70LP9595rbi3Q==
X-Google-Smtp-Source: AK7set8Tzb4cDOmF3DwYg8AHLy80Sr/Fr7dsKCFTsx7gFJABRL91kzR0pbdmZRBHPfoWgK5vzeDY5jc+UKBvTA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:8606:0:b0:52e:e6ed:308e with SMTP id
 w6-20020a818606000000b0052ee6ed308emr1258183ywf.526.1676690596794; Fri, 17
 Feb 2023 19:23:16 -0800 (PST)
Date:   Sat, 18 Feb 2023 03:23:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-1-ricarkol@google.com>
Subject: [PATCH v4 00/12] Implement Eager Page Splitting for ARM
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eager Page Splitting improves the performance of dirty-logging (used
in live migrations) when guest memory is backed by huge-pages.  It's
an optimization used in Google Cloud since 2016 on x86, and for the
last couple of months on ARM.

Background and motivation
=========================
Dirty logging is typically used for live-migration iterative copying.
KVM implements dirty-logging at the PAGE_SIZE granularity (will refer
to 4K pages from now on).  It does it by faulting on write-protected
4K pages.  Therefore, enabling dirty-logging on a huge-page requires
breaking it into 4K pages in the first place.  KVM does this breaking
on fault, and because it's in the critical path it only maps the 4K
page that faulted; every other 4K page is left unmapped.  This is not
great for performance on ARM for a couple of reasons:

- Splitting on fault can halt vcpus for milliseconds in some
  implementations. Splitting a block PTE requires using a broadcasted
  TLB invalidation (TLBI) for every huge-page (due to the
  break-before-make requirement). Note that x86 doesn't need this. We
  observed some implementations that take millliseconds to complete
  broadcasted TLBIs when done in parallel from multiple vcpus.  And
  that's exactly what happens when doing it on fault: multiple vcpus
  fault at the same time triggering TLBIs in parallel.

- Read intensive guest workloads end up paying for dirty-logging.
  Only mapping the faulting 4K page means that all the other pages
  that were part of the huge-page will now be unmapped. The effect is
  that any access, including reads, now has to fault.

Eager Page Splitting (on ARM)
=============================
Eager Page Splitting fixes the above two issues by eagerly splitting
huge-pages when enabling dirty logging. The goal is to avoid doing it
while faulting on write-protected pages. This is what the TDP MMU does
for x86 [0], except that x86 does it for different reasons: to avoid
grabbing the MMU lock on fault. Note that taking care of
write-protection faults still requires grabbing the MMU lock on ARM,
but not on x86 (with the fast_page_fault path).

An additional benefit of eagerly splitting huge-pages is that it can
be done in a controlled way (e.g., via an IOCTL). This series provides
two knobs for doing it, just like its x86 counterpart: when enabling
dirty logging, and when using the KVM_CLEAR_DIRTY_LOG ioctl. The
benefit of doing it on KVM_CLEAR_DIRTY_LOG is that this ioctl takes
ranges, and not complete memslots like when enabling dirty logging.
This means that the cost of splitting (mainly broadcasted TLBIs) can
be throttled: split a range, wait for a bit, split another range, etc.
The benefits of this approach were presented by Oliver Upton at KVM
Forum 2022 [1].

Implementation
==============
Patches 3-4 add a pgtable utility function for splitting huge block
PTEs: kvm_pgtable_stage2_split(). Patches 5-9 add support for eagerly
splitting huge-pages when enabling dirty-logging and when using the
KVM_CLEAR_DIRTY_LOG ioctl. Note that this is just like what x86 does,
and the code is actually based on it.  And finally, patch 9:

	KVM: arm64: Use local TLBI on permission relaxation

adds support for using local TLBIs instead of broadcasts when doing
permission relaxation. This last patch is key to achieving good
performance during dirty-logging, as eagerly breaking huge-pages
replaces mapping new pages with permission relaxation. Got this patch
(indirectly) from Marc Z.  and took the liberty of adding a commit
message.

Note: this applies on top of 6.2-rc6.

Performance evaluation
======================
The performance benefits were tested using the dirty_log_perf_test
selftest with 2M huge-pages.

The first test uses a write-only sequential workload where the stride
is 2M instead of 4K [2]. The idea with this experiment is to emulate a
random access pattern writing a different huge-page at every access.
Observe that the benefit increases with the number of vcpus: up to
5.76x for 152 vcpus. This table shows the guest dirtying time when
using the CLEAR ioctl (and KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2):

/dirty_log_perf_test_sparse -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2

	+-------+----------+------------------+
	| vCPUs | 6.2-rc3  | 6.2-rc3 + series |
	|       |    (ms)  |             (ms) |
	+-------+----------+------------------+
	|    1  |    2.63  |          1.66    |
	|    2  |    2.95  |          1.70    |
	|    4  |    3.21  |          1.71    |
	|    8  |    4.97  |          1.78    |
	|   16  |    9.51  |          1.82    |
	|   32  |   20.15  |          3.03    |
	|   64  |   40.09  |          5.80    |
	|  128  |   80.08  |         12.24    |
	|  152  |  109.81  |         15.14    |
	+-------+----------+------------------+

This secondv test measures the benefit of eager page splitting on read
intensive workloads (1 write for every 10 reads). As in the other
test, the benefit increases with the number of vcpus, up to 8.82x for
152 vcpus. This table shows the guest dirtying time when using the
CLEAR ioctl (and KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2):

./dirty_log_perf_test -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2 -w 10

	+-------+----------+------------------+
	| vCPUs | 6.2-rc3  | 6.2-rc3 + series |
	|       |   (sec)  |            (sec) |
	+-------+----------+------------------+
	|    1  |    0.65  |          0.07    |
	|    2  |    0.70  |          0.08    |
	|    4  |    0.71  |          0.08    |
	|    8  |    0.72  |          0.08    |
	|   16  |    0.76  |          0.08    |
	|   32  |    1.61  |          0.14    |
	|   64  |    3.46  |          0.30    |
	|  128  |    5.49  |          0.64    |
	|  152  |    6.44  |          0.63    |
	+-------+----------+------------------+

Changes from v3:
https://lore.kernel.org/kvmarm/20230215174046.2201432-1-ricarkol@google.com/
- KVM_PGTABLE_WALK_SKIP_CMO to use BIT(5). (Shaoqin)
- Rewritten commit message for "Rename free_unlinked to free_removed"
  using Oliver's suggestion. (Oliver)
- "un" -> "an" typo. (Shaoqin)
- kvm_pgtable_stage2_create_unlinked() to return a "kvm_pte_t *". (Oliver)
- refactored stage2_block_get_nr_page_tables(). (Oliver)
- /s/bock/block. (Shaoqin)

Changes from v2:
https://lore.kernel.org/kvmarm/20230206165851.3106338-1-ricarkol@google.com/
- removed redundant kvm_pte_table() check from split walker function. (Gavin)
- fix compilation of patch 8 by moving some definitions from path 9. (Gavin)
- add comment for kvm_mmu_split_nr_page_tables(). (Gavin)

Changes from v1:
https://lore.kernel.org/kvmarm/20230113035000.480021-1-ricarkol@google.com/
- added a capability to set the eager splitting chunk size. This
  indirectly sets the number of pages in the cache. It also allows for
  opting out of this feature. (Oliver, Marc)
- changed kvm_pgtable_stage2_split() to split 1g huge-pages
  using either 513 or 1 at a time (with a cache of 1). (Oliver, Marc)
- added force_pte arg to kvm_pgtable_stage2_create_removed().
- renamed free_removed to free_unlinked. (Ben and Oliver)
- added KVM_PGTABLE_WALK ctx->flags for skipping BBM and CMO, instead
  of KVM_PGTABLE_WALK_REMOVED. (Oliver)

Changes from the RFC:
https://lore.kernel.org/kvmarm/20221112081714.2169495-1-ricarkol@google.com/
- dropped the changes to split on POST visits. No visible perf
  benefit.
- changed the kvm_pgtable_stage2_free_removed() implementation to
  reuse the stage2 mapper.
- dropped the FEAT_BBM changes and optimization. Will send this on a
  different series.

Thanks,
Ricardo

Marc Zyngier (1):
  KVM: arm64: Use local TLBI on permission relaxation

Ricardo Koller (11):
  KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for skipping BBM and CMO
  KVM: arm64: Rename free_unlinked to free_removed
  KVM: arm64: Add helper for creating unlinked stage2 subtrees
  KVM: arm64: Add kvm_pgtable_stage2_split()
  KVM: arm64: Refactor kvm_arch_commit_memory_region()
  KVM: arm64: Add kvm_uninit_stage2_mmu()
  KVM: arm64: Export kvm_are_all_memslots_empty()
  KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
  KVM: arm64: Split huge pages when dirty logging is enabled
  KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
  KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG

 Documentation/virt/kvm/api.rst        |  26 ++++
 arch/arm64/include/asm/kvm_asm.h      |   4 +
 arch/arm64/include/asm/kvm_host.h     |  19 +++
 arch/arm64/include/asm/kvm_mmu.h      |   1 +
 arch/arm64/include/asm/kvm_pgtable.h  |  84 ++++++++++-
 arch/arm64/kvm/arm.c                  |  22 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    |  10 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |   6 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c         |  54 +++++++
 arch/arm64/kvm/hyp/pgtable.c          | 194 ++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c          |  32 +++++
 arch/arm64/kvm/mmu.c                  | 188 +++++++++++++++++++++----
 include/linux/kvm_host.h              |   2 +
 include/uapi/linux/kvm.h              |   1 +
 virt/kvm/kvm_main.c                   |   2 +-
 15 files changed, 591 insertions(+), 54 deletions(-)

-- 
2.39.2.637.g21b0678d19-goog

