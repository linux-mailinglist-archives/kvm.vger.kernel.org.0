Return-Path: <kvm+bounces-71092-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHOxDF7Qj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71092-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:31:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C1AC713AB01
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:31:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 50EC1307B090
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852C02F690F;
	Sat, 14 Feb 2026 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SwyzpkWs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB602D7386
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032454; cv=none; b=EHodXcwzKiJgiicG38z2eBLDZpTN0ed85QLB9uDynn+Nq7hdVpwHlU2GNZCohfbtfXIlOWA1IXE2RACxEo2GbYjh4ryrmcwA0tMSNZgor1a9BXrNoBKzjc1PqoGpSE5+sxTT78csLyzHnzfWUWmYcdssD+wza/NR/W3H4x8WD3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032454; c=relaxed/simple;
	bh=cb13x5z5N8fp2BGhzM0zHZ/gKYs1HHYc4PPu8z7jp18=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZV1FHm2zgIoKWaOml6qql/N4yvScNB5t6TSE9yjtwvOvBPtQB6mpH8im1IzjBvpiY82AZomB6NbxmXanCtKBDdrx4DRydI2GYjz/bauVQ6YMKHp8vwdXhLHGBYoVOCEXuG4LdyD6XjozlyUCBDfiqd+j92PdrpFnJMpBd4YHO8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SwyzpkWs; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aaeafeadbcso16554265ad.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032447; x=1771637247; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1nvsxV5QM155um7A8rKyWUR5yrYtoiVHtXpq9eL/jZk=;
        b=SwyzpkWsQ7SXilYxxH7nT3grwcrHiaYoPLdMr+QQ5z0kTn9d8S7Rg+qZwxqxnQCIZB
         xtg7IrP51jwvzugoOmgqeYZVUywEy2F7O4WrV0aFrQ9gONWGfSFkroGZvQtzGfxZujYN
         rV1CvOkUXsnS9RaHVVmzRHzQPqOYv2xX7+BNxz3PSuZ09XEskpHCbl3ayTyZdcKSnZwV
         lZk5sgCXCCfMLsgew/LX5zkgHG4haAoXvVTUwBm7DQfXiw7l6KBJnxc/th136aWkrqmm
         41iRiL/Fm8YLT3XZGjCclnXTOJJJi3Exkyw896y682oRbbrKNgIGAkPgRhMxNDVjTgeD
         YBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032447; x=1771637247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1nvsxV5QM155um7A8rKyWUR5yrYtoiVHtXpq9eL/jZk=;
        b=b68A0fqcEux2UMI91ZrNV0sMvb3ueuYp23kq+Zj3QzMe9y5EV9MFmNr/D63dP6oMI9
         wxT20i8HSHB5W7rPxBbFlLYY/Oakv8DBGM6qGaDdjlmi08DoRhSqqAq3gtoeXhHTqAC2
         mT1XT2LULDnETVzPcHFnIYUue5pWvG8Hh1YCj3GH6kkt/8izsfYoxJOFiwZISqOvyw31
         M6/qcvaUm3bohPTgX103+VWYi1xjZFfyhblQTsDlyqOOR6VA8MBtut41dc0Bf5VtzjE/
         jAZWI4A9Mekq1vcUJRAgJj6mzEVgq/LdFv+zcTS+eOOHRonaUAuyCgGewBejBNvBXghV
         2gLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbDPatILlb9HbVt8ZHfasjMgWdXKPO25Q7747QNOQGT9zscrFyOGYHitteQOnfll+4e/A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKBy9SyILz2o/WXPqQujavDc6pFEsf7nEr4UIhceODrLzi8rBZ
	PORXDsUia0YHieg7P7E/FooNogfMLHBGEO1T5doCnLKCDQzJOPWBVy9lyRffmPZzo365YrVXf/F
	rT5+sCQ==
X-Received: from plil7.prod.google.com ([2002:a17:903:17c7:b0:2a7:6eb5:7e30])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d488:b0:2aa:daf7:84f6
 with SMTP id d9443c01a7336-2ab50627b36mr35501185ad.55.1771032447053; Fri, 13
 Feb 2026 17:27:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:58 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-13-seanjc@google.com>
Subject: [PATCH v3 12/16] x86/virt/tdx: Tag a pile of functions as __init, and
 globals as __ro_after_init
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71092-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: C1AC713AB01
X-Rspamd-Action: no action

