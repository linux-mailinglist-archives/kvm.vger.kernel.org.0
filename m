Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72CA911356F
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfLDTHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:07:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41112 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728904AbfLDTHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 14:07:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575486455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQ4VjfIYrglflf3rJiON69ppSn0JgIlW3dfwal7bm4Y=;
        b=EeRA3D41wXEQiRMiEyMJexXrOYJdn4XqGJeffTMr6CERsxxAlkZpvY2MgqFTtffUu8WgbW
        WpBpnON6bTnHErrINyfrtUtw/biqF8g6i5sd9Hxq8rZ4wFKrXEvcCZbU9nEfqzylpTfAla
        /O08fG3pEHvgmRhF6CXT+2HqBE0anPY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-EbTqCLGlOtWVaW02Hf5MlA-1; Wed, 04 Dec 2019 14:07:33 -0500
Received: by mail-qv1-f72.google.com with SMTP id c22so488321qvc.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 11:07:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wqX1WpDnk793hPGykZVwJa0dz2ySQCsCHFOl+w7F7+Q=;
        b=mge7paRSg32UNbXkyvGiyFyViFIddtkxIN1DWbiRjROD/zKUe7BHnbOt/SlbPutxIR
         pQE8hicvaF+GKtqDB3LYStF5IY3EhmmE9y1SJ5bpJi6GPbOnUpy3B53C5Xm/TG1WHl1E
         alYwU2XYGp8PuKVdUeh52TnXpaooxaoNFQiw5lsyPZRW8zL/zvb/4sEthqfzKw99IBZv
         HUyDOOBA1qEd29p87l7BvIbzTTUzbuz/dB97kACl7ngZqLOhllxmyvHjonXAgqycxZZ4
         cLPR4O0KsvcTVVfyv6KDPvKHDzxDbVUr5Hzd/g0Iht+cp9hTbEivVKwWiTKv6Vr2pF1S
         1ZPg==
X-Gm-Message-State: APjAAAWPaE8ODVc4WOBKzOuTZxbEGRvt/MS7CtLx5Sg4Rn85Sqz6qkpl
        mejV0XaC9qTyvsZ3ep8wV08AhBzw84SVEzmlGRlACqfw2WFcYW0Jr2z2q5HWuLQ09IDFE+Riw/l
        EF4jnYH55aG/9
X-Received: by 2002:ad4:4908:: with SMTP id bh8mr4161476qvb.251.1575486452789;
        Wed, 04 Dec 2019 11:07:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqwEvT/Ded38f7safdU21KIFiL1aXou5MYGRU1P1kBbugrZwGKwljjsV/vT2lZcdGelzIUricw==
X-Received: by 2002:ad4:4908:: with SMTP id bh8mr4161445qvb.251.1575486452527;
        Wed, 04 Dec 2019 11:07:32 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id y18sm4072126qtn.11.2019.12.04.11.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:07:31 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v5 6/6] KVM: X86: Conert the last users of "shorthand = 0" to use macros
Date:   Wed,  4 Dec 2019 14:07:21 -0500
Message-Id: <20191204190721.29480-7-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191204190721.29480-1-peterx@redhat.com>
References: <20191204190721.29480-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: EbTqCLGlOtWVaW02Hf5MlA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the last users of "shorthand =3D 0" to use APIC_DEST_NOSHORT.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/ioapic.c   | 4 ++--
 arch/x86/kvm/irq_comm.c | 2 +-
 arch/x86/kvm/x86.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index f53daeaaeb37..77538fd77dc2 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -330,7 +330,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 =09=09if (e->fields.delivery_mode =3D=3D APIC_DM_FIXED) {
 =09=09=09struct kvm_lapic_irq irq;
=20
-=09=09=09irq.shorthand =3D 0;
+=09=09=09irq.shorthand =3D APIC_DEST_NOSHORT;
 =09=09=09irq.vector =3D e->fields.vector;
 =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
 =09=09=09irq.dest_id =3D e->fields.dest_id;
@@ -379,7 +379,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, in=
t irq, bool line_status)
 =09irqe.trig_mode =3D entry->fields.trig_mode;
 =09irqe.delivery_mode =3D entry->fields.delivery_mode << 8;
 =09irqe.level =3D 1;
-=09irqe.shorthand =3D 0;
+=09irqe.shorthand =3D APIC_DEST_NOSHORT;
 =09irqe.msi_redir_hint =3D false;
=20
 =09if (irqe.trig_mode =3D=3D IOAPIC_EDGE_TRIG)
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 7d083f71fc8e..9d711c2451c7 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -121,7 +121,7 @@ void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel=
_irq_routing_entry *e,
 =09irq->msi_redir_hint =3D ((e->msi.address_lo
 =09=09& MSI_ADDR_REDIRECTION_LOWPRI) > 0);
 =09irq->level =3D 1;
-=09irq->shorthand =3D 0;
+=09irq->shorthand =3D APIC_DEST_NOSHORT;
 }
 EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b00d662dc14..f6d778436e15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7355,7 +7355,7 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsig=
ned long flags, int apicid)
 {
 =09struct kvm_lapic_irq lapic_irq;
=20
-=09lapic_irq.shorthand =3D 0;
+=09lapic_irq.shorthand =3D APIC_DEST_NOSHORT;
 =09lapic_irq.dest_mode =3D APIC_DEST_PHYSICAL;
 =09lapic_irq.level =3D 0;
 =09lapic_irq.dest_id =3D apicid;
--=20
2.21.0

