Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E9C53FFC4
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 15:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244469AbiFGNOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 09:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244126AbiFGNOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 09:14:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AC8EACEB
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 06:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764AF6137B
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 13:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32D9C34114;
        Tue,  7 Jun 2022 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654607672;
        bh=z7H4Y0P+n9b+MhwAEfoY2rl2mv+LI01POH5hYvGA0rk=;
        h=From:To:Cc:Subject:Date:From;
        b=FGs1NhGM48m9rA3QD0i+KRpyMCfwEI7hQuDa6DzgBJwLDI7WK/F9gjVxRRp+Bu263
         awAHIVocX9NvvGfo6432+k0wezHX5Xl2utZnTBc2KKZksRid5a9D4Mde4sHiQFarHS
         17KYoBmdET8gsxCTuFPeD+fKgfUAbkYPpHwgSDMti/lLvkVGtpww3mhFOaK44XSWUy
         rKtCT2HMd4iy2oEGd8GxjgwGl/jQQ9VUzWUvd2zQ6BBgpCCOhVME7Q+g32T1Bg/SWD
         koa9I039SwtKdtpfXbAQNmX+ctbdD+nMTgiLbwBo1cpAOqUiittF5+fMkVC6VzACz6
         AfeA/ug9nbFbg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nyZ2U-00GBUI-HP; Tue, 07 Jun 2022 14:14:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Eric Auger <eric.auger@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
Subject: [PATCH v2 0/3] KVM: arm64: Fix userspace access to HW pending state
Date:   Tue,  7 Jun 2022 14:14:24 +0100
Message-Id: <20220607131427.1164881-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, eric.auger@redhat.com, ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a followup from [1], which aims at fixing userspace access to
interrupt pending state for HW interrupts.

* From v1 [1]:
  - Keep some of the GICv3-specifics around to avoid regressing the
    line vs latch distinction (Eric).

[1] https://lore.kernel.org/r/20220602083025.1110433-1-maz@kernel.org

Marc Zyngier (3):
  KVM: arm64: Don't read a HW interrupt pending state in user context
  KVM: arm64: Replace vgic_v3_uaccess_read_pending with
    vgic_uaccess_read_pending
  KVM: arm64: Warn if accessing timer pending state outside of vcpu
    context

 arch/arm64/kvm/arch_timer.c        |  3 +++
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  4 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 40 ++----------------------------
 arch/arm64/kvm/vgic/vgic-mmio.c    | 40 +++++++++++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio.h    |  3 +++
 5 files changed, 46 insertions(+), 44 deletions(-)

-- 
2.34.1

