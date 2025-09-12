Return-Path: <kvm+bounces-57400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AED7B54FE4
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C780166C14
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C351230E847;
	Fri, 12 Sep 2025 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="YjbhuPTw"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967333081CB;
	Fri, 12 Sep 2025 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757684627; cv=none; b=Tea+R/RDwPLIi5c9uR4hvWtDmaD6F++PHCgeUSalpHJ2//PXmYdUE8a4ZxHf78YHlqnY9IFIrywm1r+S6KMi0Cp80HdCPoxo2iTbBMunvxz2+WyQQO+CodtQfJhEFH5y7lJtbfIaogWMiZS/vKlKdIv9NIe5yt2JaG2ZtX/A6N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757684627; c=relaxed/simple;
	bh=h8LGSKFYytZOKZNIpX3Qyr6W0nr55f+r5REsFZrcd0A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OFEww4e+xbIThxf7dLG3v21MvmRru8+5z50I1RU87x5aOJR+kYPd1W3aSkLnkMN8hk1u/GK142hvAcMH1uFYGFFlrnG/KOivzdyYDmUFN14WtO6sEIjXxF8D5ngmsd0jlZ/do79d2tphE+LfONn2DVTEJXlgpgZTo/Pt4SJZ4vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=YjbhuPTw; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757684620; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=JEFJ+1KMaBT9yMuJVI/v+rlWqZb3XjQ/Sg99JRs7BGc=;
	b=YjbhuPTwCdsqFtzQSQLOPBY/x2AYiQ8HkEWTnzySASardwquXj9cK6YxRsTv81lfJt0W4ryR1gqa3bP1gJZVbtw2Qmgnm4nZ+PqQ7HjOK845hFq6zSycVO4r/qtwKwcL8ep7T6cJK8bt3yEBkGAW1YvDKbbfHzzQhfJrQmyN/jA=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WnrFL5n_1757684616 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 21:43:38 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	pbonzini@redhat.com,
	graf@amazon.com,
	jiangyifei@huawei.com
Cc: guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH] RISC-V: KVM: Fix guest page fault within HLV* instructions
Date: Fri, 12 Sep 2025 21:43:32 +0800
Message-Id: <20250912134332.22053-1-fangyu.yu@linux.alibaba.com>
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

Fixes: 9f7013265112 ("RISC-V: KVM: Handle MMIO exits for VCPU")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/kvm/vcpu_insn.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 97dec18e6989..a8b93aa4d8ec 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -448,7 +448,12 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
 							  ct->sepc,
 							  &utrap);
-			if (utrap.scause) {
+			switch (utrap.scause) {
+			case 0:
+				break;
+			case EXC_LOAD_GUEST_PAGE_FAULT:
+				return KVM_INSN_CONTINUE_SAME_SEPC;
+			default:
 				utrap.sepc = ct->sepc;
 				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 				return 1;
@@ -503,7 +508,12 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 */
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
-		if (utrap.scause) {
+		switch (utrap.scause) {
+		case 0:
+			break;
+		case EXC_LOAD_GUEST_PAGE_FAULT:
+			return KVM_INSN_CONTINUE_SAME_SEPC;
+		default:
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
@@ -629,7 +639,12 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 */
 		insn = kvm_riscv_vcpu_unpriv_read(vcpu, true, ct->sepc,
 						  &utrap);
-		if (utrap.scause) {
+		switch (utrap.scause) {
+		case 0:
+			break;
+		case EXC_LOAD_GUEST_PAGE_FAULT:
+			return KVM_INSN_CONTINUE_SAME_SEPC;
+		default:
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
 			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-- 
2.49.0


