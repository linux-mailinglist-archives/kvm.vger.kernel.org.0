Return-Path: <kvm+bounces-57973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF10B83040
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48D703A9859
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9EBC223311;
	Thu, 18 Sep 2025 05:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BNYezxtk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B2E34BA5E
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 05:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758173580; cv=none; b=M/YhR6BU3Bb0uM0h0w7ZVwj7onC0KBllL2iRBWpoaStdBLHSgIz8uw8BR7AQJ93CI1uEXS6XSMaFwwvlmugtuANZ1gIhozBJPSYQe3YPU/N4Zxteba2CXtQJeEoCsXxc+3h9TO/iea4aK+A0wPNB1Y1sa7NAhKXF8MYv1RUkpVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758173580; c=relaxed/simple;
	bh=QeocKgJGyBBuVU9tGjt5iSCGuAFl47zVnm4JwPq1SuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z4R4YHGjHJnIpwvgOXCBWUOjALkFa5SkRwpJsMLvUUB4LdXZZTR1h3h8iUqvrtYEPhA+xoJ5DlCBqnCDjo5H8ycSK/S2JUz6BWVkN7T1unX6+9Q89LYOJ136QB4M3ZbSK2U2RBcFawxyqadB6iiludykK0e85GzuOyAXHy/Gzfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BNYezxtk; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758173579; x=1789709579;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QeocKgJGyBBuVU9tGjt5iSCGuAFl47zVnm4JwPq1SuM=;
  b=BNYezxtkGdD77gABv01GFesjZ7krOLmJ8XG3vzfCKGJA/4Y9IPCBBeA4
   tK/t6gh/dJQ7lF4GyZME3SpSEHZw6Vb+v1hsZqhCux50o9UcTsX942j/V
   YHst9Vl3tcifS9x5Jus8oHrrvHnvFUnVlxt9Knu+Y6xmmajAHHwEXbrZp
   44cVtCcX9c7HqurTn6uYL53Rt2NKM4oRouvXdWfwXVKQBcph9y5L9vS2p
   zSDyIitfLRDrHe4MfaxcR0UWbejCGT23BWXKGoL8ulBbvVRYcK6qC077q
   TiNoWW5XIptER0isejSoNCsL3hBe4yuIXxY+GjgrNwnrCE8BogPXVxKdd
   w==;
X-CSE-ConnectionGUID: hixPgGt5Q26IJNipOJVHfA==
X-CSE-MsgGUID: /m89A6qnQ+ahoHIHkwOj8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71174439"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="71174439"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:32:58 -0700
X-CSE-ConnectionGUID: cJUXaVz4RJqOjNFMz6fF1w==
X-CSE-MsgGUID: WBoMfSE4R4KHmTzukCHSBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="179849841"
Received: from mjarzebo-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1..) ([10.245.246.174])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:32:54 -0700
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tony Lindgren <tony.lindgren@linux.intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kai Huang <kai.huang@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	kvm@vger.kernel.org
Subject: [PATCH v2 1/1] KVM: TDX: Fix uninitialized error code for __tdx_bringup()
Date: Thu, 18 Sep 2025 08:32:25 +0300
Message-ID: <20250918053226.802204-1-tony.lindgren@linux.intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a Smatch static checker warning reported by Dan:

	arch/x86/kvm/vmx/tdx.c:3464 __tdx_bringup()
	warn: missing error code 'r'

Initialize r to -EINVAL before tdx_get_sysinfo() to simplify the code and
to prevent similar issues from sneaking in later on as suggested by Kai.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 61bb28279623 ("KVM: TDX: Get system-wide info about TDX module on initialization")
Suggested-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---

This can wait for the merge window, not urgent

---
 arch/x86/kvm/vmx/tdx.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ca9c8ec7dd01..66e53a90af94 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3460,12 +3460,11 @@ static int __init __tdx_bringup(void)
 	if (r)
 		goto tdx_bringup_err;
 
+	r = -EINVAL;
 	/* Get TDX global information for later use */
 	tdx_sysinfo = tdx_get_sysinfo();
-	if (WARN_ON_ONCE(!tdx_sysinfo)) {
-		r = -EINVAL;
+	if (WARN_ON_ONCE(!tdx_sysinfo))
 		goto get_sysinfo_err;
-	}
 
 	/* Check TDX module and KVM capabilities */
 	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
@@ -3508,14 +3507,11 @@ static int __init __tdx_bringup(void)
 	if (td_conf->max_vcpus_per_td < num_present_cpus()) {
 		pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
 				td_conf->max_vcpus_per_td, num_present_cpus());
-		r = -EINVAL;
 		goto get_sysinfo_err;
 	}
 
-	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids())) {
-		r = -EINVAL;
+	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
 		goto get_sysinfo_err;
-	}
 
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled
-- 
2.43.0


