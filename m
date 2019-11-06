Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A468BF173D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 14:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbfKFNhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 08:37:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730705AbfKFNhH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Nov 2019 08:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573047426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zFJtbi40NQp0Azk9V10i1JYDXOyupgSpOeME9YZ9Kvc=;
        b=Qcv3XhYxcbs0DXcASmqg+do8Ni1dMJi6CnzmfbIvs2SJNrkGHn9AP61jAZWSPELtxOPDKJ
        lmViE8m3yRWFYWTTb62A6l1Il230f3jsicIEZ/lF9oFh6lRY4lamNA8rvVyQRwDRlAE25H
        OwEdear35nqRaZ/NlSF+jWom5u3WWXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-di9Z1Jc_O4qzzVYjWnSpyA-1; Wed, 06 Nov 2019 08:37:02 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48DA8800C72;
        Wed,  6 Nov 2019 13:37:01 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5849E5D9CD;
        Wed,  6 Nov 2019 13:37:00 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [Patch v1 2/2] KVM: x86: deliver KVM IOAPIC scan request to target vCPUs
Date:   Wed,  6 Nov 2019 08:36:38 -0500
Message-Id: <1573047398-7665-3-git-send-email-nitesh@redhat.com>
In-Reply-To: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
References: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: di9Z1Jc_O4qzzVYjWnSpyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In IOAPIC fixed delivery mode instead of flushing the scan
requests to all vCPUs, we should only send the requests to
vCPUs specified within the destination field.

This patch introduces kvm_get_dest_vcpus_mask() API which
retrieves an array of target vCPUs by using
kvm_apic_map_get_dest_lapic() and then based on the
vcpus_idx, it sets the bit in a bitmap. However, if the above
fails kvm_get_dest_vcpus_mask() finds the target vCPUs by
traversing all available vCPUs. Followed by setting the
bits in the bitmap.

If we had different vCPUs in the previous request for the
same redirection table entry then bits corresponding to
these vCPUs are also set. This to done to keep
ioapic_handled_vectors synchronized.

This bitmap is then eventually passed on to
kvm_make_vcpus_request_mask() to generate a masked request
only for the target vCPUs.

This would enable us to reduce the latency overhead on isolated
vCPUs caused by the IPI to process due to KVM_REQ_IOAPIC_SCAN.

Suggested-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/ioapic.c           | 33 ++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.c            | 45 +++++++++++++++++++++++++++++++++++++=
++++
 arch/x86/kvm/lapic.h            |  3 +++
 arch/x86/kvm/x86.c              |  6 ++++++
 include/linux/kvm_host.h        |  2 ++
 virt/kvm/kvm_main.c             | 14 +++++++++++++
 7 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 24d6598..b2aca6d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1571,6 +1571,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ip=
i_bitmap_low,
=20
 void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
