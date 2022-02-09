Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395B54AEA62
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 07:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiBIGbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 01:31:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235882AbiBIG3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 01:29:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D23E02DFCD;
        Tue,  8 Feb 2022 22:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644388161; x=1675924161;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IbT91/fqiVPksbSJc2NP8Q4PbHBMZvsgMb4CiiQxRiA=;
  b=DJdHFjWBtGJ/YqwGur1PuMotboSXOX+CNlStHTy6u5LJ/A5+4+wVtMs5
   ewMrup5CSeewEFRuDz15HjHoo22uTKuvFLmGzR6neh33ghivBB5AeQ4sW
   odrCoAbYE0EaGDMEg3gfPgL+gNTRvfoSf1Qo7Tcmf9vgYFRjDxvhcgDFh
   gA7TsO9StQK/ViRLxLdlaoG6TUbrsqedeoW0+e2nMIyKdlp44e+ERFxGl
   gcht7GE+yu8ohOa7Jz7hFDzTqd2uu2OwRpXXUD1pI+C7rNZATFJi6T1d2
   zxdh7vrFiy2qHKg0Tw1wSzTGeaPUJOSWGbeNOV0hs3qPzUnBRxy9/cSEs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="312428037"
X-IronPort-AV: E=Sophos;i="5.88,354,1635231600"; 
   d="scan'208";a="312428037"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 22:29:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,354,1635231600"; 
   d="scan'208";a="540958500"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 22:29:12 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH] KVM: x86: Fix emulation in writing cr8
Date:   Wed,  9 Feb 2022 14:24:28 +0800
Message-Id: <20220209062428.332295-1-zhenzhong.duan@intel.com>
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

so in KVM emulated scenario, clear TPR[3:0] to make a consistent behavior
as in other scenarios.

This doesn't impact evaluation and delivery of pending virtual interrupts
because processor does not use the processor-priority sub-class to
determine which interrupts to delivery and which to inhibit.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
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

