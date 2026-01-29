Return-Path: <kvm+bounces-69480-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JczJOG1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69480-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:20:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 569B7AA9ED
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:20:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DD7CF30228FF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E0E31B114;
	Thu, 29 Jan 2026 01:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rCtonWXg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A76534FF78
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649385; cv=none; b=cP4EiurWiqC9iTiBu8UIVpr2+AeCBG4PFwswOAQh1MfGRB6Fng4sKrAVi5c/KySTlNnrLHKbOYAg/CLH6Gu4OjmXGmzCU/Bv9HvzWWlGffeLQgUIU7DqeOcPpjgmFbCZmGqe4UDfpufZSSwhkb5R4ulkefMamx37GU/qQZxMkAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649385; c=relaxed/simple;
	bh=E/p9aO3ZAiwSbYiHC1+ljXC/97KIVcZ8eXjeNv4DXak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d3mHrL5E3zX8T5XR7jOfu8qEirx8Wo+MvuxGuJGmZz5aT04FUM+a0ndhEtRkxSzjvmcytxbVKI8esd72cuS2Sb8RCxTxos/dPAtdUYqxqMZTOlMwZhqTxiohWvPkEFneh+nhmXN/O+kf7lHqMQ45eFaGF3wBEVU4RNE+fnp8KtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rCtonWXg; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c617e59845dso287520a12.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649382; x=1770254182; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EhyaETaO3z5ZObA+zH7KzPZSfmMP5O9GD9W3Xs6375s=;
        b=rCtonWXglPMNfbMBrtvIsNS2wcNHpKUx1ASA1lzUbb0/0eJnM7JW5A5SvVhMBe/XvF
         qcSMQjEq9PBdxdZ4JMOujIQyAOrkqYOgL5wTVZo6cWPkOjxdJyd+1O6f3HJlIlwetye7
         3Wu469+to6KJyG1mXzt+DYxJ5mLB2RYo2hzP/Z9/mcyLAyQB/k2h4zJ9pT/QRHD7iMwB
         H/XCYVhHMsBxRkS3K6NfGeKCZ48In6xGru2ZRvXuP+uyC8EovBdk2IY08BdJe+btspUa
         K/WctJuqr0OvbhDTRbwxrxLeFeykj9jwciUknkW+t6/OQ5Jrx60Bd/6DpOmn6Vyy/IXH
         3XLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649382; x=1770254182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EhyaETaO3z5ZObA+zH7KzPZSfmMP5O9GD9W3Xs6375s=;
        b=BeNghlFpX/1BbW7amkkE9i5dI6KSiEMYCgwnRe1EHaqokpZfme/XuJQ5hSo2QKLoZQ
         s0L+sr/jl7waG9BeHG/yfIHMCkTnqVM2dro8zTaDLUQXaGe/IBF0BbujK4Wm2HHLW1OK
         w0Lp9ImG9NcBr4nG2kLL0hSiTPzKlIaeqsghmCozsq2OzFtzLBzW5SJUvPt9UrsZVVCH
         WyS9UxKArI/fiDOOx5aCTrnJaK5FI3qDTrKh3mmupuFhiVPOJ9hUh8bxQ7g4xZaD8ROp
         U53DxLpBqOdwdpVeCRdVHh6RzSH2htBgTlQFSCWReOmmEd/mw8bMAZasiLKe3CoLCdZl
         G2ZA==
X-Forwarded-Encrypted: i=1; AJvYcCWkDyUreAvXw1t4OxJ4SHesmpXHqsL8sEVjgmfFb+xKSQQDl2CgmHpUsOKnsw966+PjFi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzE5a61BkJOhBRXpoNeCkk40jrPn6TUEg5KR78Y1Y99sBzJspEV
	XZtEtbcyMFoTwAvo+1WY1dkw+xy+BdONLQL1G2A6L3+avmClggpfkU3vCio90/naIEdpbgSBiqy
	Y/0URcQ==
X-Received: from pggk18.prod.google.com ([2002:a63:d112:0:b0:c5e:9fe:7560])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:2206:b0:350:b8e:f99b
 with SMTP id adf61e73a8af0-38ec64182ccmr7501037637.45.1769649382397; Wed, 28
 Jan 2026 17:16:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:01 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-30-seanjc@google.com>
