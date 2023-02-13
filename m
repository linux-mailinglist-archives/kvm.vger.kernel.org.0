Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10689693C37
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBMCaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBMCaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AD6E041
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0OmubI2NEZicuPkXPyraesqovkN5V1ARkv7LLLCRMM0=;
        b=iaI6NwhKz3cBiIlvvbo2vk8i3OR10+xhTuGWPIRnHuBmKHmTCXjoc7RLYTK3onplBYItYE
        bQ9ss+/+wnWqzCge8bB9JElwPiGEl1VSoaRnEt39NxwIdBGlYSWVcQWAceUIMISvszbYZc
        iS06+mBW6iKh3mdu4+nQ1WIv3dMokGo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-370-O6N_qcC5NTeJGTdXqesnqw-1; Sun, 12 Feb 2023 21:29:22 -0500
X-MC-Unique: O6N_qcC5NTeJGTdXqesnqw-1
Received: by mail-wm1-f69.google.com with SMTP id l31-20020a05600c1d1f00b003deab30bb8bso5427376wms.2
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0OmubI2NEZicuPkXPyraesqovkN5V1ARkv7LLLCRMM0=;
        b=eJ9Xx6cTTpUF39kzfmyvRYT1G5NFBb0mvuq/zRmZqgGl4NvOAr0Yja9zWuHeI48O8R
         xHaxPVajKgWiRhNtYMsF4JpOuUOU5xEwCuy1Y1O7qnsd0VW0w0mtzRFBZaSUS3IWHRlm
         VRGhHKxjaUtfNbAlYfQcmMgMghcw0mTK5VpG6q4VRQOK8hOEBLYNb+8EGmRf1ti8rzG8
         naWFgncMTmyCBuJDPeh6Se9rn2+TE9XV6Q2cmbVoP5pDl21YkuXkzgne+0LWP24YE9Og
         TuQtAy5JQNJSr52b/gNiIoPLyVrg7Gqs3A79qG5ZP6aQMy7Tj7V4qzMDDmlQD/huqVLK
         AN5A==
X-Gm-Message-State: AO0yUKXsPBd2ZHr6OPuQi8/zUiGPlKw+19m6PA7f3o5GTHmIEdRnG5C2
        s/LX64ubTBdFmstJ+pSnC9yc1r28DKjpwpi7zdSNVbGqCYiEcF+8z4dtlVsaRwzwyLUUjoWbp1I
        w3klgMA5/E4ys
X-Received: by 2002:a05:6000:1045:b0:2c5:598c:14b0 with SMTP id c5-20020a056000104500b002c5598c14b0mr721869wrx.20.1676255361577;
        Sun, 12 Feb 2023 18:29:21 -0800 (PST)
X-Google-Smtp-Source: AK7set9mEuAJuUUFAaKDkoF4K/Bpi3uxYbwIt8gZFY4JpKNCbwFLbmvekq3ibmA7XAgTGLiovhsauA==
X-Received: by 2002:a05:6000:1045:b0:2c5:598c:14b0 with SMTP id c5-20020a056000104500b002c5598c14b0mr721855wrx.20.1676255361324;
        Sun, 12 Feb 2023 18:29:21 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id m3-20020adfe0c3000000b002c4084d3472sm9273865wri.58.2023.02.12.18.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:20 -0800 (PST)
From:   Xxx Xx <quintela@redhat.com>
X-Google-Original-From: Xxx Xx <xxx.xx@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 05/22] util/userfaultfd: Support /dev/userfaultfd
Date:   Mon, 13 Feb 2023 03:28:54 +0100
Message-Id: <20230213022911.68490-6-xxx.xx@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213022911.68490-1-xxx.xx@gmail.com>
References: <20230213022911.68490-1-xxx.xx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

Teach QEMU to use /dev/userfaultfd when it existed and fallback to the
system call if either it's not there or doesn't have enough permission.

Firstly, as long as the app has permission to access /dev/userfaultfd, it
always have the ability to trap kernel faults which QEMU mostly wants.
Meanwhile, in some context (e.g. containers) the userfaultfd syscall can be
forbidden, so it can be the major way to use postcopy in a restricted
environment with strict seccomp setup.

Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 util/userfaultfd.c | 32 ++++++++++++++++++++++++++++++++
 util/trace-events  |  1 +
 2 files changed, 33 insertions(+)

diff --git a/util/userfaultfd.c b/util/userfaultfd.c
index 4953b3137d..fdff4867e8 100644
--- a/util/userfaultfd.c
+++ b/util/userfaultfd.c
@@ -18,10 +18,42 @@
 #include <poll.h>
 #include <sys/syscall.h>
 #include <sys/ioctl.h>
+#include <fcntl.h>
+
+typedef enum {
+    UFFD_UNINITIALIZED = 0,
+    UFFD_USE_DEV_PATH,
+    UFFD_USE_SYSCALL,
+} uffd_open_mode;
 
 int uffd_open(int flags)
 {
 #if defined(__NR_userfaultfd)
+    static uffd_open_mode open_mode;
+    static int uffd_dev;
+
+    /* Detect how to generate uffd desc when run the 1st time */
+    if (open_mode == UFFD_UNINITIALIZED) {
+        /*
+         * Make /dev/userfaultfd the default approach because it has better
+         * permission controls, meanwhile allows kernel faults without any
+         * privilege requirement (e.g. SYS_CAP_PTRACE).
+         */
+        uffd_dev = open("/dev/userfaultfd", O_RDWR | O_CLOEXEC);
+        if (uffd_dev >= 0) {
+            open_mode = UFFD_USE_DEV_PATH;
+        } else {
+            /* Fallback to the system call */
+            open_mode = UFFD_USE_SYSCALL;
+        }
+        trace_uffd_detect_open_mode(open_mode);
+    }
+
+    if (open_mode == UFFD_USE_DEV_PATH) {
+        assert(uffd_dev >= 0);
+        return ioctl(uffd_dev, USERFAULTFD_IOC_NEW, flags);
+    }
+
     return syscall(__NR_userfaultfd, flags);
 #else
     return -EINVAL;
diff --git a/util/trace-events b/util/trace-events
index c8f53d7d9f..16f78d8fe5 100644
--- a/util/trace-events
+++ b/util/trace-events
@@ -93,6 +93,7 @@ qemu_vfio_region_info(const char *desc, uint64_t region_ofs, uint64_t region_siz
 qemu_vfio_pci_map_bar(int index, uint64_t region_ofs, uint64_t region_size, int ofs, void *host) "map region bar#%d addr 0x%"PRIx64" size 0x%"PRIx64" ofs 0x%x host %p"
 
 #userfaultfd.c
+uffd_detect_open_mode(int mode) "%d"
 uffd_query_features_nosys(int err) "errno: %i"
 uffd_query_features_api_failed(int err) "errno: %i"
 uffd_create_fd_nosys(int err) "errno: %i"
-- 
2.39.1

