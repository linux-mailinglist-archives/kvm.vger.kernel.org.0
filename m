Return-Path: <kvm+bounces-8981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF3A859492
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 05:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 893AD1C215C2
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 04:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6804C61;
	Sun, 18 Feb 2024 04:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wtdayv0s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACF31849;
	Sun, 18 Feb 2024 04:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708230166; cv=none; b=UeNMCzdMtG63nQxBcDom73drCo4xMs2gMZdj84cHVDA3xGCo2Bx9FpNbeXCnaPY3GTxonEKxBBzYQbsyEiTovrGQkD/pLFZZkldtBZaDn97vC5EnBYRulFWsIIsKyLJpOi3MfnRKZqBS518h2kVhCqk9htE6SMV0OkbIJ0lTtaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708230166; c=relaxed/simple;
	bh=L910vuA1nInbN44R4e4ypYcqnk/4FDV5+y2YMJ9WPsE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eIKSRsPy4E5Uz5Gw7di+1JBzuv+Slt+PQYzc9nfNuKDTD9OXKb0qHSamuVFxbLFQMOOG/iCVWcDwfxX7y7HSNq/oj1yCz9KzpFHufIjuId/lDy+DbeJaoNiA+jFXmU20YJE5AcZ7TnS5G1F2bdrM/Af8hx0wEhm60KaWTuY/bSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wtdayv0s; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708230165; x=1739766165;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=L910vuA1nInbN44R4e4ypYcqnk/4FDV5+y2YMJ9WPsE=;
  b=Wtdayv0s8jk9GDntxPsIMRP7jxCpedpNNsZGYRTWXMi6BwKBVvMiRlaN
   HoZ2CK4qWztGfTJUgieFpjGCY9Y6WsNCB2pCLNp9zJVk4ANTr33FzTssI
   TKVYbIKbhQyHFb5tVrPAq54z+scNAxTZHaub7tDkdx7I4Itq5mnb5WiyD
   IDmMDiH/RzswY/zcLRCZcr4eo952NFaGo4yXS9WdyGEoTFOc+kgKT8OKp
   o2rdh07fJUuDClMcF/bVlguI9kldFaNF7G+W/vPY9P5VgY3QTu62KqvO1
   7au6aOAsKzhEMRvpCT1ZyMXi/+fg0RSl0rgcVdaGtfxvWpOqLrcHm1IRT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10987"; a="2189219"
X-IronPort-AV: E=Sophos;i="6.06,167,1705392000"; 
   d="scan'208";a="2189219"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2024 20:22:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,167,1705392000"; 
   d="scan'208";a="4338402"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmviesa008.fm.intel.com with ESMTP; 17 Feb 2024 20:22:41 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kan Liang <kan.liang@linux.intel.com>,
	Jim Mattson <jmattson@google.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v2] KVM: selftests: Test top-down slots event
Date: Sun, 18 Feb 2024 12:30:03 +0800
Message-Id: <20240218043003.2424683-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although the fixed counter 3 and its exclusive pseudo slots event are
not supported by KVM yet, the architectural slots event is supported by
KVM and can be programed on any GP counter. Thus add validation for this
architectural slots event.

Top-down slots event "counts the total number of available slots for an
unhalted logical processor, and increments by machine-width of the
narrowest pipeline as employed by the Top-down Microarchitecture
Analysis method."

As for the slot, it's an abstract concept which indicates how many
uops (decoded from instructions) can be processed simultaneously
(per cycle) on HW. In Top-down Microarchitecture Analysis (TMA) method,
the processor is divided into two parts, frond-end and back-end. Assume
there is a processor with classic 5-stage pipeline, fetch, decode,
execute, memory access and register writeback. The former 2 stages
(fetch/decode) are classified to frond-end and the latter 3 stages are
classified to back-end.

In modern Intel processors, a complicated instruction would be decoded
into several uops (micro-operations) and so these uops can be processed
simultaneously and then improve the performance. Thus, assume a
processor can decode and dispatch 4 uops in front-end and execute 4 uops
in back-end simultaneously (per-cycle), so the machine-width of this
processor is 4 and this processor has 4 topdown slots per-cycle.

If a slot is spare and can be used to process a new upcoming uop, then
the slot is available, but if a uop occupies a slot for several cycles
and can't be retired (maybe blocked by memory access), then this slot is
stall and unavailable.

Considering the testing instruction sequence can't be macro-fused on x86
platforms, the measured slots count should not be less than
NUM_INSNS_RETIRED. Thus assert the slots count against NUM_INSNS_RETIRED.

pmu_counters_test passed with this patch on Intel Sapphire Rapids.

About the more information about TMA method, please refer the below link.
https://www.intel.com/content/www/us/en/docs/vtune-profiler/cookbook/2023-0/top-down-microarchitecture-analysis-method.html

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index ae5f6042f1e8..29609b52f8fa 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -119,6 +119,9 @@ static void guest_assert_event_count(uint8_t idx,
 	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
 		GUEST_ASSERT_NE(count, 0);
 		break;
+	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
+		GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
+		break;
 	default:
 		break;
 	}

base-commit: f0f3b810edda57f317d79f452056786257089667
-- 
2.40.1


