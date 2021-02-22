Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15DA321D7C
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhBVQyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:54:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49711 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231538AbhBVQxl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/dqQuYtgn2Ymbgyr47y6jbgpp08/OqPh94j5D5czhkA=;
        b=WNfPOfxKqKGI7tMeBqoWGr1BsxsBMV3IF6WN3XTqHjJIe+etqeo7ve9xxERxGO42NMfq9E
        JoqO2HODYdCV3gmXRkmKjiOS6EHytK+KXbUF0wZLvJjZegNE5X93597Fp0oelLNGRLnxMm
        /xrzYK8VgC3UuWjWmh/VOe0xwS6nuWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-g3BCceQVOsu6X5IdmD4pgQ-1; Mon, 22 Feb 2021 11:52:03 -0500
X-MC-Unique: g3BCceQVOsu6X5IdmD4pgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81581192CC50;
        Mon, 22 Feb 2021 16:52:02 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5B355D6B1;
        Mon, 22 Feb 2021 16:51:55 +0000 (UTC)
Subject: [RFC PATCH 07/10] vfio/pci: Notify on device release
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:51:55 -0700
Message-ID: <161401271528.16443.2318400142031983698.stgit@gimli.home>
In-Reply-To: <161401167013.16443.8389863523766611711.stgit@gimli.home>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trigger a release notifier call when open reference count is zero.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f9529bac6c97..fb8307430e24 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -560,6 +560,7 @@ static void vfio_pci_release(void *device_data)
 	mutex_lock(&vdev->reflck->lock);
 
 	if (!(--vdev->refcnt)) {
+		vfio_device_notifier_call(vdev->device, VFIO_DEVICE_RELEASE);
 		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);

