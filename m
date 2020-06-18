Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C8E1FFC19
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 21:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgFRT50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 15:57:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44767 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727909AbgFRT50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 15:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592510245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6uhU1vYx1jeJPqDKTT2tgprjXa1p0qoF4btUD8t6CkI=;
        b=fkY3wk1C319/JiTTjkBF9M9AF+YWMQ+/XsJrOj0IGm6iRB7h63z9zjolpB++osbvzWa5bH
        +dM7qciDR13Uk9m8H3He5SYi7/ezgVGsEjpLDJRyHe+7fcQYreSGeQS/t7ynkDECOpp6VV
        Cyj2FjLyS2785IsALfF5zXNsrb13S3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-FqpFi6npO-ygI0rj1Xk_6A-1; Thu, 18 Jun 2020 15:57:22 -0400
X-MC-Unique: FqpFi6npO-ygI0rj1Xk_6A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05F57107ACCD;
        Thu, 18 Jun 2020 19:57:22 +0000 (UTC)
Received: from gimli.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 838AB5BAC2;
        Thu, 18 Jun 2020 19:57:18 +0000 (UTC)
Subject: [PATCH] vfio: Cleanup allowed driver naming
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Date:   Thu, 18 Jun 2020 13:57:18 -0600
Message-ID: <159251018108.23973.14170848139642305203.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change, avoid non-inclusive naming schemes.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 580099afeaff..833da937b7fc 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -627,9 +627,9 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
  * that error notification via MSI can be affected for platforms that handle
  * MSI within the same IOVA space as DMA.
  */
-static const char * const vfio_driver_whitelist[] = { "pci-stub" };
+static const char * const vfio_driver_allowed[] = { "pci-stub" };
 
-static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
+static bool vfio_dev_driver_allowed(struct device *dev, struct device_driver *drv)
 {
 	if (dev_is_pci(dev)) {
 		struct pci_dev *pdev = to_pci_dev(dev);
@@ -638,8 +638,8 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
 			return true;
 	}
 
-	return match_string(vfio_driver_whitelist,
-			    ARRAY_SIZE(vfio_driver_whitelist),
+	return match_string(vfio_driver_allowed,
+			    ARRAY_SIZE(vfio_driver_allowed),
 			    drv->name) >= 0;
 }
 
@@ -648,7 +648,7 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
  * one of the following states:
  *  - driver-less
  *  - bound to a vfio driver
- *  - bound to a whitelisted driver
+ *  - bound to an otherwise allowed driver
  *  - a PCI interconnect device
  *
  * We use two methods to determine whether a device is bound to a vfio
@@ -674,7 +674,7 @@ static int vfio_dev_viable(struct device *dev, void *data)
 	}
 	mutex_unlock(&group->unbound_lock);
 
-	if (!ret || !drv || vfio_dev_whitelisted(dev, drv))
+	if (!ret || !drv || vfio_dev_driver_allowed(dev, drv))
 		return 0;
 
 	device = vfio_group_get_device(group, dev);

