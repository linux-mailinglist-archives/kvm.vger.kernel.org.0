Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0B3229B9
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 12:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhBWLxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 06:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhBWLwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 06:52:35 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB560C06178B
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 03:51:49 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w18so8615163pfu.9
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 03:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c3yBROiXapYXwEB1EPrfm+Nn9EEmtLH7D5B0d4oZlD4=;
        b=yGAHM8CXAX/x224wjeWCQAdixy7fpHoGLdsZfgNfS/gc7Vsv1CMk83cLMhmqBbU78u
         F7/x93MGjcQvvo1ZeiDs4pZOazPlpnHThYBXANWVPpUvXakoz3duDUKs66lbYhshiqck
         Vl8s010niUh8rCEDp2+4PAEVavuqnqjQo5fwfVAqkPCKcXCfoYOWMwBs94oLtXS2kAnX
         CteuR3/gRPG/nabtf6uiiOqLZcNe/zTTa5iwfcz5k8mPtzr3BXzLXuKFt+85uzhTyDqq
         cg4ng/58CgyFL3HinNfWnwCG3wSdZevKQb4eaj6iaO9sd24moq/n/tOdZ9kiZmHHhIBb
         O5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c3yBROiXapYXwEB1EPrfm+Nn9EEmtLH7D5B0d4oZlD4=;
        b=qhtSkq2LYzxqVfmEGUuDnHi7pbcOILmU4kdUtrHCKq4x2clkcwix6sIBqF/UR0WXOy
         vFgI4hNtNckm6+/sIesJh7YXE1SMzoVXEbG5xVsE4B4deXm/9GwK+Z7lA9ORT5vVAU8n
         FpKrrSqBJX28BOIkmx438WcSY+iqDx+bM3ZkqjAAMT9Rao7vqrTp3Ht8o+hbl39s5eIt
         FBWOpECZev8KNFYAh+MmcdjV9AnbeXEDFNfJrO4xh/psrMEfqd5f+GG8HwMjzFFdEqUM
         M/EhZ3NQn4+J3QHhqnxlckhjYAQh2NMGaBgkvH4WGJUGRlLrALvw6Rq5AFAxZ0n7JAj3
         8Uvg==
X-Gm-Message-State: AOAM531hJ4iNmpLIKlTEinzNtBsd3w944WtPhOGyhv1Ca7O+A1x/fbWz
        vj5/6BLAT2IAahEqPcJjUOje
X-Google-Smtp-Source: ABdhPJwAHNMqoT+iE+s8fClzO6jv2nzIUjZdtdu3bpXHD3CThaZLgO4WvJzwBPfwmbfWQrMRm/TBkw==
X-Received: by 2002:a65:4947:: with SMTP id q7mr11508562pgs.83.1614081109248;
        Tue, 23 Feb 2021 03:51:49 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id l15sm3001657pjq.9.2021.02.23.03.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:51:48 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 01/11] eventfd: Increase the recursion depth of eventfd_signal()
Date:   Tue, 23 Feb 2021 19:50:38 +0800
Message-Id: <20210223115048.435-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increase the recursion depth of eventfd_signal() to 1. This
is the maximum recursion depth we have found so far.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
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

