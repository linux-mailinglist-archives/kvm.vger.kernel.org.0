Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B553911F2B0
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 16:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfLNP6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 10:58:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60239 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726802AbfLNP6C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Dec 2019 10:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576339081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LRDNXmBjVfes+8mRt7KTS+s8kaJK3nwCAodGqedjxW4=;
        b=RT2uAExzwj8fwuCWNwuWjj8NxuW6xnFndTijxeKxu3PThXPIxienBBbTFOXVoIEkoyNgeC
        ECJEgs/ZOtUPePgVznkBktVAgpzHvvyDG7Ik1uTYJQhh0cFMP3qFlWZo8MhLrTfKlg1R3N
        woon5/3M/vzW24YX7FmgmixnIS5n1lA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-InHhu3ggMleXW3tOq5yXNw-1; Sat, 14 Dec 2019 10:57:59 -0500
X-MC-Unique: InHhu3ggMleXW3tOq5yXNw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1EA11852E2D;
        Sat, 14 Dec 2019 15:57:56 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88D2B5D6A7;
        Sat, 14 Dec 2019 15:57:42 +0000 (UTC)
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
Subject: [PATCH 6/8] hw/vfio/pci: Use memory_region_add_subregion() when priority is 0
Date:   Sat, 14 Dec 2019 16:56:12 +0100
Message-Id: <20191214155614.19004-7-philmd@redhat.com>
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
 hw/vfio/pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 2d40b396f2..74b1eb7ddc 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -1095,8 +1095,7 @@ static void vfio_sub_page_bar_update_mapping(PCIDev=
ice *pdev, int bar)
     memory_region_set_size(mmap_mr, size);
     if (size !=3D vdev->bars[bar].size && memory_region_is_mapped(base_m=
r)) {
         memory_region_del_subregion(r->address_space, base_mr);
-        memory_region_add_subregion_overlap(r->address_space,
-                                            bar_addr, base_mr, 0);
+        memory_region_add_subregion(r->address_space, bar_addr, base_mr)=
;
     }
=20
     memory_region_transaction_commit();
--=20
2.21.0

