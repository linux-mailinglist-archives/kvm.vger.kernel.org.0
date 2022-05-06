Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC5D51CFA2
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384740AbiEFDhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388657AbiEFDhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473DB64705;
        Thu,  5 May 2022 20:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808013; x=1683344013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HQMdIVMbFrV384358K15gzU2GKo6n64c/08wJXHeuf4=;
  b=QSNhqlQZuJQSOQwQ7vh+5Wnc39cTo2jcs8nxBFZnIc1dUX87aJP2VNdO
   Hoya6Mc0eWbI518uv7oy0AStTgL61rFmvfGubuYCPGFzDNBwHUPjgJhWk
   6Ehtj5OAjRshWwMRV2Vfe5FyIB27qEN/GCK7quXwVMNFdhfvewoFL4RyF
   FVRpo6OjZsQVKiuzNPakA0dXE8zHb266rwQL8dQEZSgIH3QUlnkz4yq8e
   UEkJTsdxuhNYBNaaxHFq+T1bk0ghmheNH5NVwyRmEfwNzKEU+pFYcdq7q
   cm/T9XO3gPaDx6VmL3d3N33oxuNpaPHeIwOlDFVSWHZtBRI1H3/H8Or2I
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241430"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241430"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745168"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:32 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 05/16] KVM: x86: Add Arch LBR MSRs to msrs_to_save_all list
Date:   Thu,  5 May 2022 23:32:54 -0400
Message-Id: <20220506033305.5135-6-weijiang.yang@intel.com>
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
index f78fc014aed3..8437d0c9804f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1429,6 +1429,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_ARCH_LBR_CTL, MSR_ARCH_LBR_DEPTH,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -6660,6 +6661,11 @@ static void kvm_init_msr_list(void)
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

