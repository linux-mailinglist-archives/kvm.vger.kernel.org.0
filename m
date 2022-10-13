Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7ED5FDAD4
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJMN2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 09:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJMN2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 09:28:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B625927160
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E3FCB81E3F
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 13:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143B6C433D6;
        Thu, 13 Oct 2022 13:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665667719;
        bh=7qXYLfXPY0mId4qeNUYUUP+ocY1lWzzGimuibv53pf8=;
        h=From:To:Cc:Subject:Date:From;
        b=QvN6AmRAzltS5HKUQE0RXOLnSQb7prK5hOldTl9Ue51CAVa3AXFgUbeRlzkbf2FEj
         FTdrupsmEW426bZ6oKCYzW9cKqjC/ZrfqPUS6y5Zff3+GmUrvDCY5AaxWtC6ufFxA/
         hMd/DBSY3MdKoweB8FZcV//s02sQgwRaJ78xbEVGdEKw4Vs14S8g83mB8sPkzpxlNr
         hG2bgsMM8B7tjcvp3KnGibybQ7SJxFNxeVRlkNve+SkdxvkC1gV5HiRrEUe30+1uru
         3bOtwLqu1nnxnxtZw8Q13q0qSrWxVrzIhDXtcmQwN1/Cctrldga+f3BfJAk7SjYhYu
         Xquq7TnLCkDzQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oiyGK-00GJJF-RC;
        Thu, 13 Oct 2022 14:28:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.1, take #1
Date:   Thu, 13 Oct 2022 14:28:30 +0100
Message-Id: <20221013132830.1304947-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, gshan@redhat.com, oliver.upton@linux.dev, qperret@google.com, vdonnefort@google.com, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the first set of fixes for 6.1. The most interesting bit is
Oliver's fix limiting the S2 invalidation batch size the the largest
block mapping, solving (at least for now) the RCU stall problems we
have been seeing for a while. We may have to find another solution
when (and if) we decide to allow 4TB mapping at S2...

The rest is a set of minor selftest fixes as well as enabling stack
protection and profiling in the VHE code.

Please pull,

       M.

The following changes since commit b302ca52ba8235ff0e18c0fa1fa92b51784aef6a:

  Merge branch kvm-arm64/misc-6.1 into kvmarm-master/next (2022-10-01 10:19:36 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.1-1

for you to fetch changes up to 05c2224d4b049406b0545a10be05280ff4b8ba0a:

  KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test (2022-10-13 11:46:51 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.1, take #1

- Fix for stage-2 invalidation holding the VM MMU lock
  for too long by limiting the walk to the largest
  block mapping size

- Enable stack protection and branch profiling for VHE

- Two selftest fixes

----------------------------------------------------------------
Gavin Shan (1):
      KVM: selftests: Fix number of pages for memory slot in memslot_modification_stress_test

Oliver Upton (2):
      KVM: arm64: Work out supported block level at compile time
      KVM: arm64: Limit stage2_apply_range() batch size to largest block

Vincent Donnefort (1):
      KVM: arm64: Enable stack protection and branch profiling for VHE

Zenghui Yu (1):
      KVM: arm64: selftests: Fix multiple versions of GIC creation

 arch/arm64/include/asm/kvm_pgtable.h                 | 18 +++++++++++++-----
 arch/arm64/include/asm/stage2_pgtable.h              | 20 --------------------
 arch/arm64/kvm/hyp/Makefile                          |  5 +----
 arch/arm64/kvm/hyp/nvhe/Makefile                     |  3 +++
 arch/arm64/kvm/mmu.c                                 |  9 ++++++++-
 tools/testing/selftests/kvm/aarch64/vgic_init.c      |  4 ++--
 .../selftests/kvm/memslot_modification_stress_test.c |  2 +-
 7 files changed, 28 insertions(+), 33 deletions(-)
