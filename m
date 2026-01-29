Return-Path: <kvm+bounces-69464-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6KdlN3y1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69464-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:18:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 585D0AA9AB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 613863043D78
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA50131AAA3;
	Thu, 29 Jan 2026 01:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XZO2dMZL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1920E32ED39
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649359; cv=none; b=XHJCshG5rd5tMNpchBkxMWrZiRG166MLoD8bZA19vdaqEkMw95hHEHfWaTHA5o9crZgIHk/lhpnVHb8cfAaGlPNaoEahYg1l/c3wS6zrA3086mkXQWEXVJJv+oHmIGshCO9vyXLTFUZGTFelrEafBP9Rp3lFw9zMFbHynW2nS+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649359; c=relaxed/simple;
	bh=esb0FgEarAvzd7he3f1yhhOtX7p49PRyk0uclVgGx9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nGn6K1c7AUO6cNck8IxuOHjUAh3MalB+XZZ/YEVuI3OC3Lu4pqTYJEG3KYe3kZyaTPdfHpRJ6jNeQKnsaf6dq3tf60V85W1R5YxEnGyGLrTQAIfEIXBwtk0CsCjfgzjessvPI2PN0N0yLZmg7YAWSbxgaYnCCTCdFQ6N4oXYMog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XZO2dMZL; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a871c32cdbso3794755ad.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649354; x=1770254154; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UlFOBu5FArwUjFk9bCGxsyWYTTpURccpKRpfejh6JpM=;
        b=XZO2dMZLp55RudMI1Rh6X7k3WvSlotfaJEGCYw6RBXr0Sj2sysggcmKVZ2DL0eaicx
         kah2lVeKPcSfE+9YLS3ayAewbGnIB7zq7BU+LDOQy2UW9bBKlqBqYxb1FdZKdyTlselT
         3yOCqJJegmd08bAUBopFX7VXR5ThZQTxvwy+QljuyYd94FmYZH7QlckyD9WSwCyG6+RF
         nadJQRYEyTED/f41s2n7SXTQ3AucSpsA2a1RnDCpbtu+LBDvsxxEamxxWIvB+F4+WzzV
         +DqDfRcaWfQ8qhMb2E0THN9FRk4oCPtBcXtTv9sRsnKopEYM0xQevELWXlADvA5pMDIW
         r4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649354; x=1770254154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UlFOBu5FArwUjFk9bCGxsyWYTTpURccpKRpfejh6JpM=;
        b=SfFMsKODJEK7fOYOyxR+dkvei0JXHFiAREEECji7SKtXoF3MUGaVQ4j1jDYzBSxk0L
         vRPFbf5cojcQhwuNaFlwcAZRjZavLSu8KMRq6psl4/AOKNhE5YTMD3B4xOP5ghbKeNDC
         uQSUGw1XO4LR0asC6K8Oq8bCUpx8b9mZM5ovjhlV30XwLKCwC2OEe3CL81Nuc+ezYCDh
         Vh6/XyRZTFo/ldVfWFhCr+VcZu3niMEpo/cB3MPmsd0G5UCU262QZXNKab+iFC3fFwg8
         SzklBbL3X9tNVpzQukMb05LDelyQ9y6iIuHbS6lc1p+Rl9R6P8u5U0ZbBJWeqBMXw2BV
         4wfw==
X-Forwarded-Encrypted: i=1; AJvYcCWRJUv9Sm40aJrJbABXBF/s4xUZEHbspX/fvVtwHNnhxVpadebo7hHhWNHmpJlyVKib1Io=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvs1b8H6mZ5BaQPjFyuQnbwspt584CF4ySxi3qixX4T2Kieh4J
	oJfQutR+Q5qlaAm+a+3RgAqYMjq5gWRakNtP32790DKxpF5M3Rdu9tiV1d1u2gZKdeaSkQHWv0n
	md+3/cg==
