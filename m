Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8944A5A8AE1
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiIABhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiIABhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C5815C786;
        Wed, 31 Aug 2022 18:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996229; x=1693532229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sz9BlB4ANsYCtbFD5nTVp7ZqKmSjsoP5saDIYrx4AOY=;
  b=Jkz38WJLjxVVzVx+JQ0g65SKrFTZrr82V59Uwl2GM7OplMkZcB4RYyUs
   ONf2WmMfggANmEeGnaMulLjqsEgz4TxH4V9Vv7YUmM281v5EvS5RxR0cf
   I1Zf7P9GAFj5YgsA653rhT90bzvHcUDdgcbSBP6uBwUln3Rb7WXllAPnN
   yqChWi0gzY+PhmHqPZoxpsRji49mOQuVvEsXy54cGr6b7UaaUTmG6EWgB
   yMRNHwia3R6846zpuGpndNwMEmx+R7ZouXTodD0j45MCIg0oX9IBhg9cv
   Z8OYAfPZD2XDqcnfkBRB5CQzFak1KIMp8uiLIiyxWu6YzGhqCKMdl4l9k
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735089"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735089"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754626007"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:01 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 08/15] KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
Date:   Wed, 31 Aug 2022 18:34:31 -0400
Message-Id: <20220831223438.413090-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch LBR MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL are queried by
userspace application before it wants to {save|restore} the Arch LBR
data. Other LBR related data MSRs are omitted here intentionally due
to lengthy list(32*3). Userspace can still use KVM_{GET|SET}_MSRS to
access them if necessary.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 92ff5f7d944b..b3d2a7ad1d18 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1452,6 +1452,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_ARCH_LBR_CTL, MSR_ARCH_LBR_DEPTH,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -3839,6 +3840,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
+	case MSR_ARCH_LBR_CTL:
+	case MSR_ARCH_LBR_DEPTH:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -3942,6 +3945,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
+	case MSR_ARCH_LBR_CTL:
+	case MSR_ARCH_LBR_DEPTH:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
@@ -6948,6 +6953,11 @@ static void kvm_init_msr_list(void)
 			if (!kvm_caps.supported_xss)
 				continue;
 			break;
+		case MSR_ARCH_LBR_DEPTH:
+		case MSR_ARCH_LBR_CTL:
+			if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

