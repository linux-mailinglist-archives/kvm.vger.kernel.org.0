Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CC23F7A48
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbhHYQUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:20:23 -0400
Received: from foss.arm.com ([217.140.110.172]:55024 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241989AbhHYQTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:19:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7415BD6E;
        Wed, 25 Aug 2021 09:18:47 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B0DF3F66F;
        Wed, 25 Aug 2021 09:18:46 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v4 kvmtool 0/5] KVM SPE support
Date:   Wed, 25 Aug 2021 17:19:53 +0100
Message-Id: <20210825161958.266411-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
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

2. After the guest memory memslots have been created and SPE initialized,
kvmtool will lock the memslot memory using the newly introduced capability.

The first patch is a simple update to the Linux headers; the next two
patches are preparatory patches. SPE support is added in patch number 4.
And finally, in patch number 5, we take advantage of the newly added
KVM_ARM_VCPU_SUPPORTED_CPUS ioctl to inform KVM that we intend to run the
VCPUs only on those physical CPUs which support SPE. This is done by
concatenating the cpulists from each of the /sys/devices/arm_spe_x/cpumask
files created by the Linux SPE driver for each separate PPI partition which
has SPE support.

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/kvm-spe-v4
[2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/kvm-spe-v4

Alexandru Elisei (4):
  update_headers: Sync KVM UAPI headers with KVM SPE implementation
  arm/arm64: Make kvm__arch_delete_ram() aarch32/aarch64 specific
  init: Add last_{init, exit} list macros
  arm64: SPE: Set KVM_ARM_VCPU_SUPPORTED_CPUS

Sudeep Holla (1):
  arm64: Add SPE support

 Makefile                                  |   2 +
 arm/aarch32/kvm.c                         |   8 +
 arm/aarch64/arm-cpu.c                     |   2 +
 arm/aarch64/include/asm/kvm.h             |  67 +++-
 arm/aarch64/include/kvm/kvm-config-arch.h |   2 +
 arm/aarch64/include/kvm/spe.h             |   7 +
 arm/aarch64/kvm-cpu.c                     |   5 +
 arm/aarch64/kvm.c                         |  18 +
 arm/aarch64/spe.c                         | 269 ++++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |   1 +
 arm/kvm-cpu.c                             |   4 +
 arm/kvm.c                                 |   5 -
 include/kvm/util-init.h                   |   6 +-
 include/linux/kvm.h                       | 425 +++++++++++++++++++++-
 powerpc/include/asm/kvm.h                 |  10 +
 x86/include/asm/kvm.h                     |  59 ++-
 16 files changed, 870 insertions(+), 20 deletions(-)
 create mode 100644 arm/aarch32/kvm.c
 create mode 100644 arm/aarch64/include/kvm/spe.h
 create mode 100644 arm/aarch64/spe.c

-- 
2.33.0

