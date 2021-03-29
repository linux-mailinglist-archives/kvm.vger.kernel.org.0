Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CAA34C32E
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 07:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhC2Ftk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 01:49:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:15632 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhC2Ft2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 01:49:28 -0400
IronPort-SDR: 0viyCxzUsbqQCWCHQkE4OKWt7i49TgllzZY08vquI8PVM3E2NPnTEftUBOvIDjH6FugfEMaV/L
 p1UuteD0K4YA==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="255478709"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="255478709"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 22:49:27 -0700
IronPort-SDR: 5DGESYEAgWUbBzkfQlAiWkXU2FXzba3V1jdjOY+wT/G7KdHr25rKpbs9G9GMeGTtJhpFGvKvom
 uJ4sAb5ayHBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="417506679"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2021 22:49:24 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     eranian@google.com, andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v4 01/16] perf/x86/intel: Add x86_pmu.pebs_vmx for Ice Lake Servers
Date:   Mon, 29 Mar 2021 13:41:22 +0800
Message-Id: <20210329054137.120994-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329054137.120994-1-like.xu@linux.intel.com>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new hardware facility supporting guest PEBS is only available
on Intel Ice Lake Server platforms for now. KVM will check this field
through perf_get_x86_pmu_capability() instead of hard coding the cpu
models in the KVM code. If it is supported, the guest PBES capability
will be exposed to the guest.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/events/intel/core.c      | 1 +
 arch/x86/events/perf_event.h      | 3 ++-
 arch/x86/include/asm/perf_event.h | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 18df17129695..06bef6ba8a9b 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2776,5 +2776,6 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->bit_width_fixed	= x86_pmu.cntval_bits;
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
+	cap->pebs_vmx		= x86_pmu.pebs_vmx;
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 7bbb5bb98d8c..591d60cc8436 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5574,6 +5574,7 @@ __init int intel_pmu_init(void)
 
 	case INTEL_FAM6_ICELAKE_X:
 	case INTEL_FAM6_ICELAKE_D:
+		x86_pmu.pebs_vmx = 1;
 		pmem = true;
 		fallthrough;
 	case INTEL_FAM6_ICELAKE_L:
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 53b2b5fc23bc..85dc4e1d4514 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -729,7 +729,8 @@ struct x86_pmu {
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
2.29.2

