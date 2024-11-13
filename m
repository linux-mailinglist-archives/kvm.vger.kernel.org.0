Return-Path: <kvm+bounces-31703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A27D49C67B4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 088F3B27892
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E048716F824;
	Wed, 13 Nov 2024 03:17:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8491662E7;
	Wed, 13 Nov 2024 03:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731467854; cv=none; b=VFeC1GPMw26YnoXqAIN8+o86wSfAmVJalvhNgvEFpNHE7zmyNCJy70aNpIEXt829DorqNijUqtXtarZgxR0GtchkZgfxMwi0gF7GC2Ul9UVtpRlbSGGIc0U5oaTUft7uz5kZr93rOd6SeyfEhZzKdDBBeKj5ATSOAk7UnFHb72E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731467854; c=relaxed/simple;
	bh=ds2iCd9Y1vCDdtQRKzk60n9z1DNTpM4hNfiXD6U4dho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dDex+mruONtQw2ZNpybg342+2ulx6bW+Q2WvfFjb0w5afwxku/rMg3gb5P+KJeqmA/kzHu8gyZEBjOkoSt4EPF0rNXKCciy11nyNThlBUa68aKErMCVj6dE45oPJtadjARHyNbb3Bo3BiRQA1OEBNzOCGEEBDT9nxK7Ai3/KfUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxC+JKGjRnUn08AA--.53836S3;
	Wed, 13 Nov 2024 11:17:30 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxDEdHGjRnX4VTAA--.14727S4;
	Wed, 13 Nov 2024 11:17:29 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 2/5] LoongArch: KVM: Add separate vmid feature support
Date: Wed, 13 Nov 2024 11:17:24 +0800
Message-Id: <20241113031727.2815628-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20241113031727.2815628-1-maobibo@loongson.cn>
References: <20241113031727.2815628-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxDEdHGjRnX4VTAA--.14727S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Feature cpu_has_guestid is used to check whether separate vmid/vpid
is supported or not. Also add different vmid updating function.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/main.c             | 30 +++++++++++++++++++++++----
 arch/loongarch/kvm/tlb.c              | 14 +++++++++++++
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 6151c7c470d5..92ec3660d221 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -279,6 +279,8 @@ static inline int kvm_get_pmu_num(struct kvm_vcpu_arch *arch)
 int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
 
 /* MMU handling */
+void kvm_flush_tlb_all_stage1(void);
+void kvm_flush_tlb_all_stage2(void);
 void kvm_flush_tlb_all(void);
 void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa);
 int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long badv, bool write);
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 8c16bff80053..afb2e10eba68 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -207,15 +207,17 @@ static void kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
 		++vpid; /* vpid 0 reserved for root */
 
 		/* start new vpid cycle */
-		kvm_flush_tlb_all();
+		if (!cpu_has_guestid)
+			kvm_flush_tlb_all();
+		else
+			kvm_flush_tlb_all_stage1();
 	}
 
 	context->vpid_cache = vpid;
 	vcpu->arch.vpid = vpid;
-	vcpu->arch.vmid = vcpu->arch.vpid & vpid_mask;
 }
 
-void kvm_check_vpid(struct kvm_vcpu *vcpu)
+static void __kvm_check_vpid(struct kvm_vcpu *vcpu)
 {
 	int cpu;
 	bool migrated;
@@ -243,7 +245,6 @@ void kvm_check_vpid(struct kvm_vcpu *vcpu)
 		kvm_update_vpid(vcpu, cpu);
 		trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
 		vcpu->cpu = cpu;
-		kvm_clear_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
 	}
 
 	/* Restore GSTAT(0x50).vpid */
@@ -251,6 +252,27 @@ void kvm_check_vpid(struct kvm_vcpu *vcpu)
 	change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
 }
 
+static void __kvm_check_vmid(struct kvm_vcpu *vcpu)
+{
+	unsigned long vmid;
+
+	/* On some machines like 3A5000, vmid needs the same with vpid */
+	if (!cpu_has_guestid) {
+		vmid = vcpu->arch.vpid & vpid_mask;
+		if (vcpu->arch.vmid != vmid) {
+			vcpu->arch.vmid = vmid;
+			kvm_clear_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
+		}
+		return;
+	}
+}
+
+void kvm_check_vpid(struct kvm_vcpu *vcpu)
+{
+	__kvm_check_vpid(vcpu);
+	__kvm_check_vmid(vcpu);
+}
+
 void kvm_init_vmcs(struct kvm *kvm)
 {
 	kvm->arch.vmcs = vmcs;
diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
index 38daf936021d..1d95e2208e82 100644
--- a/arch/loongarch/kvm/tlb.c
+++ b/arch/loongarch/kvm/tlb.c
@@ -21,6 +21,20 @@ void kvm_flush_tlb_all(void)
 	local_irq_restore(flags);
 }
 
+/* Invalidate all stage1 TLB entries including GVA-->GPA mappings */
+void kvm_flush_tlb_all_stage1(void)
+{
+	lockdep_assert_irqs_disabled();
+	invtlb_all(INVGTLB_ALLGID_GVA_TO_GPA, 0, 0);
+}
+
+/* Invalidate all stage2 TLB entries including GPA-->HPA  mappings */
+void kvm_flush_tlb_all_stage2(void)
+{
+	lockdep_assert_irqs_disabled();
+	invtlb_all(INVTLB_ALLGID_GPA_TO_HPA, 0, 0);
+}
+
 void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
 {
 	unsigned int vmid;
-- 
2.39.3


