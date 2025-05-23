Return-Path: <kvm+bounces-47555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80E42AC2057
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFE5F1C03D71
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27E9248F45;
	Fri, 23 May 2025 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vjvbg+YV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A593245008;
	Fri, 23 May 2025 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994041; cv=none; b=mKs8VmmwBKBizOsytnJDPtn/MB8Cwi3chOXh/6DUpuXfL1lOCBvp+0sb6tDBlQD4ZH5RVSOYOKEXQD8UmLH5D+wsZPtKyW75ny2yKOM31H3kkDkoovOLYQ+Ho0+2W3iTTdDG+ieS7jzIsyvKni0vsh0FakKZg+Iu9Y2ZyKsLQqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994041; c=relaxed/simple;
	bh=z0i0/IXCqbcVFjIzw3ueLhZMcxcGtEoHNUIB6t7zan8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqshVlYtuHtKvmVg8uWLm1c8Ls5NJA+vazIemOhzTXAPxa4sTjqxqWqYPyV+Ct+tSzGBPCrxO8UxB31YqwnhgSJKzT1q0YA5qGM3Fdn0wADFJ5U4OwcsOLHRhpDL5j/1Do2XDprYXBA6WPCDvPSDjPFBx8IXAzOlL6CYZC4p99M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vjvbg+YV; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994039; x=1779530039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z0i0/IXCqbcVFjIzw3ueLhZMcxcGtEoHNUIB6t7zan8=;
  b=Vjvbg+YVKoDKYcQbgF2ZfOLMndj9YVmtcB8XO6Mmf8czhlzN5/e3/YUG
   7EbzTMTpH+ojxov3tIK1NhOeoQtdR4ZMXeVImyQTR7Y4rbpsr8fbuoGTj
   fo0xeybSQXnXmgBsz3OZFQyiM8LEkEPmg/N92gnA05ATYgNkS6KRATRO3
   xPdHfd/vFcqIjhL9dQ9NZqPXA0sYO5xSfqGswa8n+BIPoHrIJqvQu3+rE
   X0HKFxVKiOOaj0SWEKfk9BA35WgkSnrcWMz0TKhcxR3PZfe4oGFPRTtHf
   SYk7nB1HAYGSYh1Lw04u03qXI50GL4/wqfADAG5aRx5a/W9+qIKhogjc1
   A==;
X-CSE-ConnectionGUID: xkl3ryjSQRiUX2iDeGcEOQ==
X-CSE-MsgGUID: 8WIWM7+dSLuBX8kpqQ8m1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444268"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444268"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:58 -0700
X-CSE-ConnectionGUID: 9TZeUvwGS6S9vS7yl4WNcg==
X-CSE-MsgGUID: obpdoiXhTq+asbZ9XygFYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315100"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:58 -0700
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
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 20/20] x86/virt/seamldr: Enable TD-Preserving Updates
Date: Fri, 23 May 2025 02:52:43 -0700
Message-ID: <20250523095322.88774-21-chao.gao@intel.com>
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

All necessary steps for TD-Preserving updates have been integrated.
Remove the temporary guard to enable TD-Preserving updates.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index fe8f98701429..c6e40a7418d3 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -350,12 +350,6 @@ static int do_seamldr_install_module(void *params)
 	return ret;
 }
 
-/*
- * Temporary flag to guard TD-Preserving updates. This will be removed once
- * all necessary components for its support are integrated.
- */
-static bool td_preserving_ready;
-
 DEFINE_FREE(free_seamldr_params, struct seamldr_params *,
 	    if (!IS_ERR_OR_NULL(_T)) free_seamldr_params(_T))
 
@@ -365,9 +359,6 @@ static int seamldr_install_module(const u8 *data, u32 size)
 							  GFP_KERNEL);
 	int ret;
 
-	if (!td_preserving_ready)
-		return -EOPNOTSUPP;
-
 	if (!info)
 		return -ENOMEM;
 
-- 
2.47.1


