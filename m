Return-Path: <kvm+bounces-15188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EF98AA75D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BCD51F20F1D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BC1168CC;
	Fri, 19 Apr 2024 03:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PhLnN9fr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3875811713;
	Fri, 19 Apr 2024 03:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498344; cv=none; b=QsWesnx0BDcNhZb5nU5l3KgXG1mJdfkiMco4WNqdznx1Pv+RcW992Zy22bPxLboJxKbUAJmQbZaNko56VZN9bANIN5MxNr58CDcwDltImCLc8FogZTV9gEaZWYSnzs7PVtj2gY98aS7/2ff9U3BnRDY8P2Pt6LfpPhlFvUvJd5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498344; c=relaxed/simple;
	bh=CEzCgDWBVKLE5GxE7FSPfrK8LT8jtbQYUwpmr+e1jXY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=teUIuGvfp45oK1BreYC8UiQd3Q+YVnLhEilcyID4Qg2mUmhhDKU4+5gK7yWiKiik2Zzng6xi0PW+KNM3qV4nD8xOSeXnfzm0eAz51q7X1PnvluVuEC275nnU8EZk0S4bajta7yVc+YPE5DvIoVZX8YWj7iFGANCbaNmMNjE/GmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PhLnN9fr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498343; x=1745034343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CEzCgDWBVKLE5GxE7FSPfrK8LT8jtbQYUwpmr+e1jXY=;
  b=PhLnN9fr4oeKM/1ufEkyR8C3cTkEAlLpZxNPD0evtb6NwEtmy4NBH7ce
   O5Ro3tV1Cd5eqwRwoRNczgLqft7PcCBPmXmXSrfSfmww3lg9LSpOdZ1/5
   20/IK8y5kl+7jxDXCzvmPpfIuSqm99CciIoumYfQix0CT+7G1Nkw5w0eq
   bFpk4BxZTBVmkOqJSC1dh93y3ny7H7Dr1q0nz8USg00vW/jhrTdZBkkUW
   rQ7T6RTHNc73suCTjOnhlxU/V5hAowmJpFDUN+UeQysBpxrt063Cu/VLu
   ZDvNhaGiMWSJy4QbrazjNPdsc596xHnIsAoPYkNY7rQ+yl3Oy5QJwWfPg
   w==;
X-CSE-ConnectionGUID: /0b2OimVTVqL9CdPCiQaiw==
X-CSE-MsgGUID: W2Z0LTEyQEyuNydHbWiXjg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565411"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565411"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:43 -0700
X-CSE-ConnectionGUID: hRWPN1lBS0ygcWzxNrhHLA==
X-CSE-MsgGUID: c9gF6VFfSL+LfZbss1Zn5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410121"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:40 -0700
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
Subject: [kvm-unit-tests Patch v4 03/17] x86: pmu: Refine fixed_events[] names
Date: Fri, 19 Apr 2024 11:52:19 +0800
Message-Id: <20240419035233.3837621-4-dapeng1.mi@linux.intel.com>
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

In SDM the fixed counter is numbered from 0 but currently the
fixed_events names are numbered from 1. It would cause confusion for
users. So Change the fixed_events[] names to number from 0 as well and
keep identical with SDM.

Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 4847a424f572..c971386db4e6 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -44,9 +44,9 @@ struct pmu_event {
 	{"branches", 0x00c2, 1*N, 1.1*N},
 	{"branch misses", 0x00c3, 0, 0.1*N},
 }, fixed_events[] = {
-	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
-	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
-	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
+	{"fixed 0", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
+	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
+	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
 char *buf;
-- 
2.34.1


