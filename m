Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5B5078FA
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 20:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357353AbiDSShB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357031AbiDSSgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C41D4C405
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FA77B818FE
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31FAC385A7;
        Tue, 19 Apr 2022 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392886;
        bh=dYKlvZ5LenzpdmPTCAB4AqiqMLiJhQAEeink3mrOudc=;
        h=From:To:Cc:Subject:Date:From;
        b=D5yK2eAW+WCxe6hxEqlwqas1NnHs3Z4mj5+fwFxCuovMsBpfQps90/jOaphK9v9VC
         yip+AbNxlUhtdcLh5H/Asxnxp1XR/Hwj3s8CcfJ0udFUh2b563sSbhgzofH951D53y
         5FH+5CGfU/fTp05qMjdEQRQw/ALJkkE9PUT2djS8qRvuYSc6jhzADjcs1uNOSiMM9O
         E13etbgi1g80n7yBrlb07CnBt3fYekkw3RdX/isfvkOg2WH1EdV31bBG3PqheNJVMN
         DVfNNnZwbn+6ITfT20I3W2+ychLBaD+tVq7ykYucAiAwqEeD/BS+d9U8pHB8HfPOrv
         swQQcVgTO+DcA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ngsa4-005QYF-7X; Tue, 19 Apr 2022 19:28:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: [PATCH v2 00/10] arm64: Add initial support for FEAT_WFxT
Date:   Tue, 19 Apr 2022 19:27:45 +0100
Message-Id: <20220419182755.601427-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, joey.gouly@arm.com, kernel-team@android.com
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

The ARMv8.7 WFxT feature is a new take on the good old WFI/WFE
instructions as they behave the same way, only taking an extra timeout
parameter.

This small series aims at adding the minimal support for this feature,
enabling it for both the kernel and KVM.

A potential addition to this series would be to remove the event
generation from the counters, and rely on the timeout where it
matters (spinlocks?). Feedback welcome.

Patches on top of 5.18-rc2, tested of the FVP AEM.

* From v1 [1]:
  - Properly generate traces even if the deadline has already expired
  - Collect RBs, with thanks.

[1] https://lore.kernel.org/r/20220412131303.504690-1-maz@kernel.org

Marc Zyngier (10):
  arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
  arm64: Add RV and RN fields for ESR_ELx_WFx_ISS
  KVM: arm64: Simplify kvm_cpu_has_pending_timer()
  KVM: arm64: Introduce kvm_counter_compute_delta() helper
  KVM: arm64: Handle blocking WFIT instruction
  KVM: arm64: Offer early resume for non-blocking WFxT instructions
  KVM: arm64: Expose the WFXT feature to guests
  arm64: Add HWCAP advertising FEAT_WFXT
  arm64: Add wfet()/wfit() helpers
  arm64: Use WFxT for __delay() when possible

 Documentation/arm64/cpu-feature-registers.rst |  2 +
 Documentation/arm64/elf_hwcaps.rst            |  4 ++
 arch/arm64/include/asm/barrier.h              |  4 ++
 arch/arm64/include/asm/esr.h                  |  8 +++-
 arch/arm64/include/asm/hwcap.h                |  1 +
 arch/arm64/include/asm/kvm_host.h             |  1 +
 arch/arm64/include/uapi/asm/hwcap.h           |  1 +
 arch/arm64/kernel/cpufeature.c                | 13 +++++
 arch/arm64/kernel/cpuinfo.c                   |  1 +
 arch/arm64/kvm/arch_timer.c                   | 47 ++++++++++++-------
 arch/arm64/kvm/arm.c                          |  6 +--
 arch/arm64/kvm/handle_exit.c                  | 35 ++++++++++++--
 arch/arm64/kvm/sys_regs.c                     |  2 +
 arch/arm64/lib/delay.c                        | 12 ++++-
 arch/arm64/tools/cpucaps                      |  1 +
 include/kvm/arm_arch_timer.h                  |  2 -
 16 files changed, 110 insertions(+), 30 deletions(-)

-- 
2.34.1

