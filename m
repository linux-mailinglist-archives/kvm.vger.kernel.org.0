Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5AA712FCC
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243254AbjEZWR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 18:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjEZWRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 18:17:25 -0400
Received: from out-3.mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7113B83
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 15:17:23 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685139441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0DRZq6mR4INEWOyJ/DMmrZaRWmShYq5YMrnor+fex+M=;
        b=xmnH4Ig+L0YoY7R+KtbzJ+h6UuJg64rZ0cY8EL3fXwUOOTbBHhPSIlSz6NOus9Z96pDe+N
        y5tA9RRZvRb313LzQ/t7oE9I3er4Fc1rsAuRqsvKeOIdlTRWDzcOosKnNWrvjrhEyBiWqo
        HHhOUiQwT08iGXEK6sFLBW8njbEZBx0=
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
Subject: [PATCH kvmtool 00/21] arm64: Handle PSCI calls in userspace
Date:   Fri, 26 May 2023 22:16:51 +0000
Message-ID: <20230526221712.317287-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 6.4 kernel picks up support for a generalized SMCCC filter, allowing
userspace to select hypercall ranges that should be forwarded to
userspace. This is a shameless attempt of making future SMCCC interfaces
the responsibility of userspace :)

As a starting point, let's move PSCI up into userspace. KVM already
leans on userspace for handling calls that have a system-wide effect.

Tested on linux-next with a 64 vCPU VM. Additionally, I took a stab at
running kvm-unit-test's psci test, which passes.

Apologies for some of the changelogs being a bit short. It's Friday, and
I'm lazy.

Oliver Upton (21):
  update_headers: Use a list for arch-generic headers
  update_headers: Add missing entries to list of headers to copy
  Copy 64-bit alignment attrtibutes from Linux 6.4-rc1
  Update headers with Linux 6.4-rc1
  Import arm-smccc.h from Linux 6.4-rc1
  aarch64: Copy cputype.h from Linux 6.4-rc1
  arm: Stash kvm_vcpu_init for later use
  arm: Add support for resetting a vCPU
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
 arm/aarch64/include/asm/cputype.h         | 186 +++++
 arm/aarch64/include/asm/kvm.h             |  38 +
 arm/aarch64/include/asm/smccc.h           |  65 ++
 arm/aarch64/include/kvm/kvm-arch.h        |   2 +-
 arm/aarch64/include/kvm/kvm-config-arch.h |   6 +-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  28 +-
 arm/aarch64/kvm-cpu.c                     |  48 +-
 arm/aarch64/kvm.c                         |  25 +-
 arm/aarch64/psci.c                        | 206 +++++
 arm/aarch64/smccc.c                       |  82 ++
 arm/include/arm-common/kvm-arch.h         |   2 +
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/include/arm-common/kvm-cpu-arch.h     |   4 +-
 arm/kvm-cpu.c                             |  35 +-
 arm/kvm.c                                 |   2 +-
 include/kvm/kvm-cpu.h                     |   3 +
 include/linux/arm-smccc.h                 | 240 ++++++
 include/linux/kvm.h                       |  55 +-
 include/linux/psci.h                      |  47 ++
 include/linux/types.h                     |  13 +
 include/linux/vfio.h                      | 920 +++++++++++++++++++++-
 include/linux/vhost.h                     | 186 ++---
 include/linux/virtio_blk.h                | 105 +++
 include/linux/virtio_net.h                |   4 +
 kvm-cpu.c                                 |  15 +
 riscv/include/asm/kvm.h                   |   3 +
 util/update_headers.sh                    |  25 +-
 x86/include/asm/kvm.h                     |  50 +-
 31 files changed, 2225 insertions(+), 182 deletions(-)
 create mode 100644 arm/aarch64/include/asm/cputype.h
 create mode 100644 arm/aarch64/include/asm/smccc.h
 create mode 100644 arm/aarch64/psci.c
 create mode 100644 arm/aarch64/smccc.c
 create mode 100644 include/linux/arm-smccc.h


base-commit: 77b108c6a6f1c66fb7f60a80d17596bb80bda8ad
-- 
2.41.0.rc0.172.g3f132b7071-goog

