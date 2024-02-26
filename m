Return-Path: <kvm+bounces-9626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B62866C32
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3634283FC2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E364F21106;
	Mon, 26 Feb 2024 08:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KIqmk+t0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB65A1EB2F;
	Mon, 26 Feb 2024 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936058; cv=none; b=fP4Q+C1/35TZw9WkK2RD4byUsovURWrhXXY85z0qANhqWPVAaTuQoODT0nU8apMujA8GdF1wesx50yj8fT+ZYrNFYZuFlIAor6TXciVoB2useCFj7GRoz5AjbOj9jUxkl684DLp1eI5cX1mcsbReuynPe6h0rjt3YHIlx/OI0aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936058; c=relaxed/simple;
	bh=0J/36UWM7sYbzkdjbiDRhB/xvJEm5o7DRTxpZXmcMqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MFsxZSLcfUOf1j1mNkzKxx6KmpvDyU892xHad/gzX/gNbiib7alEt/Mcik31xknpxjF4bMBtCJd90dHn5M+myFDc2BGbF7YC1SYk0yNHP28bytg5iA92MkXX0HSOq3/a5Vzh4HCGGxMBtpv9iRO+BsSTt8kY1kSIKNj79Y2LfG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KIqmk+t0; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936057; x=1740472057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0J/36UWM7sYbzkdjbiDRhB/xvJEm5o7DRTxpZXmcMqs=;
  b=KIqmk+t0TW7TD3wjNXBD4A2qWIPN5CTtTAPGGlMag+/aTqey57vd274L
   HOMlcwdA3jDk6aLmNuuxx79VmD7TR9fDth0SEwAiXIjS48OfCoNLpaOFA
   g68RUnf6YmQGfeNFXGRBjvfu8Yw3C1kwEUoDHcv6r1Ob6GpZ+2JkiPI1K
   rBzWxTAsonK8HMwk7xe7SjLRSQD65vr75UJDicPWO6AT4qFgBHVmmMIaA
   t+w5gW746SNCi0sn1YUFa+tsw4FPqX0xo5cbgkanmy3N7Lc7jjIcG0urs
   rZKb8nQCzJgLvtKwyLEFQesREONB2WHTcVUWnsU/NgdVuuKxA+kFifirM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3340698"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3340698"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="7020045"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:34 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 002/130] x86/virt/tdx: Move TDMR metadata fields map table to local variable
Date: Mon, 26 Feb 2024 00:25:04 -0800
Message-Id: <44d9530187b4b0b1c05e150fa73fe22ab54fc911.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

The kernel reads all TDMR related global metadata fields based on a
table which maps the metadata fields to the corresponding members of
'struct tdx_tdmr_sysinfo'.  Currently this table is a static variable.

But this table is only used by the function which reads these metadata
fields and becomes useless after reading is done.  Change the table
to function local variable.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2aee64d2f27f..cdcb3332bc5d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -301,17 +301,16 @@ struct field_mapping {
 	{ .field_id = MD_FIELD_ID_##_field_id,	   \
 	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
 
-/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
-static const struct field_mapping fields[] = {
-	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
-	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
-};
-
 static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 {
+	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
+	const struct field_mapping fields[] = {
+		TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
+		TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
+		TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
+		TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
+		TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
+	};
 	int ret;
 	int i;
 
-- 
2.25.1


