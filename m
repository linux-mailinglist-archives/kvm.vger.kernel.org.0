Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B546C3229D0
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 13:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhBWLyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 06:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbhBWLxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 06:53:14 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E463C061794
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 03:51:53 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id h4so310150pgf.13
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 03:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y16MShBcIytk+jzNL6NsgIa34R5/jPECy2Ep+HnC7Io=;
        b=xIr0qbH0hyqp8bcFhPf+q+C/mbAlsJBB4rGHR8pPvV2A9mHbz76dTWQrlAe8oHu/vv
         DMRvy5K/FW3kg3SDIkJVXaChNKwIJAJmCx6ktcyOx9EuDesBDwqwS+iM3YEAGBDB1tT+
         xGXrzZmBdTVM1UtwBE1tiUpAV4xvqUWHeipdh5mM9aEKTSh9OKCRGF4ZuzdyVNXWtzs0
         924GHoFBEzkTMsiVPA0sCm23s87uQWeB9OKKt0mNP6yjOo8BENL9+nzGLMUHrY21uxbl
         vYTrNJXAcnmUbWERllCvbeuOUcPTyB/Fr96qta3sc4ZcoXywyDjgUkuXqbOTPzlwvvGx
         zN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y16MShBcIytk+jzNL6NsgIa34R5/jPECy2Ep+HnC7Io=;
        b=MCMkEUaJ9SQ/6wYTOdkWIwgysC07UGdBV8axyAF+3dsv16W7c2zVcJhFPXc4XwQ8Ih
         UEDaFyKnOHgH8u+1kXgm3BfTVlaQlR8RVsHWZq1yMuOK6xsgmpiRnewRRywKmb8z9aA3
         uE2RDNpE4/xzBecCacqJk9o+NOF6kPIOhf6Z3bHIxkaQmt097l8j5Xz2uLk0TR342Opd
         31C0TKJeoMqglt9RHaq/29t9YpGO44BrHO7VX0i1JMIeDymo/uYNRzMk5Kzn5dd6AKFu
         XyA3PkgZJYbQ73pVL+Ggf2xgsoHVsxrrAIttC2OdwNKt3wNTqGatsz+nTI1zBIMXheOW
         au0A==
X-Gm-Message-State: AOAM532+pw0IjMj1vPuSDPtEgXj3ukC9xcscrkfMghvUkY0VZgW2vsTA
        EeiYFHCmDcg0nuSgtn3luLGT
X-Google-Smtp-Source: ABdhPJz0svnP8vxl/Nyoh9i+jgepXZZIN6ShH/MkQ1wuSpTGILb0N2cjTKsFsQjEYCDX4twaHVuSjA==
X-Received: by 2002:a63:1648:: with SMTP id 8mr24337273pgw.392.1614081112655;
        Tue, 23 Feb 2021 03:51:52 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id 14sm22868763pfy.55.2021.02.23.03.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:51:52 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 02/11] vhost-vdpa: protect concurrent access to vhost device iotlb
Date:   Tue, 23 Feb 2021 19:50:39 +0800
Message-Id: <20210223115048.435-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vhost_dev->mutex to protect vhost device iotlb from
concurrent access.

Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index c50079dfb281..5500e3bf05c1 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -723,6 +723,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	if (r)
 		return r;
 
+	mutex_lock(&dev->mutex);
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
 		r = vhost_vdpa_process_iotlb_update(v, msg);
@@ -742,6 +743,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 		r = -EINVAL;
 		break;
 	}
+	mutex_unlock(&dev->mutex);
 
 	return r;
 }
-- 
2.11.0

