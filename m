Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A472C0056
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 07:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgKWGy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 01:54:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8013 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgKWGy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Nov 2020 01:54:59 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CfdDt1V1Kzhg2q;
        Mon, 23 Nov 2020 14:54:38 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 14:54:49 +0800
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
Subject: [RFC PATCH v1 4/4] KVM: arm64: GICv4.1: Give a chance to save VLPI's pending state
Date:   Mon, 23 Nov 2020 14:54:10 +0800
Message-ID: <20201123065410.1915-5-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20201123065410.1915-1-lushenming@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before GICv4.1, we do not have direct access to the VLPI's pending
state. So we simply let it fail early when encountering any VLPI.

But now we don't have to return -EACCES directly if on GICv4.1. So
let’s change the hard code and give a chance to save the VLPI's pending
state (and preserve the interfaces).

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 Documentation/virt/kvm/devices/arm-vgic-its.rst | 2 +-
 arch/arm64/kvm/vgic/vgic-its.c                  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-its.rst b/Documentation/virt/kvm/devices/arm-vgic-its.rst
index 6c304fd2b1b4..d257eddbae29 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-its.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-its.rst
@@ -80,7 +80,7 @@ KVM_DEV_ARM_VGIC_GRP_CTRL
     -EFAULT  Invalid guest ram access
     -EBUSY   One or more VCPUS are running
     -EACCES  The virtual ITS is backed by a physical GICv4 ITS, and the
-	     state is not available
+	     state is not available without GICv4.1
     =======  ==========================================================
 
 KVM_DEV_ARM_VGIC_GRP_ITS_REGS
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 40cbaca81333..ec7543a9617c 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2218,10 +2218,10 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 		/*
 		 * If an LPI carries the HW bit, this means that this
 		 * interrupt is controlled by GICv4, and we do not
-		 * have direct access to that state. Let's simply fail
-		 * the save operation...
+		 * have direct access to that state without GICv4.1.
+		 * Let's simply fail the save operation...
 		 */
-		if (ite->irq->hw)
+		if (ite->irq->hw && !kvm_vgic_global_state.has_gicv4_1)
 			return -EACCES;
 
 		ret = vgic_its_save_ite(its, device, ite, gpa, ite_esz);
-- 
2.23.0

