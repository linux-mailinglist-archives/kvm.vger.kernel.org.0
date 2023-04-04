Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969766D6251
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 15:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbjDDNJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 09:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbjDDNJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 09:09:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B22198A
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680613782; x=1712149782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0pdsg5GImSmlfMLMsDn0scgMa9yM0+CDoCvSL+FuWRI=;
  b=VqhnH8OtYdhU6bmfyr4fqvh4+m9/jR3uVVWC7rRUP3DkUkLIgI9D09Z3
   g6kYzBf1zJXCrYYMwXeD/baV3+mSzfKfD/NB/4VZlb2BEyxEeyw0/B+2O
   t3x3TDaptRHoabiI7gFPfC/RL8Gq45vT99b0rJDYZNwJgY/1ff+aUuswa
   weWeCGQWGDYav7C7RlH5CTCbnHTc32R17+f4Z5sdtbPDHHIoAgqfLdH2n
   MO1dsokwaD6Hfk158icO0JGcaQAg+XzbRas5EhY9gpm7ogVCqi1ax7HC1
   Ztj/0K2Ol+nwlMAp8gLBWeMX7URdnj+HxjCvw9tIwQkAL/hVhQgOqHc3d
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="326193447"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="326193447"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 06:09:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750902109"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="750902109"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.215.140])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 06:09:40 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, kai.huang@intel.com, chao.gao@intel.com,
        xuelian.guo@intel.com, robert.hu@linux.intel.com
Subject: [PATCH v7 5/5] KVM: x86: Expose LAM feature to userspace VMM
Date:   Tue,  4 Apr 2023 21:09:23 +0800
Message-Id: <20230404130923.27749-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404130923.27749-1-binbin.wu@linux.intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

LAM feature is enumerated by CPUID.7.1:EAX.LAM[bit 26].
Expose the feature to userspace as the final step after the following
supports:
- CR4.LAM_SUP virtualization
- CR3.LAM_U48 and CR3.LAM_U57 virtualization
- Check and untag 64-bit linear address when LAM applies in instruction
  emulations and vmexit handlers.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 599aebec2d52..1dd5e9034386 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -670,7 +670,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
 		F(FZRM) | F(FSRS) | F(FSRC) |
-		F(AMX_FP16) | F(AVX_IFMA)
+		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-- 
2.25.1