Now that TDX-Module initialization is done during subsys init, tag all
related functions as __init, and relevant data as __ro_after_init.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/virt/vmx/tdx/tdx.c                 | 119 ++++++++++----------
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  10 +-
 2 files changed, 66 insertions(+), 63 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index feea8dd6920d..05d634caa4e8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -56,8 +56,8 @@ static struct tdmr_info_list tdx_tdmr_list;
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
-static struct tdx_sys_info tdx_sysinfo;
-static bool tdx_module_initialized;
+static struct tdx_sys_info tdx_sysinfo __ro_after_init;
+static bool tdx_module_initialized __ro_after_init;
 
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
@@ -229,8 +229,9 @@ static struct syscore tdx_syscore = {
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
 
@@ -248,7 +249,7 @@ static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
 	return 0;
 }
 
-static void free_tdx_memlist(struct list_head *tmb_list)
+static __init void free_tdx_memlist(struct list_head *tmb_list)
 {
 	/* @tmb_list is protected by mem_hotplug_lock */
 	while (!list_empty(tmb_list)) {
@@ -266,7 +267,7 @@ static void free_tdx_memlist(struct list_head *tmb_list)
  * ranges off in a secondary structure because memblock is modified
  * in memory hotplug while TDX memory regions are fixed.
  */
-static int build_tdx_memlist(struct list_head *tmb_list)
+static __init int build_tdx_memlist(struct list_head *tmb_list)
 {
 	unsigned long start_pfn, end_pfn;
 	int i, nid, ret;
@@ -298,7 +299,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
 	return ret;
 }
 
-static int read_sys_metadata_field(u64 field_id, u64 *data)
+static __init int read_sys_metadata_field(u64 field_id, u64 *data)
 {
 	struct tdx_module_args args = {};
 	int ret;
@@ -320,7 +321,7 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 
 #include "tdx_global_metadata.c"
 
-static int check_features(struct tdx_sys_info *sysinfo)
+static __init int check_features(struct tdx_sys_info *sysinfo)
 {
 	u64 tdx_features0 = sysinfo->features.tdx_features0;
 
@@ -333,7 +334,7 @@ static int check_features(struct tdx_sys_info *sysinfo)
 }
 
 /* Calculate the actual TDMR size */
-static int tdmr_size_single(u16 max_reserved_per_tdmr)
+static __init int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
 	int tdmr_sz;
 
@@ -347,8 +348,8 @@ static int tdmr_size_single(u16 max_reserved_per_tdmr)
 	return ALIGN(tdmr_sz, TDMR_INFO_ALIGNMENT);
 }
 
-static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
-			   struct tdx_sys_info_tdmr *sysinfo_tdmr)
+static __init int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
+				  struct tdx_sys_info_tdmr *sysinfo_tdmr)
 {
 	size_t tdmr_sz, tdmr_array_sz;
 	void *tdmr_array;
@@ -379,7 +380,7 @@ static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
 	return 0;
 }
 
