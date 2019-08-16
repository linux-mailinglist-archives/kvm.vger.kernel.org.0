Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016018F97D
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 05:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfHPDdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 23:33:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36679 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfHPDdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 23:33:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id w2so2403200pfi.3;
        Thu, 15 Aug 2019 20:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=s1lUchOg7iDiYDCvoYxYUrpcGLcaqdAZGXJKa54+yKY=;
        b=Xlrq+MEfXEpHfl+xW59Wm0F+k7V5EXtxu4NRlG8AfJxcKQc+2BS0dnj2E1CnLJb0ed
         tL3Hfj4oGTKsDGyeqA9ghwV8qUikDu+TC1AJf2WzpOnAnNEZPFO37BVO+hkldMNhKzYe
         A5Xwq3HDpYQyZI+2+HbHj2Ugc/5YXkRfnx7QbQ9SLww9/ejWgLJlQVLjrF0uzeTyw6Fd
         FG9f6PCbIWmJpoFiCCNSugHSZUUlXxHsCnIl8TCwfu9pKWzQYRZd6+/ZbQdP0NQnYN2b
         gjOW7jKamORq6TQ2w0ryfg5puD/RbFDPAdMi6/8F1NZm6QIBUYPj7GxlbnJE7/2YZDtt
         o7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s1lUchOg7iDiYDCvoYxYUrpcGLcaqdAZGXJKa54+yKY=;
        b=PGnWqo30XEeVP/cblHxAK/QgXOBwSdSquU52qlogWy40uN0tqYVZSX/RecW/d0NmyJ
         OBF179MY3csItEXzUmAPJtF8+M40uNGK9ufAK5LlojEW3L8KPYwqxlLbwYkjkN+3ziQd
         BQkmzXPwyPfzDoWXOfwCqo2+7VXKIHRJijV90if56REhdGN3W2KNKPliw2qsICUmrrnv
         A34Hpf+WN3UOfrjFIYSp+PdO4YQcBqTGa4aTXVar+t9aK2FExbHS29Eclz14SsPq0v3x
         ZfI2IvVGYHP6PPj3kU3mdMqeqy2mBRhXA1zz/GGg8aNdwl3EyFxCVwb0kig6Wt/gFlP9
         4sfQ==
X-Gm-Message-State: APjAAAWseHWdosRxXfwwL17LzExc8jEBt2fQN2mIqQfAI0rBxETf1IG0
        OpfPxX2m3biAKH+SD3U1l0w=
X-Google-Smtp-Source: APXvYqzjJFdZFAbFqUmkkN+HsDnh74LnXUr81ataAhNkiO0QNZvrwRdOEknATYQ244Lb3mIC6ffxqA==
X-Received: by 2002:a17:90a:bc42:: with SMTP id t2mr5157478pjv.121.1565926434689;
        Thu, 15 Aug 2019 20:33:54 -0700 (PDT)
Received: from localhost ([61.135.169.81])
        by smtp.gmail.com with ESMTPSA id 203sm5089675pfz.107.2019.08.15.20.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 20:33:54 -0700 (PDT)
From:   hexin <hexin.op@gmail.com>
X-Google-Original-From: hexin <hexin15@baidu.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     hexin <hexin15@baidu.com>, Liu Qi <liuqi16@baidu.com>,
        Zhang Yu <zhangyu31@baidu.com>
Subject: [PATCH] vfio_pci: Replace pci_try_reset_function() with __pci_reset_function_locked() to ensure that the pci device configuration space is restored to its original state
Date:   Fri, 16 Aug 2019 11:33:47 +0800
Message-Id: <1565926427-21675-1-git-send-email-hexin15@baidu.com>
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

Signed-off-by: hexin <hexin15@baidu.com>
Signed-off-by: Liu Qi <liuqi16@baidu.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
---
 drivers/vfio/pci/vfio_pci.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 703948c..3c93492 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -441,8 +441,14 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	 * Try to reset the device.  The success of this is dependent on
 	 * being able to lock the device, which is not always possible.
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

