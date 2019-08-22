Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 088DE989DF
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 05:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbfHVDf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 23:35:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38823 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfHVDf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 23:35:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so4187240wmm.3;
        Wed, 21 Aug 2019 20:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WsaYFeAkte2NretrOo8yB7eLtn2MeRH7ZtBbeHqK9ss=;
        b=mRigY60/acd7r9AbKb68l4BZVAfI6iTkq9tIoOCP/NzynKBOPNFtBnMgl88G3vKpv9
         4nbLjfEHxDEUn+KlYQfPXsu/23xyYA8DfzDkwoT0ssJWXao7V6c1pvw7hol3oKDUdNEQ
         lJLMOh2e7VXr5Tvep4FUu9ywmFnwGShlGQ7RybJqG+Ey6Ff1b7AqseT0+MqEtDudQHTo
         HediKQtaQUxtLainWjPbEz7dUfZPht5bp8BB3FRsUN6cgUer1mD35+igZNtL+iZLlbAC
         DEGVfj5bYxoghKLBjDbg0HMmJKas/B+ZMu+cPtjgLzWgZaQVrqVHIycJstWAUJT4Vd9z
         6V8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WsaYFeAkte2NretrOo8yB7eLtn2MeRH7ZtBbeHqK9ss=;
        b=KXW9d8SJejRgTsTIrJZGHVIdm5bed49HCRmXeJwYn8D2rkgAZMlR+wkdGNWx2E8Y57
         sHDirt0El6N+kJPSsZj+vq+laPt9mMJYfYGQL0e5UH974p5jTn1jdysxb5V49ky1UpU/
         bHNR2vMMV4ORr0Zxdb436a9GX3e32miYs+nTpALv/B0u6u1/wdExRXvEwjNaL+X5HQZV
         IhhAACheuMLsbiMf9rSGvsKqKNSmVar5kgXESzoPsUGCiWCsrUMR5VsUNrP1ovjSXgSh
         Yn8rS5ysRUJ9JxYrgwF12lT6j9tjjASgl0WzWHLPP3B02gU64486erDM8ocsXcO9kFD9
         f3Sw==
X-Gm-Message-State: APjAAAUtgtQL3gcgK7Bo6iDiq+BJeZPq6FmRGMroQHAOlj90bmH2TgFb
        zCvC7YDYjkehtIh/aecwUlw=
X-Google-Smtp-Source: APXvYqxpplXAscH90uc7IVjMnTI5K8IsuLoHO6ctq9wYYw2C2y4eh3XV0YiP0nw2niEWn1ZjB0odjw==
X-Received: by 2002:a1c:d108:: with SMTP id i8mr3609222wmg.28.1566444924948;
        Wed, 21 Aug 2019 20:35:24 -0700 (PDT)
Received: from localhost ([165.22.121.176])
        by smtp.gmail.com with ESMTPSA id o11sm17971037wrw.19.2019.08.21.20.35.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 20:35:24 -0700 (PDT)
From:   hexin <hexin.op@gmail.com>
X-Google-Original-From: hexin <hexin15@baidu.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     hexin <hexin15@baidu.com>, Liu Qi <liuqi16@baidu.com>,
        Zhang Yu <zhangyu31@baidu.com>
Subject: [PATCH v3] vfio_pci: Restore original state on release
Date:   Thu, 22 Aug 2019 11:35:19 +0800
Message-Id: <1566444919-3331-1-git-send-email-hexin15@baidu.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pci_enable() saves the device's initial configuration information
with the intent that it is restored in vfio_pci_disable().  However,
the commit referenced in Fixes: below replaced the call to
__pci_reset_function_locked(), which is not wrapped in a state save
and restore, with pci_try_reset_function(), which overwrites the
restored device state with the current state before applying it to the
device.  Reinstate use of __pci_reset_function_locked() to return to
the desired behavior.

Fixes: 890ed578df82 ("vfio-pci: Use pci "try" reset interface")
Signed-off-by: hexin <hexin15@baidu.com>
Signed-off-by: Liu Qi <liuqi16@baidu.com>
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
---
v2->v3:
- change commit log 
v1->v2:
- add fixes tag
- add comment to warn 

[1] https://lore.kernel.org/linux-pci/1565926427-21675-1-git-send-email-hexin15@baidu.com
[2] https://lore.kernel.org/linux-pci/1566042663-16694-1-git-send-email-hexin15@baidu.com

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

