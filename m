Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BC3623904
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiKJBlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiKJBlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:41:01 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BFB275C2
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:41:00 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id k15so470136pfg.2
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+09jyLU6lDhuNs5pMZSMI1gUeLpq4TEKRbF8Z7vfAE=;
        b=quGu/dIyNoNYfoUaLOnhPpC6Drh6MzlOQVIRdx+/tN9n66ne2Y2jhdye0zFUICK7Os
         L+ggQFPVgGPzF0xL53MmKLhsT24S5NwvyPVRXeu3zeQdUsNQ+T5FVrid56SVQRqej6JU
         ugxRe8Cpp30PV0h7NJfND2HeYo/UhyY+TLVyjzeCoHi3+hzOzg2O/qa7yf8PoAAYFUMj
         /QSiFaYXnnf5GaoCxd3K9IY4Rn7eoWBCbTzQHkh+xqnoQIbQHqcLnq2zt0qBpZiQWX+s
         5ZLdDiQg35w0yltAiV3gitf/aYAunI0+QZKrfCmD3w5jYbH0l/Lk4Q+SEnWrBMZ6qHTr
         1UlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o+09jyLU6lDhuNs5pMZSMI1gUeLpq4TEKRbF8Z7vfAE=;
        b=j7njg8mlvbDDRYVfvYGWbYmX7wxSY+IdBSBnQlAg1gVkQun+/05/1Q56f0drF+1Nje
         YHKXca6e7wxZBSqRhpmIH1gMiabeh2u5BCUn/9QeY0Dp0b4ZIdzKQQArEDrTU+xyjnKS
         5yomDwmRzwz+QckoT4Qv04hANV+fynevrmgz4rqhEdNpfbA5NQ4XJ11q2cFtuzDm3oW7
         7U7Rp7dr3WFszyUBt3KZgZNJ8BdU9hh/N3qF8ujOp0hmEjXQEtKiPhAAfzGLOQX6k5Wn
         zu1Td9rqLsRT4e+8tQVHOGU41uuI4wZ4ZkN45LkvVUFBLNjaNbFtMvauGyd07P/o5F95
         T80w==
X-Gm-Message-State: ACrzQf0d2WMu9jIP0nJYQvgdF3xXhBjCZ0IpcKQOrcmr5LgvjWAvU9cg
        EbDqgE4l3xRjjHcb0XRGnGz7c5M3qkUfnw==
X-Google-Smtp-Source: AMsMyM5GBPV0dHnu0qo+eAe5l/VAmWFRds6l8diPV/W5VpWGrDHyAmKIM0csPNEnbAEMrJSaxfCuZg==
X-Received: by 2002:aa7:9145:0:b0:556:d001:b830 with SMTP id 5-20020aa79145000000b00556d001b830mr1570995pfi.62.1668044459914;
        Wed, 09 Nov 2022 17:40:59 -0800 (PST)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id pj4-20020a17090b4f4400b00212cf2fe8c3sm3091836pjb.1.2022.11.09.17.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 17:40:59 -0800 (PST)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v6 2/3] vfio: Export the device set open count
Date:   Wed,  9 Nov 2022 17:40:26 -0800
Message-Id: <20221110014027.28780-3-ajderossi@gmail.com>
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

The open count of a device set is the sum of the open counts of all
devices in the set. Drivers can use this value to determine whether
shared resources are in use without tracking them manually or accessing
the private open_count in vfio_device.

Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio_main.c | 13 +++++++++++++
 include/linux/vfio.h     |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9a4af880e941..6e8804fe0095 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -125,6 +125,19 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
+unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
+{
+	struct vfio_device *cur;
+	unsigned int open_count = 0;
+
+	lockdep_assert_held(&dev_set->lock);
+
+	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
+		open_count += cur->open_count;
+	return open_count;
+}
+EXPORT_SYMBOL_GPL(vfio_device_set_open_count);
+
 /*
  * Group objects - create, release, get, put, search
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e7cebeb875dd..fdd393f70b19 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -189,6 +189,7 @@ int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id);
+unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set);
 
 int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state cur_fsm,
-- 
2.37.4

