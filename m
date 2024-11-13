Return-Path: <kvm+bounces-31706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFD19C67BA
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 04:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C409A2853BC
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 03:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C67317BB1A;
	Wed, 13 Nov 2024 03:17:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59880166F26;
	Wed, 13 Nov 2024 03:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731467855; cv=none; b=nKtJSppucncEfQ601Z0qmq+rIia/E8zaGGzi5BpkZuNblvcas9jvC4zX2r7fcAbFo1+T/tal1ghXijspzJeaPpAGliCGI0fWsKYN/7umYN1Bp9jX5XmwMO0v598gUVvrgLKiNr/UtQdq2awcmS/EmLe17MBdyk4ltCT2RDvwRtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731467855; c=relaxed/simple;
	bh=4Dk6ZN5yXXy56uvJFbd8k8Z3qHYS9PGMSK0FZg+JjHM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MvyWLAOUyigJbpgnoA4UF6pnchQ/40j55ea0MmpKeCIFv29p0Deq+z44wjPDehM6Ps5hUI3W7hAZqKJ4R+qjSvajssCsqazR544nsLYvtULo4Un2T0+mJ93aVBx4rKt+XsDwy1O9BEtXBSNuCWCfyt+RFwouEMcB0InTcgvuSXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxieBKGjRnVn08AA--.53729S3;
	Wed, 13 Nov 2024 11:17:30 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAxDEdHGjRnX4VTAA--.14727S5;
	Wed, 13 Nov 2024 11:17:30 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 3/5] LoongArch: KVM: implement vmid updating logic
Date: Wed, 13 Nov 2024 11:17:25 +0800
Message-Id: <20241113031727.2815628-4-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowMAxDEdHGjRnX4VTAA--.14727S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

For every physical CPU, there is one vmid calculation method. For
vCPUs on the same VM, vmid is the same. However for vCPUs on
different VM, vmid is different. When vCPU is scheduled on the
physical CPU, it checked vmid of this VM and the global cached
vmid, and judge whether it is valid or not.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/main.c             | 42 ++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 92ec3660d221..725d9c4e1965 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -64,6 +64,7 @@ struct kvm_arch_memory_slot {
 #define HOST_MAX_PMNUM			16
 struct kvm_context {
 	unsigned long vpid_cache;
+	unsigned long vmid_cache;
 	struct kvm_vcpu *last_vcpu;
 	/* Host PMU CSR */
 	u64 perf_ctrl[HOST_MAX_PMNUM];
@@ -116,6 +117,7 @@ struct kvm_arch {
 	unsigned long pv_features;
 
 	s64 time_offset;
+	unsigned long vmid[NR_CPUS];
 	struct kvm_context __percpu *vmcs;
 };
 
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index afb2e10eba68..367653b49a35 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -252,9 +252,33 @@ static void __kvm_check_vpid(struct kvm_vcpu *vcpu)
 	change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
 }
 
-static void __kvm_check_vmid(struct kvm_vcpu *vcpu)
+static void kvm_update_vmid(struct kvm_vcpu *vcpu, int cpu)
 {
 	unsigned long vmid;
+	struct kvm_context *context;
+
+	context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
+	vmid = context->vmid_cache + 1;
+	if (!(vmid & vpid_mask)) {
+		/* finish round of vmid loop */
+		if (unlikely(!vmid))
+			vmid = vpid_mask + 1;
+
+		++vmid; /* vmid 0 reserved for root */
+
+		/* start new vmid cycle */
+		kvm_flush_tlb_all_stage2();
+	}
+
+	context->vmid_cache = vmid;
+	vcpu->kvm->arch.vmid[cpu] = vmid;
+}
+
+static void __kvm_check_vmid(struct kvm_vcpu *vcpu)
+{
+	int cpu;
+	unsigned long ver, old, vmid;
+	struct kvm_context *context;
 
 	/* On some machines like 3A5000, vmid needs the same with vpid */
 	if (!cpu_has_guestid) {
@@ -265,6 +289,21 @@ static void __kvm_check_vmid(struct kvm_vcpu *vcpu)
 		}
 		return;
 	}
+
+	cpu = smp_processor_id();
+	context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
+
+	/*
+	 * Check if our vmid is of an older version
+	 */
+	ver = vcpu->kvm->arch.vmid[cpu] & ~vpid_mask;
+	old = context->vmid_cache  & ~vpid_mask;
+	if (ver != old) {
+		kvm_update_vmid(vcpu, cpu);
+		kvm_clear_request(KVM_REQ_TLB_FLUSH_GPA, vcpu);
+	}
+
+	vcpu->arch.vmid = vcpu->kvm->arch.vmid[cpu] & vpid_mask;
 }
 
 void kvm_check_vpid(struct kvm_vcpu *vcpu)
@@ -386,6 +425,7 @@ static int kvm_loongarch_env_init(void)
 	for_each_possible_cpu(cpu) {
 		context = per_cpu_ptr(vmcs, cpu);
 		context->vpid_cache = vpid_mask + 1;
+		context->vmid_cache = vpid_mask + 1;
 		context->last_vcpu = NULL;
 	}
 
-- 
2.39.3


