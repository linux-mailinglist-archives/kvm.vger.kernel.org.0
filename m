Return-Path: <kvm+bounces-9692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B58E866CF4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:49:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BD86B23D06
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB6E64A92;
	Mon, 26 Feb 2024 08:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JdCitgEa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33518626A7;
	Mon, 26 Feb 2024 08:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936109; cv=none; b=XS5FBJ7wVGAbht0Ne6DC8ypofqUasDdVXH8kpBELWxGHxCtur2wTs/Pzy4DvAO7PJfn7BEpSdyBrx0Z0zYqv4ObwRjxmIFacm8/aOwmr3Np4UnJ11yPuDQjjjJntcYeu6L1ju5W2aAsn6WyfoCnLparP6OuMewx9Wty6u80mM88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936109; c=relaxed/simple;
	bh=ItvOXDST0y8Qvf46BwFZbHkP1zwOR0dJGkEPf5xC34E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QhczXVsQtosaGzGQzxGidfvxvsG3SQ4SjklY4yHQFwmra7COrU8KGc26YKjGkYLmoY9BQir1ShcrL90M+uzWMFmS0LgkbNjNcPC7vl7fmMllPklyY6Iz+fzNN3mKbKPH7TVXd41igvte3I6YJIrakXS4AhCDUTSdLFoa1EbBFAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JdCitgEa; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936108; x=1740472108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ItvOXDST0y8Qvf46BwFZbHkP1zwOR0dJGkEPf5xC34E=;
  b=JdCitgEaKrL00iRIetnhGe2THkHFOxpTszG4272V2pCojn9Qj8h3NbRX
   DO9xxr54c6YMLB96uy9oe75XYLZLpHNg0pu/ibyqxXmhl7+H/ufrYoyPo
   raim+waACoKB19wBbdHP8N6r8OmBTioEVxuy6j03eLJTDgdJk4OlB8hsD
   2j+DyLIpcQ48VS/Q4rbWW+FTczQjT9enaY/JACy1V9uh0WyLuZphoiLQF
   xroQghiB+XV8kskJnpVDUbY9MouqNZYSkymZULITrejF8twawoq/P4vyR
   KR2x5cmp/lS9pqYZVYAVf1CJ1tyF1mEfRXAaqqumoQp3h3OrLwgDiugYS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069460"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069460"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272394"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:26 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 069/130] KVM: TDX: Require TDP MMU and mmio caching for TDX
Date: Mon, 26 Feb 2024 00:26:11 -0800
Message-Id: <f6a80dd212e8c3fd14b40049eed33187008cf35a.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
support for TDX isn't implemented.  TDX requires KVM mmio caching.  Disable
TDX support when TDP MMU or mmio caching aren't supported.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c  |  1 +
 arch/x86/kvm/vmx/main.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0e0321ad9ca2..b8d6ce02e66d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -104,6 +104,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  * If the hardware supports that we don't need to do shadow paging.
  */
 bool tdp_enabled = false;
+EXPORT_SYMBOL_GPL(tdp_enabled);
 
 static bool __ro_after_init tdp_mmu_allowed;
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 076a471d9aea..54df6653193e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -3,6 +3,7 @@
 
 #include "x86_ops.h"
 #include "vmx.h"
+#include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
 #include "tdx.h"
@@ -36,6 +37,18 @@ static __init int vt_hardware_setup(void)
 	if (ret)
 		return ret;
 
+	/* TDX requires KVM TDP MMU. */
+	if (enable_tdx && !tdp_enabled) {
+		enable_tdx = false;
+		pr_warn_ratelimited("TDX requires TDP MMU.  Please enable TDP MMU for TDX.\n");
+	}
+
+	/* TDX requires MMIO caching. */
+	if (enable_tdx && !enable_mmio_caching) {
+		enable_tdx = false;
+		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
+	}
+
 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
 	if (enable_tdx)
 		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
-- 
2.25.1


