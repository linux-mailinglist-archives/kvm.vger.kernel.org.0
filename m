Return-Path: <kvm+bounces-63781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 58603C7251B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 50C7129FBD
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7949F2FDC3E;
	Thu, 20 Nov 2025 06:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FrpAaQ7e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DB321B9C9;
	Thu, 20 Nov 2025 06:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619625; cv=none; b=CO4GB8ps2WkH0snBB9yFNkTQYqVLNCgOUSWFqOB0CqoT8zu+wap4Kd02aWuGAi1FDw5+t7n1ZZdKv0ClW0TndCdTRdTRLEC4KLb9Mrd/YbrPioMLvpMpDemKXZ5q/lyRXnTv/T8ikc8V/jz5JxJyXoP9G/ZTP+SE2pkWziQ6+zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619625; c=relaxed/simple;
	bh=INqMWYBufujJ7ZizDNzVH0AGCMPDyTIep9RLCXhm1NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfpBfcXKa+axGoX0POfDfHCvgAdwx/buQ+UvnCuzGaObe8SswZtfFMZ09DiJaVm3Uy/MmDTyWIOz/M9XXclJhrKeA9RSQnNc5VXHMHb297/0iSzQ9raffOOant7cNYXKaDPHTYBOUd0T2TF+eiy9kQvQ+IMsiM+hOsajOM9SN00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FrpAaQ7e; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619624; x=1795155624;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=INqMWYBufujJ7ZizDNzVH0AGCMPDyTIep9RLCXhm1NQ=;
  b=FrpAaQ7eorVzD7Rd5al07vkQkMoRSaYdvbPosIv171cCbF+F5V+ZRV7O
   kHgiua8mZcCawWbyTlG9MHbl9nOwr5J/5kfyfJ8CTV+xfOYqq15elsWrK
   EGCVdf+SCHNWGNE6jjrp8kH9yDW0HMwW6MMxN6tD58RhoBRmOXK30DOLc
   c2/4HhppEb+t9mDo+fzXdAX6uMlWCzReRwqTSN3j3ESo1PheOednkVFUv
   T9+DNi0A8giUNfZygdtqBxVTzn7kEvioHHO3ehwS+L//BcjIKkO7aJFCA
   ASZhp/bo2RWjR26B7jfANYcqmx/orPq2nQf/7lCDjK3Ax4C4sG9Y6h9bV
   g==;
X-CSE-ConnectionGUID: vzTwRKNgSCeTdRabg9eXkQ==
X-CSE-MsgGUID: 60BgPbFGSYypc8lcC+R21A==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76285298"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="76285298"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:20:23 -0800
X-CSE-ConnectionGUID: /WV5yCGdT0yz7YoXWKAX9A==
X-CSE-MsgGUID: pFcvMdv1RjWybwGFj8nJKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="214632733"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:20:22 -0800
Date: Wed, 19 Nov 2025 22:20:21 -0800
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
Subject: [PATCH v4 11/11] x86/vmscape: Add cmdline vmscape=on to override
 attack vector controls
Message-ID: <20251119-vmscape-bhb-v4-11-1adad4e69ddc@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>

In general, individual mitigation controls can be used to override the
attack vector controls. But, nothing exists to select BHB clearing
mitigation for VMSCAPE. The =force option comes close, but with a
side-effect of also forcibly setting the bug, hence deploying the
mitigation on unaffected parts too.

Add a new cmdline option vmscape=on to enable the mitigation based on the
VMSCAPE variant the CPU is affected by.

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
index 6c42061ca20e581b5192b66c6f25aba38d4f8ff8..4b4711ced5e187495476b5365cd7b3df81db893b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8104,9 +8104,11 @@
 
 			off		- disable the mitigation
 			ibpb		- use Indirect Branch Prediction Barrier
-					  (IBPB) mitigation (default)
+					  (IBPB) mitigation
 			force		- force vulnerability detection even on
 					  unaffected processors
+			on		- (default) automatically select IBPB
+			                  or BHB clear mitigation based on CPU
 
 	vsyscall=	[X86-64,EARLY]
 			Controls the behavior of vsyscalls (i.e. calls to
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 81b0db27f4094c90ebf4704c74f5e7e6b809560f..b4a21434869fcc01c40a2973f986a3f275f92ef2 100644
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



