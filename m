Return-Path: <kvm+bounces-26900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45517978EA0
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07E4F28A102
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DC4A1CF285;
	Sat, 14 Sep 2024 07:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="etMvt9bu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F881CEE84;
	Sat, 14 Sep 2024 07:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297283; cv=none; b=uwYvkpXZcplY1RprV/6DhnAB/sq7QMTxv541q1TsTLQ+WQZQY2fjMpmr5v5jPofsRu4zULCsfvOJ84/3ByeiZGgABtVQmT1QUpG8LpaYTqPcY+ztYalowV3pU13HVXAEHWtvuSKTFFslr2jYAma73aH/YdaXPl/EjvCivlP/Z3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297283; c=relaxed/simple;
	bh=c/FKtCmCvkZd0M4TkpSHqVExn/0016+qbGWLpWK/BiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gYKmWznDGVTgusBcfGwJ4+N1qYR9or9los8z1HD2PsNUjEOQFiEHt4hAuO4WIcNfcqKX3g7D4PIe8sCxB6vUDkAFQ2oMVfb6rviZenhh5j0m2iRw1x9UzvxVIarAIy7AGae16dwIxzOc2DK+u4waDWHrJX0Y71LM9gesdbaxNTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=etMvt9bu; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297282; x=1757833282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c/FKtCmCvkZd0M4TkpSHqVExn/0016+qbGWLpWK/BiA=;
  b=etMvt9burReQQEpZey4luxIoCzNgH0HO8Fj0SVaAmcEWwvlCLR64/d8R
   x9RDVDukB32nGPt/3iGo7k9Lc9LyOu4NRUgl65ZeQtrNh7xN7/umsDmEI
   YCF6nnRPOY2DOHUSxnFWARmg3E7zJ9wwfb6SXkSMD0cWexT1RsR5D7otA
   yny2xnnlQtFBBddFOMsnkZhyNMFXjsBBuAxvzC6zhnMyl0aXsOAJTthG5
   WBxZuvHWkOafAji2xHgTrxFm//ihhkoEwFY+GLn5Q6yez/xw17ascLq21
   dE9lvZ50iVO2CdTwfPskdSaf2RfRdFm1OJ0gUZ0969L1MxUBuO/mgcaRs
   g==;
X-CSE-ConnectionGUID: o7sR+5zRRimluAe8GpwntQ==
X-CSE-MsgGUID: /vgpxzU6SLqTsnDv44s3oA==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778772"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778772"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:22 -0700
X-CSE-ConnectionGUID: e+nqjkttSxyNyg3j9Rpp3A==
X-CSE-MsgGUID: KwqE5NccTAmbBVqMoyEL2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950900"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:16 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 05/18] x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
Date: Sat, 14 Sep 2024 10:17:15 +0000
Message-Id: <20240914101728.33148-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Considering there are already 8 GP counters and 4 fixed counters on
latest Intel processors, like Sapphire Rapids. The original cnt[] array
length 10 is definitely not enough to cover all supported PMU counters on
these new processors even through currently KVM only supports 3 fixed
counters at most. This would cause out of bound memory access and may trigger
false alarm on PMU counter validation

It's probably more and more GP and fixed counters are introduced in the
future and then directly extends the cnt[] array length to 48 once and
for all. Base on the layout of IA32_PERF_GLOBAL_CTRL and
IA32_PERF_GLOBAL_STATUS, 48 looks enough in near feature.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index a0268db8..b4de2680 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -255,7 +255,7 @@ static void check_fixed_counters(void)
 
 static void check_counters_many(void)
 {
-	pmu_counter_t cnt[10];
+	pmu_counter_t cnt[48];
 	int i, n;
 
 	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
-- 
2.40.1


