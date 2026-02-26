Return-Path: <kvm+bounces-72103-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YOPTH2XUoGmrnAQAu9opvQ
	(envelope-from <kvm+bounces-72103-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:16:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 289F51B0D66
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:16:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECA1330FBD9E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0946450903;
	Thu, 26 Feb 2026 23:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ig4AWrdN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80770399029;
	Thu, 26 Feb 2026 23:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772147682; cv=none; b=PjecIDOGwdY7xgyptcmJR6IVICZHSyxuQPjEejacCamzzhFCesuJPCG93An844Y6yGi63TZyuVtS7y6fzARX1yCvAVYeG3kp1xhGwjtia2KHp0ddmrDeNL42NqmuOlvjzUYvUvHlqnZ36zb7PTObuJy3Yh83rx7tniI3OCfD6KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772147682; c=relaxed/simple;
	bh=PrNmpgIk9ri24U7Dkk7eSCxhGilPGCS5C5ipQizqCuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb8zddP0J9DduD+LeSKDe6cOzCyZRGLl8f3DN7a1VKtF58PfUU6Dv3+NbqLd1HV7nS8b2pnVKpjyaK2nu6LY7wSNYYSq3Uaq9jaiKHksGaJR3ajgEnuovj9TIU2qhahwFLjKTb9EFve2MdVbf9wSU2TRWyi2uFn/zhaw8vEXiZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ig4AWrdN; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772147680; x=1803683680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PrNmpgIk9ri24U7Dkk7eSCxhGilPGCS5C5ipQizqCuE=;
  b=Ig4AWrdNi1RZroAY0QrVBCiwgkPyFgfahXofBkYrTJcsTnv+3niW8MKp
   WzTYcmKfVvyTMZ7iUbsx/kW1rYmnAbujsH/rUJCJ+wcQPD1Cd/cRfn8d1
   iJWBm5uiHAdKHPIhUcav0LhzhuTd98H5h26H/+TWqFdBUKdFO+QZu1ESQ
   78sRXYAxyNBHYtSm8ft1Eumx4MRm+6stO84h6ez3HOUirDehE5UUW4T4/
   mnHIcE2+bKciNFQZV7i4zyDjKZRRhV13F0V5d7lkKfs1LvzyvAp1b9TFE
   osufVUkzsZswr/TI4OcApKsc2SwLd+9dGxQGt2mw2moYpk5uIwYVZsRsN
   Q==;
X-CSE-ConnectionGUID: 82nz7HIhSRK5LWPtWUMgPw==
X-CSE-MsgGUID: gUb8MpOXSa2tHtfOfeFmdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="72928310"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="72928310"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:14:38 -0800
X-CSE-ConnectionGUID: 819KQjRZTSW9ILNUUuWuEg==
X-CSE-MsgGUID: pMkwzEE+RB29pn6fugnVcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="221340136"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:14:38 -0800
From: Zide Chen <zide.chen@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Falcon Thomas <thomas.falcon@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH 1/3] KVM: x86/pmu: Do not map fixed counters >= 3 to generic perf events
Date: Thu, 26 Feb 2026 15:06:04 -0800
Message-ID: <20260226230606.146532-2-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260226230606.146532-1-zide.chen@intel.com>
References: <20260226230606.146532-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72103-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 289F51B0D66
X-Rspamd-Action: no action

Only fixed counters 0..2 have matching generic cross-platform
hardware perf events (INSTRUCTIONS, CPU_CYCLES, REF_CPU_CYCLES).
Therefore, perf_get_hw_event_config() is only applicable to these
counters.

KVM does not intend to emulate fixed counters >= 3 on legacy
(non-mediated) vPMU, while for mediated vPMU, KVM does not care what
the fixed counter event mappings are.  Therefore, return 0 for their
eventsel.

Also remove __always_inline as BUILD_BUG_ON() is no longer needed.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 27eb76e6b6a0..4bfd16a9e6c7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -454,28 +454,30 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  * different perf_event is already utilizing the requested counter, but the end
  * result is the same (ignoring the fact that using a general purpose counter
  * will likely exacerbate counter contention).
- *
- * Forcibly inlined to allow asserting on @index at build time, and there should
- * never be more than one user.
  */
-static __always_inline u64 intel_get_fixed_pmc_eventsel(unsigned int index)
+static u64 intel_get_fixed_pmc_eventsel(unsigned int index)
 {
 	const enum perf_hw_id fixed_pmc_perf_ids[] = {
 		[0] = PERF_COUNT_HW_INSTRUCTIONS,
 		[1] = PERF_COUNT_HW_CPU_CYCLES,
 		[2] = PERF_COUNT_HW_REF_CPU_CYCLES,
 	};
-	u64 eventsel;
-
-	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_perf_ids) != KVM_MAX_NR_INTEL_FIXED_COUNTERS);
-	BUILD_BUG_ON(index >= KVM_MAX_NR_INTEL_FIXED_COUNTERS);
+	u64 eventsel = 0;
 
 	/*
-	 * Yell if perf reports support for a fixed counter but perf doesn't
-	 * have a known encoding for the associated general purpose event.
+	 * Fixed counters 3 and above don't have corresponding generic hardware
+	 * perf event, and KVM does not intend to emulate them on non-mediated
+	 * vPMU.
 	 */
-	eventsel = perf_get_hw_event_config(fixed_pmc_perf_ids[index]);
-	WARN_ON_ONCE(!eventsel && index < kvm_pmu_cap.num_counters_fixed);
+	if (index < 3) {
+		/*
+		 * Yell if perf reports support for a fixed counter but perf
+		 * doesn't have a known encoding for the associated general
+		 * purpose event.
+		 */
+		eventsel = perf_get_hw_event_config(fixed_pmc_perf_ids[index]);
+		WARN_ON_ONCE(!eventsel && index < kvm_pmu_cap.num_counters_fixed);
+	}
 	return eventsel;
 }
 
-- 
2.53.0


