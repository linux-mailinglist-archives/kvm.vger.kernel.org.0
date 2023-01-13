Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BCE66A0DC
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 18:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjAMRjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 12:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjAMRiv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 12:38:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FCCB7875
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 09:26:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2607B820D3
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 17:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67273C433EF;
        Fri, 13 Jan 2023 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673630732;
        bh=uBwzoDfIi5zx3t1cQvei6z7fqeSGlX0Xvp4YKJJlYBU=;
        h=From:To:Cc:Subject:Date:From;
        b=O2Q8UIRTe5brWI6BtTOkh3lNN1olC74z6oG8FjKm/81W9JYh6N+S66X9VU0Ux+yD8
         VOEY2HJlTa/eJxQT9ZxwXsCjvDlakJjgDkxPDcMVZI0qdpxJE5DpUEwSh2pGIStAnA
         rfK8cNyfi5v5F9n09fA723l/FJ2pf/teYcqqOhpJSzb+0ejEeSkzmmYijBJXxpuKcs
         slthuzJRwRWItsmqRXaG2cETVBu7ncaYrVL9kITJ+z+OnnPUb9gadhgyiNywb0mVag
         ID2AresCQ72ExLpw3ni2pLPvjn+TTomfRZ0cHaSkJ2u+JQtrzoQ796bK7o64vtTm07
         2fUmLw+R5h1kw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pGNo2-001bBu-3p;
        Fri, 13 Jan 2023 17:25:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/2] KVM: arm64: Drop support for VPIPT i-cache policy
Date:   Fri, 13 Jan 2023 17:25:21 +0000
Message-Id: <20230113172523.2063867-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

ARMv8.2 introduced support for VPIPT i-caches, the V standing for
VMID-tagged. Although this looks like a reasonable idea, no
implementation has ever made it into the wild.

Linux has supported this for almost 6 years (amusingly, just as the
architecture was dropping support for AVIVT i-caches), but we have no
way to even test it, and it is likely that this code is just
bit-rotting. This isn't great.

Since this only impacts KVM, let's drop the support from the
hypervisor. The kernel itself can still work as a guest on such a
system, assuming that there is HW and a hypervisor that supports this
architecture variation.

On the other hand, if you are aware of such an implementation and can
actively test KVM on this setup, please shout!

	M.

Marc Zyngier (2):
  KVM: arm64: Disable KVM on systems with a VPIPT i-cache
  KVM: arm64: Remove VPIPT I-cache handling

 arch/arm64/include/asm/kvm_mmu.h |  3 +--
 arch/arm64/kvm/arm.c             |  5 +++++
 arch/arm64/kvm/hyp/nvhe/tlb.c    | 35 --------------------------------
 arch/arm64/kvm/hyp/vhe/tlb.c     | 13 ------------
 4 files changed, 6 insertions(+), 50 deletions(-)

-- 
2.34.1

