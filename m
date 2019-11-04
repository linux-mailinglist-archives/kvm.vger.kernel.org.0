Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF21EF0E2
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfKDXAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:00:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34818 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730051AbfKDXAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 18:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gW2uKgwJ4LMfekpzPKNWIoZS/0JN+Tt7uJyOZKsGKLE=;
        b=UvZu9rm3S4fwmEGB9ERA2LB0GlHdluFC15d5s/Wq6fRxx7D/Nh7V7qHp2c0YbnLMI/uwL4
        ukBgxg/CBQ+43P66HW/YCVCOkZ68BWGNyFmHqr4nRE48+T3PwnWglM9NfPhSBH7EnZeHBF
        Kbr1Ys2uL9P+jCc65hKVQNfriPg0pB4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-VZSdoRuqNqaKWs8hM6ms4A-1; Mon, 04 Nov 2019 18:00:11 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E0021005502;
        Mon,  4 Nov 2019 23:00:10 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 091AD100164D;
        Mon,  4 Nov 2019 23:00:08 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 08/13] KVM: monolithic: remove exports
Date:   Mon,  4 Nov 2019 17:59:56 -0500
Message-Id: <20191104230001.27774-9-aarcange@redhat.com>
In-Reply-To: <20191104230001.27774-1-aarcange@redhat.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: VZSdoRuqNqaKWs8hM6ms4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The exports would be duplicated across kvm-amd and kvm-intel if
they're kept and that causes various harmless warnings.

The warnings aren't particularly concerning because the two modules
can't load at the same time, but it's cleaner to remove the warnings
by removing the exports.

This commit might break non-x86 archs, but it should be simple to make
them monolithic too (if they're not already).

In the unlikely case there's a legit reason not to go monolithic in
any arch and to keep kvm.ko around, we'll need a way to retain the
common code exports. In which case this commit would need to be
partially reversed and the exports in the kvm common code should then
be done only conditionally to a new opt-in per-arch CONFIG option.

The following warning remains for now to be able to load the kvmgt and
the powerpc version. These remaining warnings can be handled later.

WARNING: arch/x86/kvm/kvm-amd: 'kvm_debugfs_dir' exported twice. Previous e=
xport was in arch/x86/kvm/kvm-intel.ko

This is needed by powerpc.

WARNING: arch/x86/kvm/kvm-amd: 'kvm_get_kvm' exported twice. Previous expor=
t was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'kvm_put_kvm' exported twice. Previous expor=
t was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'gfn_to_memslot' exported twice. Previous ex=
port was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'kvm_is_visible_gfn' exported twice. Previou=
s export was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'gfn_to_pfn' exported twice. Previous export=
 was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'kvm_read_guest' exported twice. Previous ex=
port was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'kvm_write_guest' exported twice. Previous e=
xport was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'kvm_slot_page_track_add_page' exported twic=
e. Previous export was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'kvm_slot_page_track_remove_page' exported t=
wice. Previous export was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'kvm_page_track_register_notifier' exported =
twice. Previous export was in arch/x86/kvm/kvm-intel.ko
WARNING: arch/x86/kvm/kvm-amd: 'kvm_page_track_unregister_notifier' exporte=
d twice. Previous export was in arch/x86/kvm/kvm-intel.ko

This is needed by kvmgt.c.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/kvm/cpuid.c    |   5 --
 arch/x86/kvm/hyperv.c   |   2 -
 arch/x86/kvm/irq.c      |   4 --
 arch/x86/kvm/irq_comm.c |   2 -
 arch/x86/kvm/lapic.c    |  16 ------
 arch/x86/kvm/mmu.c      |  24 ---------
 arch/x86/kvm/mtrr.c     |   2 -
 arch/x86/kvm/pmu.c      |   3 --
 arch/x86/kvm/x86.c      | 106 ----------------------------------------
 virt/kvm/eventfd.c      |   1 -
 virt/kvm/kvm_main.c     |  64 ------------------------
 11 files changed, 229 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d156d27d83bb..661e68a53e2b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -50,7 +50,6 @@ bool kvm_mpx_supported(void)
 =09return ((host_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR))
 =09=09 && kvm_x86_mpx_supported());
 }
-EXPORT_SYMBOL_GPL(kvm_mpx_supported);
=20
 u64 kvm_supported_xcr0(void)
 {
@@ -192,7 +191,6 @@ int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
 not_found:
 =09return 36;
 }
-EXPORT_SYMBOL_GPL(cpuid_query_maxphyaddr);
=20
 /* when an old userspace process fills a new kernel module */
 int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
@@ -971,7 +969,6 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kv=
m_vcpu *vcpu,
 =09}
 =09return best;
 }
-EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
=20
 /*
  * If the basic or extended CPUID leaf requested is higher than the
@@ -1035,7 +1032,6 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *=
ebx,
 =09trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
 =09return found;
 }
-EXPORT_SYMBOL_GPL(kvm_cpuid);
=20
 int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 {
@@ -1053,4 +1049,3 @@ int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 =09kvm_rdx_write(vcpu, edx);
 =09return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_cpuid);
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a345e48a7a24..bf0c86fdee52 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -714,7 +714,6 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
 =09=09return false;
 =09return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
-EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
=20
 bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
 =09=09=09    struct hv_vp_assist_page *assist_page)
@@ -724,7 +723,6 @@ bool kvm_hv_get_assist_page(struct kvm_vcpu *vcpu,
 =09return !kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_eoi.data,
 =09=09=09=09      assist_page, sizeof(*assist_page));
 }
-EXPORT_SYMBOL_GPL(kvm_hv_get_assist_page);
=20
 static void stimer_prepare_msg(struct kvm_vcpu_hv_stimer *stimer)
 {
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index e330e7d125f7..ba4300f36a32 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -26,7 +26,6 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
=20
 =09return 0;
 }
-EXPORT_SYMBOL(kvm_cpu_has_pending_timer);
=20
 /*
  * check if there is a pending userspace external interrupt
@@ -109,7 +108,6 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
=20
 =09return kvm_apic_has_interrupt(v) !=3D -1;=09/* LAPIC */
 }
-EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
=20
 /*
  * Read pending interrupt(from non-APIC source)
@@ -146,14 +144,12 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
=20
 =09return kvm_get_apic_interrupt(v);=09/* APIC */
 }
-EXPORT_SYMBOL_GPL(kvm_cpu_get_interrupt);
=20
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 {
 =09if (lapic_in_kernel(vcpu))
 =09=09kvm_inject_apic_timer_irqs(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_pending_timer_irqs);
=20
 void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8ecd48d31800..64a13d5fcc9f 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -122,7 +122,6 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel=
_irq_routing_entry *e,
 =09irq->level =3D 1;
 =09irq->shorthand =3D 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
=20
 static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 =09=09struct kvm_kernel_irq_routing_entry *e)
@@ -346,7 +345,6 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kv=
m_lapic_irq *irq,
=20
 =09return r =3D=3D 1;
 }
-EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);
=20
 #define IOAPIC_ROUTING_ENTRY(irq) \
 =09{ .gsi =3D irq, .type =3D KVM_IRQ_ROUTING_IRQCHIP,=09\
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 22c1079fadaa..55d58bb2954a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -120,7 +120,6 @@ bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu=
)
 {
 =09return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_can_post_timer_interrupt);
=20
 static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
 {
@@ -410,7 +409,6 @@ bool __kvm_apic_update_irr(u32 *pir, void *regs, int *m=
ax_irr)
 =09return ((max_updated_irr !=3D -1) &&
 =09=09(max_updated_irr =3D=3D *max_irr));
 }
-EXPORT_SYMBOL_GPL(__kvm_apic_update_irr);
=20
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr)
 {
@@ -418,7 +416,6 @@ bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pi=
r, int *max_irr)
=20
 =09return __kvm_apic_update_irr(pir, apic->regs, max_irr);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_update_irr);
=20
 static inline int apic_search_irr(struct kvm_lapic *apic)
 {
@@ -542,7 +539,6 @@ int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 =09 */
 =09return apic_find_highest_irr(vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_find_highest_irr);
=20
 static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 =09=09=09     int vector, int level, int trig_mode,
@@ -710,7 +706,6 @@ void kvm_apic_update_ppr(struct kvm_vcpu *vcpu)
 {
 =09apic_update_ppr(vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_update_ppr);
=20
 static void apic_set_tpr(struct kvm_lapic *apic, u32 tpr)
 {
@@ -821,7 +816,6 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct =
kvm_lapic *source,
 =09=09return false;
 =09}
 }
-EXPORT_SYMBOL_GPL(kvm_apic_match_dest);
=20
 int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
 =09=09       const unsigned long *bitmap, u32 bitmap_size)
@@ -1194,7 +1188,6 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vc=
pu, int vector)
 =09kvm_ioapic_send_eoi(apic, vector);
 =09kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
=20
 static void apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_hig=
h)
 {
@@ -1353,7 +1346,6 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 of=
fset, int len,
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_reg_read);
=20
 static int apic_mmio_in_range(struct kvm_lapic *apic, gpa_t addr)
 {
@@ -1530,7 +1522,6 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 =09if (lapic_timer_int_injected(vcpu))
 =09=09__kvm_wait_lapic_expire(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
=20
 static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
 {
@@ -1695,7 +1686,6 @@ bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
=20
 =09return vcpu->arch.apic->lapic_timer.hv_timer_in_use;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_hv_timer_in_use);
=20
 static void cancel_hv_timer(struct kvm_lapic *apic)
 {
@@ -1796,13 +1786,11 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vc=
pu)
 out:
 =09preempt_enable();
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_expired_hv_timer);
=20
 void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu)
 {
 =09restart_apic_timer(vcpu->arch.apic);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_switch_to_hv_timer);
=20
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu)
 {
@@ -1814,7 +1802,6 @@ void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vc=
pu)
 =09=09start_sw_timer(apic);
 =09preempt_enable();
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_switch_to_sw_timer);
=20
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu)
 {
@@ -1984,7 +1971,6 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 r=
eg, u32 val)
=20
 =09return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_reg_write);
=20
 static int apic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *th=
is,
 =09=09=09    gpa_t address, int len, const void *data)
@@ -2023,7 +2009,6 @@ void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu)
 {
 =09kvm_lapic_reg_write(vcpu->arch.apic, APIC_EOI, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
=20
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
@@ -2038,7 +2023,6 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u=
32 offset)
 =09/* TODO: optimize to just emulate side effect w/o one more write */
 =09kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
 }
-EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
=20
 void kvm_free_lapic(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 29d930470db9..9467eac7dc4d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -317,7 +317,6 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio=
_value, u64 access_mask)
 =09shadow_mmio_mask =3D mmio_mask | SPTE_SPECIAL_MASK;
 =09shadow_mmio_access_mask =3D access_mask;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
