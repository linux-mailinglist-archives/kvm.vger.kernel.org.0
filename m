Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FB93A8274
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhFOOTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhFOORb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:17:31 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF38C061151
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 07:14:07 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w31so9058115pga.6
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b7apvPbQfTG1FYg2uNsocmvMG/QdC7c4RuzNmrGKxtc=;
        b=teEC3X5118RCoqRjDpVinxrBxb/ZnCm6ryA5hTE///DNJNJIJ7ry41IlzLM/WQ5RZi
         5rM29Gvy1WbJsWL0k3ucFdrxybEvdyBmK744/4SAfTdXMBCd9dtjzdV6h4lNYp1H3YAe
         RaY/wxthVmrWQYX778EfdTQbqgDLnqWYzbbAUF0xXFFqFVkE4KxZ564GQjL0iwdHK9zR
         QipmY/L7g/sua/MKoU4gAbpjYDQ8XMk0LrElfchchmEY96U4NRRm7211KAJCMtvD/tLG
         2zK0nUfsHKDTzh/XdBfdvD4OZrzHRQtNECYGSoQtBcAELiDzP1QZt2UELiaroy3e2M1k
         QF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b7apvPbQfTG1FYg2uNsocmvMG/QdC7c4RuzNmrGKxtc=;
        b=fNFzMxS+UN7ggQEoYKVJC3WvL0s7JGMP3eOZ6zzUUAVPgdi6rf4agO1wBiYWjon/VV
         ZOF3qvKzMlhu+LMKGYb8Bo5KzqFcRGRj2fnUGAaWwwhdmpXMWK6Sxe1dktt1duFKjufG
         q89W2ClXEmmbzUfxYiSA5L9zHDSAsbN0YzCOG57wUp+Ncq53yWwwQPmn/8j0SHO8JdD7
         3Jrni78lhZOk70idZIecsx7Aw6byPQ24pPQa3yyXhhnLDoL2sXZjluJGvk262SCo+X00
         v74EKcVCQsDY+pp9T8W1BVvpu//7FInPk0fBmb1dmVZJ78NwsA32PLjN4JK/1vJiepuo
         wmMg==
X-Gm-Message-State: AOAM532ylJhH1nEnx6lvBjBDXicNTM1Shu/uNqAaCB7YPBJ922GZTocv
        A244ORn+QpNHG80eVsStXzvO
X-Google-Smtp-Source: ABdhPJzJT+1d1E8F4L3uwEMXEuWS3/RAonqjFcnOvR03YvpVA7eJh794mNzTaDsLprM6LBC/PxXhrA==
X-Received: by 2002:a63:9302:: with SMTP id b2mr3039614pge.277.1623766446912;
        Tue, 15 Jun 2021 07:14:06 -0700 (PDT)
Received: from localhost ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id d8sm16097026pfq.198.2021.06.15.07.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:14:06 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 03/10] eventfd: Increase the recursion depth of eventfd_signal()
Date:   Tue, 15 Jun 2021 22:13:24 +0800
Message-Id: <20210615141331.407-4-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615141331.407-1-xieyongji@bytedance.com>
References: <20210615141331.407-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increase the recursion depth of eventfd_signal() to 1. This
is the maximum recursion depth we have found so far, which
can be triggered with the following call chain:

    kvm_io_bus_write                        [kvm]
      --> ioeventfd_write                   [kvm]
        --> eventfd_signal                  [eventfd]
          --> vhost_poll_wakeup             [vhost]
            --> vduse_vdpa_kick_vq          [vduse]
              --> eventfd_signal            [eventfd]

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 fs/eventfd.c            | 2 +-
 include/linux/eventfd.h | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index e265b6dd4f34..cc7cd1dbedd3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -71,7 +71,7 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 	 * it returns true, the eventfd_signal() call should be deferred to a
 	 * safe context.
 	 */
-	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
+	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH))
 		return 0;
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index fa0a524baed0..886d99cd38ef 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -29,6 +29,9 @@
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
+/* Maximum recursion depth */
+#define EFD_WAKE_DEPTH 1
+
 struct eventfd_ctx;
 struct file;
 
@@ -47,7 +50,7 @@ DECLARE_PER_CPU(int, eventfd_wake_count);
 
 static inline bool eventfd_signal_count(void)
 {
-	return this_cpu_read(eventfd_wake_count);
+	return this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH;
 }
 
 #else /* CONFIG_EVENTFD */
-- 
2.11.0

