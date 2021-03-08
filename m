Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C85433199D
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhCHVtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:49:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhCHVsw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:48:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RiD+X3RrWWZTnpp+Wb9slelJucGP/OyLw2+qHNm3UaM=;
        b=ErSWn7wxFJxhPC6ZHOjdTol915tRV5n2CIoYHnaM8JqAk5jvqI/YksGyLca0y1ZigiTm8X
        RXtxKEAG5cJtM1+hN6idSKNtAUVT9XiskVOHgiPhIQQ1MgYoGGNUhVZV1XizzGSXuzgAlx
        bcrr3XkRua372ZB78dJPAQgaNVVpba8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-UH31uqmPPWerh-gcH3_cYQ-1; Mon, 08 Mar 2021 16:48:49 -0500
X-MC-Unique: UH31uqmPPWerh-gcH3_cYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDEE58018B3;
        Mon,  8 Mar 2021 21:48:48 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69D9B5C27C;
        Mon,  8 Mar 2021 21:48:42 +0000 (UTC)
Subject: [PATCH v1 08/14] vfio/pci: Notify on device release
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:48:42 -0700
Message-ID: <161524012206.3480.6390372271074364981.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trigger a release notifier call when open reference count is zero.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 585895970e9c..bee9318b46ed 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -560,6 +560,7 @@ static void vfio_pci_release(void *device_data)
 	mutex_lock(&vdev->reflck->lock);
 
 	if (!(--vdev->refcnt)) {
+		vfio_device_notifier_call(vdev->device, VFIO_DEVICE_RELEASE);
 		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);

