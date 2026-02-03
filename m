Return-Path: <kvm+bounces-70105-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCKcDGV1gmm+UwMAu9opvQ
	(envelope-from <kvm+bounces-70105-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:23:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C65EDF305
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:23:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B7FD31395AA
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD6A38735A;
	Tue,  3 Feb 2026 22:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yiWuZSL9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DF4376BC8
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156611; cv=none; b=IAYCKVGlXC8J4Olf63ZeWxsTY3+deElBdL3g638cvpykxA1Msa9G54cAm/0zshSRdvyEsxPLbPY1kcQepzOGzqhmu93kLqMncld/Ddm6Q7wxgYLEMaZRd7IZpQXsntsnemuP8+5PsJRTciZM52yE37qlSyt6YHwY9GokUT0sxDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156611; c=relaxed/simple;
	bh=kib+TGW+Sn0wIp4wEuCVzIXogMh8yQTFjwVFCEPYhmY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tGsFxoMdGR28fTk5Gjynvonp90dBRfGOkBEgJnO3Gb7VVMrAYpy4c0Us2k/YjEw1Gsf4KFUWwBvFjzVSm3shTvD7uMpoccS0ponYHa+wor+L1xCivqe9GKXWJ4NAlWFtu5Iy6+U07fBMc97SO8L9eAGvw19rBqZxrye+up06FUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yiWuZSL9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3545b891dd1so7798393a91.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156609; x=1770761409; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cqqC2kaW5ecj2f4ECaQ1IWiF4359d2X2a1SnW9XYDSk=;
        b=yiWuZSL9Ap91iA5bMFdovEO9BPEwpndAd8N/1aB+qK5EDBFG/4Y/T0yxQQkB/QYekm
         4nY+W2kGtDRy9X6kaOKPM4nhZo0qyARf3Esk8D6AXESAc2AEtsf0rzcWxDFBj8/g0Vb/
         8amiBC5LlhHUuhehZYUiGHyqu/DvItGh+9gVddAzhc0fSuWDYKyEyYh1vMOCYzKt+IyQ
         QLB+Xln7Fa0JukUiXpA037Yc4jfW4qtF7RRQgcrdg9DnARBEd4RhOWIBafbjT3yfEWQd
         SOr+1PwaXJJrUOd943ykhUWWPnLvNKkA12E+jTmZuXCPtAptL0pKBGXi9cJJ/blwF4RS
         dCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156609; x=1770761409;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cqqC2kaW5ecj2f4ECaQ1IWiF4359d2X2a1SnW9XYDSk=;
        b=HZ+JzXZtTXNYjhnYbzo85mbiIL5fpNqK1NTQhW0sJfvwV4XACPd3CyIlj2oAxsSCvU
         dDRahIaFkCxDNDLeeb9v76LjISBNG9ibMx76VO63Gtb2/TeIdAhFyGmI3NcX9P1L/nuC
         dg4OZ5qmzTrxLSmYg9E0fP8K+pSc3Q7Qvy3CS4wUUPGAO3GKXlGre1ERDh1uUIuG4msM
         Gau+0W9OEWkEugvkqI4Mj8DbU0XzgqPq0CVQIW6kEp1p+EiXEN1/8dGP/QbzlSKCVbbo
         1tpnWK+aq8P1c00fgDNV8TLO9vLwbxHVSfvLitglGud72awsis1fRK6nyWHgHhyaGNF8
         cZYg==
X-Forwarded-Encrypted: i=1; AJvYcCVW7SSBSECIG1W6c7XmWwCOc0oXFImuEGIrSfgN8peIpVv+kXMaHiTZG+8n0fMNNs3jJas=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Jrk9/fG8/Lr5yzH3Op/8c29gojQqiMHK1GrB2RHXGGHQnndX
	suQjQRm94r9Xw01D6YfKtejvarkMRKOV7Bro8JO2zOcSfP+NtPELVb+EtucDTqXi+w0J/wv+YGc
	KoGV2J5mlyRqgPg==
X-Received: from pjpo9.prod.google.com ([2002:a17:90a:9f89:b0:34c:f8b8:349b])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e70d:b0:34c:a35d:de19 with SMTP id 98e67ed59e1d1-354871ea85fmr658805a91.33.1770156609486;
 Tue, 03 Feb 2026 14:10:09 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:46 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-13-skhawaja@google.com>
Subject: [PATCH 12/14] iommufd: Add APIs to preserve/unpreserve a vfio cdev
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, 
	YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70105-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9C65EDF305
X-Rspamd-Action: no action

Add APIs that can be used to preserve and unpreserve a vfio cdev. Use
the APIs exported by the IOMMU core to preserve/unpreserve device. Pass
the LUO preservation token of the attached iommufd into IOMMU preserve
device API. This establishes the ownership of the device with the
preserved iommufd.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/iommufd/device.c | 69 ++++++++++++++++++++++++++++++++++
 include/linux/iommufd.h        | 23 ++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 4c842368289f..30cb5218093b 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
  */
 #include <linux/iommu.h>
+#include <linux/iommu-lu.h>
 #include <linux/iommufd.h>
 #include <linux/pci-ats.h>
 #include <linux/slab.h>
@@ -1661,3 +1662,71 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(ucmd->ictx, &idev->obj);
 	return rc;
 }
