Return-Path: <kvm+bounces-20869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FBC924D9C
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E40E28720D
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6A92D7A8;
	Wed,  3 Jul 2024 02:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cCROZzbT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928AA28370;
	Wed,  3 Jul 2024 02:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972770; cv=none; b=Otek2RQ/KYSYEj+ljbcFuJmg7tfu0uic2SErPK+olpg8iU4ZgGMRqJEFq13qmV07amhiuGST+CjJBCgEIK7osz4T05JhMF/fbhtuMF74d5Y495+Z/GRlHekD23JbyduOfUmx3mNYnwAhYuGv4I/vI/LBiILZ2lt/sOsbqXwpow0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972770; c=relaxed/simple;
	bh=NOKncSb0XiiYQO6c+6ANmKchgy105hDTLQorIKO0dWY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZozGjgDa4ukhVlGaXQq78aUY9LVHF4CuSUNShDZ4iThkWtLOZ81/taGz+HN2UxRI2ld+nKvgikeUPxB9xCw12rML252Ebu5nJK0exZabNd3/AqzXrKUCDnuA6/f0kbtR6dlnVfndQnI1mOYvdl0m5CCbaDU6YNdq/nKz/4EGpv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cCROZzbT; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972768; x=1751508768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NOKncSb0XiiYQO6c+6ANmKchgy105hDTLQorIKO0dWY=;
  b=cCROZzbT6C+7WvwBnpqSSxuU7ckURwTJpHAMXXJH3vOkEFaaiCp/ektB
   qMOk6RXMjdkNRyfm0AtJj3NDbqnD5wRVIzzTD9Gx0J3w8ySP2eznG6c91
   cs7DkaQcPbbEgXXqJA6BHRfLEiK9Fbp0TPLYqM0WfLdtV8lzMtnn4guCq
   bB9gvjGVw90uxib63dkS2iT081qEAasaX/f1zoTYSazxnE0F9qxaswewA
   bmn+e9eDC83IVHR8qYnHnBGA3qPY+0LsfxAzNyJapZPS0Vr9veDMQKYi6
   LUgFoPGLerhy520uBMTk1u0kTWEox0NsL30tUqFj/+Eu46RowB+jyV9jn
   A==;
X-CSE-ConnectionGUID: rYOWfXKyS2m4q9tEcWiMow==
X-CSE-MsgGUID: IKifbUKtRdCUQc8W1xnvYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311009"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311009"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:48 -0700
X-CSE-ConnectionGUID: hdp2MQQdTSiQXUV4CzPQjA==
X-CSE-MsgGUID: Wkx7HKwMQkW8nfIR6ygDLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148587"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:46 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v5 07/18] x86: pmu: Fix cycles event validation failure
Date: Wed,  3 Jul 2024 09:57:01 +0000
Message-Id: <20240703095712.64202-8-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running pmu test on SPR, sometimes the following failure is
reported.

PMU version:         2
GP counters:         8
GP counter width:    48
Mask length:         8
Fixed counters:      3
Fixed counter width: 48
1000000 <= 55109398 <= 50000000
FAIL: Intel: core cycles-0
1000000 <= 18279571 <= 50000000
PASS: Intel: core cycles-1
1000000 <= 12238092 <= 50000000
PASS: Intel: core cycles-2
1000000 <= 7981727 <= 50000000
PASS: Intel: core cycles-3
1000000 <= 6984711 <= 50000000
PASS: Intel: core cycles-4
1000000 <= 6773673 <= 50000000
PASS: Intel: core cycles-5
1000000 <= 6697842 <= 50000000
PASS: Intel: core cycles-6
1000000 <= 6747947 <= 50000000
PASS: Intel: core cycles-7

The count of the "core cycles" on first counter would exceed the upper
boundary and leads to a failure, and then the "core cycles" count would
drop gradually and reach a stable state.

That looks reasonable. The "core cycles" event is defined as the 1st
event in xxx_gp_events[] array and it is always verified at first.
when the program loop() is executed at the first time it needs to warm
up the pipeline and cache, such as it has to wait for cache is filled.
All these warm-up work leads to a quite large core cycles count which
may exceeds the verification range.

To avoid the false positive of cycles event caused by warm-up,
explicitly introduce a warm-up state before really starting
verification.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 3e0bf3a2..1e028579 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -593,11 +593,27 @@ static void check_tsx_cycles(void)
 	report_prefix_pop();
 }
 
+static void warm_up(void)
+{
+	int i = 8;
+
+	/*
+	 * Since cycles event is always run as the first event, there would be
+	 * a warm-up state to warm up the cache, it leads to the measured cycles
+	 * value may exceed the pre-defined cycles upper boundary and cause
+	 * false positive. To avoid this, introduce an warm-up state before
+	 * the real verification.
+	 */
+	while (i--)
+		loop();
+}
+
 static void check_counters(void)
 {
 	if (is_fep_available())
 		check_emulated_instr();
 
+	warm_up();
 	check_gp_counters();
 	check_fixed_counters();
 	check_rdpmc();
-- 
2.40.1


