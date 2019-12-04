Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8957911356D
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfLDTHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:07:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28474 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728941AbfLDTHg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 14:07:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575486454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Lq/P7d+cEs1tdKkoIRD5hhXJQvr8MIiHNwX65PAnnk=;
        b=IYiQTObgrdhe5Wd6ZbDg6x7fYnd1jX2lgf2/cAajdyugP6GJSxhOOO64LfkSfX/4DgZL4C
        myIwSOJJbEVSNAMvmer0dPuAulyHOrmyWRqwvckXhX+vvGIejW6WkmckcAjsM3Bt38eSI2
        XJLsyW58xv0duxSG5O2TZ6gSHxOSaSI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-mscxAyZSOGmfS-G8jRUgVA-1; Wed, 04 Dec 2019 14:07:32 -0500
Received: by mail-qt1-f200.google.com with SMTP id u9so637087qte.5
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 11:07:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/aw+fRGlH+N9W78xqsOuN+obHGUmDvFS1ddeXRADj4A=;
        b=LcuN4aC3Kxs+U+itMtQYfhN5oP6slrz2s5Pnu5q9EL+4gw1JkvaTlhaR05PPSdEvWr
         x5OaOp7W3b/oqPaPDkPcsdYaBB9+sJAGK3azweAyXoDzKyfc5O0hLMec51416jCiepJP
         AxyouClTiKn3jFqpaiWtCkSKBEeolpu2rvODDcRlCj6Qg0rP5aHKl2XtQp6MQwjEhTax
         WkDg87aa2el2ySp0OjODxPIeNaajM/Uab3MOr0ygUJEJVyL8PbDvXa+l7C8Ecevw13k4
         p9XLPhWXmQOe/2e6ll12bdGnHEVfLUPA18TLaKAKffjOvEhJV49+khObDoVm3ojLiSCC
         TfuQ==
X-Gm-Message-State: APjAAAX8u9mg79sjBDpPG/PXyo0iy10j45cmGKUFrCd9Ny8Cu4JoGqxE
        LWz6IIdU9+OooSyCXLaVnMjDqxJ2rpxqtl7IaYN8u3qifWEvHeWyofsd1m8BcNxDPUWGVSOi6+/
        FotcoDraziIik
X-Received: by 2002:ae9:ec0b:: with SMTP id h11mr4451245qkg.97.1575486451264;
        Wed, 04 Dec 2019 11:07:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8nwioxQxIuSeML+K5PHXcsUaOyJVc9LBRDJnxWxf/xvFanlwMCKzVQ3o07cRLheRCNQXaJg==
X-Received: by 2002:ae9:ec0b:: with SMTP id h11mr4451216qkg.97.1575486450983;
        Wed, 04 Dec 2019 11:07:30 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id y18sm4072126qtn.11.2019.12.04.11.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:07:29 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v5 5/6] KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros
Date:   Wed,  4 Dec 2019 14:07:20 -0500
Message-Id: <20191204190721.29480-6-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191204190721.29480-1-peterx@redhat.com>
References: <20191204190721.29480-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: mscxAyZSOGmfS-G8jRUgVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Callers of kvm_apic_match_dest() should always pass in APIC_DEST_*
macros for either dest_mode and short_hand parameters.  Fix up all the
callers of kvm_apic_match_dest() that are not following the rule.

Since at it, rename the parameter from short_hand to shorthand in
kvm_apic_match_dest(), as suggested by Vitaly.

Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/ioapic.c   | 11 +++++++----
 arch/x86/kvm/irq_comm.c |  3 ++-
 arch/x86/kvm/lapic.c    |  4 ++--
 arch/x86/kvm/lapic.h    |  2 +-
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index e623a4f8d27e..f53daeaaeb37 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -108,8 +108,9 @@ static void __rtc_irq_eoi_tracking_restore_one(struct k=
vm_vcpu *vcpu)
 =09union kvm_ioapic_redirect_entry *e;
=20
 =09e =3D &ioapic->redirtbl[RTC_GSI];
-=09if (!kvm_apic_match_dest(vcpu, NULL, 0,=09e->fields.dest_id,
-=09=09=09=09e->fields.dest_mode))
+=09if (!kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
+=09=09=09=09 e->fields.dest_id,
+=09=09=09=09 kvm_lapic_irq_dest_mode(!!e->fields.dest_mode)))
 =09=09return;
=20
 =09new_val =3D kvm_apic_pending_eoi(vcpu, e->fields.vector);
@@ -250,8 +251,10 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulon=
g *ioapic_handled_vectors)
 =09=09if (e->fields.trig_mode =3D=3D IOAPIC_LEVEL_TRIG ||
 =09=09    kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index) ||
 =09=09    index =3D=3D RTC_GSI) {
-=09=09=09if (kvm_apic_match_dest(vcpu, NULL, 0,
-=09=09=09             e->fields.dest_id, e->fields.dest_mode) ||
+=09=09=09u16 dm =3D kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
+
+=09=09=09if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
+=09=09=09=09=09=09e->fields.dest_id, dm) ||
 =09=09=09    kvm_apic_pending_eoi(vcpu, e->fields.vector))
 =09=09=09=09__set_bit(e->fields.vector,
 =09=09=09=09=09  ioapic_handled_vectors);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 22108ed66a76..7d083f71fc8e 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -417,7 +417,8 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
=20
 =09=09=09kvm_set_msi_irq(vcpu->kvm, entry, &irq);
=20
-=09=09=09if (irq.level && kvm_apic_match_dest(vcpu, NULL, 0,
+=09=09=09if (irq.level &&
+=09=09=09    kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
 =09=09=09=09=09=09irq.dest_id, irq.dest_mode))
 =09=09=09=09__set_bit(irq.vector, ioapic_handled_vectors);
 =09=09}
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 805c18178bbf..679692b55f6d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -789,13 +789,13 @@ static u32 kvm_apic_mda(struct kvm_vcpu *vcpu, unsign=
ed int dest_id,
 }
=20
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
-=09=09=09   int short_hand, unsigned int dest, int dest_mode)
+=09=09=09   int shorthand, unsigned int dest, int dest_mode)
 {
 =09struct kvm_lapic *target =3D vcpu->arch.apic;
 =09u32 mda =3D kvm_apic_mda(vcpu, dest, source, target);
=20
 =09ASSERT(target);
-=09switch (short_hand) {
+=09switch (shorthand) {
 =09case APIC_DEST_NOSHORT:
 =09=09if (dest_mode =3D=3D APIC_DEST_PHYSICAL)
 =09=09=09return kvm_apic_match_physical_addr(target, mda);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 5a9f29ed9a4b..ec730ce7a344 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -83,7 +83,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, =
u32 val);
 int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 =09=09       void *data);
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
-=09=09=09   int short_hand, unsigned int dest, int dest_mode);
+=09=09=09   int shorthand, unsigned int dest, int dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
--=20
2.21.0

