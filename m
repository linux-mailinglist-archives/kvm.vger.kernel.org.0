Return-Path: <kvm+bounces-29842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D3E9B3096
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:43:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44D261F22239
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ABFB1DD865;
	Mon, 28 Oct 2024 12:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WTDpBQ/5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614B51DAC9B;
	Mon, 28 Oct 2024 12:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119308; cv=none; b=SI3Cpfx5EBvpvwmRR29f9meaU9+NhK952bBr297UiaoGJxIygv+Xh37C/1r7rfMi9eefIQ4Omrf0EFBO1KTwPFVRiXUPmS4EDGFhDxHjFW9dFMStwOicOULrhzB1m5LSahgcfZm4NePUp7lkOcaeDw8J9OlFDWInlZNvYVChd9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119308; c=relaxed/simple;
	bh=4ONvF2I7OrjaYkXyRNDV3GuLYBaHROdWabfoSR9X7lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw8cXv8NyHp6jBWT0957AYL1AnxRr3AjIkRAoogodqFjRA1wwuwwkQPu5fP9Sj7+SqsOgabHRrLgGsGZQQ4vcVrIxI9QNpYUQ0JZaSSwsbd3NcnyWDjEcfDHHRWh5XBBRr+Pf0CEkCsKZv+Y1n8l1X/BqvBa4fUdoujcLjcKSag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WTDpBQ/5; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119306; x=1761655306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4ONvF2I7OrjaYkXyRNDV3GuLYBaHROdWabfoSR9X7lI=;
  b=WTDpBQ/5GNwOkKI11mbuB452pY8ArzIwnrwUzvGwf8n+oGM3SI1LzaXG
   dQaeZVA0fSM8WTrw/hbZezWFMq9PxLuo0JIfEAehv6fJpjEBB8W+3bo/I
   83t2YgQQFDnuWxHp3jCBKz8CjFx3TAgMcKzzpTD6kUSC4RL/gc86NELbo
   xCsO/hw9BG5C26yxHa68MGPB5OZiLE2kc4BF3bKcCVcAQaQhiVIv11+Cc
   oLzphv95xm6vyBmuYW3kdNVU0QoO09Et9KOqsDCz7qt/Dh8IyPs4s0Vba
   Z5r6guackC2PcarLJh2JR2//N7YzRLVkIv8qMA+QiG6vpVq5RTtHXZD84
   w==;
X-CSE-ConnectionGUID: hexqLRDDTcO6Z24U6hnW7g==
X-CSE-MsgGUID: Rh7yY9a8T8emJETM0Gie9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575283"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575283"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:46 -0700
X-CSE-ConnectionGUID: YYi/k7GeQ+OqpL4Hyvz6yA==
X-CSE-MsgGUID: NhmYR+1pQrCeH/UFZxcYXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420919"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:42 -0700
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
Subject: [PATCH v6 05/10] x86/virt/tdx: Add missing header file inclusion to local tdx.h
Date: Tue, 29 Oct 2024 01:41:07 +1300
Message-ID: <3f268f096b7427ffbf39358d8559d884c85bec88.1730118186.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compiler attributes __packed and __aligned, and DECLARE_FLEX_ARRAY() are
currently used in arch/x86/virt/vmx/tdx/tdx.h, but the relevant headers
are not included explicitly.

There's no build issue in the current code since this "tdx.h" is only
included by arch/x86/virt/vmx/tdx/tdx.c and it includes bunch of other
<linux/xxx.h> before including "tdx.h".  But for the better explicitly
include the relevant headers to "tdx.h".  Also include <linux/types.h>
for basic variable types like u16.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index ec879d54eb5c..b1d705c3ab2a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -2,6 +2,9 @@
 #ifndef _X86_VIRT_TDX_H
 #define _X86_VIRT_TDX_H
 
+#include <linux/types.h>
+#include <linux/compiler_attributes.h>
+#include <linux/stddef.h>
 #include <linux/bits.h>
 
 /*
-- 
2.46.2