=20
 static bool is_mmio_spte(u64 spte)
 {
@@ -498,7 +497,6 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_=
mask,
 =09shadow_acc_track_mask =3D acc_track_mask;
 =09shadow_me_mask =3D me_mask;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
=20
 static u8 kvm_get_shadow_phys_bits(void)
 {
@@ -1731,7 +1729,6 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 =09=09mask &=3D mask - 1;
 =09}
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_clear_dirty_pt_masked);
=20
 /**
  * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for sele=
cted
@@ -2888,7 +2885,6 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn=
)
=20
 =09return r;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page);
=20
 static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp=
)
 {
@@ -3658,7 +3654,6 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct=
 kvm_mmu *mmu,
 =09kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 =09spin_unlock(&vcpu->kvm->mmu_lock);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_free_roots);
=20
 static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
 {
@@ -3883,7 +3878,6 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 =09kvm_mmu_audit(vcpu, AUDIT_POST_SYNC);
 =09spin_unlock(&vcpu->kvm->mmu_lock);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_sync_roots);
=20
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 =09=09=09=09  u32 access, struct x86_exception *exception)
@@ -4151,7 +4145,6 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 =
error_code,
 =09}
 =09return r;
 }
-EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
=20
 static bool
 check_hugepage_cache_consistency(struct kvm_vcpu *vcpu, gfn_t gfn, int lev=
el)
@@ -4331,7 +4324,6 @@ void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new=
_cr3, bool skip_tlb_flush)
 =09__kvm_mmu_new_cr3(vcpu, new_cr3, kvm_mmu_calc_root_page_role(vcpu),
 =09=09=09  skip_tlb_flush);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_new_cr3);
=20
 static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 {
@@ -4571,7 +4563,6 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, st=
ruct kvm_mmu *context)
 =09}
=20
 }
-EXPORT_SYMBOL_GPL(reset_shadow_zero_bits_mask);
=20
 static inline bool boot_cpu_is_amd(void)
 {
@@ -4991,7 +4982,6 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
 =09context->mmu_role.as_u64 =3D new_role.as_u64;
 =09reset_shadow_zero_bits_mask(vcpu, context);
 }
-EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
=20
 static union kvm_mmu_role
 kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_di=
rty,
@@ -5055,7 +5045,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, b=
ool execonly,
 =09reset_rsvds_bits_mask_ept(vcpu, context, execonly);
 =09reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
 }
-EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
=20
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
@@ -5135,7 +5124,6 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_r=
oots)
 =09else
 =09=09init_kvm_softmmu(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_init_mmu);
=20
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
@@ -5155,7 +5143,6 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 =09kvm_mmu_unload(vcpu);
 =09kvm_init_mmu(vcpu, true);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
=20
 int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
@@ -5173,7 +5160,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 =09return r;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_load);
=20
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
@@ -5182,7 +5168,6 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 =09kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
 =09WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_unload);
=20
 static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
 =09=09=09=09  struct kvm_mmu_page *sp, u64 *spte,
@@ -5394,7 +5379,6 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu=
, gva_t gva)
=20
 =09return r;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
=20
 static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
 {
@@ -5489,7 +5473,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t c=
r2, u64 error_code,
 =09return x86_emulate_instruction(vcpu, cr2, emulation_type, insn,
 =09=09=09=09       insn_len);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
=20
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
@@ -5520,7 +5503,6 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 =09kvm_x86_tlb_flush_gva(vcpu, gva);
 =09++vcpu->stat.invlpg;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
=20
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long p=
cid)
 {
@@ -5552,19 +5534,16 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva=
_t gva, unsigned long pcid)
 =09 * for them.
 =09 */
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_invpcid_gva);
=20
 void kvm_enable_tdp(void)
 {
 =09tdp_enabled =3D true;
 }
-EXPORT_SYMBOL_GPL(kvm_enable_tdp);
=20
 void kvm_disable_tdp(void)
 {
 =09tdp_enabled =3D false;
 }
-EXPORT_SYMBOL_GPL(kvm_disable_tdp);
=20
=20
 /* The return value indicates if tlb flush on all vcpus is needed. */
@@ -5963,7 +5942,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 =09=09kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
 =09=09=09=09memslot->npages);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_slot_leaf_clear_dirty);
=20
 void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 =09=09=09=09=09struct kvm_memory_slot *memslot)
@@ -5982,7 +5960,6 @@ void kvm_mmu_slot_largepage_remove_write_access(struc=
t kvm *kvm,
 =09=09kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
 =09=09=09=09memslot->npages);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_slot_largepage_remove_write_access);
=20
 void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 =09=09=09    struct kvm_memory_slot *memslot)
@@ -6000,7 +5977,6 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 =09=09kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
 =09=09=09=09memslot->npages);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
=20
 void kvm_mmu_zap_all(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 25ce3edd1872..477f7141f793 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -91,7 +91,6 @@ bool kvm_mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 d=
ata)
=20
 =09return true;
 }
-EXPORT_SYMBOL_GPL(kvm_mtrr_valid);
=20
 static bool mtrr_is_enabled(struct kvm_mtrr *mtrr_state)
 {
@@ -686,7 +685,6 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu=
, gfn_t gfn)
=20
 =09return type;
 }
-EXPORT_SYMBOL_GPL(kvm_mtrr_get_guest_memory_type);
=20
 bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn=
,
 =09=09=09=09=09  int page_num)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 144e5d0c25ff..0ac70bad4b31 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -200,7 +200,6 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 even=
tsel)
 =09=09=09      (eventsel & HSW_IN_TX),
 =09=09=09      (eventsel & HSW_IN_TX_CHECKPOINTED));
 }
-EXPORT_SYMBOL_GPL(reprogram_gp_counter);
=20
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 {
@@ -230,7 +229,6 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ct=
rl, int idx)
 =09=09=09      !(en_field & 0x1), /* exclude kernel */
 =09=09=09      pmi, false, false);
 }
-EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
=20
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
 {
@@ -248,7 +246,6 @@ void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx=
)
 =09=09reprogram_fixed_counter(pmc, ctrl, idx);
 =09}
 }
-EXPORT_SYMBOL_GPL(reprogram_counter);
=20
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e98fa6b7bf8..799c069a2296 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -76,7 +76,6 @@
 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
 u64 __read_mostly kvm_mce_cap_supported =3D MCG_CTL_P | MCG_SER_P;
-EXPORT_SYMBOL_GPL(kvm_mce_cap_supported);
=20
 #define emul_to_vcpu(ctxt) \
 =09container_of(ctxt, struct kvm_vcpu, arch.emulate_ctxt)
@@ -106,7 +105,6 @@ static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
=20
 struct kvm_x86_ops *kvm_x86_ops __read_mostly;
-EXPORT_SYMBOL_GPL(kvm_x86_ops);
=20
 static bool __read_mostly ignore_msrs =3D 0;
 module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
@@ -121,15 +119,10 @@ static bool __read_mostly kvmclock_periodic_sync =3D =
true;
 module_param(kvmclock_periodic_sync, bool, S_IRUGO);
=20
 bool __read_mostly kvm_has_tsc_control;
-EXPORT_SYMBOL_GPL(kvm_has_tsc_control);
 u32  __read_mostly kvm_max_guest_tsc_khz;
