Return-Path: <kvm+bounces-70097-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OO0LC7RygmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70097-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:12:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D76C3DF1E8
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:12:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E3E3930D17E9
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C94E3793CF;
	Tue,  3 Feb 2026 22:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VodX9BEL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC36376BF0
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156599; cv=none; b=Eru3PxuP/4VB8vtpvnJCm+ZoDFBQOFMOV7dEHaU1MWkmiH7zOsbb1qhTtUnC4XgoW5FfnmxdPEMDCGBUWU3JcD4pzdTphGR9ntJDl1JGpZsXlyFXt86bvHSwqxGl8x4EUw35nn5tLmOO/Evejj2BUd6BP5nUkfg5/AXPWKdvSmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156599; c=relaxed/simple;
	bh=5oimeBpjR9ySAyBwN7duv7K3nB4HOiM5cRVJaWv274o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lQVUnz6KgJF9y6yzqGaPZIUo3YnrxitcZHBZ4zrkl37kF67n9YnQxcwhNbR7ZoMMsFDmsnPLOAlD4a4i6UGkGcUzPTT8rR4fy4vfsrFuV4QCoXVxQIvzHsNw9ay4qpYJ34o8zLKlJoBBdXFpujk63nTWrdfH8ii/pMrJiW86lvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VodX9BEL; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a78c094ad6so62736215ad.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156597; x=1770761397; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lp/+9SAp3L8mfYjwbkh3T/evpw/YswqyzsO+xOxb2eg=;
        b=VodX9BELBn/e27xV70jzzO9+sOeUoNAPP9z8FQh07P0fTXS5f1q367/em3ZJxhFEaM
         hKzjkld4V0tYy480msA/MLdJfoIr1g7SOvliskoqU/WsYdPlVNqp2fxlZePMxYL+ucmT
         gTdKfUf+irKZQ96s5lKfcpVtKOb3uDxJYrsV3pY0qHWIxNMJUx9LP0f4tnmDXakhFFbz
         0Kwog7lmmFflb2UJYZf4f27bu9Yx0fHYA0xq72+hl+bxHdnufl2Fy1VbXdj5+ra3sO+Y
         UIgFx0kYnoW+e+q12h7GNE1OZ45mKIOId0LEhNzxwOubr5937Qf7xqwCVW6sxPwHpU/w
         KAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156597; x=1770761397;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lp/+9SAp3L8mfYjwbkh3T/evpw/YswqyzsO+xOxb2eg=;
        b=v6niX9RXP1ffAJwdVqUNeqm19W42XnpYwaLkbaoTvPQkLdC1DGClpvGMr+XDwIro2C
         UteeQyYOGJdxgSIYOYmDJf4NtmYzjTfm/yPej1O43f5vVjZxLa6X03nkSVwCp/qQ+UF6
         11nNu9vK+gWuMAbo10cIvFstVTL7NwjcCDadFLEJvFn10UrstxintPdWjqiCPZVT+kfT
         quSyBGV05pR89wm3ul1AxKkniRucGRQoKpSUf0wV/5nBPjsP+prF4HMhAmte1OZnEiJB
         Fa2xZ0nX3AOFKJ7xg2JxKzvTj0hWO/TqjA4/TffOf+4j+3BKIpRWnYPMgJXjXUnEolj6
         7ufQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcGDd0aaUid9cwH2RzwFs2R4GYuwSeuyLkj7ZLCm2nb2SuFuCge59Cf13TyANFPPzpwqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx18gRLiNYvZXuECgTgMe6GMbdUueXY65tQI2fSah6Sj8VmqUfF
	BLBKWg/D6/K5ctg+3/Z/0VFatZb7E79BmWOri5psSZ6z/Jmf79ija3/6wjMmy9zimKgIgkd3Cue
	zzEFR4SQl5COLLA==
X-Received: from plbmf3.prod.google.com ([2002:a17:902:fc83:b0:2a1:1c0e:70b9])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:c411:b0:295:b46f:a6c2 with SMTP id d9443c01a7336-2a933fba80bmr6525215ad.37.1770156597010;
 Tue, 03 Feb 2026 14:09:57 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:38 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-5-skhawaja@google.com>
