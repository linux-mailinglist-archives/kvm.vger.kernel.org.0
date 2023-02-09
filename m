Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72107690FB3
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 18:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjBIR6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 12:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBIR6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 12:58:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836F55FE67
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 09:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29EABB8227F
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 17:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18A4C433D2;
        Thu,  9 Feb 2023 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675965527;
        bh=2KRNVETxyXEtrTIEUnDJDzge0zGfEtAgWGQPFgH8d5c=;
        h=From:To:Cc:Subject:Date:From;
        b=YT8SV1Sz1qP3PQRCd1ojFsQmmzfTNOr2oFDImiffjh0C/tiK0hqmBj/PLRQ783xLH
         4uKPeoRIFmYrMqc7pCyQV19ENvWYqrqtm9XcfYfnw4jLm7R4yzMlgt6asA5HBYLdIM
         rdIuPxfy9yDM5TTpzs00WynOESv98pIsWcjVgvPQPL+BwXjePSpueZW/uyPuV1Hfno
         CWCJlg3N345APhVAuRXe//FEWVCrg/yTzXacy1tZKO09P0a+75gLJ+mECr1DQaCoVC
         92TjQSoC8XXf+k6EOcVA5T0zml8UDBqxNEmZqxHTtYQS6yt/GLXnrpVBoDJTbzdb9D
         gEPBhmd1xKKlA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pQBC1-0093r7-FG;
        Thu, 09 Feb 2023 17:58:45 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 00/18] KVM: arm64: Prefix patches for NV support
Date:   Thu,  9 Feb 2023 17:58:02 +0000
Message-Id: <20230209175820.1939006-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

As a bunch of the NV patches have had a decent amount of review, and
given that they do very little on their own, I've put together a
prefix series that gets the most mundane stuff out of the way.

Of course, nothing is functional, but nothing gets used either. In a
way, this is pretty similar to the current state of pKVM! ;-)

Thanks,

	M.

Christoffer Dall (6):
  KVM: arm64: nv: Introduce nested virtualization VCPU feature
  KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
  KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
  KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
  KVM: arm64: nv: Handle trapped ERET from virtual EL2
  KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2
    changes

Jintack Lim (7):
  arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
  KVM: arm64: nv: Handle HCR_EL2.NV system register traps
  KVM: arm64: nv: Support virtual EL2 exceptions
  KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
  KVM: arm64: nv: Handle PSCI call via smc from the guest
  KVM: arm64: nv: Add accessors for SPSR_EL1, ELR_EL1 and VBAR_EL1 from
    virtual EL2
  KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2

Marc Zyngier (5):
  KVM: arm64: Use the S2 MMU context to iterate over S2 table
  KVM: arm64: nv: Add EL2 system registers to vcpu context
  KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
  KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
  KVM: arm64: nv: Filter out unsupported features from ID regs

 .../admin-guide/kernel-parameters.txt         |   7 +-
 arch/arm64/include/asm/esr.h                  |   4 +
 arch/arm64/include/asm/kvm_arm.h              |  19 +-
 arch/arm64/include/asm/kvm_emulate.h          |  66 ++++++
 arch/arm64/include/asm/kvm_host.h             |  42 +++-
 arch/arm64/include/asm/kvm_mmu.h              |  11 +-
 arch/arm64/include/asm/kvm_nested.h           |  20 ++
 arch/arm64/include/asm/sysreg.h               |  38 +++-
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kernel/cpufeature.c                |  25 +++
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |   5 +
 arch/arm64/kvm/emulate-nested.c               | 203 ++++++++++++++++++
 arch/arm64/kvm/guest.c                        |   6 +
 arch/arm64/kvm/handle_exit.c                  |  45 +++-
 arch/arm64/kvm/hyp/exception.c                |  48 +++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |  19 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |  24 +++
 arch/arm64/kvm/inject_fault.c                 |  61 +++++-
 arch/arm64/kvm/mmu.c                          |  16 +-
 arch/arm64/kvm/nested.c                       | 162 ++++++++++++++
 arch/arm64/kvm/reset.c                        |  16 ++
 arch/arm64/kvm/sys_regs.c                     | 174 ++++++++++++++-
 arch/arm64/kvm/sys_regs.h                     |  14 +-
 arch/arm64/kvm/trace_arm.h                    |  59 +++++
 arch/arm64/tools/cpucaps                      |   1 +
 26 files changed, 1041 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/kvm/emulate-nested.c
 create mode 100644 arch/arm64/kvm/nested.c

-- 
2.34.1

