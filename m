Return-Path: <kvm+bounces-8613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57365852CC7
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2272B24261
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005463716F;
	Tue, 13 Feb 2024 09:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CRwbn6KQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3E436AEF
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707817291; cv=none; b=HxpDmqBcotjugnC42kxcGoysUvgDphc31uD4r43ogjDXjQdyS0mZAhfBBiYnqpVlu0rywncAAYcJ3bHg2VgqECw2rBbd/YrcIMqvpT/MTIVYwQY9LyVWVAu1G2uwuP5H5Ro5lcwETJXCPvGJ8pC5wIVVO3CJHGDuY/NBauMySak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707817291; c=relaxed/simple;
	bh=NhGrZyxkIuZQWCcTYldapP56WiHf0mmlItW4rC91NEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRod+gjrWOYvWsfQ67Fy1Mtq4+mQ329CHCHCgz+FDgAYavqXqiWatfiUKxGBDkMUwh15sJxR9o4c1zBurcaJgHmWgLd/bbnD7WYiFKXmnZyweLLr3QEkdU825/mtZBU8j/UyGdSCP6ZkQW89vb1PzhjzY3dn8VXFK9pTv9iCBk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CRwbn6KQ; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707817287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OMPdGXoxf8WnGOh2+4/hLw9TzTmbExY6hN0KedYmhJk=;
	b=CRwbn6KQF18IkX38dkKxlBxMgn+o6HKW3LBuGcNnDDhTK4YWSYwa/N5KOPkI5MELb7MNxk
	lejmLVorOSCqjxkDGoKe79nlEZbQPziXzd9QczzrMkx1y8ImIqWoiYbtve1oD/GCr1uAy9
	ugLbbF93vmM0VnXAJ1aJcH5GQxei1yQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 19/23] KVM: selftests: Add a minimal library for interacting with an ITS
Date: Tue, 13 Feb 2024 09:41:14 +0000
Message-ID: <20240213094114.3961683-1-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
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
ITS and interacting with it *from userspace*.

Yep, you read that right. KVM unintentionally allows userspace to send
commands to the virtual ITS via the command queue. Besides adding test
coverage for an elusive UAPI, interacting with the ITS in userspace
simplifies the handling of commands that need to allocate memory, like a
MAPD command with an ITT.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/aarch64/gic.h       |   7 +-
 .../selftests/kvm/include/aarch64/vgic.h      |  20 ++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 241 ++++++++++++++++++
 3 files changed, 267 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 16d944486e9c..abb41d67880c 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -11,7 +11,12 @@ enum gic_type {
 	GIC_TYPE_MAX,
 };
 
-#define GICD_BASE_GPA		0x8000000ULL
+/*
+ * Note that the redistributor frames are at the end, as the range scales
+ * with the number of vCPUs in the VM.
+ */
+#define GITS_BASE_GPA		0x8000000ULL
+#define GICD_BASE_GPA		(GITS_BASE_GPA + SZ_128K)
 #define GICR_BASE_GPA		(GICD_BASE_GPA + SZ_64K)
 
 /* The GIC is identity-mapped into the guest at the time of setup. */
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index ce19aa0a8360..d45b2902439d 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -32,4 +32,24 @@ void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu);
 
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
+struct vgic_its {
+	int	its_fd;
+	void 	*cmdq_hva;
+	size_t	cmdq_size;
+};
+
+struct vgic_its *vgic_its_setup(struct kvm_vm *vm,
+				vm_paddr_t coll_tbl, size_t coll_tbl_sz,
+				vm_paddr_t device_tbl, size_t device_tbl_sz,
+				vm_paddr_t cmdq, size_t cmdq_size);
+void vgic_its_destroy(struct vgic_its *its);
+
+void vgic_its_send_mapd_cmd(struct vgic_its *its, u32 device_id,
+		            vm_paddr_t itt_base, size_t itt_size, bool valid);
+void vgic_its_send_mapc_cmd(struct vgic_its *its, struct kvm_vcpu *vcpu,
+			    u32 collection_id, bool valid);
+void vgic_its_send_mapti_cmd(struct vgic_its *its, u32 device_id,
+			     u32 event_id, u32 collection_id, u32 intid);
+void vgic_its_send_invall_cmd(struct vgic_its *its, u32 collection_id);
+
 #endif // SELFTEST_KVM_VGIC_H
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index ac55b6c2e915..fc7b4fbe6453 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -12,6 +12,7 @@
 #include "vgic.h"
 #include "gic.h"
 #include "gic_v3.h"
