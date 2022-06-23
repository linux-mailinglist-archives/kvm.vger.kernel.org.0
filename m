Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0824155741F
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 09:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiFWHmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 03:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiFWHmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 03:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABA446B13
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 00:42:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C03A861B40
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6E8C3411B;
        Thu, 23 Jun 2022 07:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655970128;
        bh=WML9r1cd5wF+m6iAIdB7bqD8vB6+5Fw1VRXN0c4B/rg=;
        h=From:To:Cc:Subject:Date:From;
        b=Y4SlPpdJ166I/PwZ//gpYEgSmN23VZGi5nLRncVg1iYd48LBXZW/JIzklAy6pBQvb
         Klmt3aI0DpKlV1j22lKbtNUVLnol6ebXN+BHlF8z/IWlloT5R65Xr1bJbaSpqzOyei
         cSx6WwGJI75qd1WyRgBDwOV8gxGm5b4rME1zcBOeK8qgeSb5SEYtV65uTy0/nougwj
         5awBF/DPxeSeKfALwwzwl2Czgv9QKQ3lOH+Y68ah6ehJRi/J/wIKH3fzKweaDE97qI
         KnNA3AR/Ao3b50jAgKEuJDss7O1O2xfK62UQyZgH4n9seaiMszp5nAKTEGEUViG6TQ
         m4beyr0ibv6rQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o4HTY-002WLt-Hu;
        Thu, 23 Jun 2022 08:42:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mike Rapoport <rppt@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 fixes for 5.19, take #2
Date:   Thu, 23 Jun 2022 08:41:58 +0100
Message-Id: <20220623074158.1429243-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, rppt@kernel.org, oupton@google.com, qperret@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Only two minor items this time around: a fix for a kmemleak regression
courtesy of Quentin, and the addition of Oliver Upton as an official
reviewer for the arm64 side.

Please pull,

	M.


The following changes since commit bcbfb588cf323929ac46767dd14e392016bbce04:

  KVM: arm64: Drop stale comment (2022-06-09 13:24:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.19-2

for you to fetch changes up to cbc6d44867a24130ee528c20cffcbc28b3e09693:

  KVM: arm64: Add Oliver as a reviewer (2022-06-17 09:49:41 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 5.19, take #2

- Fix a regression with pKVM when kmemleak is enabled

- Add Oliver Upton as an official KVM/arm64 reviewer

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Add Oliver as a reviewer

Quentin Perret (1):
      KVM: arm64: Prevent kmemleak from accessing pKVM memory

 MAINTAINERS          | 1 +
 arch/arm64/kvm/arm.c | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)
