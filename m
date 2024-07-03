Return-Path: <kvm+bounces-20876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44CA5924DAB
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:17:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F37C928A628
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4AB60DCF;
	Wed,  3 Jul 2024 02:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BUvEI93f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6814DA14;
	Wed,  3 Jul 2024 02:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972792; cv=none; b=HxWxuGjRG/HSZJbzJc73zcx9nSJ9YzeovJ9/dm1ds5q+v9YUHM89Tys0P/UIz8ubX1erT5V4flLdKUDWBYRAOjKJjXZ8gVNbmK7pqYg7w75DCOzyIvC5su2VvHdH0ukQYRKFRf2WGBe1T0+IuTWKGE77F9fqXCqYzG66sqADAvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972792; c=relaxed/simple;
	bh=R/66LWCs88TWOQNVJu516TgpiQiS0Mu+jzzPoSjZGxI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V/Y0JYoAo54rRqtU1qs1rgMcZ7F5ScdWMC9oQKbPQZ4VraN+NgBYmyAhKnq5U2WMokg0dsOglTGzQLMmRh5lp0afhytBZtdRDEtxXYPoskqTUq2IcGW6NIaOEylDiz2ARmzgMXCa0xswLAHUx8xZrKhJ4kFBr5wUGgiy1hKvhAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BUvEI93f; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972791; x=1751508791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R/66LWCs88TWOQNVJu516TgpiQiS0Mu+jzzPoSjZGxI=;
  b=BUvEI93feRq6wWlPl0GyBJdyueEKILxIeC+1tbBYn+Bl0qsVVesUcStW
   Bj1VqVvi00Y8sBY4htklxP0EQ8dljKXdt5OtpRiI1ie3wTd+GO2DnNyIt
   CmLlokdcpEzzkaoVgVhQDFVZ4Q7pGfzr/d1SO5Qp8uaFRTaT75PEk5PUk
   Fq5hmdfdeu9cExwandLjvEoiFD43hFFFjXFkTEqkArBX4wUMJs3YXUggP
   Tu+rEyQpo3/PIN41C9CfzOASCBzQSzpwcgW811e2P232c02M6me65cMsK
   J5ZFWzShYF0xY9LbHHIWvJQBJpAJXGV09hzfIJXV+WOdIeBbJ5Fw0jbM4
   Q==;
X-CSE-ConnectionGUID: A/ROQL5LQvWj5haLZy97Zw==
X-CSE-MsgGUID: I84gjheIQC+dzAH+wzalwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311118"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311118"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:11 -0700
X-CSE-ConnectionGUID: AY+RhEBlQG6juZH8ct7iuw==
X-CSE-MsgGUID: +0mkDRPLReG86c7JWvhPPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148770"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:13:08 -0700
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
Subject: [Patch v5 14/18] x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy CPUs
Date: Wed,  3 Jul 2024 09:57:08 +0000
Message-Id: <20240703095712.64202-15-dapeng1.mi@linux.intel.com>
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

For these legacy Intel CPUs without clflush/clflushopt support, there is
on way to force to trigger a LLC miss and the measured llc misses is
possible to be 0. Thus adjust the lower boundary of llc-misses event to
0 to avoid possible false positive.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index 799d8d5c..c9c5fc19 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -82,6 +82,7 @@ struct pmu_event {
 enum {
 	INTEL_INSTRUCTIONS_IDX  = 1,
 	INTEL_REF_CYCLES_IDX	= 2,
+	INTEL_LLC_MISSES_IDX	= 4,
 	INTEL_BRANCHES_IDX	= 5,
 };
 
@@ -877,6 +878,15 @@ int main(int ac, char **av)
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