Subject: [PATCH 04/14] iommu/pages: Add APIs to preserve/unpreserve/restore
 iommu pages
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70097-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: D76C3DF1E8
X-Rspamd-Action: no action

IOMMU pages are allocated/freed using APIs using struct ioptdesc. For
the proper preservation and restoration of ioptdesc add helper
functions.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/iommu-pages.c | 74 +++++++++++++++++++++++++++++++++++++
 drivers/iommu/iommu-pages.h | 30 +++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 3bab175d8557..588a8f19b196 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -6,6 +6,7 @@
 #include "iommu-pages.h"
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
+#include <linux/kexec_handover.h>
 #include <linux/mm.h>
 
 #define IOPTDESC_MATCH(pg_elm, elm)                    \
@@ -131,6 +132,79 @@ void iommu_put_pages_list(struct iommu_pages_list *list)
 }
 EXPORT_SYMBOL_GPL(iommu_put_pages_list);
 
+#if IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE)
+void iommu_unpreserve_page(void *virt)
+{
+	kho_unpreserve_folio(ioptdesc_folio(virt_to_ioptdesc(virt)));
+}
+EXPORT_SYMBOL_GPL(iommu_unpreserve_page);
+
+int iommu_preserve_page(void *virt)
+{
+	return kho_preserve_folio(ioptdesc_folio(virt_to_ioptdesc(virt)));
+}
+EXPORT_SYMBOL_GPL(iommu_preserve_page);
+
+void iommu_unpreserve_pages(struct iommu_pages_list *list, int count)
+{
+	struct ioptdesc *iopt;
+
+	if (!count)
+		return;
+
+	/* If less than zero then unpreserve all pages. */
+	if (count < 0)
+		count = 0;
+
+	list_for_each_entry(iopt, &list->pages, iopt_freelist_elm) {
+		kho_unpreserve_folio(ioptdesc_folio(iopt));
+		if (count > 0 && --count ==  0)
+			break;
+	}
+}
+EXPORT_SYMBOL_GPL(iommu_unpreserve_pages);
+
+void iommu_restore_page(u64 phys)
+{
+	struct ioptdesc *iopt;
+	struct folio *folio;
+	unsigned long pgcnt;
+	unsigned int order;
+
+	folio = kho_restore_folio(phys);
+	BUG_ON(!folio);
+
+	iopt = folio_ioptdesc(folio);
+
+	order = folio_order(folio);
+	pgcnt = 1UL << order;
+	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, pgcnt);
+	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, pgcnt);
+}
+EXPORT_SYMBOL_GPL(iommu_restore_page);
+
+int iommu_preserve_pages(struct iommu_pages_list *list)
+{
+	struct ioptdesc *iopt;
+	int count = 0;
+	int ret;
+
+	list_for_each_entry(iopt, &list->pages, iopt_freelist_elm) {
+		ret = kho_preserve_folio(ioptdesc_folio(iopt));
+		if (ret) {
+			iommu_unpreserve_pages(list, count);
+			return ret;
+		}
+
+		++count;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_preserve_pages);
+
+#endif
+
 /**
  * iommu_pages_start_incoherent - Setup the page for cache incoherent operation
  * @virt: The page to setup
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index ae9da4f571f6..bd336fb56b5f 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -53,6 +53,36 @@ void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size);
 void iommu_free_pages(void *virt);
 void iommu_put_pages_list(struct iommu_pages_list *list);
 
+#if IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE)
+int iommu_preserve_page(void *virt);
+void iommu_unpreserve_page(void *virt);
+int iommu_preserve_pages(struct iommu_pages_list *list);
+void iommu_unpreserve_pages(struct iommu_pages_list *list, int count);
+void iommu_restore_page(u64 phys);
+#else
+static inline int iommu_preserve_page(void *virt)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iommu_unpreserve_page(void *virt)
+{
+}
+
+static inline int iommu_preserve_pages(struct iommu_pages_list *list)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iommu_unpreserve_pages(struct iommu_pages_list *list, int count)
+{
+}
+
+static inline void iommu_restore_page(u64 phys)
+{
+}
+#endif
+
 /**
  * iommu_pages_list_add - add the page to a iommu_pages_list
  * @list: List to add the page to
-- 
2.53.0.rc2.204.g2597b5adb4-goog


