Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C861F3D1D92
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 07:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhGVFCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 01:02:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:24019 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230268AbhGVFB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 01:01:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="272686890"
X-IronPort-AV: E=Sophos;i="5.84,260,1620716400"; 
   d="scan'208";a="272686890"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 22:42:32 -0700
X-IronPort-AV: E=Sophos;i="5.84,260,1620716400"; 
   d="scan'208";a="512372308"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 22:42:28 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, boris.ostrvsky@oracle.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V9 02/18] perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
Date:   Thu, 22 Jul 2021 13:41:43 +0800
Message-Id: <20210722054159.4459-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210722054159.4459-1-lingshan.zhu@intel.com>
References: <20210722054159.4459-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The new hardware facility supporting guest PEBS is only available
on Intel Ice Lake Server platforms for now. KVM will check this field
through perf_get_x86_pmu_capability() instead of hard coding the cpu
models in the KVM code. If it is supported, the guest PEBS capability
will be exposed to the guest.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/events/intel/core.c      | 1 +
 arch/x86/events/perf_event.h      | 3 ++-
 arch/x86/include/asm/perf_event.h | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 9a908631f6cc..2240480cef6f 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3011,5 +3011,6 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->bit_width_fixed	= x86_pmu.cntval_bits;
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
+	cap->pebs_vmx		= x86_pmu.pebs_vmx;
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index fb1bd7a0e1a6..da835f5a37e2 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6037,6 +6037,7 @@ __init int intel_pmu_init(void)
 
 	case INTEL_FAM6_ICELAKE_X:
 	case INTEL_FAM6_ICELAKE_D:
+		x86_pmu.pebs_vmx = 1;
 		pmem = true;
 		fallthrough;
 	case INTEL_FAM6_ICELAKE_L:
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 2bf1c7ea2758..68601de166a3 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -797,7 +797,8 @@ struct x86_pmu {
 			pebs_prec_dist		:1,
 			pebs_no_tlb		:1,
 			pebs_no_isolation	:1,
-			pebs_block		:1;
+			pebs_block		:1,
+			pebs_vmx		:1;
 	int		pebs_record_size;
 	int		pebs_buffer_size;
 	int		max_pebs_events;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..42d7bcf1a896 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -192,6 +192,7 @@ struct x86_pmu_capability {
 	int		bit_width_fixed;
 	unsigned int	events_mask;
 	int		events_mask_len;
+	unsigned int	pebs_vmx	:1;
 };
 
 /*
-- 
2.27.0

