Return-Path: <kvm+bounces-46299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B7DAB4CA4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE3931B41838
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0044E1F2C58;
	Tue, 13 May 2025 07:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KUL8T9dH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A021B1F1512
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120992; cv=none; b=qfsH0dy1tXuqt0FDxAwpDIZNKQXTDPcFVek14VIYYP5ZIQiGKmw6puNgk3YCeBwr04AQN6DCyvB9Ednhashj+39M34Xw6iSOE+XibvRZiIdCB8xm/9poTJAd3afOvZZXCnPg6x3j4m0c+fhTGz8NPp7pDUENu5B88rBZVuAxNfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120992; c=relaxed/simple;
	bh=0Bhw19vWT2O0ry5WFAhUzWAozzniRVyAhG/VGlC0l2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/WfHSSHSNbkhX2SstdZVd7OY953NTYR12HiEV8DsWKD42zNkysOdzwJ6dGt2Dvk+4O1k1wDM0Mfb+jRv9guStyv0PgD3ut7AFLcGxBhF0AfcWtOweMWjY9lwuEGtGuxYpdJb02e7plUtmMTyLHXsfPpFTiusrxwZ1hE8kBiDEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KUL8T9dH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120991; x=1778656991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Bhw19vWT2O0ry5WFAhUzWAozzniRVyAhG/VGlC0l2w=;
  b=KUL8T9dH3OMLAYlXLZSjAU0hgm2UTPGgA12igcN8z1Wb704mMvKMsRnW
   YxcH23jnqOIHa4iGF7/ydAVD86VD6T0s2a9OfVmbfRWhgUY8R8KlS36mF
   Z5TBx8p4U5VXaJSjZGBhezXtF1IALXBISwIlaDXBse17gbxnU45xVc5Ma
   ylHN4iTlESMDARM4FbK8my8rGZPINVTkAZP99C0OXPhH8TisW2HcLSCtS
   QgfqResBdpozyyNqphfn2qytVpWxvxwp/eRoATEjXPj9+8o52ITydz3Io
   6m7DVtg3GE/jBztWqIg2ljNrBEgwmrP0QtTvzaj9LXYg7Trw0g/W6Tx0Q
   Q==;
X-CSE-ConnectionGUID: eAYcGvseQTiZAGvPJMpz4A==
X-CSE-MsgGUID: EMAF4+pXQ4uzfKr8hmjWWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48941020"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48941020"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: 4SZJjfVpSiGMiY2gGciqiA==
X-CSE-MsgGUID: KMN2ps3nTWq7jKhT/zNvJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740619"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 7/8] x86: cet: Validate writing unaligned values to SSP MSR causes #GP
Date: Tue, 13 May 2025 00:22:49 -0700
Message-ID: <20250513072250.568180-8-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
References: <20250513072250.568180-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate that writing invalid values to SSP MSRs triggers a #GP exception.
This verifies that necessary validity checks are performed by the hardware
or the underlying VMM.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 x86/cet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/cet.c b/x86/cet.c
index 9802e2e6..b32d7de2 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -56,6 +56,7 @@ int main(int ac, char **av)
 	char *shstk_virt;
 	unsigned long shstk_phys;
 	pteval_t pte = 0;
+	u8 vector;
 	bool rvc;
 
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
@@ -103,5 +104,9 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
 
+	/* SSP should be 4-Byte aligned */
+	vector = wrmsr_safe(MSR_IA32_PL3_SSP, 0x1);
+	report(vector == GP_VECTOR, "MSR_IA32_PL3_SSP alignment test.");
+
 	return report_summary();
 }
-- 
2.47.1


