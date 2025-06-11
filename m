Return-Path: <kvm+bounces-49137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08AE9AD6195
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BBC718842CF
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D3E425D54A;
	Wed, 11 Jun 2025 21:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rdF1ely2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6854725C801
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749677788; cv=none; b=mn5T6z5nj4cTyFKNMw8bcwVnD7R968e8XY8Ocr4P+6rT/q0OqviyxEh/fw8K5U4Uj9rIfPYyGevHuz5dxwO8eYsF1I09EXeaaSC2oHKRZJbOnAbHuUh2EOwsxO3m5bX4XaX6LBlWj1RVXQzLtNfDh9K5ftCEVJ3rWn6IIuOKVo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749677788; c=relaxed/simple;
	bh=gAiOyGBDazVA/57ay8kWqpiCuGFe8WYLz5SPrNws7d8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NmXoAvTDowx5+96zUVAL4l/BjpmQIq33ly/e7pQezEdTLXB/KnuZc0ZUfD04flTDwPCL2KkN3+ada5yVUltMw+WUvuZeeI/PpNYRRa1+LcPgG5DNy7JdbVtS096VmEN8ilbEue9TSo/TSF1c38PohAbYnsM2r2QuCoCkr2NLv4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rdF1ely2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311f4f2e761so268784a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749677786; x=1750282586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lfmQPMzSVsDo7Zoyui0jc0TkIPNEMYAlP9pV9h8hDXc=;
        b=rdF1ely2IKA+Zn2MsJH3x75pg/pbG9VuvTYd5a8uw8fG2HlWzyt10b1J0TSdZzLDev
         WZvkgZ4jLc8ZbYctdc3eWJnXI5azSBlhwcjgl82ea9d5S6cdd8IGR8Ch0tHssV8CuLsb
         7Rs5oJ67778LDEiArIqBBkih+nAf7u6jIdJxtgNtg192DENXeCPaYlqkfd9IscSSsxxK
         jhDVvRGXWwSy/5IApiF7H7UIjDsg6Y0Ocy4aE8DhHwk/SX8+gH5dpCe87k/98JlkuC0R
         8Mw/SUK78twT+kD9rWnOB0ZE5C09v2CRi8XL79WAgP7h7kLgu1PnkXP9Jyf8fl9eWIBk
         cpDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749677786; x=1750282586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lfmQPMzSVsDo7Zoyui0jc0TkIPNEMYAlP9pV9h8hDXc=;
        b=sertEl6VQ1kOp2Zs0LTxfbPUrEpvH3gF0GU3+YqfWtRXvpGpAC0KvYvSKxhVkO81HP
         y3Iz2E13TN8t3B2lW0WHduMwDtvqjuBAZ6zIEByYfp7S66G1T/k0mmx3IZpDrFssrjH0
         cmxO871roYlcykEkkBvtiJZgb3QavHnGb4xvOeWTVgkjCe0CSq//ZtkNcMJ7PJ+kND2I
         u45yZYL/qHWDqz5ASDu829W+0Aj/Z30/c9NTtkxhroN8IpwciE6T1qUg9uSWElDW3+vb
         ocG4keDKN9AMgwNp4Rxi5SFAx45OMHngn7P1AsaLvvZcuYynCPQuQzyaF7lQ0WzICXdX
         OXPA==
X-Gm-Message-State: AOJu0YwKltuCJlbQoPoUgcAboF5/DiIFiy7WeeZNCuGn3zjjAHT45lOY
	0Uc0NeHKKryNEMl0elQnWOXFQpzs8CrIwygWmMlK3hr9FUmfDE7MHjIEIg7Ja+4ANOsBqXwbgjy
	J/chnRg==
