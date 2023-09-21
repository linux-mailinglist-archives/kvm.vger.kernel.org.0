Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61F17A9FC0
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbjIUU1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjIUU0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:26:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02DA266FB
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318600; x=1726854600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IucKdVxoy2TAG2qynrJ/+2Adc5kZGk23C/Tq5g823xs=;
  b=XNEod4OJoS1ctMsSTqeGyCcEgdNLifgZeQ5iM+SrAKGpEf3BSmD6y+uT
   Ax9Y7qIGnieNs+3bVxKlMHEhFIP/qrMG5TuQxTPyho6fCPdW2vKnoGZrn
   uGRMRJSpcWS+ioC6R9o1h1lxezp4C1UHBrAm4NRMqz0cMjoqlfYQpcjsG
   y9Bmx33kaxLNz1aSt0rOUNuOUdRQWTZC326b8n4bVUKxL+cDwUPefJIfy
   IlrGGCEYLlg4LovYOizLM9+Sa6jlWHTLIHa+2gfLB0fd9VsG0Ioi6HoFE
   8Xhppa2EEMRr9zN8C8sCMeN3Plv4t+Cg0fYtIJPsqVv2GdZKBNg400I8v
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841378"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841378"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747001164"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747001164"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:16 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 7/9] KVM: x86/pmu: Add fixed counter enumeration for pmu v5
Date:   Thu, 21 Sep 2023 16:29:55 +0800
Message-Id: <20230921082957.44628-8-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230921082957.44628-1-xiong.y.zhang@intel.com>
References: <20230921082957.44628-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With Arch PMU v5, CPUID.0AH.ECX is a bit mask which enumerates the
supported Fixed Counters. If bit 'i' is set, it implies that Fixed
Counter 'i' is supported.

This commit add CPUID.0AH.ECX emulation for vPMU version 5, KVM
support Fixed Counter enumeration starting from 0 by default,
user could modify it through SET_CPUID2 ioctl.

When perf driver supports fixed counter bitmap and exports it,
KVM will get it from perf driver, and set it as
KVM supported CPUID.0AH.ECX.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/cpuid.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0544e30b4946..e10844e2f211 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1004,7 +1004,15 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		entry->eax = eax.full;
 		entry->ebx = kvm_pmu_cap.events_mask;
-		entry->ecx = 0;
+		if (kvm_pmu_cap.version < 5)
+			entry->ecx = 0;
+		else
+			/*
+			 * Todo: When perf driver supports Fixed counter bitmap
+			 * and export it, KVM will get it from perf driver and set
+			 * it into entry->ecx.
+			 */
+			entry->ecx = (1ULL << kvm_pmu_cap.num_counters_fixed) - 1;
 		entry->edx = edx.full;
 		break;
 	}
-- 
2.34.1

