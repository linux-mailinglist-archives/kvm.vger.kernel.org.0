Return-Path: <kvm+bounces-69465-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFqSGja1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69465-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F950AA94A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4409E302196B
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D032519755B;
	Thu, 29 Jan 2026 01:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eowRY3tU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9C2331A53
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649360; cv=none; b=bPbZushfCD+HIKnm+JhZcDnVFR0R3n2smNcFjGBectvooRvTFyHR4g21nV4AoVeYIpLtN08e6HU5V6CYRe2uIySe5oLW1B4/62P5D+yzH6SnWI70QCoG87Vgp7uC1zN9yZZyDYSDKj/n5ym6VDFmPJvHsHHlkQCZ4SoHoVPPJBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649360; c=relaxed/simple;
	bh=6Mm0CxsePKv0UPnTln/3LFfYBmAkOanL4/Zsp57lTRg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mLdk4xGkcnutJCC9thJGEWGwQNmbGlwUVek/H/r8TElXUZ0ObIPAAJUNpgIDFesjJUFPp9OlRFGfnUe77LjquQWmSwQ8Oej1VmZfrTq0SYrWJzG7vJWiwvl162/vsTX3x2S/2bTSnxoqF/PT9DDNJmL4AvfLvxvrijLDplOtkmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eowRY3tU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so3320105ad.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649356; x=1770254156; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Bauc2hlFnmZtSKMyZqeZEsyhD6tTcOYVqQRVSOeimY=;
        b=eowRY3tUfEqiaRtjN3y+WYBVdHTQ7s6Y2DTUVU9xtYvq94GMiMEtb2z3SdszG6TNY5
         SPdfa72mclrokx5zPlVdrmpYRerI0rlvnuRZn7ARfGa44l9IbKXZv2agFoPUB+8vx0iB
         loK5Vfh0ddm5MFAnno2sxFndxdbKxurf9J/QRBOykILC2SyS3BSzVAXqB4bOoN5NRn0O
         fWhy/oLaKWODqe8Aip5w9VZGwyTynQF3jME8otOGbBHY6IkwntluVl8D84N/mdjt2OGW
         6C4tPTO2KHKsDErYdjGnsStUx5PISfZ8Ikkg/p/SspO994z/V0OybjZtL+FhH0W+80Gm
         39bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649356; x=1770254156;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Bauc2hlFnmZtSKMyZqeZEsyhD6tTcOYVqQRVSOeimY=;
        b=JMopzcCPoxE9iOjherCGoGL19wOUkqZEObn/M56CzqWVgGOv2B8Xc6iWeFA81rmqy+
         oamjfVHUu5QqV9wymNKYzOwO1bcGHTxgU3JHcg0KwuaONTbrZWI7GSxYGgpiUPqxtKex
         OhSe3Ob7WbTmIoqpdundO8W4d1rnTPXEjFVR6Evu8aMRi9K1VtK4lL77IaOCTBpG0FZl
         anYj9NBsEVXkrUUurBUcuBs2Km33GxlKde6wOUBGqaLsft3rAMWLsk4zUCNtO7/QMpjy
         ncSsY5k7t5PsEhzFhagQLGkuxE+lmahbo5Q9Ol7LfgKxZUTPMJYGyN6/CCyOxEoWjXJT
         ICHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVK78cp47ZmPpNCveo5Avnl4rkPNeYZX0TmCTCeFIKJpTcI5UGUjD6Y8yUfAkBnZ8Y+ITQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0gIOaYGwjzZzvQ0KkRmq9zFHzIbS/dZZontts5rBUMF76MOti
	+D+ZjWfqJGb521X1Tk6pVUPaiJy61+fybmmsx2eM/vk9CptHc2HwEOFyrjK7F5GeDYXn97JZ1zC
	HXFu9Yg==
