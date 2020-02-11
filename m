Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0ECF159CC2
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 00:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgBKXFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 18:05:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46788 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727799AbgBKXFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 18:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581462341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=egySVQn95d75jOeqVctft40gVEWO2D/Q7wNGOIZKyvo=;
        b=Y6DFgr92XED91DKSEhneElZN2Dr6Tv+XuqI/brLfS6ICSGqgN5RmuggTj0ezRbQ+xMcs1l
        iX3On7lVWOBwYR/ppjJhMgc15IIu77hPGFC/BlKvz7FBXUG40CoD55PuMfBlz38bWMUiZ3
        PV8XVT9ZSXSwmefgMeeWvlCeqGA6z8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-JMS2qA9-Nkez43ezurFWCA-1; Tue, 11 Feb 2020 18:05:39 -0500
X-MC-Unique: JMS2qA9-Nkez43ezurFWCA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A559B107ACC4;
        Tue, 11 Feb 2020 23:05:37 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DDCD5C1B2;
        Tue, 11 Feb 2020 23:05:34 +0000 (UTC)
Subject: [PATCH 2/7] vfio/pci: Implement match ops
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Tue, 11 Feb 2020 16:05:34 -0700
Message-ID: <158146233422.16827.5520548241096752615.stgit@gimli.home>
In-Reply-To: <158145472604.16827.15751375540102298130.stgit@gimli.home>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This currently serves the same purpose as the default implementation
but will be expanded for additional functionality.

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

