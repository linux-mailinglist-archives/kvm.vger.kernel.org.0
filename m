Return-Path: <kvm+bounces-15857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99AFA8B11D7
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB3561C2241F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604C416EC10;
	Wed, 24 Apr 2024 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b3CBYKil"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317E916DEAF;
	Wed, 24 Apr 2024 18:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982490; cv=none; b=mbwcrLJojwreVkCjhlfV0rT4neD27JXvJXi9XMiamcOx3Z8kBCQm2yblpZ9Fur1LK889Q6mG1MB9jADzB4WN/++4h8z51xW3zgzSgVhEopZ+2N9rWZSS9c+oLak9owIAHe2N+eBo9AJgETg3oNiqsQ1X/dR6UhjAeMiZZTEpYsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982490; c=relaxed/simple;
	bh=DTmj/yYZ5S3zG9s0UR1lWeqfV7XL+xXwEY+aB15HzFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvrXqCkv9nZGmXY/yx+ztBmyOedfURy0Mxu2r6wt7EFXeORPaesp56WQRCdoQGaM9KAsVU/UGmBoV12+8Qte0D9K0PKnbeuT0IN61kG/Wrwh52cnssqSSCk9AzfwkCQkF8cnC0VtA8HSudJGTfEVIVBXzoMvhYk9zjU9nsv5Fbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b3CBYKil; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982489; x=1745518489;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DTmj/yYZ5S3zG9s0UR1lWeqfV7XL+xXwEY+aB15HzFA=;
  b=b3CBYKilboprpZlWgzdqD9tQA4AP6fVl0WRLarLasUSCMg9QKrvPfIYz
   m8pugqBFi0x2+W3SUeU7/J2qBb/F9SCh2yWle26XQznBAcgLkjkEDixBB
   WMKaAenJ9j4tdnmk2mJCMoJiDnvnjF7LbtLQY12ek8xZkEj+XtwQydGdQ
   D0EJsAAAGPsUXOnDdafZyQwP0xLCels9GdCkAc4sRQx/uTvJLMOILXpAq
   2vGcFW4PXXtyJ8d1c5X/Fi4fag74nIKg+UgJQDb/tT1dqIyrvSSvOS2eK
   q/GcqVSYdfJ6/PdSZe7PIXRBvuK8Yid8C7BgMciF/0Fkc1H2pqNu103Cm
   A==;
X-CSE-ConnectionGUID: ABbjj0LRT9KRNRChC0+mUQ==
X-CSE-MsgGUID: iZOF3LVsTk6u2BRYDysHCw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503390"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503390"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:48 -0700
X-CSE-ConnectionGUID: 8YGYbTfMQSmqKIpYGLP9mg==
X-CSE-MsgGUID: iJt3JCwTSSe45nPXccqmjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="24683664"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:48 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 04/71] KVM: VMX: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:14:47 -0700
Message-ID: <20240424181447.41231-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37a89eda90f..2c747f2642c6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2518,17 +2518,15 @@ static bool cpu_has_sgx(void)
  */
 static bool cpu_has_perf_global_ctrl_bug(void)
 {
-	if (boot_cpu_data.x86 == 0x6) {
-		switch (boot_cpu_data.x86_model) {
-		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
-		case INTEL_FAM6_NEHALEM:	/* AAP115 */
-		case INTEL_FAM6_WESTMERE:	/* AAT100 */
-		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
-		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
-			return true;
-		default:
-			break;
-		}
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_NEHALEM_EP:	/* AAK155 */
+	case INTEL_NEHALEM:	/* AAP115 */
+	case INTEL_WESTMERE:	/* AAT100 */
+	case INTEL_WESTMERE_EP:	/* BC86,AAY89,BD102 */
+	case INTEL_NEHALEM_EX:	/* BA97 */
+		return true;
+	default:
+		break;
 	}
 
 	return false;
-- 
2.44.0


