Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FF06A971B
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 13:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjCCMRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 07:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCCMRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 07:17:34 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D1D5F538
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 04:17:33 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id l20-20020a05600c1d1400b003e10d3e1c23so2763230wms.1
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 04:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677845852;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D03Dx4Z6sjOCGLIbT2UoYAjEZ9PiPy+/g5LTNKuL45w=;
        b=Li4J2KcZYUwJ0+D32V0Voa3V2Fc7c1SAukOUyuJMz+1qJgDxWG5Mb/c0Pq2qncUSf9
         O6WmmN86zj6E0X8RgB0Ro+QOInprnevHI+aS7ISR6MHjtVFCVkrfHVqh5rXbo2N6Kewi
         oeiTMMuCsieHVI7LrKM190aXE7iCE1jidcyQMyKer4ohKWZb4oaQge72giBABF4f46pF
         nok0QFh/bMF1GCp8KqqGFTrpOUArwvAtXA+faSAHzQpSMnp7zpFIs3AcpIqwjeNcu7iy
         jRlByIJm8C4goZhiIv4cGqHMjUpaT1MWei6KpLtemLltf3GRR+g7JbOJoEC6KNOlFJUh
         okaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677845852;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D03Dx4Z6sjOCGLIbT2UoYAjEZ9PiPy+/g5LTNKuL45w=;
        b=WgEtF+kAz8U5vb7WxZtbj5bNpHM+vody+iQMS0FR0djU5/9jSKBbs6tEbG0YHAT7lj
         12M9QKH8KyOOXHqCTPesp7MTd64bG9cVel2VBDR5roeWI6UaqwRiV+1ekzGM83flFnZr
         wxvL2vy0rrGQsWFh8Vowu4qt+oGGo67XZoiQIYWh/4e0wZDsC2sv/jCy4bf+0TE0w5sj
         0EeLHUZL4s9n9J0bEjatx9jCWGtCL92c9VerjXAG/LadkeizIim4IugsBOjsG2pMjRBq
         x4CyPRJ+d93LBN4E8wEqJzcRb2xWkrJyfAQXoCcwJvygHnzIJckCv4FqIEAjvTm+s/s1
         +CMA==
X-Gm-Message-State: AO0yUKVtQ5nwztIaTXWQg8BbMCLAcfujBThjllPTWH8xA77XNB2GwE10
        Dh+ckA6hRYypsmdmUpqQIvF9woOJm8E8PA==
X-Google-Smtp-Source: AK7set/c/MIucZ0glMbV3kmk9UjPTLjQCjs1sWZdMYqqGtZH/zqjJTxTivaya6tTDuXll5hXepyDxnHM5jHhDw==
X-Received: from mostafa.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:333c])
 (user=smostafa job=sendgmr) by 2002:a05:600c:798:b0:3df:d8c9:caa9 with SMTP
 id z24-20020a05600c079800b003dfd8c9caa9mr370367wmo.7.1677845852143; Fri, 03
 Mar 2023 04:17:32 -0800 (PST)
Date:   Fri,  3 Mar 2023 12:11:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230303121151.3489618-1-smostafa@google.com>
Subject: [PATCH] vfio/platform: Fix reset_required behaviour
From:   Mostafa Saleh <smostafa@google.com>
To:     eric.auger@redhat.com, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_platform_device has a flag reset_required that can be set from
module_param or vfio driver which indicates that reset is not a
requirement and it bypasses related checks.

This was introduced and implemented in vfio_platform_probe_common in
"b5add544d67 vfio, platform: make reset driver a requirement by default"

However, vfio_platform_probe_common was removed in
"ac1237912fb vfio/amba: Use the new device life cycle helpers"

And new implementation added in vfio_platform_init_common in
"5f6c7e0831a vfio/platform: Use the new device life cycle helpers"

which causes an error even if vfio-platform.reset_required=0, as it
only guards printing and not the return as before.

This patch fixes this by returning 0 if there is no reset function
for the device and reset_required=0. This is also consistent with
checks in vfio_platform_open_device and vfio_platform_close_device.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 1a0a238ffa35..7325ff463cf0 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -650,10 +650,13 @@ int vfio_platform_init_common(struct vfio_platform_device *vdev)
 	mutex_init(&vdev->igate);
 
 	ret = vfio_platform_get_reset(vdev);
-	if (ret && vdev->reset_required)
+	if (ret && vdev->reset_required) {
 		dev_err(dev, "No reset function found for device %s\n",
 			vdev->name);
-	return ret;
+		return ret;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_init_common);
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

