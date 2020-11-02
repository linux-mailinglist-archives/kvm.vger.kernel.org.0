Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A4E2A2395
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 04:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgKBDhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Nov 2020 22:37:40 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7026 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgKBDhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Nov 2020 22:37:37 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CPdsC168PzhfbV;
        Mon,  2 Nov 2020 11:37:35 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 11:37:24 +0800
From:   Peng Liang <liangpeng10@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     <kvm@vger.kernel.org>, <maz@kernel.org>, <will@kernel.org>,
        <drjones@redhat.com>, <zhang.zhanghailiang@huawei.com>,
        <xiexiangyou@huawei.com>, Peng Liang <liangpeng10@huawei.com>
Subject: [RFC v3 11/12] kvm: arm64: Check consistent of ID register
Date:   Mon, 2 Nov 2020 11:34:21 +0800
Message-ID: <20201102033422.657391-12-liangpeng10@huawei.com>
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

All vCPUs in same VM need to have same values of ID registers.  If not,
the vCPU is not allowed to run.

Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
Signed-off-by: Peng Liang <liangpeng10@huawei.com>
---
 arch/arm64/kvm/arm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5a153a109317..0d7c4d4ab204 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -515,6 +515,22 @@ static void update_vmid(struct kvm_vmid *vmid)
 	spin_unlock(&kvm_vmid_lock);
 }
 
+static bool kvm_arm_id_regs_are_consistent(const struct kvm_vcpu *vcpu)
+{
+	int i, j;
+	int online_vcpus = atomic_read(&vcpu->kvm->online_vcpus);
+
+	for (i = 0; i < online_vcpus; ++i) {
+		if (memcmp(vcpu->arch.ctxt.sys_regs + ID_REG_BASE,
+			   vcpu->kvm->vcpus[i]->arch.ctxt.sys_regs + ID_REG_BASE,
+			   sizeof(vcpu->arch.ctxt.sys_regs[0]) * KVM_ARM_ID_REG_MAX_NUM)) {
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -526,6 +542,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	if (!kvm_arm_id_regs_are_consistent(vcpu))
+		return -EPERM;
+
 	vcpu->arch.has_run_once = true;
 
 	if (likely(irqchip_in_kernel(kvm))) {
-- 
2.26.2

