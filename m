Return-Path: <kvm+bounces-69472-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6LtiMHe2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69472-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8C7AAA5E
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B80463068174
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6197A346E4C;
	Thu, 29 Jan 2026 01:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FxffVin7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B3D345750
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649373; cv=none; b=jWtejxe1TGfLKzXlXE3D+Ikh5LxZ8/ryq7pObyElowyNnawqC5q7O0xFIF1TfNnSS6KL1hEcxz2AsLCHW5xybRB5zSSt5Um8tApivCnbNe+/dmwuJt1kmjvxFdPHYCo5xkHX5mOpXYm2kNKmkVaBT8ASfSN7K9k43vw3QguC3tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649373; c=relaxed/simple;
	bh=xyU67iIG8B0z1lftPU8r+DkLP9n8GV25IDyjReoJtDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rV/h9mzMW8qL7XH+bv0PRyibLpLiDGea3+CGbYrYRBLaHHz/VZwAb1XZOHiFZy9J4FgVtNuni1k9VW8AbVq65rt7hrZ2my2LVZu1zGmoa0cspc6d9SWMDZuBVW9LbHD680hSeOdKu1tVwttfJhlmQEwSK6AeUOnD8kYeP2Xq8+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FxffVin7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c61dee98720so236073a12.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649369; x=1770254169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=83UiBV3UrNTMNXOexHb3DCeTDDgbi4QS7S/0ehY+L8M=;
        b=FxffVin7zPw86OwPlBQrcaRWJCcsyS0f6OOjPg6ViCZJtzbA8WgAMjAckH98lMCivH
         Mf8ljmvmuFADbVRsgZ5kItBQZakcqJh8enANA7rGCqvXt/TwSWLvqwNY3pjPdPGSyOW7
         srq4QBFXSvXxM6pSGJVke7WiKAJ/OP7na5hNFQiIDZ+KKcHeqC/vvFtB44djsR1i+XgG
         VvkSfik4OPiXiFNxsmTKPCguhSOxzENx/j7l/V0VYLl8EgdX734hilkKfIQ7WwL9a0CP
         JsfaIKE0MD+cHqQKEJGNq5HnSN2RB2c6cBiYjFbReNuYaV4U4tLsq/ELNbb3+zcr9mmL
         j/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649369; x=1770254169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=83UiBV3UrNTMNXOexHb3DCeTDDgbi4QS7S/0ehY+L8M=;
        b=t+10Q2iLOMQfzVIQq6Saq7ZrG/V1hw8gNuWV1sv/pwNN0YYbpsB0bYmHWdLoxH1DcQ
         BSRYyDEZNZmI/84QTyysmGgzfWw9Am+IDAQrKkhc/fsZGY56NA1MfoeKWgvHbQAWD2f8
         Q2b0AjxOnx9qaXOelcyYrehkyIkdKdf/sjCwrEbcCVVRyYGlWK6JnBD4faopwYinCU0K
         VemHHX6FrUhLJLpAzsZXwbt62k6/humqi/z7JzuSn5n7r2b/j56X96s8rcSDI5p/La/H
         rxEMgHfVl5hVByoUcw1LiGIIpM3+qxlI0jtbba8k+v0+oSi+RLryGHzJrVgtwhVlSeXT
         9svQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAsDTKW911ro21aOCXJ8Ryjjxj2ElRUQry2K3NjAAxOK46CSoMi84MyBOdYc0vymlhV68=@vger.kernel.org
X-Gm-Message-State: AOJu0YybLS0zybcEB6S4fgZCkxdGzYcDQpiy5VpCWz0RMrG6Ph2gKe1B
	Qjhz0v52E+zcl1NTzxHjnmuSH7LhCjUyTDMfg74wk/QKDadnQzkQFwMfxZwKogxMaafYQrlG+ik
	/lp3aUw==
X-Received: from pjbsy16.prod.google.com ([2002:a17:90b:2d10:b0:34c:2124:a2b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:820e:b0:38d:fa67:e87f
 with SMTP id adf61e73a8af0-38ec627b9f1mr7469147637.12.1769649368609; Wed, 28
 Jan 2026 17:16:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:53 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-22-seanjc@google.com>
Subject: [RFC PATCH v5 21/45] x86/tdx: Add APIs to support get/put of DPAMT
 entries from KVM, under spinlock
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69472-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: DC8C7AAA5E
X-Rspamd-Action: no action

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Implement a PAMT "caching" scheme, similar to KVM's pre-allocated cache of
MMU assets, along with APIs to allow KVM to pre-allocate PAMT pages before
acquiring its mmu_lock spinlock, but wait until S-EPT entries are created
to actually update the Dynamic PAMT.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tdx.h  | 17 ++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 65 +++++++++++++++++++++++++++++++++----
 2 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index fa29be18498c..c39e2920d0c3 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -136,6 +136,23 @@ static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
 	return false; /* To be enabled when kernel is ready */
 }
 
+/* Simple structure for pre-allocating Dynamic PAMT pages outside of locks. */
+struct tdx_pamt_cache {
+	struct list_head page_list;
+	int cnt;
+};
+
+static inline void tdx_init_pamt_cache(struct tdx_pamt_cache *cache)
+{
+	INIT_LIST_HEAD(&cache->page_list);
+	cache->cnt = 0;
+}
+
+void tdx_free_pamt_cache(struct tdx_pamt_cache *cache);
+int tdx_topup_pamt_cache(struct tdx_pamt_cache *cache, unsigned long npages);
+int tdx_pamt_get(struct page *page, struct tdx_pamt_cache *cache);
+void tdx_pamt_put(struct page *page);
+
 void tdx_quirk_reset_page(struct page *page);
 
 int tdx_guest_keyid_alloc(void);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d333d2790913..53b29c827520 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2064,13 +2064,34 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_hkid);
 
