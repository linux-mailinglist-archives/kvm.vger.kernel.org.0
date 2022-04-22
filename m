Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594DC50B222
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445250AbiDVH6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445173AbiDVH60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:58:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D17535AAE;
        Fri, 22 Apr 2022 00:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650614133; x=1682150133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oKOe0Bd22sWrfXNuU/olm3BLUrCRY4INP6X31ocOJb8=;
  b=jwB3lbg2USSlORjqfnheqUgyyBVXujLMxIQMT/ofI/w+ZaJfx6XGI/jW
   4Nrrk1NG2mwQuUz1Gb/MMbLxGVf5gEIGoh3ub3tY1jfd/6JAi04OaSF1P
   GBCWvILuPmteQQeEHjqXQnUfGE2a5NKebZe/kVdsLXo7jku+nPS7N9I1G
   9/a8jpdMN6FAomreYGtI9bAz0Yj+44gyCEWmJ/GKo4CNdtXVCQve0OLjw
   J/WiJ6GWook2VgUht+pzvnYqNE5n2ddW55WRqyqG8jPUjKBN73ZDruV9Y
   l757p6KtFRqY/IuczSNFH6bwYP1u5p8bnGPaJCGx/OFLVucHDRnb60mki
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264384826"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="264384826"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="577741328"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 05/16] KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
Date:   Fri, 22 Apr 2022 03:54:58 -0400
Message-Id: <20220422075509.353942-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220422075509.353942-1-weijiang.yang@intel.com>
References: <20220422075509.353942-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f42f250884f1..c81014f618ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1429,6 +1429,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_ARCH_LBR_CTL, MSR_ARCH_LBR_DEPTH,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -6661,6 +6662,11 @@ static void kvm_init_msr_list(void)
 			if (!supported_xss)
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

