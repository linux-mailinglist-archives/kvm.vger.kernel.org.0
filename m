Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65E5BF50B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiIUDw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiIUDwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:52:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF0626578
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:52:54 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v5-20020a2583c5000000b006964324be8cso4022048ybm.14
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date;
        bh=MzLSXN9659oMN46VAD3QaEqmFer6u1utIpA2UG+9EdQ=;
        b=teECItsEgFfiTvj51+jcO1iNDgFfQ1pKS0sNjOrJ004BNZAuTGOtdrc+2SXYPpQEOr
         1WGJ7RS4jjKQewkJMEdGDYCrhjHTEQkp0b9LaLRRapaVhmUbpOUvZpICfzSfIwCunJ4p
         0Q1DUx62655IPzl7V9K7RggL1J+64ahObLuOwj6qQzw1cmFo21eOzv095sOJ+7JiImre
         7XJpq78XYQ4vEYYXAl0QHFuYz97QeOt3GTnT6WqlBwIcNTet16bb1UwBhFLd8JBym/Ir
         T05UcoxEdMMBPXJYC7yvod1Ootxtooo4jVc47DQ7v0TSRG5wWa8MvcH0tTtI8yoA7YI3
         +mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=MzLSXN9659oMN46VAD3QaEqmFer6u1utIpA2UG+9EdQ=;
        b=PV/xYPa16l4WrDhs0vN0a+xh/6NlHbIxoF59Wsh2hPQZYW6l/g7hDoGAPONXdkJ6qO
         mHHa3PrO9XbG4UXAXuh4wuzAjd9n3SJlRYKfjRxfamBkh6utpr9eCHQ5cUG2VyexXDkJ
         0C0ijwAUWb7GCRsc8hzxK2pSw41npyg1oN57ikVBgpXas7xZFMHq5kK31zYIEyrUv6gF
         xNF3GCl34uQc16SOHiUe9MEz3JCi04Mqj87/vF7Qz6oWE7gx2bgOfID9+BcKt6h1D3aV
         HR/Mmz96FcB5Itz9+IdOBsvhfu0nKarZumH1JPKP+6z4wvFucBAMfshSIfppHH4JE3nJ
         pLuw==
X-Gm-Message-State: ACrzQf3sk7e0Z3fsPsoVFVtItVvE5FbA9lHG9FSk759Jnx6s4XhVkxbI
        hpi7Rl27l5L2AltzqbdaBhNv6hI=
X-Google-Smtp-Source: AMsMyM6p1o6DZc1El2WX74JXWnrje6NxwPNf5KdOg0qnIgai24Z40ItJ6/xIIeE3xlynhFeSvJWE/Xs=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a81:910:0:b0:349:b5c1:4086 with SMTP id
 16-20020a810910000000b00349b5c14086mr22866786ywj.98.1663732373777; Tue, 20
 Sep 2022 20:52:53 -0700 (PDT)
Date:   Tue, 20 Sep 2022 20:51:32 -0700
Message-Id: <20220921035140.57513-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 0/8] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch series allows VMMs to use shared mappings in MTE enabled
guests. The first five patches were taken from Catalin's tree [1] which
addressed some review feedback from when they were previously sent out
as v3 of this series. The first patch from Catalin's tree makes room
for an additional PG_arch_3 flag by making the newer PG_arch_* flags
arch-dependent. The next four patches are based on a series that
Catalin sent out prior to v3, whose cover letter [2] I quote from below:

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

I rebased Catalin's tree onto -next and added the proposed userspace
enablement patches after the series. I've tested it on QEMU as well as
on MTE-capable hardware by booting a Linux kernel and userspace under
a crosvm with MTE support [3].

[1] git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux devel/mte-pg-flags
[2] https://lore.kernel.org/all/20220705142619.4135905-1-catalin.marinas@arm.com/
[3] https://chromium-review.googlesource.com/c/crosvm/crosvm/+/3892141

Catalin Marinas (4):
  mm: Do not enable PG_arch_2 for all 64-bit architectures
  arm64: mte: Fix/clarify the PG_mte_tagged semantics
  KVM: arm64: Simplify the sanitise_mte_tags() logic
  arm64: mte: Lock a page for MTE tag initialisation

Peter Collingbourne (4):
  mm: Add PG_arch_3 page flag
  KVM: arm64: unify the tests for VMAs in memslots when MTE is enabled
  KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE enabled
  Documentation: document the ABI changes for KVM_CAP_ARM_MTE

 Documentation/virt/kvm/api.rst    |  5 ++-
 arch/arm64/Kconfig                |  1 +
 arch/arm64/include/asm/mte.h      | 65 ++++++++++++++++++++++++++++++-
 arch/arm64/include/asm/pgtable.h  |  4 +-
 arch/arm64/kernel/cpufeature.c    |  4 +-
 arch/arm64/kernel/elfcore.c       |  2 +-
 arch/arm64/kernel/hibernate.c     |  2 +-
 arch/arm64/kernel/mte.c           | 16 ++++----
 arch/arm64/kvm/guest.c            | 18 +++++----
 arch/arm64/kvm/mmu.c              | 55 +++++++++++---------------
 arch/arm64/mm/copypage.c          |  7 +++-
 arch/arm64/mm/fault.c             |  4 +-
 arch/arm64/mm/mteswap.c           | 13 ++++---
 fs/proc/page.c                    |  3 +-
 include/linux/kernel-page-flags.h |  1 +
 include/linux/page-flags.h        |  3 +-
 include/trace/events/mmflags.h    |  9 +++--
 mm/Kconfig                        |  8 ++++
 mm/huge_memory.c                  |  3 +-
 19 files changed, 152 insertions(+), 71 deletions(-)

-- 
2.37.3.968.ga6b4b080e4-goog

