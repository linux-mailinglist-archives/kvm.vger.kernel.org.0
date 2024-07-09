Return-Path: <kvm+bounces-21194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 510DB92BAE7
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 15:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9C09B29333
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C19168481;
	Tue,  9 Jul 2024 13:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="IBGmho88"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C55A15ECC0;
	Tue,  9 Jul 2024 13:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720531276; cv=none; b=drCdk/YsB3PaHBWhqFe25KIBv1UXdbNP6EAETOFkLO6NSTnViaS4meUxTh0KCgCVfFzG88+81pwbUqXJ/O4Z5CVp5E9MZQ0fqkSkKDZMvNOZM2Lnk959TaSI79jEOkgk49vUCLcCNZx6SG/j7MFB/Sxc+qIvzwSHNV5eH4w54/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720531276; c=relaxed/simple;
	bh=uuopR67Q1J3vX2/gS9DwzERKE3IhuTwl8q4/PTiHb6I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nPmWT9PyKb1wrI8k/lQK232UZwckuFU0JNs3MwpOuTtR+jr3Ov2KQpyb+M6M0FGeYaJtU8Funb4yVY18fJq8vLg/RxudgmJAKQ9Lsl/q5Je/tNZ3OfTfOxuQ268TiHsfElk/eMV8s+ebQMpN/sCCBUIISvb0+Onyy71AHDbJN6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=IBGmho88; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720531276; x=1752067276;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j7xh8Fp0rGL+JNyIcONb4iIMzBYUq25BVxGN/Q+52J4=;
  b=IBGmho88qkJBK1FznX1Awd2MCCKuFbT+w20JujnLxX1RJto2mAXbmuGX
   EZkpIakmXASfZfgGtkrDebXGFXaVfAFCeCb+2XKAYdqNt3juF7EzhT5ox
   s+W4NsgRiO8dKvqsMie6mKdgmNafALOBl0W3+e/Q0m5hrJUk8/DClH3cM
   I=;
X-IronPort-AV: E=Sophos;i="6.09,195,1716249600"; 
   d="scan'208";a="432897833"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 13:21:09 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.0.204:54070]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.19.12:2525] with esmtp (Farcaster)
 id 9adfff71-39c0-4eea-be63-6a4028520ef9; Tue, 9 Jul 2024 13:21:07 +0000 (UTC)
X-Farcaster-Flow-ID: 9adfff71-39c0-4eea-be63-6a4028520ef9
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:04 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 9 Jul 2024 13:21:04 +0000
Received: from ua2d7e1a6107c5b.ant.amazon.com (172.19.88.180) by
 mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Tue, 9 Jul 2024 13:21:01 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <rppt@kernel.org>, <david@redhat.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>
Subject: [RFC PATCH 3/8] kvm: pfncache: enlighten about gmem
Date: Tue, 9 Jul 2024 14:20:31 +0100
Message-ID: <20240709132041.3625501-4-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709132041.3625501-1-roypat@amazon.co.uk>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

KVM uses gfn_to_pfn_caches to cache translations from gfn all the way to
the pfn (for example, kvm-clock caches the page storing the page used
for guest/host communication this way). Unlike the gfn_to_hva_cache,
where no equivalent caching semantics were possible to gmem-backed gfns
(see also 858e8068a750 ("kvm: pfncache: enlighten about gmem")), here it
is possible to simply cache the pfn returned by `kvm_gmem_get_pfn`.

Additionally, gfn_to_pfn_caches now invalidate whenever a cached gfn's
attributes are flipped from shared to private (or vice-versa).

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/linux/kvm_types.h |  1 +
 virt/kvm/pfncache.c       | 41 +++++++++++++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 827ecc0b7e10..8f85f01f6bb0 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -70,6 +70,7 @@ struct gfn_to_pfn_cache {
 	kvm_pfn_t pfn;
 	bool active;
 	bool valid;
+	bool is_private;
 };
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e..6430e0a49558 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -90,6 +90,9 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	if (!kvm_gpc_is_valid_len(gpc->gpa, gpc->uhva, len))
 		return false;
 
+	if (gpc->is_private != kvm_mem_is_private(gpc->kvm, gpa_to_gfn(gpc->gpa)))
+		return false;
+
 	if (!gpc->valid)
 		return false;
 
@@ -159,6 +162,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
+	gfn_t gfn;
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
@@ -173,6 +177,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 	do {
 		mmu_seq = gpc->kvm->mmu_invalidate_seq;
+		gfn = gpa_to_gfn(gpc->gpa);
 		smp_rmb();
 
 		write_unlock_irq(&gpc->lock);
@@ -197,10 +202,19 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			cond_resched();
 		}
 
-		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
-		if (is_error_noslot_pfn(new_pfn))
-			goto out_error;
+		if (gpc->is_private) {
+			int r = kvm_gmem_get_pfn(gpc->kvm, gfn_to_memslot(gpc->kvm, gfn), gfn,
+						 &new_pfn, NULL);
+
+			if (r)
+				goto out_error;
+		} else {
+			/* We always request a writeable mapping */
+			new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL,
+					     true, NULL);
+			if (is_error_noslot_pfn(new_pfn))
+				goto out_error;
+		}
 
 		/*
 		 * Obtain a new kernel mapping if KVM itself will access the
@@ -252,6 +266,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	unsigned long old_uhva;
 	kvm_pfn_t old_pfn;
 	bool hva_change = false;
+	bool old_private;
 	void *old_khva;
 	int ret;
 
@@ -271,8 +286,21 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	old_pfn = gpc->pfn;
 	old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	old_uhva = PAGE_ALIGN_DOWN(gpc->uhva);
+	old_private = gpc->is_private;
+
+	gpc->is_private = kvm_mem_is_private(gpc->kvm, gpa_to_gfn(gpa));
+
+	if (gpc->is_private && !kvm_can_access_gmem(gpc->kvm)) {
+		ret = -EFAULT;
+		goto out_unlock;
+	}
 
 	if (kvm_is_error_gpa(gpa)) {
+		if (WARN_ON_ONCE(gpc->is_private)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+
 		page_offset = offset_in_page(uhva);
 
 		gpc->gpa = INVALID_GPA;
@@ -316,9 +344,10 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 
 	/*
 	 * If the userspace HVA changed or the PFN was already invalid,
-	 * drop the lock and do the HVA to PFN lookup again.
+	 * drop the lock and do the HVA to PFN lookup again. Also
+	 * recompute the pfn if the gfn changed from shared to private (or vice-versa).
 	 */
-	if (!gpc->valid || hva_change) {
+	if (!gpc->valid || hva_change || gpc->is_private != old_private) {
 		ret = hva_to_pfn_retry(gpc);
 	} else {
 		/*
-- 
2.45.2


