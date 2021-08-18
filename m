Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2D33F0362
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 14:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhHRMJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 08:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbhHRMIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 08:08:31 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A54C0617AD
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 05:07:52 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w68so1909188pfd.0
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 05:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CkhRtVDUgb41zlq5OfgVAHJFRMwL0PptQO/kVg6fccA=;
        b=OovSAa+epA24aO5u/6uAq1flAsC1ow2M+8fLj8oCp66s4dngG/1v4SFk+KWpajGcIo
         0ASRai1lXZqvhfuj9PeHkOTmZ/zDsUIOcyqXarUc2S/SfKFPSxoF3lYdUyJ+EIWIV+Dg
         yvp5cHwAD/KqDJTJmISlwDPfT2UPt6DjNxvLNNh2NcJsrzCM9HJkvUJY2vzhstKMBVfV
         K4pZlgqvJuLljhLcMnVoirXXAqYOV6QelXUCvTJ1ZdNuLH9uIScEterj+pQYWdyMlN9z
         5rzkIrqTb/iw9LeDMwTHoHUzBO6E1jXM3i2N2lJMsxdKQnzHCJ1veWsrWH9JZmfHyD8y
         /Wdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CkhRtVDUgb41zlq5OfgVAHJFRMwL0PptQO/kVg6fccA=;
        b=p4qgcPZ2cDrTsaby8P7K0nF3fqUCX45T8qFwqDftYH2Drs34nRoRz2K6WtPUQrZeRk
         5bIiC+09aos7wTaGwejKb5zOfzAHAyJXY8ehd1BKcNyQgXrztF9X6Q6p/Y0xaKxJ7IwK
         Mi71fXFqL/Bnicit6d7LXfLe2/Yv17Dfa2ITdSy7+6JKvsYzAefOcKqZmwT3hgKVc33J
         2wmQmz/9IsITfeIPO8vLJFjirg8mc6V8fIFXpk2/Ab3R/2XhpKu2urROu3aJqnxf/L6l
         4iBxPV2VFlWUhMWHwq19mHuIwsNXA1O92s/7ebeNhC6LYLoybtddQICXXWR7pSZJsV8Y
         KSXw==
X-Gm-Message-State: AOAM531ercChr2fEkKf2GWbrFkzbJ/oAujXX4G/VND3OuCbOD8fy+lPD
        m9OsGLKV/7zFQzMoAmUfM6NB
X-Google-Smtp-Source: ABdhPJwADZG0bCD91dAS/9CLSDalLvr2jMZAhlZq7FfHtKSxKbx5WGmFt3/oaOQYoi0HAdY6FS2TIw==
X-Received: by 2002:a65:6459:: with SMTP id s25mr8703373pgv.7.1629288472254;
        Wed, 18 Aug 2021 05:07:52 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id h7sm4996162pjs.38.2021.08.18.05.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:07:51 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 02/12] file: Export receive_fd() to modules
Date:   Wed, 18 Aug 2021 20:06:32 +0800
Message-Id: <20210818120642.165-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120642.165-1-xieyongji@bytedance.com>
References: <20210818120642.165-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export receive_fd() so that some modules can use
it to pass file descriptor between processes without
missing any security stuffs.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 fs/file.c            | 6 ++++++
 include/linux/file.h | 7 +++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 86dc9956af32..210e540672aa 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1134,6 +1134,12 @@ int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
 	return new_fd;
 }
 
+int receive_fd(struct file *file, unsigned int o_flags)
+{
+	return __receive_fd(file, NULL, o_flags);
+}
+EXPORT_SYMBOL_GPL(receive_fd);
+
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
diff --git a/include/linux/file.h b/include/linux/file.h
index 2de2e4613d7b..51e830b4fe3a 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -94,6 +94,9 @@ extern void fd_install(unsigned int fd, struct file *file);
 
 extern int __receive_fd(struct file *file, int __user *ufd,
 			unsigned int o_flags);
+
+extern int receive_fd(struct file *file, unsigned int o_flags);
+
 static inline int receive_fd_user(struct file *file, int __user *ufd,
 				  unsigned int o_flags)
 {
@@ -101,10 +104,6 @@ static inline int receive_fd_user(struct file *file, int __user *ufd,
 		return -EFAULT;
 	return __receive_fd(file, ufd, o_flags);
 }
-static inline int receive_fd(struct file *file, unsigned int o_flags)
-{
-	return __receive_fd(file, NULL, o_flags);
-}
 int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags);
 
 extern void flush_delayed_fput(void);
-- 
2.11.0

