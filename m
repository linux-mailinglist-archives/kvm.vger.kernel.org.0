Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E10A663380
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbjAIVyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbjAIVyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:54:02 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABA564D2
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:54:00 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id l14-20020a056e02066e00b0030bff7a1841so7152915ilt.23
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qh4aQqwoIxDY75NrOI6syNLOu17WdjWGb2uA8qx7SbY=;
        b=pcMhyoGDuhIX7xuSXz5sBbg1yUCyA1a+L8tUYd0YEw/kMUruFyC0feQtngDQrHRDc5
         tr/hm7w7pCZfpw2DJIWa/7UAAUp56kswXtlzRj1kyGEDVf36Z3bdH9oUkXOMRFIXxzcm
         bGhOesWoCPWSR/JltR67QsyNJctHLibheKE/TmKnrbGmoDD1NHEN3kOztqNs1AvKf8KN
         mOPbmUc7+Fpbw2RoLXylNEChdf/kYQVgjEVaq1IiUsPUpNHVonLJrjmnO5pZUyJXODg+
         6VOXKaQROwckVtp0B7HyQrg0uWP6LV7sCa4IryKymfe8CWm88yBlcPSc5c5xMpm29ujX
         ioHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qh4aQqwoIxDY75NrOI6syNLOu17WdjWGb2uA8qx7SbY=;
        b=4k5GjY6BUQZMB/x7y16+b1ImAphDk4BxmzgX6jWhoPzU5Jk9yScvLlePWQWQA36Wui
         pFiDY228QgsVCxO0puQd9Ug1v9rc7ndCshVOO/V3EIbd05/LUk2/UwmgnuUuNAGYPeK1
         TARUB8y5/mF4Vn3zkRWt+m8+akg4Tdi1gZZoPAsXsJFBdWBD66ceL+5mSR2Hpt9pstlr
         ukuYwOAmjyrnXKxIKQTDtjV+GdeK4m+9jyGsFrdHFLvl1WQYNWlG922RLomwjd4JdPQS
         GRuX50ttKuy5d70OL5hn91a4WHw+y531v815FtIwuAn0DK781JJIKK3R0hTj0LlmqLMe
         qsBw==
X-Gm-Message-State: AFqh2krdT25Z0eAj9hutu7C2TToXYsPTY8RIhj8gc9pHLDZ2HxL4megy
        AJaD+g/zZuO+dR3uTeKRxLKLSqcV7YNk
X-Google-Smtp-Source: AMrXdXvT1YfO93sttvLNbLeQ8f681QIip3w70DiYwuvV9L4YgorHFf3EEGWzHjGKd8sogUDPLYG2iE6TEWwP
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6638:4497:b0:38a:46d2:18a5 with SMTP
 id bv23-20020a056638449700b0038a46d218a5mr6035764jab.155.1673301240170; Mon,
 09 Jan 2023 13:54:00 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:53:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109215347.3119271-1-rananta@google.com>
Subject: [RFC PATCH 0/6] KVM: arm64: Add support for FEAT_TLBIRANGE
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

In certain code paths, KVM/ARM currently invalidates the entire VM's
page-tables instead of just invalidating a necessary range. For example,
when collapsing a table PTE to a block PTE, instead of iterating over
each PTE and flushing them, KVM uses 'vmalls12e1is' to flush all the
entries. This is inefficient since the guest would have to refill
the TLBs again, even for the addresses that aren't covered by the table
entry. The performance impact would scale poorly if many addresses in
the VM is going through this remapping.

For architectures that implement FEAT_TLBIRANGE, KVM can replace such
inefficient paths by performing the invalidations only on the range of
addresses that are in scope. This series tries to achieve the same.

Patch-1 refactors the core arm64's __flush_tlb_range() to be used by
other entities.

Patch-2 adds support to flush a range of IPAs for KVM.

Patch-3 defines a generic KVM function, kvm_flush_remote_tlbs_range(),
to be used in upcoming patches. The patch uses this in the MMU notifier
handlers to perform the flush only for a certain range of addresses.

Patch-4 optimizes the dirty-logging path to flush the TLBs using
the range based functions.

Patch-5 operates on stage2_try_break_pte() to use the range based
TLBI instructions when breaking a table entry. The map path is the
immediate consumer of this when KVM remaps a table entry into a block.

