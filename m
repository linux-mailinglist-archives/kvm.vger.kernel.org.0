Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C35615C09
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 07:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiKBGFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 02:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiKBGFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 02:05:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8720233B2
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 23:05:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso996140pjc.2
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 23:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y9uyhw9PL/OkoyPXAE/pdjREfoBueHEZ0NBGMdBg/Sc=;
        b=fUGFMkHGoMF/QkYZaDgscqM5S0tCYHRI4ZuYi7eJi8E3VJ5u5w9Ebr8dFPDPjAvSat
         sq1HSsm1EHK1lcyTdpn9rKmjEgquHRRZt2Miw7iTqqxqF0Ryv/uwp2bFlncrZ5dlKccU
         SIERlAfK56K7kQSkQbFNziOdjlYviE/I7kBt5poNHQegkiREeP1lZUmCPTClYh0YCvfY
         FKU9HhQDhUwl5dYRVvoSU/4YhOJz4uC6eC1oZls1CQIvy1jQCHVheYW88TtVJLjpK4aN
         j9tFgoGObNWAp5yagd02YPRw0//rwqH02RdgBKcjcst7kVPfF4ezQoUyHdJlPBrLZwD6
         vW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y9uyhw9PL/OkoyPXAE/pdjREfoBueHEZ0NBGMdBg/Sc=;
        b=d0ahRVTOnXE4WvscnxsdT/MqekdHEacNDRoUN3jXPcalSnCKjiNhebbA+FROhESiWS
         KrS2sYFRXZMX5aFWUb/wCB4ywlGDj6gDTgRAY3uanV+ESw0uYBXTMihXskVmMAYli0tW
         buJUsnAwPAKO7hF3cPmij+csHZXbZyi4wpQSF4SdLjlFKq8x4eVABPIKKJYfme6i5weZ
         O24qPVhyzidLWlRjyoJUtVKCiobecqD7H+LAntEoEPeMOhJ5p4B3/sQvPDuXidxiir8G
         FJaWDFRkvUvf47JMm3I3OQB0foweD3GWVh9qiN+kiPJlGkRI52GB7InnMU+x7Hz7RXNx
         +YVw==
X-Gm-Message-State: ACrzQf3Lz4whQWcT/kTGlDRhIgrHURU2FtGbfojdiwmI1auSPmBPRlWu
        dTi3Bh5NIr6gAVHy5ziqh1jlP95RK71h2A==
X-Google-Smtp-Source: AMsMyM7xupyLnGZY8PTdkxP8oEiGZqQXpjBzvNmd2jG8KVjfPqNAKKjAQhJDNwlXY53rLVukXV4fyQ==
X-Received: by 2002:a17:902:e154:b0:186:f0d5:1ac0 with SMTP id d20-20020a170902e15400b00186f0d51ac0mr22771054pla.15.1667369122061;
        Tue, 01 Nov 2022 23:05:22 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id h29-20020a63121d000000b004388ba7e5a9sm6810611pgl.49.2022.11.01.23.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 23:05:21 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v3] vfio/pci: Accept a non-zero open_count on reset
Date:   Tue,  1 Nov 2022 22:57:32 -0700
Message-Id: <20221102055732.2110-1-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
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

The implementation of vfio_pci_core_disable() inspects the open_count of
every device in the device set to determine whether a reset is needed.
This count is always non-zero for the device being disabled, effectively
disabling the reset logic.

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
v2 -> v3:
- Added WARN_ON()
- Revised commit message
v2: https://lore.kernel.org/kvm/20221026194245.1769-1-ajderossi@gmail.com/

v1 -> v2:
- Changed reset behavior instead of open_count ordering
- Retitled from "vfio: Decrement open_count before close_device()"
v1: https://lore.kernel.org/kvm/20221025193820.4412-1-ajderossi@gmail.com/

 drivers/vfio/pci/vfio_pci_core.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index badc9d828cac..f09aa84f46e5 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -174,7 +174,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 }
 
 struct vfio_pci_group_info;
-static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
+static void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups);
 
@@ -667,7 +667,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 out:
 	pci_disable_device(pdev);
 
-	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
+	vfio_pci_core_try_reset(vdev);
 
 	/* Put the pm-runtime usage counter acquired during enable */
 	if (!disable_idle_d3)
@@ -2483,14 +2483,18 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	return ret;
 }
 
-static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
+static bool vfio_pci_core_needs_reset(struct vfio_pci_core_device *vdev)
 {
+	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
 	struct vfio_pci_core_device *cur;
 	bool needs_reset = false;
 
+	if (WARN_ON(vdev->vdev.open_count > 1))
+		return false;
+
 	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
-		/* No VFIO device in the set can have an open device FD */
-		if (cur->vdev.open_count)
+		/* Only the VFIO device being reset can have an open FD */
+		if (cur != vdev && cur->vdev.open_count)
 			return false;
 		needs_reset |= cur->needs_reset;
 	}
@@ -2498,19 +2502,20 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
 }
 
 /*
- * If a bus or slot reset is available for the provided dev_set and:
+ * If a bus or slot reset is available for the provided device and:
  *  - All of the devices affected by that bus or slot reset are unused
  *  - At least one of the affected devices is marked dirty via
  *    needs_reset (such as by lack of FLR support)
  * Then attempt to perform that bus or slot reset.
  */
-static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
+static void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
 {
+	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
 	struct vfio_pci_core_device *cur;
 	struct pci_dev *pdev;
 	bool reset_done = false;
 
-	if (!vfio_pci_dev_set_needs_reset(dev_set))
+	if (!vfio_pci_core_needs_reset(vdev))
 		return;
 
 	pdev = vfio_pci_dev_set_resettable(dev_set);
-- 
2.37.4

