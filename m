Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA95375165
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 11:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhEFJUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 05:20:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230113AbhEFJUT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 05:20:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620292760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9T3+gtqvRPWaN1kbhzEfYcsn4RQucKuVfAaPYhpIxaE=;
        b=fP+O2RVolWbMIF0CfCgVZxUqmmBd6cSLifyA0qSA5YOHi1c1jLGNryhRKuhH7hYJbS3ZRM
        sR1wTflR8OlchuWiF8ilvMEIl31PpwM2LqNSp4LkTO4VzDF+/6VIYAabLnNnyVX34w4LIw
        iNCEMd6ub0BbX8VGBUn6l1arIbTYyuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-YvqA8d_6MjelWBozQMda6Q-1; Thu, 06 May 2021 05:19:17 -0400
X-MC-Unique: YvqA8d_6MjelWBozQMda6Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69970802B78;
        Thu,  6 May 2021 09:19:16 +0000 (UTC)
Received: from max-t490s.redhat.com (unknown [10.36.110.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABA2419D7C;
        Thu,  6 May 2021 09:19:07 +0000 (UTC)
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
To:     alex.williamson@redhat.com, jmorris@namei.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, kvm@vger.kernel.org
Cc:     mjg59@srcf.ucam.org, keescook@chromium.org, cohuck@redhat.com,
        Maxime Coquelin <maxime.coquelin@redhat.com>
Subject: [PATCH] vfio: Lock down no-IOMMU mode when kernel is locked down
Date:   Thu,  6 May 2021 11:18:59 +0200
Message-Id: <20210506091859.6961-1-maxime.coquelin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When no-IOMMU mode is enabled, VFIO is as unsafe as accessing
the PCI BARs via the device's sysfs, which is locked down when
the kernel is locked down.

Indeed, it is possible for an attacker to craft DMA requests
to modify kernel's code or leak secrets stored in the kernel,
since the device is not isolated by an IOMMU.

This patch introduces a new integrity lockdown reason for the
unsafe VFIO no-iommu mode.

Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
---
 drivers/vfio/vfio.c      | 13 +++++++++----
 include/linux/security.h |  1 +
 security/security.c      |  1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 5e631c359ef2..fe466d6ea5d8 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/string.h>
@@ -165,7 +166,8 @@ static void *vfio_noiommu_open(unsigned long arg)
 {
 	if (arg != VFIO_NOIOMMU_IOMMU)
 		return ERR_PTR(-EINVAL);
-	if (!capable(CAP_SYS_RAWIO))
+	if (!capable(CAP_SYS_RAWIO) ||
+			security_locked_down(LOCKDOWN_VFIO_NOIOMMU))
 		return ERR_PTR(-EPERM);
 
 	return NULL;
@@ -1280,7 +1282,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 	if (atomic_read(&group->container_users))
 		return -EINVAL;
 
-	if (group->noiommu && !capable(CAP_SYS_RAWIO))
+	if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
+			security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
 		return -EPERM;
 
 	f = fdget(container_fd);
@@ -1362,7 +1365,8 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	    !group->container->iommu_driver || !vfio_group_viable(group))
 		return -EINVAL;
 
-	if (group->noiommu && !capable(CAP_SYS_RAWIO))
+	if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
+			security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
 		return -EPERM;
 
 	device = vfio_device_get_from_name(group, buf);
@@ -1490,7 +1494,8 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 	if (!group)
 		return -ENODEV;
 
-	if (group->noiommu && !capable(CAP_SYS_RAWIO)) {
+	if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
+			security_locked_down(LOCKDOWN_VFIO_NOIOMMU))) {
 		vfio_group_put(group);
 		return -EPERM;
 	}
diff --git a/include/linux/security.h b/include/linux/security.h
index 06f7c50ce77f..f29388180fab 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -120,6 +120,7 @@ enum lockdown_reason {
 	LOCKDOWN_MMIOTRACE,
 	LOCKDOWN_DEBUGFS,
 	LOCKDOWN_XMON_WR,
+	LOCKDOWN_VFIO_NOIOMMU,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
diff --git a/security/security.c b/security/security.c
index b38155b2de83..33c3ddb6dcab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -58,6 +58,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_MMIOTRACE] = "unsafe mmio",
 	[LOCKDOWN_DEBUGFS] = "debugfs access",
 	[LOCKDOWN_XMON_WR] = "xmon write access",
+	[LOCKDOWN_VFIO_NOIOMMU] = "VFIO unsafe no-iommu mode",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
-- 
2.31.1

