Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14392C0053
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 07:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgKWGyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 01:54:54 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7964 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgKWGyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 01:54:54 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CfdDn12VvzhgH2;
        Mon, 23 Nov 2020 14:54:33 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 14:54:38 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [RFC PATCH v1 0/4] KVM: arm64: Add VLPI migration support on GICv4.1
Date:   Mon, 23 Nov 2020 14:54:06 +0800
Message-ID: <20201123065410.1915-1-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In GICv4.1, migration has been supported except for (directly-injected)
VLPI. And GICv4.1 spec explicitly gives a way to get the VLPI's pending
state (which was crucially missing in GICv4.0). So we make VLPI migration
capable on GICv4.1 in this patch set.

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
			flush RDIST pending tables (also flush VLPI state here)
				|
		...
On the resume path:
	load each device's state:
		restore ITS tables (include pending tables) from guest RAM
				|
		for other (PCI) devices (paused), if configured to have VLPIs,
		establish the forwarding paths of their VLPIs (and transfer
		the pending states from kvm's vgic to VPT here)

Yet TODO:
 - For some reason, such as for VFIO PCI devices, there may be repeated
   resettings of HW VLPI configuration in load_state, resulting in the
   loss of pending state. A very intuitive solution is to retrieve the
   pending state in unset_forwarding (and this should be so regardless
   of migration). But at normal run time, this function may be called
   when all devices are running, in which case the unmapping of VPE is
   not allowed. It seems to be an almost insoluble bug...
   There are other possible solutions as follows:
   1) avoid unset_forwarding being called from QEMU in resuming (simply
   allocate all needed vectors first), which is more reasonable and
   efficient.
   2) add a new dedicated interface to transfer these pending states to
   HW in GIC VM state change handler corresponding to save_pending_tables.
   ...

Any comments and suggestions are very welcome.

Besides, we have tested this series in VFIO migration, and nothing else
goes wrong (with two issues committed [2][3]).

Links:
[1] vfio: UAPI for migration interface for device state:
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
    commit/?id=a8a24f3f6e38103b77cf399c38eb54e1219d00d6
[2] vfio: Move the saving of the config space to the right place in VFIO migration:
    https://patchwork.ozlabs.org/patch/1400246/
[3] vfio: Set the priority of VFIO VM state change handler explicitly:
    https://patchwork.ozlabs.org/patch/1401280/

Shenming Lu (2):
  KVM: arm64: GICv4.1: Try to save hw pending state in
    save_pending_tables
  KVM: arm64: GICv4.1: Give a chance to save VLPI's pending state

Zenghui Yu (2):
  irqchip/gic-v4.1: Plumb get_irqchip_state VLPI callback
  KVM: arm64: GICv4.1: Restore VLPI's pending state to physical side

 .../virt/kvm/devices/arm-vgic-its.rst         |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c                |  6 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 | 62 +++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v4.c                 | 12 ++++
 drivers/irqchip/irq-gic-v3-its.c              | 38 ++++++++++++
 5 files changed, 110 insertions(+), 10 deletions(-)

-- 
2.23.0

