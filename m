Return-Path: <kvm+bounces-16268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EFB08B809B
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 21:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F08A1C231A8
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 19:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF991BED9C;
	Tue, 30 Apr 2024 19:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MsPRclbO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E0B1BED6C
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 19:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714505532; cv=none; b=g6Cobc5xmkcm0/jN5I97XGo3ymEScnT4FRxh+DuvbWGFlD8gz5Ldm6/i+LtUWbMxzJYjyMqs4CbEvIM7XSDQC2lcsUYNmyUio3AvvFiibBflu9zz9imefEP9TJ8RFuMu2X8aw7E0cu716MQCjDUmzAlbtSGlDOJeKtbrWk2U12Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714505532; c=relaxed/simple;
	bh=9MhcqD3oLMqfUjo9TWK3GGfH4maBAFWA/FNunEEvlt0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pcr+vXhdmpr967tf+1WmXz3iVuxwbkx2vcTJ2JTvDHu+Oj3zlBRLsfFXLCNMl5uJxsqVSxhM2BEVq9OHpDWv3ZWI0crYhDRlsTCrVa/xF+a73/n9qcf+kJ4o2w6t5CqTVWn8SdJXyYT6pbFDuw5j3Mfa8QzIwS+qTr8hh2LG4s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MsPRclbO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61bea0c36bbso23638887b3.2
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 12:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714505529; x=1715110329; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zlyEud5d/bhoGiNpMEEmnNOfWYjdDQf4ZBXlBrFZHdU=;
        b=MsPRclbOMMYK0Lbgrn14Uwt9UJd03dzLxDN6GDcbHIJY79k6Qajw4KY1t5Gj12ioKY
         tK1/P25DwUWrA6eu3S2p2kaGq/JMKd02vpeGM8IxxxuKFX3FO6Br+07LSdbtU1oPlkLP
         UJkAnpCe/uzmphUvQTC4LDdgC8Y3I3PLYfC9i/27sh/dpJXRHo9VuqRVNH9rMtib9OhV
         VXCsku3QBHMsUQ2hiaqoZd85fIZIPR5hMwRvZf7uYhcgrMuzNWiHuf2tdsIS6UoZQfxA
         LWq0xE0hf5oYe/9DQ7gcHh3m0P039KpPwqrgfNJBzJ6uFzJac3wOxB3hlc0LVEXwm+ee
         kLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714505529; x=1715110329;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zlyEud5d/bhoGiNpMEEmnNOfWYjdDQf4ZBXlBrFZHdU=;
        b=El4DivgtX+ZVvfkxFQTuB+TyKIp0lqeQeh6mZ/TMuvnWD7aZQzoEb7W443YCSltNFJ
         pwSZcGeDAkfk471Ak5VZClfSir06isq6fOa49TsHASN1yTEMGtVrquuQ61n7rL7MU7FO
         z6cG9JZcu1H7mlspvEzxj4qtNoZHl91aSwmdr3aZdAr+LG0OQ/OnZ9Op/wHjAPeyYZ0b
         2LmENgktojqE+Wv99l98hZyK2nP9gUGFI3PYo1OAqaDpnwevRI5zh45npFc28QGwmrpg
         4CwpJTzwToBN1LUTntN8GkjzMbDN1zT4sWJNwxtyc5egp6jXCEoe+xYXbNF5mB60SNBD
         aixA==
X-Forwarded-Encrypted: i=1; AJvYcCXrs/hCV4pu3BQwO5IIMCsEksblnp43EF0CDvAenaFfHYB9N0t4rdLGhlIo79A/ButYSBkIBPlHExaqpnKiZay90ICF
X-Gm-Message-State: AOJu0Yy0eMu5SX0KmNLo/wQiKL1Cou5jhF7vkIm/lW1/ZdGZqsGtX0fN
	y0GcNeRKcoFSdO4feTI78gt+cM62QV1G8fBoXCAer2uzEMYMSY6lS6bTotLdNR6ay3Zm6LV0MeN
	rvA==
X-Google-Smtp-Source: AGHT+IG4cB2+idKWRATGCb6OVW7YEX4JltpUlzKwSOtT4qBlUznDsr14mRRca16T5tdKvIRNLf2VCRL2BMM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d2c5:0:b0:61d:3304:c25e with SMTP id
 u188-20020a0dd2c5000000b0061d3304c25emr134509ywd.7.1714505528716; Tue, 30 Apr
 2024 12:32:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Apr 2024 12:31:57 -0700
In-Reply-To: <20240430193157.419425-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430193157.419425-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430193157.419425-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: Delete the now unused kvm_arch_sched_in()
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

Delete kvm_arch_sched_in() now that all implementations are nops.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h     | 1 -
 arch/loongarch/include/asm/kvm_host.h | 1 -
 arch/mips/include/asm/kvm_host.h      | 1 -
 arch/powerpc/include/asm/kvm_host.h   | 1 -
 arch/riscv/include/asm/kvm_host.h     | 1 -
 arch/s390/include/asm/kvm_host.h      | 1 -
 arch/x86/kvm/pmu.c                    | 6 +++---
 arch/x86/kvm/x86.c                    | 5 -----
 include/linux/kvm_host.h              | 2 --
 virt/kvm/kvm_main.c                   | 1 -
 10 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e8a496fb284..a12d3bb0b590 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1180,7 +1180,6 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 }
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 69305441f40d..64ca60a3ce24 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -228,7 +228,6 @@ static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *arch)
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 179f320cc231..6743a57c1ab4 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -890,7 +890,6 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 8abac532146e..c4fb6a27fb92 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -897,7 +897,6 @@ struct kvm_vcpu_arch {
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 484d04a92fa6..6cd7a576ef14 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -272,7 +272,6 @@ struct kvm_vcpu_arch {
 };
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
 #define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 95990461888f..e9fcaf4607a6 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1045,7 +1045,6 @@ extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c397b28e3d1b..75346a588e13 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -521,9 +521,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	}
 
 	/*
-	 * Unused perf_events are only released if the corresponding MSRs
-	 * weren't accessed during the last vCPU time slice. kvm_arch_sched_in
-	 * triggers KVM_REQ_PMU if cleanup is needed.
+	 * Release unused perf_events if the corresponding guest MSRs weren't
+	 * accessed during the last vCPU time slice (need_cleanup is set when
+	 * the vCPU is scheduled back in).
 	 */
 	if (unlikely(pmu->need_cleanup))
 		kvm_pmu_cleanup(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b0a21f2e56e..17d6ce0d4fa6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12577,11 +12577,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
 }
 
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-
-}
-
 void kvm_arch_free_vm(struct kvm *kvm)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f5e35eb7eab..85b6dd7927fe 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1496,8 +1496,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
 
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu, bool sched_in);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4a4b29a9bace..b154b22a3b84 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6278,7 +6278,6 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 	WRITE_ONCE(vcpu->ready, false);
 
 	__this_cpu_write(kvm_running_vcpu, vcpu);
-	kvm_arch_sched_in(vcpu, cpu);
 	kvm_arch_vcpu_load(vcpu, cpu, true);
 }
 
-- 
2.45.0.rc0.197.gbae5840b3b-goog


