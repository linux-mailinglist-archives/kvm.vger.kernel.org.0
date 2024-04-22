Return-Path: <kvm+bounces-15570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C2F8AD58E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB394B252F5
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01F9156F21;
	Mon, 22 Apr 2024 20:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M1i8nKba"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED672156C76
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 20:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713816165; cv=none; b=dWObXSJDembpCkwzv58GP1Wc5loCowqLJupt/T+yPIrER5SXkchjeJ61A+rH0RAfhIBaFuOtojqm0d1pUO/LL0iC7vRjXVEivAo24GkjrTRLqhu+amd02PTjVpFdceJqQIkSqrJW983qbzoffpjTf7s3Okad62BIVrwWBO5N2YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713816165; c=relaxed/simple;
	bh=/we5pZwexRVUnIQKiBNnloT0WOLeMcpaP/c2X8EU1u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmM7jrqIBzbWsWMseTyrulrIRRY7pE+C0YKdDcni3GmxRo5ZkNyayfzNbxm1zSUVSGzvhKd56BM8PXRe9BKSa+jEFk3tNOt9VY0TZvOG7JYmH6Q50dHMubUw4ieIebaA9BiVMXxkwiByj9Xcsp3XnSkfAxW5Tas7iZ6mNhO86A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M1i8nKba; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713816161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Mz4yeVvP7HvtU0rzAd6JkNrN6eNN/DqBgwZhydf/AM=;
	b=M1i8nKbaVGij5qmKN1wGZ7Yw/G5CHBc7YKzg7fvHTpH6wLVgu4Z1kioRnO0LiHZlOGKHB8
	LjtolyF2dFYf2KVmHr9c9JiLoCnp4If57LRYqzi1B+lv0yibsJDRA8qprsWfs0bkCRzPrM
	lcItOdLGKaMIPcf569sAszQ4BDNi/Jc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 16/19] KVM: selftests: Add a minimal library for interacting with an ITS
Date: Mon, 22 Apr 2024 20:01:55 +0000
Message-ID: <20240422200158.2606761-17-oliver.upton@linux.dev>
In-Reply-To: <20240422200158.2606761-1-oliver.upton@linux.dev>
References: <20240422200158.2606761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A prerequisite of testing LPI injection performance is of course
instantiating an ITS for the guest. Add a small library for creating an
ITS and interacting with it from the guest.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/aarch64/gic.h       |   8 +-
 .../kvm/include/aarch64/gic_v3_its.h          |  19 ++
 .../selftests/kvm/include/aarch64/vgic.h      |   2 +
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    | 248 ++++++++++++++++++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  18 ++
 6 files changed, 295 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 741c7dc16afc..4335e5744cc6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -45,6 +45,7 @@ LIBKVM_x86_64 += lib/x86_64/vmx.c
 
 LIBKVM_aarch64 += lib/aarch64/gic.c
 LIBKVM_aarch64 += lib/aarch64/gic_v3.c
+LIBKVM_aarch64 += lib/aarch64/gic_v3_its.c
 LIBKVM_aarch64 += lib/aarch64/handlers.S
 LIBKVM_aarch64 += lib/aarch64/processor.c
 LIBKVM_aarch64 += lib/aarch64/spinlock.c
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 53617b3f52cf..6d03188435e4 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -13,10 +13,16 @@ enum gic_type {
 	GIC_TYPE_MAX,
 };
 
-#define GICD_BASE_GPA		0x8000000ULL
+/*
+ * Note that the redistributor frames are at the end, as the range scales
+ * with the number of vCPUs in the VM.
+ */
+#define GITS_BASE_GPA		0x8000000ULL
+#define GICD_BASE_GPA		(GITS_BASE_GPA + KVM_VGIC_V3_ITS_SIZE)
 #define GICR_BASE_GPA		(GICD_BASE_GPA + KVM_VGIC_V3_DIST_SIZE)
 
 /* The GIC is identity-mapped into the guest at the time of setup. */
