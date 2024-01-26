Return-Path: <kvm+bounces-7107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0A883D698
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A08B8B2B3D2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFFC1468E9;
	Fri, 26 Jan 2024 08:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxXu+7Dd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10412CCBA;
	Fri, 26 Jan 2024 08:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259439; cv=none; b=nmJIWJc+CQ8QIPJZ0IzJ+0qbvQH8lPxMS/kBSde531IENXWSobvuRMrxdwO5yezJg+TqDUNtdte+HAp2QMBw64kafGBImyBjU0vU+vti5kJzkxkmV7oAl1MRsF+80pdgkjjrw6fhloQBashU+SQ3IIKkOkM12pg99Ri4Fc75NI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259439; c=relaxed/simple;
	bh=n7VLnKBVL7xRAaVFEomROGAnaAnnwE6pOBxo0lUgP7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pFNlhehUZidhvE5lSTRTliOuOs0rNh12p7VS9lGjqBl4/1XtUMXwfmg2NzdIWmtRoS9bo8axBty06R8YZKS62j5SSgHODaDhOct/nXTupXiqlE4CVZPAVDWtffoFb5qjvr3zftS01hcQ680xt3Xc8auayjvcy5GKdye1xcJ2Ghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BxXu+7Dd; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259438; x=1737795438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n7VLnKBVL7xRAaVFEomROGAnaAnnwE6pOBxo0lUgP7k=;
  b=BxXu+7DdeRHvRviwoxC4mlxNtbXqJ0y4acTyf8ENVeHELfQwie0ygTCj
   YQuZwqthDt6LjDlf5DHXG8O1qfZ45qzdnAdlLxYyl7xbEGCc6ePkBlq1t
   KDGHTRryis/EGMyjDB1m7G6F27wCEIEUE9ZJgSKCUieZrKzSwgQr2I5et
   XqGIyxYowiOddUVvauOpyziN0X1ztgYRAcbjAaWFDPsxRy0Cab9mBYLh2
   ClwpjHYKREYBsmNMm9aRK6OFLzp2peml3nkfO/KsNPoaMhbVJUrtlGdsD
   6K2dKywLsDhFDqfyVD6DbWyMy6dynuihTbIGxEgPUurNo4YxtcTzbH35o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792632"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792632"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310111"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310111"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:12 -0800
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
Subject: [RFC PATCH 20/41] KVM: x86/pmu: Introduce PMU operation prototypes for save/restore PMU context
Date: Fri, 26 Jan 2024 16:54:23 +0800
Message-Id: <20240126085444.324918-21-xiong.y.zhang@linux.intel.com>
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

Plumb through kvm_pmu_ops with these two extra functions to allow pmu
context switch.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  2 ++
 arch/x86/kvm/pmu.c                     | 14 ++++++++++++++
 arch/x86/kvm/pmu.h                     |  4 ++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index a2acf0afee5d..ee201ac95f57 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -26,6 +26,8 @@ KVM_X86_PMU_OP(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
+KVM_X86_PMU_OP_OPTIONAL(save_pmu_context)
+KVM_X86_PMU_OP_OPTIONAL(restore_pmu_context)
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d83746f93392..9d737f5b96bf 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -898,3 +898,17 @@ void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
 {
 	static_call_cond(kvm_x86_pmu_passthrough_pmu_msrs)(vcpu);
 }
+
+void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+
+	static_call_cond(kvm_x86_pmu_save_pmu_context)(vcpu);
+}
+
+void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+
+	static_call_cond(kvm_x86_pmu_restore_pmu_context)(vcpu);
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index d575808c7258..a4c0b2e2c24b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -34,6 +34,8 @@ struct kvm_pmu_ops {
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 	void (*passthrough_pmu_msrs)(struct kvm_vcpu *vcpu);
+	void (*save_pmu_context)(struct kvm_vcpu *vcpu);
+	void (*restore_pmu_context)(struct kvm_vcpu *vcpu);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
@@ -288,6 +290,8 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
 void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu);
+void kvm_pmu_save_pmu_context(struct kvm_vcpu *vcpu);
+void kvm_pmu_restore_pmu_context(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
-- 
2.34.1