-static int alloc_pamt_array(u64 *pa_array)
+static struct page *tdx_alloc_page_pamt_cache(struct tdx_pamt_cache *cache)
+{
+	struct page *page;
+
+	page = list_first_entry_or_null(&cache->page_list, struct page, lru);
+	if (page) {
+		list_del(&page->lru);
+		cache->cnt--;
+	}
+
+	return page;
+}
+
+static struct page *alloc_dpamt_page(struct tdx_pamt_cache *cache)
+{
+	if (cache)
+		return tdx_alloc_page_pamt_cache(cache);
+
+	return alloc_page(GFP_KERNEL_ACCOUNT);
+}
+
+static int alloc_pamt_array(u64 *pa_array, struct tdx_pamt_cache *cache)
 {
 	struct page *page;
 	int i;
 
 	for (i = 0; i < tdx_dpamt_entry_pages(); i++) {
-		page = alloc_page(GFP_KERNEL_ACCOUNT);
+		page = alloc_dpamt_page(cache);
 		if (!page)
 			goto err;
 		pa_array[i] = page_to_phys(page);
@@ -2151,7 +2172,7 @@ static u64 tdh_phymem_pamt_remove(struct page *page, u64 *pamt_pa_array)
 static DEFINE_SPINLOCK(pamt_lock);
 
 /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
-static int tdx_pamt_get(struct page *page)
+int tdx_pamt_get(struct page *page, struct tdx_pamt_cache *cache)
 {
 	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
 	atomic_t *pamt_refcount;
@@ -2170,7 +2191,7 @@ static int tdx_pamt_get(struct page *page)
 	if (atomic_inc_not_zero(pamt_refcount))
 		return 0;
 
-	ret = alloc_pamt_array(pamt_pa_array);
+	ret = alloc_pamt_array(pamt_pa_array, cache);
 	if (ret)
 		goto out_free;
 
@@ -2222,12 +2243,13 @@ static int tdx_pamt_get(struct page *page)
 	free_pamt_array(pamt_pa_array);
 	return ret;
 }
+EXPORT_SYMBOL_FOR_KVM(tdx_pamt_get);
 
 /*
  * Drop PAMT refcount for the given page and free PAMT memory if it is no
  * longer needed.
  */
-static void tdx_pamt_put(struct page *page)
+void tdx_pamt_put(struct page *page)
 {
 	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
 	atomic_t *pamt_refcount;
@@ -2281,6 +2303,37 @@ static void tdx_pamt_put(struct page *page)
 	 */
 	free_pamt_array(pamt_pa_array);
 }
+EXPORT_SYMBOL_FOR_KVM(tdx_pamt_put);
+
+void tdx_free_pamt_cache(struct tdx_pamt_cache *cache)
+{
+	struct page *page;
+
+	while ((page = tdx_alloc_page_pamt_cache(cache)))
+		__free_page(page);
+}
+EXPORT_SYMBOL_FOR_KVM(tdx_free_pamt_cache);
+
+int tdx_topup_pamt_cache(struct tdx_pamt_cache *cache, unsigned long npages)
+{
+	if (WARN_ON_ONCE(!tdx_supports_dynamic_pamt(&tdx_sysinfo)))
+		return 0;
+
+	npages *= tdx_dpamt_entry_pages();
+
+	while (cache->cnt < npages) {
+		struct page *page = alloc_page(GFP_KERNEL_ACCOUNT);
+
+		if (!page)
+			return -ENOMEM;
+
+		list_add(&page->lru, &cache->page_list);
+		cache->cnt++;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM(tdx_topup_pamt_cache);
 
 /*
  * Return a page that can be gifted to the TDX-Module for use as a "control"
@@ -2296,7 +2349,7 @@ struct page *__tdx_alloc_control_page(gfp_t gfp)
 	if (!page)
 		return NULL;
 
-	if (tdx_pamt_get(page)) {
+	if (tdx_pamt_get(page, NULL)) {
 		__free_page(page);
 		return NULL;
 	}
-- 
2.53.0.rc1.217.geba53bf80e-goog


