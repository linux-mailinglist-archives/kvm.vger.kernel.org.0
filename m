Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27308110310
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfLCQ7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:59:31 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37364 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727166AbfLCQ7P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 11:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575392354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PzwZcxUy7RnohkGRP3nmuFGuUFWbAoxrN1OoQL2mAM=;
        b=BVghTG4TqVBI8NkVahcA5mB1gKQW2QJw3cKro7woXtrtdz7BsaXngGMo883t2hXRdTpxfR
        vmtEANm9Whzu+ys2A80j9a3Kw0SHGsvvC5hlGeP34XDROZ+UUjeVP0AHORE1BGYzOkE5Sp
        bzj8xbeNJM1aIAilqUzctcvI59W4zxo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-IHpHvZPVNs6FTrrBruaMag-1; Tue, 03 Dec 2019 11:59:10 -0500
Received: by mail-qk1-f198.google.com with SMTP id 16so2622153qkm.5
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 08:59:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9or0Z3IjCalxRQDLajBB/eFOZ4QHEXiRdq3XJW4DEO4=;
        b=BE4C5T6KNjnwZAA395DUCQaytdSTgnx/HKdbFN4piBqvoB9EMcTwssHm750o3P3zfn
         tLRSfqm9gpqwnJQIqYlNcUR7MPiQs6CSkENphjE0WBr8+jjh7r+1dE6r76Juh4Zd812Y
         fSuBTvqY92sg7YOdZ+nkgAVi4V2XAo94y7cF86FzKuuLRT3Cs+2bgfzvTgdGfkq8gMru
         9bMw2kTPAQ4ezKHLcJGDYwB4fgiUcjvO/+1PjVOEzHmk1R7y1xr3tUNxSbTMBHAgJmUj
         YHPwBPHMmTRqBxhBFVq2IWFhJtQcqMK2OnHaxohJnIscG07CQglkYLSrWpph4SadLTnh
         26UA==
X-Gm-Message-State: APjAAAWn6NvaO5sNZa4gzmH2NBiPLQu5pdYSr2x91DLz4+tP9ER3EiBX
        mX436762mb4D+AkJqPiDv+CenlYoTaMvk5CY6+wdcwHj4HhY816alr7aOeOwJvf/XFCLRCz+lOi
        AW8rNFVbvD9aD
X-Received: by 2002:a37:7bc7:: with SMTP id w190mr6056702qkc.132.1575392350173;
        Tue, 03 Dec 2019 08:59:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqxnqxZ1WErwO4sJh61fQ7tyCWYjuH45lvTfKDEeEAS1rAr7HD07UWPgL0K0OGrnA8lJrKUi/w==
X-Received: by 2002:a37:7bc7:: with SMTP id w190mr6056671qkc.132.1575392349797;
        Tue, 03 Dec 2019 08:59:09 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a16sm482585qkn.48.2019.12.03.08.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:59:08 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 3/6] KVM: X86: Use APIC_DEST_* macros properly in kvm_lapic_irq.dest_mode
Date:   Tue,  3 Dec 2019 11:59:00 -0500
Message-Id: <20191203165903.22917-4-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191203165903.22917-1-peterx@redhat.com>
References: <20191203165903.22917-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: IHpHvZPVNs6FTrrBruaMag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We were using either APIC_DEST_PHYSICAL|APIC_DEST_LOGICAL or 0|1 to
fill in kvm_lapic_irq.dest_mode.  It's fine only because in most cases
when we check against dest_mode it's against APIC_DEST_PHYSICAL (which
equals to 0).  However, that's not consistent.  We'll have problem
when we want to start checking against APIC_DEST_LOGICAL, which does
not equals to 1.

This patch firstly introduces kvm_lapic_irq_dest_mode() helper to take
any boolean of destination mode and return the APIC_DEST_* macro.
Then, it replaces the 0|1 settings of irq.dest_mode with the helper.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 arch/x86/kvm/ioapic.c           | 9 ++++++---
 arch/x86/kvm/irq_comm.c         | 7 ++++---
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index b79cd6aa4075..f815c97b1b57 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1022,6 +1022,11 @@ struct kvm_lapic_irq {
 =09bool msi_redir_hint;
 };
=20
+static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode)
+{
+=09return dest_mode ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
+}
+
 struct kvm_x86_ops {
 =09int (*cpu_has_kvm_support)(void);          /* __init */
 =09int (*disabled_by_bios)(void);             /* __init */
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 9fd2dd89a1c5..e623a4f8d27e 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -331,7 +331,8 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 =09=09=09irq.vector =3D e->fields.vector;
 =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
 =09=09=09irq.dest_id =3D e->fields.dest_id;
-=09=09=09irq.dest_mode =3D e->fields.dest_mode;
+=09=09=09irq.dest_mode =3D
+=09=09=09    kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
 =09=09=09bitmap_zero(&vcpu_bitmap, 16);
 =09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
 =09=09=09=09=09=09 &vcpu_bitmap);
@@ -343,7 +344,9 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 =09=09=09=09 * keep ioapic_handled_vectors synchronized.
 =09=09=09=09 */
 =09=09=09=09irq.dest_id =3D old_dest_id;
-=09=09=09=09irq.dest_mode =3D old_dest_mode;
+=09=09=09=09irq.dest_mode =3D
+=09=09=09=09    kvm_lapic_irq_dest_mode(
+=09=09=09=09=09!!e->fields.dest_mode);
 =09=09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
 =09=09=09=09=09=09=09 &vcpu_bitmap);
 =09=09=09}
@@ -369,7 +372,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, in=
t irq, bool line_status)
=20
 =09irqe.dest_id =3D entry->fields.dest_id;
 =09irqe.vector =3D entry->fields.vector;
-=09irqe.dest_mode =3D entry->fields.dest_mode;
+=09irqe.dest_mode =3D kvm_lapic_irq_dest_mode(!!entry->fields.dest_mode);
 =09irqe.trig_mode =3D entry->fields.trig_mode;
 =09irqe.delivery_mode =3D entry->fields.delivery_mode << 8;
 =09irqe.level =3D 1;
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8ecd48d31800..22108ed66a76 100644
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
+=09irq->dest_mode =3D kvm_lapic_irq_dest_mode(
+=09    !!((1 << MSI_ADDR_DEST_MODE_SHIFT) & e->msi.address_lo));
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

