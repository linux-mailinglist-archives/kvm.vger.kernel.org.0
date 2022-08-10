Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65A458F31D
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiHJTaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiHJTak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:30:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6CC66A5D
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m123-20020a253f81000000b0066ff6484995so12939589yba.22
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=1di/tt6ciXP+w3o/5q4XLldJe644DuKYm0Az9ViiC4I=;
        b=AzSz35DDsHcjaP6qfQYWUXAmnpUTMzrq+S9wxbQ6YASgGJtYseIgCVALZTXZLBBh6h
         TlI8UPji2eQtQQDx15SApQOZMsowyWhCJXr5ElbnZqyt+LK01lN5p+hCZ6qEoenAAIDz
         q+OnhuChs9jcmHZkPQdyMp8lm+MgdnNY2m71pkhUYIcfuKr48YUXdx3TUqzmK8aBLnTG
         iqfu++8u/0bPEgzUSjEbVUcXxEoKE4GQctSb/3U7n5tr/b8DgFKFKc2wjZV73qxA6Rq6
         wlU2R3O5jN/lb80Hp8mxAtDf00IzDPcteKaMzuTRhWBhqlsTMSGVlQPSz1iqW45o9U1e
         NxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=1di/tt6ciXP+w3o/5q4XLldJe644DuKYm0Az9ViiC4I=;
        b=reu9aErQOrZX5QpHN857n+CbzTJvjudpmN0Kt48K1H9XziWoStKTm9j0SRBJw7iCCx
         09e9NXAP8KnLVa2P9MMxcYrUm73bA1qU6BCQFqz55FiDeXs3J0lgcTSiTH3Rrh+LtuUe
         I9Hg9EEGIaJ5SNnnWH1jDCR5Exz5AfvQwjYDFpm6c0ykjFgqUtPJ/Zkh6B5cz6YtOORm
         bnRELT/ukaMsE5WNfqRd7w73h6Lf2cRrHlXyU0WIqcJCDmXyKg+kmM2DehxR6fCCn5J2
         Ncz7e+1VagqmuI3fEXjhQ3gufSdsGFNSStA1N68kvY8hTxFOvFDqMsc+dmJ+jFVRbFnx
         nt7w==
X-Gm-Message-State: ACgBeo0wQ+G/SQ8uTyHZsqpr5pWYHnTuONwShkP9XbfLh/l5GaKa6l1N
        sxAZACJf6JKQ9IjHNz9xE0lOLYk=
X-Google-Smtp-Source: AA6agR4MYoEAPEEGe/xF/Ddp+XkcPsty64vZpHzAiVCbe2OV1iXIkQhzrbTI7V5lKnz380bWoms/WIc=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a25:790d:0:b0:670:6032:b1df with SMTP id
 u13-20020a25790d000000b006706032b1dfmr25551772ybc.629.1660159837207; Wed, 10
 Aug 2022 12:30:37 -0700 (PDT)
Date:   Wed, 10 Aug 2022 12:30:26 -0700
Message-Id: <20220810193033.1090251-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 0/7] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch series allows VMMs to use shared mappings in MTE enabled
guests. The first four patches are based on the series that Catalin sent
out, whose cover letter [1] I quote from below:

> This series aims to fix the races between initialising the tags on a
> page and setting the PG_mte_tagged flag. Currently the flag is set
> either before or after that tag initialisation and this can lead to CoW
> copying stale tags. The first patch moves the flag setting after the
> tags have been initialised, solving the CoW issue. However, concurrent
> mprotect() on a shared mapping may (very rarely) lead to valid tags
> being zeroed.
>
> The second skips the sanitise_mte_tags() call in kvm_set_spte_gfn(),
> deferring it to user_mem_abort(). The outcome is that no
> sanitise_mte_tags() can be simplified to skip the pfn_to_online_page()
> check and only rely on VM_MTE_ALLOWED vma flag that can be checked in
> user_mem_abort().
>
> The third and fourth patches use PG_arch_3 as a lock for page tagging,
> based on Peter Collingbourne's idea of a two-bit lock.
>
> I think the first patch can be queued but the rest needs some in depth
> review and test. With this series (if correct) we could allos MAP_SHARED
> on KVM guest memory but this is to be discussed separately as there are
> some KVM ABI implications.

I rebased Catalin's series onto -next, addressed the issues that I
identified in the review and added the proposed userspace enablement
patches after the series.

[1] https://lore.kernel.org/all/20220705142619.4135905-1-catalin.marinas@arm.com/

Catalin Marinas (3):
  arm64: mte: Fix/clarify the PG_mte_tagged semantics
  KVM: arm64: Simplify the sanitise_mte_tags() logic
  arm64: mte: Lock a page for MTE tag initialisation

Peter Collingbourne (4):
  mm: Add PG_arch_3 page flag
  KVM: arm64: unify the tests for VMAs in memslots when MTE is enabled
  KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE enabled
  Documentation: document the ABI changes for KVM_CAP_ARM_MTE

 Documentation/virt/kvm/api.rst    |  5 ++-
 arch/arm64/include/asm/mte.h      | 62 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h  |  3 +-
 arch/arm64/kernel/cpufeature.c    |  4 +-
 arch/arm64/kernel/elfcore.c       |  2 +-
 arch/arm64/kernel/hibernate.c     |  2 +-
 arch/arm64/kernel/mte.c           | 17 ++++++---
 arch/arm64/kvm/guest.c            | 18 +++++----
 arch/arm64/kvm/mmu.c              | 55 +++++++++++----------------
 arch/arm64/mm/copypage.c          |  6 ++-
 arch/arm64/mm/fault.c             |  4 +-
 arch/arm64/mm/mteswap.c           |  5 ++-
 fs/proc/page.c                    |  1 +
 include/linux/kernel-page-flags.h |  1 +
 include/linux/page-flags.h        |  1 +
 include/trace/events/mmflags.h    |  7 ++--
 mm/huge_memory.c                  |  1 +
 tools/vm/page-types.c             |  2 +
 18 files changed, 137 insertions(+), 59 deletions(-)

-- 
2.37.1.559.g78731f0fdb-goog

