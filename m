Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE2754DD61
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376508AbiFPItG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376393AbiFPIsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353535DE46;
        Thu, 16 Jun 2022 01:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369268; x=1686905268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bgt6iiOS05UazPFX6/lMSu/x6EY0lL69MxEoOLr0oBE=;
  b=COcGx2164nFRUgYlVPWWibnEnb7+KUXJxpz9BMsoZZ5EOlxBA1smqpAQ
   7IAO8+4wDLmDUDZhHn21NYY10ixf8cLJsLUTZL9wOzRL/ATCU9X0dyFev
   1ixBAw+0/QcWe8n/CPUKFWOcmtTNOonMs1kOmV/KhskWISSLyvGIMdW+6
   T8DTrWbhHhcIuo6q32S3aGrkqJmdYt1BrdHQkvj5Ir7jk7VfHvsZOQw1q
   vzRWWFOOtNm/KFx6Or/Hzi7yBLq4891GWMZU2An5z2oOevhN8DM43Xeap
   qyMBv54lraM6f8vR194xytLcDF/Lf8YWr74KyH2v/xAbEZPv10bxP5nM8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259055229"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259055229"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083143"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 06/19] KVM: x86: Report XSS as an MSR to be saved if there are supported features
Date:   Thu, 16 Jun 2022 04:46:30 -0400
Message-Id: <20220616084643.19564-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add MSR_IA32_XSS to the list of MSRs reported to userspace if
supported_xss is non-zero, i.e. KVM supports at least one XSS based
feature.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20220517154100.29983-4-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2318a99139fa..f525228168b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1446,6 +1446,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+	MSR_IA32_XSS,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -6780,6 +6781,10 @@ static void kvm_init_msr_list(void)
 			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
 				continue;
 			break;
+		case MSR_IA32_XSS:
+			if (!kvm_caps.supported_xss)
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.27.0

