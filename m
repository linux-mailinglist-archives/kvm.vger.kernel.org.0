Return-Path: <kvm+bounces-64762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A546C8C2BD
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E2E13B3675
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C254A2EDD70;
	Wed, 26 Nov 2025 22:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oilujy0m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453B41E1A17;
	Wed, 26 Nov 2025 22:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195342; cv=none; b=WF2iZbBIFgreHGOcrVhoPPfFUvmAGZqqf4oBAHKqcqMCm3HEboY/Csv5sV5JHxpKeRX7AimWEsPjl3kcLlu2ndbFqrXD82Vh8ZMfyUGXbxsHAqyCaCCH82sx9AH07on8Yr5hmrYlSLrrdX7nnH2z1P33arUOJpkGpO2muuXgaZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195342; c=relaxed/simple;
	bh=G2JOWn9yvfYt1qFCSza1jyQm69uDU6B8+P8t0sq/pAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SyInJ655ANQJmUPZhwPSnNQ4PO4ZynQTbETB9/KIwqKlBEvT4HczFvZ+hROA5gLCJlJHYdumnTMWl2PurjyOX0d8HmfLPRuFptNzY13wYxFNifZrydEzyKd7EySNk3sdzznfwqekzoWShJU/V0WdGFBCcTceyxOu9StHCL2y2fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oilujy0m; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764195342; x=1795731342;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G2JOWn9yvfYt1qFCSza1jyQm69uDU6B8+P8t0sq/pAU=;
  b=Oilujy0mpeZLWXD/AUnTSDGC+7JYaGKFKJGI0z5mc9WQYIDZ4WNOWvPH
   36+jl8jOLcSG19yEArnoV/wbtKNw/nZ0mjBHvz0IaNs+9T0H0DrBfIJ36
   6BGX5uAJoc9+AbVZVlDFjDiCljSLpBBQp/shCs6l1Q/21tgtIT4+b6gma
   LyyRe1VI/V5xDmt1DCh7aMkKCkXZeUiLY+CH416vD38jxLaC7JeOuglmr
   adQLPoGg7WUv83cxx7D6sk/7EpIKTBoDBtvOGGQ5/mqwvKarsXWDdyUhd
   /YgAs1j7HRtDpxG0qAOu72ssxpyAc5gFIBlZcbjSooW5AOMkGIrtA37K7
   Q==;
X-CSE-ConnectionGUID: J2n4xmahT9Go1uU8Tjy6XA==
X-CSE-MsgGUID: 83pnxrFJRxWkMltbwqhi9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="77716029"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="77716029"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:15:41 -0800
X-CSE-ConnectionGUID: yUvYHFdLQWu8pGoJrRBkYg==
X-CSE-MsgGUID: UyImgWEbRCaOOKFwZJmNDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="193084780"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:15:41 -0800
Date: Wed, 26 Nov 2025 14:15:40 -0800
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
Subject: [PATCH v5 4/9] x86/vmscape: Move mitigation selection to a switch()
Message-ID: <20251126-vmscape-bhb-v5-4-02d66e423b00@linux.intel.com>
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

This ensures that all mitigation modes are explicitly handled, while
keeping the mitigation selection for each mode together. This also prepares
for adding BHB-clearing mitigation mode for VMSCAPE.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1e9b11198db0fe2483bd17b1327bcfd44a2c1dbf..ecefea3c018117031ea1d1ef8f4fca6e425a936c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3231,17 +3231,32 @@ early_param("vmscape", vmscape_parse_cmdline);
 
 static void __init vmscape_select_mitigation(void)
 {
-	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
-	    !boot_cpu_has(X86_FEATURE_IBPB)) {
+	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
 		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 		return;
 	}
 
-	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
-		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
+	if ((vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) &&
+	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
+		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
+
+	switch (vmscape_mitigation) {
+	case VMSCAPE_MITIGATION_NONE:
+		break;
+
+	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
+		if (!boot_cpu_has(X86_FEATURE_IBPB))
+			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
+		break;
+
+	case VMSCAPE_MITIGATION_AUTO:
+		if (boot_cpu_has(X86_FEATURE_IBPB))
 			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
 		else
 			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
+		break;
+
+	default:
 	}
 }
 

-- 
2.34.1



