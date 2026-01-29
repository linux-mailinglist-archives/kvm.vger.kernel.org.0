Return-Path: <kvm+bounces-69468-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CLeYEdu1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69468-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:20:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B7EAA9DE
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 177063096D16
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17795344DA4;
	Thu, 29 Jan 2026 01:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0XC4V+9H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6A131C57B
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649365; cv=none; b=pQgycwSpdUtrlzxWNEvJmFTsHf90TF5LifwRNDUBJ9dOAtQUHDl3OLNRrF71VeLHAR17/JUoazePeiSY6noVBYdcFrWGDDfKtH97aeWuiOFMs4DBzoJU0PuBS/p2RmpWV146ygy7jHsialIs+yJF/d/2GiRShwTVn8Mm0QXkCow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649365; c=relaxed/simple;
	bh=AXxQxnhtnt5YWRVt+lGWA6sUB4Tt8qHFbJ97Bkuq2Ck=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kG64yfgZ5S0lVbloO/bq4K05YDjz8CubTYHo/IUBpG4pU5Ihx5pMtya5ZDJIVJGfF39fMKsuBxNK6VaUmnTDPmNIJevmyqTa6b5RM53W/wj5SfYicVndgTKMR3Kb/lUxcYem5u7kzct0J88VzR0eKQ+NuIHePafQjnx6OXqIweA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0XC4V+9H; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352e195f662so273288a91.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649363; x=1770254163; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CQTLYZXbjXhuegQycdxIvwBS6byU7gVEkkc0u846/P4=;
        b=0XC4V+9HgEwcFw83xyxzkzLqqU42+KuT1CemPHaI6AR9FH3kboNo4bWF2E+DnoI9qn
         YS4smVIMsi6FDL1UFhjFlcuDM431X9t0iQauv5CojKeovYTglVYa2iu/bS8CiE67QCpG
         g+XK5xAweSQTz9v8PkkLIUs1F+qmP0U3Xz+Q1vu2Jn6hg50HSYgavr9VeJoAZjok5Czy
         eaxocl3bfZQY0Jp6krzIG1ehPwnkWdRY71SMwiQ95b5eAB2oMnF9i+qRm5Qa4kBN7vg3
         3e1M3ZL6Kjnr4j/soJfCj5zRTmigwIK1/td/Z5wg2tpb3MoqN//HXNlxpNkWluw4AeF6
         W1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649363; x=1770254163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CQTLYZXbjXhuegQycdxIvwBS6byU7gVEkkc0u846/P4=;
        b=Pn7emvizYdCgP0h727Fh7ZFN53bfbkgWsCILlxlcCrfgkz3oF+gq38SFwiGkigztmg
         KIt4w7BDsqYjJ6Hhe7HFQuBLkWgK0V7gUDIHdTpKXdJWe0mSpIiMopvmb31NCMfpWdRW
         U8BdlDqyVevWxlOz5jlVkc+/1tlCcO7zlu7nSkMdOmteep01Uz1+nASn+Gi64KnffaWn
         aUAB11VqdNO+wA6CK0RUMyQMIWcKEsivcL0RCOerw6GIqBBeC03qs+RrCZi6cFOInXGu
         D8QRUhlLGtr3aXxQrwTvwfiffU5FQzpl/Cwyq33M5h3ukbLsuB23jK3ojGbM9UA9XYT2
         efqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLbQfNIKUqLQzZuJ2STbfl0cpjOWl2c5usI8StOfm5yWzyOUdov9KjPfeh0xvScC9IdD8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Rqll/TJDjQZQaJGZ1aSMtbBWI2H8oikw0S08pjptQteUi8DN
	RKsv3wLJCXRZcdbL2cZxk3ppXInRESCba5Zits8stgkDQIqaME/PbLHHPYSSLI3qpVwU/JSxAKz
	dFMdmbQ==
