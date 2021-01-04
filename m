Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA67F2E919D
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 09:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbhADIRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 03:17:40 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10101 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbhADIRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 03:17:40 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8T341WJnzMF83;
        Mon,  4 Jan 2021 16:15:44 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.196) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 4 Jan 2021 16:16:45 +0800
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
Subject: [RFC PATCH v2 0/4] KVM: arm64: Add VLPI migration support on GICv4.1
Date:   Mon, 4 Jan 2021 16:16:09 +0800
Message-ID: <20210104081613.100-1-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.196]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In GICv4.1, migration has been supported except for (directly-injected)
VLPI. And GICv4.1 Spec explicitly gives a way to get the VLPI's pending
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

We have tested this series in VFIO migration, and found some related
issues in QEMU [2].

Links:
[1] vfio: UAPI for migration interface for device state:
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
    commit/?id=a8a24f3f6e38103b77cf399c38eb54e1219d00d6
[2] vfio: Some fixes and optimizations for VFIO migration:
    https://patchwork.ozlabs.org/cover/1413263/

History:

v1 -> v2:
 - Get the VLPI state from the KVM side.
 - Nit fixes.

Since there seems to be no better place to transfer the pending states
in patch 3, we just keep it unchanged.

Thanks,
Shenming


Shenming Lu (3):
  KVM: arm64: GICv4.1: Add function to get VLPI state
  KVM: arm64: GICv4.1: Try to save hw pending state in
    save_pending_tables
  KVM: arm64: GICv4.1: Give a chance to save VLPI's pending state

Zenghui Yu (1):
  KVM: arm64: GICv4.1: Restore VLPI's pending state to physical side

 .../virt/kvm/devices/arm-vgic-its.rst         |  2 +-
 arch/arm64/kvm/vgic/vgic-its.c                |  6 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 | 58 +++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-v4.c                 | 36 ++++++++++++
 arch/arm64/kvm/vgic/vgic.h                    |  1 +
 5 files changed, 93 insertions(+), 10 deletions(-)

-- 
2.19.1

