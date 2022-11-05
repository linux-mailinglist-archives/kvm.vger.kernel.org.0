Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC8261DF2B
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 23:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiKEWts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 18:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiKEWtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 18:49:47 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D53313DC7
        for <kvm@vger.kernel.org>; Sat,  5 Nov 2022 15:49:46 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 78so7337814pgb.13
        for <kvm@vger.kernel.org>; Sat, 05 Nov 2022 15:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6pDOE1RG9rRgZEeL9h0FSsm2VZYbQptR492yBEKa5A=;
        b=gdffMLuQrslOcBUorSS3t2Sx6Dg0CXDe56LBqaJB52w3Y/DjH2qmbOERB7Kc6TyRMn
         5UmHQoochRiQzSX43I4vxo6UqJfAvgTWlQuZc67WS+4B2hKe7V7XIasu1hS7kmNtWSpw
         jH8eRky02ZmnONIoGvXW96uttSEbZsAqyNJAE9DT7+eoR7ewaMdTD6RyQzsljxe54PSn
         Uuh/LqYHQ/LVNW/jl9gocw+Q26vJh9CNzhIEgcHEfs3cDzOaDeWCZ0unYTBlUEbkknep
         ey/TWrcBCmeh5q89nzZmBWu+T7AuVegxSNxh4pn3ysvebQZ8FeWp6B+WdO161W9PnDSw
         0MYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6pDOE1RG9rRgZEeL9h0FSsm2VZYbQptR492yBEKa5A=;
        b=AXO0WT9IbrwmyuWzE9wdgKjCDLBqKh+FT5ww5b4yjST8atUDa7GcVllEQVxg67cz0L
         XGnkVQXb99Z++w+a5QnAWP3vKNaFUfF1+LBZ4AqcdUHNPHVrAWnsuFARTulDubOrkAzP
         yOAtnm9ywL2YDJLUZQG1T1eHco/5FcDPRShdMPmRrSOFiVeWlWstryMP696IRbD6e/au
         JnHj7gOzSbVnhTCNFBfyz9Y/AexxlUw8izC9Z3RBt7yZ9pKk+dGBDILYwXLgscw0lVR3
         MhjuIhOmMh3zsCA72gT2mPRitxm184nvF4KNwwBT8iKaATmvk4imLpCVNHySalsAtoKI
         py5g==
X-Gm-Message-State: ANoB5pkP0d8Mt2lpGNPsSqiUI25Kn5DeBGsQTxHsmxkSKyKO1nyObXLb
        7lB5/pctlujZ+Mzeyu/tk/6D/TvGedybzw==
X-Google-Smtp-Source: AA0mqf7aSukzA9ZTp5RDbA53Z/6GfFU08/UmpaNptKNc0I+rvszDcdWC8DMVvhEUVC9MrIFe8jORYg==
X-Received: by 2002:a63:e855:0:b0:470:6287:fd4d with SMTP id a21-20020a63e855000000b004706287fd4dmr1756949pgk.295.1667688585876;
        Sat, 05 Nov 2022 15:49:45 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id rj14-20020a17090b3e8e00b001fde655225fsm14716728pjb.2.2022.11.05.15.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 15:49:45 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v5 3/3] vfio/pci: Check the device set open count on reset
Date:   Sat,  5 Nov 2022 15:44:58 -0700
Message-Id: <20221105224458.8180-4-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221105224458.8180-1-ajderossi@gmail.com>
References: <20221105224458.8180-1-ajderossi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pci_dev_set_needs_reset() inspects the open_count of every device
in the set to determine whether a reset is allowed. The current device
always has open_count == 1 within vfio_pci_core_disable(), effectively
disabling the reset logic. This field is also documented as private in
vfio_device, so it should not be used to determine whether other devices
in the set are open.

Checking for vfio_device_set_open_count() > 1 on the device set fixes
both issues.

After commit 2cd8b14aaa66 ("vfio/pci: Move to the device set
infrastructure"), failure to create a new file for a device would cause
the reset to be skipped due to open_count being decremented after
calling close_device() in the error path.

After commit eadd86f835c6 ("vfio: Remove calls to
vfio_group_add_container_user()"), releasing a device would always skip
the reset due to an ordering change in vfio_device_fops_release().

Failing to reset the device leaves it in an unknown state, potentially
causing errors when it is accessed later or bound to a different driver.

This issue was observed with a Radeon RX Vega 56 [1002:687f] (rev c3)
assigned to a Windows guest. After shutting down the guest, unbinding
the device from vfio-pci, and binding the device to amdgpu:

[  548.007102] [drm:psp_hw_start [amdgpu]] *ERROR* PSP create ring failed!
[  548.027174] [drm:psp_hw_init [amdgpu]] *ERROR* PSP firmware loading failed
[  548.027242] [drm:amdgpu_device_fw_loading [amdgpu]] *ERROR* hw_init of IP block <psp> failed -22
[  548.027306] amdgpu 0000:0a:00.0: amdgpu: amdgpu_device_ip_init failed
[  548.027308] amdgpu 0000:0a:00.0: amdgpu: Fatal error during GPU init

Fixes: 2cd8b14aaa66 ("vfio/pci: Move to the device set infrastructure")
Fixes: eadd86f835c6 ("vfio: Remove calls to vfio_group_add_container_user()")
Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index badc9d828cac..e030c2120183 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2488,12 +2488,12 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
 	struct vfio_pci_core_device *cur;
 	bool needs_reset = false;
 
-	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
-		/* No VFIO device in the set can have an open device FD */
-		if (cur->vdev.open_count)
-			return false;
+	/* No other VFIO device in the set can be open. */
+	if (vfio_device_set_open_count(dev_set) > 1)
+		return false;
+
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
 		needs_reset |= cur->needs_reset;
-	}
 	return needs_reset;
 }
 
-- 
2.37.4

