Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A4C22702C
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 23:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgGTVJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 17:09:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28644 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgGTVJe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 17:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595279373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mlHthLgSXx+0yukG47QpZktLnXxCHnNa5qkendynQ2U=;
        b=WWarP0NI0eAqiVyUopWQyBPrp9wat8QuH4IMT4MJAmqqIK5eZ2e2dzQQfOy5nk5IDfFA5n
        2LEAhmBiqCeUuJ2uvzFHjwrJiYwN+2xqLNu7f+8lT0jnrbFOqyRpCwJd580r0wPaOwuF21
        vbjnX0p+WsOA0CFczMqH2XSEPRJvqt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-nSOylXgzOdqC6eVgTMJPiw-1; Mon, 20 Jul 2020 17:09:31 -0400
X-MC-Unique: nSOylXgzOdqC6eVgTMJPiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC3D41902EA0;
        Mon, 20 Jul 2020 21:09:30 +0000 (UTC)
Received: from gimli.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CB2176214;
        Mon, 20 Jul 2020 21:09:27 +0000 (UTC)
Subject: [PATCH] vfio/pci: Hold igate across releasing eventfd contexts
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com, prime.zeng@hisilicon.com
Date:   Mon, 20 Jul 2020 15:09:27 -0600
Message-ID: <159527934542.26615.503005826695043299.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to release and immediately re-acquire igate while clearing
out the eventfd ctxs.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index b0258b79bb5b..dabca0450e6d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -523,14 +523,12 @@ static void vfio_pci_release(void *device_data)
 		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
+
 		mutex_lock(&vdev->igate);
 		if (vdev->err_trigger) {
 			eventfd_ctx_put(vdev->err_trigger);
 			vdev->err_trigger = NULL;
 		}
-		mutex_unlock(&vdev->igate);
-
-		mutex_lock(&vdev->igate);
 		if (vdev->req_trigger) {
 			eventfd_ctx_put(vdev->req_trigger);
 			vdev->req_trigger = NULL;