-EXPORT_SYMBOL_GPL(kvm_max_guest_tsc_khz);
 u8   __read_mostly kvm_tsc_scaling_ratio_frac_bits;
-EXPORT_SYMBOL_GPL(kvm_tsc_scaling_ratio_frac_bits);
 u64  __read_mostly kvm_max_tsc_scaling_ratio;
-EXPORT_SYMBOL_GPL(kvm_max_tsc_scaling_ratio);
 u64 __read_mostly kvm_default_tsc_scaling_ratio;
-EXPORT_SYMBOL_GPL(kvm_default_tsc_scaling_ratio);
=20
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshol=
d */
 static u32 __read_mostly tsc_tolerance_ppm =3D 250;
@@ -149,7 +142,6 @@ module_param(vector_hashing, bool, S_IRUGO);
=20
 bool __read_mostly enable_vmware_backdoor =3D false;
 module_param(enable_vmware_backdoor, bool, S_IRUGO);
-EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
=20
 static bool __read_mostly force_emulation_prefix =3D false;
 module_param(force_emulation_prefix, bool, S_IRUGO);
@@ -221,7 +213,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D {
 u64 __read_mostly host_xcr0;
=20
 struct kmem_cache *x86_fpu_cache;
-EXPORT_SYMBOL_GPL(x86_fpu_cache);
=20
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
=20
@@ -283,7 +274,6 @@ void kvm_define_shared_msr(unsigned slot, u32 msr)
 =09if (slot >=3D shared_msrs_global.nr)
 =09=09shared_msrs_global.nr =3D slot + 1;
 }
-EXPORT_SYMBOL_GPL(kvm_define_shared_msr);
=20
 static void kvm_shared_msr_cpu_online(void)
 {
@@ -313,7 +303,6 @@ int kvm_set_shared_msr(unsigned slot, u64 value, u64 ma=
sk)
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_shared_msr);
=20
 static void drop_user_return_notifiers(void)
 {
@@ -328,13 +317,11 @@ u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
 {
 =09return vcpu->arch.apic_base;
 }
-EXPORT_SYMBOL_GPL(kvm_get_apic_base);
=20
 enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
 {
 =09return kvm_apic_mode(kvm_get_apic_base(vcpu));
 }
-EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
=20
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
@@ -355,14 +342,12 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct m=
sr_data *msr_info)
 =09kvm_lapic_set_base(vcpu, msr_info->data);
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_apic_base);
=20
 asmlinkage __visible void kvm_spurious_fault(void)
 {
 =09/* Fault while not rebooting.  We want the trace. */
 =09BUG_ON(!kvm_rebooting);
 }
-EXPORT_SYMBOL_GPL(kvm_spurious_fault);
=20
 #define EXCPT_BENIGN=09=090
 #define EXCPT_CONTRIBUTORY=091
@@ -450,7 +435,6 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcp=
u)
 =09vcpu->arch.exception.has_payload =3D false;
 =09vcpu->arch.exception.payload =3D 0;
 }
-EXPORT_SYMBOL_GPL(kvm_deliver_exception_payload);
=20
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 =09=09unsigned nr, bool has_error, u32 error_code,
@@ -544,13 +528,11 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsig=
ned nr)
 {
 =09kvm_multiple_exception(vcpu, nr, false, 0, false, 0, false);
 }
-EXPORT_SYMBOL_GPL(kvm_queue_exception);
=20
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
 =09kvm_multiple_exception(vcpu, nr, false, 0, false, 0, true);
 }
-EXPORT_SYMBOL_GPL(kvm_requeue_exception);
=20
 static void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr,
 =09=09=09=09  unsigned long payload)
@@ -574,7 +556,6 @@ int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err=
)
=20
 =09return 1;
 }
-EXPORT_SYMBOL_GPL(kvm_complete_insn_gp);
=20
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fa=
ult)
 {
@@ -589,7 +570,6 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struc=
t x86_exception *fault)
 =09=09=09=09=09fault->address);
 =09}
 }
-EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
=20
 static bool kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exceptio=
n *fault)
 {
@@ -606,19 +586,16 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 =09atomic_inc(&vcpu->arch.nmi_queued);
 =09kvm_make_request(KVM_REQ_NMI, vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_inject_nmi);
=20
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_c=
ode)
 {
 =09kvm_multiple_exception(vcpu, nr, true, error_code, false, 0, false);
 }
-EXPORT_SYMBOL_GPL(kvm_queue_exception_e);
=20
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error=
_code)
 {
 =09kvm_multiple_exception(vcpu, nr, true, error_code, false, 0, true);
 }
-EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
=20
 /*
  * Checks if cpl <=3D required_cpl; if true, return true.  Otherwise queue
@@ -631,7 +608,6 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int require=
d_cpl)
 =09kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 =09return false;
 }
-EXPORT_SYMBOL_GPL(kvm_require_cpl);
=20
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr)
 {
@@ -641,7 +617,6 @@ bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr)
 =09kvm_queue_exception(vcpu, UD_VECTOR);
 =09return false;
 }
-EXPORT_SYMBOL_GPL(kvm_require_dr);
=20
 /*
  * This function will be used to read from the physical memory of the curr=
ently
@@ -665,7 +640,6 @@ int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, stru=
ct kvm_mmu *mmu,
=20
 =09return kvm_vcpu_read_guest_page(vcpu, real_gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_page_mmu);
=20
 static int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 =09=09=09       void *data, int offset, int len, u32 access)
@@ -716,7 +690,6 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *=
mmu, unsigned long cr3)
=20
 =09return ret;
 }
-EXPORT_SYMBOL_GPL(load_pdptrs);
=20
 bool pdptrs_changed(struct kvm_vcpu *vcpu)
 {
@@ -744,7 +717,6 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
=20
 =09return changed;
 }
-EXPORT_SYMBOL_GPL(pdptrs_changed);
=20
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
@@ -803,13 +775,11 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long =
cr0)
=20
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr0);
=20
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 {
 =09(void)kvm_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~0x0eul) | (msw & 0x0f)=
);
 }
-EXPORT_SYMBOL_GPL(kvm_lmsw);
=20
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
 {
@@ -821,7 +791,6 @@ void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
 =09=09vcpu->guest_xcr0_loaded =3D 1;
 =09}
 }
-EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
=20
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
 {
@@ -831,7 +800,6 @@ void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
 =09=09vcpu->guest_xcr0_loaded =3D 0;
 =09}
 }
-EXPORT_SYMBOL_GPL(kvm_put_guest_xcr0);
=20
 static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
@@ -882,7 +850,6 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 x=
cr)
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_xcr);
=20
 static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
@@ -952,7 +919,6 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr=
4)
=20
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr4);
=20
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
@@ -987,7 +953,6 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr=
3)
=20
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr3);
=20
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
@@ -999,7 +964,6 @@ int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr=
8)
 =09=09vcpu->arch.cr8 =3D cr8;
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr8);
=20
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
 {
@@ -1008,7 +972,6 @@ unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu)
 =09else
 =09=09return vcpu->arch.cr8;
 }
-EXPORT_SYMBOL_GPL(kvm_get_cr8);
=20
 static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
 {
@@ -1087,7 +1050,6 @@ int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigne=
d long val)
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_dr);
=20
 int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
 {
@@ -1111,7 +1073,6 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigne=
d long *val)
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_get_dr);
=20
 bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 {
@@ -1126,7 +1087,6 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 =09kvm_rdx_write(vcpu, data >> 32);
 =09return err;
 }
-EXPORT_SYMBOL_GPL(kvm_rdpmc);
=20
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
@@ -1357,7 +1317,6 @@ bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
=20
 =09return __kvm_valid_efer(vcpu, efer);
 }
-EXPORT_SYMBOL_GPL(kvm_valid_efer);
=20
 static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
@@ -1392,7 +1351,6 @@ void kvm_enable_efer_bits(u64 mask)
 {
        efer_reserved_bits &=3D ~mask;
 }
-EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
=20
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific faul=
t
@@ -1463,13 +1421,11 @@ int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u=
64 *data)
 {
 =09return __kvm_get_msr(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr);
=20
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 =09return __kvm_set_msr(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr);
=20
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
@@ -1488,7 +1444,6 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 =09kvm_rdx_write(vcpu, (data >> 32) & -1u);
 =09return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
=20
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
@@ -1504,7 +1459,6 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 =09trace_kvm_msr_write(ecx, data);
 =09return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
=20
 /*
  * Adapt set_msr() to msr_io()'s calling convention
@@ -1803,7 +1757,6 @@ u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
=20
 =09return _tsc;
 }
-EXPORT_SYMBOL_GPL(kvm_scale_tsc);
=20
 static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 {
@@ -1820,7 +1773,6 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_t=
sc)
=20
 =09return tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
 }
-EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
=20
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
@@ -1943,7 +1895,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_=
data *msr)
 =09spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
 }
=20
-EXPORT_SYMBOL_GPL(kvm_write_tsc);
=20
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
 =09=09=09=09=09   s64 adjustment)
@@ -2851,7 +2802,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct =
msr_data *msr_info)
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr_common);
=20
 static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool ho=
st)
 {
@@ -3090,7 +3040,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct =
msr_data *msr_info)
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr_common);
=20
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
@@ -5354,7 +5303,6 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 =09return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access,
 =09=09=09=09=09  exception);
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_virt);
=20
 static int emulator_read_std(struct x86_emulate_ctxt *ctxt,
 =09=09=09     gva_t addr, void *val, unsigned int bytes,
@@ -5439,7 +5387,6 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu=
, gva_t addr, void *val,
 =09return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 =09=09=09=09=09   PFERR_WRITE_MASK, exception);
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
=20
 int handle_ud(struct kvm_vcpu *vcpu)
 {
@@ -5457,7 +5404,6 @@ int handle_ud(struct kvm_vcpu *vcpu)
=20
 =09return kvm_emulate_instruction(vcpu, emul_type);
 }
-EXPORT_SYMBOL_GPL(handle_ud);
=20
 static int vcpu_is_mmio_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 =09=09=09    gpa_t gpa, bool write)
@@ -5897,7 +5843,6 @@ int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu)
 =09kvm_emulate_wbinvd_noskip(vcpu);
 =09return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_wbinvd);
=20
=20
=20
@@ -6297,7 +6242,6 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *v=
cpu, int irq, int inc_eip)
 =09=09kvm_set_rflags(vcpu, ctxt->eflags);
 =09}
 }
-EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
=20
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_t=
ype)
 {
@@ -6516,7 +6460,6 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vc=
pu)
 =09=09r =3D kvm_vcpu_do_singlestep(vcpu);
 =09return r;
 }
-EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
=20
 static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 {
@@ -6755,14 +6698,12 @@ int kvm_emulate_instruction(struct kvm_vcpu *vcpu, =
int emulation_type)
 {
 =09return x86_emulate_instruction(vcpu, 0, emulation_type, NULL, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_instruction);
=20
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 =09=09=09=09=09void *insn, int insn_len)
 {
 =09return x86_emulate_instruction(vcpu, 0, 0, insn, insn_len);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_instruction_from_buffer);
=20
 static int complete_fast_pio_out_port_0x7e(struct kvm_vcpu *vcpu)
 {
@@ -6863,7 +6804,6 @@ int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, uns=
igned short port, int in)
 =09=09ret =3D kvm_fast_pio_out(vcpu, size, port);
 =09return ret && kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_fast_pio);
=20
 static int kvmclock_cpu_down_prep(unsigned int cpu)
 {
@@ -7050,7 +6990,6 @@ static void kvm_timer_init(void)
 }
=20
 DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-EXPORT_PER_CPU_SYMBOL_GPL(current_vcpu);
=20
 int kvm_is_in_guest(void)
 {
@@ -7254,7 +7193,6 @@ int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 =09=09return 0;
 =09}
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
=20
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
@@ -7265,7 +7203,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 =09 */
 =09return kvm_vcpu_halt(vcpu) && ret;
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_halt);
=20
 #ifdef CONFIG_X86_64
 static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
