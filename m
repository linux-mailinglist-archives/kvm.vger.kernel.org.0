Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88972A2394
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 04:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgKBDhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 22:37:38 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7027 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbgKBDhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Nov 2020 22:37:37 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CPdsC0vbdzhfWl;
        Mon,  2 Nov 2020 11:37:35 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:26 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v3 12/12] kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
Date:   Mon, 2 Nov 2020 11:34:22 +0800
Message-ID: <20201102033422.657391-13-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102033422.657391-1-liangpeng10@huawei.com>
References: <20201102033422.657391-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add KVM_CAP_ARM_CPU_FEATURE extension for userpace to check whether KVM
supports to set CPU features in AArch64.  Also add documents for it.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 Documentation/virt/kvm/api.rst | 36 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/arm.c           |  1 +
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 38 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 36d5f1f3c6dd..3086a0d24548 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2488,6 +2488,34 @@ EINVAL.
 After the vcpu's SVE configuration is finalized, further attempts to
 write this register will fail with EPERM.
 
+In AArch64, ID registers (where Op0=3, Op1=0, CRn=0, 1<=CRm<8, 0<=Op2<8)
+are allowed to set by userspace but there are some limits:
+1. Each ID field in ID registers should be no greater than that of host.
+   Except ID_AA64PFR0_EL1.CSV2, which is allowed to set to 1 if the value of
+   host is 0;
+2. ID_AA64PFR0_EL1.FP and ID_AA64PFR0_EL1.AdvSIMD must have the same value;
+3. If the vCPU has no SVE, then ID_AA64PFR0_EL1.SVE must be 0;
+4. ID_AA64PFR0_EL1.AMU must be 0;
+5. ID_AA64DFR0_EL1.PMUVer must be 0b0100 (PMUv3 for Armv8.1);
+   ID_DFR0_EL1.PerfMon must be 0b0100 (PMUv3 for Armv8.1);
+6. ID_AA64ISAR0_EL1.SM3 and ID_AA64ISAR0_EL1.SM4 must have the same value;
+7. If the value of ID_AA64ISAR0_EL1.SHA1 is 0, then ID_AA64ISAR0_EL1.SHA2
+   must have the value 0, and vice versa; if the value of
+   ID_AA64ISAR0_EL1.SHA2 is 2, then ID_AA64ISAR0_EL1.SHA3 must have the value
+   1, and vice versa; if the value of ID_AA64ISAR0_EL1.SHA1 is 0, then
+   ID_AA64ISAR0_EL1.SHA3 must have the value 0;
+8. If the vCPU has not enabled Generic Pointer authentication, then
+   ID_AA64ISAR1_EL1.GPA, ID_AA64ISAR1_EL1.GPI, ID_AA64ISAR1_EL1.APA, and
+   ID_AA64ISAR1_EL1.API must be 0.  Otherwise, if the value of
+   ID_AA64ISAR1_EL1.GPA is non-zero, then ID_AA64ISAR1_EL1.GPI must have
+   the value 0; if the value of ID_AA64ISAR1_EL1.GPI is non-zero, then
+   ID_AA64ISAR1_EL1.GPA must have the value 0; if the value of
+   ID_AA64ISAR1_EL1.APA is non-zero, then ID_AA64ISAR1_EL1.API must have the
+   value 0; if the value of ID_AA64ISAR1_EL1.API is non-zero, then
+   ID_AA64ISAR1_EL1.APA must have the value 0;
+9. The allowed value pair of (MVFR1_EL1.FPHP, MVFR1_EL1.SIMDHP) are (0, 0),
+   (2, 1), and (3, 2).
+
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -6391,3 +6419,11 @@ When enabled, KVM will disable paravirtual features provided to the
 guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
+
+8.27 KVM_CAP_ARM_CPU_FEATURE
+----------------------------
+
+:Architecture: arm64
+
+This capability indicates that userspace can modify the ID registers via
+KVM_SET_ONE_REG ioctl.  See KVM_SET_ONE_REG:ARM64 ID Registers for limits.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0d7c4d4ab204..e184756b2b37 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -182,6 +182,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
+	case KVM_CAP_ARM_CPU_FEATURE:
 		r = 1;
 		break;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..bce49fab436c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1053,6 +1053,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_USER_SPACE_MSR 188
 #define KVM_CAP_X86_MSR_FILTER 189
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
+#define KVM_CAP_ARM_CPU_FEATURE 191
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.26.2

