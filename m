Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F50161DF2D
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 23:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiKEWtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 18:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKEWto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 18:49:44 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F5612A8C
        for <kvm@vger.kernel.org>; Sat,  5 Nov 2022 15:49:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y13so7501987pfp.7
        for <kvm@vger.kernel.org>; Sat, 05 Nov 2022 15:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajNJxEoZIzXXTPYQjvuC6wM/hhZCYCl7Jf/OFsj6B8Y=;
        b=YaQPUZ6YWQd8jcp7M5FuLZG7oyfaMhTw/I2rRVGZB+gIPyDqjgrULFqK5p7yTnPtnr
         OkPyGZfOEWHDK0AjGuNMc1IQogAwBkPfX1Lb9yZ6AYg9R3cqyFkBQK3QVuhF61eLVApO
         5Xkw1zoA66vED0KLtQjNkOlzFdhfQfAYHMjtVrwAS/IAJA+McBCi/MVy8LWPLvB1RetO
         8jBaQWbvQs9s7ObWs0/3U9KYur3fOngC8T1E52UWrBWxP9hk7pZJLE+SbIEnBZHBGkBx
         3iyV27QtrYJRlhgkJgcS3JSZ9AGcOS4e5VcFSNQEgN1itqE5O5j2EDYUcwjQthb1sZBN
         HNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ajNJxEoZIzXXTPYQjvuC6wM/hhZCYCl7Jf/OFsj6B8Y=;
        b=64XQ3D4e4u9bfnB0n8v+4kRKDlsbAq3KakVKFSHeYC5mYMacpuBneCW9+S1n8YsfZv
         4aKb6eE5Qd+zMnT9pyulRrC3hc4yt9eNd9LIVHah+a2NQQCvpjBGag9tjgqmoQ2cFtoQ
         T+4EjcKeeSlPZvQL6N43bzY2xHeou3Cn60xy+ezq+93HpF+0YYCffsWZay1/kXogZnZH
         JnSHayzCKVCZAAuydRrp7oCvHtqCIryZihnEe8+fNoxNdbKDNV/JIlol/xjG2BsbIaln
         BqS3Xio7dP0VBKnayXl5zwVC7Ujz827UdItDK3rK4/rs7r/YbbxFFuHgTGd+Es+lnHjG
         NxAQ==
X-Gm-Message-State: ACrzQf0xQyhsKlzJfLEiX3Q8okiikOEYoI4dzKilOpvzYgg4nL+3uExF
        NHKzlFsQA/SAUffwcQYNdtmO0JJTlFEQXA==
X-Google-Smtp-Source: AMsMyM6Dg9mghp3xhzDo45vpeQmTilaoqsi3S8jbTzN2MMbwtve93rop3NVbkDQZCBKv9jYpC5kJ3Q==
X-Received: by 2002:a62:874f:0:b0:56c:45eb:1ffa with SMTP id i76-20020a62874f000000b0056c45eb1ffamr43206784pfe.58.1667688581812;
        Sat, 05 Nov 2022 15:49:41 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id rj14-20020a17090b3e8e00b001fde655225fsm14716728pjb.2.2022.11.05.15.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 15:49:41 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v5 2/3] vfio: Export the device set open count
Date:   Sat,  5 Nov 2022 15:44:57 -0700
Message-Id: <20221105224458.8180-3-ajderossi@gmail.com>
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

The open count of a device set is the sum of the open counts of all
devices in the set. Drivers can use this value to determine whether
shared resources are in use without tracking them manually or accessing
the private open_count in vfio_device.

Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
---
 drivers/vfio/vfio_main.c | 11 +++++++++++
 include/linux/vfio.h     |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9a4af880e941..ab34faabcebb 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -125,6 +125,17 @@ static void vfio_release_device_set(struct vfio_device *device)
 	xa_unlock(&vfio_device_set_xa);
 }
 
+unsigned int vfio_device_set_open_count(struct vfio_device_set *dev_set)
+{
+	struct vfio_device *cur;
+	unsigned int open_count = 0;
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

