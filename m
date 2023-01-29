Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5C1680113
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjA2TCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 14:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2TCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 14:02:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF3318B05
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 11:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A082B60DFC
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 19:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057AAC433D2;
        Sun, 29 Jan 2023 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675018919;
        bh=YnpKJqKcLnIwJIkX7NoOfZ/16Cr2rgVctiBXbHOFcx0=;
        h=From:To:Cc:Subject:Date:From;
        b=PV/JZF/q5kNb0JtHeSXCmk3eV8BMA/So5Lehm0SyjuJ6vGganDjWN0+OkR7PW5uVJ
         1MMb0zKUEhm1ZpEp5IdZhXiJkEafW3hSDo+MG1c3/b5nfFz5eFdNzj9wYSDIEE4ake
         9MV/tjmqQ8Yz+7H2DmZEu+byP2AXeyZ9UB8oZyMF0Q7OHdBB4cm86PZYeiR2VAB5g9
         +lXAN/DsYPc7CezuCBeQsY1zC10ENSGjLGqt9OfNtKP8hrcb+r2Eo3Z1KN0UYRpuNN
         NaAO7KB6V9HL6+A65NQWeGCWYqIMq91h8+Nl8nOJfLBwca6PWJ0j0C6I7wY80r6ODs
         BpDC0kgf2eegg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMCw8-005edw-Ru;
        Sun, 29 Jan 2023 19:01:57 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] kvm/arm64 fixes for 6.2, take #3
Date:   Sun, 29 Jan 2023 19:01:42 +0000
Message-Id: <20230129190142.2481354-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, gshan@redhat.com, oliver.upton@linux.dev, ricarkol@google.com, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

Paolo,

Here's the (hopefully) last batch of fixes for KVM/arm64 on 6.2. The
really important one addresses yet another non-CPU access to the vgic
memory, which needs to be suitably identified to avoid generating a
scary warning. The second half of the series fixes a bunch of
page-table walk tests after the kernel fix that went in earlier in
6.2.

Please pull,

	M.

The following changes since commit ef3691683d7bfd0a2acf48812e4ffe894f10bfa8:

  KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation (2023-01-21 11:02:19 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.2-3

for you to fetch changes up to 08ddbbdf0b55839ca93a12677a30a1ef24634969:

  KVM: selftests: aarch64: Test read-only PT memory regions (2023-01-29 18:49:08 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.2, take #3

- Yet another fix for non-CPU accesses to the memory backing
  the VGICv3 subsystem

- A set of fixes for the setlftest checking for the S1PTW
  behaviour after the fix that went in ealier in the cycle

----------------------------------------------------------------
Gavin Shan (3):
      KVM: arm64: Add helper vgic_write_guest_lock()
      KVM: arm64: Allow no running vcpu on restoring vgic3 LPI pending status
      KVM: arm64: Allow no running vcpu on saving vgic3 pending table

Ricardo Koller (4):
      KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
      KVM: selftests: aarch64: Do not default to dirty PTE pages on all S1PTWs
      KVM: selftests: aarch64: Fix check of dirty log PT write
      KVM: selftests: aarch64: Test read-only PT memory regions

 Documentation/virt/kvm/api.rst                     |  10 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  13 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   4 +-
 arch/arm64/kvm/vgic/vgic.h                         |  14 ++
 include/kvm/arm_vgic.h                             |   2 +-
 .../selftests/kvm/aarch64/page_fault_test.c        | 187 ++++++++++++---------
 6 files changed, 132 insertions(+), 98 deletions(-)
