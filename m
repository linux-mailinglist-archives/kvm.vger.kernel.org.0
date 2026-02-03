Return-Path: <kvm+bounces-70104-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aPRwGY5zgmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70104-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:15:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF82DF25D
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 78F9030C9077
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48ABE385537;
	Tue,  3 Feb 2026 22:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jeCoFqmp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7262A37BE9C
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156610; cv=none; b=ENmPpPRN0AYn9TSUCYqXP4KZ4wCWfBWhp/o6kKrtFwVqUUqy5YTtoQAufMvoOsnjZnTGwJPJn9MBNhHj06yYZC2zpMthhebBuILXf3697lqYlBRqdbgdyspnNbyACfKjxJegvOoPD/lITOAjAecvU5EOW6TsSHBgDBVP97uiZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156610; c=relaxed/simple;
	bh=4pTQGXf59Tv5SczejFcsB0fW20aug+if299ScVeGJXg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f0b23AJx0YJY0LfXYOzcBkzl7d2gr1QN7Yt8LVqvrqfIrrRan+J+6PdcMqREPneH6DKe7UsflgYUZNBhdFPUh4lvrm48GJeg+6jFLpHQ0Rt6TzVkYfnCEsVbmcQ3H3/MEaafEwcWqNv91qqcz+QUXrMasI/GMG6OjMjb0lJ8N4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jeCoFqmp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c65d08b623aso176872a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156608; x=1770761408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ek4kI1rdNgBgSztIQqyckPruH667MMKt6lmcvu+Ljfo=;
        b=jeCoFqmpEUERoGxBmtlAVCASwtn2FlmfJp3VQYmCxArFNyDbPNyuG4hpJfSeHbI6w7
         kmXExil1Iqn1h6gWkWM6Oj3bJOCoAz1F31DUwToQn0EsU3uHB3+wRjKyhrNwfw+TAJXp
         ivVjYXZNkARj+CudDQ0U9cYeR+nOIRPvaT+dbdi2sYIY+4Sz83g4yT0Q/tMuEEpuJsrC
         Aq9qThaIcA2qn0xk9gld2YiKCk8F/JW15iGlPeC0djY0QtHSsQsXgOz4A7JKajbtK2Ub
         bvpr8qOyG3EKegeBc3XpwBvACmNneb8PxBfnU+V+nd8XtdjOD4e7HNaxjIpjcoTxCwIz
         SgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156608; x=1770761408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ek4kI1rdNgBgSztIQqyckPruH667MMKt6lmcvu+Ljfo=;
        b=C/cdKyqzxCDO/SC+VyvMnpdaBbIkUgE3R62vc5dim/3aO0HrcqAJDvGLzMh+cuh/Zp
         70CBCp74eisD+pCMEFPjpZTdzoLqp+krIvZh+m6Qsuz4BaltMrse9j9lYuSzNfaZ0TnA
         yRMGj7pX0RDBvy6eWWx2dYmqtTHp1zHD7Ny+6ojrQr7yfEtm3AMiLhyqvmnk80d8oAIY
         GPzxaSpuy2qIef7G7/QOlT3bMC4RCZ0Mt9mJNGQb8fF7noySXhCm4e5x1Yn7NSFPLGpW
         Wf0rgJqPv1cX4qDHXdTx8Jt+aQLWUy6G1i6GCXuDa2f85lJyL8bW6NqxRdK/4UxbXIK8
         t4og==
X-Forwarded-Encrypted: i=1; AJvYcCUhusuuXY7nEGlo9rpIC818/6MCqG/5vPpgWlv/r+qD5Gk0JMJ4MMbS51xf9vmAh36oBsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZTauAgIm496pEt3zkB1X0jclLgMe6hbVat9XxdN5tAPnnx07l
	S+47yZl1UJo34JXGG7BBqM9in5OllFv2HGb8ov8//n4yutAj85DCWTDm5YmsoDqKpdzFT78hnpd
	oUqjdBjX5dTC2rQ==
