Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090531522CA
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 00:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgBDXGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 18:06:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50572 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727815AbgBDXGC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 18:06:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580857561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bsEIV4HkyXnRkWkPJ5W4mcgrGAgSdhPmbsihZsZoU2U=;
        b=FIKnX4iXEngNW85JoJ3ZbeS25//DyamqimBzNzTZ7HCSUXOWO+fNb5r7FnWY3zkYmSR9UO
        HGF9x+29Inbyj09PdA40A8FrfKElbnt4jvtRsDRj19MVPKnfI8AGOt2f1bnHQ9ZgFVQqrs
        RqQHQl41Zm6Llh7gPffVTGCyOQl+/zY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-ZnbmZ3ZXNjylbVvsm338Qw-1; Tue, 04 Feb 2020 18:05:57 -0500
X-MC-Unique: ZnbmZ3ZXNjylbVvsm338Qw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96585800D5C;
        Tue,  4 Feb 2020 23:05:55 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 156CD77927;
        Tue,  4 Feb 2020 23:05:52 +0000 (UTC)
Subject: [RFC PATCH 2/7] vfio/pci: Implement match ops
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Tue, 04 Feb 2020 16:05:51 -0700
Message-ID: <158085755166.9445.17279904229413350701.stgit@gimli.home>
In-Reply-To: <158085337582.9445.17682266437583505502.stgit@gimli.home>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 02206162eaa9..6b3e73a33cbf 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1275,6 +1275,13 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 	mutex_unlock(&vdev->igate);
 }
 
+static int vfio_pci_match(void *device_data, char *buf)
+{
+	struct vfio_pci_device *vdev = device_data;
+
+	return strcmp(pci_name(vdev->pdev), buf) ? -ENODEV : 0;
+}
+
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
 	.open		= vfio_pci_open,
@@ -1284,6 +1291,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.write		= vfio_pci_write,
 	.mmap		= vfio_pci_mmap,
 	.request	= vfio_pci_request,
+	.match		= vfio_pci_match,
 };
 
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);

