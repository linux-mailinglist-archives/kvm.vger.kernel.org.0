Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5923B11C4
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 04:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFWCaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 22:30:55 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:39736 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhFWCaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 22:30:52 -0400
Received: by mail-pl1-f176.google.com with SMTP id o21so349256pll.6;
        Tue, 22 Jun 2021 19:28:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gwx1ZCzIHLcluKpzR6wn6tTFWmEGPnbN9lvDpuT4Ci8=;
        b=E22iIsaEpX5QmOz5vAlaSEHvPJYKFjxvYGGxnofwgK3IA/F/y6hlGJUXYUGig/C7P4
         87etjL/j+o+N5PSwa539Ifu4j/56Gs6bj+ErzYhOlKH1iSVtuYuJi7EP9JYAvkxyPr22
         rEL0uC6bh6PFdDfL/6RG0cosfCgBze/UCLZwDmvmJVH8dzjQMjVG0DOHs/wy+X6OlpgF
         PUvqvE+/OZw8DaJsRDvWgpBfBDtA1P/owCRFPQC2bH4T0D7+qajgyxCilgn4UqurKuCo
         956MTTN6DdIOAxWTpqO2jK6h+etKCXJ2W3N+eF9pjVJWauybvlSc9jGWik5u/544ccEq
         H9Qg==
X-Gm-Message-State: AOAM533P4FmbaxucTYkxFoIRXMYbCJeGSVHSthpzEGp5ZcAm2v2uQBq0
        1p6zr/HPmJkne0TIf2dIw4Q=
X-Google-Smtp-Source: ABdhPJzHcG9fcZjWj1Zasi09PP3Nkv6szaELFTskqly+XG8me/DlhyZU2zgg8OCk4/5vNC1sFucw3g==
X-Received: by 2002:a17:90a:d704:: with SMTP id y4mr7049988pju.22.1624415314997;
        Tue, 22 Jun 2021 19:28:34 -0700 (PDT)
Received: from localhost ([173.239.198.97])
        by smtp.gmail.com with ESMTPSA id y7sm3474466pja.8.2021.06.22.19.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 19:28:33 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     bhelgaas@google.com, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, kevin.tian@intel.com, eric.auger@redhat.com,
        giovanni.cabiddu@intel.com, mjrosato@linux.ibm.com,
        jannh@google.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        schnelle@linux.ibm.com
Cc:     minchan@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, mcgrof@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] vfio: use the new pci_dev_trylock() helper to simplify try lock
Date:   Tue, 22 Jun 2021 19:28:24 -0700
Message-Id: <20210623022824.308041-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623022824.308041-1-mcgrof@kernel.org>
References: <20210623022824.308041-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new pci_dev_trylock() helper to simplify our locking.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index bd7c482c948a..02b05f7b9a91 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -477,13 +477,10 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	 * We can not use the "try" reset interface here, which will
 	 * overwrite the previously restored configuration information.
 	 */
-	if (vdev->reset_works && pci_cfg_access_trylock(pdev)) {
-		if (device_trylock(&pdev->dev)) {
-			if (!__pci_reset_function_locked(pdev))
-				vdev->needs_reset = false;
-			device_unlock(&pdev->dev);
-		}
-		pci_cfg_access_unlock(pdev);
+	if (vdev->reset_works && pci_dev_trylock(pdev)) {
+		if (!__pci_reset_function_locked(pdev))
+			vdev->needs_reset = false;
+		pci_dev_unlock(pdev);
 	}
 
 	pci_restore_state(pdev);
-- 
2.30.2

