Return-Path: <kvm+bounces-47046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BBEABCB76
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 01:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A96A16489F
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2661223DC3;
	Mon, 19 May 2025 23:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EPtMed3y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50631223719
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 23:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697315; cv=none; b=LinojRIpTP63U83DFyjokb7r2Qg2QQUQg2IGImMvoSLwstkIXe5l5RWX95AGMcvQ8FQQJzIXuE6pbEJ5Xnq20bYdSds/s+nqO3qiLwN6waofeErKGt53lJgeU3v/1q86xaOyglHtbEA5RSKn9bNkHU9nQqGhKF1wUadCQbM8vVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697315; c=relaxed/simple;
	bh=A6Mvec40fXAU+3eNtc7h8WPXWVoHL67BNBfmgBmGALs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lPGTy7kcQJWBGYc3v4Ep06JfZVVz/9nET0j6y/l4SrBY6l1POdRw2AJ+Is8j/hnpDkR6mBVdVKSgOkgb0rtxFbz1ndBM2WH5tkx3F2EOUQ6WJFsaiH0tREYx6thfWaY8NwQuLXjf8bux3IlerQcGDjrmSLjcEdZhAAcByNN45s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EPtMed3y; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e38174e5so4763666a12.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747697312; x=1748302112; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XckvmjadgADiByTaHXoac+0phhb9MmWn/F+UFko6hq0=;
        b=EPtMed3yovLBXcGJsaa5njHETmVgREREMm1ciLIeQbAuvq59DbWPMLDpD4nz4B7fOS
         cnV0Ifv7zNIJvbG6dFIKiJxCAwJyF+kCN6GF4P7uJrYlT9nATPbjftvon1+FgP+fHKQj
         9+6q+r+l67A6rY6rtUGbPSI/jvovXTErzdh5dlLSEJYAbHJhxheUtwUHdSdNwoji5tpO
         /47N0k/MaP0cdZSZMFZW0fbbOSElr08Jp+VcV+rUwfIV3XG7xc9J+wTgmFgYP9x8oxAh
         X56BqlV/4BWaoAfq015x2oIJt8PTPW+dvSy5+kI8DJ0v1A8tmbF1Nd8QzWAwcdFJ4bK/
         Xw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747697312; x=1748302112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XckvmjadgADiByTaHXoac+0phhb9MmWn/F+UFko6hq0=;
        b=ZUjX7Be1zFTHPhRoQUPxtW3JM2FM0sHrMtnadfn/0plFfRuXcJ4hscrd70nxyKc0D7
         mFw3BpjSLIguiKoMMW1c9Ty7H4xvPo9L9VlHpiF5n/m8XDaWAM9lJpkZXvy3fsBqAt9c
         QO06TWBXlqBaIUWaVb0UjScJc/i5nWb0Gfh7ZoL8bgmgOJh/sjqeegSPmK/41kQHetdV
         6L6sMcPA8jFg9NFQBh8wbURInGkTeVLGVN1GuIX4XApYzsyeKReWDw7yMbIpemPC5RTI
         2e6h+dQZ5HLESd1NovvQ238TT7BqbljhdneI690JIQGhQMqo8cEzvvEx3peatvE1pVXw
         cP7A==
X-Gm-Message-State: AOJu0Yz2MpoL8IYaGoHkuj+SSRlQu3z2X24nvMRL7Xy+l52a3cD2p+B0
	/1gDSfyM2W7+4N6txh9PHn5T7V07jUlFkQRQYEwfUvKNCKILF5Asq/LyoVB+jY3taSZNEDSJLuW
	qZt9gsQ==
X-Google-Smtp-Source: AGHT+IH7nI10wVjZOjLkS5yo4985P4worGDmTWsv4AXMDEnXfYby+Cj2i/UWJk3TknKpQp9WnaJNOICMKAw=
X-Received: from pjbsn4.prod.google.com ([2002:a17:90b:2e84:b0:2fc:11a0:c549])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:100f:b0:215:fac3:2ce2
 with SMTP id adf61e73a8af0-2162192a9c8mr21422480637.23.1747697312715; Mon, 19
 May 2025 16:28:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 16:28:04 -0700
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519232808.2745331-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519232808.2745331-12-seanjc@google.com>
Subject: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a Kconfig to allowing building KVM without support for emulating an
I/O APIC, PIC, and PIT, which is desirable for deployments that effectively
don't support a fully in-kernel IRQ chip, i.e. never expect any VMM to
create an in-kernel I/O APIC.  E.g. compiling out support eliminates a few
thousand lines of guest-facing code and gives security folks warm fuzzies.

