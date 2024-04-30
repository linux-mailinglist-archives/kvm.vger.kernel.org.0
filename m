Return-Path: <kvm+bounces-16265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2851A8B808F
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 21:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 959D01F24696
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 19:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFE1199E8C;
	Tue, 30 Apr 2024 19:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jIoxzCWw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00799199E87
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 19:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714505524; cv=none; b=IeEAN2kQbstdGnxJXIuab7K9wkOyZZCZfvfyNtcPBPwDHyFZhIjwXHjfxD4GDJvkDwMB/gN00B4gFUgquHG9PC08+4UvbvPxoGWhXDvn3DUzoFtq/Ys+5FFlAKLFcG3kEU/IZfOiR9iOxAFhNylcztWM16dEpB+K3mPIxSfECG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714505524; c=relaxed/simple;
	bh=W+u+y7MWVg0P4qdPzROh25II2YFSK5VTz5XTnAkY0hA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S8WI6eKcug+XR1TrG7taJwkAQB+Zr2P8Y1PVLqbJTBc0MDpvoUiFfjBukYJLlhNOvdXosOa/c3U/bi41rVMKBuB2MMOPHdOtqEl8aOW4vpjNyW1OAqv0CJ5omzDAaS/Vsm+BsHCp85BJ8sNjXmwLQODLJ2NwcOpBXXtsueJpa0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jIoxzCWw; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de610854b8bso2895956276.0
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 12:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714505522; x=1715110322; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/9fRzl3CD0k/SyefV+PuVpGeG7yuKpTeGf5FXkOJQxc=;
        b=jIoxzCWwcWUb3+1GhOFOaYUvvT11RADNXMQ/hLNuzYBL0j/Zq+lCkU0/k4B7l2+6vx
         wBS13BW/IIB6vrNtvN9wXQaVxrdgSiAQZ/w4yl/dGlBx352pluQYkBtat5zZ+AXyMiwU
         V/HW9b11Xy9WsVacdDhqI7kPLPqcs3wBMTb5KV98JTade7eQXlzg8EmPKcpbe2pTljBa
         OUy3dj1Jj769GLA9R7bGwPQTJqfZZlz1wn2KemTzu0gQ7G2s27LO8j61HObD/y6S4kmm
         pAm/BFudGWZEKipQNJbTRufyESyZ97WGz4b5/hl40egd44eg+pVq388LldT3+LXCt4vY
         CBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714505522; x=1715110322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/9fRzl3CD0k/SyefV+PuVpGeG7yuKpTeGf5FXkOJQxc=;
        b=SqnNH9pXvNdcpwpF77E0FTWnoaDgvtfSijkpvTCeusE8iibyEybpC+1KN7n2djEUOK
         SWMw8AOgcD/Aak+2CWhEgr/sVwWOW2dHRZtf0Kxpb8nD77SG37aMcMiqnQd7Ci8T6EVQ
         bLun+TmF9wL8Dptbnz18JCGfqzj7DNOYlHU+8wx9lLST7JJgbN0TXGy17m7ir66wdQcQ
         1L5cXlu0nqsyvxLCs69F6/lWsLuTT3C8BIMwnir85ZxN8IO3S3c9hknvevmn14dzE+3Z
         2sUEX9vDRCVh66jZiSoAIHVAKxLc0PdpjWIduDZhd8ZcNbm01QFhdE8wkHmHRSuo96pH
         MAXQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+PSuVZxf+408+GlhQI432SqHT331dWe2duV01yMvcl7oDu/fic1dKCW+ANqBAR1hViyXnRjQ72gDLz47Jq6qL/l/U
X-Gm-Message-State: AOJu0YzLO1E1vRIeN4UGD58EUjDPqenx5MwoUqtttwN36aZbymKa5i84
	vZIrEntPBLpsUyt7HiLJcqvya8opMmw7v26KxVOfG8toOfHqXbqzNItgqEpEUoudY6f1IAgN57K
	IVA==
X-Google-Smtp-Source: AGHT+IHAdk2rf8sKJrz0YzlhWlhSiHEVj5XA1lMxBkIc6CQI4jsKBeWM7e1dBIV2qjtpd3vjCDa8fgs5KY0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2d16:0:b0:de1:d49:7ff6 with SMTP id
 t22-20020a252d16000000b00de10d497ff6mr66932ybt.7.1714505521993; Tue, 30 Apr
 2024 12:32:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Apr 2024 12:31:54 -0700
