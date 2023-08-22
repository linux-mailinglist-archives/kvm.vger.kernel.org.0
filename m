Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18DD783916
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbjHVFHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjHVFH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:07:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57073E42;
        Mon, 21 Aug 2023 22:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692680821; x=1724216821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FjGrlNIY+vShUtvCpATT+KcAnzFBFFjm1ThsnaWT4H0=;
  b=hL4xq9lgsSQmr0QH2YrhYekw7P1RpYJJFmTc+LXHKeTpoqWfk8acJwhn
   EdlkNdZJ/UUIT1yZ4UX6VrimqPCmcKhjCFjYNahHRrQUjjYivi0muxx63
   dNqBgXVOi/+NsrYFIYLHcLnFH6WhHgGXz+Mxugyv6Efsw9dzHQ5Ux2eUB
   MsYV2pE/nOoAbhK2GOx1A7wds4RbGxONlfnCgtcZ/feuMV6jvGnpwfWz/
   PnyLe4dQdyRoI0eYsJfSk+9XVBlL3ddBCBFzsW/vcgmFWgtorxetSXFVf
   GVvRJjUETzXHJPZKAHXB/D/HLun3cATQObyZgZtDHiGsimJCUVE2wMexm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440146780"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440146780"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 22:05:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982737043"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982737043"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2023 22:05:12 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH RFC v3 13/13] KVM: x86/pmu: Expose Topdown in MSR_IA32_PERF_CAPABILITIES
Date:   Tue, 22 Aug 2023 13:11:40 +0800
Message-Id: <20230822051140.512879-14-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
References: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Topdown support is enumerated via IA32_PERF_CAPABILITIES[bit 15]. Enable
this bit for guest when the feature is available on host.

Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 3 +++
 arch/x86/kvm/vmx/vmx.c       | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 04ccb8c6f7e4..5783cde00054 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -614,6 +614,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
 	pmu->global_ctrl_mask = counter_mask;
 
+	if (intel_pmu_metrics_is_enabled(vcpu))
+		pmu->global_ctrl_mask &= ~(1ULL << GLOBAL_CTRL_EN_PERF_METRICS);
+
 	/*
 	 * GLOBAL_STATUS and GLOBAL_OVF_CONTROL (a.k.a. GLOBAL_STATUS_RESET)
 	 * share reserved bit definitions.  The kernel just happens to use
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e6849f780dba..69a425be55bf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7827,6 +7827,8 @@ static u64 vmx_get_perf_capabilities(void)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
 	}
 
+	perf_cap |= host_perf_cap & PMU_CAP_PERF_METRICS;
+
 	return perf_cap;
 }
 
-- 
2.34.1

