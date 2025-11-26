Return-Path: <kvm+bounces-64767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C765C8C2E2
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4103C3A7D2C
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907E72E7F14;
	Wed, 26 Nov 2025 22:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OdErRotb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149571E9B35;
	Wed, 26 Nov 2025 22:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195419; cv=none; b=gUiMbeE6jB5PUwJ7iJ0R/Yc3YCYcyYe9H14sqe+aWTpSVXiINwiH/1oZ9Rbox/iARcHaXuIarDK3ayBL5Z46DZrmYxyNBUdMKE2mkYH0xnOaQxezmnqpcvjkeYq3KpbjjdLaK4YASNBn/lgz3rJDCGVeqlbQLjRzi982TZ8snIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195419; c=relaxed/simple;
	bh=vKcKDJ3m8lKaP2C2WtXUd7Fn7JuShcjQ6gHTMQXNo9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIWFfYM3YNOWKPpK5Ys0/fO4pq7vVKnvGmnOGFGws+eVI+TdgcpvB4fbA/4JLHexXudXfZF7u/ElcMz9/bmuQWsx1fPZJ/r3kAeFCRr5t+UtUPfrOKsKgylZeHIk7Q9Z0bm6fZfBVDZIYJB80XQCe18g2OuPa8ogtbFRaeTh3GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OdErRotb; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764195418; x=1795731418;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vKcKDJ3m8lKaP2C2WtXUd7Fn7JuShcjQ6gHTMQXNo9s=;
  b=OdErRotbENm0rhfgE/fKNWpFM7OiXikxr1NoZpTls8fY7qonTJIW0sEV
   fWJqDDwgVflZq7shlp9Tc9NXOWTGK0tLaL4m0fWcuq8eKmBMWzEY98LLx
   k4HWBel2c6odu5Wng68+uhLooBSm8/yHe6i/dRJkjJhkHBXMZrJPnybtQ
   XRWCnjpY9UCK9RJ9yS4c7oDouaLlEY25309VvcjYpQYGy7VWylAGgy3+e
   7NSSAR132UMe7O6Lb20pYs6LY+f0zosIPbocXrGySaCcJddeKCSHTxt+y
   N3HVV+61hzW7zGtiO004xBuWcHUzXuJvxz66hMmAOgV07zIVUR/JuaX5z
   w==;
X-CSE-ConnectionGUID: Umwi8Yt1Q0e2ruD3SDz88A==
X-CSE-MsgGUID: qP6egdijRBi6sKjeXTmrgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="65246483"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="65246483"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:16:57 -0800
X-CSE-ConnectionGUID: Ev2PgfBMRL6ozP4ax/eLjw==
X-CSE-MsgGUID: 2Bjgnt75Rpu9Ku1lly4ZRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="216412913"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:16:57 -0800
Date: Wed, 26 Nov 2025 14:16:57 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v5 9/9] x86/vmscape: Add cmdline vmscape=on to override
 attack vector controls
Message-ID: <20251126-vmscape-bhb-v5-9-02d66e423b00@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>

In general, individual mitigation controls can be used to override the
attack vector controls. But, nothing exists to select BHB clearing
mitigation for VMSCAPE. The =force option comes close, but with a
side-effect of also forcibly setting the bug, hence deploying the
mitigation on unaffected parts too.

Add a new cmdline option vmscape=on to enable the mitigation based on the
VMSCAPE variant the CPU is affected by.

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 Documentation/admin-guide/hw-vuln/vmscape.rst   | 4 ++++
 Documentation/admin-guide/kernel-parameters.txt | 4 +++-
 arch/x86/kernel/cpu/bugs.c                      | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst b/Documentation/admin-guide/hw-vuln/vmscape.rst
index dc63a0bac03d43d1e295de0791dd6497d101f986..580f288ae8bfc601ff000d6d95d711bb9084459e 100644
--- a/Documentation/admin-guide/hw-vuln/vmscape.rst
+++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
@@ -112,3 +112,7 @@ The mitigation can be controlled via the ``vmscape=`` command line parameter:
 
    Force vulnerability detection and mitigation even on processors that are
    not known to be affected.
+
+ * ``vmscape=on``:
+
+   Choose the mitigation based on the VMSCAPE variant the CPU is affected by.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e581b5192b66c6f25aba38d4f8ff8..d2ccec6e10f3ea094c01083d4c133b837c7fc7d7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8104,9 +8104,11 @@
 
 			off		- disable the mitigation
 			ibpb		- use Indirect Branch Prediction Barrier
-					  (IBPB) mitigation (default)
+					  (IBPB) mitigation
 			force		- force vulnerability detection even on
 					  unaffected processors
+			on		- (default) selects IBPB or BHB clear
+					  mitigation based on CPU
 
 	vsyscall=	[X86-64,EARLY]
 			Controls the behavior of vsyscalls (i.e. calls to
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 3b9b1f27cc19d3de061814067a5d8797dfa3858b..bda6048085fbad5605534caceda32eb1df8c29ec 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3227,6 +3227,8 @@ static int __init vmscape_parse_cmdline(char *str)
 	} else if (!strcmp(str, "force")) {
 		setup_force_cpu_bug(X86_BUG_VMSCAPE);
 		vmscape_mitigation = VMSCAPE_MITIGATION_ON;
+	} else if (!strcmp(str, "on")) {
+		vmscape_mitigation = VMSCAPE_MITIGATION_ON;
 	} else {
 		pr_err("Ignoring unknown vmscape=%s option.\n", str);
 	}

-- 
2.34.1



