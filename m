Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD311030A
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfLCQ7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:59:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23956 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727247AbfLCQ7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 11:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575392354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EbbDA8eBzmrrmvpNYXesODqmal32f0agXVmci0jBwiY=;
        b=WWUihS3+FbM84emteup784ANuWqQR/6Dn/+94P7F9FH9t3qZ3CgCHRaDdH+O6qIHmBMu7n
        Znihz96exwCo8qdzHneZG+2JNaVysIM2Ceu7ew7RWuuu8JH78C8+3O0fSNA0D1NkjdYMUa
        YyjheS+ooBG33dVhOgTA2d/+wvP+rFs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-Lu4sUoE0NGSUP-C6W9gisQ-1; Tue, 03 Dec 2019 11:59:13 -0500
Received: by mail-qk1-f199.google.com with SMTP id e23so2579620qka.23
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 08:59:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X1aOoFKR3ey7vYZ+BVQXR0mg8IAiU6yM63K4W6de1EU=;
        b=lykTzv7FXLqLCINlGEk2KF1BPUfyKRoolC6L85f5A88GyzBIoDXm7lSs2ZEVFy/e1u
         IDZNvHnj4qsoFwr2queKAw0Cve6qF8KOvQUbUQlToTG0/xjcAUpYPHXeIJrnsr581j71
         Sc71AKkJ6KMrvaaK648+4u4nkFFX6X2VVt/s3qatHOTHDT3vUrfxvHRfuHzqbwCaW7RL
         7lfctvovQ+3vordEm9/xtmGAnRfQ0OS8DlsNeUdwfakag8DhnJa/dXrO05dHCMbk7RhJ
         ktNE25sBCVC4bpCXwreba/6GK5kFwztp8o7FmfMRnPdmfFldmIv9cB4F2Ncd+P13DqV7
         ZAzQ==
X-Gm-Message-State: APjAAAWR6u3ED2um4Kb0DMsN8d/NMwO6GCbUp/7pDB44XKSyGOyD+L+t
        UhlkWZw54LuUvVsO938nVqm+u5blzKBta4sjVqpbxzuAHFutl+dJKpUap7vILLmD3gixeOtwXlc
        VWuckdBSLjx0J
X-Received: by 2002:a05:6214:6ad:: with SMTP id s13mr6005916qvz.208.1575392352968;
        Tue, 03 Dec 2019 08:59:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqzGh7RoR7bXUGd1EORpILas9d+Vrxhpz2zfR0xOT0S88RHqKjgS/dHqRB0sUoTvPCbET7czXw==
X-Received: by 2002:a05:6214:6ad:: with SMTP id s13mr6005894qvz.208.1575392352740;
        Tue, 03 Dec 2019 08:59:12 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a16sm482585qkn.48.2019.12.03.08.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:59:11 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 5/6] KVM: X86: Fix callers of kvm_apic_match_dest() to use correct macros
Date:   Tue,  3 Dec 2019 11:59:02 -0500
Message-Id: <20191203165903.22917-6-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191203165903.22917-1-peterx@redhat.com>
References: <20191203165903.22917-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: Lu4sUoE0NGSUP-C6W9gisQ-1
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
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/ioapic.c   | 11 +++++++----
 arch/x86/kvm/irq_comm.c |  3 ++-
 2 files changed, 9 insertions(+), 5 deletions(-)

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
--=20
2.21.0

