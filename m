Return-Path: <kvm+bounces-1155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38EC07E54DE
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:18:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AE231C20DBE
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821A3171B9;
	Wed,  8 Nov 2023 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="UD8ea73X"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B75D16429;
	Wed,  8 Nov 2023 11:18:38 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883921BD8;
	Wed,  8 Nov 2023 03:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442318; x=1730978318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S0vg453WVyLXU8F3J/4ltfll9IYzPE7UP39ZvRkTsE0=;
  b=UD8ea73Xzy/ZISUJsDmyzeYbm6jPHWFJiSf6gYE6ahEt2jUNt3AM5UPd
   Sn74+de783X/vxdRS3qR2RLRrnLMeWxsgXoqlriXMCvvttJFBS27wzX/a
   ZBzAUGDqeLYVigpXSl+Ko5djfyY6rT8956P1rIvnyeNwE0b6UsVpUuvE0
   4=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="366811567"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1197e3af.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:18:33 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2a-m6i4x-1197e3af.us-west-2.amazon.com (Postfix) with ESMTPS id DD42C100386;
	Wed,  8 Nov 2023 11:18:31 +0000 (UTC)
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:6644]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.22.222:2525] with esmtp (Farcaster)
 id 87b998a2-b394-4602-b733-977feede779e; Wed, 8 Nov 2023 11:18:30 +0000 (UTC)
X-Farcaster-Flow-ID: 87b998a2-b394-4602-b733-977feede779e
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:30 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:25 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Anel Orazgaliyeva <anelkz@amazon.de>, "Nicolas
 Saenz Julienne" <nsaenz@amazon.com>
Subject: [RFC 02/33] KVM: x86: Introduce KVM_CAP_APIC_ID_GROUPS
Date: Wed, 8 Nov 2023 11:17:35 +0000
Message-ID: <20231108111806.92604-3-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

From: Anel Orazgaliyeva <anelkz@amazon.de>

Introduce KVM_CAP_APIC_ID_GROUPS, this capability segments the VM's APIC
ids into two. The lower bits, the physical APIC id, represent the part
that's exposed to the guest. The higher bits, which are private to KVM,
groups APICs together. APICs in different groups are isolated from each
other, and IPIs can only be directed at APICs that share the same group
as its source. Furthermore, groups are only relevant to IPIs, anything
incoming from outside the local APIC complex: from the IOAPIC, MSIs, or
PV-IPIs is targeted at the default APIC group, group 0.

When routing IPIs with physical destinations, KVM will OR the source's
vCPU APIC group with the ICR's destination ID and use that to resolve
the target lAPIC. The APIC physical map is also made group aware in
order to speed up this process. For the sake of simplicity, the logical
map is not built while KVM_CAP_APIC_ID_GROUPS is in use and we defer IPI
routing to the slower per-vCPU scan method.

This capability serves as a building block to implement virtualisation
based security features like Hyper-V's Virtual Secure Mode (VSM). VSM
introduces a para-virtualised switch that allows for guest CPUs to jump
into a different execution context, this switches into a different CPU
state, lAPIC state, and memory protections. We model this in KVM by
using distinct kvm_vcpus for each context. Moreover, execution contexts
are hierarchical and its APICs are meant to remain functional even when
the context isn't 'scheduled in'. For example, we have to keep track of
timers' expirations, and interrupt execution of lesser priority contexts
when relevant. Hence the need to alias physical APIC ids, while keeping
the ability to target specific execution contexts.

