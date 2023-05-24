Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC71C70F700
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 14:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbjEXM6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 08:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjEXM6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 08:58:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AC699
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 05:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E19563D11
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 12:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA53AC433EF;
        Wed, 24 May 2023 12:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684933087;
        bh=dXieAErWnscQNyOpXYNYnpDKN62IcQnHBlJqUk3OEdY=;
        h=From:To:Cc:Subject:Date:From;
        b=aarb3mDhSTN8cYx5JC7IIF2bm7RKIQR5AomY3DXrgPG7mbecaYWwPzF0+nsro0s/6
         YUzmMJoB5P6lWKwTqs0rj3XyxcZyOv8L40eCt2RloxmrwhRpVTf9SQV36eqV0gZfRo
         f7KSXp+fwy5je9EPw21lwddqtyVx04UVlvZb/vzqHSw2C1XZ3tmSMdnYv28PP+7CBg
         7uI06yLsfkDvfImHxNgspTr0d1oT4h25LBoC+mMrD6Jb2IxKRFu76prfwchPpqLbzz
         MvxTilHjqBNLIdjX/PMpNYDxcs5oIVBgnroxVQE51tYBHl0HDcJSToCX8CbG8Q4fPN
         Ns9G2SrjZP4JA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q1o45-0002TJ-NN;
        Wed, 24 May 2023 13:58:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [GIC PULL] KVM/arm64 fixes for 6.4, take #2
Date:   Wed, 24 May 2023 13:57:57 +0100
Message-Id: <20230524125757.3631091-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, cohuck@redhat.com, tabba@google.com, jean-philippe@linaro.org, oliver.upton@linux.dev, qperret@google.com, steven.price@arm.com, will@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the second batch of fixes for 6.4: two interesting MMU-related
fixes that affect pKVM, a set of locking fixes, and the belated
emulation of Set/Way MTE CMO.

Please pull,

	M.

The following changes since commit c3a62df457ff9ac8c77efe6d1eca2855d399355d:

  Merge branch kvm-arm64/pgtable-fixes-6.4 into kvmarm-master/fixes (2023-05-11 15:26:01 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.4-2

for you to fetch changes up to a9f0e3d5a089d0844abb679a5e99f15010d53e25:

  KVM: arm64: Reload PTE after invoking walker callback on preorder traversal (2023-05-24 13:47:12 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.4, take #2

- Address some fallout of the locking rework, this time affecting
  the way the vgic is configured

- Fix an issue where the page table walker frees a subtree and
  then proceeds with walking what it has just freed...

- Check that a given PA donated to the gues is actually memory
  (only affecting pKVM)

- Correctly handle MTE CMOs by Set/Way

----------------------------------------------------------------
Fuad Tabba (1):
      KVM: arm64: Reload PTE after invoking walker callback on preorder traversal

Jean-Philippe Brucker (4):
      KVM: arm64: vgic: Fix a circular locking issue
      KVM: arm64: vgic: Wrap vgic_its_create() with config_lock
      KVM: arm64: vgic: Fix locking comment
      KVM: arm64: vgic: Fix a comment

Marc Zyngier (2):
      arm64: Add missing Set/Way CMO encodings
      KVM: arm64: Handle trap of tagged Set/Way CMOs

Will Deacon (1):
      KVM: arm64: Prevent unconditional donation of unmapped regions from the host

 arch/arm64/include/asm/kvm_pgtable.h  |  6 +++---
 arch/arm64/include/asm/sysreg.h       |  6 ++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 14 +++++++-------
 arch/arm64/kvm/hyp/pgtable.c          | 14 +++++++++++++-
 arch/arm64/kvm/sys_regs.c             | 19 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c       | 27 +++++++++++++++++++++------
 arch/arm64/kvm/vgic/vgic-its.c        | 14 ++++++++++----
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 10 ++++++++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 31 +++++++++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-mmio.c       |  9 ++-------
 arch/arm64/kvm/vgic/vgic-v2.c         |  6 ------
 arch/arm64/kvm/vgic/vgic-v3.c         |  7 -------
 arch/arm64/kvm/vgic/vgic-v4.c         |  3 ++-
 13 files changed, 112 insertions(+), 54 deletions(-)