X-Received: from pfbhx8.prod.google.com ([2002:a05:6a00:8988:b0:7dd:8bba:63a2])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3a0b:b0:821:8ead:3706 with SMTP id d2e1a72fcca58-82404258523mr3716559b3a.4.1770156607937;
 Tue, 03 Feb 2026 14:10:07 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:45 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-12-skhawaja@google.com>
Subject: [PATCH 11/14] iommufd-lu: Persist iommu hardware pagetables for live update
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70104-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0DF82DF25D
X-Rspamd-Action: no action

From: YiFei Zhu <zhuyifei@google.com>

The caller is expected to mark each HWPT to be preserved with an ioctl
call, with a token that will be used in restore. At preserve time, each
HWPT's domain is then called with iommu_domain_preserve to preserve the
iommu domain.

The HWPTs containing dma mappings backed by unpreserved memory should
not be preserved. During preservation check if the mappings contained in
the HWPT being preserved are only file based and all the files are
preserved.

The memfd file preservation check is not enough when preserving iommufd.
The memfd might have shrunk between the mapping and memfd preservation.
This means that if it shrunk some pages that are right now pinned due to
iommu mappings are not preserved with the memfd. Only allow iommufd
preservation when all the iopt_pages are file backed and the memory file
was seal sealed during mapping. This guarantees that all the pages that
were backing memfd when it was mapped are preserved.

Once HWPT is preserved the iopt associated with the HWPT is made
immutable. Since the map and unmap ioctls operates directly on iopt,
which contains an array of domains, while each hwpt contains only one
domain. The logic then becomes that mapping and unmapping is prohibited
if any of the domains in an iopt belongs to a preserved hwpt. However,
tracing to the hwpt through the domain is a lot more tedious than
tracing through the ioas, so if an hwpt is preserved, hwpt->ioas->iopt
is made immutable.

When undoing this (making the iopts mutable again), there's never
a need to make some iopts mutable and some kept immutable, since
the undo only happen on unpreserve and error path of preserve.
Simply iterate all the ioas and clear the immutability flag on all
their iopts.

Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/iommufd/io_pagetable.c    |  17 ++
 drivers/iommu/iommufd/io_pagetable.h    |   1 +
 drivers/iommu/iommufd/iommufd_private.h |  25 ++
 drivers/iommu/iommufd/liveupdate.c      | 300 ++++++++++++++++++++++++
 drivers/iommu/iommufd/main.c            |  14 +-
 drivers/iommu/iommufd/pages.c           |   8 +
 include/linux/kho/abi/iommufd.h         |  39 +++
 7 files changed, 403 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kho/abi/iommufd.h

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 436992331111..43e8a2443793 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -270,6 +270,11 @@ static int iopt_alloc_area_pages(struct io_pagetable *iopt,
 	}
 
 	down_write(&iopt->iova_rwsem);
