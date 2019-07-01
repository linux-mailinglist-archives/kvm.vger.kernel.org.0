Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402B81CBAC
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfENPRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:17:52 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:50202 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfENPRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557847070; x=1589383070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=QcDO1x50vykS6alzxzUfHSiSasm/D0Pn85L/rydHfIg=;
  b=iGuZbAcHU/uW5drVq4BdCd6m3R2qTj943B0sMg4Y0p/GJHYuD+L1VRN+
   ljGraFVcpival74uwDBwUi7Lqw+1Ff4EyEXRZyjq+SQQJIx0ImjFAfoaQ
   z1mlCD+Ub83E7CPuMOMYtD1LByaMtLiFGgLEUQyH2DUatqZXPpPrUIO9V
   s=;
X-IronPort-AV: E=Sophos;i="5.60,469,1549929600"; 
   d="scan'208";a="804590402"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 May 2019 15:17:46 +0000
Received: from uf8b156e456a5587c9af4.ant.amazon.com (iad7-ws-svc-lb50-vlan2.amazon.com [10.0.93.210])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x4EFHegZ104209
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 14 May 2019 15:17:43 GMT
Received: from uf8b156e456a5587c9af4.ant.amazon.com (localhost [127.0.0.1])
        by uf8b156e456a5587c9af4.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x4EFHd8C028010;
        Tue, 14 May 2019 17:17:39 +0200
Received: (from sironi@localhost)
        by uf8b156e456a5587c9af4.ant.amazon.com (8.15.2/8.15.2/Submit) id x4EFHdra028007;
        Tue, 14 May 2019 17:17:39 +0200
From:   Filippo Sironi <sironi@amazon.de>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, boris.ostrovsky@oracle.com,
        cohuck@redhat.com, konrad.wilk@oracle.com,
        xen-devel@lists.xenproject.org, vasu.srinivasan@oracle.com
Cc:     Filippo Sironi <sironi@amazon.de>
Subject: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM entries
Date:   Tue, 14 May 2019 17:16:41 +0200
Message-Id: <1557847002-23519-2-git-send-email-sironi@amazon.de>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557847002-23519-1-git-send-email-sironi@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Start populating /sys/hypervisor with KVM entries when we're running on
KVM. This is to replicate functionality that's available when we're
running on Xen.

Start with /sys/hypervisor/uuid, which users prefer over
/sys/devices/virtual/dmi/id/product_uuid as a way to recognize a virtual
machine, since it's also available when running on Xen HVM and on Xen PV
and, on top of that doesn't require root privileges by default.
Let's create arch-specific hooks so that different architectures can
provide different implementations.

Signed-off-by: Filippo Sironi <sironi@amazon.de>
---
v2:
* move the retrieval of the VM UUID out of uuid_show and into
  kvm_para_get_uuid, which is a weak function that can be overwritten

 drivers/Kconfig              |  2 ++
 drivers/Makefile             |  2 ++
 drivers/kvm/Kconfig          | 14 ++++++++++++++
 drivers/kvm/Makefile         |  1 +
 drivers/kvm/sys-hypervisor.c | 30 ++++++++++++++++++++++++++++++
 5 files changed, 49 insertions(+)
 create mode 100644 drivers/kvm/Kconfig
 create mode 100644 drivers/kvm/Makefile
 create mode 100644 drivers/kvm/sys-hypervisor.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 45f9decb9848..90eb835fe951 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -146,6 +146,8 @@ source "drivers/hv/Kconfig"
 
 source "drivers/xen/Kconfig"
 
+source "drivers/kvm/Kconfig"
+
 source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index c61cde554340..79cc92a3f6bf 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -44,6 +44,8 @@ obj-y				+= soc/
 obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_XEN)		+= xen/
 
+obj-$(CONFIG_KVM_GUEST)		+= kvm/
+
 # regulators early, since some subsystems rely on them to initialize
 obj-$(CONFIG_REGULATOR)		+= regulator/
 
diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
new file mode 100644
index 000000000000..3fc041df7c11
--- /dev/null
+++ b/drivers/kvm/Kconfig
@@ -0,0 +1,14 @@
+menu "KVM driver support"
+        depends on KVM_GUEST
+
+config KVM_SYS_HYPERVISOR
+        bool "Create KVM entries under /sys/hypervisor"
+        depends on SYSFS
+        select SYS_HYPERVISOR
+        default y
+        help
+          Create KVM entries under /sys/hypervisor (e.g., uuid). When running
+          native or on another hypervisor, /sys/hypervisor may still be
+          present, but it will have no KVM entries.
+
+endmenu
diff --git a/drivers/kvm/Makefile b/drivers/kvm/Makefile
new file mode 100644
index 000000000000..73a43fc994b9
--- /dev/null
+++ b/drivers/kvm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_KVM_SYS_HYPERVISOR) += sys-hypervisor.o
diff --git a/drivers/kvm/sys-hypervisor.c b/drivers/kvm/sys-hypervisor.c
new file mode 100644
index 000000000000..43b1d1a09807
--- /dev/null
+++ b/drivers/kvm/sys-hypervisor.c
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <asm/kvm_para.h>
+
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+
+__weak const char *kvm_para_get_uuid(void)
+{
+	return NULL;
+}
+
+static ssize_t uuid_show(struct kobject *obj,
+			 struct kobj_attribute *attr,
+			 char *buf)
+{
+	const char *uuid = kvm_para_get_uuid();
+	return sprintf(buf, "%s\n", uuid);
+}
+
+static struct kobj_attribute uuid = __ATTR_RO(uuid);
+
+static int __init uuid_init(void)
+{
+	if (!kvm_para_available())
+		return 0;
+	return sysfs_create_file(hypervisor_kobj, &uuid.attr);
+}
+
+device_initcall(uuid_init);
-- 
2.7.4

