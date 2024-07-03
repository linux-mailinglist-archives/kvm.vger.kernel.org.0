Return-Path: <kvm+bounces-20867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70AB6924D98
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A3A128684B
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78EC4219E1;
	Wed,  3 Jul 2024 02:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bdhztw1+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ADF1CAA9;
	Wed,  3 Jul 2024 02:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972764; cv=none; b=fiXO94iszDmy2/imN8Xw2ZnddeqUAybxvdfGeyEk1GyQHnsiKGJOtZMtTTgx9HllG2JHW1B8rUow+hPzqzggCek7q9TuqJYjpuc185O5nLU3uoz2ohVoyMAg2qg1NbdMYE+l18RgxUio82cYB7wcFjYlX9VOa8hK3BV2hU/v3PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972764; c=relaxed/simple;
	bh=c/FKtCmCvkZd0M4TkpSHqVExn/0016+qbGWLpWK/BiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iB7pwfifnmNlt14HmJbVR66bL7X5NeSUEIAM/Cz1JkxdRGsxHPR/+G9R9ePg9Dpk14dfjrcyFawupsz/Qk9RLwZZTlRS1x0bGWzaazupl/IBEfrGTyuHRE7grSj+vP8bYA1IEvu5zchfPWC4MX8TkWPzMiJYLhx1BOk5tqsTP10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bdhztw1+; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972763; x=1751508763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c/FKtCmCvkZd0M4TkpSHqVExn/0016+qbGWLpWK/BiA=;
  b=Bdhztw1+sjb63A5OC28Nqz/w+cu++imNp9JtVFQuGLKcFiJtjQI9E1OF
   H13k0urRoETZyWvD+ggE2RcDwEQFfcCdG17Lr0z/HDGY3TFTfZwN5FvpJ
   vut6AhqGumfwxMx6SAAdjLc7k+N/b/HGL/v+BQBVIOxm//c+tlJ7YEYts
   Jnb87C1peSvfku0ZYK1e74F7nKpZ62FbiknrjM2GzpX5bDvKZ/xAnb8An
   +BaWcEARGd3v54nmBVPmy4XcWsnLmJK/1TC0zb0IOZbGNZ4Q62Mff7e5g
   Mi2Pm5md+cDFH9UUEW1pTWyRAHPiYXf9/cKaTKQMNGUsbV05gzDs3pX8C
   w==;
X-CSE-ConnectionGUID: NZn4XQYBSJGKo+dZtUrZsA==
X-CSE-MsgGUID: w3rQZzaBTuOyHbkMOWaUZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17310983"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17310983"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:43 -0700
X-CSE-ConnectionGUID: OT7RmQJQT+KMwQiIVrEg6w==
X-CSE-MsgGUID: 7CRYMr5PTiuB0S2/Ys8y8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148567"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:40 -0700
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
Subject: [Patch v5 05/18] x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
Date: Wed,  3 Jul 2024 09:56:59 +0000
Message-Id: <20240703095712.64202-6-dapeng1.mi@linux.intel.com>
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


