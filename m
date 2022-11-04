Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4A3618D73
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 02:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiKDBLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 21:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKDBLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 21:11:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E0F1F2E9
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 18:11:00 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id r126-20020a632b84000000b004393806c06eso1702686pgr.4
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 18:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MD4sMsdZ3Kj9lzVMKTpZ1mSgffrTJwexAbptSvbOBTs=;
        b=KAGDbvUBGRMCwSDrAXBTfRWpNauve+o6eufOssRdV8+ifYozwSybHg4nY9bJPm/KDt
         74XyI+eiTBQmG0nE2ysra4jkAYePQx4ZoS8wiT1TlV0xL01s8tqKePoWJk4W9r4Yo9nx
         Hn1hv2IdqZci+4cKUeAd+aRYtmRQ2qD9wSzI5+/pegF3BAxcWRWNNZcOMs2p+X4Lj36y
         Q6DEOEddA5LiwkUhytRm9r5yvfo8ERcuJtlFm3bNCGkJXMcL5pfFdvTr5U40J8iwDMu/
         Cyve//FTWDMlncsRKNKr4OxEqSFf1F4uq/IHjwwII/bX4GiFocJYFLcWJiDfp1W1Poih
         DyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MD4sMsdZ3Kj9lzVMKTpZ1mSgffrTJwexAbptSvbOBTs=;
        b=O7VwltiAnignEG6a12gO1pr6vMMGqhC4S7NW82BY96WSl6MQWPUobIveOamshlnKkP
         c0JttEsD1s7XZ43fNJjZC7YrW3DUmOqSlNWZfuuKPkQUeZGyg2kuIT75hVEmU0TrYdnb
         EQVGYSDKz+97Zkv1B86SewH4d5fcjyvveMsdSbfuBDsIm0IR9JUtdbtDQSDup95Yf9Fy
         SKHWQ//W91X6pVDLZL93O4UgnTj/ZuVvHpCrD1MecrJTglYOzhWYPo9WLlUFYopkWIfE
         KE0fieivzYzHDuGjg/MDrSt19qf34noVTU/u88GjIxL85VScUsTvVsJSjzj7f/Ig/rqq
         6R5g==
X-Gm-Message-State: ACrzQf0QBSOTyRDjx2A61LtF6krPwbWvnTUDvmjVb1jdvI1OQEYK3WSl
        AoTHbjZLVhReeFkJ/Q6IzbJWwk8=
X-Google-Smtp-Source: AMsMyM41C+IFtgA5t1c+69xBTRkwpvyPxjIzeGnprwRfU+qsGdt/Bl29bDMEYWzWzr8sDSkH76xhnvA=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a17:90a:1287:b0:20a:f469:7307 with SMTP id
 g7-20020a17090a128700b0020af4697307mr220586pja.213.1667524259464; Thu, 03 Nov
 2022 18:10:59 -0700 (PDT)
Date:   Thu,  3 Nov 2022 18:10:33 -0700
Message-Id: <20221104011041.290951-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 0/8] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
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

In this v5 I rebased Catalin's tree onto -next again. Please double check
my rebase, which resolved the conflict with commit a8e5e5146ad0 ("arm64:
mte: Avoid setting PG_mte_tagged if no tags cleared or restored").

I now have Reviewed-by for all patches except for the last one, which adds
the documentation. Thanks for the reviews so far, and please take a look!

I've tested it on QEMU as well as on MTE-capable hardware by booting a
Linux kernel and userspace under a crosvm with MTE support [3].

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
 arch/arm64/kernel/mte.c           | 21 +++++-----
 arch/arm64/kvm/guest.c            | 18 +++++----
 arch/arm64/kvm/mmu.c              | 55 +++++++++++---------------
 arch/arm64/mm/copypage.c          |  7 +++-
 arch/arm64/mm/fault.c             |  4 +-
 arch/arm64/mm/mteswap.c           | 16 +++-----
 fs/proc/page.c                    |  3 +-
 include/linux/kernel-page-flags.h |  1 +
 include/linux/page-flags.h        |  3 +-
 include/trace/events/mmflags.h    |  9 +++--
 mm/Kconfig                        |  8 ++++
 mm/huge_memory.c                  |  3 +-
 19 files changed, 152 insertions(+), 79 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