X-Google-Smtp-Source: AGHT+IFJZse34GkBp2Np+0jzsDBv9GLpSMFW3pCuOtalBTnCB0ZQ3qdGdFbcXcU/88x11+qo8vzvraLe5ps=
X-Received: from pjp5.prod.google.com ([2002:a17:90b:55c5:b0:301:1bf5:2f07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2745:b0:311:a623:676c
 with SMTP id 98e67ed59e1d1-313c08c8b9amr815599a91.27.1749677785722; Wed, 11
 Jun 2025 14:36:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 14:35:53 -0700
In-Reply-To: <20250611213557.294358-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611213557.294358-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611213557.294358-15-seanjc@google.com>
Subject: [PATCH v2 14/18] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a Kconfig to allow building KVM without support for emulating a I/O
APIC, PIC, and PIT, which is desirable for deployments that effectively
don't support a fully in-kernel IRQ chip, i.e. never expect any VMM to
create an in-kernel I/O APIC.  E.g. compiling out support eliminates a few
thousand lines of guest-facing code and gives security folks warm fuzzies.

As a bonus, wrapping relevant paths with CONFIG_KVM_IOAPIC #ifdefs makes
it much easier for readers to understand which bits and pieces exist
specifically for fully in-kernel IRQ chips.

Opportunistically convert all two in-kernel uses of __KVM_HAVE_IOAPIC to
CONFIG_KVM_IOAPIC, e.g. rather than add a second #ifdef to generate a stub
for kvm_arch_post_irq_routing_update().

Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/Kconfig            | 10 ++++++++++
 arch/x86/kvm/Makefile           |  5 +++--
 arch/x86/kvm/i8254.h            |  2 ++
 arch/x86/kvm/irq.c              |  8 ++++++++
 arch/x86/kvm/irq.h              |  9 +++++++++
 arch/x86/kvm/irq_comm.c         |  2 ++
 arch/x86/kvm/lapic.c            |  7 ++++++-
 arch/x86/kvm/trace.h            |  2 ++
 arch/x86/kvm/x86.c              | 22 ++++++++++++++++++----
 include/linux/kvm_host.h        |  2 +-
 include/trace/events/kvm.h      |  4 ++--
 12 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ebda93979179..f5ff5174674c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1374,9 +1374,11 @@ struct kvm_arch {
 	atomic_t noncoherent_dma_count;
 #define __KVM_HAVE_ARCH_ASSIGNED_DEVICE
 	atomic_t assigned_device_count;
+#ifdef CONFIG_KVM_IOAPIC
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
+#endif
 	atomic_t vapics_in_nmi_mode;
 	struct mutex apic_map_lock;
 	struct kvm_apic_map __rcu *apic_map;
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2eeffcec5382..2c86673155c9 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -166,6 +166,16 @@ config KVM_AMD_SEV
 	  Encrypted State (SEV-ES), and Secure Encrypted Virtualization with
 	  Secure Nested Paging (SEV-SNP) technologies on AMD processors.
 
+config KVM_IOAPIC
+	bool "I/O APIC, PIC, and PIT emulation"
+	default y
+	depends on KVM
+	help
+	  Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
+	  for full in-kernel APIC emulation.
+
+	  If unsure, say Y.
+
 config KVM_SMM
 	bool "System Management Mode emulation"
 	default y
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index a5d362c7b504..92c737257789 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -5,12 +5,13 @@ ccflags-$(CONFIG_KVM_WERROR) += -Werror
 
 include $(srctree)/virt/kvm/Makefile.kvm
 
-kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
-			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
+kvm-y			+= x86.o emulate.o irq.o lapic.o \
+			   irq_comm.o cpuid.o pmu.o mtrr.o \
 			   debugfs.o mmu/mmu.o mmu/page_track.o \
 			   mmu/spte.o
 
 kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
+kvm-$(CONFIG_KVM_IOAPIC) += i8259.o i8254.o ioapic.o
 kvm-$(CONFIG_KVM_HYPERV) += hyperv.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-$(CONFIG_KVM_SMM)	+= smm.o
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index b9c1feb379a7..e8bd59ad8a7c 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -8,6 +8,7 @@
 
 #include <uapi/asm/kvm.h>
 
+#ifdef CONFIG_KVM_IOAPIC
 struct kvm_kpit_channel_state {
 	u32 count; /* can be 65536 */
 	u16 latched_count;
@@ -64,5 +65,6 @@ int kvm_vm_ioctl_reinject(struct kvm *kvm, struct kvm_reinject_control *control)
 
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags);
 void kvm_free_pit(struct kvm *kvm);
+#endif /* CONFIG_KVM_IOAPIC */
 
 #endif
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index fb3bad0f4965..4c219e9f52b0 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -76,8 +76,10 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v)
 	if (!kvm_apic_accept_pic_intr(v))
 		return 0;
 
+#ifdef CONFIG_KVM_IOAPIC
 	if (pic_in_kernel(v->kvm))
 		return v->kvm->arch.vpic->output;
+#endif
 
 	WARN_ON_ONCE(!irqchip_split(v->kvm));
 	return pending_userspace_extint(v);
@@ -136,8 +138,10 @@ int kvm_cpu_get_extint(struct kvm_vcpu *v)
 		return v->kvm->arch.xen.upcall_vector;
 #endif
 
+#ifdef CONFIG_KVM_IOAPIC
 	if (pic_in_kernel(v->kvm))
 		return kvm_pic_read_irq(v->kvm); /* PIC */
+#endif
 
 	WARN_ON_ONCE(!irqchip_split(v->kvm));
 	return get_userspace_extint(v);
@@ -171,7 +175,9 @@ void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	__kvm_migrate_apic_timer(vcpu);
+#ifdef CONFIG_KVM_IOAPIC
 	__kvm_migrate_pit_timer(vcpu);
+#endif
 	kvm_x86_call(migrate_timers)(vcpu);
 }
 
@@ -187,6 +193,7 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
 	return irqchip_in_kernel(kvm);
 }
 
