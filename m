Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FD026D150
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 04:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgIQCq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 22:46:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60194 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgIQCqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 22:46:55 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B355FE72A94ED350DBC9;
        Thu, 17 Sep 2020 10:31:01 +0800 (CST)
Received: from localhost (10.174.185.104) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 10:30:53 +0800
From:   Ying Fang <fangying1@huawei.com>
To:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <maz@kernel.org>
CC:     <drjones@redhat.com>, <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>,
        <zhang.zhanghailiang@huawei.com>, <alex.chen@huawei.com>,
        Ying Fang <fangying1@huawei.com>
Subject: [PATCH 1/2] KVM: arm64: add KVM_CAP_ARM_MP_AFFINITY extension
Date:   Thu, 17 Sep 2020 10:30:32 +0800
Message-ID: <20200917023033.1337-2-fangying1@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20200917023033.1337-1-fangying1@huawei.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.185.104]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM_CAP_ARM_MP_AFFINITY extension for userspace to check
whether KVM supports setting MPIDR on AArch64 platform. Thus
we can give userspace control over the MPIDR to present
cpu topology information.

Signed-off-by: Ying Fang <fangying1@huawei.com>
---
 Documentation/virt/kvm/api.rst | 8 ++++++++
 arch/arm64/kvm/arm.c           | 1 +
 include/uapi/linux/kvm.h       | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eb3a1316f03e..d2fb18613a34 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6159,3 +6159,11 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.24 KVM_CAP_ARM_MP_AFFINITY
+----------------------------
+
+:Architecture: arm64
+
+This capability indicates that KVM_ARM_SET_MP_AFFINITY ioctl is available.
+It is used by to set MPIDR from userspace.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 46dc3d75cf13..913c8da539b3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -178,6 +178,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
+	case KVM_CAP_ARM_MP_AFFINITY:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..c4874905cd9c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_ARM_MP_AFFINITY 187
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.23.0

