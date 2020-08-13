Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9D72433CE
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 08:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHMGOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 02:14:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34836 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbgHMGOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 02:14:21 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 55FC52C6ECCEE54F846D;
        Thu, 13 Aug 2020 14:14:14 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 13 Aug 2020 14:14:03 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <zhang.zhanghailiang@huawei.com>, <xiexiangyou@huawei.com>,
        Peng Liang <liangpeng10@huawei.com>
Subject: [RFC 1/4] arm64: add a helper function to traverse arm64_ftr_regs
Date:   Thu, 13 Aug 2020 14:05:14 +0800
Message-ID: <20200813060517.2360048-2-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200813060517.2360048-1-liangpeng10@huawei.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we want to emulate ID registers, we need to initialize ID registers
firstly.  This commit is to add a helper function to traverse
arm64_ftr_regs so that we can initialize ID registers from
arm64_ftr_regs.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h |  2 ++
 arch/arm64/kernel/cpufeature.c      | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 89b4f0142c28..2ba7c4f11d8a 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -79,6 +79,8 @@ struct arm64_ftr_reg {
 
 extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 
+int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp);
+
 /*
  * CPU capabilities:
  *
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a389b999482e..eb4c78b85a35 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1112,6 +1112,19 @@ u64 read_sanitised_ftr_reg(u32 id)
 	return regp->sys_val;
 }
 
+int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp)
+{
+	int i, ret;
+
+	for (i = 0; i <  ARRAY_SIZE(arm64_ftr_regs); i++) {
+		ret = (*op)(arm64_ftr_regs[i].sys_id,
+			    arm64_ftr_regs[i].reg->sys_val, argp);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
 #define read_sysreg_case(r)	\
 	case r:		return read_sysreg_s(r)
 
-- 
2.18.4

