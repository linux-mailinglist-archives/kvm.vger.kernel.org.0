Return-Path: <kvm+bounces-31704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B0F9C67B6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:18:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C35511F24E0C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA701714D7;
	Wed, 13 Nov 2024 03:17:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B3A166310;
	Wed, 13 Nov 2024 03:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731467854; cv=none; b=Oxwq1RzOT1H/XklFveyAGNXPHqIJ2AogqtiGxg9scowjiUmeFt0Ekjak7WwQQF7JUepBfbC/TKh/78GV7OCEKm/dV7uO0eXrNl+I4f/R3gfWDheAyQfjoTncxbzJWNfpx+VR0K2OKNq+s/rxzPj+aYMdrENEZFXMe7Jgld6uezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731467854; c=relaxed/simple;
	bh=q5P7swPuEjyp3vJ2hRrjCtBVHumWvilkU8Jd0nUXiDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u1d88+EnymR4qFY9cSiWWtJk9CgNqJbRAtaMI7HpECdXUI9hJ+9WWxLZCFxqW2R8eZpZvVujhLDgufi+waIVdRY/oNVC/v1kOPBCMY4vJWa29cGpzgRAbldiEzZG1/FTLMt4jTYoslg5Ln9h5/YzxNougHd+/ZYEXG9EFoztoco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Ax6+FJGjRnTn08AA--.53415S3;
	Wed, 13 Nov 2024 11:17:29 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxDEdHGjRnX4VTAA--.14727S3;
	Wed, 13 Nov 2024 11:17:28 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 1/5] LoongArch: KVM: Add vmid support for stage2 MMU
Date: Wed, 13 Nov 2024 11:17:23 +0800
Message-Id: <20241113031727.2815628-2-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowMAxDEdHGjRnX4VTAA--.14727S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

LoongArch KVM hypervisor supports two-level MMU, vpid index is used
for stage1 MMU and vmid index is used for stage2 MMU.

On 3A5000, vmid must be the same with vpid. On 3A6000 platform vmid
may separate from vpid. If vcpu migrate to different physical CPUs,
vpid need change however vmid can keep the same with old value. Also
vmid index of the while VM machine on physical CPU the same, all vCPUs
on the VM can share the same vmid index on one physical CPU.

Here vmid index is added and it keeps the same with vpid still.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h | 3 +++
 arch/loongarch/kernel/asm-offsets.c   | 1 +
 arch/loongarch/kvm/main.c             | 1 +
 arch/loongarch/kvm/switch.S           | 5 ++---
 arch/loongarch/kvm/tlb.c              | 5 ++++-
 5 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index d6bb72424027..6151c7c470d5 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -166,6 +166,9 @@ struct kvm_vcpu_arch {
 	unsigned long host_tp;
 	unsigned long host_pgd;
 
+	/* vmid info for guest VM */
+	unsigned long vmid;
+
 	/* Host CSRs are used when handling exits from guest */
 	unsigned long badi;
 	unsigned long badv;
diff --git a/arch/loongarch/kernel/asm-offsets.c b/arch/loongarch/kernel/asm-offsets.c
index bee9f7a3108f..4e9a9311afd3 100644
--- a/arch/loongarch/kernel/asm-offsets.c
+++ b/arch/loongarch/kernel/asm-offsets.c
@@ -307,6 +307,7 @@ static void __used output_kvm_defines(void)
 	OFFSET(KVM_ARCH_HSP, kvm_vcpu_arch, host_sp);
 	OFFSET(KVM_ARCH_HTP, kvm_vcpu_arch, host_tp);
 	OFFSET(KVM_ARCH_HPGD, kvm_vcpu_arch, host_pgd);
+	OFFSET(KVM_ARCH_VMID, kvm_vcpu_arch, vmid);
 	OFFSET(KVM_ARCH_HANDLE_EXIT, kvm_vcpu_arch, handle_exit);
 	OFFSET(KVM_ARCH_HEENTRY, kvm_vcpu_arch, host_eentry);
 	OFFSET(KVM_ARCH_GEENTRY, kvm_vcpu_arch, guest_eentry);
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 27e9b94c0a0b..8c16bff80053 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -212,6 +212,7 @@ static void kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
 
 	context->vpid_cache = vpid;
 	vcpu->arch.vpid = vpid;
+	vcpu->arch.vmid = vcpu->arch.vpid & vpid_mask;
 }
 
 void kvm_check_vpid(struct kvm_vcpu *vcpu)
diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0c292f818492..2774343f64d3 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -72,9 +72,8 @@
 	ldx.d   t0, t1, t0
 	csrwr	t0, LOONGARCH_CSR_PGDL
 
-	/* Mix GID and RID */
-	csrrd		t1, LOONGARCH_CSR_GSTAT
-	bstrpick.w	t1, t1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SHIFT
+	/* Set VMID for gpa --> hpa mapping */
+	ld.d		t1, a2, KVM_ARCH_VMID
 	csrrd		t0, LOONGARCH_CSR_GTLBC
 	bstrins.w	t0, t1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
 	csrwr		t0, LOONGARCH_CSR_GTLBC
diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
index ebdbe9264e9c..38daf936021d 100644
--- a/arch/loongarch/kvm/tlb.c
+++ b/arch/loongarch/kvm/tlb.c
@@ -23,7 +23,10 @@ void kvm_flush_tlb_all(void)
 
 void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
 {
+	unsigned int vmid;
+
 	lockdep_assert_irqs_disabled();
 	gpa &= (PAGE_MASK << 1);
-	invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
+	vmid = (vcpu->arch.vmid << CSR_GSTAT_GID_SHIFT) & CSR_GSTAT_GID;
+	invtlb(INVTLB_GID_ADDR, vmid, gpa);
 }
-- 
2.39.3


