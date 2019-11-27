Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D13B10B3D4
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 17:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfK0Qto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 11:49:44 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2766 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfK0Qto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 11:49:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574873384; x=1606409384;
  h=from:to:cc:subject:date:message-id;
  bh=eQhzbtK33bAPiznFgsly4Gjgsjra5pEl6cMAgAK27Co=;
  b=X3gAA8OoWYcv2+kuZ/LPGlAADMtbn5RHOaACNAMlVAgKRcb8e9K8o1lI
   Sobdiia4G5cBfNhKT+46/dIK8tSUvqYOptXvxnlr8YvxFhgNX8OBuqA03
   dUnSDwDQ+NHSDqwewDdnQgSoWEb/VhG33PCg+/zA9WJIXnTekV8jKHMqF
   8=;
IronPort-SDR: qZiodDjbJRpZvCLsnk5E3jdX9kb4Ej5uhQiX3JkG+RC1463A/jU5SdWMRB5dquDEdbVDTOjS3Y
 0xraSK5E8bjw==
X-IronPort-AV: E=Sophos;i="5.69,250,1571702400"; 
   d="scan'208";a="10251277"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 27 Nov 2019 16:49:31 +0000
Received: from u5992c35209ee5c.ant.amazon.com (iad7-ws-svc-lb50-vlan3.amazon.com [10.0.93.214])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id AD920A247C;
        Wed, 27 Nov 2019 16:49:28 +0000 (UTC)
Received: from u5992c35209ee5c.ant.amazon.com (localhost [127.0.0.1])
        by u5992c35209ee5c.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTPS id xARGnQlJ016125
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 17:49:26 +0100
Received: (from giangyi@localhost)
        by u5992c35209ee5c.ant.amazon.com (8.15.2/8.15.2/Submit) id xARGnPIw016123;
        Wed, 27 Nov 2019 17:49:25 +0100
From:   Jiang Yi <giangyi@amazon.com>
To:     kvm@vger.kernel.org
Cc:     adulea@amazon.de, jschoenh@amazon.de, maz@kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        Jiang Yi <giangyi@amazon.com>
Subject: [PATCH] vfio: call irq_bypass_unregister_producer() before freeing irq
Date:   Wed, 27 Nov 2019 17:49:10 +0100
Message-Id: <20191127164910.15888-1-giangyi@amazon.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since irq_bypass_register_producer() is called after request_irq(), we
should do tear-down in reverse order: irq_bypass_unregister_producer()
then free_irq().

Signed-off-by: Jiang Yi <giangyi@amazon.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3fa3f728fb39..2056f3f85f59 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -289,18 +289,18 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	int irq, ret;
 
 	if (vector < 0 || vector >= vdev->num_ctx)
 		return -EINVAL;
 
 	irq = pci_irq_vector(pdev, vector);
 
 	if (vdev->ctx[vector].trigger) {
-		free_irq(irq, vdev->ctx[vector].trigger);
 		irq_bypass_unregister_producer(&vdev->ctx[vector].producer);
+		free_irq(irq, vdev->ctx[vector].trigger);
 		kfree(vdev->ctx[vector].name);
 		eventfd_ctx_put(vdev->ctx[vector].trigger);
 		vdev->ctx[vector].trigger = NULL;
 	}
 
 	if (fd < 0)
 		return 0;
 
-- 
2.17.1

