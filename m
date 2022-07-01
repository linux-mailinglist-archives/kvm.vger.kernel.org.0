Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B623563592
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiGAOap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiGAO3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:29:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C17186EE96
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47E0B113E;
        Fri,  1 Jul 2022 07:25:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9D1CA3F792;
        Fri,  1 Jul 2022 07:25:18 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 00/12] Virtio v1 support
Date:   Fri,  1 Jul 2022 15:24:22 +0100
Message-Id: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is version 2 of the modern virtio support for kvmtool.

Since v1 [1]:
* Repaired vhost-net for pci-modern, by adding patches 4 and 5
* Added patch 6 that extends the feature fields and simplifies modern
  features handling
* Added patch 12, a small cleanup

Since vsock and scsi devices have been broken for a while, this series
doesn't attempt to make them work but I have another series [2] to fix
the vhost support, that I will send later.

[1] https://lore.kernel.org/kvm/20220607170239.120084-1-jean-philippe.brucker@arm.com/
[2] https://jpbrucker.net/git/kvmtool/log/?h=virtio/devel

Jean-Philippe Brucker (12):
  virtio/pci: Delete MSI routes
  virtio: Extract init_vq() for PCI and MMIO
  virtio/pci: Make doorbell offset dynamic
  virtio/pci: Use the correct eventfd for vhost notification
  virtio/net: Set vhost backend after queue address
  virtio: Prepare for more feature bits
  virtio: Move PCI transport to pci-legacy
  virtio: Add support for modern virtio-pci
  virtio: Move MMIO transport to mmio-legacy
  virtio: Add support for modern virtio-mmio
  virtio/pci: Initialize all vectors to VIRTIO_MSI_NO_VECTOR
  virtio/pci: Remove VIRTIO_PCI_F_SIGNAL_MSI

 Makefile                          |   4 +
 arm/include/arm-common/kvm-arch.h |   6 +-
 include/kvm/kvm-config.h          |   1 +
 include/kvm/kvm.h                 |   6 +
 include/kvm/pci.h                 |  11 +
 include/kvm/virtio-mmio.h         |  29 ++-
 include/kvm/virtio-pci-dev.h      |   4 +
 include/kvm/virtio-pci.h          |  50 +++-
 include/kvm/virtio.h              |   8 +-
 mips/include/kvm/kvm-arch.h       |   2 -
 powerpc/include/kvm/kvm-arch.h    |   2 -
 riscv/include/kvm/kvm-arch.h      |   3 +-
 x86/include/kvm/kvm-arch.h        |   2 -
 builtin-run.c                     |   2 +
 virtio/9p.c                       |   2 +-
 virtio/balloon.c                  |   2 +-
 virtio/blk.c                      |   2 +-
 virtio/console.c                  |   2 +-
 virtio/core.c                     |  16 +-
 virtio/mmio-legacy.c              | 150 ++++++++++++
 virtio/mmio-modern.c              | 161 ++++++++++++
 virtio/mmio.c                     | 183 ++------------
 virtio/net.c                      |  15 +-
 virtio/pci-legacy.c               | 205 ++++++++++++++++
 virtio/pci-modern.c               | 390 ++++++++++++++++++++++++++++++
 virtio/pci.c                      | 317 +++++-------------------
 virtio/rng.c                      |   2 +-
 virtio/scsi.c                     |   2 +-
 virtio/vsock.c                    |   2 +-
 29 files changed, 1131 insertions(+), 450 deletions(-)
 create mode 100644 virtio/mmio-legacy.c
 create mode 100644 virtio/mmio-modern.c
 create mode 100644 virtio/pci-legacy.c
 create mode 100644 virtio/pci-modern.c

-- 
2.36.1