+void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
+=09=09=09=09       unsigned long *vcpu_bitmap);
=20
 void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 =09=09=09=09     struct kvm_async_pf *work);
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index d859ae8..c8d0a83 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -271,8 +271,9 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 {
 =09unsigned index;
 =09bool mask_before, mask_after;
-=09int old_remote_irr, old_delivery_status;
 =09union kvm_ioapic_redirect_entry *e;
+=09unsigned long vcpu_bitmap;
+=09int old_remote_irr, old_delivery_status, old_dest_id, old_dest_mode;
=20
 =09switch (ioapic->ioregsel) {
 =09case IOAPIC_REG_VERSION:
@@ -296,6 +297,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 =09=09/* Preserve read-only fields */
 =09=09old_remote_irr =3D e->fields.remote_irr;
 =09=09old_delivery_status =3D e->fields.delivery_status;
+=09=09old_dest_id =3D e->fields.dest_id;
+=09=09old_dest_mode =3D e->fields.dest_mode;
 =09=09if (ioapic->ioregsel & 1) {
 =09=09=09e->bits &=3D 0xffffffff;
 =09=09=09e->bits |=3D (u64) val << 32;
@@ -321,7 +324,33 @@ static void ioapic_write_indirect(struct kvm_ioapic *i=
oapic, u32 val)
 =09=09if (e->fields.trig_mode =3D=3D IOAPIC_LEVEL_TRIG
 =09=09    && ioapic->irr & (1 << index))
 =09=09=09ioapic_service(ioapic, index, false);
-=09=09kvm_make_scan_ioapic_request(ioapic->kvm);
+=09=09if (e->fields.delivery_mode =3D=3D APIC_DM_FIXED) {
+=09=09=09struct kvm_lapic_irq irq;
+
+=09=09=09irq.shorthand =3D 0;
+=09=09=09irq.vector =3D e->fields.vector;
+=09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
+=09=09=09irq.dest_id =3D e->fields.dest_id;
+=09=09=09irq.dest_mode =3D e->fields.dest_mode;
+=09=09=09kvm_get_dest_vcpus_mask(ioapic->kvm, &irq,
+=09=09=09=09=09=09&vcpu_bitmap);
+=09=09=09if (old_dest_mode !=3D e->fields.dest_mode ||
+=09=09=09    old_dest_id !=3D e->fields.dest_id) {
+=09=09=09=09/*
+=09=09=09=09 * Update vcpu_bitmap with vcpus specified in
+=09=09=09=09 * the previous request as well. This is done to
+=09=09=09=09 * keep ioapic_handled_vectors synchronized.
+=09=09=09=09 */
+=09=09=09=09irq.dest_id =3D old_dest_id;
+=09=09=09=09irq.dest_mode =3D old_dest_mode;
+=09=09=09=09kvm_get_dest_vcpus_mask(ioapic->kvm, &irq,
+=09=09=09=09=09=09=09&vcpu_bitmap);
+=09=09=09}
+=09=09=09kvm_make_scan_ioapic_request_mask(ioapic->kvm,
+=09=09=09=09=09=09=09  &vcpu_bitmap);
+=09=09} else {
+=09=09=09kvm_make_scan_ioapic_request(ioapic->kvm);
+=09=09}
 =09=09break;
 =09}
 }
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b29d00b..90869c4 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1124,6 +1124,51 @@ static int __apic_accept_irq(struct kvm_lapic *apic,=
 int delivery_mode,
 =09return result;
 }
=20
+/*
+ * This routine identifies the destination vcpus mask meant to receive the
+ * IOAPIC interrupts. It either uses kvm_apic_map_get_dest_lapic() to find
+ * out the destination vcpus array and set the bitmap or it traverses to
+ * each available vcpu to identify the same.
+ */
+void kvm_get_dest_vcpus_mask(struct kvm *kvm, struct kvm_lapic_irq *irq,
+=09=09=09     unsigned long *vcpu_bitmap)
+{
+=09struct kvm_lapic **dest_vcpu =3D NULL;
+=09struct kvm_lapic *src =3D NULL;
+=09struct kvm_apic_map *map;
+=09struct kvm_vcpu *vcpu;
+=09unsigned long bitmap;
+=09int i, vcpus_idx;
+=09bool ret;
+
+=09rcu_read_lock();
+=09map =3D rcu_dereference(kvm->arch.apic_map);
+
+=09ret =3D kvm_apic_map_get_dest_lapic(kvm, &src, irq, map, &dest_vcpu,
+=09=09=09=09=09  &bitmap);
+=09if (ret) {
+=09=09for_each_set_bit(i, &bitmap, 16) {
+=09=09=09if (!dest_vcpu[i])
+=09=09=09=09continue;
+=09=09=09vcpus_idx =3D dest_vcpu[i]->vcpu->vcpus_idx;
+=09=09=09__set_bit(vcpus_idx, vcpu_bitmap);
+=09=09}
+=09} else {
+=09=09kvm_for_each_vcpu(i, vcpu, kvm) {
+=09=09=09if (!kvm_apic_present(vcpu))
+=09=09=09=09continue;
+=09=09=09if (!kvm_apic_match_dest(vcpu, NULL,
+=09=09=09=09=09=09 irq->delivery_mode,
+=09=09=09=09=09=09 irq->dest_id,
+=09=09=09=09=09=09 irq->dest_mode))
+=09=09=09=09continue;
+=09=09=09vcpus_idx =3D dest_vcpu[i]->vcpu->vcpus_idx;
+=09=09=09__set_bit(vcpus_idx, vcpu_bitmap);
+=09=09}
+=09}
+=09rcu_read_unlock();
+}
+
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 {
 =09return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1f501485..49b0c6c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -226,6 +226,9 @@ static inline int kvm_lapic_latched_init(struct kvm_vcp=
u *vcpu)
=20
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
=20
+void kvm_get_dest_vcpus_mask(struct kvm *kvm, struct kvm_lapic_irq *irq,
+=09=09=09     unsigned long *vcpu_bitmap);
+
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *i=
rq,
 =09=09=09struct kvm_vcpu **dest_vcpu);
 int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff395f8..ee6945f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7838,6 +7838,12 @@ static void process_smi(struct kvm_vcpu *vcpu)
 =09kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
=20
+void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
+=09=09=09=09       unsigned long *vcpu_bitmap)
+{
+=09kvm_make_cpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC, vcpu_bitmap);
+}
+
 void kvm_make_scan_ioapic_request(struct kvm *kvm)
 {
 =09kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 31c4fde..2f69eae 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -786,6 +786,8 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t g=
pa, const void *data,
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 =09=09=09=09 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
+bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
+=09=09=09=09unsigned long *vcpu_bitmap);
=20
 long kvm_arch_dev_ioctl(struct file *filp,
 =09=09=09unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 24ab711..9e85df8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -242,6 +242,20 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsi=
gned int req,
 =09return called;
 }
=20
+bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
+=09=09=09=09unsigned long *vcpu_bitmap)
+{
+=09cpumask_var_t cpus;
+=09bool called;
+
+=09zalloc_cpumask_var(&cpus, GFP_ATOMIC);
+
+=09called =3D kvm_make_vcpus_request_mask(kvm, req, vcpu_bitmap, cpus);
+
+=09free_cpumask_var(cpus);
+=09return called;
+}
+
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
 =09cpumask_var_t cpus;
--=20
1.8.3.1

