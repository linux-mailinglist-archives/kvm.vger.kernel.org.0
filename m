Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96251CFA9
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388722AbiEFDh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388673AbiEFDhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD34B6471A;
        Thu,  5 May 2022 20:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808016; x=1683344016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hi3VCyD+JnIDk2e0rz7CI6Cyjxc9Z6zZMaSQJIsFywc=;
  b=lNV2AMfWgL611zec4i7opQvC8o7KQr00YmHaVKVXf1blYzTVySO8l0TT
   IIjX0gX+zbozY1uZDq4nd6ftBLFREQXBUTORgYvj7VVxHec0VqySed4hF
   Zgh/wHkQWXVYTs7tn69typvHf8rX64ENT4q37mjakKUGzkYAzXTUjYOSG
   FLNoLZsBth0psP8LMPrPqRyHSgHzt8XBuyOfdOVLj849rZosa3EMAA+Ks
   DD/eZBVwAdd8Mj0VAcuI/Iz/jgd5XubNX6gvwCnv0mOXliWHy8fysWoAz
   kFP42GiRKskmkS3ykLqG2qqsof5ew/iza6OMkcar3YCGdkdciu1pqHjaH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241446"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241446"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745209"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:35 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest state change
Date:   Thu,  5 May 2022 23:33:03 -0400
Message-Id: <20220506033305.5135-15-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506033305.5135-1-weijiang.yang@intel.com>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
LBRs." So clear Arch LBREn bit on #SMI and restore it on RSM manully, also
clear the bit when guest does warm reset.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d6ee9cf82f5..b38f58868905 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4593,6 +4593,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!init_event) {
 		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
 			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
+	} else {
+		flip_arch_lbr_ctl(vcpu, false);
 	}
 }
 
@@ -7704,6 +7706,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	vmx->nested.smm.vmxon = vmx->nested.vmxon;
 	vmx->nested.vmxon = false;
 	vmx_clear_hlt(vcpu);
+	flip_arch_lbr_ctl(vcpu, false);
 	return 0;
 }
 
@@ -7725,6 +7728,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		vmx->nested.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
+	flip_arch_lbr_ctl(vcpu, true);
 	return 0;
 }
 
-- 
2.27.0

