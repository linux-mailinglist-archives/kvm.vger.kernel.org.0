Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E3C29C0F6
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817988AbgJ0RQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:16:45 -0400
Received: from foss.arm.com ([217.140.110.172]:47464 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1817973AbgJ0RQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:16:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC422139F;
        Tue, 27 Oct 2020 10:16:33 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 236773F719;
        Tue, 27 Oct 2020 10:16:30 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com
Subject: [RFC PATCH kvmtool v3 0/3] SPE support
Date:   Tue, 27 Oct 2020 17:17:32 +0000
Message-Id: <20201027171735.13638-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds userspace support for creating a guest which can use SPE.
It requires KVM SPE support which is in the RFC phase, hence why this
series is also RFC. The kvmtool patches can also be found at [1], and the
KVM SPE patches can be found at [2].

To create a guest with SPE support the following steps must be executed:

1. Set the SPE virtual interrupt ID and then initialize the features on
every VCPU.

2. After the guest memory memslots have been created, kvmtool must mlock()
the VMAs backing the memslots.

3. After everything has been copied to the guest's memory, kvmtool must
execute the KVM_ARM_VM_SPE_CTRL(KVM_ARM_VM_SPE_FINALIZE) on the VM fd.

The first patch is a simple update to the Linux headers; the second patch
add a new init list that executes last which is necessary to make sure the
gest memory will not be touched after that; and the third patch contains
the actual SPE support.

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v3
[2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v3

Alexandru Elisei (1):
  init: Add last_{init, exit} list macros

Sudeep Holla (2):
  update_headers: Sync kvm UAPI headers with linux 5.10-rc1
  arm64: Add SPE support

 Makefile                                  |   2 +-
 arm/aarch64/arm-cpu.c                     |   2 +
 arm/aarch64/include/asm/kvm.h             |  53 +++++++-
 arm/aarch64/include/kvm/kvm-config-arch.h |   2 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |   3 +-
 arm/aarch64/kvm-cpu.c                     |   5 +
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/include/arm-common/spe.h              |   7 +
 arm/spe.c                                 | 154 ++++++++++++++++++++++
 include/kvm/util-init.h                   |   6 +-
 include/linux/kvm.h                       | 117 +++++++++++++++-
 powerpc/include/asm/kvm.h                 |   8 ++
 x86/include/asm/kvm.h                     |  42 +++++-
 13 files changed, 387 insertions(+), 15 deletions(-)
 create mode 100644 arm/include/arm-common/spe.h
 create mode 100644 arm/spe.c

-- 
2.29.1

