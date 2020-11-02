Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C716F2A2382
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 04:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgKBDhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 22:37:12 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7394 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727694AbgKBDhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Nov 2020 22:37:12 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CPdrj3QvSz6ytt;
        Mon,  2 Nov 2020 11:37:09 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:02 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v3 01/12] arm64: Add a helper function to traverse arm64_ftr_regs
Date:   Mon, 2 Nov 2020 11:34:11 +0800
Message-ID: <20201102033422.657391-2-liangpeng10@huawei.com>
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
index f7e7144af174..8ea2c4307708 100644
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
index dcc165b3fc04..6e31d3fbd791 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2855,3 +2855,16 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 
 	return sprintf(buf, "Vulnerable\n");
 }
+
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
-- 
2.26.2

