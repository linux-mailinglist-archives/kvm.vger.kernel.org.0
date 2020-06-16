Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95931FC0FC
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 23:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgFPV0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 17:26:45 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37961 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726134AbgFPV0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 17:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592342803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rfjyihg61U3ImXhyN/RZdOnqUBmVbpAphX1IIssGqq4=;
        b=jMOd9W8OZVUfbqdp/+zCeeWqPtazUN7tG6pOiknb4fD1/E5QRuM6T6f/m763lDxLnAxDBp
        I0QZlK0UcrEnLSPT/U2dHPs6mWSGwYBPIeTr562K43AzYylteLw5cZt4JusRdh9y3RnnW9
        XQrbs5OMYc3KKDLlRlNESBi3y4jtUEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-iB73ybuIMlKdSBblkDt8xw-1; Tue, 16 Jun 2020 17:26:41 -0400
X-MC-Unique: iB73ybuIMlKdSBblkDt8xw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 853891512E0;
        Tue, 16 Jun 2020 21:26:40 +0000 (UTC)
Received: from gimli.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C52A5D9D3;
        Tue, 16 Jun 2020 21:26:37 +0000 (UTC)
Subject: [PATCH] vfio/pci: Clear error and request eventfd ctx after
 releasing
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com, dwagner@suse.de, cai@lca.pw
Date:   Tue, 16 Jun 2020 15:26:36 -0600
Message-ID: <159234276956.31057.6902954364435481688.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next use of the device will generate an underflow from the
stale reference.

Cc: Qian Cai <cai@lca.pw>
Fixes: 1518ac272e78 ("vfio/pci: fix memory leaks of eventfd ctx")
Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7c0779018b1b..f634c81998bb 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -521,10 +521,14 @@ static void vfio_pci_release(void *device_data)
 		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
-		if (vdev->err_trigger)
+		if (vdev->err_trigger) {
 			eventfd_ctx_put(vdev->err_trigger);
-		if (vdev->req_trigger)
+			vdev->err_trigger = NULL;
+		}
+		if (vdev->req_trigger) {
 			eventfd_ctx_put(vdev->req_trigger);
+			vdev->req_trigger = NULL;
+		}
 	}
 
 	mutex_unlock(&vdev->reflck->lock);

