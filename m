Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53ACB34FB27
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 10:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhCaIG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 04:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbhCaIGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 04:06:40 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB45C061760
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 01:06:28 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q10so2449930pgj.2
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 01:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f7Vhf0sKPolvZdmmoQbWwDj+eTIPxki+8IuZB8c0Kq4=;
        b=r75Rzrne30uVZcUUdNkOzD94W4ROnkMv7fAN57hx5SsqQiycs7arb/U8T5gr66kqY2
         fsJYjTgVulWItUoSriq/FcqQzPwx3Fz0XkL0dAwW6DR6TiQZ5fh9zqob5EY+4Shmuo59
         UI6B0NIdzdqg38KAIztpGrWMwp/WjmNC3nfJE9c7zNUk4GE3UIQHNBQrvi1D/vVoIO+h
         hsdx37JQ3jSo2oFjNRGiYasaDMC3P1a1pxm9YUHLvG+1y1GhwqybDH8jya7I36j0Of6Q
         RB3uA8sHEhyNHiGFYH28UOTktfqnH1hbLdQ+8d4laajfaXV5EVw6897aE7LGfaIq5Agv
         Oyzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f7Vhf0sKPolvZdmmoQbWwDj+eTIPxki+8IuZB8c0Kq4=;
        b=LAmuzS5LdjzRqtDaE+uSD4DkDDZrSSWeZPlHLGqOxraHDrJZ9b64SH89ymc+qT2U5+
         lclf5wviLtIvMp7mDqgJy42KSp45+WGdSMVaaULVcs7dwB2GlHbF8yjVpb5YnJZkRTIG
         kt+EOV4XEJR6YoFYbY1JZp9ip5eWA9xOs/FxgITaXhEVf3pvAdQBZUr4xQYmO2wg6CFc
         xtGP4XbRrT6TX6ODsG1mLL1Uh4h9edgYF2Iq9Rh5kC6NdHkQILiFjJW4YmYFHqvEy04i
         3ZvqzKckQmnm1RwTKqShXTsjP2iK74w0X+/Umd4givyF8hPck8p1+CL9U4uPU9hhtgUl
         4OiQ==
X-Gm-Message-State: AOAM53308kk8ms0HLJT/IQPCpSg3Ro1WIYKofyOCVRxz6RAi40N/sXsN
        dXxcR0UyvnbCA0ASfIKmg9DC
X-Google-Smtp-Source: ABdhPJw5SdAYJYwggqFPCWKc2zs9T35K7EWcA/8fPQg9WcIHxPAKmkso7yE0S4NhyNQOP74BaSA/yw==
X-Received: by 2002:a63:1144:: with SMTP id 4mr2075169pgr.333.1617177988462;
        Wed, 31 Mar 2021 01:06:28 -0700 (PDT)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id 4sm1293560pjl.51.2021.03.31.01.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:06:28 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 03/10] vhost-vdpa: protect concurrent access to vhost device iotlb
Date:   Wed, 31 Mar 2021 16:05:12 +0800
Message-Id: <20210331080519.172-4-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331080519.172-1-xieyongji@bytedance.com>
References: <20210331080519.172-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vhost_dev->mutex to protect vhost device iotlb from
concurrent access.

Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 3947fbc2d1d5..63b28d3aee7c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -725,9 +725,11 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
 
+	mutex_lock(&dev->mutex);
+
 	r = vhost_dev_check_owner(dev);
 	if (r)
-		return r;
+		goto unlock;
 
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
@@ -748,6 +750,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 		r = -EINVAL;
 		break;
 	}
+unlock:
+	mutex_unlock(&dev->mutex);
 
 	return r;
 }
-- 
2.11.0

