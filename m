Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084FD7A8BD6
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjITSdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjITSde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:33:34 -0400
Received: from out-229.mta1.migadu.com (out-229.mta1.migadu.com [IPv6:2001:41d0:203:375::e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81CAC9
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:33:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695234804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7Nhz4H8l1rfYTcw7mM0IBP0p2Qb41WdKVQC8nCsXgMk=;
        b=gHcL/vSvfZM8btz3RWbjVBSooZ3+qS4fr7XTgqXoa1jTSQKV5jwIHc1Orw+m/MGh137Vx2
        Hxv9EsHXxbnfM8ZH0du+Pyh31ODuOl2k2tncREOjgFEYiK/t4LkxRCSZHZWfhoyx3gh35N
        opQ0p+dfZLfa0NY8z/44Egnpnewow4w=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v10 00/12] KVM: arm64: Enable 'writable' ID registers
Date:   Wed, 20 Sep 2023 18:32:57 +0000
Message-ID: <20230920183310.1163034-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

This is hopefully the last take on the 'writable' ID registers series.
The patches have been sitting on the mailing list for years in some form
and it seems like we're approaching critical mass in terms of interest
in the feature.

I've taken Jing's series and applied some cleanups to get things in
order for 6.7.

v9 -> v10:
 - Picked up the latest KVM_ARM_GET_REG_WRITABLE_MASKS patch
 - Cleaned up the initializer macros for sys_reg_descs
 - Aggressively masked-out features that make no sense to modify
 - Added ZFR0 and the ISAR registers to the mix
 - Added documentation on how userspace is expected to use all the UAPI

v9: https://lore.kernel.org/kvmarm/20230821212243.491660-1-jingzhangos@google.com/

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

 Documentation/virt/kvm/api.rst                |   43 +
 Documentation/virt/kvm/arm/index.rst          |    1 +
 Documentation/virt/kvm/arm/vcpu-features.rst  |   47 +
 arch/arm64/include/asm/kvm_host.h             |    2 +
 arch/arm64/include/uapi/asm/kvm.h             |   32 +
 arch/arm64/kvm/arm.c                          |   10 +
 arch/arm64/kvm/sys_regs.c                     |  185 +-
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
 .../selftests/kvm/aarch64/set_id_regs.c       |  478 ++++
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +-
 19 files changed, 3853 insertions(+), 689 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/vcpu-features.rst
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100755 tools/arch/arm64/tools/gen-sysreg.awk
 create mode 100644 tools/arch/arm64/tools/sysreg
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: ce9ecca0238b140b88f43859b211c9fdfd8e5b70
-- 
2.42.0.515.g380fc7ccd1-goog

