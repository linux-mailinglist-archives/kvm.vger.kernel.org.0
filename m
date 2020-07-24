Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D4022C179
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgGXIzl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:55:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55964 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727109AbgGXIzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 04:55:41 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E57FCE0BEBBE4295DAF2;
        Fri, 24 Jul 2020 16:55:38 +0800 (CST)
Received: from huawei.com (10.174.187.31) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Jul 2020
 16:55:29 +0800
From:   Yifei Jiang <jiangyifei@huawei.com>
To:     <pbonzini@redhat.com>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>
CC:     <anup.patel@wdc.com>, <atish.patra@wdc.com>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <victor.zhangxiaofeng@huawei.com>,
        <wu.wubin@huawei.com>, <zhang.zhanghailiang@huawei.com>,
        <dengkai1@huawei.com>, <limingwang@huawei.com>,
        Yifei Jiang <jiangyifei@huawei.com>
Subject: [RFC 2/2] RISC-V: KVM: read\write kernel mmio device support
Date:   Fri, 24 Jul 2020 16:54:41 +0800
Message-ID: <20200724085441.1514-3-jiangyifei@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200724085441.1514-1-jiangyifei@huawei.com>
References: <20200724085441.1514-1-jiangyifei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.187.31]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Mingwang Li <limingwang@huawei.com>
---
 arch/riscv/kvm/vcpu_exit.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index e97ba96cb0ae..448f11179fa8 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -191,6 +191,8 @@ static int virtual_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long fault_addr, unsigned long htinst)
 {
+	int ret;
+	u8 data_buf[8];
 	unsigned long insn;
 	int shift = 0, len = 0;
 	struct kvm_cpu_trap utrap = { 0 };
@@ -272,19 +274,32 @@ static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	vcpu->arch.mmio_decode.len = len;
 	vcpu->arch.mmio_decode.return_handled = 0;
 
-	/* Exit to userspace for MMIO emulation */
-	vcpu->stat.mmio_exit_user++;
-	run->exit_reason = KVM_EXIT_MMIO;
+	ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_addr, len,
+						  data_buf);
+
 	run->mmio.is_write = false;
 	run->mmio.phys_addr = fault_addr;
 	run->mmio.len = len;
 
+	if (!ret) {
+		/* We handled the access successfully in the kernel. */
+		memcpy(run->mmio.data, data_buf, len);
+		vcpu->stat.mmio_exit_kernel++;
+		kvm_riscv_vcpu_mmio_return(vcpu, run);
+		return 1;
+	}
+
+	/* Exit to userspace for MMIO emulation */
+	vcpu->stat.mmio_exit_user++;
+	run->exit_reason = KVM_EXIT_MMIO;
+
 	return 0;
 }
 
 static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			 unsigned long fault_addr, unsigned long htinst)
 {
+	int ret;
 	u8 data8;
 	u16 data16;
 	u32 data32;
@@ -378,13 +393,24 @@ static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		return -ENOTSUPP;
 	};
 
-	/* Exit to userspace for MMIO emulation */
-	vcpu->stat.mmio_exit_user++;
-	run->exit_reason = KVM_EXIT_MMIO;
+	ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, fault_addr, len,
+						   run->mmio.data);
+
 	run->mmio.is_write = true;
 	run->mmio.phys_addr = fault_addr;
 	run->mmio.len = len;
 
+	if (!ret) {
+		/* We handled the access successfully in the kernel. */
+		vcpu->stat.mmio_exit_kernel++;
+		kvm_riscv_vcpu_mmio_return(vcpu, run);
+		return 1;
+	}
+
+	/* Exit to userspace for MMIO emulation */
+	vcpu->stat.mmio_exit_user++;
+	run->exit_reason = KVM_EXIT_MMIO;
+
 	return 0;
 }
 
-- 
2.19.1


