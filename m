Return-Path: <kvm+bounces-69477-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eL0/CH+2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69477-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A4931AAA73
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0B1DC30C9D02
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1D434FF59;
	Thu, 29 Jan 2026 01:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dwf9Hbf1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D312634DB72
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649381; cv=none; b=e1FOf326EJkVYFY/UyG9KgNaMuAqtM04tTGAFqv/8R90CEU1qa7O0RHIQb12P/EZzMQmqFrvuEopXLZWJUhN9NDAEY4bIj12U1M0ZTZMIN2b3wqu9iZIJc3F/5e7ATZQbkL/Cn5eb53agQVxJdkoPeG/XT7x3ScDnT5v5lONRVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649381; c=relaxed/simple;
	bh=PfMNr2r+VH5JLxrfxOQQF4dS/m+8iJ8wfmAB6pwfKRU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pNQAhIjd/Q6DWKOVBjLEbTva9Pk/UtISls60A3IcDLkorW7H26f3xz/n0Myj1U0dr+k8GXP0O09/PBDJWCkmMqLXlbYMY50nFU7hSayPvC7dSqAzekwTUoxE1eNPhlRhVr103kNzwN5PpBHZHPwwB3JQrfGsYOQBjQ0qh6i1vU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dwf9Hbf1; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81e81fbbb8cso399518b3a.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649379; x=1770254179; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IDz9ZOJlCXDAbAOz3SQRUqJo6I1Od4zF7irdWu0ijNQ=;
        b=dwf9Hbf17Re3HIZIyQ5QcO8evvYep6A1m2y+gteFjK7Phfun1Pl+I1+YgIPct2drpQ
         qQm07NUrMJquy1Yc6J6R7bUAGMFkUvAtN0dyf2vOkol1QVBBwFXLG/B/TzKXqCXZdHU6
         NFs+/0fKDM3UCUUCWVR7YaW1s+CeiqsctS5LQTQUFhvkE1Rm1BgXkBVUEbwQP6lzL2uT
         q+B4rsMFES//gUMYlo1XnkhpBvmNiPyKKfQrB2awZN7yLzzwuvx4GT96WeRxOURt1vA+
         awrSWdR/cOxa8n7PxJRXVR0J+PRzKbKd0zx3+R4gBjqEwUcgE1vmVh66+bxEjkVz/RpE
         QfJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649379; x=1770254179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IDz9ZOJlCXDAbAOz3SQRUqJo6I1Od4zF7irdWu0ijNQ=;
        b=olJAmSjhMATJQistYmPdfEzwA4KtGdFVwQnqfFU3G+AE25UWSyBsGqTEF4lh4C68CF
         l3FUgs1dLXsnV45CWEw5CoL3AGjHezhy/QPPX+iZ+iHRI5uAitUvYSfco9Txi9dZuxpx
         NG7V12wQ7Q+T/oc13iSxbwEUfpRkQREmtiA4ZE7DXHMN9G9NPpWbvaflqcpviwQGwNyh
         IaSUL7i+NM3+de+cRBNMRzLk/Fy5jQgtCpjU8lHoebsxRI8vwzd87Jl55gM2RmkscDH+
         gBJpJpWXvgJzwte/mpMEbZpNoQaEwvyR8FCwphK3UN/dn3R/MQYc98p+5RPjMDcOYpGv
         pSAA==
X-Forwarded-Encrypted: i=1; AJvYcCVIzop7oiaOoNO0HqFF6w0r5lXN4+OFm0PuIR7EbWezj2TJJsEkPaDvv5HozIOkwqvMVhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVcAkfzhXIUwvTmVZ1d07TumXxM1NMzR61v6g9sq9P1pJQvzko
	FssHHgqrG6OqQ6zbrFwJNd+vTE16g2sL2vWD7q5bmdoGCVQSon8lgJ5QitZgjWzO4S3CrpM9m+5
	yZtHysA==
X-Received: from pfbli11.prod.google.com ([2002:a05:6a00:718b:b0:7dd:8bba:63aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1a17:b0:823:1276:9a86
 with SMTP id d2e1a72fcca58-8236929d5fbmr5606152b3a.39.1769649379248; Wed, 28
 Jan 2026 17:16:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:59 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-28-seanjc@google.com>
Subject: [RFC PATCH v5 27/45] x86/virt/tdx: Enhance tdh_phymem_page_wbinvd_hkid()
 to invalidate huge pages
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69477-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: A4931AAA73
X-Rspamd-Action: no action

From: Yan Zhao <yan.y.zhao@intel.com>

After removing a TD's private page, the TDX module does not write back and
invalidate cache lines associated with the page and its keyID (i.e., the
TD's guest keyID). The SEAMCALL wrapper tdh_phymem_page_wbinvd_hkid()
enables the caller to provide the TD's guest keyID and physical memory
address to invoke the SEAMCALL TDH_PHYMEM_PAGE_WBINVD to perform cache line
invalidation.

Enhance the SEAMCALL wrapper tdh_phymem_page_wbinvd_hkid() to support cache
line invalidation for huge pages by introducing the parameters "folio",
"start_idx", and "npages". These parameters specify the physical memory
starting from the page at "start_idx" within a "folio" and spanning
"npages" contiguous PFNs. Return TDX_OPERAND_INVALID if the specified
memory is not entirely contained within a single folio.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tdx.h  |  2 +-
 arch/x86/kvm/vmx/tdx.c      |  2 +-
 arch/x86/virt/vmx/tdx/tdx.c | 16 ++++++++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 1f57f7721286..8ceaebc6c1a9 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -237,7 +237,7 @@ u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, enum pg_level level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, u64 pfn);
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, u64 pfn, enum pg_level level);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4ac312376ac9..90133e8f5c53 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1867,7 +1867,7 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
 		return;
 
-	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, pfn);
+	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, pfn, level);
 	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 37776ea56eb7..367df9366d57 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2071,13 +2071,21 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_tdr);
 
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, u64 pfn)
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, u64 pfn, enum pg_level level)
 {
-	struct tdx_module_args args = {};
+	unsigned long npages = page_level_size(level) / PAGE_SIZE;
+	u64 err;
 
-	args.rcx = mk_keyed_paddr(hkid, pfn);
+	for (unsigned long i = 0; i < npages; i++) {
+		struct tdx_module_args args = {
+			.rcx = mk_keyed_paddr(hkid, pfn + i),
+		};
 
-	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+		err = seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+		if (err)
+			break;
+	}
+	return err;
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_hkid);
 
-- 
2.53.0.rc1.217.geba53bf80e-goog


