Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A33D61A1D5
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 21:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKDUDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 16:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiKDUCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 16:02:39 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40ADC45A35
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:01:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y4so5865249plb.2
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 13:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jh/lYB5WiOxX1oSK4LWl/FL3NO8tB4pgbus8C9dwTWk=;
        b=em4fQgqI+TXrScQ/k5gwiFtYFyzXQ4CEYuZEzjarizzrodACfNrwwQtI/5wOb9j83+
         mShZ3TU8wUBb5oVOLw/AVrGL0oYsrZfYpmlpKb+Pb+3oXB+CxDBr0IIbL7VHJeeYmIqo
         iJZmiaay2FRoPdpSnispwU/kV1s71LCpDEog1yzZ0TVkQhBXnyUzA5wyO1OiuGxVseR0
         OOC1GvYf5lZajGr5T2pLodVEh5KE3ZJ0xgf7vHCl0RB9a//TWjarUg2nKGOTfVmAFaYU
         IVMS9WDBaKxZEDjJbLIxDiKG0fYHKmwf+7hukPQGI0L0btFhv9sfQYxaSKPEc6AsnYZ/
         qHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jh/lYB5WiOxX1oSK4LWl/FL3NO8tB4pgbus8C9dwTWk=;
        b=4YvPZFu5ASQjnnMqFE00UeA47jYhc8BKbsWOP8JMmavE35JqK/5U9dVunh91qP+N1e
         3az3XQd8PHM+AfaAd+iZrISrhMlhTRqHo1zKKMXDEe4YdMhD0qVrvIe+tiS7CGmtoVSS
         W+qoa04Yf0EwNxGpg0s+B/SiiIvYhF8mVvW6Yf2+lJx0Jrwnyis5ZYwT2SroTJrhC6T+
         n63FnAFM2PvvkjunlSsLW+dBZrpgu2+rikHOaNCpAMO1WfqnY0qdmGuVdYA32Pjkfq8+
         1wdYQSkhyz+Q+3pi+GwJC2gTR+uiwrb8Ah5X1bjhXWiTo7zqC9Sjl7mpJIYcgEMXO9qw
         eqNg==
X-Gm-Message-State: ACrzQf2DdgsmODd/7/YAHJMu97TIiHevw7DWylGOJnorl23Mee3twqfW
        MQJHVaC04PkLd4/Z+TnomOuUWhFUZ03AEw==
X-Google-Smtp-Source: AMsMyM7n6xzlxWpINSc7gC6ArswBZ/yS+gHl00K2gSlsK1nX4Cr7zGkC4G79z00UcVUHwPV0gfxNdg==
X-Received: by 2002:a17:902:7283:b0:188:612b:1d31 with SMTP id d3-20020a170902728300b00188612b1d31mr6333194pll.81.1667592111657;
        Fri, 04 Nov 2022 13:01:51 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id q23-20020a63cc57000000b0046f6d7dcd1dsm122545pgi.25.2022.11.04.13.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:01:51 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v4 3/3] vfio/pci: Check the device set open_count on reset
Date:   Fri,  4 Nov 2022 12:57:27 -0700
Message-Id: <20221104195727.4629-4-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221104195727.4629-1-ajderossi@gmail.com>
References: <20221104195727.4629-1-ajderossi@gmail.com>
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
in the set to determine whether a reset is needed. The current device
always has open_count == 1 within vfio_pci_core_disable(), effectively
disabling the reset logic. This field is also documented as private in
vfio_device, so it should not be used to determine whether other devices
in the set are open.

Checking for open_count > 1 on the device set fixes both issues.

After commit 2cd8b14aaa66 ("vfio/pci: Move to the device set
infrastructure"), failure to create a new file for a device would cause
the reset to be skipped due to open_count being decremented after
calling close_device() in the error path.

After commit eadd86f835c6 ("vfio: Remove calls to
vfio_group_add_container_user()"), releasing a device would always skip
the reset due to an ordering change in vfio_device_fops_release().

Failing to reset the device leaves it in an unknown state, potentially
causing errors when it is bound to a different driver.

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
index badc9d828cac..e65c70781fe2 100644
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
+	if (dev_set->open_count > 1)
+		return false;
+
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
 		needs_reset |= cur->needs_reset;
-	}
 	return needs_reset;
 }
 
-- 
2.37.4