Signed-off-by: Anel Orazgaliyeva <anelkz@amazon.de>
Co-developed-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/include/uapi/asm/kvm.h |  5 +++
 arch/x86/kvm/lapic.c            | 59 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/lapic.h            | 33 ++++++++++++++++++
 arch/x86/kvm/x86.c              | 15 +++++++++
 include/uapi/linux/kvm.h        |  2 ++
 6 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dff10051e9b6..a2f224f95404 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1298,6 +1298,9 @@ struct kvm_arch {
 	struct rw_semaphore apicv_update_lock;
 	unsigned long apicv_inhibit_reasons;
 
+	u32 apic_id_group_mask;
+	u8 apic_id_group_shift;
+
 	gpa_t wall_clock;
 
 	bool mwait_in_guest;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a448d0964fc0..f73d137784d7 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -565,4 +565,9 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
 
+/* for KVM_SET_APIC_ID_GROUPS */
+struct kvm_apic_id_groups {
+	__u8 n_bits; /* nr of bits used to represent group in the APIC ID */
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3e977dbbf993..f55d216cb2a0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -141,7 +141,7 @@ static inline int apic_enabled(struct kvm_lapic *apic)
 
 static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 {
-	return apic->vcpu->vcpu_id;
+	return kvm_apic_id(apic->vcpu);
 }
 
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
@@ -219,8 +219,8 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
 				    bool *xapic_id_mismatch)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 x2apic_id = kvm_x2apic_id(apic);
-	u32 xapic_id = kvm_xapic_id(apic);
+	u32 x2apic_id = kvm_apic_id_and_group(vcpu);
+	u32 xapic_id = kvm_apic_id_and_group(vcpu);
 	u32 physical_id;
 
 	/*
@@ -299,6 +299,13 @@ static void kvm_recalculate_logical_map(struct kvm_apic_map *new,
 	u16 mask;
 	u32 ldr;
 
+	/*
+	 * Using maps for logical destinations when KVM_CAP_APIC_ID_GRUPS is in
+	 * use isn't supported.
+	 */
+	if (kvm_apic_group(vcpu))
+		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
+
 	if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
 		return;
 
@@ -370,6 +377,25 @@ enum {
 	DIRTY
 };
 
+int kvm_vm_ioctl_set_apic_id_groups(struct kvm *kvm,
+				    struct kvm_apic_id_groups *groups)
+{
+	u8 n_bits = groups->n_bits;
+
+	if (n_bits > 32)
+		return -EINVAL;
+
+	kvm->arch.apic_id_group_mask = n_bits ? GENMASK(31, 32 - n_bits): 0;
+	/*
+	 * Bitshifts >= than the width of the type are UD, so set the
+	 * apic group shift to 0 when n_bits == 0. The group mask above will
+	 * clear the APIC ID, so group querying functions will return the
+	 * correct value.
+	 */
+	kvm->arch.apic_id_group_shift = n_bits ? 32 - n_bits : 0;
+	return 0;
+}
+
 void kvm_recalculate_apic_map(struct kvm *kvm)
 {
 	struct kvm_apic_map *new, *old = NULL;
@@ -414,7 +440,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		if (kvm_apic_present(vcpu))
-			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
+			max_id = max(max_id, kvm_apic_id_and_group(vcpu));
 
 	new = kvzalloc(sizeof(struct kvm_apic_map) +
 	                   sizeof(struct kvm_lapic *) * ((u64)max_id + 1),
@@ -525,7 +551,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
 {
 	u32 ldr = kvm_apic_calc_x2apic_ldr(id);
 
-	WARN_ON_ONCE(id != apic->vcpu->vcpu_id);
+	WARN_ON_ONCE(id != kvm_apic_id(apic->vcpu));
 
 	kvm_lapic_set_reg(apic, APIC_ID, id);
 	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
@@ -1067,6 +1093,17 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 	struct kvm_lapic *target = vcpu->arch.apic;
 	u32 mda = kvm_apic_mda(vcpu, dest, source, target);
 
+	/*
+	 * Make sure vCPUs belong to the same APIC group, it's not possible
+	 * to send interrupts across groups.
+	 *
+	 * Non-IPIs and PV-IPIs can only be injected into the default APIC
+	 * group (group 0).
+	 */
+	if ((source && !kvm_match_apic_group(source->vcpu, vcpu)) ||
+	    kvm_apic_group(vcpu))
+		return false;
+
 	ASSERT(target);
 	switch (shorthand) {
 	case APIC_DEST_NOSHORT:
@@ -1518,6 +1555,10 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 	else
 		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
 
+	if (irq.dest_mode == APIC_DEST_PHYSICAL)
+		kvm_apic_id_set_group(apic->vcpu->kvm,
+				      kvm_apic_group(apic->vcpu), &irq.dest_id);
+
 	trace_kvm_apic_ipi(icr_low, irq.dest_id);
 
 	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
@@ -2541,7 +2582,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	/* update jump label if enable bit changes */
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
 		if (value & MSR_IA32_APICBASE_ENABLE) {
-			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
+			kvm_apic_set_xapic_id(apic, kvm_apic_id(vcpu));
 			static_branch_slow_dec_deferred(&apic_hw_disabled);
 			/* Check if there are APF page ready requests pending */
 			kvm_make_request(KVM_REQ_APF_READY, vcpu);
@@ -2553,9 +2594,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 
 	if ((old_value ^ value) & X2APIC_ENABLE) {
 		if (value & X2APIC_ENABLE)
-			kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
+			kvm_apic_set_x2apic_id(apic, kvm_apic_id(vcpu));
 		else if (value & MSR_IA32_APICBASE_ENABLE)
-			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
+			kvm_apic_set_xapic_id(apic, kvm_apic_id(vcpu));
 	}
 
 	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
@@ -2685,7 +2726,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	/* The xAPIC ID is set at RESET even if the APIC was already enabled. */
 	if (!init_event)
-		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
+		kvm_apic_set_xapic_id(apic, kvm_apic_id(vcpu));
 	kvm_apic_set_version(apic->vcpu);
 
 	for (i = 0; i < apic->nr_lvt_entries; i++)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index e1021517cf04..542bd208e52b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -97,6 +97,8 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
+int kvm_vm_ioctl_set_apic_id_groups(struct kvm *kvm,
+				    struct kvm_apic_id_groups *groups);
 void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
@@ -277,4 +279,35 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
 
+static inline u32 kvm_apic_id(struct kvm_vcpu *vcpu)
+{
+	return vcpu->vcpu_id & ~vcpu->kvm->arch.apic_id_group_mask;
+}
+
+static inline u32 kvm_apic_id_and_group(struct kvm_vcpu *vcpu)
+{
+	return vcpu->vcpu_id;
+}
+
+static inline u32 kvm_apic_group(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	return (vcpu->vcpu_id & kvm->arch.apic_id_group_mask) >>
+	       kvm->arch.apic_id_group_shift;
+}
+
+static inline void kvm_apic_id_set_group(struct kvm *kvm, u32 group,
+					 u32 *apic_id)
+{
+	*apic_id |= ((group << kvm->arch.apic_id_group_shift) &
+		     kvm->arch.apic_id_group_mask);
+}
+
+static inline bool kvm_match_apic_group(struct kvm_vcpu *src,
+					struct kvm_vcpu *dst)
+{
+	return kvm_apic_group(src) == kvm_apic_group(dst);
+}
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3eb608b6692..4cd3f00475c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4526,6 +4526,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_APIC_ID_GROUPS:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -7112,6 +7113,20 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
 		break;
 	}
+	case KVM_SET_APIC_ID_GROUPS: {
+		struct kvm_apic_id_groups groups;
+
+		r = -EINVAL;
+		if (kvm->created_vcpus)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_from_user(&groups, argp, sizeof(groups)))
+			goto out;
+
+		r = kvm_vm_ioctl_set_apic_id_groups(kvm, &groups);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5b5820d19e71..d7a01766bf21 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1219,6 +1219,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_MEMORY_ATTRIBUTES 232
 #define KVM_CAP_GUEST_MEMFD 233
 #define KVM_CAP_VM_TYPES 234
+#define KVM_CAP_APIC_ID_GROUPS 235
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2307,4 +2308,5 @@ struct kvm_create_guest_memfd {
 
 #define KVM_GUEST_MEMFD_ALLOW_HUGEPAGE		(1ULL << 0)
 
+#define KVM_SET_APIC_ID_GROUPS _IOW(KVMIO, 0xd7, struct kvm_apic_id_groups)
 #endif /* __LINUX_KVM_H */
-- 
2.40.1


