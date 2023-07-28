Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53351766727
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbjG1Ib3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234979AbjG1Ia4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102AE3AA3
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A30B6205C
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1516C43391;
        Fri, 28 Jul 2023 08:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690533000;
        bh=yZcmhkVMMz+kdgiMr/eWhQGJ2beGySESdCvZqQcaZy8=;
        h=From:To:Cc:Subject:Date:From;
        b=gqjS58jiIRcP+SC5UPgIH3fZINNtlflJLzew5gWXkmMFb9ZjjmdESFOfjj3+o6qJr
         VBP8lQ+KYTb/E1vBGscZJMh+oz0fPfKUloLjAzJ4rKeSRWpQJPw99W7SYOHGVlDOe2
         0Uv0bAkE0a8w/i7GnLvnrCHz5Yzf1VBIcqtJFklXpNiySaROnrPBySu7DyZXvjRsz0
         d8pzNE38Y0KAbDMRJpt7ATeDQTN74SIk+w4CA1wutY5n/Y+1+t7bY2t1EmMD7r1tww
         3SQcieo7iTsc6pcoOHOS4lCplnxPWG9irGztu7GoZOpOail5psvMcTWnhJ0zNpF3JJ
         t4CFedxQv3BKg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrG-0000EO-6L;
        Fri, 28 Jul 2023 09:29:58 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 00/26] KVM: arm64: NV trap forwarding infrastructure
Date:   Fri, 28 Jul 2023 09:29:26 +0100
Message-Id: <20230728082952.959212-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

As people are getting tired of seeing the full NV series, I've
extracted some of the easy stuff which I'm targeting for 6.6.

This implements the so called "trap forwarding" infrastructure, which
gets used when we take a trap from an L2 guest and that the L1 guest
wants to see the trap for itself.

Most of the series is pretty boring stuff, mostly a long list of
encodings which are mapped to a set of trap bits. I swear they are
correct. Sort of (then are much more correct now that Eric has gone
through them all with a fine comb).

The interesting bit is around how we compute the trap result, which is
pretty complex due to the layers of crap the architecture has piled
over the years (a single op can be trapped by multiple coarse grained
trap bits, or a fine grained trap bit, which may itself be conditioned
by another control bit -- madness).

This also results in some rework of both the FGT stuff (for which I
carry a patch from Mark) and newly introduced the HCRX support.

With that (and the rest of the NV series[0]), FGT gets exposed to guests
and the trapping seems to work as expected.

* From v1 [1]:

  - Lots of fixups all over the map (too many to mention) after Eric's
    fantastic reviewing effort. Hopefully the result is easier to
    understand and less wrong

  - Amended Mark's patch to use the ARM64_CPUID_FIELDS() macro

  - Collected RBs, with thanks.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.6-WIP
[1] https://lore.kernel.org/all/20230712145810.3864793-1-maz@kernel.org/

Marc Zyngier (25):
  arm64: Add missing VA CMO encodings
  arm64: Add missing ERX*_EL1 encodings
  arm64: Add missing DC ZVA/GVA/GZVA encodings
  arm64: Add TLBI operation encodings
  arm64: Add AT operation encodings
  arm64: Add debug registers affected by HDFGxTR_EL2
  arm64: Add missing BRB/CFP/DVP/CPP instructions
  arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
  KVM: arm64: Correctly handle ACCDATA_EL1 traps
  KVM: arm64: Add missing HCR_EL2 trap bits
  KVM: arm64: nv: Add FGT registers
  KVM: arm64: Restructure FGT register switching
  KVM: arm64: nv: Add trap forwarding infrastructure
  KVM: arm64: nv: Add trap forwarding for HCR_EL2
  KVM: arm64: nv: Expose FEAT_EVT to nested guests
  KVM: arm64: nv: Add trap forwarding for MDCR_EL2
  KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
  KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
  KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
  KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
  KVM: arm64: nv: Add SVC trap forwarding
  KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
  KVM: arm64: nv: Expose FGT to nested guests
  KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
  KVM: arm64: nv: Add support for HCRX_EL2

Mark Brown (1):
  arm64: Add feature detection for fine grained traps

 arch/arm64/include/asm/kvm_arm.h        |   50 +
 arch/arm64/include/asm/kvm_host.h       |    7 +
 arch/arm64/include/asm/kvm_nested.h     |    2 +
 arch/arm64/include/asm/sysreg.h         |  270 +++-
 arch/arm64/kernel/cpufeature.c          |    7 +
 arch/arm64/kvm/arm.c                    |    4 +
 arch/arm64/kvm/emulate-nested.c         | 1731 +++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c            |   12 +
 arch/arm64/kvm/hyp/include/hyp/switch.h |  127 +-
 arch/arm64/kvm/nested.c                 |   11 +-
 arch/arm64/kvm/sys_regs.c               |   15 +
 arch/arm64/kvm/trace_arm.h              |   19 +
 arch/arm64/tools/cpucaps                |    1 +
 arch/arm64/tools/sysreg                 |  129 ++
 14 files changed, 2345 insertions(+), 40 deletions(-)

-- 
2.34.1

