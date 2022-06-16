Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B32254DD6B
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376427AbiFPIto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359855AbiFPIs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D925F247;
        Thu, 16 Jun 2022 01:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369276; x=1686905276;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5ds9yOVSoDWedK4bluyWKuKvK1FziQP9xxqZoYWM0jw=;
  b=PCt42bnYdfFn5fkac4tb0NEnghYnSOvvq4IKlfCtz9jbxSvCpAD5D6sP
   SdOOgouY4cSNW+QCzcxeUBY2Sj/9Yg6lm+eWs6rRGgAGLJRrV/GOPs1Ky
   79JAEMYL8ZKAMhDjUaCSADR719WNgxWApxK2RMN2tmpOcqs0q+3KrZOgK
   rF/JaBeWtbBtB99ihNzbfbY5u3SjwBBhuB0qjsWslSVqxt4Ycc6qmj148
   rgrFwbP1JAC0Ubf+GNbtG7Rz+K4WXj6/55YWMeJweGIQuGB3vV4XySZV+
   TDW1V4zS/IeT5hWNFwQYJj4nlpZyfa2Zf9fAtVlY29IkLxt4ye9COVRqX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259664561"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259664561"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083169"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 14/19] KVM: x86: Report CET MSRs as to-be-saved if CET is supported
Date:   Thu, 16 Jun 2022 04:46:38 -0400
Message-Id: <20220616084643.19564-15-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Report all CET MSRs, including the synthetic GUEST_SSP MSR, as
to-be-saved, e.g. for migration, if CET is supported by KVM.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cce789f1246a..3613b73f13fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1460,6 +1460,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_IA32_U_CET, MSR_IA32_PL3_SSP, MSR_KVM_GUEST_SSP,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -6814,6 +6815,12 @@ static void kvm_init_msr_list(void)
 			if (!kvm_caps.supported_xss)
 				continue;
 			break;
+		case MSR_KVM_GUEST_SSP:
+		case MSR_IA32_U_CET:
+		case MSR_IA32_PL3_SSP:
+			if (!kvm_cet_user_supported())
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

