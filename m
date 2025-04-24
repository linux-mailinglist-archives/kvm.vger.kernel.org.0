Return-Path: <kvm+bounces-44077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E779EA9A28B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86803920B02
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F801F2C56;
	Thu, 24 Apr 2025 06:46:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E691D5166;
	Thu, 24 Apr 2025 06:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745477198; cv=none; b=GhhBnv5/i/7Aukh0/12U8+zWKU06gqb5UFBSrI0KxQpwaIekKmc2lP1Kmx3kP/CFkWQxudas/ULv8e5ZMAupVpl3aOlOIuQX8zB5rH9aY7cGr8Cg5c+wxy/+MoGmlodesEcKrzaZnUz+jA29Jfxq65b1i3kxSbrUQsNrcYh5hYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745477198; c=relaxed/simple;
	bh=I5oSLeaECgBESSQPJTrXap4PDHv/Zm++hpeYpGm02Dc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oBwdsWMQ+sGpWFsqikxqO4bC76y1hERgnaZvmFZhkpWe/Y7gH7SYEMNVNvrKf0AEJgk47GWfwQj8LvTe05SLoadxURDKJzaTcoq1mgn07tKXz/W3h9q79iXVHJdu8UYA7gErsQHhaYxo+mKWU8fG2EsiSkSYQa+YDQ0LrS4kEys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxWXFK3glokx_FAA--.64928S3;
	Thu, 24 Apr 2025 14:46:34 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxXsVB3gloABqTAA--.39186S4;
	Thu, 24 Apr 2025 14:46:32 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] LoongArch: KVM: Do not flush tlb if HW PTW supported
Date: Thu, 24 Apr 2025 14:46:25 +0800
Message-Id: <20250424064625.3928278-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250424064625.3928278-1-maobibo@loongson.cn>
References: <20250424064625.3928278-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXsVB3gloABqTAA--.39186S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With HW PTW supported, TLB is not added if page fault happens. With
EXCCODE_TLBM exception, TLB may exist because last read access, tlb
flush operation is necessary with EXCCODE_TLBM exception, and not
necessary with other memory page fault exception.

With SW PTW supported, invalid TLB is added in TLB refill exception.
tlb flush operation is necessary with all page fault exceptions.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 +-
 arch/loongarch/kvm/exit.c             |  8 ++++----
 arch/loongarch/kvm/mmu.c              | 17 +++++++++++++----
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index f457c2662e2f..a3c4cc46c892 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -301,7 +301,7 @@ int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
 /* MMU handling */
 void kvm_flush_tlb_all(void);
 void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa);
-int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long badv, bool write);
+int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long badv, bool write, int ecode);
 
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end, bool blockable);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 31b9d5f67e8f..e6ad251debb1 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -661,7 +661,7 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 	return ret;
 }
 
-static int kvm_handle_rdwr_fault(struct kvm_vcpu *vcpu, bool write)
+static int kvm_handle_rdwr_fault(struct kvm_vcpu *vcpu, bool write, int ecode)
 {
 	int ret;
 	larch_inst inst;
@@ -675,7 +675,7 @@ static int kvm_handle_rdwr_fault(struct kvm_vcpu *vcpu, bool write)
 		return RESUME_GUEST;
 	}
 
-	ret = kvm_handle_mm_fault(vcpu, badv, write);
+	ret = kvm_handle_mm_fault(vcpu, badv, write, ecode);
 	if (ret) {
 		/* Treat as MMIO */
 		inst.word = vcpu->arch.badi;
@@ -707,12 +707,12 @@ static int kvm_handle_rdwr_fault(struct kvm_vcpu *vcpu, bool write)
 
 static int kvm_handle_read_fault(struct kvm_vcpu *vcpu, int ecode)
 {
-	return kvm_handle_rdwr_fault(vcpu, false);
+	return kvm_handle_rdwr_fault(vcpu, false, ecode);
 }
 
 static int kvm_handle_write_fault(struct kvm_vcpu *vcpu, int ecode)
 {
-	return kvm_handle_rdwr_fault(vcpu, true);
+	return kvm_handle_rdwr_fault(vcpu, true, ecode);
 }
 
 int kvm_complete_user_service(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 4d203294767c..0f0d4be9cba2 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -912,7 +912,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	return err;
 }
 
-int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
+int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write, int ecode)
 {
 	int ret;
 
@@ -920,9 +920,18 @@ int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	if (ret)
 		return ret;
 
-	/* Invalidate this entry in the TLB */
-	vcpu->arch.flush_gpa = gpa;
-	kvm_make_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
+	if (!cpu_has_ptw || (ecode == EXCCODE_TLBM)) {
+		/*
+		 * With HW ptw supported, TLB will not update for any page fault
+		 * For EXCCODE_TLBM exception, TLB may exist because last read access
+		 *
+		 * With SW ptw, invalid TLB is added in TLB refill exception
+		 *
+		 * Invalidate this entry in the TLB
+		 */
+		vcpu->arch.flush_gpa = gpa;
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
+	}
 
 	return 0;
 }
-- 
2.39.3


