Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFE426DB2B
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 14:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgIQMKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 08:10:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbgIQMJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 08:09:42 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9FAD6888B4ACF4426B70;
        Thu, 17 Sep 2020 20:09:39 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:09:31 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v2 3/7] kvm: arm64: save ID registers to sys_regs file
Date:   Thu, 17 Sep 2020 20:00:57 +0800
Message-ID: <20200917120101.3438389-4-liangpeng10@huawei.com>
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

To emulate the ID registers, we need a place to storage the values of
the ID regsiters.  Maybe putting them in sysreg file is a good idea.

This commit has no functional changes but only code refactor.  When
initializing a vCPU, get the values of the ID registers from
arm64_ftr_regs and storage them in sysreg file.  And we just read
the value from sysreg file when getting/setting the value of the ID
regs.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/include/asm/kvm_coproc.h |  2 ++
 arch/arm64/include/asm/kvm_host.h   |  3 +++
 arch/arm64/kvm/arm.c                |  2 ++
 arch/arm64/kvm/sys_regs.c           | 33 +++++++++++++++++++++++++----
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
index d6bb40122fdb..76e8c3cb0662 100644
--- a/arch/arm64/include/asm/kvm_coproc.h
+++ b/arch/arm64/include/asm/kvm_coproc.h
@@ -35,4 +35,6 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
 int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
 unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu);
 
+void kvm_arm_sys_reg_init(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_COPROC_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 905c2b87e05a..50152e364c4f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -184,6 +184,9 @@ enum vcpu_sysreg {
 	CNTP_CVAL_EL0,
 	CNTP_CTL_EL0,
 
+	ID_REG_BASE,
+	ID_REG_END = ID_REG_BASE + 55,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b588c3b5c2f0..6d961e192268 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -274,6 +274,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
+	kvm_arm_sys_reg_init(vcpu);
+
 	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 077293b5115f..2b0fa8d5ac62 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1119,13 +1119,16 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+#define ID_REG_INDEX(id)						\
+	(ID_REG_BASE + (((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id)))
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
-static u64 read_id_reg(const struct kvm_vcpu *vcpu,
+static u64 read_id_reg(struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
-	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
+	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, ID_REG_INDEX(id));
 
 	if (id == SYS_ID_AA64PFR0_EL1) {
 		if (!vcpu_has_sve(vcpu))
@@ -1265,7 +1268,7 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
  * are stored, and for set_id_reg() we don't allow the effective value
  * to be changed.
  */
-static int __get_id_reg(const struct kvm_vcpu *vcpu,
+static int __get_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
@@ -1275,7 +1278,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
 	return reg_to_user(uaddr, &val, id);
 }
 
-static int __set_id_reg(const struct kvm_vcpu *vcpu,
+static int __set_id_reg(struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd, void __user *uaddr,
 			bool raz)
 {
@@ -2854,3 +2857,25 @@ void kvm_sys_reg_table_init(void)
 	/* Clear all higher bits. */
 	cache_levels &= (1 << (i*3))-1;
 }
+
+static int get_cpu_ftr(u32 id, u64 val, void *argp)
+{
+	struct kvm_vcpu *vcpu = argp;
+
+	/*
+	 * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
+	 * where 1<=crm<8, 0<=op2<8.
+	 */
+	if (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
+	    sys_reg_CRn(id) == 0 && sys_reg_CRm(id) > 0 &&
+	    sys_reg_CRm(id) < 8) {
+		__vcpu_sys_reg(vcpu, ID_REG_INDEX(id)) = val;
+	}
+
+	return 0;
+}
+
+void kvm_arm_sys_reg_init(struct kvm_vcpu *vcpu)
+{
+	arm64_cpu_ftr_regs_traverse(get_cpu_ftr, vcpu);
+}
-- 
2.26.2

