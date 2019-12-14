Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBC011F2AE
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 16:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfLNP5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 10:57:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29790 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726757AbfLNP5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Dec 2019 10:57:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576339056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7SlorlqSNo6p31H7HgBYKxDoBhr5Y5T4+whsDnKxCwo=;
        b=WkaGCgLA5aQ/4Dwf7BpSTUQuQD0OqJ/DknzWKRSZ0Sp1QhADzX88nY/0LjJDUpLQjhR5zI
        XB8yCAntSwZxnUwk3Up2xFOHRqxREfHDd7GAoSTtG7YPxWyW+4o2IwMEKS0yhy9sQ1LsAF
        9QUpCc0P6Mdq024wMUxvBOoC4tgc4Hc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-uNUZ_QilNLChRElt76KaAQ-1; Sat, 14 Dec 2019 10:57:34 -0500
X-MC-Unique: uNUZ_QilNLChRElt76KaAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61F701852E2A;
        Sat, 14 Dec 2019 15:57:32 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0764F5D6A7;
        Sat, 14 Dec 2019 15:57:19 +0000 (UTC)
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
Subject: [PATCH 4/8] hw/i386/intel_iommu: Use memory_region_add_subregion when priority is 0
Date:   Sat, 14 Dec 2019 16:56:10 +0100
Message-Id: <20191214155614.19004-5-philmd@redhat.com>
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
 hw/i386/intel_iommu.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 43c94b993b..afa7e07b05 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3363,11 +3363,9 @@ VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *=
s, PCIBus *bus, int devfn)
          * switch between DMAR & noDMAR by enable/disable
          * corresponding sub-containers
          */
-        memory_region_add_subregion_overlap(&vtd_dev_as->root, 0,
-                                            MEMORY_REGION(&vtd_dev_as->i=
ommu),
-                                            0);
-        memory_region_add_subregion_overlap(&vtd_dev_as->root, 0,
-                                            &vtd_dev_as->nodmar, 0);
+        memory_region_add_subregion(&vtd_dev_as->root, 0,
+                                    MEMORY_REGION(&vtd_dev_as->iommu));
+        memory_region_add_subregion(&vtd_dev_as->root, 0, &vtd_dev_as->n=
odmar);
=20
         vtd_switch_address_space(vtd_dev_as);
     }
@@ -3764,8 +3762,7 @@ static void vtd_realize(DeviceState *dev, Error **e=
rrp)
     memory_region_init_alias(&s->mr_sys_alias, OBJECT(s),
                              "vtd-sys-alias", get_system_memory(), 0,
                              memory_region_size(get_system_memory()));
-    memory_region_add_subregion_overlap(&s->mr_nodmar, 0,
-                                        &s->mr_sys_alias, 0);
+    memory_region_add_subregion(&s->mr_nodmar, 0, &s->mr_sys_alias);
     memory_region_add_subregion_overlap(&s->mr_nodmar,
                                         VTD_INTERRUPT_ADDR_FIRST,
                                         &s->mr_ir, 1);
--=20
2.21.0

