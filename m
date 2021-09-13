Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB134097A8
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbhIMPoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:44:37 -0400
Received: from foss.arm.com ([217.140.110.172]:33168 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245524AbhIMPoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:44:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B19656D;
        Mon, 13 Sep 2021 08:42:51 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A9A7C3F719;
        Mon, 13 Sep 2021 08:42:50 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v1 kvmtool 0/7] vfio/pci: Fix MSIX table and PBA size allocation
Date:   Mon, 13 Sep 2021 16:44:06 +0100
Message-Id: <20210913154413.14322-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is meant to rework the way the MSIX table and PBA are allocated
to prevent situations where the size allocated by kvmtool is larger than
the size of the BAR that holds them.

Patches 1-3 are fixes for stuff I found when I was investing a bug
triggered by the incorrect sizing of the table and PBA.

Patch 4 is a preparatory patch.

Patch 5 is the proper fix. More details in the commit message.

Patch 6 is there to make it easier to catch such errors if the code
regresses.

Patch 7 is an optimization for guests with larger page sizes than the host.


Testing
=======

On an AMD Seattle, host page size 4k and 64k, guest page size 4k and 64k
(so 4 tests in total for each device). Tried device passthrough with a
Realtek RTL8168 NIC and with a Intel 82574L NIC (not at the same time). No
issues encountered, MSIX table and PBA BAR has the same layout as the
physical device.

On an AMD Ryzen 3900x, host and guest 4k pages, I've assigned an Intel
82574L NIC to the guest. Realtek RTL8168 doesn't work without emulating a
PCI Express bus because the drivers falls back to CSI for device
configuration. Everything works in the guest, the shared BAR has the same
layout in the guest as the physical device.


Alexandru Elisei (7):
  arm/gicv2m: Set errno when gicv2_update_routing() fails
  vfio/pci.c: Remove double include for assert.h
  pci: Fix pci_dev_* print macros
  vfio/pci: Rename PBA offset in device descriptor to fd_offset
  vfio/pci: Rework MSIX table and PBA physical size allocation
  vfio/pci: Print an error when offset is outside of the MSIX table or
    PBA
  vfio/pci: Align MSIX Table and PBA size allocation to 64k

 arm/gicv2m.c       | 10 +++---
 include/kvm/pci.h  | 10 +++---
 include/kvm/vfio.h |  3 +-
 vfio/pci.c         | 82 ++++++++++++++++++++++++++++++----------------
 4 files changed, 66 insertions(+), 39 deletions(-)

-- 
2.20.1

