Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508A41CD0D9
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 06:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgEKEfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 00:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgEKEfB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 00:35:01 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF92C061A0E
        for <kvm@vger.kernel.org>; Sun, 10 May 2020 21:35:01 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id fb4so3791498qvb.7
        for <kvm@vger.kernel.org>; Sun, 10 May 2020 21:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eAd4gbb0pcNnApGm6Og5wCWvp0yRJHJXtLCgR/gxdK4=;
        b=KAW6y7vm9lCjNEy0YAU6G7q+RuEfJEjJ0WGtTcfF5+EDnb0VUdt+EuDEMmnxAU8uuI
         6Vg7JkVSpSPv1CCUzufDIZVzUXHtCFf1UHZ45JvPn8T8NOs84T++3dXQkIG0VtvW9mAY
         2oiemNvUY9qm/uOTIy3Kg7w1rraNMNR8GsEVXJEnFU0g6iK2ov0qr8ILjlfx1jrGXavX
         PYqT/1iOUrnXjiTtFVU+eziz5YUmPIUOaXDIlyUAy+GxwFrI6rCeuun67mfiqth3ixx8
         xc1mqCVnn1+SD2CTriYUIJFRsYVJ6fCEp0wdh+uytF8zDHHLgHUv6oJx3qm1JFVJwxCZ
         v3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eAd4gbb0pcNnApGm6Og5wCWvp0yRJHJXtLCgR/gxdK4=;
        b=iXdvuLyworDtwaBx/4qI9JQc3RLntjZTHLA2VmCZGtMsqQf12gxAlpmlNq0ELGLZq/
         S3bTQNTN0YC6veYbiimQDq0X1pok1NSmqn01fYiA39Fn3GsHXVneNEBDJVlU53SfZdQK
         aEIv1tZGkelqe7d84IdUDuz5UJYmPFy+uNnFBvwerQmUKw/czlLjzUTy2bAprRjYYImt
         ueawUc9xMTfDf0X25xNLzBqcFG4gKBYjFfGkiP6rgKWm7jElNSpA7h45uDJMqs8DwYtf
         6HDudnN3pR/gn3wCdy8Mzpa80nLZ2hWFDEanvWOHg1nI8/4WOsozIiO0eYn5O0LKc2MB
         VFlw==
X-Gm-Message-State: AGi0PuaeGOMCl0EC+EiaPiCNBqWvVzq4+AJpyKAneg3Z2bQ+ZFa2xtKQ
        AqvK0juaj8EcN+ignezn5eQs5g==
X-Google-Smtp-Source: APiQypLFNnKP7c/SRXW2/x9gJo9sMJpGIWsLIMrsDdA2a1mki4zFpL/KN4MNfuGlgTnwSxSkYBzbJA==
X-Received: by 2002:a0c:f70c:: with SMTP id w12mr13674265qvn.28.1589171699967;
        Sun, 10 May 2020 21:34:59 -0700 (PDT)
Received: from ovpn-112-210.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id e16sm8384451qtc.92.2020.05.10.21.34.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 May 2020 21:34:59 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] vfio/pci: fix memory leaks of eventfd ctx
Date:   Mon, 11 May 2020 00:34:50 -0400
Message-Id: <20200511043450.2718-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Finished a qemu-kvm (-device vfio-pci,host=0001:01:00.0) triggers a few
memory leaks after a while because vfio_pci_set_ctx_trigger_single()
calls eventfd_ctx_fdget() without the matching eventfd_ctx_put() later.
Fix it by calling eventfd_ctx_put() for those memory in
vfio_pci_release() before vfio_device_release().

unreferenced object 0xebff008981cc2b00 (size 128):
  comm "qemu-kvm", pid 4043, jiffies 4294994816 (age 9796.310s)
  hex dump (first 32 bytes):
    01 00 00 00 6b 6b 6b 6b 00 00 00 00 ad 4e ad de  ....kkkk.....N..
    ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
  backtrace:
    [<00000000917e8f8d>] slab_post_alloc_hook+0x74/0x9c
    [<00000000df0f2aa2>] kmem_cache_alloc_trace+0x2b4/0x3d4
    [<000000005fcec025>] do_eventfd+0x54/0x1ac
    [<0000000082791a69>] __arm64_sys_eventfd2+0x34/0x44
    [<00000000b819758c>] do_el0_svc+0x128/0x1dc
    [<00000000b244e810>] el0_sync_handler+0xd0/0x268
    [<00000000d495ef94>] el0_sync+0x164/0x180
unreferenced object 0x29ff008981cc4180 (size 128):
  comm "qemu-kvm", pid 4043, jiffies 4294994818 (age 9796.290s)
  hex dump (first 32 bytes):
    01 00 00 00 6b 6b 6b 6b 00 00 00 00 ad 4e ad de  ....kkkk.....N..
    ff ff ff ff 6b 6b 6b 6b ff ff ff ff ff ff ff ff  ....kkkk........
  backtrace:
    [<00000000917e8f8d>] slab_post_alloc_hook+0x74/0x9c
    [<00000000df0f2aa2>] kmem_cache_alloc_trace+0x2b4/0x3d4
    [<000000005fcec025>] do_eventfd+0x54/0x1ac
    [<0000000082791a69>] __arm64_sys_eventfd2+0x34/0x44
    [<00000000b819758c>] do_el0_svc+0x128/0x1dc
    [<00000000b244e810>] el0_sync_handler+0xd0/0x268
    [<00000000d495ef94>] el0_sync+0x164/0x180

Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/vfio/pci/vfio_pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6c6b37b5c04e..080e6608f297 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -519,6 +519,10 @@ static void vfio_pci_release(void *device_data)
 		vfio_pci_vf_token_user_add(vdev, -1);
 		vfio_spapr_pci_eeh_release(vdev->pdev);
 		vfio_pci_disable(vdev);
+		if (vdev->err_trigger)
+			eventfd_ctx_put(vdev->err_trigger);
+		if (vdev->req_trigger)
+			eventfd_ctx_put(vdev->req_trigger);
 	}
 
 	mutex_unlock(&vdev->reflck->lock);
-- 
2.21.0 (Apple Git-122.2)

