Return-Path: <kvm+bounces-65452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9738FCA9D42
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4015831A146F
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81A041459FA;
	Sat,  6 Dec 2025 01:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xw8n6Z49"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF89E242D91
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 01:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764983477; cv=none; b=suC3QHYNvIsI6NckLHGPQqgBW3GHRAlLRs764xbUIkqXNELUfurdGS6BqgqHDCt3sns6oyJNH+ThJc+xXg7ajthpY4Jmh369ODMyt9tnRqYtGDLuF7P7Chb0hGLhOAQeeAbfMu/FhRsoVJNqCXaXNC+tQ6pie1J6yr7vADnHsGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764983477; c=relaxed/simple;
	bh=l7luhA58Ogc/VIls8G8zjcbt0uhbWWok9pxvmMLiVs0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YGwBN4KNyWLojaCneDmKceQ3yH4Ab199TTxpSwJg50JTsE4uSQun10ArtfEeEQkLAB3kIEgRDQwSUkakcSScH4uqRmoX6vEhUhXE8O4IMiQIhj8qB8T8+DWjozJ8tthK5A4OHI6NApJSlpaXCtpHWlptO5afR/6sQ1u2jyxbhf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xw8n6Z49; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297f587dc2eso3591375ad.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 17:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764983474; x=1765588274; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9IgG/EwS0rhU6/zESmY7/VVF5fzyu73j5FogJ2Eynxk=;
        b=Xw8n6Z49pq4+TZuEBFTIDxxeVIp0tYF/lmn7gcgr9I2zvYMfyoXj7hfO9LChYSfan5
         DGk74N7chVuIAWL2pdhNHFj/Ky9ogvYZX03HRP96HPsq/xkP3xwiLto2mKHgH4JCFamn
         cjQufMEptFk28XSxrnispW85f613PSBtqQanDGvql8UCX72VTAVBD7/yg4ppuOsm3Oqp
         BdwNexO+2O3h7BQVRepvVI7ThRWxl4oKRbYGSMjwF5XcGFmxKPqFiJck3+zX4YFl0qBh
         wFTdaOoXwz4pVBFrlwPSNhdVUywe0zhnYkP3S7cEqEPHCluWYGhL0pO2QFXOV3ftU3AN
         1PYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764983474; x=1765588274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9IgG/EwS0rhU6/zESmY7/VVF5fzyu73j5FogJ2Eynxk=;
        b=HFJGqzoo3E6hD9qHx/2V3j7weDfqrDjySNIxc5I6j0ZtuzU3no5Tyi9jl+gSD1dRrH
         fWmclyZRM1+a/iv4m/j9IGtbzlGyDogQCX7XVcMM2xXarXkLPou1SJyBjN8CUasul2p1
         Yt+pEevPBCfrWlx8y6kW07jgLxXsTkv1CrollSbz6ZmtUl4x6TH3IMxZAtdP5f7B8UQn
         vdprkqphAWK0Zp+ZabJh+aVa9xzYZ2jIerq2KkC4UpSGLdkYabjJJIxD+a+FejW1qNnE
         xz8jRn4vGPbtm1XCGD0n78N+jyKu2KK4gotjsefsiBedO1v/Xecn92iO38w1IlO8grSr
         gERg==
X-Forwarded-Encrypted: i=1; AJvYcCWobUIG9CjBkkv7aUCgjnEgT8qqks5Mcl6ypml6S/FiLmnCJxNY/uSq63d/ViXjM/LQ4kE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb5fZy0DAwHSzIeL4wxemZaY05AtfqokwRTFoiOCrLqjlSn8rS
	UJH+7faJmxigIIDCWP4Mt6nWGxVI68HNlFgcXZCCdVeQ2/VCI1R5L1ngA7BNvb3hfBVfQduwro6
	LfB/vJw==
