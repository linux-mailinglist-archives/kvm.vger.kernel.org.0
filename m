Return-Path: <kvm+bounces-72494-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBNKMKRSpmkbOAAAu9opvQ
	(envelope-from <kvm+bounces-72494-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:16:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 676E71E866A
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6598E301DD74
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 03:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF5E37CD41;
	Tue,  3 Mar 2026 03:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l+f334Fa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BB437DE97;
	Tue,  3 Mar 2026 03:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772507807; cv=none; b=iAQbFAy/9lxBRL+QZ0oWWz38uBhW2/+cOj6Aogmqm/Eaqg6gZquSvBbOX0r8PWz4N10nt91W/eTXMqo+zQ9hY4+yf7I0ZmrUS9UrdNujkJezKUvgchW82zFlOZM3GlAWGE6PqDUXW728gCDj/eug/HY8p6ArVD6h9IALUu3IJ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772507807; c=relaxed/simple;
	bh=IbCfjAR1kaOoaqHNjlo/eRgvjaAUGZc5tpaeXhcuHZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jlgv6MHj9Cz5Lz8z/Sdp4hIbF1QAWCB9A2N2k7LhJOJK4PHWbRnZvm6wniwo/MaebRPse52VJyT4Fl6xd0FHBAHCZJvTcEcu7Z0yQbVzRakLYfOg4EweFqP6bQR6S5ILNZTz1lggn73f+9l9600yFNL+fmv8tkCaiXdcFb/y+HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l+f334Fa; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772507805; x=1804043805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IbCfjAR1kaOoaqHNjlo/eRgvjaAUGZc5tpaeXhcuHZM=;
  b=l+f334FalVAcrukkJGLl7KnkPSUG38tuK3o5UdKUGCv6dDL/hosg81bQ
   /KkqEkNAZ2qFiSeitmNVTb9gslCiuv5vBel34aWX6ShVPWBWntbNiz+QV
   wZV9svgoaFk3ACiLCIo2EFAwvMvEg2EDWEvWcJV/9JXvREJrB5eT1EkXA
   pbIaIKjuDSDRIZZz4zHjAjYLMmt33kYUomsz5RjOnCiO/ZMMNn6boYTG0
   VqvCu7kH7exH88AMb5BaQ0Bqsw3M6IfphBI3kS078ekTS+/E8fZ+kh4px
   WF7ssK20shvUPZRkJHDwnlRnFBogNLBR1ynZ5s3dKrSp+VCfaEImuQOUn
   w==;
X-CSE-ConnectionGUID: bveDPfaNRamd/byNBRAA/A==
X-CSE-MsgGUID: qUQlB7twRia1RRRY5LNDIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="83869720"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="83869720"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 19:16:45 -0800
X-CSE-ConnectionGUID: aAWS0l08RTeTYBar/mv2bA==
X-CSE-MsgGUID: DJHPvESqT+uFE1u8TYKvXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="216988903"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa006.jf.intel.com with ESMTP; 02 Mar 2026 19:16:42 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v4 1/4] x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE
Date: Tue,  3 Mar 2026 11:03:32 +0800
Message-ID: <20260303030335.766779-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260303030335.766779-1-xiaoyao.li@intel.com>
References: <20260303030335.766779-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 676E71E866A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72494-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

The TD scoped TDCS attributes are defined by bit positions. In the guest
side of the TDX code, the 'tdx_attributes' string array holds pretty
print names for these attributes, which are generated via macros and
defines. Today these pretty print names are only used to print the
attribute names to dmesg.

Unfortunately there is a typo in the define for the migratable bit.
Change the defines TDX_ATTR_MIGRTABLE* to TDX_ATTR_MIGRATABLE*. Update
the sole user, the tdx_attributes array, to use the fixed name.

Since these defines control the string printed to dmesg, the change is
user visible. But the risk of breakage is almost zero since it is not
exposed in any interface expected to be consumed programmatically.

Fixes: 564ea84c8c14 ("x86/tdx: Dump attributes and TD_CTLS on boot")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
Changes in v3:
 - Use the rewritten changelog from Rick.

Changes in v2:
 - Add the impact of the change in the commit message. (provided by Rick)
---
 arch/x86/coco/tdx/debug.c         | 2 +-
 arch/x86/include/asm/shared/tdx.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/tdx/debug.c b/arch/x86/coco/tdx/debug.c
index cef847c8bb67..28990c2ab0a1 100644
--- a/arch/x86/coco/tdx/debug.c
+++ b/arch/x86/coco/tdx/debug.c
@@ -17,7 +17,7 @@ static __initdata const char *tdx_attributes[] = {
 	DEF_TDX_ATTR_NAME(ICSSD),
 	DEF_TDX_ATTR_NAME(LASS),
 	DEF_TDX_ATTR_NAME(SEPT_VE_DISABLE),
-	DEF_TDX_ATTR_NAME(MIGRTABLE),
+	DEF_TDX_ATTR_NAME(MIGRATABLE),
 	DEF_TDX_ATTR_NAME(PKS),
 	DEF_TDX_ATTR_NAME(KL),
 	DEF_TDX_ATTR_NAME(TPA),
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 8bc074c8d7c6..11f3cf30b1ac 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -35,8 +35,8 @@
 #define TDX_ATTR_LASS			BIT_ULL(TDX_ATTR_LASS_BIT)
 #define TDX_ATTR_SEPT_VE_DISABLE_BIT	28
 #define TDX_ATTR_SEPT_VE_DISABLE	BIT_ULL(TDX_ATTR_SEPT_VE_DISABLE_BIT)
-#define TDX_ATTR_MIGRTABLE_BIT		29
-#define TDX_ATTR_MIGRTABLE		BIT_ULL(TDX_ATTR_MIGRTABLE_BIT)
+#define TDX_ATTR_MIGRATABLE_BIT		29
+#define TDX_ATTR_MIGRATABLE		BIT_ULL(TDX_ATTR_MIGRATABLE_BIT)
 #define TDX_ATTR_PKS_BIT		30
 #define TDX_ATTR_PKS			BIT_ULL(TDX_ATTR_PKS_BIT)
 #define TDX_ATTR_KL_BIT			31
-- 
2.43.0


