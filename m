Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48378F91C
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348495AbjIAH3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240592AbjIAH3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:29:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0022910F2
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693553372; x=1725089372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b0+sx3iOFFdvgVqFfT3IKEJQOAHLBAvTFXOuu4XWNXc=;
  b=C/VaJpdL+qpp7xG53JpC+EvH2dY8SUvRAYf2E/cFz8ifFKV5TXjrHnft
   811+tNg3B+1Bdp+jrH35LR71/p0krF4g3b9oK8LZ4hf/nPEUp+UJzlKIA
   Ij9sLncd8OgY7YufUeMJT913HFSN/M7zfweeu2HdMHpaxcI/Jq16Ih/KK
   7NERCWwlb0gqeje9DxYfbTUxIImkrGiJ9TLG1GU9zeYf5H/pg+cOCdhA5
   gtwrRUap/SsacXVdgf3my16534xufIu5mbsJUlFiolli9OB6IKqfKPY4Y
   mXKWCY553S6pnRXC8/yLr0J/Tsq4SctEGvFo7t+GdAgZJ3+W6Fy4bpJvO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="373550332"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="373550332"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="716671306"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="716671306"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:29 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 5/9] KVM: x86/pmu: Check CPUID.0AH.ECX consistency
Date:   Fri,  1 Sep 2023 15:28:05 +0800
Message-Id: <20230901072809.640175-6-xiong.y.zhang@intel.com>
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

With Arch PMU V5, register CPUID.0AH.ECX indicates Fixed Counter
enumeration. It is a bit mask which enumerates the supported Fixed
counters.
FxCtrl[i]_is_supported := ECX[i] || (EDX[4:0] > i)
where EDX[4:0] is Number of continuous fixed-function performance
counters starting from 0 (if version ID > 1).

Here ECX and EDX[4:0] should satisfy the following consistency:
1. if 1 < pmu_version < 5, ECX == 0;
2. if pmu_version == 5 && edx[4:0] == 0, ECX[bit 0] == 0
3. if pmu_version == 5 && edx[4:0] > 0,
   ecx & ((1 << edx[4:0]) - 1) == (1 << edx[4:0]) -1

Otherwise it is mess to decide whether a fixed counter is supported
or not. i.e. pmu_version = 5, edx[4:0] = 3, ecx = 0x10, it is hard
to decide whether fixed counters 0 ~ 2 are supported or not.

User can call SET_CPUID2 ioctl to set guest CPUID.0AH, this commit
adds a check to guarantee ecx and edx consistency specified by user.

Once user specifies an un-consistency value, KVM can return an
error to user and drop user setting, or correct the un-consistency
data and accept the corrected data, this commit chooses to
return an error to user.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/cpuid.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e961e9a05847..95dc5e8847e0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -150,6 +150,33 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 	}
 
+	best = cpuid_entry2_find(entries, nent, 0xa,
+				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
+	if (best && vcpu->kvm->arch.enable_pmu) {
+		union cpuid10_eax eax;
+		union cpuid10_edx   edx;
+
+		eax.full = best->eax;
+		edx.full = best->edx;
+
+		if (eax.split.version_id > 1 &&
+		    eax.split.version_id < 5 &&
+		    best->ecx != 0) {
+			return -EINVAL;
+		} else if (eax.split.version_id >= 5) {
+			int fixed_count = edx.split.num_counters_fixed;
+
+			if (fixed_count == 0 && (best->ecx & 0x1)) {
+				return -EINVAL;
+			} else if (fixed_count > 0) {
+				int low_fixed_mask = (1 << fixed_count) - 1;
+
+				if ((best->ecx & low_fixed_mask) != low_fixed_mask)
+					return -EINVAL;
+			}
+		}
+	}
+
 	/*
 	 * Exposing dynamic xfeatures to the guest requires additional
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
-- 
2.34.1

