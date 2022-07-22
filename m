Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3848957D81B
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 03:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiGVBu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 21:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGVBu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 21:50:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1EF18E17
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:50:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r64-20020a254443000000b006707b7c2baeso2601126yba.16
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Rhs+4jBfg1QM5n7eWG2/LdEIc5IyIGfWAsCL7NyPRwQ=;
        b=EPu9cfSmX3DAmdVD3SXg5Chipd7twxc2aYzKZWGdt9qqZYcXxOhVbYsm2Q4w3Keblq
         iOOY371rfBqvXTY6NybNQWreMp53L+rUZ1LTcNZne4JJDGcvaPks3Ru8OFBCCz30Qmwx
         4WD270XRYhRv/GvT+dVV1awsfHaNxwtD37r68MFhp9ELCmrImgLiyWRhaKkWDXkBoZnH
         s78qnShu3Azqth50MftuCULbQDS0/sGtGm8g1LRAArzgephpOZ9rxfyCLFfTxD4ZvsHo
         W0x7N5i+Yoy5MqKgYCuj6TnY2HyvX9xkkG6z1rNzJUm68C/cjwlYxsZY/ACE2sHzBlDO
         jhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Rhs+4jBfg1QM5n7eWG2/LdEIc5IyIGfWAsCL7NyPRwQ=;
        b=TdB5vLDLVHpxyayVfoBpVY13OEc7sNCob+ReHadxXAZ8U/HftOOFT2LRpXz3RzJYjx
         XA3l3AnHUnH3X+ASs9PUUJT93ecZUi4f0RlmuWA0tcNngM/WKRC/cHAvZvbaLPbmrj8R
         5uf/sKS1JiDdYyn1WTjiNDQUWc07JPELb4O50zM7fR4RQ1Sjq6K9+QheMkONA4L/H7w0
         tN3tuFXNcy9ehXtyoDUFH3Avm/4JVtm2rgsT8isfwQipfT6QmQoPZgFbyftPXHbG89as
         641ZCniGmgLjrT0ppW6MaPsjMFFgCQSHzU6YGCm8vNoQ56UWl0YkEZU6GikCaIBFQ7Nj
         +2bw==
X-Gm-Message-State: AJIora+mlnxtOyoCkHjP+u3fgcin9BkOcLPRD0u4LibMKduFbClCg04T
        gwUcoYFK/z5gcGGh6+LOj4rpQeA=
X-Google-Smtp-Source: AGRyM1s/pmWLb7/RVeSHgBd1PqQYRVoHVPsujzJ6L2UtPXkGfO1tJ3J+fcjlJoTgQYjpaF7llAnRI+U=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a5b:890:0:b0:670:8312:a52f with SMTP id
 e16-20020a5b0890000000b006708312a52fmr1197181ybq.139.1658454654329; Thu, 21
 Jul 2022 18:50:54 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:50:26 -0700
Message-Id: <20220722015034.809663-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 0/7] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
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

 Documentation/virt/kvm/api.rst   |  5 +--
 arch/arm64/include/asm/mte.h     | 62 ++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h |  3 +-
 arch/arm64/kernel/cpufeature.c   |  4 ++-
 arch/arm64/kernel/elfcore.c      |  2 +-
 arch/arm64/kernel/hibernate.c    |  2 +-
 arch/arm64/kernel/mte.c          | 17 +++++----
 arch/arm64/kvm/guest.c           | 18 ++++++----
 arch/arm64/kvm/mmu.c             | 55 ++++++++++++----------------
 arch/arm64/mm/copypage.c         |  6 ++--
 arch/arm64/mm/fault.c            |  4 ++-
 arch/arm64/mm/mteswap.c          |  5 ++-
 fs/proc/page.c                   |  1 +
 include/linux/page-flags.h       |  1 +
 include/trace/events/mmflags.h   |  7 ++--
 mm/huge_memory.c                 |  1 +
 16 files changed, 134 insertions(+), 59 deletions(-)

-- 
2.37.1.359.gd136c6c3e2-goog

