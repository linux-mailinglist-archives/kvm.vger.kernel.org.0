Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7075311E8
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbiEWOJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 10:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbiEWOJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 10:09:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B17C43385;
        Mon, 23 May 2022 07:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653314942; x=1684850942;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CP8ihjKGx/8QsyN9SA++OSx8EsR3YUJySmWvuEJ3E+Y=;
  b=TlgaClV7hMQLmBeULz/zHdnutwRbU63nMkLIdeAmEOLfWWnwG0BkJJAo
   aPMrCy1YSRYkKqG8PRZMTXcXM/1GejCP3R+0OxXm9ZGG2SqxOfLgxwATQ
   irM4xyqvJxiCwSpLS2wunb2jNf0rwCRUy11MSjW+vfkNiJRtUNQMJ6eFE
   s/kWaXeN4Ym6FX0UhTv5iRFSoA+Z9iUREX0Xz1xc3Bf7OZ1owTAezuQLs
   xWUxxD6QZIRVyM08VHY5J7rGX2oPbMCH7f64TB0gQAJp/o7vgFh9k6qA5
   OKUqwfLUqUzxr8p+bxX3NRh1Jz776FhB/TSX2QwnzGmyI2lcpLrgrOi18
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="253109280"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="253109280"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 07:09:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="558660848"
Received: from tower.bj.intel.com ([10.238.157.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 07:08:57 -0700
From:   Yanfei Xu <yanfei.xu@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, wei.w.wang@intel.com,
        kan.liang@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: x86: Fix the intel_pt PMI handling wrongly considered from guest
Date:   Mon, 23 May 2022 22:08:21 +0800
Message-Id: <20220523140821.1345605-1-yanfei.xu@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kernel handles the vm-exit caused by external interrupts and NMI,
it always set a type of kvm_intr_type to handling_intr_from_guest to
tell if it's dealing an IRQ or NMI. For the PMI scenario, it could be
IRQ or NMI.
However the intel_pt PMI certainly is a NMI PMI, hence using
kvm_handling_nmi_from_guest() to distinguish if the intel_pt PMI comes
from guest is more appropriate. This modification can avoid the host
wrongly considered the intel_pt PMI comes from a guest once the host
intel_pt PMI breaks the handling of vm-exit of external interrupts.

Fixes: db215756ae59 ("KVM: x86: More precisely identify NMI from guest when handling PMI")
Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
---
v1->v2:
1.Fix vmx_handle_intel_pt_intr() directly instead of changing the generic function.
2.Tune the commit message.

v2->v3:
Add the NULL pointer check of variable "vcpu".

 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..982df9c000d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7856,7 +7856,7 @@ static unsigned int vmx_handle_intel_pt_intr(void)
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	/* '0' on failure so that the !PT case can use a RET0 static call. */
-	if (!kvm_arch_pmi_in_guest(vcpu))
+	if (!vcpu || !kvm_handling_nmi_from_guest(vcpu))
 		return 0;
 
 	kvm_make_request(KVM_REQ_PMI, vcpu);
-- 
2.32.0

