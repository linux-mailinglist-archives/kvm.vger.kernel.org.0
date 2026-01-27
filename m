Return-Path: <kvm+bounces-69245-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Av/K0e1eGlzsQEAu9opvQ
	(envelope-from <kvm+bounces-69245-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:53:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51DF69487A
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:53:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CFF02306814B
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 12:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC76356A0F;
	Tue, 27 Jan 2026 12:51:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E21E355042;
	Tue, 27 Jan 2026 12:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769518294; cv=none; b=uQMHiXl7w7K+WOZST9SzfDSh5g7k7m/OTkYFfTR+an+oBGiGfhjFFA+poR48XeiYM1v3wBMtF3R1NYPMNbtvveu9WL5Uar3f5suVyYr1xPnBqOW0lbC9H2f2bS/8uXCQVKJ2HJvT3QRkKq7KDUM3iyI6QtJim1+mXMS9rN6k1ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769518294; c=relaxed/simple;
	bh=7YIh20H2by5sDVrbfxOP83AGWSzPQwwRkf2iETQ6jlc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ieqLEIhMglzHJBbwn3JtF56sfDYbDLltUWkZTHPAEDFX/LTlFx9hH34PQer5VSVkKPfaQ6zAXjTht4Bz8NyTEumuQRnp6aqY8LZTFT0BdWr185s8iJXAzOfoV/xYCudJox0lnpQTkDwwLE0qtjm8H7M+DVMhG3D6jKD78wC7lfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxAfHOtHhpNR4NAA--.43149S3;
	Tue, 27 Jan 2026 20:51:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxWcHMtHhpYpo0AA--.24006S5;
	Tue, 27 Jan 2026 20:51:26 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v2 3/3] LoongArch: KVM: Add FPU delay load support
Date: Tue, 27 Jan 2026 20:51:24 +0800
Message-Id: <20260127125124.3234252-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260127125124.3234252-1-maobibo@loongson.cn>
References: <20260127125124.3234252-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxWcHMtHhpYpo0AA--.24006S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	DMARC_NA(0.00)[loongson.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69245-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 51DF69487A
X-Rspamd-Action: no action

FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
loaded, vCPU can be preempted and FPU will be lost again. Here FPU
is delay load until guest enter entry.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/exit.c             | 15 ++++++++----
 arch/loongarch/kvm/vcpu.c             | 33 +++++++++++++++++----------
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index e4fe5b8e8149..902ff7bc0e35 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -37,6 +37,7 @@
 #define KVM_REQ_TLB_FLUSH_GPA		KVM_ARCH_REQ(0)
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(1)
 #define KVM_REQ_PMU			KVM_ARCH_REQ(2)
+#define KVM_REQ_FPU_LOAD		KVM_ARCH_REQ(3)
 
 #define KVM_GUESTDBG_SW_BP_MASK		\
 	(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
@@ -234,6 +235,7 @@ struct kvm_vcpu_arch {
 	u64 vpid;
 	gpa_t flush_gpa;
 
+	int fpu_load_type;
 	/* Frequency of stable timer in Hz */
 	u64 timer_mhz;
 	ktime_t expire;
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 74b427287e96..b6f08df8fedb 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -754,7 +754,8 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu, int ecode)
 		return RESUME_HOST;
 	}
 
-	kvm_own_fpu(vcpu);
+	vcpu->arch.fpu_load_type = KVM_LARCH_FPU;
+	kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
 
 	return RESUME_GUEST;
 }
@@ -794,8 +795,10 @@ static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (!kvm_guest_has_lsx(&vcpu->arch))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
-	else
-		kvm_own_lsx(vcpu);
+	else {
+		vcpu->arch.fpu_load_type = KVM_LARCH_LSX;
+		kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
+	}
 
 	return RESUME_GUEST;
 }
@@ -812,8 +815,10 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (!kvm_guest_has_lasx(&vcpu->arch))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
-	else
-		kvm_own_lasx(vcpu);
+	else {
+		vcpu->arch.fpu_load_type = KVM_LARCH_LASX;
+		kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
+	}
 
 	return RESUME_GUEST;
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index d91a1160a309..3e749e9738b2 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -232,6 +232,27 @@ static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
 			kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
 			vcpu->arch.flush_gpa = INVALID_GPA;
 		}
+
+	if (kvm_check_request(KVM_REQ_FPU_LOAD, vcpu)) {
+		switch (vcpu->arch.fpu_load_type) {
+		case KVM_LARCH_FPU:
+			kvm_own_fpu(vcpu);
+			break;
+
+		case KVM_LARCH_LSX:
+			kvm_own_lsx(vcpu);
+			break;
+
+		case KVM_LARCH_LASX:
+			kvm_own_lasx(vcpu);
+			break;
+
+		default:
+			break;
+		}
+
+		vcpu->arch.fpu_load_type = 0;
+	}
 }
 
 /*
@@ -1338,8 +1359,6 @@ static inline void kvm_check_fcsr_alive(struct kvm_vcpu *vcpu) { }
 /* Enable FPU and restore context */
 void kvm_own_fpu(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
-
 	/*
 	 * Enable FPU for guest
 	 * Set FR and FRE according to guest context
@@ -1350,16 +1369,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
 	kvm_restore_fpu(&vcpu->arch.fpu);
 	vcpu->arch.aux_inuse |= KVM_LARCH_FPU;
 	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU);
-
-	preempt_enable();
 }
 
 #ifdef CONFIG_CPU_HAS_LSX
 /* Enable LSX and restore context */
 int kvm_own_lsx(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
-
 	/* Enable LSX for guest */
 	kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_LSXEN | CSR_EUEN_FPEN);
@@ -1381,8 +1396,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 
 	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
 	vcpu->arch.aux_inuse |= KVM_LARCH_LSX | KVM_LARCH_FPU;
-	preempt_enable();
-
 	return 0;
 }
 #endif
@@ -1391,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 /* Enable LASX and restore context */
 int kvm_own_lasx(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
-
 	kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
 	switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
@@ -1414,8 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
 
 	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX);
 	vcpu->arch.aux_inuse |= KVM_LARCH_LASX | KVM_LARCH_LSX | KVM_LARCH_FPU;
-	preempt_enable();
-
 	return 0;
 }
 #endif
-- 
2.39.3


