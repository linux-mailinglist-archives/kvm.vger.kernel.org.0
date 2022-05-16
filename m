Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88046528496
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 14:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbiEPMwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 08:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbiEPMwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 08:52:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA3B38BD0
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 05:52:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 156B061209
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 12:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762ACC385AA;
        Mon, 16 May 2022 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652705529;
        bh=lMqrH8tUWPiPNpp7YGN4p4ypyHXlAjPKtD0Fl41tSJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=gcqzLdfgWD+vGB1UXhXVa1Mdoe/NiQKF8S4HMwqLc05eiSy9OqShf6jLUYCEeylh7
         zpgiZlU1J5+YPeFL1U41HUfAVVikwHQubO0In05+n30tl55iYWVgXeIlxMpLrtW5UD
         NmIz314S5DVW8jwQY81kjsJaj/FI+AWNxKxZNNAFblZOK2UgwIDdNaDZ4PiWglOyZP
         jPu3G/sSzlhXCyRd/tjmfZrT2f7/nenTW3sexkyHYduXnRXVRXLoEwAZxLC0reo/0N
         VLSgG2uAEwYsuV9uDo1f09bWQ1Ke3YkJ6mdVmnSciqONmV2psqRRzFHYFGKGIsnlOe
         dG83F1+xVYZhw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nqaCk-00Bc9J-FA; Mon, 16 May 2022 13:52:06 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.18, take #3
Date:   Mon, 16 May 2022 13:51:51 +0100
Message-Id: <20220516125151.955808-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oupton@google.com, peter.maydell@linaro.org, qperret@google.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's the third (and hopefully final) set of fixes for 5.18. Two
rather simple patches: one addressing a userspace-visible change in
behaviour with GICv3, and a fix for pKVM in combination with CPUs
affected by Spectre-v3a.

Please pull,

	M.

The following changes since commit 85ea6b1ec915c9dd90caf3674b203999d8c7e062:

  KVM: arm64: Inject exception on out-of-IPA-range translation fault (2022-04-27 23:02:23 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.18-3

for you to fetch changes up to 2e40316753ee552fb598e8da8ca0d20a04e67453:

  KVM: arm64: Don't hypercall before EL2 init (2022-05-15 12:14:14 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.18, take #3

- Correctly expose GICv3 support even if no irqchip is created
  so that userspace doesn't observe it changing pointlessly
  (fixing a regression with QEMU)

- Don't issue a hypercall to set the id-mapped vectors when
  protected mode is enabled

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: vgic-v3: Consistently populate ID_AA64PFR0_EL1.GIC

Quentin Perret (1):
      KVM: arm64: Don't hypercall before EL2 init

 arch/arm64/kvm/arm.c      | 3 ++-
 arch/arm64/kvm/sys_regs.c | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)
