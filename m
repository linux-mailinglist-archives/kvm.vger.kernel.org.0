Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E47A91058
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2019 13:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfHQLwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Aug 2019 07:52:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41098 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfHQLwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Aug 2019 07:52:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id j16so4019290wrr.8;
        Sat, 17 Aug 2019 04:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Bjg3d+ReGnHwJhKycmU6EiBnA2dCiOLyBl8G9lc4YXw=;
        b=MjUzhZtIvOWuMwEXuUvrcyL500MH6X249sn8yuDg3Jztsn7xnUBOA3ny9lVWOCnyDD
         vMidcwz/w6EFcT8DrmV8MXvVTMwJOnik2k2q8JYu4SNGO2xSaBWF5oP4gSGFjZDkIjdl
         ZM6CIP2jQzohed+N43Xg3PFl6GHApP0TTMjPsdN8YfRTUYh3aEzvWZUf1C6ywpmJ15Qu
         TDP39Y7cJw7Z+6fcJv8LXo0fCtFs1ziYzxow2pvur3ZBe2q643urBBtneGEOWM3eL1fK
         HROQyijGZ/Lapeoolj7cvwWQNwEn1QCT5Ky9M4yhQIWUJhgBHmEahrMjmkTSC6eRwG1z
         6vSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Bjg3d+ReGnHwJhKycmU6EiBnA2dCiOLyBl8G9lc4YXw=;
        b=NvO/naQLPDtireEjxZpehDvoWLrYWF76vV0EsKPxKkPPyMPiTvcIY09Q+9AxZYaEI3
         wLbuICUWvgWEUrgOTekx6gCjo8fNQeWpFlwoOC3U5xAShxf3sXLMTzCOv1znznmVtppp
         oAO+Jd5vl43pqup7xpP+qL9s552zy+9pIwDHHELL913ybCl4Gxfo6G6e4RoxEaV9STZ6
         TW9Upt1U851eKt+ReHKIVZCtibtlZAehkOv549OjBqpFq5qdjNuZTvChqUfnBq9Gz7DT
         kBuAsnXnDkEc0pI432IG4fKzluhTHv0H8bBfR+fJuBcQpk4GYdoC96czkbvQhFsrsZLW
         oXlQ==
X-Gm-Message-State: APjAAAVsG5J33cRyzWlE8tnChGU2JjfpuEWwiwhcmKzYP79Pr+5/0UCc
        RCGUYlCkITdyqkR/WoM9fLpakH/C3vHXLg==
X-Google-Smtp-Source: APXvYqzZGaXfbTdF9IJFmQZYlA2ZtB5E21tF4WhfAav5Dl5+SeKgbR1m2pIUL4fbVFn660E3bcIsSQ==
X-Received: by 2002:adf:e750:: with SMTP id c16mr16322899wrn.199.1566042740898;
        Sat, 17 Aug 2019 04:52:20 -0700 (PDT)
Received: from localhost ([165.22.121.176])
        by smtp.gmail.com with ESMTPSA id o9sm10352285wrm.88.2019.08.17.04.52.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 04:52:20 -0700 (PDT)
From:   hexin <hexin.op@gmail.com>
X-Google-Original-From: hexin <hexin15@baidu.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     hexin <hexin15@baidu.com>, Liu Qi <liuqi16@baidu.com>,
        Zhang Yu <zhangyu31@baidu.com>
Subject: [PATCH v2] vfio_pci: Replace pci_try_reset_function() with __pci_reset_function_locked() to ensure that the pci device configuration space is restored to its original state
Date:   Sat, 17 Aug 2019 19:51:03 +0800
Message-Id: <1566042663-16694-1-git-send-email-hexin15@baidu.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In vfio_pci_enable(), save the device's initial configuration information
and then restore the configuration in vfio_pci_disable(). However, the
execution result is not the same. Since the pci_try_reset_function()
function saves the current state before resetting, the configuration
information restored by pci_load_and_free_saved_state() will be
overwritten. The __pci_reset_function_locked() function can be used
to prevent the configuration space from being overwritten.

Fixes: 890ed578df82 ("vfio-pci: Use pci "try" reset interface")
Signed-off-by: hexin <hexin15@baidu.com>
Signed-off-by: Liu Qi <liuqi16@baidu.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
---
 drivers/vfio/pci/vfio_pci.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 703948c..0220616 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -438,11 +438,20 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
 
 	/*
-	 * Try to reset the device.  The success of this is dependent on
-	 * being able to lock the device, which is not always possible.
+	 * Try to get the locks ourselves to prevent a deadlock. The
+	 * success of this is dependent on being able to lock the device,
+	 * which is not always possible.
+	 * We can not use the "try" reset interface here, which will
+	 * overwrite the previously restored configuration information.
 	 */
-	if (vdev->reset_works && !pci_try_reset_function(pdev))
-		vdev->needs_reset = false;
+	if (vdev->reset_works && pci_cfg_access_trylock(pdev)) {
+		if (device_trylock(&pdev->dev)) {
+			if (!__pci_reset_function_locked(pdev))
+				vdev->needs_reset = false;
+			device_unlock(&pdev->dev);
+		}
+		pci_cfg_access_unlock(pdev);
+	}
 
 	pci_restore_state(pdev);
 out:
-- 
1.8.3.1

