Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3B742D69E
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJNKAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 06:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbhJNKAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 06:00:42 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4C9C061760;
        Thu, 14 Oct 2021 02:58:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l6so3791240plh.9;
        Thu, 14 Oct 2021 02:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7pLIyNJD+d5mAa5PFcs4g1QmPkUK7kz7RJBNS5MvFNU=;
        b=Ah6yRqVAdD4LxJmM0L+oAgTEvbnLGQdgTDLVPsNv4h/MGGz4gP8NxmaQFWlLnlnnCV
         iCeC/m2bFkk2ynY0SAPHDJO7L+KjudbSaYQAwNrsWfRMqdnh/yftsB20y+tg8yCi+GZk
         cv2KGgSQAgK9f4l2yXlNlnvR0NKWMkC2wGuU5te8kHtdNvErrrH/vJEQSVSQbjpcx21X
         WZ0VwIvpbAZ0shhyRFxEriDi6CNi46ejgK4mM2N5oNZKlqokpGwyCurtfsxWNdEbV05u
         0WrEd8qvFuUqPVLO/kjv1aCYD70loJVVGTh4tbU8wDG+FwS9xOcScT3r8Y0J8A2KEYQ0
         Xtiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7pLIyNJD+d5mAa5PFcs4g1QmPkUK7kz7RJBNS5MvFNU=;
        b=p4L7GMuIm5c6/RJS50//6Mt+w2SaNO7l2EJ0Xn+HOFMIzplbvyOzt0XmzXIZwcgUA4
         0alG7GDDHXUPjC5dRUeI0rsbxvln5RZinRg1xenXhOo/XDjEtxJfEKNZG+QNtV9i7iH7
         LWpxAhnyCnhWIh91OAgkvE/abwLmYo8tqlTMhA+voq4EtAVYrLEfyBPcHyfPHEv/McPP
         rVBMoNkSp20ciNqNMt1vf3QDO2G6d3E8V5mTqdYmsKdR+i81i/1WsIx6JssdlExl0wsN
         yT77X5bSoAu8p+3mkDKyL2p4NKXKpnB5c8/gyHhDLb8jZLbDH5JWJqXU4cqbXngTrts6
         fUAA==
X-Gm-Message-State: AOAM531p0HkC+3qut4fej7CeKbNG9PxjjFCYCZWxeK9sY+XB15z8i+UV
        wrcX+3N95PP/02zRGljd+sk=
X-Google-Smtp-Source: ABdhPJzXxvkWR+vqomWVBACjT7oXOvcLdFI29NK4NAXfXv87ebuNlyJybNcBQfZnAabrIZRuGoTl9g==
X-Received: by 2002:a17:903:31cd:b0:134:5b6f:2ff8 with SMTP id v13-20020a17090331cd00b001345b6f2ff8mr4156279ple.46.1634205517429;
        Thu, 14 Oct 2021 02:58:37 -0700 (PDT)
Received: from localhost.localdomain (5e.8a.38a9.ip4.static.sl-reverse.com. [169.56.138.94])
        by smtp.gmail.com with ESMTPSA id k127sm2080664pfd.1.2021.10.14.02.58.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Oct 2021 02:58:37 -0700 (PDT)
From:   Zhenguo Yao <yaozhenguo1@gmail.com>
To:     bhelgaas@google.com, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, jgg@ziepe.ca, mgurtovoy@nvidia.com,
        yishaih@nvidia.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaozhenguo@jd.com,
        Zhenguo Yao <yaozhenguo1@gmail.com>
Subject: [PATCH v1 2/2] vfio-pci: Don't do device reset when ignore_reset is setting
Date:   Thu, 14 Oct 2021 17:57:48 +0800
Message-Id: <20211014095748.84604-3-yaozhenguo1@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014095748.84604-1-yaozhenguo1@gmail.com>
References: <20211014095748.84604-1-yaozhenguo1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some scenarios, vfio device can't do any reset in initialization
process. For example: Nvswitch and GPU A100 working in Shared NVSwitch
Virtualization Model. In such mode, The GPUs can't do any reset when
Guest VM is booting up.

So, Using ignore_reset to control whether to do PCI reset in
initialization. In Shared NVSwitch Virtualization Model, GPUs will
ignore reset when Gust VM booting up.

Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 48 ++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 68198e0f2a63..83d3ef5d3a9c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -254,11 +254,13 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (ret)
 		return ret;
 
-	/* If reset fails because of the device lock, fail this path entirely */
-	ret = pci_try_reset_function(pdev);
-	if (ret == -EAGAIN) {
-		pci_disable_device(pdev);
-		return ret;
+	if (!pdev->ignore_reset) {
+		/* If reset fails because of the device lock, fail this path entirely */
+		ret = pci_try_reset_function(pdev);
+		if (ret == -EAGAIN) {
+			pci_disable_device(pdev);
+			return ret;
+		}
 	}
 
 	vdev->reset_works = !ret;
@@ -388,25 +390,30 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 */
 	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
 
-	/*
-	 * Try to get the locks ourselves to prevent a deadlock. The
-	 * success of this is dependent on being able to lock the device,
-	 * which is not always possible.
-	 * We can not use the "try" reset interface here, which will
-	 * overwrite the previously restored configuration information.
-	 */
-	if (vdev->reset_works && pci_dev_trylock(pdev)) {
-		if (!__pci_reset_function_locked(pdev))
-			vdev->needs_reset = false;
-		pci_dev_unlock(pdev);
+	if (!pdev->ignore_reset) {
+		/*
+		 * Try to get the locks ourselves to prevent a deadlock. The
+		 * success of this is dependent on being able to lock the device,
+		 * which is not always possible.
+		 * We can not use the "try" reset interface here, which will
+		 * overwrite the previously restored configuration information.
+		 */
+		if (vdev->reset_works && pci_dev_trylock(pdev)) {
+			if (!__pci_reset_function_locked(pdev))
+				vdev->needs_reset = false;
+			pci_dev_unlock(pdev);
+		}
 	}
 
 	pci_restore_state(pdev);
 out:
 	pci_disable_device(pdev);
 
-	if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
-		vfio_pci_set_power_state(vdev, PCI_D3hot);
+	if (!pdev->ignore_reset) {
+		if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) &&
+					!disable_idle_d3)
+			vfio_pci_set_power_state(vdev, PCI_D3hot);
+	}
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
@@ -919,6 +926,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 
 		if (!vdev->reset_works)
 			return -EINVAL;
+		if (vdev->pdev->ignore_reset)
+			return -EINVAL;
 
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
 		ret = pci_try_reset_function(vdev->pdev);
@@ -1007,6 +1016,9 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		bool slot = false;
 		int group_idx, count = 0, ret = 0;
 
+		if (vdev->pdev->ignore_reset)
+			return -EINVAL;
+
 		minsz = offsetofend(struct vfio_pci_hot_reset, count);
 
 		if (copy_from_user(&hdr, (void __user *)arg, minsz))
-- 
2.27.0

