Return-Path: <kvm+bounces-70103-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOusNYdzgmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70103-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:15:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F82FDF256
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 68ED3310AE2C
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932303806BC;
	Tue,  3 Feb 2026 22:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DYU3bnSx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6DB37F737
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156608; cv=none; b=BiLmapD+TMg2yuU3e9cX7bi5/HjG7D1uOqrtJSIkMGC8qagvL5YZDmquJ7EwpNRlYXdtHWJaH4l8JNo60XI+0/ZchbhlpuR6jBzXvUJz3zcmoGTmURillE3s/b2VxhU5DWXfYWs0xHzKe7As/DnC0Vz0pQLkOad94bIRUgBtqMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156608; c=relaxed/simple;
	bh=L1gdkrfZpzHvz4nOMEwGAj6a2f4hvV7aHXOYdOFvgIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P+f66EnJszTsnBygocWE/BV+CaysC3Qf2J6KuotTgNkd8AgfwXdkw7BkEwt60BpEse20r6JZb7wuFezFwT5iGiSbIbbKdzy2j9PIvCEZ+1XOUramGpWKCoAwY/z4FAu69OzRdxddG3YCyzXwxSmFGZBQT4tADCBljxBpBiPvm5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DYU3bnSx; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c613929d317so3727659a12.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156606; x=1770761406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FO4QdmXutfGlvqQphmse6DQSnrpdmmMLD/ha8Ivm6lo=;
        b=DYU3bnSxg6vbbejoZO9VJ4yF8NQzWtpKuiN7OkCLDWOpMS1zHEB5lIdmHHmIMjNMIZ
         JeftADerTXfMR9ifUGPU1jHUw2n6LFzyD5QdtF51OOWbEnsMobIX3UbbFo5ET6BlD+bM
         JAgh/UuNnunoAuJEjMS+N11aAlmT3EW43I1Ngp1TsV60j55HRY7gVmvHdIdStQ/BGJlk
         XPlEQlC0QkVW8yTd1lMPES/C4AfRm7k91mEhZYXa4EIbVrvh4XwfvYjFXJckoyKkyBqa
         o6epLl+RKudYhI6ESVA96s4yUfVaRN18vX1hHlYv+cI0V0NuKjJDQfIsVm7KepQVxY/B
         +3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156606; x=1770761406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FO4QdmXutfGlvqQphmse6DQSnrpdmmMLD/ha8Ivm6lo=;
        b=XsCIMhw6P5YMXvITwxOGRRPI5QVUvk/2lbsb/4aAZSNCU3a5Cjru8kAgL5RVDJCva0
         L15hc2MZTF9jJAf3keELK7xtT/Qbkx8uJALCSKqmMCqwt+bouyGeTo7A+4mXeURzSwYh
         Dqz2FOe0AXrJf2/YD/WIjmfrzbeaROLmA5WFbcFMGdjBc3sTA6DLxztCymQtzuWNow2V
         oLpay+HGuZzjQYXy3GUmvkTms0AVlu77nzaiUhsIj6++sbWKhp2VFL4fpKeiNhrO3jIr
         fx+04VtKac/4Nk521h4qBiz6qFLhLY0v9phxORFwYKI7NEwKI8FMh5QZB3k7xlt+5gD2
         kwjw==
X-Forwarded-Encrypted: i=1; AJvYcCXH8u4xX99Rr9Ub6gZupCiQcZK2ZbZZwkBlzobELNihQzWjPd6NaAKJ9IWped5uinfaA+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YybNsPykZN0FJ0WFE4eiHSgFwcshbZMVBenzVd62OiQqUszuuRv
	SGc8d/E5E/LVe9+4ay4JwQf8DPXSYZxHqweBdkjDEGyxYzKmUYUxaXbU005pBEsMMgXj/eCIERK
	RIafvuH0ayj/h6g==
X-Received: from pgct9.prod.google.com ([2002:a05:6a02:5289:b0:c61:3a73:1448])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:9185:b0:366:58cc:b74b with SMTP id adf61e73a8af0-393720cfdddmr834146637.21.1770156606372;
 Tue, 03 Feb 2026 14:10:06 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:44 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-11-skhawaja@google.com>
Subject: [PATCH 10/14] iommufd-lu: Implement ioctl to let userspace mark an
 HWPT to be preserved
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: YiFei Zhu <zhuyifei@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70103-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4F82FDF256
X-Rspamd-Action: no action

From: YiFei Zhu <zhuyifei@google.com>

Userspace provides a token, which will then be used at restore to
identify this HWPT. The restoration logic is not implemented and will be
added later.

Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/iommufd/Makefile          |  1 +
 drivers/iommu/iommufd/iommufd_private.h | 13 +++++++
 drivers/iommu/iommufd/liveupdate.c      | 49 +++++++++++++++++++++++++
 drivers/iommu/iommufd/main.c            |  2 +
 include/uapi/linux/iommufd.h            | 19 ++++++++++
 5 files changed, 84 insertions(+)
 create mode 100644 drivers/iommu/iommufd/liveupdate.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 71d692c9a8f4..c3bf0b6452d3 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_IOMMUFD_DRIVER) += iova_bitmap.o
 
 iommufd_driver-y := driver.o
 obj-$(CONFIG_IOMMUFD_DRIVER_CORE) += iommufd_driver.o
