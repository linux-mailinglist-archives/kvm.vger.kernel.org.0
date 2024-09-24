Return-Path: <kvm+bounces-27361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B3598448B
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C8B71F25158
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E421A76C6;
	Tue, 24 Sep 2024 11:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jbKBdh8P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C241A76AB;
	Tue, 24 Sep 2024 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177365; cv=none; b=BxjBjEsQ4Xt2xojuuxDVe6yr3P2m5M9CSzga0HJcNHndfaSli66AEb8OsqhwH+GdL+5CpUUAIw7A6nhI8TKkzGuVHIutaCgTtw9N9Uw5rLbCPpimMtUjTHRnmlvBM1Lgueyr/tofB8fFhG08Vkr/zxLDEd5W/N+3Nd/MB0+nzqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177365; c=relaxed/simple;
	bh=GIjj/fxfNYlKIQZ5lN1ifW+maPZJeHuzboN+LWDwryA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCFjpTp4tesvKOjDTuk/qrSSisSzPPMnxAafA7ZSbo//hqcn+hQvWeEAuBMiWKOWxjhkHMkk82UNgPmFQDrnTXhpSbZjDgebQWDEaNpwR7JSFyyCF74YRseKa8aQUU5r4Prao7vrvA4lfMaZANY8i+u/wZY6NfEerLKte9INxno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jbKBdh8P; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727177364; x=1758713364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIjj/fxfNYlKIQZ5lN1ifW+maPZJeHuzboN+LWDwryA=;
  b=jbKBdh8PYPKgwYsAqpqsFjCqPu9Aovs4elzL3FXW9ljevKOc7XC+l+YV
   FGmn+2giz87xB0exYzs1i10WOhEEt4eYoGqvo1laTH0h9bjD9h4zRX31g
   SQ6j5sIJijqk3NIYPdexzXzob7FAn5z4U0s27HxXDLoZpA4Rj8KWNU7aw
   D/ktzTG8meYpFCZLUfFXRn18jeKABR5ESzvZtqx+DFFl3nUK8wHlDPxWn
   Fiq3fqSv/gD0dL2J9uZ9QdCu03vD7QIUY5S4PH094RWZ9S/RnxRq+qztU
   LWvBtemEs9jggnznLyf4np4Bup0sn3ausv0MB69LK6emNwpfA6S3oHq+t
   A==;
X-CSE-ConnectionGUID: bMku6jNuRbC0RZkQuYVumg==
X-CSE-MsgGUID: z9WdFSzfSQml+/0ITjEbOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="43686514"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="43686514"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:24 -0700
X-CSE-ConnectionGUID: xJi3CIogSFyz3CaVaccJTw==
X-CSE-MsgGUID: BRQWsiMgRFigNM83iHQUoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="70994615"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.10])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:29:20 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v4 4/8] x86/virt/tdx: Refine a comment to reflect the latest TDX spec
Date: Tue, 24 Sep 2024 23:28:31 +1200
Message-ID: <3b9e111c2cc6ba9413f3e462448bea94947f7f01.1727173372.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1727173372.git.kai.huang@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old versions of "Intel TDX Module v1.5 ABI Specification" contain
the definitions of all global metadata field IDs directly in a table.

However, the latest spec moves those definitions to a dedicated
'global_metadata.json' file as part of a new (separate) "Intel TDX
Module v1.5 ABI definitions" [1].

Update the comment to reflect this.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/795381

Reported-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
---
 arch/x86/virt/vmx/tdx/tdx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 148f9b4d1140..38f8656162e3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -29,7 +29,7 @@
 /*
  * Global scope metadata field ID.
  *
- * See Table "Global Scope Metadata", TDX module 1.5 ABI spec.
+ * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
  */
 #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
 #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
-- 
2.46.0


