Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054DE76DBB4
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjHBXnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbjHBXnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:43:16 -0400
Received: from out-88.mta1.migadu.com (out-88.mta1.migadu.com [IPv6:2001:41d0:203:375::58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820D330CF
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:43:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691019791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R2RlCwZNfKPoBl/YBp1ZtAc2eI49tDe7LZAUDFCIQzA=;
        b=DgNKCrXTQk7jLiZt4kP72kZ4GOZT2dS1skmtHQgStGJLaV7nLOzkcdvzxmpkt0XGKCPvHQ
        0EHH4VV3ckR+vd7clyCfiNcDesNn2WXfoIwOiusztgs3jYepYc19jLaRKwBBCH2JKu+6bi
        T5bVOSxDcNw7b8BZPPkrcx2LPgt7bi4=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v3 00/17] aarch64: Handle PSCI calls in userspace
Date:   Wed,  2 Aug 2023 23:42:38 +0000
Message-ID: <20230802234255.466782-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3 of the series to do PSCI calls in userspace, as an example for using
the SMCCC filtering API added to KVM in 6.4.

v2 -> v3:
 - Dropped some of the headers patches since they've already been
   updated
 - Redo header imports on top of 6.5-rc1
 - Actually use the right subject prefix...

v2: https://lore.kernel.org/kvmarm/20230620163353.2688567-1-oliver.upton@linux.dev/

Oliver Upton (17):
  Import arm-smccc.h from Linux 6.5-rc1
  aarch64: Copy cputype.h from Linux 6.5-rc1
  Update psci.h to Linux 6.5-rc1
  arm: Stash kvm_vcpu_init for later use
  arm: Use KVM_SET_MP_STATE ioctl to power off non-boot vCPUs
  aarch64: Expose ARM64_CORE_REG() for general use
  arm: Generalize execution state specific VM initialization
  Add helpers to pause the VM from vCPU thread
  aarch64: Add support for finding vCPU for given MPIDR
  aarch64: Add skeleton implementation for PSCI
  aarch64: psci: Implement CPU_SUSPEND
  aarch64: psci: Implement CPU_OFF
  aarch64: psci: Implement CPU_ON
  aarch64: psci: Implement AFFINITY_INFO
  aarch64: psci: Implement MIGRATE_INFO_TYPE
  aarch64: psci: Implement SYSTEM_{OFF,RESET}
  aarch64: smccc: Start sending PSCI to userspace

 Makefile                                  |   4 +-
 arm/aarch32/include/kvm/kvm-arch.h        |   2 +-
 arm/aarch32/kvm-cpu.c                     |   5 +
 arm/aarch64/include/asm/cputype.h         | 186 +++++++++++++++++
 arm/aarch64/include/asm/smccc.h           |  65 ++++++
 arm/aarch64/include/kvm/kvm-arch.h        |   2 +-
 arm/aarch64/include/kvm/kvm-config-arch.h |   6 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  28 ++-
 arm/aarch64/kvm-cpu.c                     |  48 +++--
 arm/aarch64/kvm.c                         |  25 ++-
 arm/aarch64/psci.c                        | 207 +++++++++++++++++++
 arm/aarch64/smccc.c                       |  81 ++++++++
 arm/include/arm-common/kvm-arch.h         |   2 +
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/include/arm-common/kvm-cpu-arch.h     |   2 +-
 arm/kvm-cpu.c                             |  21 +-
 arm/kvm.c                                 |   2 +-
 include/kvm/kvm-cpu.h                     |   3 +
 include/linux/arm-smccc.h                 | 240 ++++++++++++++++++++++
 include/linux/psci.h                      |  47 +++++
 kvm-cpu.c                                 |  16 ++
 21 files changed, 959 insertions(+), 34 deletions(-)
 create mode 100644 arm/aarch64/include/asm/cputype.h
 create mode 100644 arm/aarch64/include/asm/smccc.h
 create mode 100644 arm/aarch64/psci.c
 create mode 100644 arm/aarch64/smccc.c
 create mode 100644 include/linux/arm-smccc.h


base-commit: 106e2ea7756d980454d68631b87d5e25ba4e4881
-- 
2.41.0.585.gd2178a4bd4-goog

