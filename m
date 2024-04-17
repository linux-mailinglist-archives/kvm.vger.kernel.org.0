Return-Path: <kvm+bounces-14938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 075FB8A7D58
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30E1DB2169A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A171B6E61E;
	Wed, 17 Apr 2024 07:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="c0yF1oBK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45883B653
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 07:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713339940; cv=none; b=alMmXfQ+iXSduYlSYe75bnzdyuJDK0od7VA9DEGhQFT4pVOsZCJO4P0Zkb4fb27WoPdEwnpBX/rgUUwD8w0RJ1C5QPxm7ETq96s387Oh76qiL6rnNj8qNc4pDYmnn7hKgYZccYGh0o3AS8rogOP1xBa749I1qV+jOKZ2dbg4dgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713339940; c=relaxed/simple;
	bh=H193LG1OYhGZxbiufps3RKJjYMc9orDOM742EhH0pVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Qch+gVsrQgc9hZJSPKnz2kb73Cehre8VK107HLNSckg0i3dahIWNuyBiiy4f7IjGlbgF4b8oeLQm4Q+lboPQ1aNBc1bESvxE6JcJZT1Z9orXYFA4hmTtOaXklVT6Z18IlK9tS3Lpsk5JwQvmvaV6mlQnY1GAsZ+W9fFuCAOAzWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=c0yF1oBK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e834159f40so1521985ad.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 00:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1713339938; x=1713944738; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=St7UoB0o1VZp6BFYuL7tbSNr44kxdvXND12E5lAvbIw=;
        b=c0yF1oBKTfPVSvXD7LQ9PE9Cv+WZeL4NY5WYKTFBpdABA2Um2xQMZWY3kW4a/rsGVl
         WpDE9UPlwkWhPplP7t9d/eEGFwIg4IchHB8kFxX9aS0vIi0OEcG7KJWnd8vUQCi3vZ3P
         mzDZqckvCKrifXDB+wvJPTev5VGCrguv+UJ0yaE3NPFrZkUHLgd1nT+ymTFUP9vaYijk
         OC1iLMotQQsil4vXSoZVB+i/EFtqBLflGq5cOpMmkQPrL3tAsITIwI2r5iH+99BZLR1B
         qwGQu3RwHWzLhnBQpyurTSbhnT1eco7maJ1UYTd7QLwib76xXVMIA1yN1L65xAsqoaSF
         uWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713339938; x=1713944738;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=St7UoB0o1VZp6BFYuL7tbSNr44kxdvXND12E5lAvbIw=;
        b=hNCpyCL99GnjNAvzQtx+daYm37nvf7e+tO2otGAved9xsVHTxa/v0NROiX1MuVq3Qy
         tktiGZu9l81YWSIDIOoQ3t5vROk9X0/45LlsZhQ8sMDCCoqN4/YQJ1Evy/8gqDk8CTRP
         rFElBNqKLeQv6ZawnkENxpwRyEb/+rSC0u6H+FiLmub3+uGASUIXICecdimXNejET7gN
         TBNR/zm+ktD39hi3XxEUukgvW7wNIoeLBlfFfAAcHwXjrhAvgBSgtdIXbPp+LUu0Szqu
         Ojkalm1YIaG2jlyOMOSamwcAzan1FcPJuzOTb9Kufw4f7gAN+IC3bOweExtaSt8SSelv
         CrMA==
X-Forwarded-Encrypted: i=1; AJvYcCVCejBqCteki0m43FWqD5fbhKzGBowov0ek4eH1oJ92Hhs4D1jUd1kJXM44+k+AwILtDSO5Xav9oNXSlMuHnYATkr5f
X-Gm-Message-State: AOJu0YxAdExAamtQNHZPDhqhjyhZ8SuZ4w5IHkYQ4Y3i1hSngSbbFEX8
	JnlRZDMA2lWY1M8ZqPIhi4gM4FkdWcseZ4T7p2tmKPUsqvj73vNUZ2m9T+97TGE=
