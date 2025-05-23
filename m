Return-Path: <kvm+bounces-47536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FB2AC2033
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B1DC1B6433C
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3E3227E95;
	Fri, 23 May 2025 09:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ffVXNUw2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FAD22370F;
	Fri, 23 May 2025 09:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994006; cv=none; b=gGN2wY1Hnd5/giyVT+HKBc/NI5OogO85NtvZ/bBldX9phDOxULeIk99ZuIwd/GiVOUYCG5mH2gdDrmeuIuVxD91c4YjiPAJZUOU1cifFjhC4ewQByuKiUWzHypcKXt657el6uQy5+ID2zH8sxWFCm3jWz2kQHzlZG1eTlkduaR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994006; c=relaxed/simple;
	bh=sOkw1JG9iRLRW+PGBK0WHlQW7LGgtjnpZzL8wyQuJY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ7xPqSjIcY8ItpTOQ9s7LcKCNQCc+MsjmO6SlumOzN4CyGCDMeimYWtt793llTnYMBN9w7DFsEsaYrf4kVaR4kiVeWRkGIRtZN9xApWM4sCZYoLP+TpTMdjVsQej+wAShhiGXMgbgg/UH3HByhOueMnhc5e/48BdXJ+v28luhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ffVXNUw2; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994005; x=1779530005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sOkw1JG9iRLRW+PGBK0WHlQW7LGgtjnpZzL8wyQuJY4=;
  b=ffVXNUw2In4z2PwzVspyM0PZdWzpdHrvxuzVm95DzW7H5b4WQ5EyGO4c
   xOWmzoMHsYAZB6GfazojFbvmbNotbINbdtNotNDxtkPjSCU5XYpX+pNON
   5T91rELA/TwHbYga4H4d1B4FtpzRN2psj0PQxCt8QVGA0hUfdlhaDn6Rv
   LPvOhBK8v6zuCAMRqsjbMGgJk5XwE7p/F1/F8e25vPFUzsZXmscHgbXdb
   DsRGlpsJlqIGNULVT2Mb2LtbAXvlD8FhkvOovontquXFJl8U+xfY36wVP
   rF91wmIDxE4MqyFxQV1EYBy8qDrHomAciiUYbKf91I4luH7ALygNzq+VZ
   Q==;
X-CSE-ConnectionGUID: vaEtmKAyStqXmMRnmO02hA==
X-CSE-MsgGUID: uuQUse4aQh2s7hoimbv8XA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444091"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444091"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:24 -0700
X-CSE-ConnectionGUID: LWnOCfaCS6O6i9s/kN5tgQ==
X-CSE-MsgGUID: DKR8vC3TTPe3/tFWKLB7PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315034"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:23 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/20] x86/virt/tdx: Print SEAMCALL leaf numbers in decimal
Date: Fri, 23 May 2025 02:52:24 -0700
Message-ID: <20250523095322.88774-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both TDX spec and kernel defines SEAMCALL leaf numbers as decimal. Printing
them in hex makes no sense. Correct it.

Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f5e2a937c1e7..49267c865f18 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -62,7 +62,7 @@ typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
 {
-	pr_err("SEAMCALL (0x%016llx) failed: 0x%016llx\n", fn, err);
+	pr_err("SEAMCALL (%lld) failed: 0x%016llx\n", fn, err);
 }
 
 static inline void seamcall_err_ret(u64 fn, u64 err,
-- 
2.47.1


