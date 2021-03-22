Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26AC343911
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 07:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhCVGDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 02:03:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14421 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhCVGCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 02:02:30 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F3kPv4k4tzkdDV;
        Mon, 22 Mar 2021 14:00:51 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 14:02:18 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>,
        "Will Deacon" <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [PATCH v5 0/6] KVM: arm64: Add VLPI migration support on GICv4.1
Date:   Mon, 22 Mar 2021 14:01:52 +0800
Message-ID: <20210322060158.1584-1-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

In GICv4.1, migration has been supported except for (directly-injected)
VLPI. And GICv4.1 Spec explicitly gives a way to get the VLPI's pending
state (which was crucially missing in GICv4.0). So we make VLPI migration
capable on GICv4.1 in this series.

In order to support VLPI migration, we need to save and restore all
required configuration information and pending states of VLPIs. But
in fact, the configuration information of VLPIs has already been saved
(or will be reallocated on the dst host...) in vgic(kvm) migration.
So we only have to migrate the pending states of VLPIs specially.

Below is the related workflow in migration.

On the save path:
	In migration completion:
		pause all vCPUs
				|
		call each VM state change handler:
			pause other devices (just keep from sending interrupts, and
			such as VFIO migration protocol has already realized it [1])
					|
			flush ITS tables into guest RAM
					|
			flush RDIST pending tables (also flush VLPI pending states here)
				|
		...
On the resume path:
	load each device's state:
		restore ITS tables (include pending tables) from guest RAM
				|
		for other (PCI) devices (paused), if configured to have VLPIs,
		establish the forwarding paths of their VLPIs (and transfer
		the pending states from kvm's vgic to VPT here)

We have tested this series in VFIO migration, and found some related
issues in QEMU [2].

Links:
[1] vfio: UAPI for migration interface for device state:
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a8a24f3f6e38103b77cf399c38eb54e1219d00d6
[2] vfio: Some fixes and optimizations for VFIO migration:
    https://patchwork.ozlabs.org/project/qemu-devel/cover/20210310030233.1133-1-lushenming@huawei.com/

History:

v4 -> v5
 - Lock the whole pending state read/write sequence. (in Patch 5, from Marc)

v3 -> v4
 - Nit fixes.
 - Add a CPU cache invalidation right after unmapping the vPE. (Patch 1)
 - Drop the setting of PTZ altogether. (Patch 2)
 - Bail out if spot !vgic_initialized(). (in Patch 4)
 - Communicate the state change (clear pending_latch) via
   vgic_queue_irq_unlock. (in Patch 5)

Thanks a lot for the suggestions from Marc!

v2 -> v3
 - Add the vgic initialized check to ensure that the allocation and enabling
   of the doorbells have already been done before unmapping the vPEs.
 - Check all get_vlpi_state related conditions in save_pending_tables in one place.
 - Nit fixes.

v1 -> v2:
 - Get the VLPI state from the KVM side.
 - Nit fixes.

Thanks,
Shenming


Marc Zyngier (1):
  irqchip/gic-v3-its: Add a cache invalidation right after vPE unmapping

Shenming Lu (4):
  irqchip/gic-v3-its: Drop the setting of PTZ altogether
  KVM: arm64: GICv4.1: Add function to get VLPI state
  KVM: arm64: GICv4.1: Try to save VLPI state in save_pending_tables
  KVM: arm64: GICv4.1: Give a chance to save VLPI state

Zenghui Yu (1):
  KVM: arm64: GICv4.1: Restore VLPI pending state to physical side

 .../virt/kvm/devices/arm-vgic-its.rst         |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c                |  6 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 | 66 +++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v4.c                 | 38 +++++++++++
 arch/arm64/kvm/vgic/vgic.h                    |  1 +
 drivers/irqchip/irq-gic-v3-its.c              | 21 +++++-
 6 files changed, 122 insertions(+), 12 deletions(-)

-- 
2.19.1

