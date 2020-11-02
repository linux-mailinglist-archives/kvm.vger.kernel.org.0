Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC142A2388
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 04:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgKBDhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 22:37:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7129 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbgKBDhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Nov 2020 22:37:21 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CPdrs4q4JzLsbq;
        Mon,  2 Nov 2020 11:37:17 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:13 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v3 05/12] kvm: arm64: Make ID_AA64DFR0_EL1 configurable
Date:   Mon, 2 Nov 2020 11:34:15 +0800
Message-ID: <20201102033422.657391-6-liangpeng10@huawei.com>
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

Except that each ID field should be not greater than that of host,
PMUVer must be 0b0100 (PMUv3 for Armv8.1).

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bcc57cbe0421..3954b7a21a4b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1367,6 +1367,32 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
+		const struct sys_reg_desc *rd,
+		const struct kvm_one_reg *reg, void __user *uaddr)
+{
+	u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
+			     (u32)rd->CRm, (u32)rd->Op2);
+	int err;
+	u64 val;
+
+	err = reg_from_user(&val, uaddr, sys_reg_to_index(rd));
+	if (err)
+		return err;
+
+	err = check_features(reg_id, val);
+	if (err)
+		return err;
+
+	/* Limit guests to PMUv3 for ARMv8.1 */
+	if (cpuid_feature_extract_signed_field(val, ID_AA64DFR0_PMUVER_SHIFT) !=
+	    ID_AA64DFR0_PMUVER_8_1)
+		return -EINVAL;
+
+	__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
+	return 0;
+}
+
 static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
 {
@@ -1571,7 +1597,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,7),
 
 	/* CRm=5 */
-	ID_SANITISED(ID_AA64DFR0_EL1),
+	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), access_id_reg, .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1 },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.26.2

