Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FB368380B
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjAaU4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjAaUzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:55:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230CF12580
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBem2dexGXw3ZIql4XGcXH6PHPZautcAu+4+1fJHPSs=;
        b=V+l/W/BsEsCA8IS/o7HZwaVeIsRH+17bGrJbqrvongiXFyYlEmTEPcIn0LyKBZXti+7DOA
        oiukR5KCE0XQRdueaqXlAIbX9tGLBNAkuqjtvQSntY7RT8lEE7Ic5pkotw/lCJgX2LRqIR
        tYtXwsXrAjDhWC0twIBdZodZSQD/b9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-OOdB0gFJPguCk1nr3pgPGA-1; Tue, 31 Jan 2023 15:54:55 -0500
X-MC-Unique: OOdB0gFJPguCk1nr3pgPGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54A3885CCE4;
        Tue, 31 Jan 2023 20:54:54 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90A4240C2064;
        Tue, 31 Jan 2023 20:54:48 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, kevin.tian@intel.com, chao.p.peng@intel.com,
        peterx@redhat.com, shameerali.kolothum.thodi@huawei.com,
        zhangfei.gao@linaro.org, berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: [RFC v3 15/18] util/char_dev: Add open_cdev()
Date:   Tue, 31 Jan 2023 21:53:02 +0100
Message-Id: <20230131205305.2726330-16-eric.auger@redhat.com>
In-Reply-To: <20230131205305.2726330-1-eric.auger@redhat.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

/dev/vfio/devices/vfioX may not exist. In that case it is still possible
to open /dev/char/$major:$minor instead. Add helper function to abstract
the cdev open.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 MAINTAINERS             |  6 ++++
 include/qemu/char_dev.h | 16 +++++++++++
 util/chardev_open.c     | 61 +++++++++++++++++++++++++++++++++++++++++
 util/meson.build        |  1 +
 4 files changed, 84 insertions(+)
 create mode 100644 include/qemu/char_dev.h
 create mode 100644 util/chardev_open.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 48e41e4c1b..23f6189f63 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3247,6 +3247,12 @@ S: Maintained
 F: include/qemu/iova-tree.h
 F: util/iova-tree.c
 
+cdev Open
+M: Yi Liu <yi.l.liu@intel.com>
+S: Maintained
+F: include/qemu/char_dev.h
+F: util/chardev_open.c
+
 elf2dmp
 M: Viktor Prutyanov <viktor.prutyanov@phystech.edu>
 S: Maintained
diff --git a/include/qemu/char_dev.h b/include/qemu/char_dev.h
new file mode 100644
index 0000000000..79877fb24d
--- /dev/null
+++ b/include/qemu/char_dev.h
@@ -0,0 +1,16 @@
+/*
+ * QEMU Chardev Helper
+ *
+ * Copyright (C) 2022 Intel Corporation.
+ *
+ * Authors: Yi Liu <yi.l.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ */
+
+#ifndef QEMU_CHARDEV_HELPERS_H
+#define QEMU_CHARDEV_HELPERS_H
+
+int open_cdev(const char *devpath, dev_t cdev);
+#endif
diff --git a/util/chardev_open.c b/util/chardev_open.c
new file mode 100644
index 0000000000..d17a547962
--- /dev/null
+++ b/util/chardev_open.c
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2022 Intel Corporation.
+ * Copyright (c) 2019, Mellanox Technologies. All rights reserved.
+ *
+ * Authors: Yi Liu <yi.l.liu@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * Copied from
+ * https://github.com/linux-rdma/rdma-core/blob/master/util/open_cdev.c
+ *
+ */
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include "qemu/osdep.h"
+#include "qemu/char_dev.h"
+
+static int open_cdev_internal(const char *path, dev_t cdev)
+{
+    struct stat st;
+    int fd;
+
+    fd = qemu_open_old(path, O_RDWR);
+    if (fd == -1) {
+        return -1;
+    }
+    if (fstat(fd, &st) || !S_ISCHR(st.st_mode) ||
+        (cdev != 0 && st.st_rdev != cdev)) {
+        close(fd);
+        return -1;
+    }
+    return fd;
+}
+
+static int open_cdev_robust(dev_t cdev)
+{
+    char *devpath;
+    int ret;
+
+    /*
+     * This assumes that udev is being used and is creating the /dev/char/
+     * symlinks.
+     */
+    devpath = g_strdup_printf("/dev/char/%u:%u", major(cdev), minor(cdev));
+    ret = open_cdev_internal(devpath, cdev);
+    g_free(devpath);
+    return ret;
+}
+
+int open_cdev(const char *devpath, dev_t cdev)
+{
+    int fd;
+
+    fd = open_cdev_internal(devpath, cdev);
+    if (fd == -1 && cdev != 0) {
+        return open_cdev_robust(cdev);
+    }
+    return fd;
+}
diff --git a/util/meson.build b/util/meson.build
index 26c73e586b..1a0da2351e 100644
--- a/util/meson.build
+++ b/util/meson.build
@@ -104,4 +104,5 @@ if have_block
     util_ss.add(files('filemonitor-stub.c'))
   endif
   util_ss.add(when: 'CONFIG_LINUX', if_true: files('vfio-helpers.c'))
+  util_ss.add(when: 'CONFIG_LINUX', if_true: files('chardev_open.c'))
 endif
-- 
2.37.3

