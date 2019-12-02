Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE53F10F163
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfLBUNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:13:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27688 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728183AbfLBUNb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 15:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575317611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGyv0HcV61jwW8d05G9E2IdyBpBV7NLYzlcgkoWtE1A=;
        b=Am2cIpFRlGu6JRYgXu4lqCvpEj1kgPr0coTSup573TNkb2PgZpEzRlSceLBP6QRIM6bY6Z
        uP2c3WayJWwDfehwc02/shO+lw2+EJhhKEJd+zz6uw+xZ0lvfH/U0jX9DYO3onehSBqq5j
        1P18VVgxrp8uBpKHN0dyuivE9j1usFg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-f467Dvh7NNqsej2Mttk6DA-1; Mon, 02 Dec 2019 15:13:27 -0500
Received: by mail-qv1-f69.google.com with SMTP id l1so528831qvu.13
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 12:13:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D/FzhMnEoda/8HIh8/dn3z8Z/X2H7yZOxK6TY6H8n7g=;
        b=sZUr2fWszBYTDN/mrEq6MxhUmMlR6gK0nURkd+msczvWfEOaaLlCKXBX121moMuCyU
         MStbEEPd0RI3VFqeOvKtLHqfVbw0ResG0ZhBpIsu0dsBQHRNo0NZXY2kj099VTOUqrFV
         YOiFX3M4JSrBBmG9lZlo7dpiClI15fzGQ5r7eb6STpr1JC3XYFs7CqcaCbcy0k4a8PwM
         QL2VYChdwrqbTyVZo2YngwHC/56WdTA6z1M2g8UVRb7fC10gKDboEHxu+9vn6oRdzfxy
         vDPIvjLaqs9vZhxZMghy7zx6LBu511eq5bU5GIEIpirivtz2OPELbEvChCarrUVYj5fk
         5bXA==
X-Gm-Message-State: APjAAAVy/YjqAMRPCMt+pN+ffwW2ssI8EbaJntomRInwJTOAsKe7A1Bd
        PWvrsEdrFXpZ2AAGpzpUa4LlPFzZrnuosNVvlY9SCFDGW9Ui0H48E2pWzvy+OSaEhJi5g9Rez/y
        4ROLDHNp8g7jv
X-Received: by 2002:ac8:4a8a:: with SMTP id l10mr1303326qtq.198.1575317607412;
        Mon, 02 Dec 2019 12:13:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqyJIT5O2PIq2hBfIXIZv6d47L3iz/6K6nfkU3HOvroWZken45053jQWJDbUYGB3TtnE632I4A==
X-Received: by 2002:ac8:4a8a:: with SMTP id l10mr1303310qtq.198.1575317607172;
        Mon, 02 Dec 2019 12:13:27 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id b6sm342410qtp.5.2019.12.02.12.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 12:13:26 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 5/5] KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros
Date:   Mon,  2 Dec 2019 15:13:14 -0500
Message-Id: <20191202201314.543-6-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191202201314.543-1-peterx@redhat.com>
References: <20191202201314.543-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: f467Dvh7NNqsej2Mttk6DA-1
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

Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/ioapic.c   | 11 +++++++----
 arch/x86/kvm/irq_comm.c |  3 ++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 901d85237d1c..1082ca8d11e5 100644
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
+=09=09=09=09 kvm_lapic_irq_dest_mode(e->fields.dest_mode)))
 =09=09return;
=20
 =09new_val =3D kvm_apic_pending_eoi(vcpu, e->fields.vector);
@@ -237,6 +238,7 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong=
 *ioapic_handled_vectors)
 =09struct dest_map *dest_map =3D &ioapic->rtc_status.dest_map;
 =09union kvm_ioapic_redirect_entry *e;
 =09int index;
+=09u16 dm;
=20
 =09spin_lock(&ioapic->lock);
=20
@@ -250,8 +252,9 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, ulong=
 *ioapic_handled_vectors)
 =09=09if (e->fields.trig_mode =3D=3D IOAPIC_LEVEL_TRIG ||
 =09=09    kvm_irq_has_notifier(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index) ||
 =09=09    index =3D=3D RTC_GSI) {
-=09=09=09if (kvm_apic_match_dest(vcpu, NULL, 0,
-=09=09=09             e->fields.dest_id, e->fields.dest_mode) ||
+=09=09=09dm =3D kvm_lapic_irq_dest_mode(e->fields.dest_mode);
+=09=09=09if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
+=09=09=09=09=09=09e->fields.dest_id, dm) ||
 =09=09=09    kvm_apic_pending_eoi(vcpu, e->fields.vector))
 =09=09=09=09__set_bit(e->fields.vector,
 =09=09=09=09=09  ioapic_handled_vectors);
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 5f59e5ebdbed..e89c2160b39f 100644
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
--=20
2.21.0

