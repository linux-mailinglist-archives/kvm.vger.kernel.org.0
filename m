Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A7534FB18
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 10:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhCaIGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 04:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbhCaIGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 04:06:23 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2939C06175F
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 01:06:21 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so806693pjg.5
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 01:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qd7q0+7mMIaCO7kNrN03miiLmUUotvU02ar15rGLAYA=;
        b=TC4wgya5iSyGQZApckwILsZ07cID8JY+wSUKJkkjSK6QenG/Nmjt6rFLbaVUVwLWuR
         qZUC8Y0GjUhiGVid8GxHZKbu9gf4fU+lvhfmVfPgGy+5jgQjVK7BNWsvr6SfgOEkycaZ
         5vq2ipI4hpOZ0O2rO+5j+j/r4ClYjWkyP2C+gZCHd4C/hmSUIOJRWa8irRXib6jNL6bu
         kD4W62kB3IbxjCgNwxzpm1RKEIwtcxPZUTI1DX3Y9RXd+XOhqYwQUafQpdnDpvkcgH0M
         D8Gqf8VvrAIYcVLhc6Mm5fymUe/OERG1iFMO5tcrA4RGKFIGu9cfuHfcaCK9xR+LNdNI
         8BIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qd7q0+7mMIaCO7kNrN03miiLmUUotvU02ar15rGLAYA=;
        b=pMEv7Z3xnS7aTMVBM0VmihVyL+/sH+GZa4xIJ7XPDfCbyy7oF5HFMbsywB/qeu7lNS
         fr4ZoPbiRDmfZfctijBkWHsGNICEr60ByZ6oQyOOWcRKbxcNsg7CparkCKXCcafkbSDE
         x+QDYW25sZ7YfDjDLaKHqwYeohhHsuD7IjVAlRnnCaj5VY0WBKX1EKE84DRx91fgPLsP
         9rlLTZCnGJK50nXCdlL2GqC1YtREvyAvC2YoOJzQlYuE5qs9czsqk1bJubEkNFU1n2V7
         WUnoLAvBw/kJV77WhoGF+N0zUS0ZXrJ3P8OaFsAFSh1xSwiewo5RTXXR7WzPmAmpSrv/
         u+sg==
X-Gm-Message-State: AOAM530E+CHlG6XDW8ArT4Yr5ojG591KXmNdHwBroMgLL69/14Te912c
        kJ0AIMEF7225LFtsHV7W/xhg
X-Google-Smtp-Source: ABdhPJydrF0nk0d3cE3vx8KgidDGa8Zfry5KovS8f39HDenv+8gD9ih8HKxbhTFZ2J9TJmZpWj0qlg==
X-Received: by 2002:a17:90a:fb83:: with SMTP id cp3mr2363661pjb.33.1617177981360;
        Wed, 31 Mar 2021 01:06:21 -0700 (PDT)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id 23sm1644744pgo.53.2021.03.31.01.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:06:20 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 01/10] file: Export receive_fd() to modules
Date:   Wed, 31 Mar 2021 16:05:10 +0800
Message-Id: <20210331080519.172-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331080519.172-1-xieyongji@bytedance.com>
References: <20210331080519.172-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export receive_fd() so that some modules can use
it to pass file descriptor between processes without
missing any security stuffs.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/file.c            | 6 ++++++
 include/linux/file.h | 7 +++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index dab120b71e44..d7d957217576 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1108,6 +1108,12 @@ int __receive_fd(int fd, struct file *file, int __user *ufd, unsigned int o_flag
 	return new_fd;
 }
 
+int receive_fd(struct file *file, unsigned int o_flags)
+{
+	return __receive_fd(-1, file, NULL, o_flags);
+}
+EXPORT_SYMBOL(receive_fd);
+
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
diff --git a/include/linux/file.h b/include/linux/file.h
index 225982792fa2..4667f9567d3e 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -94,6 +94,9 @@ extern void fd_install(unsigned int fd, struct file *file);
 
 extern int __receive_fd(int fd, struct file *file, int __user *ufd,
 			unsigned int o_flags);
+
+extern int receive_fd(struct file *file, unsigned int o_flags);
+
 static inline int receive_fd_user(struct file *file, int __user *ufd,
 				  unsigned int o_flags)
 {
@@ -101,10 +104,6 @@ static inline int receive_fd_user(struct file *file, int __user *ufd,
 		return -EFAULT;
 	return __receive_fd(-1, file, ufd, o_flags);
 }
-static inline int receive_fd(struct file *file, unsigned int o_flags)
-{
-	return __receive_fd(-1, file, NULL, o_flags);
-}
 static inline int receive_fd_replace(int fd, struct file *file, unsigned int o_flags)
 {
 	return __receive_fd(fd, file, NULL, o_flags);
-- 
2.11.0

