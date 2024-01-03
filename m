Return-Path: <kvm+bounces-5495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0605682276D
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9170B1C22C4D
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4651E18C27;
	Wed,  3 Jan 2024 03:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D5/T5KqO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A0818B19;
	Wed,  3 Jan 2024 03:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251388; x=1735787388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F3O1AGqo4cde/C+vvkiVvkwpaA4RYdhbUZBoJXM9NzA=;
  b=D5/T5KqO74nRN2APVdosF+a9fmAEVPzKg/rc49utwVITDt8uC22eFCeI
   FCH0NnYgYDE1ojSYOzoQTUfGfsgbqGp03HsLiPsh0/VmhHLKOLfNsw1s8
   B94nZqRwNZjkXxnddxTbDLwre2Rja2MSBb7zTOW3ux/v4scOHPrVQDa6i
   8eD9ZE3mKnke7iPpsP9SsB/c8u7mfAI90Fsk9eUjrn2vuknZQETs4/9t1
   GtI04F40G7RlrQ6y1pZbXaqahefGxWjXw+ZT0wyRb7z8jgnA7WoWUGbX9
   WJdz92Spb61bFQwkUaZrW/60zS8YIhgxoj8h3qmSi+MJQILFL6fDYt096
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343143"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343143"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:09:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729665941"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729665941"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:09:44 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v3 05/11] x86: pmu: Refine fixed_events[] names
Date: Wed,  3 Jan 2024 11:14:03 +0800
Message-Id: <20240103031409.2504051-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
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

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 67ebfbe55b49..a2c64a1ce95b 100644
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


