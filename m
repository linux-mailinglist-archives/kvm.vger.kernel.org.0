Return-Path: <kvm+bounces-56667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 907BEB41577
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38F711B6071A
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4972F2DCF69;
	Wed,  3 Sep 2025 06:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oF25FEcF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074B32DCBFD;
	Wed,  3 Sep 2025 06:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882059; cv=none; b=uFvirZ7FI4vayifqWn/H75nAvToGBJs2xUT9X1ZHBSH1Ck2ctkUgzx+XhgFoThoz9sGHL9+pyvSEa35pwNXtY/uPySGznxVfwz3GZPsgFDirzTFoVT8BtrstCwHDovGeUOZT1FcPiZRQGn2Gys3J5zS6X+G0lscsp1qIS9FtJGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882059; c=relaxed/simple;
	bh=1CVYfQYEkfyq8SaYox+DXBOLRWq3Y8uewK6cgv1Mi6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J5Kek8ZLiNPtSimzG/Wiqm7RbLlRX5W89PipAflIXaBilBqdb939+97P0kpiLVSGSQeUsQyQCSkpgZtrBJk0aee5OZffSpIvIOLM0jPfndMQDRUFBInQBJJvy7oOKqoGF+TfSpzQ9Q00clGFSyNOeZj2K4qn6jPhsv8bihiV/1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oF25FEcF; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882058; x=1788418058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1CVYfQYEkfyq8SaYox+DXBOLRWq3Y8uewK6cgv1Mi6A=;
  b=oF25FEcF2hpNlm5a2mNsCdKndQeZbUBsMXl0nka1HvOJapa5Xn04z+F4
   +FbEAeAMlLvNl3oSdU2SzdgoQPiMmTdPYZRcR3d0NkQ5q7tcPRx6Rvc5b
   gF73qWd/WargcxGE6UejSZoQJpd9ZhHXjvh+c2SfqzAuWZS8+AtxmbGV0
   NnRcnnV1ojMbEwAGsu+KPYtZiY9CcwU9nGLOUpGCZNTJ8X+LOvTrROVSi
   WLNNnZ4Kl6uTuFaXEfL+FMXcrehjSNNw6TIN8+zuBivKlsEIpIxX9ly33
   YuRpuZ0UVknGHQiLHdv2xTNKdmLVpR/fkJ8uVUWZibsfQQ/pYTLHmVaUl
   g==;
X-CSE-ConnectionGUID: X5ty7pj9TqK043YieMwyhA==
X-CSE-MsgGUID: jGRMybmDSK6ALYwhtHHvug==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003800"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003800"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:38 -0700
X-CSE-ConnectionGUID: LFbD5dAxQTKfVWz13P3aDg==
X-CSE-MsgGUID: Zf/Ydu3WRlyRkqDTsJAukw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656591"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:35 -0700
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
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v3 5/8] x86/pmu: Relax precise count check for emulated instructions tests
Date: Wed,  3 Sep 2025 14:45:58 +0800
Message-Id: <20250903064601.32131-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Relax precise count check for emulated instructions tests on these
platforms with HW overcount issues.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index c54c0988..6bf6eee3 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -790,7 +790,7 @@ static void check_emulated_instr(void)
 
 	// Check that the end count - start count is at least the expected
 	// number of instructions and branches.
-	if (this_cpu_has_perf_global_ctrl()) {
+	if (this_cpu_has_perf_global_ctrl() && !intel_inst_overcount_flags) {
 		report(instr_cnt.count - instr_start == KVM_FEP_INSNS,
 		       "instruction count");
 		report(brnch_cnt.count - brnch_start == KVM_FEP_BRANCHES,
-- 
2.34.1


