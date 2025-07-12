Return-Path: <kvm+bounces-52457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AE8EB054F6
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE8F71C20B72
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1742D3EDD;
	Tue, 15 Jul 2025 08:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JSfrKqCy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D3926E70A;
	Tue, 15 Jul 2025 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752568317; cv=none; b=MCE6mKJELyOmsq9CFeTV10XXjA55JqE24Ij90jt31dAy6S4Qr8sRUWMF9E/u8EK5F40yywh/sVFnmhokyAhNcZny44sfvkzv0Q2wTpvQI6aFS0/HXsxVNTMs9X99owFRNJAWTfsh16dw+bbhRMrrBSwlNQG1YePPSY/YPZv1qh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752568317; c=relaxed/simple;
	bh=1Ia/J3K9aclNh66KQEhyuyMRC7haQhAZD00golo2ytI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCL2VHlozL2Lc0/bo8+jM/BFJRzL0hJMv18M/VIjn2zrGC6Ax3jFzBaY/nBM1W/OaBnAJEstiY7KxNbbmRu/xpoV1fCkP9lN7b5eJYS/vnwDlflBPtl/iufHZ1+T2lxBspIK1J02q/W6OPGQMAoVmZl4ZtsbwUnszOMsH2jDIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JSfrKqCy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752568316; x=1784104316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1Ia/J3K9aclNh66KQEhyuyMRC7haQhAZD00golo2ytI=;
  b=JSfrKqCy1OUSNCMoZqYW3Rumsr7/5MzhzFykQcJH484DIrECeYBUbqZr
   DgclKevEUiRnEpNQvU+26DrKSl5ssKUeGh+mHA+khtS/t+91mrKu1BiGA
   NRkkfmgu6CoobFnlvOseGS//SuxORaI4EV1QZRkMMSeHUuOTgPIAO8Sta
   AoVVE48qfvIBRXpCVxRwk37tMKyobEa8ZvSOaaVJp8rajD1RaZQjLO2zD
   ZO30WtPLtGp5rG5my3ZAOJVi4oDbTETt3MVJzuOwHFyLkhNH2TGZsu/cW
   7v2DZD4LRPswQUS2ilcK/URs++0QVhrNevcl4v2MVcH870hwK4rJ2oNSP
   g==;
X-CSE-ConnectionGUID: qrymY4bIQ7KFGGeENNI7YQ==
X-CSE-MsgGUID: 4Jv7fa7eROus4vx6JKAGqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54632107"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54632107"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:31:51 -0700
X-CSE-ConnectionGUID: lKA+n8ovSv6iHbxLFXJrng==
X-CSE-MsgGUID: gsOMK/IYRrO3MVTbWZHMtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="156572586"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa010.jf.intel.com with ESMTP; 15 Jul 2025 01:31:48 -0700
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
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch 3/5] x86/pmu: Fix incorrect masking of fixed counters
Date: Sat, 12 Jul 2025 17:49:13 +0000
Message-ID: <20250712174915.196103-4-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
References: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

The current implementation mistakenly limits the width of fixed counters
to the width of GP counters. Corrects the logic to ensure fixed counters
are properly masked according to their own width.

Opportunistically refine the GP counter bitwidth processing code.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 04946d10..44c728a5 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -556,18 +556,16 @@ static void check_counter_overflow(void)
 		int idx;
 
 		cnt.count = overflow_preset;
-		if (pmu_use_full_writes())
-			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
-
 		if (i == pmu.nr_gp_counters) {
 			if (!pmu.is_intel)
 				break;
 
 			cnt.ctr = fixed_events[0].unit_sel;
-			cnt.count = measure_for_overflow(&cnt);
-			cnt.count &= (1ull << pmu.gp_counter_width) - 1;
+			cnt.count &= (1ull << pmu.fixed_counter_width) - 1;
 		} else {
 			cnt.ctr = MSR_GP_COUNTERx(i);
+			if (pmu_use_full_writes())
+				cnt.count &= (1ull << pmu.gp_counter_width) - 1;
 		}
 
 		if (i % 2)
-- 
2.43.0