-static void free_tdmr_list(struct tdmr_info_list *tdmr_list)
+static __init void free_tdmr_list(struct tdmr_info_list *tdmr_list)
 {
 	free_pages_exact(tdmr_list->tdmrs,
 			tdmr_list->max_tdmrs * tdmr_list->tdmr_sz);
@@ -408,8 +409,8 @@ static inline u64 tdmr_end(struct tdmr_info *tdmr)
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
@@ -485,8 +486,8 @@ static int fill_out_tdmrs(struct list_head *tmb_list,
  * Calculate PAMT size given a TDMR and a page size.  The returned
  * PAMT size is always aligned up to 4K page boundary.
  */
-static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
-				      u16 pamt_entry_size)
+static __init unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
+					     u16 pamt_entry_size)
 {
 	unsigned long pamt_sz, nr_pamt_entries;
 
@@ -517,7 +518,7 @@ static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
  * PAMT.  This node will have some memory covered by the TDMR.  The
  * relative amount of memory covered is not considered.
  */
-static int tdmr_get_nid(struct tdmr_info *tdmr, struct list_head *tmb_list)
+static __init int tdmr_get_nid(struct tdmr_info *tdmr, struct list_head *tmb_list)
 {
 	struct tdx_memblock *tmb;
 
@@ -546,9 +547,9 @@ static int tdmr_get_nid(struct tdmr_info *tdmr, struct list_head *tmb_list)
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
@@ -618,7 +619,7 @@ static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_base,
 	*pamt_size = pamt_sz;
 }
 
-static void tdmr_do_pamt_func(struct tdmr_info *tdmr,
+static __init void tdmr_do_pamt_func(struct tdmr_info *tdmr,
 		void (*pamt_func)(unsigned long base, unsigned long size))
 {
 	unsigned long pamt_base, pamt_size;
@@ -635,17 +636,17 @@ static void tdmr_do_pamt_func(struct tdmr_info *tdmr,
 	pamt_func(pamt_base, pamt_size);
 }
 
-static void free_pamt(unsigned long pamt_base, unsigned long pamt_size)
+static __init void free_pamt(unsigned long pamt_base, unsigned long pamt_size)
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
 
@@ -654,9 +655,9 @@ static void tdmrs_free_pamt_all(struct tdmr_info_list *tdmr_list)
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
 
@@ -705,12 +706,13 @@ void tdx_quirk_reset_page(struct page *page)
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_quirk_reset_page);
 
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
 
@@ -718,7 +720,7 @@ static void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
 		tdmr_quirk_reset_pamt(tdmr_entry(tdmr_list, i));
 }
 
-static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
+static __init unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
 {
 	unsigned long pamt_size = 0;
 	int i;
@@ -733,8 +735,8 @@ static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
 	return pamt_size / 1024;
 }
 
-static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
-			      u64 size, u16 max_reserved_per_tdmr)
+static __init int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx,
+				     u64 addr, u64 size, u16 max_reserved_per_tdmr)
 {
 	struct tdmr_reserved_area *rsvd_areas = tdmr->reserved_areas;
 	int idx = *p_idx;
@@ -767,10 +769,10 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
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
@@ -831,10 +833,10 @@ static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
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
 
@@ -869,7 +871,7 @@ static int tdmr_populate_rsvd_pamts(struct tdmr_info_list *tdmr_list,
 }
 
 /* Compare function called by sort() for TDMR reserved areas */
-static int rsvd_area_cmp_func(const void *a, const void *b)
+static __init int rsvd_area_cmp_func(const void *a, const void *b)
 {
 	struct tdmr_reserved_area *r1 = (struct tdmr_reserved_area *)a;
 	struct tdmr_reserved_area *r2 = (struct tdmr_reserved_area *)b;
@@ -888,10 +890,10 @@ static int rsvd_area_cmp_func(const void *a, const void *b)
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
 
@@ -916,9 +918,9 @@ static int tdmr_populate_rsvd_areas(struct tdmr_info *tdmr,
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
 
@@ -939,9 +941,9 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
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
@@ -973,7 +975,8 @@ static int construct_tdmrs(struct list_head *tmb_list,
 	return ret;
 }
 
-static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
+static __init int config_tdx_module(struct tdmr_info_list *tdmr_list,
+				    u64 global_keyid)
 {
 	struct tdx_module_args args = {};
 	u64 *tdmr_pa_array;
@@ -1008,7 +1011,7 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 	return ret;
 }
 
-static int do_global_key_config(void *unused)
+static __init int do_global_key_config(void *unused)
 {
 	struct tdx_module_args args = {};
 
@@ -1026,7 +1029,7 @@ static int do_global_key_config(void *unused)
  * KVM) can ensure success by ensuring sufficient CPUs are online and
  * can run SEAMCALLs.
  */
-static int config_global_keyid(void)
+static __init int config_global_keyid(void)
 {
 	cpumask_var_t packages;
 	int cpu, ret = -EINVAL;
@@ -1066,7 +1069,7 @@ static int config_global_keyid(void)
 	return ret;
 }
 
-static int init_tdmr(struct tdmr_info *tdmr)
+static __init int init_tdmr(struct tdmr_info *tdmr)
 {
 	u64 next;
 
@@ -1097,7 +1100,7 @@ static int init_tdmr(struct tdmr_info *tdmr)
 	return 0;
 }
 
-static int init_tdmrs(struct tdmr_info_list *tdmr_list)
+static __init int init_tdmrs(struct tdmr_info_list *tdmr_list)
 {
 	int i;
 
@@ -1116,7 +1119,7 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 	return 0;
 }
 
-static int init_tdx_module(void)
+static __init int init_tdx_module(void)
 {
 	int ret;
 
@@ -1197,7 +1200,7 @@ static int init_tdx_module(void)
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
2.53.0.310.g728cabbaf7-goog


