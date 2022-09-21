Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2505C04A2
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiIUQuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiIUQuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:50:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A92E50717;
        Wed, 21 Sep 2022 09:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663778738; x=1695314738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=csO58O6YHCh8TiEHFgaWlEB977WasEpvat7SJQLp5Uo=;
  b=Kme6qetrpYsjWh/SyU3Saf9JChli76OOCaJXHNCoQdfBJTAyMvXWHVIQ
   mEK/2l+zDhsKYj8lUF1HmmMEnRk3hGTD+qTyNyULscvi1NlATCMdRaWXc
   pdI25Aol8kHe9BgBSNrWvYtb8erPhHFYz+mb44YEMGHW980zkFbB2Qayx
   ZgYeIvHb7InfHBiSNXbdjHDyF2HnCpQ2S3pNq7YexxhDYpZZx7WTjKoY8
   lDaIdw6XLzFr+W3iocqsMgYKOwuEpkFqZ6gpd/lRCyhP02IL7avSGIOeJ
   lPvib5gQmJHbGD2RSs5+qpRKTGm4A3NjE+IkJYl/2SKf2JyR2WAZroUMX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300044983"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="300044983"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 09:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="948227934"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 21 Sep 2022 09:45:28 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, wei.w.wang@intel.com,
        kan.liang@linux.intel.com
Cc:     xiaoyao.li@intel.com, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export pt_get_curr_event()
Date:   Thu, 22 Sep 2022 00:45:20 +0800
Message-Id: <20220921164521.2858932-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220921164521.2858932-1-xiaoyao.li@intel.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM supports PT_MODE_HOST_GUEST mode for Intel PT where host and guest
have separate Intel PT configurations and they work independently.

Currently, in this mode, when both host and guest enable PT, KVM manually
clears MSR_IA32_RTIT_CTL.TRACEEN to disable host PT so that it can
context switch the other PT MSRs. However, PT PMI can be delivered after
this point and before the VM-entry. As a result, the re-enabling of PT
leads to VM-entry failure of guest.

To solve the problem, introduce and export pt_get_curr_event() for KVM
to get current pt event. Along with perf_event_{dis, en}able_local(),
With them, KVM can avoid PT re-enabling in PT PMI handler.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/events/intel/pt.c        | 8 ++++++++
 arch/x86/include/asm/perf_event.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 82ef87e9a897..62bfc45c11c9 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1624,6 +1624,14 @@ static void pt_event_stop(struct perf_event *event, int mode)
 	}
 }
 
+struct perf_event *pt_get_curr_event(void)
+{
+	struct pt *pt = this_cpu_ptr(&pt_ctx);
+
+	return pt->handle.event;
+}
+EXPORT_SYMBOL_GPL(pt_get_curr_event);
+
 static long pt_event_snapshot_aux(struct perf_event *event,
 				  struct perf_output_handle *handle,
 				  unsigned long size)
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f6fc8dd51ef4..7c3533392cf5 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -553,11 +553,13 @@ static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 
 #ifdef CONFIG_CPU_SUP_INTEL
  extern void intel_pt_handle_vmx(int on);
+ extern struct perf_event *pt_get_curr_event(void);
 #else
 static inline void intel_pt_handle_vmx(int on)
 {
 
 }
+struct perf_event *pt_get_curr_event(void) { return NULL; }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
-- 
2.27.0

