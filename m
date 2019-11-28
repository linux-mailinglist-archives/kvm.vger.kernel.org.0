Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A210CEEA
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 20:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfK1TcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 14:32:18 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbfK1TcS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 14:32:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574969536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XMgsSwZQeQUSGV+wli5DvraayuJweYcClot3naZXyqM=;
        b=hLcSWRs/n1CdxLodM7SxyCgkHCxx1D5x0WHnUgzavxQkp+GGWu1LnUHYInTLd+0j5OjCA0
        iM24ABE73V/DSa6E8nVzYKgu70dk33tRKzS6dONCNr/xL74n4IaYZ4sQubBWvePC+CE6HV
        gFH61NBJofk3hl06UNxHZImPdaeZz+4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-TJJdfkETMuCvt7jnbv7ZNQ-1; Thu, 28 Nov 2019 14:32:14 -0500
Received: by mail-qt1-f197.google.com with SMTP id l25so745708qtu.0
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 11:32:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UsdxgTYnGq5qlzCPxK2R/zyMAt8PsfASdePTB4mVfio=;
        b=uXeLn40O4I0EyfZiaGzkoScUSX5hN5BwZsukPFUnvoDfMczEDOMmMK3Pc0dJkeTIxw
         LJW+iWpKWc3rz/JpenJrgWUGuDkmIIcbRAchgoLa0GxZVO3HpHEPTwQ4KeecCj+AGF/f
         Xz2mg6Pk0Xp5q1VzMKbMDEpN3CNhY+u4RGreBgcgLVUgrIJDDJavGrmrrR/pAElqGqt3
         VxuXezhFMvqhpaJIEhoY950txoVE5dnQRqu5VTCLdU+0HRXrFFg7P/PKG/a87CEA/dQs
         FJIKxZVPoasrCS6T6f4S2fBllJSV1BZCHnXjGD1xjKEC90xnywfJ7g1n+z+7JbJhL2us
         gArw==
X-Gm-Message-State: APjAAAUIem6H7oLGEfOUJAb9AQS13NFXOwsns6fVQtdnTzAQBk816CNs
        4AZAZuvF7RIxX0MjYcjAf6IyH04NIgOK4LgWhjcAjhhP+K4UVVGMJ8oYD7blNt6+2vChDwFfvUe
        xz2nre3tjZKae
X-Received: by 2002:a37:5942:: with SMTP id n63mr11663947qkb.432.1574969534100;
        Thu, 28 Nov 2019 11:32:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqx2kY7sAyhyavXxVXch1pzKTwKJrrOIiaxnEiIEDCsPRfNWlBYZUpXZzMOMBRn088FhlV7mjA==
X-Received: by 2002:a37:5942:: with SMTP id n63mr11663920qkb.432.1574969533797;
        Thu, 28 Nov 2019 11:32:13 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id x6sm2273178qke.127.2019.11.28.11.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 11:32:12 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>
Subject: [PATCH] KVM: X86: Use APIC_DEST_* macros properly
Date:   Thu, 28 Nov 2019 14:32:11 -0500
Message-Id: <20191128193211.32684-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: TJJdfkETMuCvt7jnbv7ZNQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously we were using either APIC_DEST_PHYSICAL|APIC_DEST_LOGICAL
or 0|1 to fill in kvm_lapic_irq.dest_mode, and it's done in an adhoc
way.  It's fine imho only because in most cases when we check against
dest_mode it's against APIC_DEST_PHYSICAL (which equals to 0).
However, that's not consistent, majorly because APIC_DEST_LOGICAL does
not equals to 1, so if one day we check irq.dest_mode against
APIC_DEST_LOGICAL we'll probably always get a false returned.

This patch replaces the 0/1 settings of irq.dest_mode with the macros
to make them consistent.

CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <sean.j.christopherson@intel.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Nitesh Narayan Lal <nitesh@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/ioapic.c   | 9 ++++++---
 arch/x86/kvm/irq_comm.c | 7 ++++---
 arch/x86/kvm/x86.c      | 2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 9fd2dd89a1c5..1e091637d5d5 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -331,7 +331,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 =09=09=09irq.vector =3D e->fields.vector;
 =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
 =09=09=09irq.dest_id =3D e->fields.dest_id;
-=09=09=09irq.dest_mode =3D e->fields.dest_mode;
+=09=09=09irq.dest_mode =3D e->fields.dest_mode ?
+=09=09=09    APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 =09=09=09bitmap_zero(&vcpu_bitmap, 16);
 =09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
 =09=09=09=09=09=09 &vcpu_bitmap);
@@ -343,7 +344,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 =09=09=09=09 * keep ioapic_handled_vectors synchronized.
 =09=09=09=09 */
 =09=09=09=09irq.dest_id =3D old_dest_id;
-=09=09=09=09irq.dest_mode =3D old_dest_mode;
+=09=09=09=09irq.dest_mode =3D old_dest_mode ?
+=09=09=09=09    APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 =09=09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
 =09=09=09=09=09=09=09 &vcpu_bitmap);
 =09=09=09}
@@ -369,7 +371,8 @@ static int ioapic_service(struct kvm_ioapic *ioapic, in=
t irq, bool line_status)
=20
 =09irqe.dest_id =3D entry->fields.dest_id;
 =09irqe.vector =3D entry->fields.vector;
-=09irqe.dest_mode =3D entry->fields.dest_mode;
+=09irqe.dest_mode =3D entry->fields.dest_mode ?
+=09    APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 =09irqe.trig_mode =3D entry->fields.trig_mode;
 =09irqe.delivery_mode =3D entry->fields.delivery_mode << 8;
 =09irqe.level =3D 1;
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8ecd48d31800..673b6afd6dbf 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -52,8 +52,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_=
lapic *src,
 =09unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 =09unsigned int dest_vcpus =3D 0;
=20
-=09if (irq->dest_mode =3D=3D 0 && irq->dest_id =3D=3D 0xff &&
-=09=09=09kvm_lowest_prio_delivery(irq)) {
+=09if (irq->dest_mode =3D=3D APIC_DEST_PHYSICAL &&
+=09    irq->dest_id =3D=3D 0xff && kvm_lowest_prio_delivery(irq)) {
 =09=09printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 =09=09irq->delivery_mode =3D APIC_DM_FIXED;
 =09}
@@ -114,7 +114,8 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel=
_irq_routing_entry *e,
 =09=09irq->dest_id |=3D MSI_ADDR_EXT_DEST_ID(e->msi.address_hi);
 =09irq->vector =3D (e->msi.data &
 =09=09=09MSI_DATA_VECTOR_MASK) >> MSI_DATA_VECTOR_SHIFT;
-=09irq->dest_mode =3D (1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_lo;
+=09irq->dest_mode =3D (1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_lo =
?
+=09    APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 =09irq->trig_mode =3D (1 << MSI_DATA_TRIGGER_SHIFT) & e->msi.data;
 =09irq->delivery_mode =3D e->msi.data & 0x700;
 =09irq->msi_redir_hint =3D ((e->msi.address_lo
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ed167e039e5..3b00d662dc14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7356,7 +7356,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsig=
ned long flags, int apicid)
 =09struct kvm_lapic_irq lapic_irq;
=20
 =09lapic_irq.shorthand =3D 0;
-=09lapic_irq.dest_mode =3D 0;
+=09lapic_irq.dest_mode =3D APIC_DEST_PHYSICAL;
 =09lapic_irq.level =3D 0;
 =09lapic_irq.dest_id =3D apicid;
 =09lapic_irq.msi_redir_hint =3D false;
--=20
2.21.0

