Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125E426DB2F
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 14:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgIQMKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 08:10:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56938 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726913AbgIQMJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 08:09:56 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CDA60E3FA0CC72DCA40F;
        Thu, 17 Sep 2020 20:09:54 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:09:48 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v2 6/7] kvm: arm64: make ID registers configurable
Date:   Thu, 17 Sep 2020 20:01:00 +0800
Message-ID: <20200917120101.3438389-7-liangpeng10@huawei.com>
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

It's time to make ID registers configurable.  When userspace (but not
guest) want to set the values of ID registers, save the value in
sysreg file so that guest can read the modified values.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a642ecfebe0a..881b66494524 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1263,10 +1263,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 
 /*
  * cpufeature ID register user accessors
- *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
  */
 static int __get_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1290,9 +1286,15 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (err)
 		return err;
 
-	/* This is what we mean by invariant: you can't change it. */
-	if (val != read_id_reg(vcpu, rd, raz))
-		return -EINVAL;
+	if (raz) {
+		if (val != read_id_reg(vcpu, rd, raz))
+			return -EINVAL;
+	} else {
+		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
+				     (u32)rd->CRm, (u32)rd->Op2);
+		/* val should be checked in check_user */
+		__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
+	}
 
 	return 0;
 }
-- 
2.26.2

