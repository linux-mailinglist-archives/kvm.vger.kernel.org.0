Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABEE339D02
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 09:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhCMIkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Mar 2021 03:40:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13601 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbhCMIjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Mar 2021 03:39:51 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DyGKM61grz17KSR;
        Sat, 13 Mar 2021 16:37:59 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 13 Mar 2021 16:39:42 +0800
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
Subject: [PATCH v4 3/6] KVM: arm64: GICv4.1: Add function to get VLPI state
Date:   Sat, 13 Mar 2021 16:38:57 +0800
Message-ID: <20210313083900.234-4-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210313083900.234-1-lushenming@huawei.com>
References: <20210313083900.234-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With GICv4.1 and the vPE unmapped, which indicates the invalidation
of any VPT caches associated with the vPE, we can get the VLPI state
by peeking at the VPT. So we add a function for this.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 19 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h    |  1 +
 2 files changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 66508b03094f..ac029ba3d337 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -203,6 +203,25 @@ void vgic_v4_configure_vsgis(struct kvm *kvm)
 	kvm_arm_resume_guest(kvm);
 }
 
+/*
+ * Must be called with GICv4.1 and the vPE unmapped, which
+ * indicates the invalidation of any VPT caches associated
+ * with the vPE, thus we can get the VLPI state by peeking
+ * at the VPT.
+ */
+void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val)
+{
+	struct its_vpe *vpe = &irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+	int mask = BIT(irq->intid % BITS_PER_BYTE);
+	void *va;
+	u8 *ptr;
+
+	va = page_address(vpe->vpt_page);
+	ptr = va + irq->intid / BITS_PER_BYTE;
+
+	*val = !!(*ptr & mask);
+}
+
 /**
  * vgic_v4_init - Initialize the GICv4 data structures
  * @kvm:	Pointer to the VM being initialized
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 64fcd7511110..d8cfd360838c 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -317,5 +317,6 @@ bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
+void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
 
 #endif
-- 
2.19.1

