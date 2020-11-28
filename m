Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F5D2C7457
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 23:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388622AbgK1Vtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 16:49:42 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9066 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732698AbgK1Rzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 12:55:43 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CjtsL68GZzLwH9;
        Sat, 28 Nov 2020 22:19:02 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 22:19:24 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Jason Cooper" <jason@lakedaemon.net>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>
CC:     <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [PATCH v2 0/2] KVM: arm64: Optimize the wait for the completion of the VPT analysis
Date:   Sat, 28 Nov 2020 22:18:55 +0800
Message-ID: <20201128141857.983-1-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right after a vPE is made resident, the code starts polling the
GICR_VPENDBASER.Dirty bit until it becomes 0, where the delay_us
is set to 10. But in our measurement, it takes only hundreds of
nanoseconds, or 1~2 microseconds, to finish parsing the VPT in most
cases. What's more, we found that the MMIO delay on GICv4.1 system
(HiSilicon) is about 10 times higher than that on GICv4.0 system in
kvm-unit-tests (the specific data is as follows).

                        |   GICv4.1 emulator   |  GICv4.0 emulator
mmio_read_user (ns)     |        12811         |        1598

After analysis, this is mainly caused by the 10 delay_us, so it might
really hurt performance.

To avoid this, we can set the delay_us to 1, which is more appropriate
in this situation and universal. Besides, we can delay the execution
of the polling, giving the GIC a chance to work in parallel with the CPU
on the entry path.

Shenming Lu (2):
  irqchip/gic-v4.1: Reduce the delay time of the poll on the
    GICR_VPENDBASER.Dirty bit
  KVM: arm64: Delay the execution of the polling on the
    GICR_VPENDBASER.Dirty bit

 arch/arm64/kvm/vgic/vgic-v4.c      | 16 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         |  3 +++
 drivers/irqchip/irq-gic-v3-its.c   | 18 +++++++++++++-----
 drivers/irqchip/irq-gic-v4.c       | 11 +++++++++++
 include/kvm/arm_vgic.h             |  3 +++
 include/linux/irqchip/arm-gic-v4.h |  4 ++++
 6 files changed, 50 insertions(+), 5 deletions(-)

-- 
2.23.0

