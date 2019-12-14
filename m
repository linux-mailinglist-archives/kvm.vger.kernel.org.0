Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8704911F2AD
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 16:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfLNP50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 10:57:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48655 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726757AbfLNP5Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Dec 2019 10:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576339045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MiLtQtAFIR7WooqjFNP7RA7pxFuVPXkVzD1becE3SHU=;
        b=Ll43n+D1FitT+k9IpwIm5jGEFts9W5C5JtNFhj1exmAuN+weshRSKK0942a+hyW2/55DHk
        xovQdD15XPluA7I55lBUNRTfnUkzS8kAiVipe1nKkWCnzwO8aY2R6gesiL0lC7z7+LsGqn
        BJ3w0qyou8NDiPUvK09m1IU3O5WTFSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-GUjV9-9vPW2uksM1tC2tFw-1; Sat, 14 Dec 2019 10:57:21 -0500
X-MC-Unique: GUjV9-9vPW2uksM1tC2tFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B6CA801E53;
        Sat, 14 Dec 2019 15:57:19 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F5D75D6A7;
        Sat, 14 Dec 2019 15:57:09 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Andrew Baumann <Andrew.Baumann@microsoft.com>,
        Aurelien Jarno <aurelien@aurel32.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Joel Stanley <joel@jms.id.au>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Paul Burton <pburton@wavecomp.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/8] hw/arm/xlnx-versal: Use memory_region_add_subregion() when priority is 0
Date:   Sat, 14 Dec 2019 16:56:09 +0100
Message-Id: <20191214155614.19004-4-philmd@redhat.com>
In-Reply-To: <20191214155614.19004-1-philmd@redhat.com>
References: <20191214155614.19004-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is pointless to overlap a memory subregion with priority 0.
Use the simpler memory_region_add_subregion() function.

This patch was produced with the following spatch script:

    @@
    expression region;
    expression offset;
    expression subregion;
    @@
    -memory_region_add_subregion_overlap(region, offset, subregion, 0)
    +memory_region_add_subregion(region, offset, subregion)

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 hw/arm/xlnx-versal-virt.c | 3 +--
 hw/arm/xlnx-versal.c      | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/hw/arm/xlnx-versal-virt.c b/hw/arm/xlnx-versal-virt.c
index 462493c467..901e9ed86c 100644
--- a/hw/arm/xlnx-versal-virt.c
+++ b/hw/arm/xlnx-versal-virt.c
@@ -437,8 +437,7 @@ static void versal_virt_init(MachineState *machine)
=20
     /* Make the APU cpu address space visible to virtio and other
      * modules unaware of muliple address-spaces.  */
-    memory_region_add_subregion_overlap(get_system_memory(),
-                                        0, &s->soc.fpd.apu.mr, 0);
+    memory_region_add_subregion(get_system_memory(), 0, &s->soc.fpd.apu.=
mr);
=20
     s->binfo.ram_size =3D machine->ram_size;
     s->binfo.loader_start =3D 0x0;
diff --git a/hw/arm/xlnx-versal.c b/hw/arm/xlnx-versal.c
index 8b3d8d85b8..538d907f8a 100644
--- a/hw/arm/xlnx-versal.c
+++ b/hw/arm/xlnx-versal.c
@@ -281,8 +281,8 @@ static void versal_realize(DeviceState *dev, Error **=
errp)
     memory_region_init_ram(&s->lpd.mr_ocm, OBJECT(s), "ocm",
                            MM_OCM_SIZE, &error_fatal);
=20
-    memory_region_add_subregion_overlap(&s->mr_ps, MM_OCM, &s->lpd.mr_oc=
m, 0);
-    memory_region_add_subregion_overlap(&s->fpd.apu.mr, 0, &s->mr_ps, 0)=
;
+    memory_region_add_subregion(&s->mr_ps, MM_OCM, &s->lpd.mr_ocm);
+    memory_region_add_subregion(&s->fpd.apu.mr, 0, &s->mr_ps);
 }
=20
 static void versal_init(Object *obj)
--=20
2.21.0

