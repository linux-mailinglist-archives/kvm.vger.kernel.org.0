Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F277135C311
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 12:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbhDLJ5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 05:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244782AbhDLJ4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 05:56:40 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60645C061363
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 02:55:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d124so8840256pfa.13
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 02:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WGhAYrLlT6jJ3oarrFVLtGbJxuwlJT0uonwBC7CFB2c=;
        b=SYlBPXS/JHASqZqUy2bndiWwD9J64xNpFzs6QmK/6Jw9e+EqDlRqCak4xTqYyyAaXb
         Al84xZ3Eu6eZxwmq1TET2MmneFe9K2wVlz89JdKUfWe6Tbmk8FowfLEhXSV1HTM2oEcK
         xaQKh6dcWHuKQ0f2GqecgMP2uEgHZZj2cEG9umf3bqJMSZiaDX5+QUMCDzC/dpOiMaVH
         ALr5bIKUXbb7foGQFxhkDzsAloZPjTp8aZ7kBwWLCiffI1gn3VL9/BGX1/VbRu7DeT7B
         lcZT/oD92iq8q3TtAQ5xcR6VuX9noaKNCgzy1cn/b/Q7VT/STQVHJZzeOAq0XR1LJUCb
         mFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WGhAYrLlT6jJ3oarrFVLtGbJxuwlJT0uonwBC7CFB2c=;
        b=uGuRAiLmuJ2x18pgknk4eeXOS/nSkbPLp2rYVVia9VzquXyAx3FuCwaiMUgVqafPTW
         WbRKAEDiLcR+rQjaPhmTaAUpExPxrZWGpgY80V77/y+Nme9Q71UjP/rqGKXS26Xn/wPD
         ds8jTjhr+USz11YJ2Y92sKyWnVJx77/dgq3cmI2BJI++5dUPrTszb1q84uu7k+Rml+Ss
         drpZcweINMpmoVnNCsNJb4v3iALUlkcfDZVMvs5Y4azwLrAG7SAr1kN/pABdFg1key9X
         0mYeFlZPjnIR/REaE2ZOwrrZaIT6kjSMMfxzS1GJZwIkQBNnl/zRl2lDSJtpMGkbQMW7
         rtiw==
X-Gm-Message-State: AOAM532GU7nD3UlVVQp//BauVF41lWyRHCHJJ8+jQC74m9w6hc9m8Yaq
        RVGe5Q4Bxct0IpOdV8g+qPr9
X-Google-Smtp-Source: ABdhPJz5uYW2po0H7GJV6ejIQK6lDJip/OMuXP1SmWDv+/aL39+O72IuEqq1fcdU2YBURx0p/Ca3Jw==
X-Received: by 2002:a63:1266:: with SMTP id 38mr26228922pgs.427.1618221348945;
        Mon, 12 Apr 2021 02:55:48 -0700 (PDT)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id h25sm6470647pfq.152.2021.04.12.02.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 02:55:48 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] vhost-vdpa: protect concurrent access to vhost device iotlb
Date:   Mon, 12 Apr 2021 17:55:12 +0800
Message-Id: <20210412095512.178-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protect vhost device iotlb by vhost_dev->mutex. Otherwise,
it might cause corruption of the list and interval tree in
struct vhost_iotlb if userspace sends the VHOST_IOTLB_MSG_V2
message concurrently.

Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index e0a27e336293..bfa4c6ef554e 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -745,9 +745,11 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
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
@@ -768,6 +770,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 		r = -EINVAL;
 		break;
 	}
+unlock:
+	mutex_unlock(&dev->mutex);
 
 	return r;
 }
-- 
2.11.0

