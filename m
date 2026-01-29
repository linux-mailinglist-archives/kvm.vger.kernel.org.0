Return-Path: <kvm+bounces-69469-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yATcKWO2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69469-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:22:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1B0AAA50
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F5D7306019A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6583A345CD0;
	Thu, 29 Jan 2026 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yRs+JtwI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC5C343D76
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649369; cv=none; b=OdhKVcjIP1aO2vkGZYLmJ3TBn1sm9ofIZUGM42lS6+jkLOb0g6TmRA9mL8qI1vyvRuOcUGD/b5gNogEsFVMCvmfakf5wTUvGjS8mRFwbivE87zh/icJm6GlYgUry+alUlBn4WN5pv9tAHqhP404VkU2pxlObM5F2OlPcqXYpyFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649369; c=relaxed/simple;
	bh=D1RcyFmhh8+6broUyuRXqMJfbz3G6P8KH0L0jZI3CCE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bn/kVD/TXweXtjkJANOwEbP1zXa/7bosNQrhmqwI7FDnjpYQoX4jiG3vu/HHUuLEsPBYh+IuHy8nrMW+Y80iuliDIJzPSVufDFM2QkvzpdVGX3LkiXQR5R/RqyAQ3sy5FuzGss2Kc31o+c2ZggJuCkfJtMWZDPzw6677VaALroU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yRs+JtwI; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82357cbd272so686395b3a.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649365; x=1770254165; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ex0+d/EF8QHeKOGyYN3KDqeLevHaBCQA5Sl9ZATFjF0=;
        b=yRs+JtwI9bAzB0ajJ90k5KMreMdzCCSe2hKvtVkwILGNrW19hediRw2PIVqdIobvd8
         5dEqWeyVZNBIYuh2k0+op0ZZ8MWgFSOH70HBuH201QbCfKvR3ENdjvkOB2FIPB67xaUh
         U9e1WfGKXWo7OnOZlYJ//CyjH6olSaF8oNqo4WrstBs+09vU4Lu3AyvqP/v8kW5bh7Yd
         xl/fW5gE0j28AjdoTKv7i8ogpiQgMpvocWQT6vYOGWbE4VqXvJ8czDoSNgbE2CTuVDmS
         6bDfQ4LD+jFMqOjYxwyT4+RtEKVRMOXGbcXzAFJ2sWtJ6ALs8NmXdeWMtEJXjWhVSitj
         XlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649365; x=1770254165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ex0+d/EF8QHeKOGyYN3KDqeLevHaBCQA5Sl9ZATFjF0=;
        b=ODQbS4Ziifob6wVr728TigultPzdAd570i8s0TxhyE/sSae7Yl/O01pbPoae2fI3jF
         +3aqoIqte1oVhD5OcRFaKdcw82YDjAP7UVe57WV7AE2Rx/l1vExyuRpqUqdTAUH2mVv8
         nomdkprPCqoLx2Wl93V/gGnebi8aZoL+qSi0fJrE4mMSFJaSCUkIhHdZYcF9WOrbiyOC
         Ez5mjkVpNarmq08kJv8xsuY9oVdbAEoIwtpCID5tTcX68I7PXpx/r0DKe/YlBagOulH6
         vKEGt+Jk8PGIDavccnC4/ZGpsdUT4dW4xoepsPcNcVimLvAubeGpqJMHmuL41OkQIuUW
         gyAg==
X-Forwarded-Encrypted: i=1; AJvYcCWLzXvXzTMkwnKYJOZTFh2jpjtUbrNJenwvPAloXl0OX9haamvvRpwZbLN61Jo5hhc0Ioo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrKg5NXHaO09pG6S8hltQGJ6w+Wte36wdBbAa+iOD3APlYSrNs
	UOBUMv/bqOzV2uuf4Eu3bXWoDTqe3PQiMyxKPB5TtOHAQB7YBlYj6YxAHNDw7QghpBpKWgUnvdB
	PZHahvw==
X-Received: from pfbif13.prod.google.com ([2002:a05:6a00:8b0d:b0:76b:f0d4:ac71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d82:b0:821:80bf:590b
 with SMTP id d2e1a72fcca58-823692a3747mr6686129b3a.34.1769649365031; Wed, 28
 Jan 2026 17:16:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:51 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-20-seanjc@google.com>
Subject: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69469-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 2D1B0AAA50
X-Rspamd-Action: no action

Extend "struct kvm_mmu_memory_cache" to support a custom page allocator
so that x86's TDX can update per-page metadata on allocation and free().

Name the allocator page_get() to align with __get_free_page(), e.g. to
communicate that it returns an "unsigned long", not a "struct page", and
to avoid collisions with macros, e.g. with alloc_page.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_types.h | 2 ++
 virt/kvm/kvm_main.c       | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index a568d8e6f4e8..87fa9deffdb7 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -112,6 +112,8 @@ struct kvm_mmu_memory_cache {
 	gfp_t gfp_custom;
 	u64 init_value;
 	struct kmem_cache *kmem_cache;
+	unsigned long (*page_get)(gfp_t gfp);
+	void (*page_free)(unsigned long addr);
 	int capacity;
 	int nobjs;
 	void **objects;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 571cf0d6ec01..7015edce5bd8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -356,7 +356,10 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 	if (mc->kmem_cache)
 		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
 
-	page = (void *)__get_free_page(gfp_flags);
+	if (mc->page_get)
+		page = (void *)mc->page_get(gfp_flags);
+	else
+		page = (void *)__get_free_page(gfp_flags);
 	if (page && mc->init_value)
 		memset64(page, mc->init_value, PAGE_SIZE / sizeof(u64));
 	return page;
@@ -416,6 +419,8 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 	while (mc->nobjs) {
 		if (mc->kmem_cache)
 			kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
+		else if (mc->page_free)
+			mc->page_free((unsigned long)mc->objects[--mc->nobjs]);
 		else
 			free_page((unsigned long)mc->objects[--mc->nobjs]);
 	}
-- 
2.53.0.rc1.217.geba53bf80e-goog


