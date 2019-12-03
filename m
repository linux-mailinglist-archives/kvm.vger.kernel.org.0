Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B872B110308
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfLCQ7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:59:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38657 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727287AbfLCQ7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 11:59:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575392358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CokILJJqXdrHsv0tjIebaIYM+c7ZHf6WdfuYQQUg9IQ=;
        b=FsgU13+IIBIcOL+HuIboMe54DBKzdFnlf38fswG+IvCmvipPkt2j8cdrFub+RvznYBF59k
        qxrsg4A1kb+2Hbb2kVo1ZBMbQvST22tN/Fdp8PnldYm/R5iF+8TbtpiuHTqExObFBGb3no
        i77ezpnKUzi2qCs+sCmMfLnTKquB3zY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-dpJotGpbMdy_N_UBCgOtrw-1; Tue, 03 Dec 2019 11:59:15 -0500
Received: by mail-qv1-f72.google.com with SMTP id g33so2588945qvd.7
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 08:59:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rby7OAxJWRGIY59KJwhRvRc4bijIHbG4l5NvhzcAxK8=;
        b=dGRf/6UPgbM+p/W3w4CyJrmPAS0kY32jCUjUC8B3c+2ldjpyrQjWJYT6U4Wt4sTEf+
         euWORAlZ1Yyw1tz6qrjp8K5XURVZxxUy4LLlC7JQuLzcOtA312fOvleueEhZ5763Kq9E
         UBRVahiVToLNrqy8xk7UjGonkZPkN/NqB56Ug8qoTxsnCqQMz6UyGghOsbQ7yIcTjI0I
         yRAJCvu1Zc/8f+UqunIrIX3ES06yRuQB2LUj7npp0mnDW4rAnR+ktS6xcTAq+v+qNhiw
         utisgD3A7Fm1/o3g/wrCuN9qlkn5aPRODAbLYWA5RIg3y8N2Kn1/CPW3z/bhyHSfkClc
         /qDg==
X-Gm-Message-State: APjAAAXUwFo8x/1vUxIg0UTuL7U9ToojFFN5p09MWkw/0udv2FkB2fJJ
        bgnxiyKfMvHWjPKeWgTcOJt3NEwlFRgU2ARMLfwWXKMdzsbMLb/j82X7Ch6v0VHkYhtzuQP1xoV
        L6Pl9bwEOkG3t
X-Received: by 2002:a05:620a:2010:: with SMTP id c16mr5938044qka.386.1575392354612;
        Tue, 03 Dec 2019 08:59:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQfVoMDRqDnxNfwvnqyaXyIDMNqHRLocnfax32ITgCaGfDAssMZDEsbnRydHQ5WTxKScDc7A==
X-Received: by 2002:a05:620a:2010:: with SMTP id c16mr5938019qka.386.1575392354373;
        Tue, 03 Dec 2019 08:59:14 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a16sm482585qkn.48.2019.12.03.08.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:59:13 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 6/6] KVM: X86: Conert the last users of "shorthand = 0" to use macros
Date:   Tue,  3 Dec 2019 11:59:03 -0500
Message-Id: <20191203165903.22917-7-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191203165903.22917-1-peterx@redhat.com>
References: <20191203165903.22917-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: dpJotGpbMdy_N_UBCgOtrw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the last users of "shorthand =3D 0" to use APIC_DEST_NOSHORT.

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