X-Google-Smtp-Source: AGHT+IGRS9sQuIP9/GMS0SenwgYnysTWUy3gYbpCBzzZG+YUTgplWaBrw+naN0TdcM0x09NFhWX66ud1UBI=
X-Received: from plse4.prod.google.com ([2002:a17:902:b784:b0:298:3a03:dc2e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:240e:b0:298:5599:3ab0
 with SMTP id d9443c01a7336-29df59a867bmr7455415ad.16.1764983474152; Fri, 05
 Dec 2025 17:11:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 17:10:51 -0800
In-Reply-To: <20251206011054.494190-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206011054.494190-5-seanjc@google.com>
Subject: [PATCH v2 4/7] x86/virt/tdx: Tag a pile of functions as __init, and
 globals as __ro_after_init
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that TDX-Module initialization is done during subsys init, tag all
related functions as __init, and relevant data as __ro_after_init.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/virt/vmx/tdx/tdx.c                 | 115 ++++++++++----------
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  10 +-
 2 files changed, 64 insertions(+), 61 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8282c9b1b48b..d49645797fe4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -55,8 +55,8 @@ static struct tdmr_info_list tdx_tdmr_list;
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
-static struct tdx_sys_info tdx_sysinfo;
-static bool tdx_module_initialized;
+static struct tdx_sys_info tdx_sysinfo __ro_after_init;
+static bool tdx_module_initialized __ro_after_init;
 
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
@@ -226,8 +226,9 @@ static struct syscore_ops tdx_syscore_ops = {
  * all memory regions are added in address ascending order and don't
  * overlap.
  */
-static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
-			    unsigned long end_pfn, int nid)
+static __init int add_tdx_memblock(struct list_head *tmb_list,
+				   unsigned long start_pfn,
+				   unsigned long end_pfn, int nid)
 {
 	struct tdx_memblock *tmb;
 
@@ -245,7 +246,7 @@ static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
 	return 0;
 }
 
-static void free_tdx_memlist(struct list_head *tmb_list)
+static __init void free_tdx_memlist(struct list_head *tmb_list)
 {
 	/* @tmb_list is protected by mem_hotplug_lock */
 	while (!list_empty(tmb_list)) {
@@ -263,7 +264,7 @@ static void free_tdx_memlist(struct list_head *tmb_list)
  * ranges off in a secondary structure because memblock is modified
  * in memory hotplug while TDX memory regions are fixed.
  */
-static int build_tdx_memlist(struct list_head *tmb_list)
+static __init int build_tdx_memlist(struct list_head *tmb_list)
 {
 	unsigned long start_pfn, end_pfn;
 	int i, nid, ret;
@@ -295,7 +296,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
-static int read_sys_metadata_field(u64 field_id, u64 *data)
+static __init int read_sys_metadata_field(u64 field_id, u64 *data)
 {
 	struct tdx_module_args args = {};
 	int ret;
@@ -317,7 +318,7 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 
 #include "tdx_global_metadata.c"
 
-static int check_features(struct tdx_sys_info *sysinfo)
+static __init int check_features(struct tdx_sys_info *sysinfo)
 {
 	u64 tdx_features0 = sysinfo->features.tdx_features0;
 
@@ -330,7 +331,7 @@ static int check_features(struct tdx_sys_info *sysinfo)
 }
 
 /* Calculate the actual TDMR size */
-static int tdmr_size_single(u16 max_reserved_per_tdmr)
+static __init int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
 	int tdmr_sz;
 
@@ -344,8 +345,8 @@ static int tdmr_size_single(u16 max_reserved_per_tdmr)
 	return ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
 }
 
-static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
-			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
+static __init int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
+				  struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	size_t tdmr_sz, tdmr_array_sz;
 	void *tdmr_array;
@@ -376,7 +377,7 @@ static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
 	return 0;
 }
 
-static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
+static __init void free_tdmr_list(struct tdmr_info_list *tdmr_list)
 {
 	free_pages_exact(tdmr_list->tdmrs,
 			tdmr_list->max_tdmrs * tdmr_list->tdmr_sz);
@@ -405,8 +406,8 @@ static inline u64 tdmr_end(struct tdmr_info *tdmr)
  * preallocated @tdmr_list, following all the special alignment
  * and size rules for TDMR.
  */
-static int fill_out_tdmrs(struct list_head *tmb_list,
-			  struct tdmr_info_list *tdmr_list)
+static __init int fill_out_tdmrs(struct list_head *tmb_list,
+				 struct tdmr_info_list *tdmr_list)
 {
 	struct tdx_memblock *tmb;
 	int tdmr_idx = 0;
@@ -482,8 +483,8 @@ static int fill_out_tdmrs(struct list_head *tmb_list,
  * Calculate PAMT size given a TDMR and a page size.  The returned
  * PAMT size is always aligned up to 4K page boundary.
  */
-static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
-				      u16 pamt_entry_size)
+static __init unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
+					     u16 pamt_entry_size)
 {
 	unsigned long pamt_sz, nr_pamt_entries;
 
@@ -514,7 +515,7 @@ static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
  * PAMT.  This node will have some memory covered by the TDMR.  The
  * relative amount of memory covered is not considered.
  */
-static int tdmr_get_nid(struct tdmr_info *tdmr, struct list_head *tmb_list)
+static __init int tdmr_get_nid(struct tdmr_info *tdmr, struct list_head *tmb_list)
 {
 	struct tdx_memblock *tmb;
 
@@ -543,9 +544,9 @@ static int tdmr_get_nid(struct tdmr_info *tdmr, struct list_head *tmb_list)
  * Allocate PAMTs from the local NUMA node of some memory in @tmb_list
  * within @tdmr, and set up PAMTs for @tdmr.
  */
-static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
-			    struct list_head *tmb_list,
-			    u16 pamt_entry_size[])
+static __init int tdmr_set_up_pamt(struct tdmr_info *tdmr,
+				   struct list_head *tmb_list,
+				   u16 pamt_entry_size[])
 {
 	unsigned long pamt_base[TDX_PS_NR];
 	unsigned long pamt_size[TDX_PS_NR];
@@ -615,7 +616,7 @@ static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_base,
 	*pamt_size = pamt_sz;
 }
 
-static void tdmr_do_pamt_func(struct tdmr_info *tdmr,
+static __init void tdmr_do_pamt_func(struct tdmr_info *tdmr,
 		void (*pamt_func)(unsigned long base, unsigned long size))
 {
 	unsigned long pamt_base, pamt_size;
@@ -632,17 +633,17 @@ static void tdmr_do_pamt_func(struct tdmr_info *tdmr,
 	pamt_func(pamt_base, pamt_size);
 }
 
-static void free_pamt(unsigned long pamt_base, unsigned long pamt_size)
+static __init  void free_pamt(unsigned long pamt_base, unsigned long pamt_size)
 {
 	free_contig_range(pamt_base >> PAGE_SHIFT, pamt_size >> PAGE_SHIFT);
 }
 
-static void tdmr_free_pamt(struct tdmr_info *tdmr)
+static __init void tdmr_free_pamt(struct tdmr_info *tdmr)
 {
 	tdmr_do_pamt_func(tdmr, free_pamt);
 }
 
-static void tdmrs_free_pamt_all(struct tdmr_info_list *tdmr_list)
+static __init void tdmrs_free_pamt_all(struct tdmr_info_list *tdmr_list)
 {
 	int i;
 
@@ -651,9 +652,9 @@ static void tdmrs_free_pamt_all(struct tdmr_info_list *tdmr_list)
 }
 
 /* Allocate and set up PAMTs for all TDMRs */
-static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
-				 struct list_head *tmb_list,
-				 u16 pamt_entry_size[])
+static __init int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
+					struct list_head *tmb_list,
+					u16 pamt_entry_size[])
 {
 	int i, ret = 0;
 
@@ -702,12 +703,13 @@ void tdx_quirk_reset_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
 
-static void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
+static __init void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
+
 {
 	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
 }
 
-static void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
+static __init void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
 {
 	int i;
 
@@ -715,7 +717,7 @@ static void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
 		tdmr_quirk_reset_pamt(tdmr_entry(tdmr_list, i));
 }
 
-static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
+static __init unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
 {
 	unsigned long pamt_size = 0;
 	int i;
@@ -730,8 +732,8 @@ static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
 	return pamt_size / 1024;
 }
 
-static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
-			      u64 size, u16 max_reserved_per_tdmr)
+static __init int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx,
+				     u64 addr, u64 size, u16 max_reserved_per_tdmr)
 {
 	struct tdmr_reserved_area *rsvd_areas = tdmr->reserved_areas;
 	int idx = *p_idx;
@@ -764,10 +766,10 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
  * those holes fall within @tdmr, set up a TDMR reserved area to cover
  * the hole.
  */
-static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
-				    struct tdmr_info *tdmr,
-				    int *rsvd_idx,
-				    u16 max_reserved_per_tdmr)
+static __init int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
+					   struct tdmr_info *tdmr,
+					   int *rsvd_idx,
+					   u16 max_reserved_per_tdmr)
 {
 	struct tdx_memblock *tmb;
 	u64 prev_end;
@@ -828,10 +830,10 @@ static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
  * overlaps with @tdmr, set up a TDMR reserved area to cover the
  * overlapping part.
  */
-static int tdmr_populate_rsvd_pamts(struct tdmr_info_list *tdmr_list,
-				    struct tdmr_info *tdmr,
-				    int *rsvd_idx,
-				    u16 max_reserved_per_tdmr)
+static __init int tdmr_populate_rsvd_pamts(struct tdmr_info_list *tdmr_list,
+					   struct tdmr_info *tdmr,
+					   int *rsvd_idx,
+					   u16 max_reserved_per_tdmr)
 {
 	int i, ret;
 
@@ -866,7 +868,7 @@ static int tdmr_populate_rsvd_pamts(struct tdmr_info_list *tdmr_list,
 }
 
 /* Compare function called by sort() for TDMR reserved areas */
-static int rsvd_area_cmp_func(const void *a, const void *b)
+static __init int rsvd_area_cmp_func(const void *a, const void *b)
 {
 	struct tdmr_reserved_area *r1 = (struct tdmr_reserved_area *)a;
 	struct tdmr_reserved_area *r2 = (struct tdmr_reserved_area *)b;
@@ -885,10 +887,10 @@ static int rsvd_area_cmp_func(const void *a, const void *b)
  * Populate reserved areas for the given @tdmr, including memory holes
  * (via @tmb_list) and PAMTs (via @tdmr_list).
  */
-static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
-				    struct list_head *tmb_list,
-				    struct tdmr_info_list *tdmr_list,
-				    u16 max_reserved_per_tdmr)
+static __init int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
+					   struct list_head *tmb_list,
+					   struct tdmr_info_list *tdmr_list,
+					   u16 max_reserved_per_tdmr)
 {
 	int ret, rsvd_idx = 0;
 
@@ -913,9 +915,9 @@ static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
  * Populate reserved areas for all TDMRs in @tdmr_list, including memory
  * holes (via @tmb_list) and PAMTs.
  */
-static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
-					 struct list_head *tmb_list,
-					 u16 max_reserved_per_tdmr)
+static __init int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
+						struct list_head *tmb_list,
+						u16 max_reserved_per_tdmr)
 {
 	int i;
 
@@ -936,9 +938,9 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
  * to cover all TDX memory regions in @tmb_list based on the TDX module
  * TDMR global information in @sysinfo_tdmr.
  */
-static int construct_tdmrs(struct list_head *tmb_list,
-			   struct tdmr_info_list *tdmr_list,
-			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
+static __init int construct_tdmrs(struct list_head *tmb_list,
+				  struct tdmr_info_list *tdmr_list,
+				  struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	u16 pamt_entry_size[TDX_PS_NR] = {
 		sysinfo_tdmr->pamt_4k_entry_size,
@@ -970,7 +972,8 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	return ret;
 }
 
-static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
+static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
+				    u64 global_keyid)
 {
 	struct tdx_module_args args = {};
 	u64 *tdmr_pa_array;
@@ -1063,7 +1066,7 @@ static int config_global_keyid(void)
 	return ret;
 }
 
-static int init_tdmr(struct tdmr_info *tdmr)
+static __init int init_tdmr(struct tdmr_info *tdmr)
 {
 	u64 next;
 
@@ -1094,7 +1097,7 @@ static int init_tdmr(struct tdmr_info *tdmr)
 	return 0;
 }
 
-static int init_tdmrs(struct tdmr_info_list *tdmr_list)
+static __init int init_tdmrs(struct tdmr_info_list *tdmr_list)
 {
 	int i;
 
@@ -1113,7 +1116,7 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 	return 0;
 }
 
-static int init_tdx_module(void)
+static __init int init_tdx_module(void)
 {
 	int ret;
 
@@ -1194,7 +1197,7 @@ static int init_tdx_module(void)
 	goto out_put_tdxmem;
 }
 
-static int tdx_enable(void)
+static __init int tdx_enable(void)
 {
 	enum cpuhp_state state;
 	int ret;
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 13ad2663488b..360963bc9328 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -7,7 +7,7 @@
  * Include this file to other C file instead.
  */
 
-static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
+static __init int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
 {
 	int ret = 0;
 	u64 val;
@@ -18,7 +18,7 @@ static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_featu
 	return ret;
 }
 
-static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
+static __init int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	int ret = 0;
 	u64 val;
@@ -37,7 +37,7 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 	return ret;
 }
 
-static int get_tdx_sys_info_td_ctrl(struct tdx_sys_info_td_ctrl *sysinfo_td_ctrl)
+static __init int get_tdx_sys_info_td_ctrl(struct tdx_sys_info_td_ctrl *sysinfo_td_ctrl)
 {
 	int ret = 0;
 	u64 val;
@@ -52,7 +52,7 @@ static int get_tdx_sys_info_td_ctrl(struct tdx_sys_info_td_ctrl *sysinfo_td_ctrl
 	return ret;
 }
 
-static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf)
+static __init int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf)
 {
 	int ret = 0;
 	u64 val;
@@ -85,7 +85,7 @@ static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf
 	return ret;
 }
 
-static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
+static __init int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
 
-- 
2.52.0.223.gf5cc29aaa4-goog


