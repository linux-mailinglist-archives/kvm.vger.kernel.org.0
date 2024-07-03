Return-Path: <kvm+bounces-20871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1C25924DA0
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EB54288C67
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07413BBEA;
	Wed,  3 Jul 2024 02:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jju5YqwL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A592C3CF73;
	Wed,  3 Jul 2024 02:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972777; cv=none; b=azEZ56VgWewnsinmrfeBaBb5nOlGpC3hDfGHHQpxDNLwJqrmwM9V4549K18C/sTsfeIDtZiUmmIEf+DWGfx5f/nr3IkEUwVuLCHPEo3sFaz4HZw/CQAoaXEhQr7snd3BOxCpFrKB1y+FTEpWb+qztF3nOrojxng77xXKXhueq2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972777; c=relaxed/simple;
	bh=w5Z2JaEdGhQ6l5mbUkwdeGJcBZrYkCI8yXhRRGVZzsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sGSCZ9VjCkjR+YhsrhE0BHiZFdrofrFa5BfPI7E3sCx0MTnavhyOqixAw1OMvCEAV9fCPZzjOvEtSFj7H+4InAi5Djh6PgllmyK8vDAmHoaZWLSRJPEmixTPB44ft9/ebkiRtFscGOlf4G6xrRvDy1XmschQhNFSsb1LnIPZCgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jju5YqwL; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972775; x=1751508775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w5Z2JaEdGhQ6l5mbUkwdeGJcBZrYkCI8yXhRRGVZzsI=;
  b=jju5YqwLGBs6PcYHZs17HgqSVRKYxlME8420B6KUhVKYfPAgjKPH2q+Q
   BYpBy0obj7xnhV56jizU21/E9GrTcj1YYzmKJMUYTROgjJVh3P/xD3nU2
   sTSkPSa44N2nL+Wtp3eJDS+WjxUM0BW55MBYU0bcrnQ7XTwrdWgOTBzoi
   p4C5UTUOdxTwVnVPxkn8NOS2jtbdX/HL23HItwCRp/ONiWzjBzFOcYvLT
   5nQFEU9LSCPGiUKCq6Vk0qeZCSdeIbANUSdQ3B4u2AU87B2kOu6sLo1A0
   GvJjG7hvkeZr8+ohmxwthTJaJgoEr5OorJxzWDfEr6+nQPA7hE/MfGGsB
   Q==;
X-CSE-ConnectionGUID: MjlSm/g4T3+KFwI9OqXlsA==
X-CSE-MsgGUID: jNz+r+f9R0GWDaC5agGhaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311035"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311035"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:55 -0700
X-CSE-ConnectionGUID: pGwjzXekRhqApxH1OONYbQ==
X-CSE-MsgGUID: B3rNkxElTk+vD8/ZlswCPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148603"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:12:51 -0700
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
Subject: [Patch v5 09/18] x86: pmu: Use macro to replace hard-coded ref-cycles event index
Date: Wed,  3 Jul 2024 09:57:03 +0000
Message-Id: <20240703095712.64202-10-dapeng1.mi@linux.intel.com>
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

Replace hard-coded ref-cycles event index with macro to avoid possible
mismatch issue if new event is added in the future and cause ref-cycles
event index changed, but forget to update the hard-coded ref-cycles
event index.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index d2138567..b7de3b58 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -55,6 +55,7 @@ struct pmu_event {
  * intel_gp_events[].
  */
 enum {
+	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_BRANCHES_IDX	= 5,
 };
 
@@ -699,7 +700,8 @@ static void set_ref_cycle_expectations(void)
 {
 	pmu_counter_t cnt = {
 		.ctr = MSR_IA32_PERFCTR0,
-		.config = EVNTSEL_OS | EVNTSEL_USR | intel_gp_events[2].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  intel_gp_events[INTEL_REF_CYCLES_IDX].unit_sel,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
@@ -735,8 +737,10 @@ static void set_ref_cycle_expectations(void)
 	if (!tsc_delta)
 		return;
 
-	intel_gp_events[2].min = (intel_gp_events[2].min * cnt.count) / tsc_delta;
-	intel_gp_events[2].max = (intel_gp_events[2].max * cnt.count) / tsc_delta;
+	intel_gp_events[INTEL_REF_CYCLES_IDX].min =
+		(intel_gp_events[INTEL_REF_CYCLES_IDX].min * cnt.count) / tsc_delta;
+	intel_gp_events[INTEL_REF_CYCLES_IDX].max =
+		(intel_gp_events[INTEL_REF_CYCLES_IDX].max * cnt.count) / tsc_delta;
 }
 
 static void check_invalid_rdpmc_gp(void)
-- 
2.40.1


