Return-Path: <kvm+bounces-22094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 474E9939BD2
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 09:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 048A2282973
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 07:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8244C14B97E;
	Tue, 23 Jul 2024 07:38:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A433B13C9A3;
	Tue, 23 Jul 2024 07:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721720312; cv=none; b=RFNzFok9ujzmXVuf+kKfNlJCDxfDRmsoEZOTVkcqlanF+V/g42Asii63W77elIuQnKJnBE8Sp0xQrQVB0SrOcTTkDb0sIhRiRqAZjtym/dEtniB453gd+lBAw0hSuatzE+vdvLvTUSg8oAzJJGLKjvPs2msiaWeF1UfDAWXKF70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721720312; c=relaxed/simple;
	bh=FjNgx6rpn9nCPF8fEc6SvCXKltByWMlDh/rZv5Nyk8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W6hxQTCtu2NP40cVMtWYrKNXOzfSKU/lDJ67SdPF9Xh3Mo+lahPiWbfzhkAOmsF8C5YXNDzuHbIROW1+ywRCwllZ9Iegi67RcVG22J3zipVP+WFyyyGlHD6v78BgKkOzNvaB/0L5ivRPaJ2hXBGxmI8OyqOYSa1OWOBBOktID7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx7eryXZ9m7GAAAA--.1646S3;
	Tue, 23 Jul 2024 15:38:26 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxusbxXZ9m+l9VAA--.59486S3;
	Tue, 23 Jul 2024 15:38:26 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH 1/2] LoongArch: KVM: Add paravirt qspinlock in kvm side
Date: Tue, 23 Jul 2024 15:38:24 +0800
Message-Id: <20240723073825.1811600-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240723073825.1811600-1-maobibo@loongson.cn>
References: <20240723073825.1811600-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxusbxXZ9m+l9VAA--.59486S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add paravirt spinlock in kvm side, idle instruction is used with
pv_wait() function so that vCPU thread releases pCPU and sleeps
on the wait queue. With pv_kick_cpu() function, hypercall
instruction is used to wake up vCPU thread and yield to vcpu thread,
caller vcpu thread gives up schedule.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_host.h  |  4 ++++
 arch/loongarch/include/asm/kvm_para.h  |  1 +
 arch/loongarch/include/asm/loongarch.h |  1 +
 arch/loongarch/kvm/exit.c              | 24 +++++++++++++++++++++++-
 arch/loongarch/kvm/vcpu.c              | 13 ++++++++++++-
 5 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 44b54965f5b4..9c60c1018410 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -32,6 +32,7 @@
 #define KVM_HALT_POLL_NS_DEFAULT	500000
 #define KVM_REQ_TLB_FLUSH_GPA		KVM_ARCH_REQ(0)
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(1)
+#define KVM_REQ_EVENT			KVM_ARCH_REQ(2)
 
 #define KVM_GUESTDBG_SW_BP_MASK		\
 	(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
@@ -214,6 +215,9 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		struct gfn_to_hva_cache cache;
 	} st;
+	struct {
+		bool pv_unhalted;
+	} pv;
 };
 
 static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, int reg)
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index d134b63b921f..67aef57e7490 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -15,6 +15,7 @@
 #define KVM_HCALL_SERVICE		HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SERVICE)
 #define  KVM_HCALL_FUNC_IPI		1
 #define  KVM_HCALL_FUNC_NOTIFY		2
+#define  KVM_HCALL_FUNC_KICK		3
 
 #define KVM_HCALL_SWDBG			HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
 
diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 7a4633ef284b..27961668bfd9 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -170,6 +170,7 @@
 #define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
 #define  KVM_FEATURE_IPI		BIT(1)
 #define  KVM_FEATURE_STEAL_TIME		BIT(2)
+#define  KVM_FEATURE_PARAVIRT_SPINLOCK	BIT(3)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ea73f9dc2cc6..bed182573b91 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -50,7 +50,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 		vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
 		break;
 	case CPUCFG_KVM_FEATURE:
-		ret = KVM_FEATURE_IPI;
+		ret = KVM_FEATURE_IPI | KVM_FEATURE_PARAVIRT_SPINLOCK;
 		if (kvm_pvtime_supported())
 			ret |= KVM_FEATURE_STEAL_TIME;
 		vcpu->arch.gprs[rd] = ret;
@@ -776,6 +776,25 @@ static int kvm_send_pv_ipi(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static long kvm_pv_kick_cpu(struct kvm_vcpu *vcpu)
+{
+	int cpu = vcpu->arch.gprs[LOONGARCH_GPR_A1];
+	struct kvm_vcpu *dst;
+
+	dst = kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu);
+	if (!dst)
+		return KVM_HCALL_INVALID_PARAMETER;
+
+	dst->arch.pv.pv_unhalted = true;
+	kvm_make_request(KVM_REQ_EVENT, dst);
+	kvm_vcpu_kick(dst);
+	/* Ignore requests to yield to self */
+	if (dst != vcpu)
+		kvm_vcpu_yield_to(dst);
+
+	return 0;
+}
+
 /*
  * Hypercall emulation always return to guest, Caller should check retval.
  */
@@ -792,6 +811,9 @@ static void kvm_handle_service(struct kvm_vcpu *vcpu)
 	case KVM_HCALL_FUNC_NOTIFY:
 		ret = kvm_save_notify(vcpu);
 		break;
+	case KVM_HCALL_FUNC_KICK:
+		ret =  kvm_pv_kick_cpu(vcpu);
+		break;
 	default:
 		ret = KVM_HCALL_INVALID_CODE;
 		break;
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 16756ffb55e8..19446b9a32e6 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -95,6 +95,9 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
 	if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 		kvm_update_stolen_time(vcpu);
 
+	if (kvm_check_request(KVM_REQ_EVENT, vcpu))
+		vcpu->arch.pv.pv_unhalted = false;
+
 	return RESUME_GUEST;
 }
 
@@ -222,9 +225,17 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.pv.pv_unhalted)
+		return true;
+
+	return false;
+}
+
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	return !!(vcpu->arch.irq_pending) &&
+	return (!!vcpu->arch.irq_pending || kvm_vcpu_has_events(vcpu)) &&
 		vcpu->arch.mp_state.mp_state == KVM_MP_STATE_RUNNABLE;
 }
 
-- 
2.39.3