@@ -7409,7 +7346,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 =09++vcpu->stat.hypercalls;
 =09return kvm_skip_emulated_instruction(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
=20
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 {
@@ -7915,13 +7851,11 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vc=
pu *vcpu)
 =09 */
 =09put_page(page);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
=20
 void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 {
 =09smp_send_reschedule(vcpu->cpu);
 }
-EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
=20
 /*
  * Returns 1 to let vcpu_run() continue the guest execution loop without
@@ -8600,7 +8534,6 @@ void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int =
*db, int *l)
 =09*db =3D cs.db;
 =09*l =3D cs.l;
 }
-EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
=20
 static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
@@ -8715,7 +8648,6 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_se=
lector, int idt_index,
 =09kvm_make_request(KVM_REQ_EVENT, vcpu);
 =09return 1;
 }
-EXPORT_SYMBOL_GPL(kvm_task_switch);
=20
 static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
@@ -9312,7 +9244,6 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 =09return vcpu->kvm->arch.bsp_vcpu_id =3D=3D vcpu->vcpu_id;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
=20
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
@@ -9320,7 +9251,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 }
=20
 struct static_key kvm_no_apic_vcpu __read_mostly;
-EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
=20
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
@@ -9543,7 +9473,6 @@ int __x86_set_memory_region(struct kvm *kvm, int id, =
gpa_t gpa, u32 size)
=20
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(__x86_set_memory_region);
=20
 int x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 {
@@ -9555,7 +9484,6 @@ int x86_set_memory_region(struct kvm *kvm, int id, gp=
a_t gpa, u32 size)
=20
 =09return r;
 }
-EXPORT_SYMBOL_GPL(x86_set_memory_region);
=20
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
@@ -9877,13 +9805,11 @@ unsigned long kvm_get_linear_rip(struct kvm_vcpu *v=
cpu)
 =09return (u32)(get_segment_base(vcpu, VCPU_SREG_CS) +
 =09=09     kvm_rip_read(vcpu));
 }
-EXPORT_SYMBOL_GPL(kvm_get_linear_rip);
=20
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip)
 {
 =09return kvm_get_linear_rip(vcpu) =3D=3D linear_rip;
 }
-EXPORT_SYMBOL_GPL(kvm_is_linear_rip);
=20
 unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 {
@@ -9894,7 +9820,6 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 =09=09rflags &=3D ~X86_EFLAGS_TF;
 =09return rflags;
 }
-EXPORT_SYMBOL_GPL(kvm_get_rflags);
=20
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
@@ -9909,7 +9834,6 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned l=
ong rflags)
 =09__kvm_set_rflags(vcpu, rflags);
 =09kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_set_rflags);
=20
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf =
*work)
 {
@@ -10116,37 +10040,31 @@ void kvm_arch_start_assignment(struct kvm *kvm)
 {
 =09atomic_inc(&kvm->arch.assigned_device_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
=20
 void kvm_arch_end_assignment(struct kvm *kvm)
 {
 =09atomic_dec(&kvm->arch.assigned_device_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_end_assignment);
=20
 bool kvm_arch_has_assigned_device(struct kvm *kvm)
 {
 =09return atomic_read(&kvm->arch.assigned_device_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
=20
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 {
 =09atomic_inc(&kvm->arch.noncoherent_dma_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
=20
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
 {
 =09atomic_dec(&kvm->arch.noncoherent_dma_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
=20
 bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 {
 =09return atomic_read(&kvm->arch.noncoherent_dma_count);
 }
-EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
=20
 bool kvm_arch_has_irq_bypass(void)
 {
@@ -10197,32 +10115,8 @@ bool kvm_vector_hashing_enabled(void)
 {
 =09return vector_hashing;
 }
-EXPORT_SYMBOL_GPL(kvm_vector_hashing_enabled);
=20
 bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 =09return (vcpu->arch.msr_kvm_poll_control & 1) =3D=3D 0;
 }
-EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
-
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window_update);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 67b6fc153e9c..4c1a8abd1458 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -462,7 +462,6 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irq=
chip, unsigned pin)
=20
 =09return false;
 }
-EXPORT_SYMBOL_GPL(kvm_irq_has_notifier);
=20
 void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1b7fbd138406..bbc4064d74c2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -72,22 +72,18 @@ MODULE_LICENSE("GPL");
 /* Architectures should define their poll value according to the halt late=
ncy */
 unsigned int halt_poll_ns =3D KVM_HALT_POLL_NS_DEFAULT;
 module_param(halt_poll_ns, uint, 0644);
-EXPORT_SYMBOL_GPL(halt_poll_ns);
=20
 /* Default doubles per-vcpu halt_poll_ns. */
 unsigned int halt_poll_ns_grow =3D 2;
 module_param(halt_poll_ns_grow, uint, 0644);
-EXPORT_SYMBOL_GPL(halt_poll_ns_grow);
=20
 /* The start value to grow halt_poll_ns from */
 unsigned int halt_poll_ns_grow_start =3D 10000; /* 10us */
 module_param(halt_poll_ns_grow_start, uint, 0644);
-EXPORT_SYMBOL_GPL(halt_poll_ns_grow_start);
=20
 /* Default resets per-vcpu halt_poll_ns . */
 unsigned int halt_poll_ns_shrink;
 module_param(halt_poll_ns_shrink, uint, 0644);
-EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
=20
 /*
  * Ordering of locks:
@@ -104,7 +100,6 @@ static int kvm_usage_count;
 static atomic_t hardware_enable_failed;
=20
 struct kmem_cache *kvm_vcpu_cache;
-EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
=20
 static __read_mostly struct preempt_ops kvm_preempt_ops;
=20
@@ -133,7 +128,6 @@ static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t=
 gfn);
=20
 __visible bool kvm_rebooting;
-EXPORT_SYMBOL_GPL(kvm_rebooting);
=20
 static bool largepages_enabled =3D true;
=20
@@ -167,7 +161,6 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 =09kvm_arch_vcpu_load(vcpu, cpu);
 =09put_cpu();
 }
-EXPORT_SYMBOL_GPL(vcpu_load);
=20
 void vcpu_put(struct kvm_vcpu *vcpu)
 {
@@ -176,7 +169,6 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 =09preempt_notifier_unregister(&vcpu->preempt_notifier);
 =09preempt_enable();
 }
-EXPORT_SYMBOL_GPL(vcpu_put);
=20
 /* TODO: merge with kvm_arch_vcpu_should_kick */
 static bool kvm_request_needs_ipi(struct kvm_vcpu *vcpu, unsigned req)
@@ -280,7 +272,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 =09=09++kvm->stat.remote_tlb_flush;
 =09cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
 #endif
=20
 void kvm_reload_remote_mmus(struct kvm *kvm)
@@ -326,7 +317,6 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kv=
m, unsigned id)
 fail:
 =09return r;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_init);
