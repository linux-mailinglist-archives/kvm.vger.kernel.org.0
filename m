Return-Path: <kvm+bounces-44032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E066A99F3A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7BD2921384
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68AE51A8401;
	Thu, 24 Apr 2025 03:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Di86I/Ze"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1B819CC0C;
	Thu, 24 Apr 2025 03:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745463994; cv=none; b=XICG6DMtMBPBrl64csOAB54AixMx0EFaFTOjeGGGwS48OTNChMsMtiLcoo+89p+IRoEbwo1SUPlYEQTcFYuxxJdIVyLPLCukkoScAde5IM2n6Vc+YcQsvtCFNmy1YWLFqcS0L1SpX7fcj4eNTZa3MhdNseLgLq/rUg8beALsw5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745463994; c=relaxed/simple;
	bh=uXNOsvCklRAYSqLYu63ifPB0WY2hC7YPSUDJIeIHlu4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xf2JVAjEg3s2jVVFHGYiw+oA7zIQDthsAS+tZ7VvdkG4iooWpQPRBUTMexXfM0zxKO5/m9SvcOdVwcyd35KRf391ILhWVX1rorgNy9bfUE+tN620QhzfjbO83M4scUIHG8qqZjBO2R8ZFTrc8KPd1n5y6Rfjs/sA4z6g6FN79dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Di86I/Ze; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745463993; x=1776999993;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uXNOsvCklRAYSqLYu63ifPB0WY2hC7YPSUDJIeIHlu4=;
  b=Di86I/ZeAll4wMmIilYKa3sdvEdjxlAUeB1lKAc0sh14YetetNFmliJr
   fpuSX+gFleWYVaC/rJ6cHluIcbPl1WiX4q6uMfhd8jte5sG+pG5q5ON9W
   AM4OlJwfBrLqCDKfnxsRX9WDDwv+vw6H7pWo6LwrhoA2w2WP5CnlZSsFQ
   4MK0SS6VRfSMNHhGLSXUh/C0+6PkhxagdrHcKbruMZw9RaBdl2ePn7f4B
   aPYb0RJH7TxsNydA7lALNWN1OPnF2x12sPp4LikgeFBrfpvcSAtMGTelw
   QzxaztiVe/IvOc45aMnTYIgiqS13IYLMKWQkyqihv5KIumaUjsYlzlnmS
   Q==;
X-CSE-ConnectionGUID: BzcasqvRSTqCKJPmJRenbQ==
X-CSE-MsgGUID: q/Z/UpZ5T4GPp18Yb9czAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="49744034"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="49744034"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:06:31 -0700
X-CSE-ConnectionGUID: Hz/IRvLUQWKhWlORvT/9GQ==
X-CSE-MsgGUID: bH5XwpOcSjyZx51D7iJgOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132374363"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa010.jf.intel.com with ESMTP; 23 Apr 2025 20:06:28 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH] x86/pmu_pebs: Initalize and enable PMU interrupt (PMI_VECTOR)
Date: Thu, 24 Apr 2025 05:22:01 +0000
Message-Id: <20250424052201.7194-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PMU interrupt is not correctly initialized and enabled in pmu_pebs test.
It leads to the APIC_LVTPC mask bit is never cleared after first PMI and
all subsequential PEBS PMIs are suppressed.

Although it doesn't impact pmu_pebs test results since current pmu_pebs
test checks PEBS records by polling instead of PMI driving, it's still an
incorrect behavior and could cause some unexpected false positives.

Thus initialize and enable PMU interrupt and ensure PEBS PMI can be
generated and correctly processed.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu_pebs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index 6396d51c..6e73fc34 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -417,9 +417,11 @@ int main(int ac, char **av)
 	printf("PEBS Fixed counters: %d\n", pmu.nr_fixed_counters);
 	printf("PEBS baseline (Adaptive PEBS): %d\n", has_baseline);
 
+	apic_write(APIC_LVTPC, PMI_VECTOR);
 	handle_irq(PMI_VECTOR, cnt_overflow);
 	alloc_buffers();
 
+	sti();
 	for (i = 0; i < ARRAY_SIZE(counter_start_values); i++) {
 		ctr_start_val = counter_start_values[i];
 		check_pebs_counters(0, false);
@@ -441,6 +443,7 @@ int main(int ac, char **av)
 			report_prefix_pop();
 		}
 	}
+	cli();
 
 	free_buffers();
 

base-commit: abdc5d02a7796a55802509ac9bb704c721f2a5f6
-- 
2.40.1


