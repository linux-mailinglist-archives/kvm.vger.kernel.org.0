Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC81164E27
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 19:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgBSSyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 13:54:54 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34307 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726739AbgBSSyy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 13:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582138493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oOG1xcfx/XK/BX/8Fvn0t0Ub7ouo5ivEiSJ+HCOiGlw=;
        b=LnC+7vRtlcMObsBxcS1nv+sGGWelxraaUuDd2U5EzNwD57GF3BmWqVd6ZlKfjQPYsXLWlW
        G78thYe0X1scgqntnsfbYnHeaxtiBHfkOKEEAHnGEcW0aFTG9KQ29Cwpdg/PKA16UW7TlA
        69n9hglIdMuLK4TOnwFWyLrc3F9Gb2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-JTzWQq42OsiK8L_9c_iN8g-1; Wed, 19 Feb 2020 13:54:49 -0500
X-MC-Unique: JTzWQq42OsiK8L_9c_iN8g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 447DD1800D42;
        Wed, 19 Feb 2020 18:54:48 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 284F060BE1;
        Wed, 19 Feb 2020 18:54:45 +0000 (UTC)
Subject: [PATCH v2 7/7] vfio/pci: Cleanup .probe() exit paths
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Wed, 19 Feb 2020 11:54:44 -0700
Message-ID: <158213848474.17090.18286195387831295821.stgit@gimli.home>
In-Reply-To: <158213716959.17090.8399427017403507114.stgit@gimli.home>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 497ecadef2ba..7d410224343a 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1591,8 +1591,8 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
-		vfio_iommu_group_put(group, &pdev->dev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_group_put;
 	}
 
 	vdev->pdev = pdev;
@@ -1603,43 +1603,27 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1665,6 +1649,18 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

