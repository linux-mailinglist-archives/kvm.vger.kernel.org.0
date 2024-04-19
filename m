Return-Path: <kvm+bounces-15186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F08188AA75A
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A78321F22436
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1822D268;
	Fri, 19 Apr 2024 03:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DfAQN9a5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892DEB65C;
	Fri, 19 Apr 2024 03:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498338; cv=none; b=WtCLPpBAGy39ESxkWAKpOVSVbXDQIyxxN+QcfLUP/QAor+hZxeGl3LM+vxhtdSQKQ52x6BAZtj7frHe0YLENxlEnBSacAG+c4d/U0V/TStt1x+icGfcbIEbzadALlQkzt/uRBFqmdfhPMcx89jVGP7D3dvLW+GzjeNDjhQSC2Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498338; c=relaxed/simple;
	bh=mvnhKObMsf4oRtDBDUyLyjk+9cER6IEHnWTcGVhIjQ4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zdapvqp5HJ1QZHIUM3dKI2YU/7+L/1jPrXqYRFuqVctRGWn692soxwlqLr7kmwyF/d20WTQzQV7q0CJFL4roTRGspr7T8/rjVNYu+IPRSokKn8jBXMIFfGq3wLHlj3RgSqR4pgSJyr6iRDRrrD4PEq1zCpZvYCclyjDucEMVvYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DfAQN9a5; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498337; x=1745034337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mvnhKObMsf4oRtDBDUyLyjk+9cER6IEHnWTcGVhIjQ4=;
  b=DfAQN9a50I6zmy9+pCHN/pAB5zRtg9IS4VX1dF0J8ewJmDVGudbj+8Hb
   txmsgc3XIZuF8SS1vVl7rBDL/zLMTD280BSEvRoB2n+Xb/6PNgYi7OLuy
   d4Dro8eebUWxft/4Nq65qtO1vRqpoJL1lvCYoplz9OjMQIAHgY9nVYd/X
   eclnAy7nPwjO2WCO45AVmMrOMm7cJ3oq3MPV1MGCEP57kUxS+2OJxi4Mf
   9B+lEIZ9yhQO4hfperUTGLl/I4d4LytXzxHYL4iq1DYDKs0b860TR1Wc/
   He3+4KGX7DUFB+tFYhVIFoEpz/8LLvj3O34gMnY6qsB9UzOFxJZNP3sgD
   w==;
X-CSE-ConnectionGUID: pLD1nsigQqecdRheOF6H8w==
X-CSE-MsgGUID: jnXLVH8kRJWkn4YM5HOFTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565397"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565397"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:37 -0700
X-CSE-ConnectionGUID: Eb2gFHIwSxiZ3DyaOoO7qQ==
X-CSE-MsgGUID: uyD1Lh62QJi8fxWmPqloFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410102"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:34 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v4 01/17] x86: pmu: Remove duplicate code in pmu_init()
Date: Fri, 19 Apr 2024 11:52:17 +0800
Message-Id: <20240419035233.3837621-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
References: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiong Zhang <xiong.y.zhang@intel.com>

There are totally same code in pmu_init() helper, remove the duplicate
code.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 lib/x86/pmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 0f2afd650bc9..d06e94553024 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -16,11 +16,6 @@ void pmu_init(void)
 			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
 		}
 
-		if (pmu.version > 1) {
-			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
-			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
-		}
-
 		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
 		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
 		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
-- 
2.34.1