X-Received: from pjbso3.prod.google.com ([2002:a17:90b:1f83:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384e:b0:340:b912:536
 with SMTP id 98e67ed59e1d1-353fed87a7amr5569509a91.31.1769649356235; Wed, 28
 Jan 2026 17:15:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:47 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-16-seanjc@google.com>
Subject: [RFC PATCH v5 15/45] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
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
Content-Transfer-Encoding: quoted-printable
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
	TAGGED_FROM(0.00)[bounces-69465-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 2F950AA94A
X-Rspamd-Action: no action

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

init_pamt_metadata() allocates PAMT refcounts for all physical memory up
to max_pfn. It might be suboptimal if the physical memory layout is
discontinuous and has large holes.

The refcount allocation vmalloc allocation. This is necessary to support a
large allocation size. The virtually contiguous property also makes it
easy to find a specific 2MB range=E2=80=99s refcount since it can simply be
indexed.

Since vmalloc mappings support remapping during normal kernel runtime,
switch to an approach that only populates refcount pages for the vmalloc
mapping when there is actually memory for that range. This means any holes
in the physical address space won=E2=80=99t use actual physical memory.

The validity of this memory optimization is based on a couple assumptions:
1. Physical holes in the ram layout are commonly large enough for it to be
   worth it.
2. An alternative approach that looks the refcounts via some more layered
   data structure wouldn=E2=80=99t overly complicate the lookups. Or at lea=
st
   more than the complexity of managing the vmalloc mapping.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 122 ++++++++++++++++++++++++++++++++++--
 1 file changed, 118 insertions(+), 4 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index db48bf2ce601..f6e80aba5895 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -195,30 +195,135 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_cpu_enable);
=20
+/* Find PAMT refcount for a given physical address */
+static atomic_t *tdx_find_pamt_refcount(unsigned long pfn)
+{
+	/* Find which PMD a PFN is in. */
+	unsigned long index =3D pfn >> (PMD_SHIFT - PAGE_SHIFT);
+
+	return &pamt_refcounts[index];
+}
+
+/* Map a page into the PAMT refcount vmalloc region */
+static int pamt_refcount_populate(pte_t *pte, unsigned long addr, void *da=
ta)
+{
+	struct page *page;
+	pte_t entry;
+
+	page =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		return -ENOMEM;
+
+	entry =3D mk_pte(page, PAGE_KERNEL);
+
+	spin_lock(&init_mm.page_table_lock);
+	/*
+	 * PAMT refcount populations can overlap due to rounding of the
+	 * start/end pfn. Make sure the PAMT range is only populated once.
+	 */
+	if (pte_none(ptep_get(pte)))
+		set_pte_at(&init_mm, addr, pte, entry);
+	else
+		__free_page(page);
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
 /*
- * Allocate PAMT reference counters for all physical memory.
+ * Allocate PAMT reference counters for the given PFN range.
  *
  * It consumes 2MiB for every 1TiB of physical memory.
  */
+static int alloc_pamt_refcount(unsigned long start_pfn, unsigned long end_=
pfn)
+{
+	unsigned long refcount_first, refcount_last;
+	unsigned long mapping_start, mapping_end;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	/*
+	 * 'start_pfn' is inclusive and 'end_pfn' is exclusive. Find the
+	 * range of refcounts the pfn range will need.
+	 */
+	refcount_first =3D (unsigned long)tdx_find_pamt_refcount(start_pfn);
+	refcount_last   =3D (unsigned long)tdx_find_pamt_refcount(end_pfn - 1);
+
+	/*
+	 * Calculate the page aligned range that includes the refcounts. The
+	 * teardown logic needs to handle potentially overlapping refcount
+	 * mappings resulting from the alignments.
+	 */
+	mapping_start =3D round_down(refcount_first, PAGE_SIZE);
+	mapping_end   =3D round_up(refcount_last + sizeof(*pamt_refcounts), PAGE_=
SIZE);
+
+
+	return apply_to_page_range(&init_mm, mapping_start, mapping_end - mapping=
_start,
+				   pamt_refcount_populate, NULL);
+}
+
+/*
+ * Reserve vmalloc range for PAMT reference counters. It covers all physic=
al
+ * address space up to max_pfn. It is going to be populated from
+ * build_tdx_memlist() only for present memory that available for TDX use.
+ *
+ * It reserves 2MiB of virtual address space for every 1TiB of physical me=
mory.
+ */
 static int init_pamt_metadata(void)
 {
-	size_t size =3D DIV_ROUND_UP(max_pfn, PTRS_PER_PTE) * sizeof(*pamt_refcou=
nts);
+	struct vm_struct *area;
+	size_t size;
=20
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return 0;
=20
-	pamt_refcounts =3D __vmalloc(size, GFP_KERNEL | __GFP_ZERO);
-	if (!pamt_refcounts)
+	size =3D DIV_ROUND_UP(max_pfn, PTRS_PER_PTE) * sizeof(*pamt_refcounts);
+
+	area =3D get_vm_area(size, VM_SPARSE);
+	if (!area)
 		return -ENOMEM;
=20
+	pamt_refcounts =3D area->addr;
 	return 0;
 }
=20
+/* Unmap a page from the PAMT refcount vmalloc region */
+static int pamt_refcount_depopulate(pte_t *pte, unsigned long addr, void *=
data)
+{
+	struct page *page;
+	pte_t entry;
+
+	spin_lock(&init_mm.page_table_lock);
+
+	entry =3D ptep_get(pte);
+	/* refcount allocation is sparse, may not be populated */
+	if (!pte_none(entry)) {
+		pte_clear(&init_mm, addr, pte);
+		page =3D pte_page(entry);
+		__free_page(page);
+	}
+
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+/* Unmap all PAMT refcount pages and free vmalloc range */
 static void free_pamt_metadata(void)
 {
+	size_t size;
+
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return;
=20
+	size =3D max_pfn / PTRS_PER_PTE * sizeof(*pamt_refcounts);
+	size =3D round_up(size, PAGE_SIZE);
+
+	apply_to_existing_page_range(&init_mm,
+				     (unsigned long)pamt_refcounts,
+				     size, pamt_refcount_depopulate,
+				     NULL);
 	vfree(pamt_refcounts);
 	pamt_refcounts =3D NULL;
 }
@@ -289,10 +394,19 @@ static int build_tdx_memlist(struct list_head *tmb_li=
st)
 		ret =3D add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
 		if (ret)
 			goto err;
+
+		/* Allocated PAMT refcountes for the memblock */
+		ret =3D alloc_pamt_refcount(start_pfn, end_pfn);
+		if (ret)
+			goto err;
 	}
=20
 	return 0;
 err:
+	/*
+	 * Only free TDX memory blocks here, PAMT refcount pages
+	 * will be freed in the init_tdx_module() error path.
+	 */
 	free_tdx_memlist(tmb_list);
 	return ret;
 }
--=20
2.53.0.rc1.217.geba53bf80e-goog


