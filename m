Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83BE77D20A
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbjHOSjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbjHOSjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:39:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AED1BEE
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 632DD65F07
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 18:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD2EC433CD;
        Tue, 15 Aug 2023 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692124757;
        bh=xu2YUU/jhCrfFKtk8h109BurYyIVdb/eaTfJtVK+xwA=;
        h=From:To:Cc:Subject:Date:From;
        b=ZAwEoAqVZH1zbVRFL/o1HlhmOTHOll88NEnfZL1cMoHDvQ+wevxObeEqAuv/lr6sQ
         mc+OK6idQz9wtor4EyOva8wwzE4NLMYbZs035yolC0rtFz+eYBZLfTQ7qnxJBz7NZj
         zOYe4KW/BQqp9FuG0dY/agsPVL97nxsi3Pdlne/XTEJ4/yNFF+qMcSAbrN5ujsVsOq
         5V1N22CFM+S4AnyqQoOphWkzuQ465jdOYu7wGzKkpEeRp89Aj0GnWihQVDcgDzoQLs
         Z5/ks2ZQjGJwPzC11p15mkWUVju2QUm7BylYe9OkQ/Dl3aiLY0pxwBfe8UqJdeRxb0
         h7s/CjBn7wD8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qVywk-0055Sd-Cb;
        Tue, 15 Aug 2023 19:39:15 +0100
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
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 00/28] KVM: arm64: NV trap forwarding infrastructure
Date:   Tue, 15 Aug 2023 19:38:34 +0100
Message-Id: <20230815183903.2735724-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

Another week, another version. Change log below.

I'll drop this into -next now, and see what happens.

* From v3 [3]:

  - Renamed trap_group to cgt_group_id (Eric)

  - Plenty of comment rework (Eric)

  - Fix HCR_EL2.FIEN handling (Miguel)

  - Fix missing validation of last MCB entry (Miguel)

  - Fix instance of recursive MCB (Jing)

  - Handle error return from xa_store()/xa_range_store() (Jing)

  - Propagate error generated from populate_nv_trap_config() (Jing)

  - Added more consistency checks for sysregs and trap bits

  - Added a line number entry, which is useful for debugging
    overlapping entries.

  - Fixed duplicate entries for SP_EL1, DBGDTRRX_EL0 and SCXTNUM_EL0

  - Correctly handle fine grained trapping for ERET

  - Collected RBs, with thanks

* From v2 [2]:

  - Another set up fixups thanks to Oliver, Eric and Miguel: TRCID
    bits, duplicate encodings, sanity checking, error handling at boot
    time, spelling mistakes...

  - Split the HFGxTR_EL2 patch in two patches: one that provides the
    FGT infrastructure, and one that provides the HFGxTR_EL2 traps. It
    makes it easier to review and matches the rest of the series.

  - Collected RBs, with thanks

* From v1 [1]:

  - Lots of fixups all over the map (too many to mention) after Eric's
    fantastic reviewing effort. Hopefully the result is easier to
    understand and less wrong

  - Amended Mark's patch to use the ARM64_CPUID_FIELDS() macro

  - Collected RBs, with thanks.

[1] https://lore.kernel.org/all/20230712145810.3864793-1-maz@kernel.org
[2] https://lore.kernel.org/all/20230728082952.959212-1-maz@kernel.org
[3] https://lore.kernel.org/all/20230808114711.2013842-1-maz@kernel.org

Marc Zyngier (27):
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
  KVM: arm64: nv: Add fine grained trap forwarding infrastructure
  KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
  KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
  KVM: arm64: nv: Add trap forwarding for HDFGxTR_EL2
  KVM: arm64: nv: Add SVC trap forwarding
  KVM: arm64: nv: Expand ERET trap forwarding to handle FGT
  KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
  KVM: arm64: nv: Expose FGT to nested guests
  KVM: arm64: Move HCRX_EL2 switch to load/put on VHE systems
  KVM: arm64: nv: Add support for HCRX_EL2

Mark Brown (1):
  arm64: Add feature detection for fine grained traps

 arch/arm64/include/asm/kvm_arm.h        |   50 +
 arch/arm64/include/asm/kvm_host.h       |    7 +
 arch/arm64/include/asm/kvm_nested.h     |    2 +
 arch/arm64/include/asm/sysreg.h         |  268 +++-
 arch/arm64/kernel/cpufeature.c          |    7 +
 arch/arm64/kvm/arm.c                    |    4 +
 arch/arm64/kvm/emulate-nested.c         | 1850 +++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c            |   29 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  127 +-
 arch/arm64/kvm/nested.c                 |   11 +-
 arch/arm64/kvm/sys_regs.c               |   15 +
 arch/arm64/kvm/trace_arm.h              |   26 +
 arch/arm64/tools/cpucaps                |    1 +
 arch/arm64/tools/sysreg                 |  129 ++
 14 files changed, 2485 insertions(+), 41 deletions(-)

-- 
2.34.1

