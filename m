Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FE72114AD
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 23:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgGAVCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 17:02:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725535AbgGAVCl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 17:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593637360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/2cNlIlhLsfre0+HjP1RIAKjqNYYQUIp8pAZWmFwfi4=;
        b=IPTjrwRLKgX5vGqlQUHuEKWboqsYd1OItQweRMqzPAZoQHM7+UQ2dMuOgu5AvXWaV4J4rc
        UbbM/T7uBhNK2JSYlFTyLpBZeKM0PUs+bqVnfsl4N7xy9u0x6HFrijVLMGUIoBbC2s8Bq9
        iPp4/z6RGVp6FjkmqrJPo+Ibl0/IfTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-Zr6jlFD3OeGcr5l350Wb2g-1; Wed, 01 Jul 2020 17:02:38 -0400
X-MC-Unique: Zr6jlFD3OeGcr5l350Wb2g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55E07186A200;
        Wed,  1 Jul 2020 21:02:37 +0000 (UTC)
Received: from gimli.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3654A60CD1;
        Wed,  1 Jul 2020 21:02:34 +0000 (UTC)
Subject: [PATCH] vfio/pci: Add Intel X550 to hidden INTx devices
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Date:   Wed, 01 Jul 2020 15:02:33 -0600
Message-ID: <159363734524.19359.5271945196793749675.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel document 333717-008, "Intel® Ethernet Controller X550
Specification Update", version 2.7, dated June 2020, includes errata
#22, added in version 2.1, May 2016, indicating X550 NICs suffer from
the same implementation deficiency as the 700-series NICs:

"The Interrupt Status bit in the Status register of the PCIe
 configuration space is not implemented and is not set as described
 in the PCIe specification."

Without the interrupt status bit, vfio-pci cannot determine when
these devices signal INTx.  They are therefore added to the nointx
quirk.

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f634c81998bb..9968dc0f87a3 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -207,6 +207,8 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 		case 0x1580 ... 0x1581:
 		case 0x1583 ... 0x158b:
 		case 0x37d0 ... 0x37d2:
+		/* X550 */
+		case 0x1563:
 			return true;
 		default:
 			return false;

