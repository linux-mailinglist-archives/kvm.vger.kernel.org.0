Return-Path: <kvm+bounces-69969-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDg8IjdtgWmwGAMAu9opvQ
	(envelope-from <kvm+bounces-69969-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 04:36:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E3949D42B1
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 04:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E5BE130D5953
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 03:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B7C35A943;
	Tue,  3 Feb 2026 03:31:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F8532142F;
	Tue,  3 Feb 2026 03:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770089502; cv=none; b=SQmRNlJHzbCPe3JEUNlkLNj1+FmzW1VK3dEuBs17cGUsiH5u10aAmc3BBdxFH/+hewSMI0+1nUvbfObP864v7w64svZYIanuih8yMpuUCzHzvWBXkuQsvn9eVU8SSaLduKI1jy7iz97j9amydkAOrLUX26d2fc/7Ago1ivM63bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770089502; c=relaxed/simple;
	bh=31he4kFXzR0lNTSEFBIYR7Vkdne0EhzfzekN8B+ukOU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rkKmJ9/gP1V3btTi+bbjYz/3GfDAU1UcB28SWmhttrNYExMfN2N36KJPVsstf/EZ3jbqPIxNpmFo++4MaO3AH7I+OCddSKpujryAiYRk3OOlHNJTAKP7REGtr3vqSM2GTZgSG9AgfTsnPMmPk4bcVdh9MDuGaG/Lx8mmEfZkgO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxOMIabIFp7TwPAA--.49922S3;
	Tue, 03 Feb 2026 11:31:38 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxzsIZbIFpdNk+AA--.51291S2;
	Tue, 03 Feb 2026 11:31:37 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v3 4/4] LoongArch: KVM: Add FPU delay load support
Date: Tue,  3 Feb 2026 11:31:31 +0800
Message-Id: <20260203033131.3372834-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260203033131.3372834-1-maobibo@loongson.cn>
References: <20260203033131.3372834-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxzsIZbIFpdNk+AA--.51291S2
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
	TAGGED_FROM(0.00)[bounces-69969-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: E3949D42B1
X-Rspamd-Action: no action

FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
loaded, vCPU can be preempted and FPU will be lost again, there will
be unnecessary FPU exception, load and store process. Here FPU is
delay load until guest enter entry.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  2 ++
 arch/loongarch/kvm/exit.c             | 21 ++++++++++-----
 arch/loongarch/kvm/vcpu.c             | 37 ++++++++++++++++++---------
 3 files changed, 41 insertions(+), 19 deletions(-)

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
index 65ec10a7245a..62403c7c6f9a 100644
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
@@ -822,8 +827,10 @@ static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
 	if (!kvm_guest_has_lbt(&vcpu->arch))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
-	else
-		kvm_own_lbt(vcpu);
+	else {
+		vcpu->arch.fpu_load_type = KVM_LARCH_LBT;
+		kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
+	}
 
 	return RESUME_GUEST;
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 995461d724b5..d05fe6c8f456 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -232,6 +232,31 @@ static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
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
+		case KVM_LARCH_LBT:
+			kvm_own_lbt(vcpu);
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
@@ -1286,13 +1311,11 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 #ifdef CONFIG_CPU_HAS_LBT
 int kvm_own_lbt(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
 	if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
 		set_csr_euen(CSR_EUEN_LBTEN);
 		_restore_lbt(&vcpu->arch.lbt);
 		vcpu->arch.aux_inuse |= KVM_LARCH_LBT;
 	}
-	preempt_enable();
 
 	return 0;
 }
@@ -1335,8 +1358,6 @@ static inline void kvm_check_fcsr_alive(struct kvm_vcpu *vcpu) { }
 /* Enable FPU and restore context */
 void kvm_own_fpu(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
-
 	/*
 	 * Enable FPU for guest
 	 * Set FR and FRE according to guest context
@@ -1347,16 +1368,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
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
@@ -1378,7 +1395,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 
 	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
 	vcpu->arch.aux_inuse |= KVM_LARCH_LSX | KVM_LARCH_FPU;
-	preempt_enable();
 
 	return 0;
 }
@@ -1388,8 +1404,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 /* Enable LASX and restore context */
 int kvm_own_lasx(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
-
 	kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
 	switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
@@ -1411,7 +1425,6 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
 
 	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX);
 	vcpu->arch.aux_inuse |= KVM_LARCH_LASX | KVM_LARCH_LSX | KVM_LARCH_FPU;
-	preempt_enable();
 
 	return 0;
 }
-- 
2.39.3


