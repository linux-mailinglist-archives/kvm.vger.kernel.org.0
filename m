Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C38376A29
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 20:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhEGSyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 14:54:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhEGSyV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 14:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620413600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=to4F3RSSacx66bqGoR4rednsO9qjieECmlHxCX3pgUA=;
        b=Tx1412wWo3TLsN86I5AvfRVIERuv1hZfBKuDtKnb77n9hufjvfRFKGu3XeVBNok9ep2nRR
        2bhP0KgO3uMo9uuGNLi3Z55etIosO15TC3XFRU7La32JHQXsD/jmD39rI6oVsfWGtYmHi/
        PUEq1C+Pn1MEEiJSRMmuvmiTDMUKwVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-taiXcfulPziogsO5EiL8Vg-1; Fri, 07 May 2021 14:53:18 -0400
X-MC-Unique: taiXcfulPziogsO5EiL8Vg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3097100A67C;
        Fri,  7 May 2021 18:53:17 +0000 (UTC)
Received: from [172.30.42.188] (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96C805D74A;
        Fri,  7 May 2021 18:53:17 +0000 (UTC)
Subject: [PATCH] vfio/pci: Sanity check IGD OpRegion Size
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     tkffaul@outlook.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 07 May 2021 12:53:17 -0600
Message-ID: <162041357421.21800.16214130780777455390.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The size field of the IGD OpRegion table is supposed to indicate table
size in KB, but we've seen at least one report of a BIOS that appears
to incorrectly report size in bytes.  The default size is 8 (*1024 =
8KB), but an incorrect implementation may report 8192 (*1024 = 8MB)
and can cause a variety of mapping errors.

It's believed that 8MB would be an implausible, if not absurd, actual
size, so we can probably be pretty safe in assuming this is a BIOS bug
where the intended size is likely 8KB.

Reported-by: Travis Faulhaber <tkffaul@outlook.com>
Tested-by: Travis Faulhaber <tkffaul@outlook.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_igd.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 228df565e9bc..c89a4797cd18 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -86,7 +86,16 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 		return -EINVAL;
 	}
 
-	size *= 1024; /* In KB */
+	/*
+	 * The OpRegion size field is specified as size in KB, but there have been
+	 * user reports where this field appears to report size in bytes.  If we
+	 * read 8192, assume this is the case.
+	 */
+	if (size == OPREGION_SIZE)
+		pci_warn(vdev->pdev,
+			 "BIOS Bug, IGD OpRegion reports invalid size, assuming default 8KB\n");
+	else
+		size *= 1024; /* In KB */
 
 	/*
 	 * Support opregion v2.1+


