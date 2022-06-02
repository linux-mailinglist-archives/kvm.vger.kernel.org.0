Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF96A53B52B
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 10:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiFBIan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 04:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiFBIaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 04:30:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938AEE9B
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 01:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FF2EB81EE7
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 08:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B74C3411C;
        Thu,  2 Jun 2022 08:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654158635;
        bh=vzY+G8+ASqCckXvQ6YmgGfQtJZDGIWLvqqnwao/JorY=;
        h=From:To:Cc:Subject:Date:From;
        b=FKrKjZIJXf8NSwXpdMQplv+lflcmI/vGdP15boyX6V9G8I3IBsENIov1YcxVs4rmG
         15ij0D6YDHrxvT22FpmGegYXwGYFNGvYP8Rq/K1dOBuufxKXuTbGc8HiGuHHaVegWg
         qQZsJ5Kf5gExnHzrNRNJGqF+IBiHBmVb/H2AZnSeTJEBuUr8dVaHDn+IzI+/pcOTS1
         1yhQ7blxRs/OXdDADdtwUP5sFj/9MfnCzSXEmHwRF9bUYfFePoqb1UCpStwhfktcyX
         22Ottjkzq2nguarEhDjHKG6YsEj7C6KVuSFZi4MBJTdJS/sDN35ftP+H8dCb+k6oro
         eHIaCw/vDv62A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nwgDw-00F9Sj-Op; Thu, 02 Jun 2022 09:30:32 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Eric Auger <eauger@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
Subject: [PATCH 0/3] KVM: arm64: Fix userspace access to HW pending state
Date:   Thu,  2 Jun 2022 09:30:22 +0100
Message-Id: <20220602083025.1110433-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, eauger@redhat.com, ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, kernel-team@android.com
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

Eric reported that a Seattle system was pretty unhappy about VM
migration, and the trace pointed to a glaring bug in the way the GICv2
emulation code reported the interrupt pending state to userspace for
HW interrupts, specially if the interrupt state is per-CPU, as this is
the case for the timer...

Fixing this actually results in a minor cleanup, followed by a bit of
extra hardening so that we can catch further issues in this area
without completely taking the system down.

Unless someone screams, I plan to take these in as fixes as quickly as
possible, with the first patch being an obvious stable candidate. I'd
appreciate it if people could verify that VM migration still works
correctly for both GICv2 and GICv3.

Thanks,

	M.

Marc Zyngier (3):
  KVM: arm64: Don't read a HW interrupt pending state in user context
  KVM: arm64: Replace vgic_v3_uaccess_read_pending with
    vgic_uaccess_read_pending
  KVM: arm64: Warn if accessing timer pending state outside of vcpu
    context

 arch/arm64/kvm/arch_timer.c        |  3 +++
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  4 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 40 ++----------------------------
 arch/arm64/kvm/vgic/vgic-mmio.c    | 19 +++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio.h    |  3 +++
 5 files changed, 26 insertions(+), 43 deletions(-)

-- 
2.34.1