+	if (iopt_lu_map_immutable(iopt)) {
+		rc = -EBUSY;
+		goto out_unlock;
+	}
+
 	if ((length & (iopt->iova_alignment - 1)) || !length) {
 		rc = -EINVAL;
 		goto out_unlock;
@@ -328,6 +333,7 @@ static void iopt_abort_area(struct iopt_area *area)
 		WARN_ON(area->pages);
 	if (area->iopt) {
 		down_write(&area->iopt->iova_rwsem);
+		WARN_ON(iopt_lu_map_immutable(area->iopt));
 		interval_tree_remove(&area->node, &area->iopt->area_itree);
 		up_write(&area->iopt->iova_rwsem);
 	}
@@ -755,6 +761,12 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 again:
 	down_read(&iopt->domains_rwsem);
 	down_write(&iopt->iova_rwsem);
+
+	if (iopt_lu_map_immutable(iopt)) {
+		rc = -EBUSY;
+		goto out_unlock_iova;
+	}
+
 	while ((area = iopt_area_iter_first(iopt, start, last))) {
 		unsigned long area_last = iopt_area_last_iova(area);
 		unsigned long area_first = iopt_area_iova(area);
@@ -1398,6 +1410,11 @@ int iopt_cut_iova(struct io_pagetable *iopt, unsigned long *iovas,
 	int i;
 
 	down_write(&iopt->iova_rwsem);
+	if (iopt_lu_map_immutable(iopt)) {
+		up_write(&iopt->iova_rwsem);
+		return -EBUSY;
+	}
+
 	for (i = 0; i < num_iovas; i++) {
 		struct iopt_area *area;
 
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 14cd052fd320..b64cb4cf300c 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -234,6 +234,7 @@ struct iopt_pages {
 		struct {			/* IOPT_ADDRESS_FILE */
 			struct file *file;
 			unsigned long start;
+			u32 seals;
 		};
 		/* IOPT_ADDRESS_DMABUF */
 		struct iopt_pages_dmabuf dmabuf;
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 6424e7cea5b2..f8366a23999f 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -94,6 +94,9 @@ struct io_pagetable {
 	/* IOVA that cannot be allocated, struct iopt_reserved */
 	struct rb_root_cached reserved_itree;
 	u8 disable_large_pages;
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+	bool lu_map_immutable;
+#endif
 	unsigned long iova_alignment;
 };
 
@@ -712,12 +715,34 @@ iommufd_get_vdevice(struct iommufd_ctx *ictx, u32 id)
 }
 
 #ifdef CONFIG_IOMMU_LIVEUPDATE
+int iommufd_liveupdate_register_lufs(void);
+int iommufd_liveupdate_unregister_lufs(void);
+
 int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd);
+static inline bool iopt_lu_map_immutable(const struct io_pagetable *iopt)
+{
+	return iopt->lu_map_immutable;
+}
 #else
+static inline int iommufd_liveupdate_register_lufs(void)
+{
+	return 0;
+}
+
+static inline int iommufd_liveupdate_unregister_lufs(void)
+{
+	return 0;
+}
+
 static inline int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd)
 {
 	return -ENOTTY;
 }
+
+static inline bool iopt_lu_map_immutable(const struct io_pagetable *iopt)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_IOMMUFD_TEST
diff --git a/drivers/iommu/iommufd/liveupdate.c b/drivers/iommu/iommufd/liveupdate.c
index ae74f5b54735..ec11ae345fe7 100644
--- a/drivers/iommu/iommufd/liveupdate.c
+++ b/drivers/iommu/iommufd/liveupdate.c
@@ -4,9 +4,15 @@
 
 #include <linux/file.h>
 #include <linux/iommufd.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/iommufd.h>
 #include <linux/liveupdate.h>
+#include <linux/iommu-lu.h>
+#include <linux/mm.h>
+#include <linux/pci.h>
 
 #include "iommufd_private.h"
+#include "io_pagetable.h"
 
 int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd)
 {
@@ -47,3 +53,297 @@ int iommufd_hwpt_lu_set_preserve(struct iommufd_ucmd *ucmd)
 	return rc;
 }
 
+static void iommufd_set_ioas_mutable(struct iommufd_ctx *ictx)
+{
+	struct iommufd_object *obj;
+	struct iommufd_ioas *ioas;
+	unsigned long index;
+
+	xa_lock(&ictx->objects);
+	xa_for_each(&ictx->objects, index, obj) {
+		if (obj->type != IOMMUFD_OBJ_IOAS)
+			continue;
+
+		ioas = container_of(obj, struct iommufd_ioas, obj);
+
+		/*
+		 * Not taking any IOAS lock here. All writers take LUO
+		 * session mutex, and this writer racing with readers is not
+		 * really a problem.
+		 */
+		WRITE_ONCE(ioas->iopt.lu_map_immutable, false);
+	}
+	xa_unlock(&ictx->objects);
+}
+
+static int check_iopt_pages_preserved(struct liveupdate_session *s,
+				      struct iommufd_hwpt_paging *hwpt)
+{
+	u32 req_seals = F_SEAL_SEAL | F_SEAL_GROW | F_SEAL_SHRINK;
+	struct iopt_area *area;
+	int ret;
+
+	for (area = iopt_area_iter_first(&hwpt->ioas->iopt, 0, ULONG_MAX); area;
+	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+		struct iopt_pages *pages = area->pages;
+
+		/* Only allow file based mapping */
+		if (pages->type != IOPT_ADDRESS_FILE)
+			return -EINVAL;
+
+		/*
+		 * When this memory file was mapped it should be sealed and seal
+		 * should be sealed. This means that since mapping was done the
+		 * memory file was not grown or shrink and the pages being used
+		 * until now remain pinnned and preserved.
+		 */
+		if ((pages->seals & req_seals) != req_seals)
+			return -EINVAL;
+
+		/* Make sure that the file was preserved. */
+		ret = liveupdate_get_token_outgoing(s, pages->file, NULL);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int iommufd_save_hwpts(struct iommufd_ctx *ictx,
+			      struct iommufd_lu *iommufd_lu,
+			      struct liveupdate_session *session)
+{
+	struct iommufd_hwpt_paging *hwpt, **hwpts = NULL;
+	struct iommu_domain_ser *domain_ser;
+	struct iommufd_hwpt_lu *hwpt_lu;
+	struct iommufd_object *obj;
+	unsigned int nr_hwpts = 0;
+	unsigned long index;
+	unsigned int i;
+	int rc = 0;
+
+	if (iommufd_lu) {
+		hwpts = kcalloc(iommufd_lu->nr_hwpts, sizeof(*hwpts),
+				GFP_KERNEL);
+		if (!hwpts)
+			return -ENOMEM;
+	}
+
+	xa_lock(&ictx->objects);
+	xa_for_each(&ictx->objects, index, obj) {
+		if (obj->type != IOMMUFD_OBJ_HWPT_PAGING)
+			continue;
+
+		hwpt = container_of(obj, struct iommufd_hwpt_paging, common.obj);
+		if (!hwpt->lu_preserve)
+			continue;
+
+		if (hwpt->ioas) {
+			/*
+			 * Obtain exclusive access to the IOAS and IOPT while we
+			 * set immutability
+			 */
+			mutex_lock(&hwpt->ioas->mutex);
+			down_write(&hwpt->ioas->iopt.domains_rwsem);
+			down_write(&hwpt->ioas->iopt.iova_rwsem);
+
+			hwpt->ioas->iopt.lu_map_immutable = true;
+
+			up_write(&hwpt->ioas->iopt.iova_rwsem);
+			up_write(&hwpt->ioas->iopt.domains_rwsem);
+			mutex_unlock(&hwpt->ioas->mutex);
+		}
+
+		if (!hwpt->common.domain) {
+			rc = -EINVAL;
+			xa_unlock(&ictx->objects);
+			goto out;
+		}
+
+		if (!iommufd_lu) {
+			rc = check_iopt_pages_preserved(session, hwpt);
+			if (rc) {
+				xa_unlock(&ictx->objects);
+				goto out;
+			}
+		} else if (iommufd_lu) {
+			hwpts[nr_hwpts] = hwpt;
+			hwpt_lu = &iommufd_lu->hwpts[nr_hwpts];
+
+			hwpt_lu->token = hwpt->lu_token;
+			hwpt_lu->reclaimed = false;
+		}
+
+		nr_hwpts++;
+	}
+	xa_unlock(&ictx->objects);
+
+	if (WARN_ON(iommufd_lu && iommufd_lu->nr_hwpts != nr_hwpts)) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (iommufd_lu) {
+		/*
+		 * iommu_domain_preserve may sleep and must be called
+		 * outside of xa_lock
+		 */
+		for (i = 0; i < nr_hwpts; i++) {
+			hwpt = hwpts[i];
+			hwpt_lu = &iommufd_lu->hwpts[i];
+
+			rc = iommu_domain_preserve(hwpt->common.domain, &domain_ser);
+			if (rc < 0)
+				goto out;
+
+			hwpt_lu->domain_data = __pa(domain_ser);
+		}
+	}
+
+	rc = nr_hwpts;
+
+out:
+	kfree(hwpts);
+	return rc;
+}
+
+static int iommufd_liveupdate_preserve(struct liveupdate_file_op_args *args)
+{
+	struct iommufd_ctx *ictx = iommufd_ctx_from_file(args->file);
+	struct iommufd_lu *iommufd_lu;
+	size_t serial_size;
+	void *mem;
+	int rc;
+
+	if (IS_ERR(ictx))
+		return PTR_ERR(ictx);
+
+	rc = iommufd_save_hwpts(ictx, NULL, args->session);
+	if (rc < 0)
+		goto err_ioas_mutable;
+
+	serial_size = struct_size(iommufd_lu, hwpts, rc);
+
+	mem = kho_alloc_preserve(serial_size);
+	if (!mem) {
+		rc = -ENOMEM;
+		goto err_ioas_mutable;
+	}
+
+	iommufd_lu = mem;
+	iommufd_lu->nr_hwpts = rc;
+	rc = iommufd_save_hwpts(ictx, iommufd_lu, args->session);
+	if (rc < 0)
+		goto err_free;
+
+	args->serialized_data = virt_to_phys(iommufd_lu);
+	iommufd_ctx_put(ictx);
+	return 0;
+
+err_free:
+	kho_unpreserve_free(mem);
+err_ioas_mutable:
+	iommufd_set_ioas_mutable(ictx);
+	iommufd_ctx_put(ictx);
+	return rc;
+}
+
+static int iommufd_liveupdate_freeze(struct liveupdate_file_op_args *args)
+{
+	/* No-Op; everything should be made read-only */
+	return 0;
+}
+
+static void iommufd_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct iommufd_ctx *ictx = iommufd_ctx_from_file(args->file);
+	struct iommufd_hwpt_paging *hwpt;
+	struct iommufd_object *obj;
+	unsigned long index;
+
+	if (WARN_ON(IS_ERR(ictx)))
+		return;
+
+	xa_lock(&ictx->objects);
+	xa_for_each(&ictx->objects, index, obj) {
+		if (obj->type != IOMMUFD_OBJ_HWPT_PAGING)
+			continue;
+
+		hwpt = container_of(obj, struct iommufd_hwpt_paging, common.obj);
+		if (!hwpt->lu_preserve)
+			continue;
+		if (!hwpt->common.domain)
+			continue;
+
+		iommu_domain_unpreserve(hwpt->common.domain);
+	}
+	xa_unlock(&ictx->objects);
+
+	kho_unpreserve_free(phys_to_virt(args->serialized_data));
+
+	iommufd_set_ioas_mutable(ictx);
+	iommufd_ctx_put(ictx);
+}
+
+static int iommufd_liveupdate_retrieve(struct liveupdate_file_op_args *args)
+{
+	return -EOPNOTSUPP;
+}
+
+static bool iommufd_liveupdate_can_finish(struct liveupdate_file_op_args *args)
+{
+	return false;
+}
+
+static void iommufd_liveupdate_finish(struct liveupdate_file_op_args *args)
+{
+}
+
+static bool iommufd_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
+					    struct file *file)
+{
+	struct iommufd_ctx *ictx = iommufd_ctx_from_file(file);
+
+	if (IS_ERR(ictx))
+		return false;
+
+	iommufd_ctx_put(ictx);
+	return true;
+}
+
+static struct liveupdate_file_ops iommufd_lu_file_ops = {
+	.can_preserve = iommufd_liveupdate_can_preserve,
+	.preserve = iommufd_liveupdate_preserve,
+	.unpreserve = iommufd_liveupdate_unpreserve,
+	.freeze = iommufd_liveupdate_freeze,
+	.retrieve = iommufd_liveupdate_retrieve,
+	.can_finish = iommufd_liveupdate_can_finish,
+	.finish = iommufd_liveupdate_finish,
+};
+
+static struct liveupdate_file_handler iommufd_lu_handler = {
+	.compatible = IOMMUFD_LUO_COMPATIBLE,
+	.ops = &iommufd_lu_file_ops,
+};
+
+int iommufd_liveupdate_register_lufs(void)
+{
+	int ret;
+
+	ret = liveupdate_register_file_handler(&iommufd_lu_handler);
+	if (ret)
+		return ret;
+
+	ret = iommu_liveupdate_register_flb(&iommufd_lu_handler);
+	if (ret)
+		liveupdate_unregister_file_handler(&iommufd_lu_handler);
+
+	return ret;
+}
+
+int iommufd_liveupdate_unregister_lufs(void)
+{
+	WARN_ON(iommu_liveupdate_unregister_flb(&iommufd_lu_handler));
+
+	return liveupdate_unregister_file_handler(&iommufd_lu_handler);
+}
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index e1a9b3051f65..d7683244c67a 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -775,11 +775,21 @@ static int __init iommufd_init(void)
 		if (ret)
 			goto err_misc;
 	}
