Return-Path: <kvm+bounces-25129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DCF9602D4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9807282ABF
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C50A19D88C;
	Tue, 27 Aug 2024 07:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bVQHjwgj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14CB15687C;
	Tue, 27 Aug 2024 07:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742921; cv=none; b=iegM1oWZHlDysH2XXz72Dd7F3QJLwY5OQ3Xfly16HQswObIhXQpAvtWpi9+Wa0x25QU3JuVqPwtD2KRrmSIiQQ44F5fsd/jX71QWW7/eME49d9DvcFpFd9ukDb/9YKwZYtCNHZo1QAbpSdd03UDHAJwn0yZRfdmFVVGEKPd18Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742921; c=relaxed/simple;
	bh=grormjxrxQ/kWgqfapiq6pNWiEMjNqpZCDAi+voZbC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmnHZWr7+47JemDb2ma38nMHPMpxdLPas+qLuCAWJ1J3Jw/z+Y8qAQbCZOvloeB64MGDw/YtT/2v+n5LByn2etEWXSeR4vLl0u+S7S33TbYzG0nblSJArbb/f6UKbzhqd4zbbqopEES25M4cfC046nhR3tu98+oGpTq+Lstqb30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bVQHjwgj; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724742920; x=1756278920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=grormjxrxQ/kWgqfapiq6pNWiEMjNqpZCDAi+voZbC4=;
  b=bVQHjwgjYNe7N1d/eUdcdKdCxSyp5tg/StknH1AkHfD7z2ObEKNrP7zi
   PTHK1yQ76QjwaYN4Jvy1Cp5lyHW3KjTDObbYvijrh5bZhlkl5262qQCBM
   nwY3bKEbB5SaeuAzRN41FUk9e5LRFvXSipmeBLU9OY6hCRWSqh8vu/qaO
   j3RKOXlC5KkKzedFElr49SnALIUxGXPK7q4YwqEqXGR96xNy8v0JWf+AN
   dwCbINV5mhP5UvNoPYcsjFviY0Uej4Yi/4PiCCXWeYbxr6yN1f2pIQCrl
   FTv8Wcf0ftW+AgBUA04X7Z8VsnCKXdBksyWvMEdxg/k0LyAtuyEdqPmT9
   g==;
X-CSE-ConnectionGUID: tF2mLAAeTDWxembAzSIMug==
X-CSE-MsgGUID: 0Nl5E4wsQb2cowXmQ0X28Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34575903"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="34575903"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:15:20 -0700
X-CSE-ConnectionGUID: j/0yQ4QDTRe6nBXYDMOnvg==
X-CSE-MsgGUID: iCLrDHamRC2ausFN7qh3VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="63092623"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:15:16 -0700
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
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	adrian.hunter@intel.com,
	kai.huang@intel.com
Subject: [PATCH v3 8/8] x86/virt/tdx: Don't initialize module that doesn't support NO_RBP_MOD feature
Date: Tue, 27 Aug 2024 19:14:30 +1200
Message-ID: <0996e2f1b3e5c72150708b10bff57ad726c69e4b.1724741926.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1724741926.git.kai.huang@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
RBP is used as frame pointer in the x86_64 calling convention, and
clobbering RBP could result in bad things like being unable to unwind
the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
gap.

A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
metadata field via bit 18.

Don't initialize the TDX module if this feature is not supported [1].

Link: https://lore.kernel.org/all/c0067319-2653-4cbd-8fee-1ccf21b1e646@suse.com/T/#mef98469c51e2382ead2c537ea189752360bd2bef [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
---

v2 -> v3:
 - check_module_compatibility() -> check_features().
 - Improve error message.

 https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#md9e2eeef927838cbf20d7b361cdbea518b8aec50

---
 arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fa335ab1ae92..032a53ddf5bc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -454,6 +454,18 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 }
 
+static int check_features(struct tdx_sys_info *sysinfo)
+{
+	u64 tdx_features0 = sysinfo->features.tdx_features0;
+
+	if (!(tdx_features0 & TDX_FEATURES0_NO_RBP_MOD)) {
+		pr_err("frame pointer (RBP) clobber bug present, upgrade TDX module\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1235,6 +1247,11 @@ static int init_tdx_module(void)
 
 	print_basic_sys_info(&sysinfo);
 
+	/* Check whether the kernel can support this module */
+	ret = check_features(&sysinfo);
+	if (ret)
+		return ret;
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index e7bed9e717c7..831361e6d0fb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -154,6 +154,9 @@ struct tdx_sys_info_features {
 	u64 tdx_features0;
 };
 
+/* Architectural bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_NO_RBP_MOD	_BITULL(18)
+
 /* Class "TDX Module Version" */
 struct tdx_sys_info_version {
 	u16 major;
-- 
2.46.0