+#ifdef CONFIG_KVM_IOAPIC
 #define IOAPIC_ROUTING_ENTRY(irq) \
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
 	  .u.irqchip = { .irqchip = KVM_IRQCHIP_IOAPIC, .pin = (irq) } }
@@ -273,3 +280,4 @@ int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	kvm_pic_update_irq(pic);
 	return r;
 }
+#endif
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 7b8b54462f95..5e62c1f79ce6 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -18,6 +18,8 @@
 #include <kvm/iodev.h>
 #include "lapic.h"
 
+#ifdef CONFIG_KVM_IOAPIC
+
 #define PIC_NUM_PINS 16
 #define SELECT_PIC(irq) \
 	((irq) < 8 ? KVM_IRQCHIP_PIC_MASTER : KVM_IRQCHIP_PIC_SLAVE)
@@ -79,12 +81,19 @@ static inline int irqchip_full(struct kvm *kvm)
 	smp_rmb();
 	return mode == KVM_IRQCHIP_KERNEL;
 }
+#else /* CONFIG_KVM_IOAPIC */
+static __always_inline int irqchip_full(struct kvm *kvm)
+{
+	return false;
+}
+#endif
 
 static inline int pic_in_kernel(struct kvm *kvm)
 {
 	return irqchip_full(kvm);
 }
 
+
 static inline int irqchip_split(struct kvm *kvm)
 {
 	int mode = kvm->arch.irqchip_mode;
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 13d84c25e503..14fc8db0206c 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -208,6 +208,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 	 * check kvm_arch_can_set_irq_routing() before calling this function.
 	 */
 	switch (ue->type) {
+#ifdef CONFIG_KVM_IOAPIC
 	case KVM_IRQ_ROUTING_IRQCHIP:
 		if (irqchip_split(kvm))
 			return -EINVAL;
@@ -231,6 +232,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		}
 		e->irqchip.irqchip = ue->u.irqchip.irqchip;
 		break;
+#endif
 	case KVM_IRQ_ROUTING_MSI:
 		e->set = kvm_set_msi;
 		e->msi.address_lo = ue->u.msi.address_lo;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73418dc0ebb2..4cf8c1f753d3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1455,7 +1455,7 @@ static bool kvm_ioapic_handles_vector(struct kvm_lapic *apic, int vector)
 
 static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 {
-	int trigger_mode;
+	int __maybe_unused trigger_mode;
 
 	/* Eoi the ioapic only if the ioapic doesn't own the vector. */
 	if (!kvm_ioapic_handles_vector(apic, vector))
@@ -1476,12 +1476,14 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 		return;
 	}
 
+#ifdef CONFIG_KVM_IOAPIC
 	if (apic_test_vector(vector, apic->regs + APIC_TMR))
 		trigger_mode = IOAPIC_LEVEL_TRIG;
 	else
 		trigger_mode = IOAPIC_EDGE_TRIG;
 
 	kvm_ioapic_update_eoi(apic->vcpu, vector, trigger_mode);
+#endif
 }
 
 static int apic_set_eoi(struct kvm_lapic *apic)
@@ -3146,8 +3148,11 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 		kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
+
+#ifdef CONFIG_KVM_IOAPIC
 	if (ioapic_in_kernel(vcpu->kvm))
 		kvm_rtc_eoi_tracking_restore_one(vcpu);
