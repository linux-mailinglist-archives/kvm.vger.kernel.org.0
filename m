Return-Path: <kvm+bounces-70098-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8JY5DdhygmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70098-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:12:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F11DF205
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:12:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1998A30241B7
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B233B374179;
	Tue,  3 Feb 2026 22:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G0HCQ5zc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3673137107B
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156600; cv=none; b=rqdavl5Xtnu66Ec8hYjdSo6LjTArgXF769OWrGHD3GW5quxKg/jD8CA5mhu/ZrMC1cfLJnbqXT8ukxFAJmTax7glrZ3UUSQijzMazc8iau4BZdsveR5dRAJPP5ngWBsK96l0bzwF7Vb9CS8iiZSzQOGgm1qTs1azrFfx4zMv5mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156600; c=relaxed/simple;
	bh=XmH949+cFNYEHjPb6Flo1g0WANgdqrWkFIs/6XqOnbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c+J4Br+ZfuKtRPdjnTongQmEI+zPgdNqiYKe2BNAMAI8yOcL84PF9NY03ryZ91Wpz7WYfkf5Szqz28na/UCQ36UteZ5ajEaj9Uj91lhEZVrmNCYNZwfe/nyHKIE4YFudPdF/W33QBrF6r4y84GP0p1i/bvedXnJ5L5sQp8gZ1sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G0HCQ5zc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a377e15716so162983775ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156598; x=1770761398; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yiKJgtR9ONUoXQPN4oexiJxFq7KWJtr+8+pAjx8UEac=;
        b=G0HCQ5zcM0mFtsB9CivvieMXS54Ms68VJ3V+S54m4DUsk86SjMyjQNybGwxhaYfLAw
         EDoCajjptvM3QUe8Z5FX9QyX2+3/a8b5Z7W6FS0QHUmM4h6UDPpc40J9oD2EpKa9JkqP
         1DSSS0D2HBlV/OZbn1FSfiD7Bsp2fqBYLISQnHiQfJaLS6hzDG6rtHH3er8KhmZsSb1q
         0KbLtkb6DOg0ZFithjlzXfHWIzO2aPdF/6bp/0mV3s52EUYRwDHoSPeoRp/PHvafeZt3
         07jY5YhGpIbCQEqahVlMtemoIMiThFMLICGIpxhSFXs90dGhAUxtsJJsDMCCPL8BpDMO
         ahVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156598; x=1770761398;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yiKJgtR9ONUoXQPN4oexiJxFq7KWJtr+8+pAjx8UEac=;
        b=JyppVCAkIEWnzQsOCfUnzgdKc3gubf38rjmhYdi04Q53EXEzkqIJM9XV28TaC8qoN4
         SEylGd/1lxqBCZFdfrc1vWckOrzqxT7Pih/Zwje5rl7mZjnJL29uNIgzQbEn1qKQY0Eb
         mRItcItEaERBfUg5W112ydTliBT821VxS1vJKztE50dXgYKCEm1Bv5QJhS+njzE0PhXD
         rBZh+fXk79UQNJ4ljpVJm9sHycitnxzaNP2B3ZRnt56jg+1uCR0xRGWVRfMa7EuUo2wG
         oEs7RpHWsHx2Eq2MOB6bhJcISiWoPdnAK4+sxxOOlmYVltdDHOEeJM2tPJbG4gdKpT8S
         qyoQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/NnieIhormVnSdi3b7nMOihm2/CHFSuLeEp1MbDN5yRvpSzKymufDQeeLm5Vpf8RryjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXlAckGpCFmGi0FbqKQ/mpdr1P0iDoy0bbkMMDVdSruunVJHPD
	KQzADOLsrwJ2T6wlzGwz3Xlvaz8GGZeoAD+1PWqcPZfws93anvZO65smJNRaMhWZPi59euIc8Ot
	KgeS+IO/yQaQ+MA==
X-Received: from plgz17.prod.google.com ([2002:a17:903:191:b0:2a7:8c71:aa97])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1ac3:b0:2a0:d629:9035 with SMTP id d9443c01a7336-2a933bbe729mr7724415ad.3.1770156598471;
 Tue, 03 Feb 2026 14:09:58 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:39 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-6-skhawaja@google.com>
Subject: [PATCH 05/14] iommupt: Implement preserve/unpreserve/restore callbacks
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70098-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: E0F11DF205
X-Rspamd-Action: no action

Implement the iommu domain ops for presevation, unpresevation and
restoration of iommu domains for liveupdate. Use the existing page
walker to preserve the ioptdesc of the top_table and the lower tables.
Preserve the top_level also so it can be restored during boot.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 96 +++++++++++++++++++++++++++++
 include/linux/generic_pt/iommu.h    | 10 +++
 2 files changed, 106 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 3327116a441c..0a1adb6312dd 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -921,6 +921,102 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 }
 EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(map_pages), "GENERIC_PT_IOMMU");
 
