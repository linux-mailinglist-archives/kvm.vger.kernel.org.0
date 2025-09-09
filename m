Return-Path: <kvm+bounces-57094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A73B4AA3D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FEC63AF1D9
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2530531C561;
	Tue,  9 Sep 2025 10:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cy6sX8D9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8407D274B35
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 10:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757413024; cv=none; b=nWt1kmdOpt6U1cWVLEoGHRzphebLnvVasRynXbvaqyoTtSiU1diTG6UiZDEIEqRtosEsFVxionpJ7wy+1MnV9YKEE9MEyYO5RT4sSkAPUXsPstT956peYh+gKGkiawKlHtvd9bIQ00rfzkXTMkgAR8xF3+VSYUip505e8kAAf9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757413024; c=relaxed/simple;
	bh=xebUbArEPv6rpNtcsLYMTBp+hhHQQgcxtQ8B+tQArq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DB3TDyNOnfigYSJO+1jSbx0hz5AEFKAsk4RBXMt1tp69gQXoYY4m6T2PDGCvZp+AxmOfooeV4xsUgjFSh0yHcOg1my1kZudYy4iSfVo5A+FiB+d2bJEK4TY2EOC1r6hiD7F2FKI5o1Hf5je6+YHlcxd6yWVba+k2xBfVrrpjffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cy6sX8D9; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757413022; x=1788949022;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xebUbArEPv6rpNtcsLYMTBp+hhHQQgcxtQ8B+tQArq0=;
  b=Cy6sX8D9Hg6xIv2nfbpaGamclhmec2Dw2hPBCCeFbAAHB3MjmwOAoUg4
   eT1e60hAewETcAi2ZnhKWBh40ur/HTE9yST6O023dJZvuFLOHzxSLRxFE
   ckXQQjTgat9bznDWIHtby2pmM1MxvaZXqC9LF3TThhiNXwvnOhoE84Sm8
   5qx4piYYPjisVx3SZUH+Y4yMB2QSZKMnKNfIHvFvWjIOXLZMG34qVYAYw
   OEgbz3M8fUmScM0/E1PDOjizU6TZChOG5fx0l9NviWgR+hxekvmobwwnx
   8K81efhr6rYFsTf7Vb7Kxiodt3T7Yk8df429CVWR3YAwcMb8jpQ6HpEhm
   A==;
X-CSE-ConnectionGUID: Rb72XlHsQviuSg25FiTqqQ==
X-CSE-MsgGUID: FSDc/UZuSHOBxvKagywjBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="47266293"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="47266293"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 03:17:02 -0700
X-CSE-ConnectionGUID: XlYCLIv9QRepcNEmFZViNw==
X-CSE-MsgGUID: 7fzRreM1Th6Pp4xgpmPwug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="173839658"
Received: from carterle-desk.ger.corp.intel.com (HELO tlindgre-MOBL1..) ([10.245.246.29])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 03:16:58 -0700
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Tony Lindgren <tony.lindgren@linux.intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	kvm@vger.kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 1/1] KVM: TDX: Fix uninitialized error code for __tdx_bringup()
Date: Tue,  9 Sep 2025 13:16:38 +0300
Message-ID: <20250909101638.170135-1-tony.lindgren@linux.intel.com>
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

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes:  61bb28279623 ("KVM: TDX: Get system-wide info about TDX module on initialization")
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..3ce7fe08afd8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3466,11 +3466,15 @@ static int __init __tdx_bringup(void)
 
 	/* Check TDX module and KVM capabilities */
 	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
-	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
+	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf)) {
+		r = -EINVAL;
 		goto get_sysinfo_err;
+	}
 
-	if (!(tdx_sysinfo->features.tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM))
+	if (!(tdx_sysinfo->features.tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM)) {
+		r = -EINVAL;
 		goto get_sysinfo_err;
+	}
 
 	/*
 	 * TDX has its own limit of maximum vCPUs it can support for all
-- 
2.43.0