As a bonus, wrapping relevant paths with CONFIG_KVM_IOAPIC #ifdefs makes
it much easier for readers to understand which bits and pieces exist
specific for fully in-kernel IRQ chips.

Opportunistically convert all two in-kernel uses of __KVM_HAVE_IOAPIC to
CONFIG_KVM_IOAPIC, e.g. rather than add a second #ifdef to generate a stub
for kvm_arch_post_irq_routing_update().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/Kconfig            | 10 ++++++++++
 arch/x86/kvm/Makefile           |  5 +++--
 arch/x86/kvm/irq.c              |  6 ++++++
 arch/x86/kvm/irq_comm.c         |  2 ++
 arch/x86/kvm/lapic.c            |  7 ++++++-
 arch/x86/kvm/trace.h            |  2 ++
 arch/x86/kvm/x86.c              | 24 ++++++++++++++++++++----
 include/linux/kvm_host.h        |  2 +-
 include/trace/events/kvm.h      |  4 ++--
 10 files changed, 54 insertions(+), 10 deletions(-)

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
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b9b9df00ab77..a416ccddde5f 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -75,8 +75,10 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v)
 	if (!kvm_apic_accept_pic_intr(v))
 		return 0;
 
+#ifdef CONFIG_KVM_IOAPIC
 	if (pic_in_kernel(v->kvm))
 		return v->kvm->arch.vpic->output;
+#endif
 
 	WARN_ON_ONCE(!irqchip_split(v->kvm));
 	return pending_userspace_extint(v);
@@ -135,8 +137,10 @@ int kvm_cpu_get_extint(struct kvm_vcpu *v)
 		return v->kvm->arch.xen.upcall_vector;
 #endif
 
+#ifdef CONFIG_KVM_IOAPIC
 	if (pic_in_kernel(v->kvm))
 		return kvm_pic_read_irq(v->kvm); /* PIC */
+#endif
 
 	WARN_ON_ONCE(!irqchip_split(v->kvm));
 	return get_userspace_extint(v);
@@ -170,7 +174,9 @@ void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	__kvm_migrate_apic_timer(vcpu);
+#ifdef CONFIG_KVM_IOAPIC
 	__kvm_migrate_pit_timer(vcpu);
+#endif
 	kvm_x86_call(migrate_timers)(vcpu);
 }
 
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index adef53dc4fef..a4ef150fdd1c 100644
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
index 9e2c249d45ca..52eff4919d95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4630,17 +4630,20 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
@@ -6393,6 +6396,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	return 0;
 }
 
+#ifdef CONFIG_KVM_IOAPIC
 static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 {
 	struct kvm_pic *pic = kvm->arch.vpic;
@@ -6521,6 +6525,7 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 
 	return 0;
 }
+#endif /* CONFIG_KVM_IOAPIC */
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
@@ -7064,9 +7069,11 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
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
@@ -7074,6 +7081,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		struct kvm_pit_state2 ps2;
 		struct kvm_pit_config pit_config;
 	} u;
+#endif
 
 	switch (ioctl) {
 	case KVM_SET_TSS_ADDR:
@@ -7097,6 +7105,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	case KVM_SET_NR_MMU_PAGES:
 		r = kvm_vm_ioctl_set_nr_mmu_pages(kvm, arg);
 		break;
+#ifdef CONFIG_KVM_IOAPIC
 	case KVM_CREATE_IRQCHIP: {
 		mutex_lock(&kvm->lock);
 
@@ -7257,6 +7266,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		r = kvm_vm_ioctl_reinject(kvm, &control);
 		break;
 	}
+#endif
 	case KVM_SET_BOOT_CPU_ID:
 		r = 0;
 		mutex_lock(&kvm->lock);
@@ -10716,8 +10726,10 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 
 	if (irqchip_split(vcpu->kvm))
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
+#ifdef CONFIG_KVM_IOAPIC
 	else if (ioapic_in_kernel(vcpu->kvm))
 		kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
+#endif
 
 	if (is_guest_mode(vcpu))
 		vcpu->arch.load_eoi_exitmap_pending = true;
@@ -12920,7 +12932,9 @@ void kvm_arch_pre_destroy_vm(struct kvm *kvm)
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
 
+#ifdef CONFIG_KVM_IOAPIC
 	kvm_free_pit(kvm);
+#endif
 
 	kvm_mmu_pre_destroy_vm(kvm);
 	static_call_cond(kvm_x86_vm_pre_destroy)(kvm);
@@ -12944,8 +12958,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
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
index 44b439c5fcf4..0e151db44ecd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1019,7 +1019,7 @@ void kvm_destroy_vcpus(struct kvm *kvm);
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
2.49.0.1101.gccaa498523-goog