X-Google-Smtp-Source: AGHT+IFHSsF9cxqiNY1Nu+bx/qodN9CUjIwlbNj3jKBIDWTLMlrbov3NEnKLK0AuzqvNxhhd9qpAyQ==
X-Received: by 2002:a17:902:f7c5:b0:1e0:c567:bb42 with SMTP id h5-20020a170902f7c500b001e0c567bb42mr13147740plw.59.1713339938562;
        Wed, 17 Apr 2024 00:45:38 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id g21-20020a170902c39500b001e7b7a79340sm3166065plg.267.2024.04.17.00.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 00:45:38 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] RISCV: KVM: Introduce mp_state_lock to avoid lock inversion in SBI_EXT_HSM_HART_START
Date: Wed, 17 Apr 2024 15:45:25 +0800
Message-Id: <20240417074528.16506-2-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240417074528.16506-1-yongxuan.wang@sifive.com>
References: <20240417074528.16506-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Documentation/virt/kvm/locking.rst advises that kvm->lock should be
acquired outside vcpu->mutex and kvm->srcu. However, when KVM/RISC-V
handling SBI_EXT_HSM_HART_START, the lock ordering is vcpu->mutex,
kvm->srcu then kvm->lock.

Although the lockdep checking no longer complains about this after commit
f0f44752f5f6 ("rcu: Annotate SRCU's update-side lockdep dependencies"),
it's necessary to replace kvm->lock with a new dedicated lock to ensure
only one hart can execute the SBI_EXT_HSM_HART_START call for the target
hart simultaneously.

Additionally, this patch also rename "power_off" to "mp_state" with two
possible values. The vcpu->mp_state_lock also protects the access of
vcpu->mp_state.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/include/asm/kvm_host.h |  7 ++--
 arch/riscv/kvm/vcpu.c             | 56 ++++++++++++++++++++++++-------
 arch/riscv/kvm/vcpu_sbi.c         |  7 ++--
 arch/riscv/kvm/vcpu_sbi_hsm.c     | 23 ++++++++-----
 4 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 484d04a92fa6..64d35a8c908c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -252,8 +252,9 @@ struct kvm_vcpu_arch {
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-	/* VCPU power-off state */
-	bool power_off;
+	/* VCPU power state */
+	struct kvm_mp_state mp_state;
+	spinlock_t mp_state_lock;
 
 	/* Don't run the VCPU (blocked) */
 	bool pause;
@@ -375,7 +376,9 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
 bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
+void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
+bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
 
 void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..70937f71c3c4 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -102,6 +102,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *cntx;
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 
+	spin_lock_init(&vcpu->arch.mp_state_lock);
+
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
@@ -201,7 +203,7 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
 	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
-		!vcpu->arch.power_off && !vcpu->arch.pause);
+		!kvm_riscv_vcpu_stopped(vcpu) && !vcpu->arch.pause);
 }
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
@@ -429,26 +431,50 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 	return kvm_riscv_vcpu_aia_has_interrupts(vcpu, mask);
 }
 
-void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
+static void __kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = true;
+	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
-void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->arch.mp_state_lock);
+	__kvm_riscv_vcpu_power_off(vcpu);
+	spin_unlock(&vcpu->arch.mp_state_lock);
+}
+
+void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = false;
+	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
 	kvm_vcpu_wake_up(vcpu);
 }
 
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->arch.mp_state_lock);
+	__kvm_riscv_vcpu_power_on(vcpu);
+	spin_unlock(&vcpu->arch.mp_state_lock);
+}
+
+bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu)
+{
+	bool ret;
+
+	spin_lock(&vcpu->arch.mp_state_lock);
+	ret = vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
+	spin_unlock(&vcpu->arch.mp_state_lock);
+
+	return ret;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	if (vcpu->arch.power_off)
-		mp_state->mp_state = KVM_MP_STATE_STOPPED;
-	else
-		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+	spin_lock(&vcpu->arch.mp_state_lock);
+	*mp_state = vcpu->arch.mp_state;
+	spin_unlock(&vcpu->arch.mp_state_lock);
 
 	return 0;
 }
