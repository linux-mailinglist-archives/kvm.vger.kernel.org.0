Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF6520155B
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 18:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404741AbgFSQV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 12:21:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29133 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390662AbgFSPAu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592578846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZKQQ3TSN3kM3Cb8dTgCKmUaoa0Mo3XfrlHvCQ5ywFhw=;
        b=f1BTs/NPzetpirbEi3J7FSXEXl0YMZQxalxi79y8DuBQA6iaQ6euChvam0dEHSj0Q5wJZG
        Wt/dJqFNFsVL/iERWBIN8siBcNJpiWL+rRGbvVuJQxoqJe5Ii174ZWEVsZXNj31YDwrqVY
        NoXXWKkEaiPCoK2Rxs6Iu9/wurtU9zY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-tYa_nW_TODO6rlo-ACXqqw-1; Fri, 19 Jun 2020 11:00:43 -0400
X-MC-Unique: tYa_nW_TODO6rlo-ACXqqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A757F107ACF4;
        Fri, 19 Jun 2020 15:00:42 +0000 (UTC)
Received: from gimli.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63A695C1D0;
        Fri, 19 Jun 2020 15:00:39 +0000 (UTC)
Subject: [PATCH v2] vfio: Cleanup allowed driver naming
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Date:   Fri, 19 Jun 2020 09:00:39 -0600
Message-ID: <159257872055.20595.16949396190256140801.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change, avoid non-inclusive naming schemes.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: Wrap vfio_dev_driver_allowed to 80 column for consistency,
    checkpatch no longer warns about this.

 drivers/vfio/vfio.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 580099afeaff..262ab0efd06c 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -627,9 +627,10 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
  * that error notification via MSI can be affected for platforms that handle
  * MSI within the same IOVA space as DMA.
  */
-static const char * const vfio_driver_whitelist[] = { "pci-stub" };
+static const char * const vfio_driver_allowed[] = { "pci-stub" };
 
-static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
+static bool vfio_dev_driver_allowed(struct device *dev,
+				    struct device_driver *drv)
 {
 	if (dev_is_pci(dev)) {
 		struct pci_dev *pdev = to_pci_dev(dev);
@@ -638,8 +639,8 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
 			return true;
 	}
 
-	return match_string(vfio_driver_whitelist,
-			    ARRAY_SIZE(vfio_driver_whitelist),
+	return match_string(vfio_driver_allowed,
+			    ARRAY_SIZE(vfio_driver_allowed),
 			    drv->name) >= 0;
 }
 
@@ -648,7 +649,7 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
  * one of the following states:
  *  - driver-less
  *  - bound to a vfio driver
- *  - bound to a whitelisted driver
+ *  - bound to an otherwise allowed driver
  *  - a PCI interconnect device
  *
  * We use two methods to determine whether a device is bound to a vfio
@@ -674,7 +675,7 @@ static int vfio_dev_viable(struct device *dev, void *data)
 	}
 	mutex_unlock(&group->unbound_lock);
 
-	if (!ret || !drv || vfio_dev_whitelisted(dev, drv))
+	if (!ret || !drv || vfio_dev_driver_allowed(dev, drv))
 		return 0;
 
 	device = vfio_group_get_device(group, dev);

