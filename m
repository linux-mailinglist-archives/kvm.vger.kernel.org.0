Return-Path: <kvm+bounces-44476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3639FA9DEBD
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 04:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 405F81A81048
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 02:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6779C229B0B;
	Sun, 27 Apr 2025 02:45:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1206A1FBEB9;
	Sun, 27 Apr 2025 02:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745721913; cv=none; b=PAcGJLo/JVDZuZSHbqSKD8Q2swgJ4lXcmrSn/WOw0/KV2ub0Xasg4HwSE5TLlZoLYQSXjwLRf0tsCb0ze606nEy5YuBVkTdGgZoO30/vB6MeTz5WeMCBhJ0gKv0598yg8zryK0Y2BIvOwqgAbfmIc0/YAnsBJmf5NFiHSQaIuk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745721913; c=relaxed/simple;
	bh=c/1+/uoSv0GzF4ZMXTZ9GuQ4sqCvwDSO4jEuKat8Tnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZjL423rJCJViT0k3vOaIDYIHNZyFW683pcbFuiu7d6Rfkm/iXJkQQ+mseXiggWPkxWh/yGRj5S7om1I0s8fC3t8t9d79vIo/uond2dWPxeSqhzFiWjjgShQzhF48ITyO627Mm6btuTy50KuOl27/13kLbb50NBO2q2lYwx9+zB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxbKwzmg1ozgrHAA--.2523S3;
	Sun, 27 Apr 2025 10:45:07 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMCxLcUxmg1oz+WXAA--.49302S4;
	Sun, 27 Apr 2025 10:45:07 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] LoongArch: KVM: Do not flush tlb if HW PTW supported
Date: Sun, 27 Apr 2025 10:45:05 +0800
Message-Id: <20250427024505.129383-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250427024505.129383-1-maobibo@loongson.cn>
References: <20250427024505.129383-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxLcUxmg1oz+WXAA--.49302S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With HW PTW supported, invalid TLB is not added when page fault happens.
With EXCCODE_TLBM exception, stale TLB may exist because of last read
access, tlb flush operation is necessary with EXCCODE_TLBM exception, and
not necessary with other page fault exceptions.

With SW PTW supported, invalid TLB is added in TLB refill exception.
tlb flush operation is necessary with all page fault exceptions.

Here remove unnecessary TLB flush opereation with HW PTW supported.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 +-
 arch/loongarch/kvm/exit.c             |  8 ++++----
 arch/loongarch/kvm/mmu.c              | 18 ++++++++++++++----
 3 files changed, 19 insertions(+), 9 deletions(-)

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
index e143fa3d21d4..fa52251b3bf1 100644
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
index 4d203294767c..b1262f04fc46 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -912,7 +912,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	return err;
 }
 
-int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
+int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write, int ecode)
 {
 	int ret;
 
@@ -920,9 +920,19 @@ int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	if (ret)
 		return ret;
 
-	/* Invalidate this entry in the TLB */
-	vcpu->arch.flush_gpa = gpa;
-	kvm_make_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
+	if (!cpu_has_ptw || (ecode == EXCCODE_TLBM)) {
+		/*
+		 * With HW ptw supported, invalid TLB will not be added with
+		 * any page fault. With EXCCODE_TLBM exception, stale TLB may
+		 * exist because of last read access.
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