+/**
+ * unpreserve() - Unpreserve page tables and other state of a domain.
+ * @domain: Domain to unpreserve
+ */
+void DOMAIN_NS(unpreserve)(struct iommu_domain *domain, struct iommu_domain_ser *ser)
+{
+	struct pt_iommu *iommu_table =
+		container_of(domain, struct pt_iommu, domain);
+	struct pt_common *common = common_from_iommu(iommu_table);
+	struct pt_range range = pt_all_range(common);
+	struct pt_iommu_collect_args collect = {
+		.free_list = IOMMU_PAGES_LIST_INIT(collect.free_list),
+	};
+
+	iommu_pages_list_add(&collect.free_list, range.top_table);
+	pt_walk_range(&range, __collect_tables, &collect);
+
+	iommu_unpreserve_pages(&collect.free_list, -1);
+}
+EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(unpreserve), "GENERIC_PT_IOMMU");
+
+/**
+ * preserve() - Preserve page tables and other state of a domain.
+ * @domain: Domain to preserve
+ *
+ * Returns: -ERRNO on failure, on success.
+ */
+int DOMAIN_NS(preserve)(struct iommu_domain *domain, struct iommu_domain_ser *ser)
+{
+	struct pt_iommu *iommu_table =
+		container_of(domain, struct pt_iommu, domain);
+	struct pt_common *common = common_from_iommu(iommu_table);
+	struct pt_range range = pt_all_range(common);
+	struct pt_iommu_collect_args collect = {
+		.free_list = IOMMU_PAGES_LIST_INIT(collect.free_list),
+	};
+	int ret;
+
+	iommu_pages_list_add(&collect.free_list, range.top_table);
+	pt_walk_range(&range, __collect_tables, &collect);
+
+	ret = iommu_preserve_pages(&collect.free_list);
+	if (ret)
+		return ret;
+
+	ser->top_table = virt_to_phys(range.top_table);
+	ser->top_level = range.top_level;
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(preserve), "GENERIC_PT_IOMMU");
+
+static int __restore_tables(struct pt_range *range, void *arg,
+			    unsigned int level, struct pt_table_p *table)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	int ret;
+
+	for_each_pt_level_entry(&pts) {
+		if (pts.type == PT_ENTRY_TABLE) {
+			iommu_restore_page(virt_to_phys(pts.table_lower));
+			ret = pt_descend(&pts, arg, __restore_tables);
+			if (ret)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+/**
+ * restore() - Restore page tables and other state of a domain.
+ * @domain: Domain to preserve
+ *
+ * Returns: -ERRNO on failure, on success.
+ */
+int DOMAIN_NS(restore)(struct iommu_domain *domain, struct iommu_domain_ser *ser)
+{
+	struct pt_iommu *iommu_table =
+		container_of(domain, struct pt_iommu, domain);
+	struct pt_common *common = common_from_iommu(iommu_table);
+	struct pt_range range = pt_all_range(common);
+
+	iommu_restore_page(ser->top_table);
+
+	/* Free new table */
+	iommu_free_pages(range.top_table);
+
+	/* Set the restored top table */
+	pt_top_set(common, phys_to_virt(ser->top_table), ser->top_level);
+
+	/* Restore all pages*/
+	range = pt_all_range(common);
+	return pt_walk_range(&range, __restore_tables, NULL);
+}
+EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(restore), "GENERIC_PT_IOMMU");
+
 struct pt_unmap_args {
 	struct iommu_pages_list free_list;
 	pt_vaddr_t unmapped;
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 9eefbb74efd0..b824a8642571 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -13,6 +13,7 @@ struct iommu_iotlb_gather;
 struct pt_iommu_ops;
 struct pt_iommu_driver_ops;
 struct iommu_dirty_bitmap;
+struct iommu_domain_ser;
 
 /**
  * DOC: IOMMU Radix Page Table
@@ -198,6 +199,12 @@ struct pt_iommu_cfg {
 				       unsigned long iova, phys_addr_t paddr,  \
 				       size_t pgsize, size_t pgcount,          \
 				       int prot, gfp_t gfp, size_t *mapped);   \
+	int pt_iommu_##fmt##_preserve(struct iommu_domain *domain,             \
+				      struct iommu_domain_ser *ser);           \
+	void pt_iommu_##fmt##_unpreserve(struct iommu_domain *domain,          \
+					 struct iommu_domain_ser *ser);        \
+	int pt_iommu_##fmt##_restore(struct iommu_domain *domain,              \
+				     struct iommu_domain_ser *ser);            \
 	size_t pt_iommu_##fmt##_unmap_pages(                                   \
 		struct iommu_domain *domain, unsigned long iova,               \
 		size_t pgsize, size_t pgcount,                                 \
@@ -224,6 +231,9 @@ struct pt_iommu_cfg {
 #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
 	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys, \
 	.map_pages = &pt_iommu_##fmt##_map_pages,       \
+	.preserve = &pt_iommu_##fmt##_preserve,		\
+	.unpreserve = &pt_iommu_##fmt##_unpreserve,	\
+	.restore = &pt_iommu_##fmt##_restore,		\
 	.unmap_pages = &pt_iommu_##fmt##_unmap_pages
 #define IOMMU_PT_DIRTY_OPS(fmt) \
 	.read_and_clear_dirty = &pt_iommu_##fmt##_read_and_clear_dirty
-- 
2.53.0.rc2.204.g2597b5adb4-goog