+#define GITS_BASE_GVA		((volatile void *)GITS_BASE_GPA)
 #define GICD_BASE_GVA		((volatile void *)GICD_BASE_GPA)
 #define GICR_BASE_GVA		((volatile void *)GICR_BASE_GPA)
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h b/tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
new file mode 100644
index 000000000000..3722ed9c8f96
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __SELFTESTS_GIC_V3_ITS_H__
+#define __SELFTESTS_GIC_V3_ITS_H__
+
+#include <linux/sizes.h>
+
+void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
+	      vm_paddr_t device_tbl, size_t device_tbl_sz,
+	      vm_paddr_t cmdq, size_t cmdq_size);
+
+void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
+		       size_t itt_size, bool valid);
+void its_send_mapc_cmd(void *cmdq_base, u32 vcpu_id, u32 collection_id, bool valid);
+void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
+			u32 collection_id, u32 intid);
+void its_send_invall_cmd(void *cmdq_base, u32 collection_id);
+
+#endif // __SELFTESTS_GIC_V3_ITS_H__
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index ce19aa0a8360..c481d0c00a5d 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -32,4 +32,6 @@ void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu);
 
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
+int vgic_its_setup(struct kvm_vm *vm);
+
 #endif // SELFTEST_KVM_VGIC_H
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c
new file mode 100644
index 000000000000..09f270545646
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Guest ITS library, generously donated by drivers/irqchip/irq-gic-v3-its.c
+ * over in the kernel tree.
+ */
+
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+#include <asm/kvm_para.h>
+#include <asm/kvm.h>
+
+#include "kvm_util.h"
+#include "vgic.h"
+#include "gic.h"
+#include "gic_v3.h"
+#include "processor.h"
+
+static u64 its_read_u64(unsigned long offset)
+{
+	return readq_relaxed(GITS_BASE_GVA + offset);
+}
+
+static void its_write_u64(unsigned long offset, u64 val)
+{
+	writeq_relaxed(val, GITS_BASE_GVA + offset);
+}
+
+static u32 its_read_u32(unsigned long offset)
+{
+	return readl_relaxed(GITS_BASE_GVA + offset);
+}
+
+static void its_write_u32(unsigned long offset, u32 val)
+{
+	writel_relaxed(val, GITS_BASE_GVA + offset);
+}
+
+static unsigned long its_find_baser(unsigned int type)
+{
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		u64 baser;
+		unsigned long offset = GITS_BASER + (i * sizeof(baser));
+
+		baser = its_read_u64(offset);
+		if (GITS_BASER_TYPE(baser) == type)
+			return offset;
+	}
+
+	GUEST_FAIL("Couldn't find an ITS BASER of type %u", type);
+	return -1;
+}
+
+static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
+{
+	unsigned long offset = its_find_baser(type);
+	u64 baser;
+
+	baser = ((size / SZ_64K) - 1) |
+		GITS_BASER_PAGE_SIZE_64K |
+		GITS_BASER_InnerShareable |
+		base |
+		GITS_BASER_RaWaWb |
+		GITS_BASER_VALID;
+
+	its_write_u64(offset, baser);
+}
+
+static void its_install_cmdq(vm_paddr_t base, size_t size)
+{
+	u64 cbaser;
+
+	cbaser = ((size / SZ_4K) - 1) |
+		 GITS_CBASER_InnerShareable |
+		 base |
+		 GITS_CBASER_RaWaWb |
+		 GITS_CBASER_VALID;
+
+	its_write_u64(GITS_CBASER, cbaser);
+}
+
+void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
+	      vm_paddr_t device_tbl, size_t device_tbl_sz,
+	      vm_paddr_t cmdq, size_t cmdq_size)
+{
+	u32 ctlr;
+
+	its_install_table(GITS_BASER_TYPE_COLLECTION, coll_tbl, coll_tbl_sz);
+	its_install_table(GITS_BASER_TYPE_DEVICE, device_tbl, device_tbl_sz);
+	its_install_cmdq(cmdq, cmdq_size);
+
+	ctlr = its_read_u32(GITS_CTLR);
+	ctlr |= GITS_CTLR_ENABLE;
+	its_write_u32(GITS_CTLR, ctlr);
+}
+
+struct its_cmd_block {
+	union {
+		u64	raw_cmd[4];
+		__le64	raw_cmd_le[4];
+	};
+};
+
+static inline void its_fixup_cmd(struct its_cmd_block *cmd)
+{
+	/* Let's fixup BE commands */
+	cmd->raw_cmd_le[0] = cpu_to_le64(cmd->raw_cmd[0]);
+	cmd->raw_cmd_le[1] = cpu_to_le64(cmd->raw_cmd[1]);
+	cmd->raw_cmd_le[2] = cpu_to_le64(cmd->raw_cmd[2]);
+	cmd->raw_cmd_le[3] = cpu_to_le64(cmd->raw_cmd[3]);
+}
+
+static void its_mask_encode(u64 *raw_cmd, u64 val, int h, int l)
+{
+	u64 mask = GENMASK_ULL(h, l);
+	*raw_cmd &= ~mask;
+	*raw_cmd |= (val << l) & mask;
+}
+
+static void its_encode_cmd(struct its_cmd_block *cmd, u8 cmd_nr)
+{
+	its_mask_encode(&cmd->raw_cmd[0], cmd_nr, 7, 0);
+}
+
+static void its_encode_devid(struct its_cmd_block *cmd, u32 devid)
+{
+	its_mask_encode(&cmd->raw_cmd[0], devid, 63, 32);
+}
+
+static void its_encode_event_id(struct its_cmd_block *cmd, u32 id)
+{
+	its_mask_encode(&cmd->raw_cmd[1], id, 31, 0);
+}
+
+static void its_encode_phys_id(struct its_cmd_block *cmd, u32 phys_id)
+{
+	its_mask_encode(&cmd->raw_cmd[1], phys_id, 63, 32);
+}
+
+static void its_encode_size(struct its_cmd_block *cmd, u8 size)
+{
+	its_mask_encode(&cmd->raw_cmd[1], size, 4, 0);
+}
+
+static void its_encode_itt(struct its_cmd_block *cmd, u64 itt_addr)
+{
+	its_mask_encode(&cmd->raw_cmd[2], itt_addr >> 8, 51, 8);
+}
+
+static void its_encode_valid(struct its_cmd_block *cmd, int valid)
+{
+	its_mask_encode(&cmd->raw_cmd[2], !!valid, 63, 63);
+}
+
+static void its_encode_target(struct its_cmd_block *cmd, u64 target_addr)
+{
+	its_mask_encode(&cmd->raw_cmd[2], target_addr >> 16, 51, 16);
+}
+
+static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
+{
+	its_mask_encode(&cmd->raw_cmd[2], col, 15, 0);
+}
+
+#define GITS_CMDQ_POLL_ITERATIONS	0
+
+static void its_send_cmd(void *cmdq_base, struct its_cmd_block *cmd)
+{
+	u64 cwriter = its_read_u64(GITS_CWRITER);
+	struct its_cmd_block *dst = cmdq_base + cwriter;
+	u64 cbaser = its_read_u64(GITS_CBASER);
+	size_t cmdq_size;
+	u64 next;
+	int i;
+
+	cmdq_size = ((cbaser & 0xFF) + 1) * SZ_4K;
+
+	its_fixup_cmd(cmd);
+
+	WRITE_ONCE(*dst, *cmd);
+	dsb(ishst);
+	next = (cwriter + sizeof(*cmd)) % cmdq_size;
+	its_write_u64(GITS_CWRITER, next);
+
+	/*
+	 * Polling isn't necessary considering KVM's ITS emulation at the time
+	 * of writing this, as the CMDQ is processed synchronously after a write
+	 * to CWRITER.
+	 */
+	for (i = 0; its_read_u64(GITS_CREADR) != next; i++) {
+		__GUEST_ASSERT(i < GITS_CMDQ_POLL_ITERATIONS,
+			       "ITS didn't process command at offset %lu after %d iterations\n",
+			       cwriter, i);
+
+		cpu_relax();
+	}
+}
+
+void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
+		       size_t itt_size, bool valid)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_MAPD);
+	its_encode_devid(&cmd, device_id);
+	its_encode_size(&cmd, ilog2(itt_size) - 1);
+	its_encode_itt(&cmd, itt_base);
+	its_encode_valid(&cmd, valid);
+
+	its_send_cmd(cmdq_base, &cmd);
+}
+
+void its_send_mapc_cmd(void *cmdq_base, u32 vcpu_id, u32 collection_id, bool valid)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_MAPC);
+	its_encode_collection(&cmd, collection_id);
+	its_encode_target(&cmd, vcpu_id);
+	its_encode_valid(&cmd, valid);
+
+	its_send_cmd(cmdq_base, &cmd);
+}
+
+void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
+			u32 collection_id, u32 intid)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_MAPTI);
+	its_encode_devid(&cmd, device_id);
+	its_encode_event_id(&cmd, event_id);
+	its_encode_phys_id(&cmd, intid);
+	its_encode_collection(&cmd, collection_id);
+
+	its_send_cmd(cmdq_base, &cmd);
+}
+
+void its_send_invall_cmd(void *cmdq_base, u32 collection_id)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_INVALL);
+	its_encode_collection(&cmd, collection_id);
+
+	its_send_cmd(cmdq_base, &cmd);
+}
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 7738fdb0cea1..5e8f0d5382c2 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -166,3 +166,21 @@ void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu)
 {
 	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISACTIVER);
 }
+
+int vgic_its_setup(struct kvm_vm *vm)
+{
+	int its_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
+	u64 attr;
+
+	attr = GITS_BASE_GPA;
+	kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_ITS_ADDR_TYPE, &attr);
+
+	kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	virt_map(vm, GITS_BASE_GPA, GITS_BASE_GPA,
+		 vm_calc_num_guest_pages(vm->mode, KVM_VGIC_V3_ITS_SIZE));
+
+	return its_fd;
+}
-- 
2.44.0.769.g3c40516874-goog