In-Reply-To: <20240430193157.419425-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430193157.419425-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430193157.419425-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: Plumb in a @sched_in flag to kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a @sched_in flag to kvm_arch_vcpu_load() to note that the vCPU is
being (re)loaded by kvm_sched_in(), i.e. after the vCPU was previously
scheduled out.  KVM x86 currently uses a dedicated kvm_arch_sched_in()
hook, but that's unnecessarily brittle as the behavior of the arch hook
heavily depends on the arbitrary order of the two arch calls.

A separate hook also makes it unnecessarily difficult to do something
unique when re-loading vCPU during kvm_sched_in(), e.g. to optimize vCPU
loading if KVM knows that some CPU state couldn't have changed while the
vCPU was scheduled out.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c            | 2 +-
 arch/arm64/kvm/emulate-nested.c | 4 ++--
 arch/arm64/kvm/reset.c          | 2 +-
 arch/loongarch/kvm/vcpu.c       | 2 +-
 arch/mips/kvm/mmu.c             | 2 +-
 arch/powerpc/kvm/powerpc.c      | 2 +-
 arch/riscv/kvm/vcpu.c           | 4 ++--
 arch/s390/kvm/kvm-s390.c        | 2 +-
 arch/x86/kvm/x86.c              | 2 +-
 include/linux/kvm_host.h        | 2 +-
 virt/kvm/kvm_main.c             | 4 ++--
 11 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c4a0a35e02c7..30ea103bfacb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -428,7 +428,7 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 4697ba41b3a9..ad5458c47e5e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2193,7 +2193,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	*vcpu_pc(vcpu) = elr;
 	*vcpu_cpsr(vcpu) = spsr;
 
-	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	kvm_arch_vcpu_load(vcpu, smp_processor_id(), false);
 	preempt_enable();
 }
 
@@ -2274,7 +2274,7 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	 */
 	__kvm_adjust_pc(vcpu);
 
-	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	kvm_arch_vcpu_load(vcpu, smp_processor_id(), false);
 	preempt_enable();
 
 	return 1;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 68d1d05672bd..654cf09c81e9 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -262,7 +262,7 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_reset(vcpu);
 
 	if (loaded)
-		kvm_arch_vcpu_load(vcpu, smp_processor_id());
+		kvm_arch_vcpu_load(vcpu, smp_processor_id(), false);
 	preempt_enable();
 }
 
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 3a8779065f73..61d549c4f8d1 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1050,7 +1050,7 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	return 0;
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
 	unsigned long flags;
 
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index c17157e700c0..6797799f3f32 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -682,7 +682,7 @@ static void kvm_mips_migrate_count(struct kvm_vcpu *vcpu)
 }
 
 /* Restore ASID once we are scheduled back after preemption */
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
 	unsigned long flags;
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index d32abe7fe6ab..8de620716875 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -826,7 +826,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 	return kvmppc_core_pending_dec(vcpu);
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
 #ifdef CONFIG_BOOKE
 	/*
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..a7b7f172fa61 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -87,7 +87,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset the guest CSRs for hotplug usecase */
 	if (loaded)
-		kvm_arch_vcpu_load(vcpu, smp_processor_id());
+		kvm_arch_vcpu_load(vcpu, smp_processor_id(), false);
 	put_cpu();
 }
 
@@ -507,7 +507,7 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5147b943a864..9f04dc312641 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3713,7 +3713,7 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
 	return value;
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool shed_in)
 {
 
 	gmap_enable(vcpu->arch.enabled_gmap);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d2619d3eee4..925cadb18b55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5003,7 +5003,7 @@ static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in)
 {
 	/* Address WBINVD may be executed by guest */
 	if (need_emulate_wbinvd(vcpu)) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index afbc99264ffa..2f5e35eb7eab 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1498,7 +1498,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 658581d4ad68..4a4b29a9bace 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -211,7 +211,7 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 
 	__this_cpu_write(kvm_running_vcpu, vcpu);
 	preempt_notifier_register(&vcpu->preempt_notifier);
-	kvm_arch_vcpu_load(vcpu, cpu);
+	kvm_arch_vcpu_load(vcpu, cpu, false);
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(vcpu_load);
@@ -6279,7 +6279,7 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 
 	__this_cpu_write(kvm_running_vcpu, vcpu);
 	kvm_arch_sched_in(vcpu, cpu);
-	kvm_arch_vcpu_load(vcpu, cpu);
+	kvm_arch_vcpu_load(vcpu, cpu, true);
 }
 
 static void kvm_sched_out(struct preempt_notifier *pn,
-- 
2.45.0.rc0.197.gbae5840b3b-goog


