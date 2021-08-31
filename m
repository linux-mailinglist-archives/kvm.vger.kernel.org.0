Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42963FC61D
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 13:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbhHaKkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 06:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241131AbhHaKib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 06:38:31 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1998AC0612A9
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 03:37:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so1646332pjw.2
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 03:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C07xaPneecmbOG/2S1p4CJrqrccH6w7GBsTKs/jZSu8=;
        b=rvwTBW/chQwCs1ysBZtuOOGvFV8AoCOi2faEBCshYAhgiqxCHJHsLU0lvpLAKEC53A
         1Z5uB9MoFNJQ139cNkZQqj6o8M0OCSAnRE+xkYtpVBsgR1y8wlVPd5z+MlKaFK0bUjd+
         7w/E8RZ493mxhz0AMH5vxE5KH84DplzEYfrK5DhdpkG4TE+28RB7vzCAkgB0SnPeRW9C
         TJdrtE5YLJ+ARxPEjRFIKdCcIyOOqIynFi2Ax9SG5k5/U0yencRx0YXDRFcVDWOziXrf
         SyQglSnRCjXJD8ieWRepwEggqDxJ4QqyQPDRHM97ybs3J0jftdCffrf22EKTlZaiK/6L
         JznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C07xaPneecmbOG/2S1p4CJrqrccH6w7GBsTKs/jZSu8=;
        b=AhEZPpIs2vjJOsejNVv3F9hRcEidUzfLkGk57GI3HVoECcdQ6Fi0+U47/zA+FE22mK
         DEisE2lomp8T1cE4zvvTQzkmHBnPUvrR+Tnogp6z/U065n563jtUEraWICtmVn5EGo1a
         equ/WcRd1v2u3XmjFjljVtNyW8FQn6ZU89pFShKaOadRe3WZDlTkZAiWQP7MgXmGOptE
         SJk83ulc6sj8vtVUjESprhYKIIysV/LN7EHokxqcFeVc8cqsFxW5PdKmPlvKP5kgXM+m
         S68pI+5tjdQWMA3cH4AhYey1pVDSLQQofzMJjF7C5xtaBS0DSzgucBrq87tGp8ZMdXBk
         yG8w==
X-Gm-Message-State: AOAM5330XqxEvhaS32utG5MrpOrQuSJRmkl3twmuIPTS6SoXFvFoYEj0
        xHC57Rywe76azd7ImayhDs3F
X-Google-Smtp-Source: ABdhPJxayXvJMyHxVP3rT4nojLNgd/ffmXKTeSHlwaQVlvgNs+l4lB1isTVsta0CNNQ1iuiXOsbF6w==
X-Received: by 2002:a17:90a:d590:: with SMTP id v16mr4584722pju.205.1630406245702;
        Tue, 31 Aug 2021 03:37:25 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id l127sm7169012pfl.99.2021.08.31.03.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 03:37:25 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 06/13] vhost-vdpa: Handle the failure of vdpa_reset()
Date:   Tue, 31 Aug 2021 18:36:27 +0800
Message-Id: <20210831103634.33-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210831103634.33-1-xieyongji@bytedance.com>
References: <20210831103634.33-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vdpa_reset() may fail now. This adds check to its return
value and fail the vhost_vdpa_open().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ab7a24613982..ab39805ecff1 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -116,12 +116,13 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 }
 
-static void vhost_vdpa_reset(struct vhost_vdpa *v)
+static int vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 
-	vdpa_reset(vdpa);
 	v->in_batch = 0;
+
+	return vdpa_reset(vdpa);
 }
 
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
@@ -865,7 +866,9 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 		return -EBUSY;
 
 	nvqs = v->nvqs;
-	vhost_vdpa_reset(v);
+	r = vhost_vdpa_reset(v);
+	if (r)
+		goto err;
 
 	vqs = kmalloc_array(nvqs, sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
-- 
2.11.0

