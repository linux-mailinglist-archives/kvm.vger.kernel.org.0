Return-Path: <kvm+bounces-15190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3DC8AA761
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:47:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AC45284532
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:47:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1262747B;
	Fri, 19 Apr 2024 03:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0Ako2w9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DA3225CF;
	Fri, 19 Apr 2024 03:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498350; cv=none; b=NEhyMeCjJ9yPAhtIrkfLRVVO6ev1uVoJ6FKgBmWhEXCOn7j0n+QX3eK6RhfGEvhpqtu9BdyuxL9bflJyO/bC76uogCfPpBIqos1DwxaMA1Dl1CfIQrgpmRv8THWXC5+h9VrBEFTdyjS2wXutHTCmx1eeh3l5gorbBtEl40LHjoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498350; c=relaxed/simple;
	bh=/Fg7XH4wVHMgm+RVDjt7bI8o2hvzs79zF/aqW2rqFOs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rndHUmRPpisWbceUnXAgS/B0tgfvZ5Vu4DuB+4zTlJUEGGzQGSqPh7rUS5NtQDRWltUpUcSOPdgDcEoZ5WWOg3smOj3ljeFndnF8UXfxXNvLaZHDqUZACtnO3WwWRJTdCokrvM+ZP+DI120Kr8K3wC4m3iPqDom1J6bbQod3C4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X0Ako2w9; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498349; x=1745034349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Fg7XH4wVHMgm+RVDjt7bI8o2hvzs79zF/aqW2rqFOs=;
  b=X0Ako2w9GToRrL8lwDDjGzvMpPq1kxXdDRjNoXUvoO4DpZ7USVmLr2a+
   2sWdRLdhBjaNXwgIUEJ8OwgGcAKNpTsBmK0v7dwjcEImp//HIZCRZxhKS
   0GnpBTfNqNMtbj5w+KAVmEABzxF0JHNTWqqfHL5KQLN7khUuXsGyldZfs
   CKm7wT/gWU/P4vjACULS++En4EnJXtzu1HwkJFgifTGbiLWf3AYebg0Iq
   D9rw0Ce9FvrGcV6Y4Oqbdxyy0ZS89QVnZBZybwbb0x8HThX3gRs0xQ3dS
   fdOBI7ENiGHTeHCk790LpDcaQ3s0ft7474YYlukwf9zsiWLbd1Qv1tXbq
   Q==;
X-CSE-ConnectionGUID: VV9R6Us/QAWJ3+2DFoGUzQ==
X-CSE-MsgGUID: GmqykvU7S3+4ssAPAxAIUA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565428"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565428"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:45:49 -0700
X-CSE-ConnectionGUID: w7V3nyGWTiyx0qlxwfnqpQ==
X-CSE-MsgGUID: lnADloPQQ7SFjPsPSyAGGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410148"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:46 -0700
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
Subject: [kvm-unit-tests Patch v4 05/17] x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
Date: Fri, 19 Apr 2024 11:52:21 +0800
Message-Id: <20240419035233.3837621-6-dapeng1.mi@linux.intel.com>
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
index 5fd7439a0eba..494af4012e84 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -253,7 +253,7 @@ static void check_fixed_counters(void)
 
 static void check_counters_many(void)
 {
-	pmu_counter_t cnt[10];
+	pmu_counter_t cnt[48];
 	int i, n;
 
 	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
-- 
2.34.1


