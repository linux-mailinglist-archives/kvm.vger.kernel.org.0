Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C3026DB27
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 14:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgIQMJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 08:09:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgIQMJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 08:09:42 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8BAC0ADBD8F834A00E22;
        Thu, 17 Sep 2020 20:09:34 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:09:24 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v2 2/7] arm64: introduce check_features
Date:   Thu, 17 Sep 2020 20:00:56 +0800
Message-ID: <20200917120101.3438389-3-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917120101.3438389-1-liangpeng10@huawei.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To emulate ID registers, we need to validate the value of the register
defined by user space.  For most ID registers, we need to check whether
each field defined by user space is no more than that of host (whether
host support the corresponding features) and whether the fields are
supposed to be exposed to guest.  Introduce check_features to do those
jobs.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h |  2 ++
 arch/arm64/kernel/cpufeature.c      | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 2ba7c4f11d8a..954adc5ca72f 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -579,6 +579,8 @@ void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
 
+int check_features(u32 sys_reg, u64 val);
+
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
 	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 698b32705544..e58926992a70 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2850,3 +2850,26 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 
 	return sprintf(buf, "Vulnerable\n");
 }
+
+int check_features(u32 sys_reg, u64 val)
+{
+	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
+	const struct arm64_ftr_bits *ftrp;
+	u64 exposed_mask = 0;
+
+	if (!reg)
+		return -ENOENT;
+
+	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
+		if (arm64_ftr_value(ftrp, reg->sys_val) <
+		    arm64_ftr_value(ftrp, val)) {
+			return -EINVAL;
+		}
+		exposed_mask |= arm64_ftr_mask(ftrp);
+	}
+
+	if (val & ~exposed_mask)
+		return -EINVAL;
+
+	return 0;
+}
-- 
2.26.2

