Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6831B6383CD
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKYGKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKYGKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:10 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9837321E0A;
        Thu, 24 Nov 2022 22:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356609; x=1700892609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9dgyRevU02/WAQF4wQb17DisD5XuSJGZ1MCakKBODE8=;
  b=Q7NjNOMU/YLxFz32Hs29P0c9gp5MrXGW8SjLMYveXkX/J/n8RxZotiS8
   xfh0zLwdkHbPNh7jAbJxavU/8mN5COEDLA7tDTuuTivgjuNWByry6zj7Y
   70hcyGS7v/+Ysx+hA2GMOGPHqQ/zx28yUESc+n+N6QC+BQueFNi26Yo1B
   1kV1EfaJnjSVHozjHDeVe1/BPLVmChobvPuoVZEBM/jSrBxsYJJWrrodk
   LuWkdYLYqR3GCTZdbXkQBFfk+7o0s8EjY9hKVhLjiUP5swohlE7p9dIn2
   gBe7bA2/b90CJs6JDV9xgB7rIPQannsmEYdmTVY4PpXDnKAZUZ8rzlyKu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116819"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116819"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838485"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838485"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:05 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 08/15] KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
Date:   Thu, 24 Nov 2022 23:05:57 -0500
Message-Id: <20221125040604.5051-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
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

Arch LBR MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL are queried by
userspace application before it wants to {save|restore} the Arch LBR
data. Other LBR related data MSRs are omitted here intentionally due
to lengthy list(32*3). Userspace can still use KVM_{GET|SET}_MSRS to
access them if necessary.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 888a153e32bc..74c858eaa1ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1466,6 +1466,7 @@ static const u32 msrs_to_save_all[] = {
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_ARCH_LBR_CTL, MSR_ARCH_LBR_DEPTH,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -3877,6 +3878,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
+	case MSR_ARCH_LBR_CTL:
+	case MSR_ARCH_LBR_DEPTH:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -3980,6 +3983,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 	case MSR_IA32_DS_AREA:
 	case MSR_PEBS_DATA_CFG:
+	case MSR_ARCH_LBR_CTL:
+	case MSR_ARCH_LBR_DEPTH:
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
@@ -7068,6 +7073,11 @@ static void kvm_init_msr_list(void)
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

