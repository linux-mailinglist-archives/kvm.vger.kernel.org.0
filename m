Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2FA4B09EE
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 10:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiBJJtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 04:49:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239035AbiBJJtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 04:49:41 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A1B1BC;
        Thu, 10 Feb 2022 01:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644486582; x=1676022582;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QD7diRDjosCEK96P8HtODobHDCAMfgamv9O2SqAn5T8=;
  b=bXFLTH+d4CTCsHh/02B2eT8t8ffTPoVbEmFd8izEHiZtHvcOxnAWlaVj
   i0Of0zNHqItzZXZ9PeumDwa5322GPzm3DZvCMTtYlrAQLqRyAaTC3LbXY
   KWXR8hYiR/pKvu2b1d8H1fDHgtsOTlMMA6CQiCAKYamjSOtQlIjs1KTao
   cxbDNsiXkBbZw+SE2P/cV0baMYf4A/DwH4L3GCusrPNUGM4AhDiSwJpoF
   /atG3pnlOGbWqsJgqMm5grxnsmPlKjx+0CokkVP9At5TTWesNyh7t6uiY
   Wv2+ydv2F2s75Nx2p3pfsPkbbyKVfv9wwtWZdO7EHLOMCaIDX9WloPaFs
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="312742027"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="312742027"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 01:49:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="541538900"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 01:49:40 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: [PATCH v2] KVM: x86: Fix emulation in writing cr8
Date:   Thu, 10 Feb 2022 17:45:06 +0800
Message-Id: <20220210094506.20181-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In emulation of writing to cr8, one of the lowest four bits in TPR[3:0]
is kept.

According to Intel SDM 10.8.6.1(baremetal scenario):
"APIC.TPR[bits 7:4] = CR8[bits 3:0], APIC.TPR[bits 3:0] = 0";

and SDM 28.3(use TPR shadow):
"MOV to CR8. The instruction stores bits 3:0 of its source operand into
bits 7:4 of VTPR; the remainder of VTPR (bits 3:0 and bits 31:8) are
cleared.";

and AMD's APM 16.6.4:
"Task Priority Sub-class (TPS)-Bits 3 : 0. The TPS field indicates the
current sub-priority to be used when arbitrating lowest-priority messages.
This field is written with zero when TPR is written using the architectural
CR8 register.";

so in KVM emulated scenario, clear TPR[3:0] to make a consistent behavior
as in other scenarios.

This doesn't impact evaluation and delivery of pending virtual interrupts
because processor does not use the processor-priority sub-class to
determine which interrupts to delivery and which to inhibit.

Sub-class is used by hardware to arbitrate lowest priority interrupts,
but KVM just does a round-robin style delivery.

Fixes: b93463aa59d6 ("KVM: Accelerated apic support")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
v2: Add Sean's comments and "Fixes:" to patch description

 arch/x86/kvm/lapic.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7e6fde82d25..306025db9959 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2242,10 +2242,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-
-	apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
-		     | (kvm_lapic_get_reg(apic, APIC_TASKPRI) & 4));
+	apic_set_tpr(vcpu->arch.apic, (cr8 & 0x0f) << 4);
 }
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
-- 
2.25.1

