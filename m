Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A07693C84
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjBMCxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMCxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3981E1027E
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0OmubI2NEZicuPkXPyraesqovkN5V1ARkv7LLLCRMM0=;
        b=NoPF0Hvdsclm8krhnQpVNAbFbu35GnlrGSzNG/xCTP3Gqcr3cTTlPnXrHKQTqv/WDokpmW
        cbqsPqf5oQc01/tLvMQxPGKUr4uotN+xiIU0zvbemdn1sFmehvp+mcjRG+meBdWExiKn7G
        zcjXi4KE9BAV7Pb4LrEzU+whGw9lga8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-ayEy2j1uNcOe0aV3tYCCpg-1; Sun, 12 Feb 2023 21:52:02 -0500
X-MC-Unique: ayEy2j1uNcOe0aV3tYCCpg-1
Received: by mail-wm1-f69.google.com with SMTP id n4-20020a05600c3b8400b003dfe223de49so8393740wms.5
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0OmubI2NEZicuPkXPyraesqovkN5V1ARkv7LLLCRMM0=;
        b=C8UmAPmQtFtnrjcgqSLgL2ta4yKB+wq+FD2eF7Kgqjs7fQPCUhbziHQTaTSJlzv9nR
         jzH8rkQDpDY4NAVp0R48MufB3mFpa2jGZQT+8+kU6O4EC+D2SF9nMyU6BIDDlg/a/WDQ
         oB12XQ6Olrw3zlkV2DRIoy1A5FU5pIWbFnNjBKxuNdNz1ei5VwqJ+WXhGElaygbxgp64
         TdfNj7ud7FogSrKSYdgropvThwpsWdkLEz2DGuxpby3xDPkYmCk5AlDiOlsoHNggj39o
         1xqn83rjVvMsQ42AAxJ/ALqXMyIYvPVAgOi/Q42pUgSTe0CA7KZnYPzPDzIC5dulzkI8
         l89g==
X-Gm-Message-State: AO0yUKU1rjMUTX84XS0MmqUFxBb3HNSAi9Pj/PbuTkFSIvJVmZvETZcC
        Em/1qcluM8yjl6aOhPRxYHKLg44EeJBP15M5Ol4xJmULuDSDpCmfXRdhHl3knyWDgDqt9HEdzS2
        tqjrFK7vFTQk4
X-Received: by 2002:a5d:44c6:0:b0:2c3:f534:67b3 with SMTP id z6-20020a5d44c6000000b002c3f53467b3mr19781948wrr.23.1676256720837;
        Sun, 12 Feb 2023 18:52:00 -0800 (PST)
X-Google-Smtp-Source: AK7set+XmQP6yyfclPif2uPQymsWwytLhMOk9we0ppZUPzNyug7vHOwAYOJ+MojLyInFZJ8Zw4XLpw==
X-Received: by 2002:a5d:44c6:0:b0:2c3:f534:67b3 with SMTP id z6-20020a5d44c6000000b002c3f53467b3mr19781939wrr.23.1676256720657;
        Sun, 12 Feb 2023 18:52:00 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id q9-20020a5d6589000000b002c559405a1csm1103706wru.20.2023.02.12.18.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:51:59 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PULL 05/22] util/userfaultfd: Support /dev/userfaultfd
Date:   Mon, 13 Feb 2023 03:51:33 +0100
Message-Id: <20230213025150.71537-6-quintela@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213025150.71537-1-quintela@redhat.com>
References: <20230213025150.71537-1-quintela@redhat.com>
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