X-Received: from plbd1.prod.google.com ([2002:a17:902:f141:b0:29d:5afa:2d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ca0f:b0:2a0:9fc8:a98b
 with SMTP id d9443c01a7336-2a870ddc60amr49753935ad.40.1769649354439; Wed, 28
 Jan 2026 17:15:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:46 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-15-seanjc@google.com>
Subject: [RFC PATCH v5 14/45] x86/virt/tdx: Allocate reference counters for
 PAMT memory
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
	TAGGED_FROM(0.00)[bounces-69464-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 585D0AA9AB
X-Rspamd-Action: no action

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

The PAMT memory holds metadata for TDX protected memory. With Dynamic
PAMT, the 4KB range of PAMT is allocated on demand. The kernel supplies
the TDX module with a page pair that covers 2MB of host physical memory.

The kernel must provide this page pair before using pages from the range
for TDX. If this is not done, any SEAMCALL that attempts to use the memory
will fail.

Allocate reference counters for every 2MB range to track PAMT memory usage.
This is necessary to accurately determine when PAMT memory needs to be
allocated and when it can be freed.

This allocation will currently consume 2 MB for every 1 TB of address
space from 0 to max_pfn (highest pfn of RAM). The allocation size will
depend on how the ram is physically laid out. In a worse case scenario
where the entire 52 bit address space is covered this would be 8GB. Then
the DPAMT refcount allocations could hypothetically exceed the savings
from Dynamic PAMT, which is 4GB per TB. This is probably unlikely.

However, future changes will reduce this refcount overhead to make DPAMT
always a net win.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 47 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 517c6759c3ca..db48bf2ce601 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -30,6 +30,7 @@
 #include <linux/suspend.h>
 #include <linux/idr.h>
 #include <linux/kvm_types.h>
+#include <linux/vmalloc.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
 #include <asm/msr-index.h>
@@ -51,6 +52,16 @@ static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 
 static struct tdmr_info_list tdx_tdmr_list;
 
+/*
+ * On a machine with Dynamic PAMT, the kernel maintains a reference counter
+ * for every 2M range. The counter indicates how many users there are for
+ * the PAMT memory of the 2M range.
+ *
+ * The kernel allocates PAMT memory when the first user arrives and
+ * frees it when the last user has left.
+ */
+static atomic_t *pamt_refcounts;
+
 static enum tdx_module_status_t tdx_module_status;
 static DEFINE_MUTEX(tdx_module_lock);
 
@@ -184,6 +195,34 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_cpu_enable);
 
+/*
+ * Allocate PAMT reference counters for all physical memory.
+ *
+ * It consumes 2MiB for every 1TiB of physical memory.
+ */
+static int init_pamt_metadata(void)
+{
+	size_t size = DIV_ROUND_UP(max_pfn, PTRS_PER_PTE) * sizeof(*pamt_refcounts);
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	pamt_refcounts = __vmalloc(size, GFP_KERNEL | __GFP_ZERO);
+	if (!pamt_refcounts)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void free_pamt_metadata(void)
+{
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return;
+
+	vfree(pamt_refcounts);
+	pamt_refcounts = NULL;
+}
+
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
  * all memory regions are added in address ascending order and don't
@@ -1083,10 +1122,14 @@ static int init_tdx_module(void)
 	 */
 	get_online_mems();
 
-	ret = build_tdx_memlist(&tdx_memlist);
+	ret = init_pamt_metadata();
 	if (ret)
 		goto out_put_tdxmem;
 
+	ret = build_tdx_memlist(&tdx_memlist);
+	if (ret)
+		goto err_free_pamt_metadata;
+
 	/* Allocate enough space for constructing TDMRs */
 	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdx_sysinfo.tdmr);
 	if (ret)
@@ -1136,6 +1179,8 @@ static int init_tdx_module(void)
 	free_tdmr_list(&tdx_tdmr_list);
 err_free_tdxmem:
 	free_tdx_memlist(&tdx_memlist);
+err_free_pamt_metadata:
+	free_pamt_metadata();
 	goto out_put_tdxmem;
 }
 
-- 
2.53.0.rc1.217.geba53bf80e-goog