Subject: [RFC PATCH v5 29/45] x86/virt/tdx: Get/Put DPAMT page pair if and
 only if mapping size is 4KB
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69480-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 569B7AA9ED
X-Rspamd-Action: no action

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Elide the guts of getting/putting a Dynamic PAMT entry when the associated
mapping is greater than 4KiB, in which case static PAMT pages are used and
there's no need to (un)install extra PAMT pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Yan: Move level checking to callers of tdx_pamt_{get/put}()]
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: move level checking back to tdx_pamt_{get/put}()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tdx.h  | 16 ++++++++++++++--
 arch/x86/kvm/vmx/tdx.c      |  6 +++---
 arch/x86/virt/vmx/tdx/tdx.c | 12 ++++++------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index e61b0b3cc403..50feea01b066 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -154,8 +154,20 @@ static inline void tdx_init_pamt_cache(struct tdx_pamt_cache *cache)
 
 void tdx_free_pamt_cache(struct tdx_pamt_cache *cache);
 int tdx_topup_pamt_cache(struct tdx_pamt_cache *cache, unsigned long npages);
-int tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache);
-void tdx_pamt_put(u64 pfn);
+int __tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache);
+void __tdx_pamt_put(u64 pfn);
+
+static inline int tdx_pamt_get(u64 pfn, enum pg_level level,
+			       struct tdx_pamt_cache *cache)
+{
+	return level == PG_LEVEL_4K ? __tdx_pamt_get(pfn, cache) : 0;
+}
+
+static inline void tdx_pamt_put(u64 pfn, enum pg_level level)
+{
+	if (level == PG_LEVEL_4K)
+		__tdx_pamt_put(pfn);
+}
 
 void __tdx_quirk_reset_page(u64 pfn, enum pg_level level);
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index aca556923822..bd5d902da303 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1729,7 +1729,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	WARN_ON_ONCE((mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
 
-	ret = tdx_pamt_get(pfn, &tdx->pamt_cache);
+	ret = tdx_pamt_get(pfn, level, &tdx->pamt_cache);
 	if (ret)
 		return ret;
 
@@ -1751,7 +1751,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		ret = tdx_mem_page_add(kvm, gfn, level, pfn);
 
 	if (ret)
-		tdx_pamt_put(pfn);
+		tdx_pamt_put(pfn, level);
 
 	return ret;
 }
@@ -1872,7 +1872,7 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 		return;
 
 	__tdx_quirk_reset_page(pfn, level);
-	tdx_pamt_put(pfn);
+	tdx_pamt_put(pfn, level);
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 411e5feef39f..cff325fdec79 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2195,7 +2195,7 @@ static u64 tdh_phymem_pamt_remove(u64 pfn, u64 *pamt_pa_array)
 static DEFINE_SPINLOCK(pamt_lock);
 
 /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
-int tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
+int __tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
 {
 	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
 	atomic_t *pamt_refcount;
@@ -2266,13 +2266,13 @@ int tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
 	free_pamt_array(pamt_pa_array);
 	return ret;
 }
-EXPORT_SYMBOL_FOR_KVM(tdx_pamt_get);
+EXPORT_SYMBOL_FOR_KVM(__tdx_pamt_get);
 
 /*
  * Drop PAMT refcount for the given page and free PAMT memory if it is no
  * longer needed.
  */
-void tdx_pamt_put(u64 pfn)
+void __tdx_pamt_put(u64 pfn)
 {
 	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
 	atomic_t *pamt_refcount;
@@ -2326,7 +2326,7 @@ void tdx_pamt_put(u64 pfn)
 	 */
 	free_pamt_array(pamt_pa_array);
 }
-EXPORT_SYMBOL_FOR_KVM(tdx_pamt_put);
+EXPORT_SYMBOL_FOR_KVM(__tdx_pamt_put);
 
 void tdx_free_pamt_cache(struct tdx_pamt_cache *cache)
 {
@@ -2372,7 +2372,7 @@ struct page *__tdx_alloc_control_page(gfp_t gfp)
 	if (!page)
 		return NULL;
 
-	if (tdx_pamt_get(page_to_pfn(page), NULL)) {
+	if (__tdx_pamt_get(page_to_pfn(page), NULL)) {
 		__free_page(page);
 		return NULL;
 	}
@@ -2390,7 +2390,7 @@ void __tdx_free_control_page(struct page *page)
 	if (!page)
 		return;
 
-	tdx_pamt_put(page_to_pfn(page));
+	__tdx_pamt_put(page_to_pfn(page));
 	__free_page(page);
 }
 EXPORT_SYMBOL_FOR_KVM(__tdx_free_control_page);
-- 
2.53.0.rc1.217.geba53bf80e-goog


