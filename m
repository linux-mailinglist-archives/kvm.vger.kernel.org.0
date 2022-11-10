Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA13623905
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiKJBlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiKJBlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:41:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F305F26ADF
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:41:02 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso360752pjc.5
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pwT50tglKE+MepvfiCbo0G+dkcZKB4IaKAiycehi8Ik=;
        b=mYNV32i26BJCNdBwFgU6MnJMup/CdKVESp/2YW1JfIFAmBJcuchMruzI80M0Jxi6cN
         wi0CXaShYRe/x9f7qbTbzHDQNV0oXFr1vX6EvpsbsUIGtG5nm1sMpTCuLhi0Gpzy1+OC
         jK7IkRnHRC+uyjCfJ/7rO2cxrQPOi2UgG3cMWasePxaJuSsfyS2tZoBOeoiJ5ItSAxTS
         htN/sPRr1d1nYLVGQ2F5dnxBepqgIsxE/4ioPpxFSYi7m4WYskPTjXwQx/jRl9OjgKN0
         O031uRav2POLk7BeUZFzusas8gl6Yuqssz7qV4/Oy+kKZQrzCbdpa0tiiRkWTZkvzWhF
         fyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pwT50tglKE+MepvfiCbo0G+dkcZKB4IaKAiycehi8Ik=;
        b=1T85HzgKjI7z6qqzg8IA3Ep7HfSrhhoMNL9QLAqEOJ6D14B3XvDWiBdYlRpeE6Fwhs
         r+ecm+WaGZRLcqKO+Ls3AGxxaE5oqKofHeJ3wLZQwIsw+XgHQlgvTktr5m0gVx5xY4di
         dHyHjrjyVuHQXwjReKC3tR3b76uq7T9Vye+VbHtLLX9Bq+lkxd+QJTcuYz8YhApnbDRk
         3AfEme2W+VohbySsj5IaHYVyLzqIlUjfkFinuFz7eQS1cg6DAdVzrILJiCIvdAIGJHwv
         pMN90+4qtZ39vWATnXW0XWqIJJkc8bCsPpN6m1HKSAiKGTG+4/qrKoeK4V/NwcBI1FuE
         jfkQ==
X-Gm-Message-State: ACrzQf0/KattfrtF5s6ZS6mwTllhxN42EJjyMV1BxJ+gkcfMqPGHKWb6
        5STa91Nhx3lj82uWkvLbdxT15ZIo4iweog==
X-Google-Smtp-Source: AMsMyM7U9BCksOXtpVUhG0K6a5oUQ/EAQCoNj97xPijocpst7A4L0xLdJGYt3SBgy/PZg7ykPUJeOg==
X-Received: by 2002:a17:903:32cb:b0:187:4b3a:15f3 with SMTP id i11-20020a17090332cb00b001874b3a15f3mr40560524plr.5.1668044462383;
        Wed, 09 Nov 2022 17:41:02 -0800 (PST)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id pj4-20020a17090b4f4400b00212cf2fe8c3sm3091836pjb.1.2022.11.09.17.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 17:41:01 -0800 (PST)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v6 3/3] vfio/pci: Check the device set open count on reset
Date:   Wed,  9 Nov 2022 17:40:27 -0800
Message-Id: <20221110014027.28780-4-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221110014027.28780-1-ajderossi@gmail.com>
References: <20221110014027.28780-1-ajderossi@gmail.com>
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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