Patch-6 introduces a fast stage-2 unmap path in which, for the right
conditions, instead of traversing each and every PTE and unmapping them,
disconnect the PTE at a higher level (say at level-1 for a 4K pagesize)
and unmap the table entries using free_removed_table(). This would allow
KVM to use the range based TLBI to flush the entire range govered at
that level.

The series is based off of kvmarm-next.

The performance evaluation was done on a hardware that supports
FEAT_TLBIRANGE, on a VHE configuration, using the kvm_page_table_test.
Currently, the series captures the impact in the map and unmap paths as
described above.

kvm_page_table_test -m 2 -v 128 -s anonymous_hugetlb_2mb -b $i

+--------+------------------------------+------------------------------+
| mem_sz |    ADJUST_MAPPINGS           |      Unmap VM                |
|  (GB)  | next (s) | next + series (s) | next (s) | next + series (s) |
+--------+----------|-------------------+------------------------------+
|   1    | 0.70     | 0.73              | 0.50     | 0.50              |
|   2    | 0.91     | 0.97              | 0.50     | 0.50              |
|   4    | 1.47     | 1.48              | 0.51     | 0.51              |
|   8    | 2.25     | 2.43              | 0.52     | 0.51              |
|  16    | 4.09     | 4.60              | 0.54     | 0.54              |
|  32    | 7.77     | 8.99              | 0.58     | 0.61              |
|  64    | 16.73    | 17.50             | 0.66     | 0.7               |
| 128    | 30.45    | 35.55             | 0.80     | 0.77              |    
+--------+----------+-------------------+----------+-------------------+

Unfortunately, the performance of ADJUST_MAPPINGS gets degraded with
increase in memory size. Upon closely profiling, __kvm_tlb_flush_vmid(),
that the baseline uses to flush takes an averge of 73.2 us, while
__kvm_tlb_flush_range_vmid_ipa(), that the series uses costs, 208.1 us.
That is a regression of ~2.8x per flush when breaking the PTE, and could
be the reason why ADJUST_MAPPING's performance degreades with size.

On the other hand, the unmap's performance is almost on par with the
baseline for 2M hugepages. However, the fast unmap path's performance is
significatly improved by 3-4x when the guest is backed by 4K pages. This
is expected as the number of PTEs that we traverse for 4K mappings is
significantly larger than 2M hugepages, which the fast path is avoiding.

kvm_page_table_test -m 2 -v 1 -b $i

+--------+------------------------------+
| mem_sz |      Unmap VM                |
|  (GB)  | next (s) | next + series (s) |
+--------+------------------------------+
|   1    | 1.03     | 1.05              |
|   2    | 1.57     | 1.19              |
|   4    | 2.61     | 1.45              |
|   8    | 4.69     | 1.96              |
|  16    | 8.84     | 3.03              |
|  32    | 18.07    | 4.80              |
|  64    | 36.62    | 8.56              |
| 128    | 66.81    | 17.18             |    
+--------+----------+-------------------+

I'm looking for the suggestions/comments on the following from the
reviewers:

1. Given the poor performance of the TLBI range instructions against the
global VM flush, is there a room to improve the implementation of
__kvm_tlb_flush_range() (patch-2)?

2. When the series switches from a global flush to a range based flush
in the map path (patch-5), we'd expect fewer TLB misses and improved
guest performance. This performance is not yet measured. Is there any
upstream test that can meaure this?

Thank you.
Raghavendra

Raghavendra Rao Ananta (6):
  arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
  KVM: arm64: Add support for FEAT_TLBIRANGE
  KVM: Define kvm_flush_remote_tlbs_range
  KVM: arm64: Optimize TLBIs in the dirty logging path
  KVM: arm64: Optimize the stage2 map path with TLBI range instructions
  KVM: arm64: Create a fast stage-2 unmap path

 arch/arm64/include/asm/kvm_asm.h   |  21 ++++++
 arch/arm64/include/asm/tlbflush.h  | 107 +++++++++++++++--------------
 arch/arm64/kvm/arm.c               |   7 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  11 +++
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  24 +++++++
 arch/arm64/kvm/hyp/pgtable.c       |  73 ++++++++++++++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c       |  20 ++++++
 arch/arm64/kvm/mmu.c               |  12 +++-
 include/linux/kvm_host.h           |   1 +
 virt/kvm/kvm_main.c                |   7 +-
 10 files changed, 223 insertions(+), 60 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

