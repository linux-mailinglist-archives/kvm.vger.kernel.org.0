Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DC752F9A8
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 09:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349984AbiEUHYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 03:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiEUHYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 03:24:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AD16CA91;
        Sat, 21 May 2022 00:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653117845; x=1684653845;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3asQqEgN3HAp03iRISKotmL8Hzh0H0AiQ5h1mdRd4mU=;
  b=dLksq0kCgeneLrIg7mul/8YOhdwXbgG9ejzHDLGiuwwVna9ncgzrQHy8
   TIIQ9NkKNcOrPrF6micVC7/5SYVFusSyXtp0Dg20naCsBZO0IVK13Ior6
   LmquI+TSuqbZ7tgtSmTW16VilI3HIR80O0c9NoWwy6lD4yN8UmjdRtAZ3
   T9jjBkcII9EHxpqtP+waM2Gk2jEaFi0aeqtOmBMRGmwbo1/vtXuHGJMNK
   iJiiZfq5yI1TPWlwlD5p8VIBSNFji2kMmuS6nhS3iknP5iSBGdshu4dpI
   1oe9HtE8jNTDANiTYA4vy465tIXLt9ElHiN2znHVy0Ni2eJTXL/hjn2Zk
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="254871996"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="254871996"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 00:24:04 -0700
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="599658223"
Received: from tower.bj.intel.com ([10.238.157.62])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 00:24:01 -0700
From:   Yanfei Xu <yanfei.xu@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, wei.w.wang@intel.com,
        kan.liang@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Fix the intel_pt PMI handling wrongly considered from guest
Date:   Sat, 21 May 2022 15:23:18 +0800
Message-Id: <20220521072318.1226928-1-yanfei.xu@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..378036c1cf94 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7856,7 +7856,7 @@ static unsigned int vmx_handle_intel_pt_intr(void)
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 	/* '0' on failure so that the !PT case can use a RET0 static call. */
-	if (!kvm_arch_pmi_in_guest(vcpu))
+	if (!kvm_handling_nmi_from_guest(vcpu))
 		return 0;
 
 	kvm_make_request(KVM_REQ_PMI, vcpu);
-- 
2.32.0