=20
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
@@ -339,7 +329,6 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
 =09kvm_arch_vcpu_uninit(vcpu);
 =09free_page((unsigned long)vcpu->run);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
=20
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
@@ -1081,7 +1070,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 out:
 =09return r;
 }
-EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
=20
 int kvm_set_memory_region(struct kvm *kvm,
 =09=09=09  const struct kvm_userspace_memory_region *mem)
@@ -1093,7 +1081,6 @@ int kvm_set_memory_region(struct kvm *kvm,
 =09mutex_unlock(&kvm->slots_lock);
 =09return r;
 }
-EXPORT_SYMBOL_GPL(kvm_set_memory_region);
=20
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 =09=09=09=09=09  struct kvm_userspace_memory_region *mem)
@@ -1135,7 +1122,6 @@ int kvm_get_dirty_log(struct kvm *kvm,
 =09=09*is_dirty =3D 1;
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
=20
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 /**
@@ -1221,7 +1207,6 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 =09=09return -EFAULT;
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_get_dirty_log_protect);
=20
 /**
  * kvm_clear_dirty_log_protect - clear dirty bits in the bitmap
@@ -1295,7 +1280,6 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
=20
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_clear_dirty_log_protect);
 #endif
=20
 bool kvm_largepages_enabled(void)
@@ -1307,7 +1291,6 @@ void kvm_disable_largepages(void)
 {
 =09largepages_enabled =3D false;
 }
-EXPORT_SYMBOL_GPL(kvm_disable_largepages);
=20
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 {
@@ -1387,19 +1370,16 @@ unsigned long gfn_to_hva_memslot(struct kvm_memory_=
slot *slot,
 {
 =09return gfn_to_hva_many(slot, gfn, NULL);
 }
-EXPORT_SYMBOL_GPL(gfn_to_hva_memslot);
=20
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 {
 =09return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
 }
-EXPORT_SYMBOL_GPL(gfn_to_hva);
=20
 unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 =09return gfn_to_hva_many(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn, NULL);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_hva);
=20
 /*
  * Return the hva of a @gfn and the R/W attribute if possible.
@@ -1661,7 +1641,6 @@ kvm_pfn_t __gfn_to_pfn_memslot(struct kvm_memory_slot=
 *slot, gfn_t gfn,
 =09return hva_to_pfn(addr, atomic, async, write_fault,
 =09=09=09  writable);
 }
-EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
=20
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 =09=09      bool *writable)
@@ -1669,31 +1648,26 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gf=
n, bool write_fault,
 =09return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, NULL,
 =09=09=09=09    write_fault, writable);
 }
-EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
=20
 kvm_pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
 =09return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
 }
-EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
=20
 kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gf=
n)
 {
 =09return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
 }
-EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
=20
 kvm_pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
 {
 =09return gfn_to_pfn_memslot_atomic(gfn_to_memslot(kvm, gfn), gfn);
 }
-EXPORT_SYMBOL_GPL(gfn_to_pfn_atomic);
=20
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 =09return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gf=
n);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn_atomic);
=20
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
@@ -1705,7 +1679,6 @@ kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, =
gfn_t gfn)
 {
 =09return gfn_to_pfn_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
=20
 int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 =09=09=09    struct page **pages, int nr_pages)
@@ -1722,7 +1695,6 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot *s=
lot, gfn_t gfn,
=20
 =09return __get_user_pages_fast(addr, nr_pages, 1, pages);
 }
-EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
=20
 static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
 {
@@ -1745,7 +1717,6 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
=20
 =09return kvm_pfn_to_page(pfn);
 }
-EXPORT_SYMBOL_GPL(gfn_to_page);
=20
 static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
 =09=09=09 struct kvm_host_map *map)
@@ -1785,7 +1756,6 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, st=
ruct kvm_host_map *map)
 {
 =09return __kvm_map_gfn(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn, map);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_map);
=20
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 =09=09    bool dirty)
@@ -1813,7 +1783,6 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm=
_host_map *map,
 =09map->hva =3D NULL;
 =09map->page =3D NULL;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
=20
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
@@ -1823,7 +1792,6 @@ struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vc=
pu, gfn_t gfn)
=20
 =09return kvm_pfn_to_page(pfn);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_page);
=20
 void kvm_release_page_clean(struct page *page)
 {
@@ -1831,14 +1799,12 @@ void kvm_release_page_clean(struct page *page)
=20
 =09kvm_release_pfn_clean(page_to_pfn(page));
 }
-EXPORT_SYMBOL_GPL(kvm_release_page_clean);
=20
 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
 =09if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
 =09=09put_page(pfn_to_page(pfn));
 }
-EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
=20
 void kvm_release_page_dirty(struct page *page)
 {
@@ -1846,14 +1812,12 @@ void kvm_release_page_dirty(struct page *page)
=20
 =09kvm_release_pfn_dirty(page_to_pfn(page));
 }
-EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
=20
 void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 {
 =09kvm_set_pfn_dirty(pfn);
 =09kvm_release_pfn_clean(pfn);
 }
-EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
=20
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
@@ -1863,21 +1827,18 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 =09=09SetPageDirty(page);
 =09}
 }
-EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
=20
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
 =09if (!kvm_is_reserved_pfn(pfn))
 =09=09mark_page_accessed(pfn_to_page(pfn));
 }
-EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
=20
 void kvm_get_pfn(kvm_pfn_t pfn)
 {
 =09if (!kvm_is_reserved_pfn(pfn))
 =09=09get_page(pfn_to_page(pfn));
 }
-EXPORT_SYMBOL_GPL(kvm_get_pfn);
=20
 static int next_segment(unsigned long len, int offset)
 {
@@ -1909,7 +1870,6 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, v=
oid *data, int offset,
=20
 =09return __kvm_read_guest_page(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_page);
=20
 int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 =09=09=09     int offset, int len)
@@ -1918,7 +1878,6 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, g=
fn_t gfn, void *data,
=20
 =09return __kvm_read_guest_page(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
=20
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long l=
en)
 {
@@ -1958,7 +1917,6 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t =
gpa, void *data, unsigned l
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest);
=20
 static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn=
,
 =09=09=09           void *data, int offset, unsigned long len)
@@ -1986,7 +1944,6 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa,=
 void *data,
=20
 =09return __kvm_read_guest_atomic(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_atomic);
=20
 int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 =09=09=09       void *data, unsigned long len)
@@ -1997,7 +1954,6 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu,=
 gpa_t gpa,
=20
 =09return __kvm_read_guest_atomic(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
=20
 static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t g=
fn,
 =09=09=09          const void *data, int offset, int len)
@@ -2022,7 +1978,6 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
=20
 =09return __kvm_write_guest_page(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest_page);
=20
 int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 =09=09=09      const void *data, int offset, int len)
@@ -2031,7 +1986,6 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, =
gfn_t gfn,
=20
 =09return __kvm_write_guest_page(slot, gfn, data, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
=20
 int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
 =09=09    unsigned long len)
@@ -2073,7 +2027,6 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t=
 gpa, const void *data,
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest);
=20
 static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 =09=09=09=09       struct gfn_to_hva_cache *ghc,
@@ -2119,7 +2072,6 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct=
 gfn_to_hva_cache *ghc,
 =09struct kvm_memslots *slots =3D kvm_memslots(kvm);
 =09return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);
 }
-EXPORT_SYMBOL_GPL(kvm_gfn_to_hva_cache_init);
=20
 int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache=
 *ghc,
 =09=09=09=09  void *data, unsigned int offset,
@@ -2147,14 +2099,12 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, =
struct gfn_to_hva_cache *ghc,
=20
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest_offset_cached);
=20
 int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 =09=09=09   void *data, unsigned long len)
 {
 =09return kvm_write_guest_offset_cached(kvm, ghc, data, 0, len);
 }
-EXPORT_SYMBOL_GPL(kvm_write_guest_cached);
=20
 int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 =09=09=09   void *data, unsigned long len)
@@ -2179,7 +2129,6 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn=
_to_hva_cache *ghc,
=20
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
=20
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
 {
@@ -2187,7 +2136,6 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, =
int offset, int len)
=20
 =09return kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
 }
-EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
=20
 int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 {
@@ -2206,7 +2154,6 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsig=
ned long len)
 =09}
 =09return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_clear_guest);
=20
 static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
 =09=09=09=09    gfn_t gfn)
@@ -2225,7 +2172,6 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 =09memslot =3D gfn_to_memslot(kvm, gfn);
 =09mark_page_dirty_in_slot(memslot, gfn);
 }
-EXPORT_SYMBOL_GPL(mark_page_dirty);
=20
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
@@ -2234,7 +2180,6 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, =
gfn_t gfn)
 =09memslot =3D kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 =09mark_page_dirty_in_slot(memslot, gfn);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
=20
 void kvm_sigset_activate(struct kvm_vcpu *vcpu)
 {
@@ -2385,7 +2330,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 =09trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
 =09kvm_arch_vcpu_block_finish(vcpu);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_block);
=20
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
@@ -2401,7 +2345,6 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
=20
 =09return false;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
=20
 #ifndef CONFIG_S390
 /*
@@ -2421,7 +2364,6 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 =09=09=09smp_send_reschedule(cpu);
 =09put_cpu();
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
 #endif /* !CONFIG_S390 */
=20
 int kvm_vcpu_yield_to(struct kvm_vcpu *target)
@@ -2442,7 +2384,6 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target)
=20
 =09return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_yield_to);