+#endif
 
 	vcpu->arch.apic_arb_prio = 0;
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4ef17990574d..ababdba2c186 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -270,6 +270,7 @@ TRACE_EVENT(kvm_cpuid,
 	{0x6, "SIPI"},			\
 	{0x7, "ExtINT"}
 
+#ifdef CONFIG_KVM_IOAPIC
 TRACE_EVENT(kvm_ioapic_set_irq,
 	    TP_PROTO(__u64 e, int pin, bool coalesced),
 	    TP_ARGS(e, pin, coalesced),
@@ -314,6 +315,7 @@ TRACE_EVENT(kvm_ioapic_delayed_eoi_inj,
 		  (__entry->e & (1<<15)) ? "level" : "edge",
 		  (__entry->e & (1<<16)) ? "|masked" : "")
 );
+#endif
 
 TRACE_EVENT(kvm_msi_set_irq,
 	    TP_PROTO(__u64 address, __u64 data),
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 115405f496ef..a39babc32a6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4632,17 +4632,20 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXT_CPUID:
 	case KVM_CAP_EXT_EMUL_CPUID:
 	case KVM_CAP_CLOCKSOURCE:
+#ifdef CONFIG_KVM_IOAPIC
 	case KVM_CAP_PIT:
+	case KVM_CAP_PIT2:
+	case KVM_CAP_PIT_STATE2:
+	case KVM_CAP_REINJECT_CONTROL:
+#endif
 	case KVM_CAP_NOP_IO_DELAY:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_USER_NMI:
-	case KVM_CAP_REINJECT_CONTROL:
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_IOEVENTFD_NO_LENGTH:
-	case KVM_CAP_PIT2:
-	case KVM_CAP_PIT_STATE2:
+
 	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
 	case KVM_CAP_VCPU_EVENTS:
 #ifdef CONFIG_KVM_HYPERV
@@ -6937,9 +6940,11 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	struct kvm *kvm = filp->private_data;
 	void __user *argp = (void __user *)arg;
 	int r = -ENOTTY;
+
+#ifdef CONFIG_KVM_IOAPIC
 	/*
 	 * This union makes it completely explicit to gcc-3.x
-	 * that these two variables' stack usage should be
+	 * that these three variables' stack usage should be
 	 * combined, not added together.
 	 */
 	union {
@@ -6947,6 +6952,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		struct kvm_pit_state2 ps2;
 		struct kvm_pit_config pit_config;
 	} u;
+#endif
 
 	switch (ioctl) {
 	case KVM_SET_TSS_ADDR:
@@ -6970,6 +6976,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	case KVM_SET_NR_MMU_PAGES:
 		r = kvm_vm_ioctl_set_nr_mmu_pages(kvm, arg);
 		break;
+#ifdef CONFIG_KVM_IOAPIC
 	case KVM_CREATE_IRQCHIP: {
 		mutex_lock(&kvm->lock);
 
@@ -7136,6 +7143,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		r = kvm_vm_ioctl_reinject(kvm, &control);
 		break;
 	}
+#endif
 	case KVM_SET_BOOT_CPU_ID:
 		r = 0;
 		mutex_lock(&kvm->lock);
@@ -10595,8 +10603,10 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 
 	if (irqchip_split(vcpu->kvm))
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
+#ifdef CONFIG_KVM_IOAPIC
 	else if (ioapic_in_kernel(vcpu->kvm))
 		kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
+#endif
 
 	if (is_guest_mode(vcpu))
 		vcpu->arch.load_eoi_exitmap_pending = true;
@@ -12799,7 +12809,9 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
 
+#ifdef CONFIG_KVM_IOAPIC
 	kvm_free_pit(kvm);
+#endif
 
 	kvm_mmu_pre_destroy_vm(kvm);
 	static_call_cond(kvm_x86_vm_pre_destroy)(kvm);
@@ -12823,8 +12835,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 	kvm_destroy_vcpus(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
+#ifdef CONFIG_KVM_IOAPIC
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
+#endif
 	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4ff5ea29e343..3b5575d0b574 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1023,7 +1023,7 @@ void kvm_unlock_all_vcpus(struct kvm *kvm);
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
 
-#ifdef __KVM_HAVE_IOAPIC
+#ifdef CONFIG_KVM_IOAPIC
 void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm);
 #else
 static inline void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm)
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 96e581900c8e..1065a81ca57f 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -84,14 +84,14 @@ TRACE_EVENT(kvm_set_irq,
 );
 #endif /* defined(CONFIG_HAVE_KVM_IRQCHIP) */
 
-#if defined(__KVM_HAVE_IOAPIC)
+#ifdef CONFIG_KVM_IOAPIC
 
 #define kvm_irqchips						\
 	{KVM_IRQCHIP_PIC_MASTER,	"PIC master"},		\
 	{KVM_IRQCHIP_PIC_SLAVE,		"PIC slave"},		\
 	{KVM_IRQCHIP_IOAPIC,		"IOAPIC"}
 
-#endif /* defined(__KVM_HAVE_IOAPIC) */
+#endif /* CONFIG_KVM_IOAPIC */
 
 #if defined(CONFIG_HAVE_KVM_IRQCHIP)
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


