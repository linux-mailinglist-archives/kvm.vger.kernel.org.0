Return-Path: <kvm+bounces-7120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EAB83D6BC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 690AB1C29E3F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D569214E2EC;
	Fri, 26 Jan 2024 08:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XGQ0/Pw4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C353744C91;
	Fri, 26 Jan 2024 08:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259505; cv=none; b=Ccb7XzzImUjnUINKaTg/gEnAHrgyaFunxEOizYjNA1M22CIZl10yRbxhrXt2jTa9bMMRdTfT2TBr1n3I/Oe+ZbrkU2+FVrPJTpBWdoTBZI1/RuKNObjlGy1A0UW5sxMk7VPPh63LWbAo9VfY6IIIEf7KIlxHRLQsutlKVOYbCXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259505; c=relaxed/simple;
	bh=ddpAkYf+SFjOXBfQ8YDzS6ORpXllmgKkQ9QvOpiV49E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n1vr1KN/+rr9N37147WCCfEjeB4II3Hs5cRpEbA1tFklSMKwwBwkHodaIxWqwNPfKHT/GKWAWuK3ip1690NCMFder4HetPcZe+hhqT88H1JdxI3baB8w5h8rYmgM7aBDVH6U5rMCnpA0+TUbU4NSKMvIAqz3OpOVQd/5rWOSEqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XGQ0/Pw4; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259504; x=1737795504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ddpAkYf+SFjOXBfQ8YDzS6ORpXllmgKkQ9QvOpiV49E=;
  b=XGQ0/Pw4JBjsshYnqZaj+QvA4kGdI5hfLF7MHOrzX4+/6suY4AJ116bx
   8lNV+1ERElEMyntt3LeLNQiy0JO55KbbX79wxxhmRla2a6tPuHbirMH7G
   SwVOKEu2bSiKxIdDBMMDTwrbOdvE40NlTV7bX0OrfGBA0pONVyC1vCbUl
   9uKVMVzjN7mTl0IjHI/TlSP5+l2nTCMgSieEItzoF1CyQ84j+rcBx1Slf
   MnlnI/B87BHpPbMhGs7QaUiBhS+Nn9+xyoUWcgMaut3stibfcsZJ4p9i/
   NAC2Oiy2xmg9VdRsprjunw9gH3efdiRTW8Jqqo66vmEewTWPU2htBbRQm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792941"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792941"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310415"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310415"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:58:18 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 33/41] KVM: x86/pmu: Make check_pmu_event_filter() an exported function
Date: Fri, 26 Jan 2024 16:54:36 +0800
Message-Id: <20240126085444.324918-34-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mingwei Zhang <mizhang@google.com>

Make check_pmu_event_filter() exported to usable by vendor modules like
kvm_intel. This is because passthrough PMU intercept the guest writes to
event selectors and directly do the event filter checking inside the vendor
specific set_msr() instead of deferring to the KVM_REQ_PMU handler.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/pmu.c | 3 ++-
 arch/x86/kvm/pmu.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index afc9f7eb3a6b..e7ad97734705 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -356,7 +356,7 @@ static bool is_fixed_event_allowed(struct kvm_x86_pmu_event_filter *filter,
 	return true;
 }
 
-static bool check_pmu_event_filter(struct kvm_pmc *pmc)
+bool check_pmu_event_filter(struct kvm_pmc *pmc)
 {
 	struct kvm_x86_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
@@ -370,6 +370,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 
 	return is_fixed_event_allowed(filter, pmc->idx);
 }
+EXPORT_SYMBOL_GPL(check_pmu_event_filter);
 
 static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a4c0b2e2c24b..6f44fe056368 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -292,6 +292,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
 void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu);
 void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu);
 void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu);
+bool check_pmu_event_filter(struct kvm_pmc *pmc);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
-- 
2.34.1


