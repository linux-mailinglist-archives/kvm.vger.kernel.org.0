Return-Path: <kvm+bounces-25125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 904459602CB
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49DB4282C1E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E71219754D;
	Tue, 27 Aug 2024 07:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kuhvFa7l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00259193433;
	Tue, 27 Aug 2024 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724742903; cv=none; b=m08jSuygO3UwhZvvOBDxFDVYLTxZIbUzDOqzI7PErFUY33J9pMcoKVKE5Jabpzc0SyT3tKeEneUsr8ecHLnFuSso9DTLS/FQt58cYGFe+sAJVgVIcJqJvlZXxBgYh+Q6f+cneC5/h+Gw1qtA69jG3KI8X+OBvHp+/uAu8fA2a/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724742903; c=relaxed/simple;
	bh=iOwhyk6CLSQyjuOGqBrDGkGAiGKSAVxya3654+z3ijk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNK1PvAcAplsLqVAJA6GyO8jSQ1OZwUSdtqr/ETkyQ3nGrfKIaV9wB+8rz1DGYBhZJKgPigXkBKaJL4AgsZS/dxsm5P/yYGc8m0/IKQ20TDvty1ieYEUvgVBWF/flnvji+S6YscMFAskGTUf3LqMKOkDBUtyOJlQt9MXV4xwXSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kuhvFa7l; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724742902; x=1756278902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iOwhyk6CLSQyjuOGqBrDGkGAiGKSAVxya3654+z3ijk=;
  b=kuhvFa7leEBch9kkxIn4VcUCOBIua3uaGRpdxqa0YfLWpw/sPuXH/25b
   bfAfPsTrK0fhJbxihiTLM+cHDZ3QIK9Xk/uatlTpY0y+PrRRODH3DNHWi
   CY19Hb7YVbyp5G9Zi4F21uJVHRLOmbcmrAnA+0UURF3pAKPzsGlRXe9ay
   5WH8xHwSDjNL0TzJb+8D4VFe9kmVv68IJYEPWKgfF1CB7umOAalymnFOe
   VzMqqWW8MJxBcAOEc738tTVSl9DCW5tC3pnFla7xJKuSxkHRTDYoyfsOs
   Vu6psqwwUk9WHG8Yu362udrCgcdjAattZ0Su7RG/MnW8fomjQ72jrSWo4
   A==;
X-CSE-ConnectionGUID: 9fDw87EwRaqPO8va65SsYQ==
X-CSE-MsgGUID: +5jcyY/+Tz+nIdKM7sbWaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="34575865"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="34575865"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:15:02 -0700
X-CSE-ConnectionGUID: tU0Zo3MbTIiCeJ3bX2bJqA==
X-CSE-MsgGUID: kWMwzKxAQkK5DzDJE2Ypng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="63092571"
Received: from apaszkie-mobl2.apaszkie-mobl2 (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:14:57 -0700
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
Subject: [PATCH v3 4/8] x86/virt/tdx: Refine a comment to reflect the latest TDX spec
Date: Tue, 27 Aug 2024 19:14:26 +1200
Message-ID: <88b2198138d89a9d5dc89b42efaed9ae669ae1c0.1724741926.git.kai.huang@intel.com>
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

The old versions of "Intel TDX Module v1.5 ABI Specification" contain
the definitions of all global metadata field IDs directly in a table.

However, the latest spec moves those definitions to a dedicated
'global_metadata.json' file as part of a new (separate) "Intel TDX
Module v1.5 ABI definitions" [1].

Update the comment to reflect this.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/795381

Reported-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 7458f6717873..8aabd03d8bf5 100644
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


