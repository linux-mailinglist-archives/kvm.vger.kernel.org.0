Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654E4292831
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 15:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgJSNav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 09:30:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728300AbgJSNas (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 09:30:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603114247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aDNhLJRM/nT1vY+letQJHejcGlh5BSbNPHby1Nx3QTw=;
        b=GCCuXnZsPCBazEtlFI4QyOwvERJRxzl6mGKqsVHRhqhEU/ml1vco6tzE0+t4vbEO9E8wYQ
        t14ibqbnyEjJMCXCTWNxPpSGSaa5XMOlNlic2f987EzSnRca5YZsd3KZHWfjvT2/VaISEN
        p+ExlF4j/OpmrgixUClIFOm/c0oAvMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-DMC7xye6Pm6bjRiyB6VbNw-1; Mon, 19 Oct 2020 09:30:44 -0400
X-MC-Unique: DMC7xye6Pm6bjRiyB6VbNw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C868F876E3F;
        Mon, 19 Oct 2020 13:30:42 +0000 (UTC)
Received: from gimli.home (ovpn-112-77.phx2.redhat.com [10.3.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36C345B4AD;
        Mon, 19 Oct 2020 13:30:37 +0000 (UTC)
Subject: [PATCH] vfio/pci: Clear token on bypass registration failure
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        guomin_chen@sina.com, gchen.guomin@gmail.com
Date:   Mon, 19 Oct 2020 07:30:37 -0600
Message-ID: <160311419702.25406.2436004222669241097.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The eventfd context is used as our irqbypass token, therefore if an
eventfd is re-used, our token is the same.  The irqbypass code will
return an -EBUSY in this case, but we'll still attempt to unregister
the producer, where if that duplicate token still exists, results in
removing the wrong object.  Clear the token of failed producers so
that they harmlessly fall out when unregistered.

Fixes: 6d7425f109d2 ("vfio: Register/unregister irq_bypass_producer")
Reported-by: guomin chen <guomin_chen@sina.com>
Tested-by: guomin chen <guomin_chen@sina.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1d9fb2592945..869dce5f134d 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -352,11 +352,13 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	vdev->ctx[vector].producer.token = trigger;
 	vdev->ctx[vector].producer.irq = irq;
 	ret = irq_bypass_register_producer(&vdev->ctx[vector].producer);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
 		dev_info(&pdev->dev,
 		"irq bypass producer (token %p) registration fails: %d\n",
 		vdev->ctx[vector].producer.token, ret);
 
+		vdev->ctx[vector].producer.token = NULL;
+	}
 	vdev->ctx[vector].trigger = trigger;
 
 	return 0;