+#include "processor.h"
 
 /*
  * vGIC-v3 default host setup
@@ -166,3 +167,243 @@ void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, struct kvm_vcpu *vcpu)
 {
 	vgic_poke_irq(gic_fd, intid, vcpu, GICD_ISACTIVER);
 }
+
+static u64 vgic_its_read_reg(int its_fd, unsigned long offset)
+{
+	u64 attr;
+
+	kvm_device_attr_get(its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+			    offset, &attr);
+	return attr;
+}
+
+static void vgic_its_write_reg(int its_fd, unsigned long offset, u64 val)
+{
+	kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+			    offset, &val);
+}
+
+static unsigned long vgic_its_find_baser(int its_fd, unsigned int type)
+{
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		u64 baser;
+		unsigned long offset = GITS_BASER + (i * sizeof(baser));
+
+		baser = vgic_its_read_reg(its_fd, offset);
+		if (GITS_BASER_TYPE(baser) == type)
+			return offset;
+	}
+
+	TEST_FAIL("Couldn't find an ITS BASER of type %u", type);
+	return -1;
+}
+
+static void vgic_its_install_table(int its_fd, unsigned int type, vm_paddr_t base,
+				   size_t size)
+{
+	unsigned long offset = vgic_its_find_baser(its_fd, type);
+	u64 baser;
+
+	baser = ((size / SZ_64K) - 1) |
+		GITS_BASER_PAGE_SIZE_64K |
+		GITS_BASER_InnerShareable |
+		base |
+		GITS_BASER_RaWaWb |
+		GITS_BASER_VALID;
+
+	vgic_its_write_reg(its_fd, offset, baser);
+}
+
+static void vgic_its_install_cmdq(int its_fd, vm_paddr_t base, size_t size)
+{
+	u64 cbaser;
+
+	cbaser = ((size / SZ_4K) - 1) |
+		 GITS_CBASER_InnerShareable |
+		 base |
+		 GITS_CBASER_RaWaWb |
+		 GITS_CBASER_VALID;
+
+	vgic_its_write_reg(its_fd, GITS_CBASER, cbaser);
+}
+
+struct vgic_its *vgic_its_setup(struct kvm_vm *vm,
+				vm_paddr_t coll_tbl, size_t coll_tbl_sz,
+				vm_paddr_t device_tbl, size_t device_tbl_sz,
+				vm_paddr_t cmdq, size_t cmdq_size)
+{
+	int its_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
+	struct vgic_its *its = malloc(sizeof(struct vgic_its));
+	u64 attr, ctlr;
+
+	attr = GITS_BASE_GPA;
+	kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_ITS_ADDR_TYPE, &attr);
+
+	kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	vgic_its_install_table(its_fd, GITS_BASER_TYPE_COLLECTION, coll_tbl,
+			       coll_tbl_sz);
+	vgic_its_install_table(its_fd, GITS_BASER_TYPE_DEVICE, device_tbl,
+			       device_tbl_sz);
+
+	vgic_its_install_cmdq(its_fd, cmdq, cmdq_size);
+
+	ctlr = vgic_its_read_reg(its_fd, GITS_CTLR);
+	ctlr |= GITS_CTLR_ENABLE;
+	vgic_its_write_reg(its_fd, GITS_CTLR, ctlr);
+
+	*its = (struct vgic_its) {
+		.its_fd		= its_fd,
+		.cmdq_hva	= addr_gpa2hva(vm, cmdq),
+		.cmdq_size	= cmdq_size,
+	};
+
+	return its;
+}
+
+void vgic_its_destroy(struct vgic_its *its)
+{
+	close(its->its_fd);
+	free(its);
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
+static void vgic_its_send_cmd(struct vgic_its *its, struct its_cmd_block *cmd)
+{
+	u64 cwriter = vgic_its_read_reg(its->its_fd, GITS_CWRITER);
+	struct its_cmd_block *dst = its->cmdq_hva + cwriter;
+	u64 next;
+
+	its_fixup_cmd(cmd);
+
+	WRITE_ONCE(*dst, *cmd);
+	dsb(ishst);
+
+	next = (cwriter + sizeof(*cmd)) % its->cmdq_size;
+	vgic_its_write_reg(its->its_fd, GITS_CWRITER, next);
+
+	TEST_ASSERT(vgic_its_read_reg(its->its_fd, GITS_CREADR) == next,
+		    "ITS didn't process command at offset: %lu\n", cwriter);
+}
+
+void vgic_its_send_mapd_cmd(struct vgic_its *its, u32 device_id,
+		            vm_paddr_t itt_base, size_t itt_size, bool valid)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_MAPD);
+	its_encode_devid(&cmd, device_id);
+	its_encode_size(&cmd, ilog2(itt_size) - 1);
+	its_encode_itt(&cmd, itt_base);
+	its_encode_valid(&cmd, valid);
+
+	vgic_its_send_cmd(its, &cmd);
+}
+
+void vgic_its_send_mapc_cmd(struct vgic_its *its, struct kvm_vcpu *vcpu,
+			    u32 collection_id, bool valid)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_MAPC);
+	its_encode_collection(&cmd, collection_id);
+	its_encode_target(&cmd, vcpu->id);
+	its_encode_valid(&cmd, valid);
+
+	vgic_its_send_cmd(its, &cmd);
+}
+
+void vgic_its_send_mapti_cmd(struct vgic_its *its, u32 device_id,
+			     u32 event_id, u32 collection_id, u32 intid)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_MAPTI);
+	its_encode_devid(&cmd, device_id);
+	its_encode_event_id(&cmd, event_id);
+	its_encode_phys_id(&cmd, intid);
+	its_encode_collection(&cmd, collection_id);
+
+	vgic_its_send_cmd(its, &cmd);
+}
+
+void vgic_its_send_invall_cmd(struct vgic_its *its, u32 collection_id)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_INVALL);
+	its_encode_collection(&cmd, collection_id);
+
+	vgic_its_send_cmd(its, &cmd);
+}
-- 
2.43.0.687.g38aa6559b0-goog


