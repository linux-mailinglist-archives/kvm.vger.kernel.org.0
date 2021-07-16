Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F383CB5FF
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 12:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbhGPK0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 06:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238938AbhGPK0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 06:26:35 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98000C06175F
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 03:23:40 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k20so9516228pgg.7
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 03:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O+aoi4mzR9R0iZuLemuHjtXgfA9womLoAerCtxXTQaU=;
        b=EGvXh4cu9xHTBQMHWEdPcpq0Cehs0/omnlJ7DpLTRy4lJ44ulzrdc7Nk6Ng1rMSWCF
         on1ymYszZTIM8tY2LL6bBOOvdANp+flT1o+DR0mo/1esxdpEll1K9tjgfnVCidwoumyR
         UBy1cO9cYEGzMGNL15FYBzmsA9K1iIb/PGJmy38XQFZRA52RKVxwNm6u4DWKuR6uJSrd
         2mHjCoJmKdM13gH+qPdJJz9xV6k4UyJhC6xMxFXwKFOmBOMEY49nrwL/daEURrsrbn4l
         UJXsTjUl0kZ67KBVXHNZatfysQn7hG+yrBf0qZT99bB49bgr6nW9Rr/jrpwW1uW4n0+V
         Holg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O+aoi4mzR9R0iZuLemuHjtXgfA9womLoAerCtxXTQaU=;
        b=e7DbYn+l7e8gowURE5ZOo9JjqeSIRL7i12kgfs5YCnpDpJ4TJs1jx3UNwKqoBZKZPJ
         l5FVY7yVFM92W9zRe4fHYzRtlR3DssbfduVIilahYEC+C4o9/8k9RvHquwynrtWoPaJi
         4ElEhwr9JydTPfTbDHCSIMcvFWmKilYVBbOiLoKXplmC0u40MLe6/p/hTpIp/9ceQcSk
         qf5MFn7CI6IK1ua1RqCNIDwZ++ILsbhxiNOE4a8tM6gTqS4trMBeNXtWzCUBn5N695C1
         nvnOg5Hjfd7jkIw78fexBqPvUYRl0Xe5rjFL4jMX1WGGeCIs5wnvSMwW/q8d6j8Dj+nV
         qTrw==
X-Gm-Message-State: AOAM531v93eZah/Mk7zTVKKuNRWSoNbFi73y/QtzV9zLVL8lgk0j7TPe
        IT1/ex4y1+UNc9GeB16uVAei
X-Google-Smtp-Source: ABdhPJxuw98GR5HK3YBPh9STuop2yfagNpyb+GFBdHn1W/rAoINiKBfEzL6gAM6RByS5JfWFM0Uw3g==
X-Received: by 2002:a05:6a00:1a09:b029:32c:7b3a:837 with SMTP id g9-20020a056a001a09b029032c7b3a0837mr9616864pfv.36.1626431020225;
        Fri, 16 Jul 2021 03:23:40 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id k19sm8137435pji.32.2021.07.16.03.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 03:23:39 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] vhost: Fix the calculation in vhost_overflow()
Date:   Fri, 16 Jul 2021 18:22:39 +0800
Message-Id: <20210716102239.96-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210716102239.96-1-xieyongji@bytedance.com>
References: <20210716102239.96-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes the incorrect calculation for integer overflow
when the last address of iova range is 0xffffffff.

Fixes: ec33d031a14b ("vhost: detect 32 bit integer wrap around“)
Reported-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b9e853e6094d..a9fd1b311d2f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -738,7 +738,8 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
 static bool vhost_overflow(u64 uaddr, u64 size)
 {
 	/* Make sure 64 bit math will not overflow. */
-	return uaddr > ULONG_MAX || size > ULONG_MAX || uaddr > ULONG_MAX - size;
+	return uaddr > ULONG_MAX || size > ULONG_MAX ||
+	       uaddr - 1 > ULONG_MAX - size;
 }
 
 /* Caller should have vq mutex and device mutex. */
-- 
2.11.0

