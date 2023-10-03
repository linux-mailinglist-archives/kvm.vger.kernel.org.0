Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A724D7B746D
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 01:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjJCXEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 19:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjJCXEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 19:04:23 -0400
Received: from out-197.mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7448AB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 16:04:19 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696374258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vVOxICpIQ/PQQ7Lqo0OPeRUAu3It0WcvPdKF8Eoi9TA=;
        b=OpeiqJDlNiTXIai0HbgVEZuCTF8nMDrdngg02MJaEYOtgZEQp+bjqPVn8+2Md2F/QVc01+
        q6Z/PUFBDV+xhgMruGeOjF66Ch0Ungj3cKYGiI5VP+pbgFprDgSN645QB5KaK8GhYLKek0
        MlYuhHhh3VX+LM31jT/xjeota29w2ZM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v11 00/12] KVM: arm64: Enable 'writable' ID registers
Date:   Tue,  3 Oct 2023 23:03:56 +0000
Message-ID: <20231003230408.3405722-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Few more fixes that I threw on top:

v10 -> v11:
 - Drop the custom handling of FEAT_BC as it is now fixed on the arm64
   side (Kristina)
 - Bikeshed on the naming of the masks ioctl to keep things in the KVM_
   namespace
 - Apply more bikeshedding to the ioctl documentation, spinning off
   separate blocks for the 'generic' description and the Feature ID
   documentation
 - Fix referencing in the vCPU features doc
 - Fix use of uninitialized data in selftest

Jing Zhang (7):
  KVM: arm64: Allow userspace to get the writable masks for feature ID
    registers
  KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Allow userspace to change ID_AA64MMFR{0-2}_EL1
  KVM: arm64: Allow userspace to change ID_AA64PFR0_EL1
  KVM: arm64: selftests: Import automatic generation of sysreg defs
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (5):
  KVM: arm64: Reject attempts to set invalid debug arch version
  KVM: arm64: Bump up the default KVM sanitised debug version to v8p8
  KVM: arm64: Allow userspace to change ID_AA64ISAR{0-2}_EL1
  KVM: arm64: Allow userspace to change ID_AA64ZFR0_EL1
  KVM: arm64: Document vCPU feature selection UAPIs

 Documentation/virt/kvm/api.rst                |   52 +
 Documentation/virt/kvm/arm/index.rst          |    1 +
 Documentation/virt/kvm/arm/vcpu-features.rst  |   48 +
 arch/arm64/include/asm/kvm_host.h             |    2 +
 arch/arm64/include/uapi/asm/kvm.h             |   32 +
 arch/arm64/kvm/arm.c                          |   10 +
 arch/arm64/kvm/sys_regs.c                     |  181 +-
 include/uapi/linux/kvm.h                      |    2 +
 tools/arch/arm64/include/.gitignore           |    1 +
 tools/arch/arm64/include/asm/gpr-num.h        |   26 +
 tools/arch/arm64/include/asm/sysreg.h         |  839 ++----
 tools/arch/arm64/tools/gen-sysreg.awk         |  336 +++
 tools/arch/arm64/tools/sysreg                 | 2497 +++++++++++++++++
 tools/testing/selftests/kvm/Makefile          |   15 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |    4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |    6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       |  479 ++++
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +-
 19 files changed, 3860 insertions(+), 689 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/vcpu-features.rst
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100755 tools/arch/arm64/tools/gen-sysreg.awk
 create mode 100644 tools/arch/arm64/tools/sysreg
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.609.gbb76f46606-goog

