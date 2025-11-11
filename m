Return-Path: <kvm+bounces-62770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A5DC4E441
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 14:59:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ABF53B30F2
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 13:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68DBF3596E9;
	Tue, 11 Nov 2025 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XfskZZSY"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C70727CCE2;
	Tue, 11 Nov 2025 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762869326; cv=none; b=qZvEV4X3SY6/m+P15SfUH1AG8l/eTQWBvuM/c8bVGxGEZ7bA1sqQhEUeYYWEHZH2ITjwimOTjznfLfZU3R2Q6jbu6wTmnCRX43/DGlhtc0hJi1hTSJ1ZBNafaf2mtX9Sck5dCb/tpD/3MJzLl0PPnqZRc1UpCVYtr8feqxND1Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762869326; c=relaxed/simple;
	bh=VrBYrXb2gomVRqKKGoZblHBhw98ua0Jd5cvQ+mlX0ZA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lOX68LuO6EXDjwgSSi4i2la5TbiULEC5scfUIy23aWIa4Vnp2Z4B529JMwvqndFZ5Qc3UfgGxlqlMJcB63HEJ6ubmelSCa4rVqDf7/0LiFpBA1ZmlTQJwV7HxWubK2LiNTQ/ht1ry+ap+WHLyfZ4gdn03MedR3y5griDgKmW4xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XfskZZSY; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762869320; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=JYpEUEDdcRzYzdeW+638BcwXZNQIfYVkyqsW+6NhS0E=;
	b=XfskZZSYrEF2smAxw+37I99lj036YExbHHegCrW3GsWdLRMYtj/ZoXjzo2JuyM1gfiPrL8F90LnHiShKSNzMd35yclrFyWSzIMRpTxXnN0L3e2W0xdI2CTVtBOu/DlV2GFwJO3XBQcjYrYHMWHwQtW2mpoqiPJUa6/JzqX8e6pE=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WsBpap1_1762869317 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 11 Nov 2025 21:55:19 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v2] RISC-V: KVM: Fix guest page fault within HLV* instructions
Date: Tue, 11 Nov 2025 21:55:06 +0800
Message-Id: <20251111135506.8526-1-fangyu.yu@linux.alibaba.com>
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
Changes in v2:
- Remove unnecessary modifications and add comments(suggested by Anup)
- Update Fixes tag
- Link to v1: https://lore.kernel.org/linux-riscv/20250912134332.22053-1-fangyu.yu@linux.alibaba.com/
---
 arch/riscv/kvm/vcpu_insn.c | 39 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index de1f96ea6225..a8d796ef2822 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -323,6 +323,19 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 							  ct->sepc,
 							  &utrap);
 			if (utrap.scause) {
+				/**
+				 * If a g-stage page fault occurs, the direct approach
+				 * is to let the g-stage page fault handler handle it
+				 * naturally, however, calling the g-stage page fault
+				 * handler here seems rather strange.
+				 * Considering this is an corner case, we can directly
+				 * return to the guest and re-execute the same PC, this
+				 * will trigger a g-stage page fault again and then the
+				 * regular g-stage page fault handler will populate
+				 * g-stage page table.
+				 */
+				if (utrap.scause == EXC_LOAD_GUEST_PAGE_FAULT)
+					return 1;
 				utrap.sepc = ct->sepc;
 				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 				return 1;
@@ -378,6 +391,19 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
 		if (utrap.scause) {
+			/**
+			 * If a g-stage page fault occurs, the direct approach
+			 * is to let the g-stage page fault handler handle it
+			 * naturally, however, calling the g-stage page fault
+			 * handler here seems rather strange.
+			 * Considering this is an corner case, we can directly
+			 * return to the guest and re-execute the same PC, this
+			 * will trigger a g-stage page fault again and then the
+			 * regular g-stage page fault handler will populate
+			 * g-stage page table.
+			 */
+			if (utrap.scause == EXC_LOAD_GUEST_PAGE_FAULT)
+				return 1;
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
@@ -504,6 +530,19 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
 		if (utrap.scause) {
+			/**
+			 * If a g-stage page fault occurs, the direct approach
+			 * is to let the g-stage page fault handler handle it
+			 * naturally, however, calling the g-stage page fault
+			 * handler here seems rather strange.
+			 * Considering this is an corner case, we can directly
+			 * return to the guest and re-execute the same PC, this
+			 * will trigger a g-stage page fault again and then the
+			 * regular g-stage page fault handler will populate
+			 * g-stage page table.
+			 */
+			if (utrap.scause == EXC_LOAD_GUEST_PAGE_FAULT)
+				return 1;
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-- 
2.50.1


