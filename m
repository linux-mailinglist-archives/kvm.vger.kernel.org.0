Return-Path: <kvm+bounces-69479-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CEqhFqi2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69479-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF27AAAAB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D72A30DEC5D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB795352F9A;
	Thu, 29 Jan 2026 01:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eLELBRAQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F151C328B6A
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649383; cv=none; b=FuZ1YS5CIME8tvrlKlyA+KiiAQXz6SFjrfrOiqAtCnqILxSwNk40IkQJHiVsZ9tRU0/op0k/Gu6ET2gKULM4NFHg1tvbqj4sOFPbqVNG3mssrG3qwkZP0ar+Xeg+srh2kfCs2/sUpMRoeop723wMZm5SMoKY4X8KYHpL8ZHnPmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649383; c=relaxed/simple;
	bh=CYTYIlGGcrH6BQ0d71EBgYmrRkYDF9cUwwiwLMPdHys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uaXbA1nc6zrsFSqIjDcpKroxqGHl7gpZ+LeE1qmd8uyZKf0uW4FDMsxfVCXEumiH1w9bs3q2XlyYDqm1LQ6IyS9h+Df3d8mpIEEWyko5XwoGVSHnj5csAVLM3e32tWgOmGkAMh2XmXr8pdJCHTZ6kDIsFmo8of9vkOT3I5j1hU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eLELBRAQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ac814f308so632630a91.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649381; x=1770254181; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=msD2jv18E2L4HOYUfz15g4GHsjmr/D9b7fjjCRW4KGo=;
        b=eLELBRAQUs7O/ZEHD6Bcq9OUbL5b5azWsYCDabQzX7VMxDPTDXcnN+gDxiHTFfMh5j
         hPIBSk3zORQuGE5kT4mJ+6ajCD+AuYkjgfwfabyMUP6YB4MESSe4oK87+GdIDF0ZpoG5
         P7AlT0jSGLEbXt/7ATwSQrm1wV6iCszrJBMutfqXN4Z/Fg9vLPnzbErNGuEXF9ftBfsP
         2oRplLmRHW31QmesfrOitAPBFdIXufeKFPXs54yJdCIXpIBiDnPEh7BlAArgbCvrt0fZ
         vMA7upCi8gatuj8En1wUwysnKtmXZ9rjj2S/DZH30iF3BMpQ3VqeoIKn5qalbymqrzNb
         TRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649381; x=1770254181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=msD2jv18E2L4HOYUfz15g4GHsjmr/D9b7fjjCRW4KGo=;
        b=v5le23h+0PerpL91H3A0It2MPd544w9DUqCEmYRELHyX9G2NV965zxMzBIl1v9+R6u
         397Gf/zMUBbp2AjJF552lRDVNuxcfGf2a8CQA1u2vJZzqvLaeZ07BW529AIDABn28zSM
         ZiSDB+0mtXfLsHnWifWSW+ec5GQ14vJ6M/l7Yg7Ipb8HdaTT+7tfhNOIkcnKsG0/fz1d
         dNtK2yExMcH1SnLcv/OWfEEwyHA83DUXHfk4Um/GbMFl9FX/Z+FTuiNm/a2Yq4IUx4kO
         0DWdOwVq+oHcOU5e8iMLjM78fPtQhbd8yam1a+8qg2tbVkUs2uHWsgJ+1R+7mzeSbEh2
         ss3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVazdLkfxEZu+G3r73b5Rpg6WaFM8cDk26/WZLJaDGlrVGCxHmYiw7bsVHjA7hfu3XPuvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUcNyO8ioNTm2xeZXZREeQVs8Hnwk1dN6co9D959w0IRO8ztb/
	LrkolVxlJnR4u1qRk1FtmRj/nzlR9VJ2ooLYy49tJJP1ovZLvVyr++wjxSqVC3uo9uc7VYpGDPU
	nDRW7hQ==
X-Received: from pjof4.prod.google.com ([2002:a17:90a:8e84:b0:34c:cb46:dad7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2789:b0:34c:cb3c:f536
 with SMTP id 98e67ed59e1d1-353fedbb396mr7057728a91.36.1769649380899; Wed, 28
 Jan 2026 17:16:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:00 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-29-seanjc@google.com>
Subject: [RFC PATCH v5 28/45] x86/virt/tdx: Extend "reset page" quirk to
 support huge pages
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69479-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: EDF27AAAAB
X-Rspamd-Action: no action

Extend the APIs for "resetting" TDX pages to workaround the TDX_PW_MCE
erratum to support huge pages, e.g. so that KVM can pass in the pfn+level
without having to manually calculate the size in multiple locations.

No functional change intended (because KVM doesn't currently support
anything but level=PG_LEVEL_4K).

Suggested-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tdx.h  | 7 ++++++-
 arch/x86/kvm/vmx/tdx.c      | 2 +-
 arch/x86/virt/vmx/tdx/tdx.c | 6 +++---
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 8ceaebc6c1a9..e61b0b3cc403 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -157,7 +157,12 @@ int tdx_topup_pamt_cache(struct tdx_pamt_cache *cache, unsigned long npages);
 int tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache);
 void tdx_pamt_put(u64 pfn);
 
-void tdx_quirk_reset_page(u64 pfn);
+void __tdx_quirk_reset_page(u64 pfn, enum pg_level level);
+
+static inline void tdx_quirk_reset_page(u64 pfn)
+{
+	__tdx_quirk_reset_page(pfn, PG_LEVEL_4K);
+}
 
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 90133e8f5c53..aca556923822 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1871,7 +1871,7 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
 
-	tdx_quirk_reset_page(pfn);
+	__tdx_quirk_reset_page(pfn, level);
 	tdx_pamt_put(pfn);
 }
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 367df9366d57..411e5feef39f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -799,11 +799,11 @@ static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 	mb();
 }
 
-void tdx_quirk_reset_page(u64 pfn)
+void __tdx_quirk_reset_page(u64 pfn, enum pg_level level)
 {
-	tdx_quirk_reset_paddr(PFN_PHYS(pfn), PAGE_SIZE);
+	tdx_quirk_reset_paddr(PFN_PHYS(pfn), page_level_size(level));
 }
-EXPORT_SYMBOL_FOR_KVM(tdx_quirk_reset_page);
+EXPORT_SYMBOL_FOR_KVM(__tdx_quirk_reset_page);
 
 static void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
 {
-- 
2.53.0.rc1.217.geba53bf80e-goog


