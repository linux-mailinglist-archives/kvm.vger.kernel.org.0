Return-Path: <kvm+bounces-64131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 761CEC7982F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 19BD729212
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6681C34C98F;
	Fri, 21 Nov 2025 13:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mZJhoZ7f"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CAF3F9D2;
	Fri, 21 Nov 2025 13:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732173; cv=none; b=cE4Ebrin9hhePaOIFB6drPhuqRYdncw2LdBaVw3HVydKBhwj7Gnh4GNTjVFstdjc4wRHgltX2wRxwweXJRSpjIxHkC2rMem9oWtLGRAzL82LhGn9pCNPGyj3FGLVgj6nUCqbrmWZMuHShqythOztbjZ0d78dU5Lw4uKTOQekGvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732173; c=relaxed/simple;
	bh=l9zY3Y7OLuRdKyHz0EggNJqmADS4gNUNqkhxBTWGjd4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B0uOve9y0jrDq6QA8+khAqNYjborvCYTbT63L5Hrp74RShUDGV/kv1YwMSQFtkNys3vDBh7u81WUDWZ0OFOO6xgUoSOXol0b+YdDMekW543QHv3f8YBx0jepsJAjihhlHhLwYOkQxwZ442iqaDQ5xGQVa1RgMYj/rVB2y7JRMwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mZJhoZ7f; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763732157; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=0Y4Gl8l0oRGBSSOkUyUCKPutDiBDPCRdKNSD2TJIBMU=;
	b=mZJhoZ7f5PaIaMaxLTD/qqnp/ZJ5IBvYhNd8vniKgLlb5KJ9kF7XBIHQaQDH2a5jDJAIUM4buUmAuNmA9thjqm+Q4x6T/eFcFwbCWKeb0srL/JtD2QV+Aar25+2oWsPjzuKiEdvktPu5z5KP2fQ4XXMCflmAlRA+Vrp4CBcnz9I=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0Wt0CGTO_1763732155 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Nov 2025 21:35:56 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	ajones@ventanamicro.com,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v3] RISC-V: KVM: Fix guest page fault within HLV* instructions
Date: Fri, 21 Nov 2025 21:35:43 +0800
Message-Id: <20251121133543.46822-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

When executing HLV* instructions at the HS mode, a guest page fault
may occur when a g-stage page table migration between triggering the
virtual instruction exception and executing the HLV* instruction.

This may be a corner case, and one simpler way to handle this is to
re-execute the instruction where the virtual  instruction exception
occurred, and the guest page fault will be automatically handled.

Fixes: b91f0e4cb8a3 ("RISC-V: KVM: Factor-out instruction emulation into separate sources")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>

---
Changes in v3:
- Add a helper function to avoid repeating the same paragraph(suggested by drew)
- Link to v2: https://lore.kernel.org/linux-riscv/20251111135506.8526-1-fangyu.yu@linux.alibaba.com/

Changes in v2:
- Remove unnecessary modifications and add comments(suggested by Anup)
- Update Fixes tag
- Link to v1: https://lore.kernel.org/linux-riscv/20250912134332.22053-1-fangyu.yu@linux.alibaba.com/
---
 arch/riscv/kvm/vcpu_insn.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index de1f96ea6225..4d89b94128ae 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -298,6 +298,22 @@ static int system_opcode_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	return (rc <= 0) ? rc : 1;
 }
 
+static bool is_load_guest_page_fault(unsigned long scause)
+{
+	/**
+	 * If a g-stage page fault occurs, the direct approach
+	 * is to let the g-stage page fault handler handle it
+	 * naturally, however, calling the g-stage page fault
+	 * handler here seems rather strange.
+	 * Considering this is a corner case, we can directly
+	 * return to the guest and re-execute the same PC, this
+	 * will trigger a g-stage page fault again and then the
+	 * regular g-stage page fault handler will populate
+	 * g-stage page table.
+	 */
+	return (scause == EXC_LOAD_GUEST_PAGE_FAULT);
+}
+
 /**
  * kvm_riscv_vcpu_virtual_insn -- Handle virtual instruction trap
  *
@@ -323,6 +339,8 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 							  ct->sepc,
 							  &utrap);
 			if (utrap.scause) {
+				if (is_load_guest_page_fault(utrap.scause))
+					return 1;
 				utrap.sepc = ct->sepc;
 				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 				return 1;
@@ -378,6 +396,8 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
 		if (utrap.scause) {
+			if (is_load_guest_page_fault(utrap.scause))
+				return 1;
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
@@ -504,6 +524,8 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
 		if (utrap.scause) {
+			if (is_load_guest_page_fault(utrap.scause))
+				return 1;
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-- 
2.50.1


