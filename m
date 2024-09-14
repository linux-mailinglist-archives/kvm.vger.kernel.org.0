Return-Path: <kvm+bounces-26910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF3F0978EB6
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A151D28AA9D
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064211D0DD1;
	Sat, 14 Sep 2024 07:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bkMNjsMW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB751D0972;
	Sat, 14 Sep 2024 07:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297314; cv=none; b=aQ14rG5DQMcGxE1a2urmP3oBd8ICK44IxrRdmkoRLaG64XE6omNMTK7hoQ6INJVBZWI+r0uqMZaQnV5v006FRIQZlDlR+u4WNY2Gdc5K3n3wCvSaOCvLaM96WdJaLAm0CEfERQE1BMFoQIJZUoKMTAv7wr8kvhrBnPokaJRb8d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297314; c=relaxed/simple;
	bh=6rkU41q/MyT0y9yMobn5IXzrkBZx/aO+BTHMgn2NnYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iBzOuuDbdsfMejesGCAR4PsUA0NsZ2r0dUvqikhYwGHKj1JolCX1jiCxLO7JxLURWCkv0DN2kwu1R9G7jcKAkFfyrZNajPU0zVN+j3PgX+dR+sMnVi6LzUNeFRS4KnDcWBmYzCOKQSWyCIKJdHcZFDMHeLVlczDNtpUr7yDbyDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bkMNjsMW; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297313; x=1757833313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6rkU41q/MyT0y9yMobn5IXzrkBZx/aO+BTHMgn2NnYU=;
  b=bkMNjsMWGm0u1WAHuu8NiTjdvJIgq3hpInfxhHYc57aQIsga2yFs8O+S
   c15mwOMpBMlMpWu0EOqJ/jE3rrPjNpWZJTtPwB5waWjb3tH2on1mERECi
   HxBQu35UVxdkFNfc/ENzISxph3uh0MH9AbX6Egr1i4oZqa/BFZNA710mx
   u8KUzFTOqvkFc/UJ5Z4KUV4iksl/XUINWuXbpre3l1uEGNRJtUdDqFDVt
   Cmn3n3tRBmHfeyYPkV63A/vTLeTODjRu/ni2DE/ewD4+c1MbJAPvdaF8Z
   HOp553xNlY9VCbnn3g67VIVJeKduw/oEzi1iHNYw1USwBiKBB2vF6guag
   A==;
X-CSE-ConnectionGUID: MY+juHGRT3ik3e12cp0Rew==
X-CSE-MsgGUID: Ed8uzmJeSy6BAFMO665Ncg==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778874"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778874"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:53 -0700
X-CSE-ConnectionGUID: RJiyu6iFRfOHfoErH0Qf7Q==
X-CSE-MsgGUID: qDd4tpmRTemmeyynpoIaaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67951004"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:50 -0700
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
Subject: [kvm-unit-tests patch v6 15/18] x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy CPUs
Date: Sat, 14 Sep 2024 10:17:25 +0000
Message-Id: <20240914101728.33148-16-dapeng1.mi@linux.intel.com>
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

For these legacy Intel CPUs without clflush/clflushopt support, there is
on way to force to trigger a LLC miss and the measured llc misses is
possible to be 0. Thus adjust the lower boundary of llc-misses event to
0 to avoid possible false positive.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index c9160423..47b6305d 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -82,6 +82,7 @@ struct pmu_event {
 enum {
 	INTEL_INSTRUCTIONS_IDX  = 1,
 	INTEL_REF_CYCLES_IDX	= 2,
+	INTEL_LLC_MISSES_IDX	= 4,
 	INTEL_BRANCHES_IDX	= 5,
 };
 
@@ -892,6 +893,15 @@ int main(int ac, char **av)
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 		instruction_idx = INTEL_INSTRUCTIONS_IDX;
 		branch_idx = INTEL_BRANCHES_IDX;
+
+		/*
+		 * For legacy Intel CPUS without clflush/clflushopt support,
+		 * there is no way to force to trigger a LLC miss, thus set
+		 * the minimum value to 0 to avoid false positives.
+		 */
+		if (!this_cpu_has(X86_FEATURE_CLFLUSH))
+			gp_events[INTEL_LLC_MISSES_IDX].min = 0;
+
 		report_prefix_push("Intel");
 		set_ref_cycle_expectations();
 	} else {
-- 
2.40.1


