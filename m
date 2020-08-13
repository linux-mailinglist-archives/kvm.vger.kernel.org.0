Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AECE2433D2
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 08:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMGOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 02:14:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34818 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726082AbgHMGOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 02:14:23 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5140E343D469CCE347CC;
        Thu, 13 Aug 2020 14:14:14 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 13 Aug 2020 14:14:06 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <zhang.zhanghailiang@huawei.com>, <xiexiangyou@huawei.com>,
        Peng Liang <liangpeng10@huawei.com>
Subject: [RFC 3/4] kvm: arm64: make ID registers configurable
Date:   Thu, 13 Aug 2020 14:05:16 +0800
Message-ID: <20200813060517.2360048-4-liangpeng10@huawei.com>
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

It's time to make ID registers configurable.  When userspace (but not
guest) want to set the values of ID registers, save the value in
kvm_arch_vcpu so that guest can read the modified values.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/kvm/sys_regs.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 776c2757a01e..f98635489966 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1111,6 +1111,14 @@ static u64 kvm_get_id_reg(struct kvm_vcpu *vcpu, u64 id)
 	return ri->sys_val;
 }
 
+static void kvm_set_id_reg(struct kvm_vcpu *vcpu, u64 id, u64 value)
+{
+	struct id_reg_info *ri = kvm_id_reg(vcpu, id);
+
+	BUG_ON(!ri);
+	ri->sys_val = value;
+}
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
@@ -1252,10 +1260,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 
 /*
  * cpufeature ID register user accessors
- *
- * For now, these registers are immutable for userspace, so no values
- * are stored, and for set_id_reg() we don't allow the effective value
- * to be changed.
  */
 static int __get_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
@@ -1279,9 +1283,14 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
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
+		kvm_set_id_reg(vcpu, reg_id, val);
+	}
 
 	return 0;
 }
-- 
2.18.4