@@ -458,17 +484,21 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 {
 	int ret = 0;
 
+	spin_lock(&vcpu->arch.mp_state_lock);
+
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.power_off = false;
+		vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
 		break;
 	case KVM_MP_STATE_STOPPED:
-		kvm_riscv_vcpu_power_off(vcpu);
+		__kvm_riscv_vcpu_power_off(vcpu);
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
+	spin_unlock(&vcpu->arch.mp_state_lock);
+
 	return ret;
 }
 
@@ -584,11 +614,11 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
 			kvm_vcpu_srcu_read_unlock(vcpu);
 			rcuwait_wait_event(wait,
-				(!vcpu->arch.power_off) && (!vcpu->arch.pause),
+				(!kvm_riscv_vcpu_stopped(vcpu)) && (!vcpu->arch.pause),
 				TASK_INTERRUPTIBLE);
 			kvm_vcpu_srcu_read_lock(vcpu);
 
-			if (vcpu->arch.power_off || vcpu->arch.pause) {
+			if (kvm_riscv_vcpu_stopped(vcpu) || vcpu->arch.pause) {
 				/*
 				 * Awaken to handle a signal, request to
 				 * sleep again later.
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 72a2ffb8dcd1..1851fc979bd2 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -138,8 +138,11 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 	unsigned long i;
 	struct kvm_vcpu *tmp;
 
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		spin_lock(&vcpu->arch.mp_state_lock);
+		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
+		spin_unlock(&vcpu->arch.mp_state_lock);
+	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&run->system_event, 0, sizeof(run->system_event));
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 7dca0e9381d9..115a6c6525fd 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -18,12 +18,18 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	struct kvm_vcpu *target_vcpu;
 	unsigned long target_vcpuid = cp->a0;
+	int ret = 0;
 
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
 	if (!target_vcpu)
 		return SBI_ERR_INVALID_PARAM;
-	if (!target_vcpu->arch.power_off)
-		return SBI_ERR_ALREADY_AVAILABLE;
+
+	spin_lock(&target_vcpu->arch.mp_state_lock);
+
+	if (target_vcpu->arch.mp_state.mp_state != KVM_MP_STATE_STOPPED) {
+		ret = SBI_ERR_ALREADY_AVAILABLE;
+		goto out;
+	}
 
 	reset_cntx = &target_vcpu->arch.guest_reset_context;
 	/* start address */
@@ -34,14 +40,18 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 	reset_cntx->a1 = cp->a2;
 	kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
 
-	kvm_riscv_vcpu_power_on(target_vcpu);
+	__kvm_riscv_vcpu_power_on(target_vcpu);
+
+out:
+	spin_unlock(&target_vcpu->arch.mp_state_lock);
+
 
 	return 0;
 }
 
 static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.power_off)
+	if (kvm_riscv_vcpu_stopped(vcpu))
 		return SBI_ERR_FAILURE;
 
 	kvm_riscv_vcpu_power_off(vcpu);
@@ -58,7 +68,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
 	if (!target_vcpu)
 		return SBI_ERR_INVALID_PARAM;
-	if (!target_vcpu->arch.power_off)
+	if (!kvm_riscv_vcpu_stopped(target_vcpu))
 		return SBI_HSM_STATE_STARTED;
 	else if (vcpu->stat.generic.blocking)
 		return SBI_HSM_STATE_SUSPENDED;
@@ -71,14 +81,11 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
-	struct kvm *kvm = vcpu->kvm;
 	unsigned long funcid = cp->a6;
 
 	switch (funcid) {
 	case SBI_EXT_HSM_HART_START:
-		mutex_lock(&kvm->lock);
 		ret = kvm_sbi_hsm_vcpu_start(vcpu);
-		mutex_unlock(&kvm->lock);
 		break;
 	case SBI_EXT_HSM_HART_STOP:
 		ret = kvm_sbi_hsm_vcpu_stop(vcpu);
-- 
2.17.1


