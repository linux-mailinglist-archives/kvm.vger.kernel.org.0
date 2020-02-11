Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC0D159CD1
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 00:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgBKXG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 18:06:26 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53874 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728003AbgBKXGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 18:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581462384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zl42YFae7shP7qDZsLmjotiywH2QivsM2n43EHp8HXI=;
        b=Bk5GgBdPSC6uVMAV4OMlwW14kveqI5szLly0GuwgmBSpUufkb23+q5VwMMs6Lz2XWUIZMb
        AnfISdQmlgnQKhwWbA1PKl1ILrU+Na4QBUWzqRwNw0wM1dQoRTBdlLHMJbEtq6cBXOwAkb
        Z+QOP88D7WpQoaL3m5Za9bHmfDf9EkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-63tPqKG0PkeYD-iktDgy0w-1; Tue, 11 Feb 2020 18:06:22 -0500
X-MC-Unique: 63tPqKG0PkeYD-iktDgy0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D812800D4C;
        Tue, 11 Feb 2020 23:06:20 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6ED146E40A;
        Tue, 11 Feb 2020 23:06:17 +0000 (UTC)
Subject: [PATCH 7/7] vfio/pci: Cleanup .probe() exit paths
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Tue, 11 Feb 2020 16:06:17 -0700
Message-ID: <158146237704.16827.13577826727613048764.stgit@gimli.home>
In-Reply-To: <158145472604.16827.15751375540102298130.stgit@gimli.home>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cleanup is getting a tad long.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |   54 ++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a88b45ce1cc7..fff49dfc742a 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1520,8 +1520,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
-		vfio_iommu_group_put(group, &pdev->dev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_group_put;
 	}
 
 	vdev->pdev = pdev;
@@ -1532,43 +1532,27 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
-	if (ret) {
-		vfio_iommu_group_put(group, &pdev->dev);
-		kfree(vdev);
-		return ret;
-	}
+	if (ret)
+		goto out_free;
 
 	ret = vfio_pci_reflck_attach(vdev);
-	if (ret) {
-		vfio_del_group_dev(&pdev->dev);
-		vfio_iommu_group_put(group, &pdev->dev);
-		kfree(vdev);
-		return ret;
-	}
+	if (ret)
+		goto out_del_group_dev;
 
 	if (pdev->is_physfn) {
 		vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
 		if (!vdev->vf_token) {
-			vfio_pci_reflck_put(vdev->reflck);
-			vfio_del_group_dev(&pdev->dev);
-			vfio_iommu_group_put(group, &pdev->dev);
-			kfree(vdev);
-			return -ENOMEM;
-		}
-
-		vdev->nb.notifier_call = vfio_pci_bus_notifier;
-		ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
-		if (ret) {
-			kfree(vdev->vf_token);
-			vfio_pci_reflck_put(vdev->reflck);
-			vfio_del_group_dev(&pdev->dev);
-			vfio_iommu_group_put(group, &pdev->dev);
-			kfree(vdev);
-			return ret;
+			ret = -ENOMEM;
+			goto out_reflck;
 		}
 
 		mutex_init(&vdev->vf_token->lock);
 		uuid_gen(&vdev->vf_token->uuid);
+
+		vdev->nb.notifier_call = vfio_pci_bus_notifier;
+		ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
+		if (ret)
+			goto out_vf_token;
 	}
 
 	if (vfio_pci_is_vga(pdev)) {
@@ -1594,6 +1578,18 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	return ret;
+
+out_vf_token:
+	kfree(vdev->vf_token);
+out_reflck:
+	vfio_pci_reflck_put(vdev->reflck);
+out_del_group_dev:
+	vfio_del_group_dev(&pdev->dev);
+out_free:
+	kfree(vdev);
+out_group_put:
+	vfio_iommu_group_put(group, &pdev->dev);
+	return ret;
 }
 
 static void vfio_pci_remove(struct pci_dev *pdev)

