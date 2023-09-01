Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D4F78F91E
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348498AbjIAHaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238793AbjIAHaC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:30:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D0F171E
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693553381; x=1725089381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cRvvaoqt29ES3Mx7bTKA8fiZt2RGm+2unAl9XvbkbdE=;
  b=A0COPPA764zwm0y/PH8c8NCr+n+p5s9z/8BkJaiDAGqNeZkE1XPqc9DL
   G0t15wGYPG2A/v6ziu1CYjHqdN5dkmByC1g0Eyzvg7fLlMqIDofNpzoKf
   lN6mBETHZKakepuu/y+icNQg535eiRy62LPtqqngFjpQrGD642psV8SNP
   Xlr9h/3JyjkQUWL1ei3WKkAmPidDDtXHaC3ekG1uC4dunFHB6+6DrcXEa
   2ilI1a3BzsekDq67whY/N1zfC1/q/ha0cFkVTTqkhts0AUAlcwhdp4QnP
   5QODzXDtbbESP8jrtnv11fCEJe2QiD3vLsvhRZkcDkVXOxikVevH/hXgW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="373550359"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="373550359"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="716671339"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="716671339"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:38 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 7/9] KVM: x86/pmu: Add fixed counter enumeration for pmu v5
Date:   Fri,  1 Sep 2023 15:28:07 +0800
Message-Id: <20230901072809.640175-8-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230901072809.640175-1-xiong.y.zhang@intel.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With Arch PMU v5, CPUID.0AH.ECX is a bit mask which enumerates the
supported Fixed Counters. If bit 'i' is set, it implies that Fixed
Counter 'i' is supported.

This commit adds CPUID.0AH.ECX emulation for vPMU version 5, KVM
supports Fixed Counter enumeration starting from 0 by default,
user can modify it through SET_CPUID2 ioctl.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/cpuid.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 95dc5e8847e0..2bffed010c9e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1028,7 +1028,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		entry->eax = eax.full;
 		entry->ebx = kvm_pmu_cap.events_mask;
-		entry->ecx = 0;
+		if (kvm_pmu_cap.version < 5)
+			entry->ecx = 0;
+		else
+			entry->ecx = (1ULL << kvm_pmu_cap.num_counters_fixed) - 1;
 		entry->edx = edx.full;
 		break;
 	}
-- 
2.34.1

