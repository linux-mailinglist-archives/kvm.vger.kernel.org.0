Return-Path: <kvm+bounces-26901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FCAB978EA2
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8DECB21F9A
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7041A1CF2B1;
	Sat, 14 Sep 2024 07:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T/yozKaK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5008E1CDA34;
	Sat, 14 Sep 2024 07:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297285; cv=none; b=OBX7iELdj1SZFH5skmKcnaSkEWCXTY3r9Zeu0eKG/YhRtn1wrE+tH2O7kEbEYRprimgogGvsU68h2jlctGbrEyOl4f/Qw5fsl0m4Vm0eXsougu/2e2qf29tj2Vj2AzP5JhTJA26tfUoT4xjlocH5/FQBgqOas8qeRVkMIJ6Zfow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297285; c=relaxed/simple;
	bh=iP055UHzTX++BXlX72hw/r55PRCSYQxiKzpgOHjSnoo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u7vTSEJLWFkd0iDf6P0b23PQoGfsZpNN54paNbr2PCg+qFHcQwe2UM/x7e28C0OQmLLnN1QlO5KmsRSldIokJGupJYbis5pe6dsy4LG/5ZBannGEwwFbRsKE4YgkrLGyp35Ikf3EfNPyI2QmYZfgK8/IXV2n1lk5J5OE1rdf41E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T/yozKaK; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297284; x=1757833284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iP055UHzTX++BXlX72hw/r55PRCSYQxiKzpgOHjSnoo=;
  b=T/yozKaKigBukGVSvgbJomIBdLwYwoXOYpuWauh2CPoX/AAACwL/lyvR
   f8KFQGlTomTqMF7p040KYHe6Jx8xNlkLjvIe1nPGMGrw64zxEiG/Ud1Wc
   azNUERdKSEMPjX1zrvnGqBZqCDuwzSJG9D1ZFGw2ex6jHUN0HVJOmtnDS
   h6eQ/kS8a4z6ZGvKLKClkgcnKaMrGLmtrKf47ndb67+rSkJ16bdh9a7dk
   rcSaNF4SKZC7j8Y0t77FpOzO7vx4iYQvuxkpTE5z9nG6HiDHR3C2JMFfM
   +YzoYibedGoI/a351Ivr3g654/xxlzZ3SFpP5+QjP3WZ3TuOZEQysBhbl
   g==;
X-CSE-ConnectionGUID: BsEMtTcISNSPi1w+tbGYsQ==
X-CSE-MsgGUID: kx8mAMUwTDq4is2weCJkYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778777"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778777"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:24 -0700
X-CSE-ConnectionGUID: PCvOHz/4SRePr79QUH969Q==
X-CSE-MsgGUID: HM+GwhZSQwmOMGqUluM8kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950908"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:21 -0700
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
Subject: [kvm-unit-tests patch v6 06/18] x86: pmu: Print measured event count if test fails
Date: Sat, 14 Sep 2024 10:17:16 +0000
Message-Id: <20240914101728.33148-7-dapeng1.mi@linux.intel.com>
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

Print the measured event count if the test case fails. This helps users
quickly know why the test case fails.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index b4de2680..53bb7ec0 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -204,8 +204,12 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
-	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
-	return count >= e->min && count <= e->max;
+	bool pass = count >= e->min && count <= e->max;
+
+	if (!pass)
+		printf("FAIL: %d <= %"PRId64" <= %d\n", e->min, count, e->max);
+
+	return pass;
 }
 
 static bool verify_counter(pmu_counter_t *cnt)
-- 
2.40.1