X-Received: from pjbmy4.prod.google.com ([2002:a17:90b:4c84:b0:353:31e9:fe44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51cb:b0:340:a5b2:c305
 with SMTP id 98e67ed59e1d1-353feccf407mr5767501a91.2.1769649363134; Wed, 28
 Jan 2026 17:16:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:50 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-19-seanjc@google.com>
Subject: [RFC PATCH v5 18/45] KVM: TDX: Allocate PAMT memory for TD and vCPU
 control structures
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
	TAGGED_FROM(0.00)[bounces-69468-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email];
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
X-Rspamd-Queue-Id: D3B7EAA9DE
X-Rspamd-Action: no action

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

TDX TD control structures are provided to the TDX module at 4KB page size
and require PAMT backing. This means for Dynamic PAMT they need to also
have 4KB backings installed. Use the recently introduce TDX APIs for
allocating/freeing control pages, which handle DPAMT maintenance, to
allocate/free TD and vCPU pages for TDX guests.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
[sean: handle alloc+free+reclaim in one patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4ef414ee27b4..323aae4300a1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -360,7 +360,7 @@ static void tdx_reclaim_control_page(struct page *ctrl_page)
 	if (tdx_reclaim_page(ctrl_page))
 		return;
 
-	__free_page(ctrl_page);
+	__tdx_free_control_page(ctrl_page);
 }
 
 struct tdx_flush_vp_arg {
@@ -597,7 +597,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 
 	tdx_quirk_reset_page(kvm_tdx->td.tdr_page);
 
-	__free_page(kvm_tdx->td.tdr_page);
+	__tdx_free_control_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
 }
 
@@ -2412,7 +2412,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 	atomic_inc(&nr_configured_hkid);
 
-	tdr_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	tdr_page = __tdx_alloc_control_page(GFP_KERNEL_ACCOUNT);
 	if (!tdr_page)
 		goto free_hkid;
 
@@ -2425,7 +2425,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto free_tdr;
 
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		tdcs_pages[i] = alloc_page(GFP_KERNEL_ACCOUNT);
+		tdcs_pages[i] = __tdx_alloc_control_page(GFP_KERNEL_ACCOUNT);
 		if (!tdcs_pages[i])
 			goto free_tdcs;
 	}
@@ -2543,10 +2543,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 teardown:
 	/* Only free pages not yet added, so start at 'i' */
 	for (; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		if (tdcs_pages[i]) {
-			__free_page(tdcs_pages[i]);
-			tdcs_pages[i] = NULL;
-		}
+		__tdx_free_control_page(tdcs_pages[i]);
+		tdcs_pages[i] = NULL;
 	}
 	if (!kvm_tdx->td.tdcs_pages)
 		kfree(tdcs_pages);
@@ -2561,16 +2559,13 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	free_cpumask_var(packages);
 
 free_tdcs:
-	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		if (tdcs_pages[i])
-			__free_page(tdcs_pages[i]);
-	}
+	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++)
+		__tdx_free_control_page(tdcs_pages[i]);
 	kfree(tdcs_pages);
 	kvm_tdx->td.tdcs_pages = NULL;
 
 free_tdr:
-	if (tdr_page)
-		__free_page(tdr_page);
+	__tdx_free_control_page(tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
 
 free_hkid:
@@ -2900,7 +2895,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	int ret, i;
 	u64 err;
 
-	page = alloc_page(GFP_KERNEL_ACCOUNT);
+	page = __tdx_alloc_control_page(GFP_KERNEL_ACCOUNT);
 	if (!page)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
@@ -2920,7 +2915,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	}
 
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		page = alloc_page(GFP_KERNEL_ACCOUNT);
+		page = __tdx_alloc_control_page(GFP_KERNEL_ACCOUNT);
 		if (!page) {
 			ret = -ENOMEM;
 			goto free_tdcx;
@@ -2942,7 +2937,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 			 * method, but the rest are freed here.
 			 */
 			for (; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-				__free_page(tdx->vp.tdcx_pages[i]);
+				__tdx_free_control_page(tdx->vp.tdcx_pages[i]);
 				tdx->vp.tdcx_pages[i] = NULL;
 			}
 			return -EIO;
@@ -2970,16 +2965,14 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 
 free_tdcx:
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		if (tdx->vp.tdcx_pages[i])
-			__free_page(tdx->vp.tdcx_pages[i]);
+		__tdx_free_control_page(tdx->vp.tdcx_pages[i]);
 		tdx->vp.tdcx_pages[i] = NULL;
 	}
 	kfree(tdx->vp.tdcx_pages);
 	tdx->vp.tdcx_pages = NULL;
 
 free_tdvpr:
-	if (tdx->vp.tdvpr_page)
-		__free_page(tdx->vp.tdvpr_page);
+	__tdx_free_control_page(tdx->vp.tdvpr_page);
 	tdx->vp.tdvpr_page = NULL;
 	tdx->vp.tdvpr_pa = 0;
 
-- 
2.53.0.rc1.217.geba53bf80e-goog


