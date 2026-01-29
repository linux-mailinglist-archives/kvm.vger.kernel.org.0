Return-Path: <kvm+bounces-69453-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHTdNiC1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69453-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F65DAA93A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6426C305E9DD
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B9B3148BF;
	Thu, 29 Jan 2026 01:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Izhe0iXb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0396D31C57B
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649335; cv=none; b=g6VqJ85GKtXC77iZC0kwM7zf5FVxZCPK5Rm9F7kgSH0Jp8SLUIvi9a6B0eYcr8+Vbf2g4ByORUtSo0HWKyT490rUk7VpB08cODJUhEGV+x5V0q8wehzgJOUUy6Rq0f7M0e6Hxb1Kt1ajHV1EpFrBV1lZXMSbT+HJHTF9SsxHcOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649335; c=relaxed/simple;
	bh=rawa+GdPzt/mn/jjYKeF7IrFPzAWvGBv/cL7AH4QpdE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pgSUfu9N1kY822Ym9H052msMnOz4kNUeHG1LTNW0CsAs5VxcIjsHScIQvWRb3JxXKgNxiuyAqapqxD3LG3uVSCGSwy+QNUlCmVeg8f+vMyz5mL0aI7KNbcelPR94kKWGDEKvVQUoJUaxdPmQsyriBpbn6EKP2OoLBVMmSJO2zTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Izhe0iXb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ed2so331054a91.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649333; x=1770254133; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QDz31TgUHSC/pAT7NKm7s9BECEFc0xut5G3SF9CrPBg=;
        b=Izhe0iXbQIr5wee6Ty1226YDIUoBlPpzttNBH7dTq5yIE9nPjqyZIQHmTEOuvLTZ0Z
         DU5USJfKNI65e+kSZbJciUHrkGOh7jP1Uvm44E+kWNtfry6oldtYjvuYybSTOArYL/tw
         WKSY9AeeTrzVRtEZ17cgW760BkgpZfeAAbgkKYjAy9zba70laEZyxzvpY256PAMQdbUs
         EWdIREoVDcKjGtUeLm8q5jcCm+vlRR3PzB+dwFPHwIinSZOKNePqYhs6K+syXU37umtg
         h8wfDMGe4DIfFTzcwH0ppnWxLypmYzx32DslYQZ5rJQDf2E2UZbzNQsjtOjHXDKU6jmz
         C86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649333; x=1770254133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QDz31TgUHSC/pAT7NKm7s9BECEFc0xut5G3SF9CrPBg=;
        b=J3txM963WjKVvnOwRS59FeRHF1jc7P3MUOTn9IxYRxDMt6z4POOWMTKVMwDANrSqwq
         cWe4LDddfq3oCiQ81EBUQHeq6G/GCi1E3IHWr65guU6aixwzYjlFs/DH9DXhTdoc/VMZ
         tDwEaKMjhf1PjpiThOpL+94cDbGgtgpAaOGxp2PmW+3XyKTmMfSLKTZkxwJXCvOJTSAz
         KuB7/Z68vfuHk7UnytMSvto4T+vrq8R7esoT/8ONbac4Y9q1wcILiWQFo4ApudunV9NR
         8hncmcZZB3+w5BzwZXKQ7JqOoZ4HzjxvDAVUEqTPAkOAAPT7+m6C7Tr9CjWI9KT3t7Sa
         b5OQ==
X-Forwarded-Encrypted: i=1; AJvYcCVs/qW/1bUFMIO6G3YZJZB2hLzqXotVTQKXKTTgyaLEGL0HAMnCqH8lNQbeqHG3dgCHyvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBtbMghKhWg7umW59mxu641/v8sz+hOomnBVuolHU0pYJSsCNd
	z/k4iNmR9F1zFgml0Qo///CmL/jlDeO1/fcC5DcCB+uKvj45sev8eYqTdoXaTjkvCluP4+hVp7H
	8wYNVTA==
X-Received: from pjbnh9.prod.google.com ([2002:a17:90b:3649:b0:352:ff8b:ef26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:50c8:b0:32b:9774:d340
 with SMTP id 98e67ed59e1d1-353fedb93fbmr6374509a91.33.1769649333379; Wed, 28
 Jan 2026 17:15:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:35 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-4-seanjc@google.com>
Subject: [RFC PATCH v5 03/45] KVM: TDX: Account all non-transient page
 allocations for per-TD structures
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
	TAGGED_FROM(0.00)[bounces-69453-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 7F65DAA93A
X-Rspamd-Action: no action

Account all non-transient allocations associated with a single TD (or its
vCPUs), as KVM's ABI is that allocations that are active for the lifetime
of a VM are accounted.  Leave temporary allocations, i.e. allocations that
are freed within a single function/ioctl, unaccounted, to again align with
KVM's existing behavior, e.g. see commit dd103407ca31 ("KVM: X86: Remove
unnecessary GFP_KERNEL_ACCOUNT for temporary variables").

Fixes: 8d032b683c29 ("KVM: TDX: create/destroy VM structure")
Fixes: a50f673f25e0 ("KVM: TDX: Do TDX specific vcpu initialization")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 561461c9d131..5688c77616e3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2397,7 +2397,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 	atomic_inc(&nr_configured_hkid);
 
-	tdr_page = alloc_page(GFP_KERNEL);
+	tdr_page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!tdr_page)
 		goto free_hkid;
 
@@ -2405,12 +2405,12 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	/* TDVPS = TDVPR(4K page) + TDCX(multiple 4K pages), -1 for TDVPR. */
 	kvm_tdx->td.tdcx_nr_pages = tdx_sysinfo->td_ctrl.tdvps_base_size / PAGE_SIZE - 1;
 	tdcs_pages = kcalloc(kvm_tdx->td.tdcs_nr_pages, sizeof(*kvm_tdx->td.tdcs_pages),
-			     GFP_KERNEL);
+			     GFP_KERNEL_ACCOUNT);
 	if (!tdcs_pages)
 		goto free_tdr;
 
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		tdcs_pages[i] = alloc_page(GFP_KERNEL);
+		tdcs_pages[i] = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!tdcs_pages[i])
 			goto free_tdcs;
 	}
@@ -2885,7 +2885,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	int ret, i;
 	u64 err;
 
-	page = alloc_page(GFP_KERNEL);
+	page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!page)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
@@ -2898,14 +2898,14 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	tdx->vp.tdvpr_pa = page_to_phys(tdx->vp.tdvpr_page);
 
 	tdx->vp.tdcx_pages = kcalloc(kvm_tdx->td.tdcx_nr_pages, sizeof(*tdx->vp.tdcx_pages),
-			       	     GFP_KERNEL);
+				     GFP_KERNEL_ACCOUNT);
 	if (!tdx->vp.tdcx_pages) {
 		ret = -ENOMEM;
 		goto free_tdvpr;
 	}
 
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		page = alloc_page(GFP_KERNEL);
+		page = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!page) {
 			ret = -ENOMEM;
 			goto free_tdcx;
-- 
2.53.0.rc1.217.geba53bf80e-goog


