Return-Path: <kvm+bounces-68883-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QMDOMFMJcmmOagAAu9opvQ
	(envelope-from <kvm+bounces-68883-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:26:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D8165F71
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 12B8F76BA4C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555E444D6BE;
	Thu, 22 Jan 2026 11:14:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5762F5472;
	Thu, 22 Jan 2026 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080489; cv=none; b=G1s4KS/U+wXQIlKJe080EWnFQ+dYIwksRAXZc+4/9M0wBicAZOQy0jF2GTKISw+nfXx1XX1Ec+lIK1XEBZ5oGIEXndtapn3xklUZeZkIJRRY4T0/PcHVi8XYPW20Us6y3DxWJDxehYqJ0BCNmv1Hqj6BWqv3w1XO3ojga4RYr5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080489; c=relaxed/simple;
	bh=ZM9jMKC1FNU2vUL0nu3IkQWKCp/IJS9VWWAFmMpqNOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Re+OyNSWEMqBR2RS/dNiloTMKVt4EwqWSjh3L2HTMEtRxJ9zEtaGE4XHHOiMTN9NOYojbRdBwQFout3+uRhmlCdjbUkzFKtGdU1EySyw6Pzq5KXNzFKHQcPnkHPKvthvei2Ia8I7mGy4Ljf/1111DvYY2JKLDfpozMtKvzU/3nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxVvCdBnJpz3sLAA--.38163S3;
	Thu, 22 Jan 2026 19:14:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxquCbBnJpwR4rAA--.21397S5;
	Thu, 22 Jan 2026 19:14:37 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 3/3] LoongArch: KVM: Add FPU delay load support
Date: Thu, 22 Jan 2026 19:14:33 +0800
Message-Id: <20260122111434.1737872-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260122111434.1737872-1-maobibo@loongson.cn>
References: <20260122111434.1737872-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxquCbBnJpwR4rAA--.21397S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.24 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-68883-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 65D8165F71
X-Rspamd-Action: no action

FPU is lazy enabled with KVM hypervisor. After FPU is enabled and
loaded, vCPU can be preempted and FPU will be lost again. Here FPU
is delay load until guest enter entry.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h |  3 +++
 arch/loongarch/kvm/exit.c             |  6 +++---
 arch/loongarch/kvm/vcpu.c             | 24 +++++++++---------------
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index e4fe5b8e8149..2ad61f2dc3a9 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -37,6 +37,9 @@
 #define KVM_REQ_TLB_FLUSH_GPA		KVM_ARCH_REQ(0)
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(1)
 #define KVM_REQ_PMU			KVM_ARCH_REQ(2)
+#define KVM_REQ_FPU_LOAD		KVM_ARCH_REQ(3)
+#define KVM_REQ_LSX_LOAD		KVM_ARCH_REQ(4)
+#define KVM_REQ_LASX_LOAD		KVM_ARCH_REQ(5)
 
 #define KVM_GUESTDBG_SW_BP_MASK		\
 	(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 74b427287e96..f979e70da7c3 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -754,7 +754,7 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu, int ecode)
 		return RESUME_HOST;
 	}
 
-	kvm_own_fpu(vcpu);
+	kvm_make_request(KVM_REQ_FPU_LOAD, vcpu);
 
 	return RESUME_GUEST;
 }
@@ -795,7 +795,7 @@ static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu, int ecode)
 	if (!kvm_guest_has_lsx(&vcpu->arch))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
 	else
-		kvm_own_lsx(vcpu);
+		kvm_make_request(KVM_REQ_LSX_LOAD, vcpu);
 
 	return RESUME_GUEST;
 }
@@ -813,7 +813,7 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu, int ecode)
 	if (!kvm_guest_has_lasx(&vcpu->arch))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
 	else
-		kvm_own_lasx(vcpu);
+		kvm_make_request(KVM_REQ_LASX_LOAD, vcpu);
 
 	return RESUME_GUEST;
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index d91a1160a309..572cae4f7882 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -232,6 +232,15 @@ static void kvm_late_check_requests(struct kvm_vcpu *vcpu)
 			kvm_flush_tlb_gpa(vcpu, vcpu->arch.flush_gpa);
 			vcpu->arch.flush_gpa = INVALID_GPA;
 		}
+
+	if (kvm_check_request(KVM_REQ_FPU_LOAD, vcpu))
+		kvm_own_fpu(vcpu);
+
+	if (kvm_check_request(KVM_REQ_LSX_LOAD, vcpu))
+		kvm_own_lsx(vcpu);
+
+	if (kvm_check_request(KVM_REQ_LASX_LOAD, vcpu))
+		kvm_own_lasx(vcpu);
 }
 
 /*
@@ -1338,8 +1347,6 @@ static inline void kvm_check_fcsr_alive(struct kvm_vcpu *vcpu) { }
 /* Enable FPU and restore context */
 void kvm_own_fpu(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
-
 	/*
 	 * Enable FPU for guest
 	 * Set FR and FRE according to guest context
@@ -1349,17 +1356,12 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_restore_fpu(&vcpu->arch.fpu);
 	vcpu->arch.aux_inuse |= KVM_LARCH_FPU;
-	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU);
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
@@ -1379,10 +1381,7 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LSX);
 	vcpu->arch.aux_inuse |= KVM_LARCH_LSX | KVM_LARCH_FPU;
-	preempt_enable();
-
 	return 0;
 }
 #endif
@@ -1391,8 +1390,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 /* Enable LASX and restore context */
 int kvm_own_lasx(struct kvm_vcpu *vcpu)
 {
-	preempt_disable();
-
 	kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
 	set_csr_euen(CSR_EUEN_FPEN | CSR_EUEN_LSXEN | CSR_EUEN_LASXEN);
 	switch (vcpu->arch.aux_inuse & (KVM_LARCH_FPU | KVM_LARCH_LSX)) {
@@ -1412,10 +1409,7 @@ int kvm_own_lasx(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_LASX);
 	vcpu->arch.aux_inuse |= KVM_LARCH_LASX | KVM_LARCH_LSX | KVM_LARCH_FPU;
-	preempt_enable();
-
 	return 0;
 }
 #endif
-- 
2.39.3


