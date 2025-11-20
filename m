Return-Path: <kvm+bounces-63776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DEA1C72545
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8C4994E7F4E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00AB32E541E;
	Thu, 20 Nov 2025 06:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VrGaTiRZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F9F238C3B;
	Thu, 20 Nov 2025 06:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619547; cv=none; b=AONUq/mamxjO3pyy+SChlQcURVIIHU2JWDnB4Byf461JGG+oX+cGnMBzhu5oPLn2TSDXBf+5m94+nweJq3PJ8Cho3+TDJxkE5stV2eBsNu03mHEKTtUamWZZizieiqxzc7NEt0Uqn7sg1X06YTTgqxDwxXTZ5cF0iivhXtyxCok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619547; c=relaxed/simple;
	bh=dMz6zekRJxMgHvVGRAsdGPLDZGboXMTY5OevNzqM73Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ae7VREQoKMU8pLYYVXwAVZtooMjdspUSNvTWo6CVP1mDd+LdrtxnwrhSUaLK/NSg/GgmJ8p4L2SDdgEeTiuVhmYVTHGlVwQ9M1sBktfTkJUI7vx14e+Y93Rps/F1xvu7xW82qeu7MX7YyfYjRX0FrhBCYZGOiLF6Y3KI3yke7LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VrGaTiRZ; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619545; x=1795155545;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dMz6zekRJxMgHvVGRAsdGPLDZGboXMTY5OevNzqM73Y=;
  b=VrGaTiRZq8LXhYQuEi3hMhMmK5dv+D9R075ZY2nsMpOXMtE7x/Nqi41E
   D8ceTrQNfogFSZEdES66+YU4Bs7AvDUl1Av8EG/cH7+IY7IntlYU4eulr
   t7WqaRofHttJVORP7fIt6NGhTXmUIhQEXI6Gs00jLKgzAIpkd5gnLlwW3
   ZTRN7ODxpOLaOfdM8LZBHaiDdREHtmwHzlmo5ePlIjalBrQeSLjOrJLSH
   1IC82okDYhQtLa0JF7yjRqCCFc2sNT21giTinycVvxaxVSlRwzbHIL8YF
   XAc9+IfhAQVxhFsKpJEx0/TjXmduFySfEeCg9jSk0WlaKl18/vecPZMtY
   Q==;
X-CSE-ConnectionGUID: u3x+BhBFRXKOhevtPGwq/Q==
X-CSE-MsgGUID: gqQhKEthRHS1QlKS7bIv7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76354645"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="76354645"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:19:05 -0800
X-CSE-ConnectionGUID: u2RymnzIRtmpHHqhqK/06Q==
X-CSE-MsgGUID: qcXT9DXvROmdqECQgUQHYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="191400650"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:19:05 -0800
Date: Wed, 19 Nov 2025 22:19:04 -0800
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
Subject: [PATCH v4 06/11] x86/vmscape: Move mitigation selection to a switch()
Message-ID: <20251119-vmscape-bhb-v4-6-1adad4e69ddc@linux.intel.com>
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

This ensures that all mitigation modes are explicitly handled, while
keeping the mitigation selection for each mode together. This also prepares
for adding BHB-clearing mitigation mode for VMSCAPE.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1e9b11198db0fe2483bd17b1327bcfd44a2c1dbf..233594ede19bf971c999f4d3cc0f6f213002c16c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3231,17 +3231,31 @@ early_param("vmscape", vmscape_parse_cmdline);
 
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
+	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
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
 	}
 }
 

-- 
2.34.1