+
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+int iommufd_device_preserve(struct liveupdate_session *s,
+			    struct iommufd_device *idev,
+			    u64 *tokenp)
+{
+	struct iommufd_group *igroup = idev->igroup;
+	struct iommufd_hwpt_paging *hwpt_paging;
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_attach *attach;
+	int ret;
+
+	mutex_lock(&igroup->lock);
+	attach = xa_load(&igroup->pasid_attach, IOMMU_NO_PASID);
+	if (!attach) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	hwpt = attach->hwpt;
+	hwpt_paging = find_hwpt_paging(hwpt);
+	if (!hwpt_paging || !hwpt_paging->lu_preserve) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = liveupdate_get_token_outgoing(s, idev->ictx->file, tokenp);
+	if (ret)
+		goto out;
+
+	ret = iommu_preserve_device(hwpt_paging->common.domain,
+				    idev->dev,
+				    *tokenp);
+out:
+	mutex_unlock(&igroup->lock);
+	return ret;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_preserve, "IOMMUFD");
+
+void iommufd_device_unpreserve(struct liveupdate_session *s,
+			       struct iommufd_device *idev,
+			       u64 token)
+{
+	struct iommufd_group *igroup = idev->igroup;
+	struct iommufd_hwpt_paging *hwpt_paging;
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_attach *attach;
+
+	mutex_lock(&igroup->lock);
+	attach = xa_load(&igroup->pasid_attach, IOMMU_NO_PASID);
+	if (!attach) {
+		WARN_ON(-ENOENT);
+		goto out;
+	}
+
+	hwpt = attach->hwpt;
+	hwpt_paging = find_hwpt_paging(hwpt);
+	if (!hwpt_paging || !hwpt_paging->lu_preserve) {
+		WARN_ON(-EINVAL);
+		goto out;
+	}
+
+	iommu_unpreserve_device(hwpt_paging->common.domain, idev->dev);
+out:
+	mutex_unlock(&igroup->lock);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_device_unpreserve, "IOMMUFD");
+#endif
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 6e7efe83bc5d..c4b3ed5b518c 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -9,6 +9,7 @@
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
+#include <linux/liveupdate.h>
 #include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/xarray.h>
@@ -71,6 +72,28 @@ void iommufd_device_detach(struct iommufd_device *idev, ioasid_t pasid);
 struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
 u32 iommufd_device_to_id(struct iommufd_device *idev);
 
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+int iommufd_device_preserve(struct liveupdate_session *s,
+			    struct iommufd_device *idev,
+			    u64 *tokenp);
+void iommufd_device_unpreserve(struct liveupdate_session *s,
+			       struct iommufd_device *idev,
+			       u64 token);
+#else
+static inline int iommufd_device_preserve(struct liveupdate_session *s,
+					  struct iommufd_device *idev,
+					  u64 *tokenp)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iommufd_device_unpreserve(struct liveupdate_session *s,
+					     struct iommufd_device *idev,
+					     u64 token)
+{
+}
+#endif
+
 struct iommufd_access_ops {
 	u8 needs_pin_pages : 1;
 	void (*unmap)(void *data, unsigned long iova, unsigned long length);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


