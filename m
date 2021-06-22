Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420723B0084
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFVJpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 05:45:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:20211 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229922AbhFVJpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 05:45:43 -0400
IronPort-SDR: mIr1KzEafHCh1RA0SHwTNqjbJeoHPI/7u77hA0k2YR8E6Y1tcJSdpO5orB6A7XelzF4Fo0Y8Gr
 bWtEhBhrWZ4g==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="194330930"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="194330930"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:43:27 -0700
IronPort-SDR: jWF9q99fSRnOSL6wqsTIfSbaLEkYNzI1fFDuGDbKNYafhf9qsCHBJJLIfL1UC3zyPLD5ZD9OGI
 V89JaLrEyg6Q==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="641600124"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:43:23 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        weijiang.yang@intel.com, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V7 02/18] perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
Date:   Tue, 22 Jun 2021 17:42:50 +0800
Message-Id: <20210622094306.8336-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210622094306.8336-1-lingshan.zhu@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
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
index c71af4cfba9b..67eb5983bf80 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2984,5 +2984,6 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->bit_width_fixed	= x86_pmu.cntval_bits;
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
+	cap->pebs_vmx		= x86_pmu.pebs_vmx;
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 430f5743f3ca..211b3767d7e6 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6027,6 +6027,7 @@ __init int intel_pmu_init(void)
 
 	case INTEL_FAM6_ICELAKE_X:
 	case INTEL_FAM6_ICELAKE_D:
+		x86_pmu.pebs_vmx = 1;
 		pmem = true;
 		fallthrough;
 	case INTEL_FAM6_ICELAKE_L:
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index ad87cb36f7c8..d0634b142376 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -796,7 +796,8 @@ struct x86_pmu {
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
index 544f41a179fb..6a6e707905be 100644
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

