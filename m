Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABADD668A65
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjAMDuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjAMDuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:04 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAC3108E
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:03 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id r7-20020a25c107000000b006ff55ac0ee7so21421671ybf.15
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e+n3gQai70ipJM8poF7SWn9TzUEiK7J1JAM5ZJ89/EI=;
        b=pa43ZjbSW1ATKmLvbtZJWF5ORCqJ0KG6qdElX+Ss5yiWyts1cHKV1G2NBeJaBpADhk
         tlj0aLl8ct/aQCydT69NtuL/6QJ7PFOfR9k6O/VZjYRzkYd2mGFboexHPz9CAgMusaKQ
         6aqQ2YuDzZVKU1emMlKL7SS9W4H/iZ7hHOMX1hyZP+dDiXqZGZcWrVUTYbtHdk1an5k2
         TwdywvbeK4ekigedT9YkcNLdnz4onx/Ishb3k11Ya1JVZrxJgHc+YdGYZzWKiymxWUzN
         XWTn8FogYjAgLrIGK5cGFPSVgBoYJKMF9N/speTwyNQxlKMFyd3zmSwS3jfSH+SYuUez
         ITlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e+n3gQai70ipJM8poF7SWn9TzUEiK7J1JAM5ZJ89/EI=;
        b=ZK9LdeMIVSBCqZ1Je/HNHoeg7F8yCAHj82pNOhJHLmC5xl7GGOSKFAQFBrlKrfW68z
         onrOwbW/PUUWjuKWXvzip3kb4xbzarG/9H3XkjZUvwPYHVCjaqyg5Y4p6zMkZVFnqrG2
         HewJDlbODtbaftIHJ6GxRVqV1EYWIJ/KzBEIKdL8J1qHOfF9K8x7sLM5XzZPIeeMmA3s
         4bf8a8LgY1rzULGH+5lKT91hY6BsQlF9zQbBnrXoQkeftKHZbmbIOpDPN4/cUagkpJq+
         hPjfzRo9mGEMIlp7en5A0I+XSWr9TBZvwJdOf9XrlHpukXGGHj0fjYCf6cspAxpYaKpU
         +ZIA==
X-Gm-Message-State: AFqh2krqkFDq8oqJPShzMTSUOnBnC8PT7UXsN0HzJkQ+RlkgISr5C73q
        ZE/gjsERuV/hyWnOmbG0XaI6Vyw1qzD71Q==
X-Google-Smtp-Source: AMrXdXte1MbGmBTxNvPIYCqxka+j6nvsrdlDKqAJVdPJkJwe2M1IJRUNbtwBblDZxXnJK//HRWU80I5Mc5Y4NA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9f0b:0:b0:6f0:f80e:9e87 with SMTP id
 n11-20020a259f0b000000b006f0f80e9e87mr8962883ybq.247.1673581802714; Thu, 12
 Jan 2023 19:50:02 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:51 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-1-ricarkol@google.com>
Subject: [PATCH 0/9] KVM: arm64: Eager Huge-page splitting for dirty-logging
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

Implement Eager Page Splitting for ARM.

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
Patches 1-3 add a pgtable utility function for splitting huge block
PTEs: kvm_pgtable_stage2_split(). Patches 4-8 add support for eagerly
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

Note: this applies on top of 6.2-rc3.

Performance evaluation
======================
The performance benefits were tested using the dirty_log_perf_test
selftest with 2M huge-pages.

The first test uses a write-only sequential workload where the stride
is 2M instead of 4K [2]. The idea with this experiment is to emulate a
random access pattern writing a different huge-page at every access.
Observe that the benefit increases with the number of vcpus: up to
5.76x for 152 vcpus.

./dirty_log_perf_test_sparse -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2

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

This second test measures the benefit of eager page splitting on read
intensive workloads (1 write for every 10 reads). As in the other
test, the benefit increases with the number of vcpus, up to 8.82x for
152 vcpus.

./dirty_log_perf_test -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2 -f 10

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

[0] https://lore.kernel.org/kvm/20220119230739.2234394-1-dmatlack@google.com/
[1] https://kvmforum2022.sched.com/event/15jJq/kvmarm-at-scale-improvements-to-the-mmu-in-the-face-of-hardware-growing-pains-oliver-upton-google
[2] https://github.com/ricarkol/linux/commit/f78e9102b2bff4fb7f30bee810d7d611a537b46d
[3] https://lore.kernel.org/kvmarm/20221107215644.1895162-1-oliver.upton@linux.dev/

Marc Zyngier (1):
  KVM: arm64: Use local TLBI on permission relaxation

Ricardo Koller (8):
  KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
  KVM: arm64: Add helper for creating removed stage2 subtrees
  KVM: arm64: Add kvm_pgtable_stage2_split()
  KVM: arm64: Refactor kvm_arch_commit_memory_region()
  KVM: arm64: Add kvm_uninit_stage2_mmu()
  KVM: arm64: Split huge pages when dirty logging is enabled
  KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
  KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG

 arch/arm64/include/asm/kvm_asm.h     |   4 +
 arch/arm64/include/asm/kvm_host.h    |  30 +++++
 arch/arm64/include/asm/kvm_mmu.h     |   1 +
 arch/arm64/include/asm/kvm_pgtable.h |  62 ++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  10 ++
 arch/arm64/kvm/hyp/nvhe/tlb.c        |  54 +++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 143 +++++++++++++++++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c         |  32 +++++
 arch/arm64/kvm/mmu.c                 | 168 ++++++++++++++++++++++-----
 9 files changed, 466 insertions(+), 38 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

