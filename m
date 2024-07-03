Return-Path: <kvm+bounces-20881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B655924DB6
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 409F61F26803
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EC11339A4;
	Wed,  3 Jul 2024 02:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IbELz3Nb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4378F131732;
	Wed,  3 Jul 2024 02:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972804; cv=none; b=brVZ2L1rijF646ks+VnhZtq1WyaY9QqSrCB5vlz5oZkcIZ2iJRPNckJRvBCmJEhhbhmz7pGxhnK4FnTzef/Gqr/vDax2x7Ws6vT2jo0wCgS7KIxocuhaBPjsbloiwX4R8EAgcLiCd1gav2JhM8B9lyB06RL9d9HuanCvzfBGj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972804; c=relaxed/simple;
	bh=yEZEiccp3WYNeQ6RfmFNlJurYbV/2aQkHtlCt84nI4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cF6M4fOmfCXafcsPesDCWvS6Pk65AGooBBzvWbebIN0J7ImYO1nHnN8pXfyFN46Xg5OTr2q8KpOMj6zHzdIGelHASVcu2eHnNMOAk1Y6V3FJS+LLsJbq4vM/9BuOYmScoSjspVno2pFrM8leeDz1MWZ+/ZDDUFjzUGtsSp6Ye+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IbELz3Nb; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972803; x=1751508803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yEZEiccp3WYNeQ6RfmFNlJurYbV/2aQkHtlCt84nI4k=;
  b=IbELz3Nb22z9xRaDItXLxUtiTyTdL+yJKs0attkfQdOqi0A4EwgeETP4
   tt7YjAfyM7CGZ0AjS3ZCIXumVbc4W0uso/9kN7m5evU+cqp9golW3Lg0c
   D8G3pkQkRC5TYS47ASEG3E/OlFNc03cgYPoU6108qzhWGWuPFYlfIU3z9
   nI2OstALFhLeJLtT43hSSQ349lmxgMObMnVsveQTu8OhldifrBu+gnjXs
   /uZ8IO8D9WvBhGqDJZ6Qd8psqjbKYuVGBWXiQ4+JDXc498knO+9U/jlyT
   bcGzKQuMc9kdn/Bcsekumd/cF4suAZqEP5hCLUB75b2uuWZTTdcpKkG3W
   g==;
X-CSE-ConnectionGUID: 4XYuXgp/SiOgrqwFFrXQpg==
X-CSE-MsgGUID: 9PvsLcdPQsO67wFX5Q0ytg==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311148"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311148"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:23 -0700
X-CSE-ConnectionGUID: /w4k3O+bSwu20NIZV9QPiA==
X-CSE-MsgGUID: EqIfOJT6TcSDto4BJYD4Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148892"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:13:20 -0700
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
Subject: [Patch v5 18/18] x86: pmu: Print measured event count if test fails
Date: Wed,  3 Jul 2024 09:57:12 +0000
Message-Id: <20240703095712.64202-19-dapeng1.mi@linux.intel.com>
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

Print the measured event count if the test case fails. This helps users
quickly know why the test case fails.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 332d274c..0658a1c1 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -398,8 +398,12 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 
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


