Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8301F1039BB
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 13:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbfKTMMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 07:12:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729202AbfKTMMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 07:12:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574251952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KJxhVxnKLCqBwMe6QDFuzbqbvStQBH6WEDU+lUrFWvk=;
        b=aSBoPSfXa5gJ6kLgUz9nWk9ZiUdmiJS5CIQsFREk6J74TgTkBmB/Pl5mxZvSPkzy7MS0Zs
        Qo/o4595/e4ky3GTPydk+tr8QmEHATFOx6angxZxRbVnRuUUCOtirCAGMU2vZ+Ay9cq/PO
        qWZt6s/7vKCav+qdDe6jSv/cSwGuff4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-S82Tcyr9MOmDC_YEI1ZwyA-1; Wed, 20 Nov 2019 07:12:31 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14F24107ACC7;
        Wed, 20 Nov 2019 12:12:29 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB8AC3483A;
        Wed, 20 Nov 2019 12:12:24 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH] KVM: x86: Zero the IOAPIC scan request dest vCPUs bitmap
Date:   Wed, 20 Nov 2019 07:12:24 -0500
Message-Id: <20191120121224.9850-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: S82Tcyr9MOmDC_YEI1ZwyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Not zeroing the bitmap used for identifying the destination vCPUs for an
IOAPIC scan request in fixed delivery mode could lead to waking up unwanted
vCPUs. This patch zeroes the vCPU bitmap before passing it to
kvm_bitmap_or_dest_vcpus(), which is responsible for setting the bitmap
with the bits corresponding to the destination vCPUs.

Fixes: 7ee30bc132c6("KVM: x86: deliver KVM IOAPIC scan request to target vC=
PUs")
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 arch/x86/kvm/ioapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index ce30ef23c86b..9fd2dd89a1c5 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -332,6 +332,7 @@ static void ioapic_write_indirect(struct kvm_ioapic *io=
apic, u32 val)
 =09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
 =09=09=09irq.dest_id =3D e->fields.dest_id;
 =09=09=09irq.dest_mode =3D e->fields.dest_mode;
+=09=09=09bitmap_zero(&vcpu_bitmap, 16);
 =09=09=09kvm_bitmap_or_dest_vcpus(ioapic->kvm, &irq,
 =09=09=09=09=09=09 &vcpu_bitmap);
 =09=09=09if (old_dest_mode !=3D e->fields.dest_mode ||
--=20
2.18.1

