Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2691D6BD764
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjCPRp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 13:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCPRp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 13:45:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC66923D90
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 10:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 591DA620CF
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A556BC433EF;
        Thu, 16 Mar 2023 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678988752;
        bh=N1P01DTJd4uVjYfwCW0Upba7xUoZtVgRhAG/ukULUy4=;
        h=From:To:Cc:Subject:Date:From;
        b=dL9Fb4tR+LyaksLVWeq3nNK5szOJaEghNyl5aontm0qutNQk3UavbeNDCgco3tih2
         nqCmWVjP1lyWFHsZsCnq4CsuiqQGqnGL2v17HFiQuosE827tjH/Dh+BNrI0nIrlDUM
         b7Rd5Aquz23nUpC6Wv8GAZZqTNP+cWMAcOukIuDuj/wrTBzUL+6PgD5EJFyS/nimZF
         qgvULMGVIM/jj2Ah7pbKZiP51RFFRkpIHnSM3ua2SP8e9rJCNXPsSkgPI20k6wSsG6
         iE0XAWVJf8yjxEdxFFEp7GWNY28Mk+CgKiRIsgQvAMdh0xFvZEIN74m4378GEeTqKP
         t08LcnqGoMNdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pcrfi-000eUs-DM;
        Thu, 16 Mar 2023 17:45:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: Plug a couple of MM races
Date:   Thu, 16 Mar 2023 17:45:44 +0000
Message-Id: <20230316174546.3777507-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ardb@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, dmatlack@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ard recently reported a really odd warning generated with KASAN, where
the page table walker we use to inspect the userspace page tables was
going into the weeds and accessing something that was looking totally
unrelated (and previously freed).

Will and I spent quite some time looking into it, and while we were
not able to reproduce the issue, we were able to spot at least a
couple of issues that could partially explain the issue.

The first course of action is to disable interrupts while walking the
userspace PTs. This prevents exit_mmap() from tearing down these PTs
by blocking the IPI. We also fail gracefully if the IPI won the race
and killed the page tables before we started the walk.

The second issue is to not use a VMA pointer that was obtained with
the mmap_read_lock held after that lock has been released. There is no
guarantee that it is still valid.

I've earmarked both for stable, though I expect backporting this to
older revisions of the kernel could be... interesting.

* From v1[1]:

  - Return -EAGAIN from get_user_mapping_size() when the mapping is
    gone instead of -EFAULT which would be fatal (which is still
    returned in cases that are not expected to be seen). Other error
    codes can also be returned from kvm_pgtable_get_leaf(), but always
    in conditions that are rather bad.

  - Rebased on top of kvmarm/fixes which already contains David's own
    MMU fix.

[1] https://lore.kernel.org/r/20230313091425.1962708-1-maz@kernel.org

Marc Zyngier (2):
  KVM: arm64: Disable interrupts while walking userspace PTs
  KVM: arm64: Check for kvm_vma_mte_allowed in the critical section

 arch/arm64/kvm/mmu.c | 53 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 9 deletions(-)

-- 
2.34.1

