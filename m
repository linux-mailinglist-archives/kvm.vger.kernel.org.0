Return-Path: <kvm+bounces-65076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D854C9A384
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:19:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AEC1A342910
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742EC2FD7CA;
	Tue,  2 Dec 2025 06:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="apGi2zuz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE6325D527;
	Tue,  2 Dec 2025 06:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656387; cv=none; b=leejcYgtvqwxaSPYWq6TDT39WmmstY/E3DS/EqVcZG3iNcdyFLPzgXIdSOedqJsW52cytPssSBKzuAos4bkFrXbarinRIWd0ZcNRtD2JSDJH6XVbdx3hBd7geDdKT/eXq1LJurWU5MxBOcOd+jJUGPm22lVGuc0bA1YLFXkNlpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656387; c=relaxed/simple;
	bh=LwiRaiJm83rbz1obic3BMaKDvfBkIvzUhBGwulJDATA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T41nRVoKX+hmLNRSy2Y/veaCfBHmVZ05V6OI7KZ7PDYheIkgsrvNvLu/xSg2QIOQMROJTPEoPEnRheCKZDRCXSUgF9zhu67vRW3Npd4o9Gb9xtF10ZOQLI0FvA1Qjzwm/HTj3+LT2b4lLFRu3MAstvPUgeZEqhT+/9vTsDfK3cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=apGi2zuz; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656386; x=1796192386;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LwiRaiJm83rbz1obic3BMaKDvfBkIvzUhBGwulJDATA=;
  b=apGi2zuz7saDTjGztVvxVunmriaiGC9DZ6Oz5iYAIkqZiY5q8auV8MtG
   Yvr+WOFOtOaHX8Zw6PKS9nfplP2RTItp4bQ+LgjgkocxrpBzkvxtGgG9J
   WGziWHrZ8rHFuKEPwWXmeJ6x1cWzYrPGi7OjuTRijkrDmOJOoeu12Eu7V
   QpQfpAoN1MIAOtUMASngA1TF5G1jfoPIQZhOTvbzeb/Xp4KTRn0Vdd4+t
   bFyeIFw8bocJleCV/CqCLRExpz5BH81xlLbX9MaQDqUImlkvmAaaGDaxb
   HMAq7khrou4QxszVAJ4ZLXGcc4viEuPY0WweJmB6nsKJCOX6r1uUD43cT
   g==;
X-CSE-ConnectionGUID: qXWEzwgtTUysywkngHIvsA==
X-CSE-MsgGUID: OGH5xzV8S9mcLBryM6rbNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="54165859"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="54165859"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:19:45 -0800
X-CSE-ConnectionGUID: vzfJv1gdSBymVAQCvFLUng==
X-CSE-MsgGUID: Ebg/GjRaRkiLfCsvNbeT+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="193580374"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:19:45 -0800
Date: Mon, 1 Dec 2025 22:19:44 -0800
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
Subject: [PATCH v6 4/9] x86/vmscape: Move mitigation selection to a switch()
Message-ID: <20251201-vmscape-bhb-v6-4-d610dd515714@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>

This ensures that all mitigation modes are explicitly handled, while
keeping the mitigation selection for each mode together. This also prepares
for adding BHB-clearing mitigation mode for VMSCAPE.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1e9b11198db0fe2483bd17b1327bcfd44a2c1dbf..71865b9d2c5c18cd0cf3cb8bbf07d1576cd20498 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3231,17 +3231,33 @@ early_param("vmscape", vmscape_parse_cmdline);
 
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
+		break;
 	}
 }
 

-- 
2.34.1



