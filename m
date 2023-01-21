Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EA06765DB
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 12:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjAULI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Jan 2023 06:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjAULI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Jan 2023 06:08:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9748C518C5
        for <kvm@vger.kernel.org>; Sat, 21 Jan 2023 03:08:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFAA3CE08D0
        for <kvm@vger.kernel.org>; Sat, 21 Jan 2023 11:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F79C433EF;
        Sat, 21 Jan 2023 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674299333;
        bh=47y4G5mTxnqndK19ipCK8qSV1r62Ibu+XDQrarb4elY=;
        h=From:To:Cc:Subject:Date:From;
        b=uD50DZVvbU99h0bvoxA1kEF02FVPw3nRZ89d4ESCcba5yOgdwzHSqL/H4VrZOee/f
         rojtboO92YzuIa8N1t1l2eNgWXaQ5/b1cw1MkSdhSo2zoF5fU2PjSMY4j9gLVZ5be5
         k7UoEPBNHt4PFpJNopWqX+GlwOhyPb+F4tcep+7BKx6UKV+HQrCYgFEel4LLJfjpGE
         pFqARrnFoAG2IH9R5laYxDTzdfV541XFntfG5qXdk5E4XetyCC8Lf3ocoNTV3NVpK4
         J+HgvY5+8Y4WUqVYnkcI1VCiLhweYxR4LWb1VfTTn695/YdqDx8/KfPdcCri9iR1mM
         Fhu/mWTmCFZ+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pJBju-003cmz-NU;
        Sat, 21 Jan 2023 11:08:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.2, take #2
Date:   Sat, 21 Jan 2023 11:08:37 +0000
Message-Id: <20230121110837.3216901-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, cohuck@redhat.com, oliver.upton@linux.dev, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

Hi Paolo,

Here's a small set of important 6.2 fixes for KVM/arm64. We have a MTE
fix after the recent changes that went into -rc1, as well as a GICv4.1
fix for a pretty bad race that results in a dead host (a stable
candidate).

Please pull,

	M.

The following changes since commit de535c0234dd2dbd9c790790f2ca1c4ec8a52d2b:

  Merge branch kvm-arm64/MAINTAINERS into kvmarm-master/fixes (2023-01-05 15:26:53 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.2-2

for you to fetch changes up to ef3691683d7bfd0a2acf48812e4ffe894f10bfa8:

  KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation (2023-01-21 11:02:19 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.2, take #2

- Pass the correct address to mte_clear_page_tags() on initialising
  a tagged page

- Plug a race against a GICv4.1 doorbell interrupt while saving
  the vgic-v3 pending state.

----------------------------------------------------------------
Catalin Marinas (1):
      KVM: arm64: Pass the actual page address to mte_clear_page_tags()

Marc Zyngier (1):
      KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation

 arch/arm64/kvm/guest.c        |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c | 25 +++++++++++--------------
 arch/arm64/kvm/vgic/vgic-v4.c |  8 ++++++--
 arch/arm64/kvm/vgic/vgic.h    |  1 +
 4 files changed, 19 insertions(+), 17 deletions(-)
