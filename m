Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767EA3FB832
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 16:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbhH3O0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 10:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237220AbhH3OXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 10:23:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0735EC061760
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 07:22:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so6998278pjc.3
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 07:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C07xaPneecmbOG/2S1p4CJrqrccH6w7GBsTKs/jZSu8=;
        b=HXzHxxUEctUdMw/Tg7vmA1K2XVr7WdUktOjOycNy2jlb8xnx8zsJCIbLUBP5paIHTy
         7y8trporRqfdQvNw93cwAcsPUO3bzmLxIX4zEsYG+S/fVLC5Zw+BccWcJrTUt4Htsqk8
         03QQZZy7P91Q4DsaYrKcT7uzjV2PDkOcMYeQZnzbdOomX0bLYDdpZq+15PSgHammHK31
         Bg7o0EP6u5YUWqiOkcXdNCE8DNxzAaftyHsDZUnpAt3HLR7ZERmfY0hW4ZyFK7kLZ7l5
         1FGUNCxiHNcAjoZiI/S+VL0l9RIKadCbrlGz3ECPY3Wj3XsHrHa1z6f2U1/qVRqTZZRF
         JJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C07xaPneecmbOG/2S1p4CJrqrccH6w7GBsTKs/jZSu8=;
        b=KYcUz499p1OZ6hEaZKpiLMS2wJI+axsP7DHwyP5O44A5FD7xCPECHu6kR9dMhqn7QN
         HQ0XLMFULnRqnIcxAB6sn1Und9X5DkYj0RJu9TmMrp93veGsTnq+VOfE+EsHChuIA2jH
         F6y5JXM03nAjQnrcUH2/aSoYoXFZavVar4eDBmNnXO0n84HW16DlibSr5bY/vcAeb/bO
         YAnCnpeOddM3jZQF45OeaQETSbQEL9PkkHHxQea5UfdoVcbGcIIy+XR8i2Xu7T3upKw5
         cau0CiEXSM8OF6mrGwD8H8RqVqwSVW80YIs9DDDdzqsPIijW1KF8U11HZSrnKo1EB++l
         lNTg==
X-Gm-Message-State: AOAM533c+n35A3uFhR+CT6fS7bCBx38w1Z7lwG+F6nlob7KJ9m2jZnbo
        Sqd6e5fWgg4VWeDwV1Zb9eoO
X-Google-Smtp-Source: ABdhPJz5iri0HNltCbrXp5kUj+I/lmo35EEaIVJnXsPYibIv00PV5xHQtOyfAAm14vVpN5zVL3k6UQ==
X-Received: by 2002:a17:902:ab18:b0:138:a41d:c7a0 with SMTP id ik24-20020a170902ab1800b00138a41dc7a0mr14317614plb.6.1630333335570;
        Mon, 30 Aug 2021 07:22:15 -0700 (PDT)
Received: from localhost ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id 138sm15116060pfz.187.2021.08.30.07.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 07:22:15 -0700 (PDT)
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
Subject: [PATCH v12 06/13] vhost-vdpa: Handle the failure of vdpa_reset()
Date:   Mon, 30 Aug 2021 22:17:30 +0800
Message-Id: <20210830141737.181-7-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830141737.181-1-xieyongji@bytedance.com>
References: <20210830141737.181-1-xieyongji@bytedance.com>
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

