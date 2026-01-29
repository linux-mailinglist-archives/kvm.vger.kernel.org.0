Return-Path: <kvm+bounces-69476-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIHtEqy1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69476-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:19:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CCCAA9CF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A8D9301A771
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD7034E749;
	Thu, 29 Jan 2026 01:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eaVBYD+0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB8534CFC2
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649379; cv=none; b=BKDHw7COdKxZCXR0e3l4tK4nQjYPC5jAVlD94MFBwpjzoPeVHcIQmRrXWvEP7P2jV7rDfxDQuRQQ8E9ThDv6VEOL18EfraFLMS9ScE7BdDUy5DCmi9RWty0g+EpnKzcP/q8UlHyBKVGxVC8d+jnBD2x0oHG2phAdILf+qLHAK7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649379; c=relaxed/simple;
	bh=2AFN/urgPi8sHxS0ED+9ecVsZaZqGadZaHDApgUZnpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AoEWOOE7xzGDcEmh1tIR/0iULpaciMYXbzf1W+3AClY3zoDm3ZGVe/JBP+qeSF0lvaQqQx4Y05faBjjyYo1QN09zg4V3GFc1aZQ8iSNbaB+NkfPm+bjNKilJNnm5GwdgmLN2HAUaOdl/Cq1f5WF8SnkNVtpe44bih2eTKtZkkOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eaVBYD+0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352c79abf36so320025a91.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649377; x=1770254177; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=80B6pHXYnPFCaLMTncYxaAMN7FbDOTiyI0xEQDWm1fU=;
        b=eaVBYD+0n6Ge25BC3ApptZtLTjnLI5TOcJm7WWj03lkKmIyYze7yhM4BVhah0PXQN/
         j0QU8O9nhV/ZkwKKkoPbzaFEj4EhkiNmHMqs7m9N7ey/+bCYffpxlkmVEk55STy1p2EK
         2xJ011t+ec7KS0PS/hPxuzWhSV7QaukJLyOuJ+fL4IHzMfvEvBr/RjoVB+nIALURK5z5
         c3pREQMMAvaAFIh98VyTjtO86rev/+lrIYhmjr97q4vQ4H0gtribkooM6NFElFo8Hkat
         TAvJR6hHJwb8s6q8CKQdZ3qRH5Ce3l8pOtbCg6m2xqKh7PkO12ijpThBWO1y/sO/FbSH
         L2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649377; x=1770254177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=80B6pHXYnPFCaLMTncYxaAMN7FbDOTiyI0xEQDWm1fU=;
        b=PK3wA4gYep65QHK2LugfUQRig2cOsVHEpMBF2mtQ4mytLCZwLAy5D3uNT6A2aH3pcN
         FeMXCagMwFrhXuYesNa2ZfSzvNTWn5I8IaveIM7mFdWGlsA3sWGJGhSWCv8ROOe2ya4S
         aRe7jzYqBzXJA4aYasec01dTaQ2V0mv7sniPzZgPYCPPGoCz+a+X1wpFXpJWsVFGX4fB
         9+FDCOVXOe+DpjEGuRXvxqE8bMiC6dkoX6INY5nKjdtn/AMDwgfxixmxoeMIoiqoRXF7
         uQHTMETkmpBXjaEjVloPhxfWeK8TXQ87AM9o1jC1rpzCHG6GHM/ptY8cl0L4x7pkeAo5
         hAaA==
X-Forwarded-Encrypted: i=1; AJvYcCXNss3knh8vWTEoVVPHVbhm0lC96e1qEVAhCEb5y7NV9OwE42LYMlw+hDWY0CPywExb334=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOT+UkRgD/H57PzELy/+OR6915ARIBjte3/eQ1HGSSQuwAGAaB
	ZoWKhM8HVKQc9H6LcQcw4eNfBeOzoyg/jNOrl2lnTKCHqZEM+t0B6p2CBjFcH5uO5JLqFaHxAWs
	b+XAg4A==
X-Received: from pjbos4.prod.google.com ([2002:a17:90b:1cc4:b0:34a:c87f:a95a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c88c:b0:340:9cf1:54d0
 with SMTP id 98e67ed59e1d1-353fecca19emr6398135a91.1.1769649377470; Wed, 28
 Jan 2026 17:16:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:58 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-27-seanjc@google.com>
Subject: [RFC PATCH v5 26/45] x86/virt/tdx: Enhance tdh_mem_page_aug() to
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69476-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 35CCCAA9CF
X-Rspamd-Action: no action

From: Yan Zhao <yan.y.zhao@intel.com>

Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.

The SEAMCALL TDH_MEM_PAGE_AUG currently supports adding physical memory to
the S-EPT up to 2MB in size.

While keeping the "level" parameter in the tdh_mem_page_aug() wrapper to
allow callers to specify the physical memory size, introduce the parameters
"folio" and "start_idx" to specify the physical memory starting from the
page at "start_idx" within the "folio". The specified physical memory must
be fully contained within a single folio.

Invoke tdx_clflush_page() for each 4KB segment of the physical memory being
added. tdx_clflush_page() performs CLFLUSH operations conservatively to
prevent dirty cache lines from writing back later and corrupting TD memory.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
[sean: remove the page+folio assumptions]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 85c31ed9b9d1..37776ea56eb7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1756,9 +1756,13 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, enum pg_level level, u64 pfn,
 		.rdx = tdx_tdr_pa(td),
 		.r8 = PFN_PHYS(pfn),
 	};
+	unsigned long npages = page_level_size(level) / PAGE_SIZE;
+	unsigned long i;
 	u64 ret;
 
-	tdx_clflush_pfn(pfn);
+	for (i = 0; i < npages; i++)
+		tdx_clflush_pfn(pfn + i);
+
 	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
 
 	*ext_err1 = args.rcx;
-- 
2.53.0.rc1.217.geba53bf80e-goog


