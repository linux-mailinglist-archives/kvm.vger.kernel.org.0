Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78323164E15
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 19:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgBSSyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 13:54:14 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51140 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726875AbgBSSyN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 13:54:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582138452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JvxF3s2C8+BX1cZ8mMuQEhyQrnMXU9w82UDzhSCaiB8=;
        b=CISmMG5cLs2qzfer3eKUN80Kjx/zm90PNUkUIX+ZKkmcaB0jejfK4qMKs4rEDYab95UITd
        9Sp8Pw/fUpLbDmiVkprSkZihjqmkTqPeKY94PJOxN3IH/HAZrz8aiSkqmWUNFrKRU+gqiE
        MWQGKiAIsk9jDpZLW56qORtE53jDEas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-Qz605BC0PPqDmW3OXCPl2Q-1; Wed, 19 Feb 2020 13:54:08 -0500
X-MC-Unique: Qz605BC0PPqDmW3OXCPl2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E61B800D50;
        Wed, 19 Feb 2020 18:54:07 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D7AE10001AE;
        Wed, 19 Feb 2020 18:54:04 +0000 (UTC)
Subject: [PATCH v2 2/7] vfio/pci: Implement match ops
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Wed, 19 Feb 2020 11:54:03 -0700
Message-ID: <158213844382.17090.14303032019487051956.stgit@gimli.home>
In-Reply-To: <158213716959.17090.8399427017403507114.stgit@gimli.home>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This currently serves the same purpose as the default implementation
but will be expanded for additional functionality.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 379a02c36e37..2ec6c31d0ab0 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1278,6 +1278,13 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 	mutex_unlock(&vdev->igate);
 }
 
+static int vfio_pci_match(void *device_data, char *buf)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return !strcmp(pci_name(vdev->pdev), buf);
+}
+
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
 	.open		= vfio_pci_open,
@@ -1287,6 +1294,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.write		= vfio_pci_write,
 	.mmap		= vfio_pci_mmap,
 	.request	= vfio_pci_request,
+	.match		= vfio_pci_match,
 };
 
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);