+obj-$(CONFIG_IOMMU_LIVEUPDATE) += liveupdate.o
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index eb6d1a70f673..6424e7cea5b2 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -374,6 +374,10 @@ struct iommufd_hwpt_paging {
 	bool auto_domain : 1;
 	bool enforce_cache_coherency : 1;
 	bool nest_parent : 1;
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+	bool lu_preserve : 1;
+	u32 lu_token;
+#endif
 	/* Head at iommufd_ioas::hwpt_list */
 	struct list_head hwpt_item;
 	struct iommufd_sw_msi_maps present_sw_msi;
@@ -707,6 +711,15 @@ iommufd_get_vdevice(struct iommufd_ctx *ictx, u32 id)
 			    struct iommufd_vdevice, obj);
 }
 
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd);
+#else
+static inline int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd)
+{
+	return -ENOTTY;
+}
+#endif
+
 #ifdef CONFIG_IOMMUFD_TEST
 int iommufd_test(struct iommufd_ucmd *ucmd);
 void iommufd_selftest_destroy(struct iommufd_object *obj);
diff --git a/drivers/iommu/iommufd/liveupdate.c b/drivers/iommu/iommufd/liveupdate.c
new file mode 100644
index 000000000000..ae74f5b54735
--- /dev/null
+++ b/drivers/iommu/iommufd/liveupdate.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#define pr_fmt(fmt) "iommufd: " fmt
+
+#include <linux/file.h>
+#include <linux/iommufd.h>
+#include <linux/liveupdate.h>
+
+#include "iommufd_private.h"
+
+int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_hwpt_lu_set_preserve *cmd = ucmd->cmd;
+	struct iommufd_hwpt_paging *hwpt_target, *hwpt;
+	struct iommufd_ctx *ictx = ucmd->ictx;
+	struct iommufd_object *obj;
+	unsigned long index;
+	int rc = 0;
+
+	hwpt_target = iommufd_get_hwpt_paging(ucmd, cmd->hwpt_id);
+	if (IS_ERR(hwpt_target))
+		return PTR_ERR(hwpt_target);
+
+	xa_lock(&ictx->objects);
+	xa_for_each(&ictx->objects, index, obj) {
+		if (obj->type != IOMMUFD_OBJ_HWPT_PAGING)
+			continue;
+
+		hwpt = container_of(obj, struct iommufd_hwpt_paging, common.obj);
+
+		if (hwpt == hwpt_target)
+			continue;
+		if (!hwpt->lu_preserve)
+			continue;
+		if (hwpt->lu_token == cmd->hwpt_token) {
+			rc = -EADDRINUSE;
+			goto out;
+		}
+	}
+
+	hwpt_target->lu_preserve = true;
+	hwpt_target->lu_token = cmd->hwpt_token;
+
+out:
+	xa_unlock(&ictx->objects);
+	iommufd_put_object(ictx, &hwpt_target->common.obj);
+	return rc;
+}
+
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 5cc4b08c25f5..e1a9b3051f65 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -493,6 +493,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_VIOMMU_ALLOC, iommufd_viommu_alloc_ioctl,
 		 struct iommu_viommu_alloc, out_viommu_id),
+	IOCTL_OP(IOMMU_HWPT_LU_SET_PRESERVE, iommufd_hwpt_lu_set_preserve,
+		 struct iommu_hwpt_lu_set_preserve, hwpt_token),
 #ifdef CONFIG_IOMMUFD_TEST
 	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
 #endif
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 2c41920b641d..25d8cff987eb 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -57,6 +57,7 @@ enum {
 	IOMMUFD_CMD_IOAS_CHANGE_PROCESS = 0x92,
 	IOMMUFD_CMD_VEVENTQ_ALLOC = 0x93,
 	IOMMUFD_CMD_HW_QUEUE_ALLOC = 0x94,
+	IOMMUFD_CMD_HWPT_LU_SET_PRESERVE = 0x95,
 };
 
 /**
@@ -1299,4 +1300,22 @@ struct iommu_hw_queue_alloc {
 	__aligned_u64 length;
 };
 #define IOMMU_HW_QUEUE_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HW_QUEUE_ALLOC)
+
+/**
+ * struct iommu_hwpt_lu_set_preserve - ioctl(IOMMU_HWPT_LU_SET_PRESERVE)
+ * @size: sizeof(struct iommu_hwpt_lu_set_preserve)
+ * @hwpt_id: Iommufd object ID of the target HWPT
+ * @hwpt_token: Token to identify this hwpt upon restore
+ *
+ * The target HWPT will be preserved during iommufd preservation.
+ *
+ * The hwpt_token is provided by userspace. If userspace enters a token
+ * already in use within this iommufd, -EADDRINUSE is returned from this ioctl.
+ */
+struct iommu_hwpt_lu_set_preserve {
+	__u32 size;
+	__u32 hwpt_id;
+	__u32 hwpt_token;
+};
+#define IOMMU_HWPT_LU_SET_PRESERVE _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_LU_SET_PRESERVE)
 #endif
-- 
2.53.0.rc2.204.g2597b5adb4-goog