=20
 /*
  * Helper that checks whether a VCPU is eligible for directed yield.
@@ -2559,7 +2500,6 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield=
_to_kernel_mode)
 =09/* Ensure vcpu is not eligible during next spinloop */
 =09kvm_vcpu_set_dy_eligible(me, false);
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
=20
 static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 {
@@ -3743,7 +3683,6 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_=
bus bus_idx, gpa_t addr,
 =09r =3D __kvm_io_bus_write(vcpu, bus, &range, val);
 =09return r < 0 ? r : 0;
 }
-EXPORT_SYMBOL_GPL(kvm_io_bus_write);
=20
 /* kvm_io_bus_write_cookie - called under kvm->slots_lock */
 int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
@@ -3920,7 +3859,6 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *=
kvm, enum kvm_bus bus_idx,
=20
 =09return iodev;
 }
-EXPORT_SYMBOL_GPL(kvm_io_bus_get_dev);
=20
 static int kvm_debugfs_open(struct inode *inode, struct file *file,
 =09=09=09   int (*get)(void *, u64 *), int (*set)(void *, u64),
@@ -4352,7 +4290,6 @@ __init int kvm_init(void *opaque, unsigned vcpu_size,=
 unsigned vcpu_align,
 out_fail:
 =09return r;
 }
-EXPORT_SYMBOL_GPL(kvm_init);
=20
 void kvm_exit(void)
 {
@@ -4370,4 +4307,3 @@ void kvm_exit(void)
 =09free_cpumask_var(cpus_hardware_enabled);
 =09kvm_vfio_ops_exit();
 }
-EXPORT_SYMBOL_GPL(kvm_exit);