+
+	if (IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE)) {
+		ret = iommufd_liveupdate_register_lufs();
+		if (ret)
+			goto err_vfio_misc;
+	}
+
 	ret = iommufd_test_init();
 	if (ret)
-		goto err_vfio_misc;
+		goto err_lufs;
 	return 0;
 
+err_lufs:
+	if (IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE))
+		iommufd_liveupdate_unregister_lufs();
 err_vfio_misc:
 	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER))
 		misc_deregister(&vfio_misc_dev);
@@ -791,6 +801,8 @@ static int __init iommufd_init(void)
 static void __exit iommufd_exit(void)
 {
 	iommufd_test_exit();
+	if (IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE))
+		iommufd_liveupdate_unregister_lufs();
 	if (IS_ENABLED(CONFIG_IOMMUFD_VFIO_CONTAINER))
 		misc_deregister(&vfio_misc_dev);
 	misc_deregister(&iommu_misc_dev);
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index dbe51ecb9a20..cc0e3265ba4e 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -55,6 +55,7 @@
 #include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
+#include <linux/memfd.h>
 #include <linux/vfio_pci_core.h>
 
 #include "double_span.h"
@@ -1420,6 +1421,7 @@ struct iopt_pages *iopt_alloc_file_pages(struct file *file,
 
 {
 	struct iopt_pages *pages;
+	int seals;
 
 	pages = iopt_alloc_pages(start_byte, length, writable);
 	if (IS_ERR(pages))
@@ -1427,6 +1429,12 @@ struct iopt_pages *iopt_alloc_file_pages(struct file *file,
 	pages->file = get_file(file);
 	pages->start = start - start_byte;
 	pages->type = IOPT_ADDRESS_FILE;
+
+	pages->seals = 0;
+	seals = memfd_get_seals(file);
+	if (seals > 0)
+		pages->seals = seals;
+
 	return pages;
 }
 
diff --git a/include/linux/kho/abi/iommufd.h b/include/linux/kho/abi/iommufd.h
new file mode 100644
index 000000000000..f7393ac78aa9
--- /dev/null
+++ b/include/linux/kho/abi/iommufd.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2025, Google LLC
+ * Author: Samiullah Khawaja <skhawaja@google.com>
+ */
+
+#ifndef _LINUX_KHO_ABI_IOMMUFD_H
+#define _LINUX_KHO_ABI_IOMMUFD_H
+
+#include <linux/mutex_types.h>
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/**
+ * DOC: IOMMUFD Live Update ABI
+ *
+ * This header defines the ABI for preserving the state of an IOMMUFD file
+ * across a kexec reboot using LUO.
+ *
+ * This interface is a contract. Any modification to any of the serialization
+ * structs defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the IOMMUFD_LUO_COMPATIBLE string.
+ */
+
+#define IOMMUFD_LUO_COMPATIBLE "iommufd-v1"
+
+struct iommufd_hwpt_lu {
+	u32 token;
+	u64 domain_data;
+	bool reclaimed;
+} __packed;
+
+struct iommufd_lu {
+	unsigned int nr_hwpts;
+	struct iommufd_hwpt_lu hwpts[];
+};
+
+#endif /* _LINUX_KHO_ABI_IOMMUFD_H */
-- 
2.53.0.rc2.204.g2597b5adb4-goog


