Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A318F6FD686
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 08:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbjEJGHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 02:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbjEJGHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 02:07:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D054EDD;
        Tue,  9 May 2023 23:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683698812; x=1715234812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kt0qjz7s/zDjl1X7gKCqQ/BcP+kDKdTRpLmI67rfMd0=;
  b=JCD08YOYVyBvGiuVzQ0V2W7AZdg6hgg03HxvSPTaZ5LctPpmJKCAIrdn
   D3w3sVQTJ0fbrM/F14byvxRb8H8kAktifLByuXE5N80wupT/QNDQr0cAc
   1L9DAyD0PRKwSch+C5v9TsWiYIU5mmXgxNixpJ1vIEgD7FnKwhDecF+2V
   RnS7a9ohuyDuHyCi38/eXEUF0O7bMucZ269KMXZNeylWAzHUFfmfPdOL6
   GZKWAh3IHdCVeTM8ayfF7cjux767kTq2gblR0Lrm6MxRQ9DALdp0a5Qmb
   i/Eeh5GaG+fw4Qw56G/Tlt949NKQTBwVDJNHQd+Z6KjsTvV+lgfl2f48K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="348969286"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="348969286"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="768803141"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="768803141"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.90])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:50 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v8 6/6] KVM: x86: Expose LAM feature to userspace VMM
Date:   Wed, 10 May 2023 14:06:11 +0800
Message-Id: <20230510060611.12950-7-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230510060611.12950-1-binbin.wu@linux.intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
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
  emulations and VMExit handlers.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 123bf8b97a4b..fc8286f747ac 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -664,7 +664,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
 		F(FZRM) | F(FSRS) | F(FSRC) |
-		F(AMX_FP16) | F(AVX_IFMA)
+		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
 	);
 
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
-- 
2.25.1

