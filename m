Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFF676269D
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbjGYWZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbjGYWXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:23:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3843E63;
        Tue, 25 Jul 2023 15:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323550; x=1721859550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F1na9iHUMKw4mKC0owR/NCG+6golikTlvHP4q5QoXuk=;
  b=NPD3OHvpVHpTaTT3xFB8OrKFgJjM6od9MNkoWxAGb4AIvjztIvPnrvqR
   MpXDPRfxbyml9mlnxvDHrwlqDb4a653SEjgnKArhQw2HBBNiLtvV79qk9
   tCm5kokrYDPTo2cknI31OJgAKO4PyJ1bOw/uVjFyLbNW4K61v4RlPtOYU
   bQSODe30trSXa3Tv7cmNS9N3SApG5AOkFyCX7cBBx3c8/62SllaOz9t3x
   A3OmRy5Ja+tqLSgRgmDgVksUqBN46GwzDEyjBxVcrmAgotmuP9WVMZXCi
   AlTM4IZdih6zMBuEbyXuFkVHh52R4CKBlS+rRZHR+URWE0xZIP471i0yU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882783"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882783"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001963"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001963"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:10 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 109/115] KVM: TDX: Add a method to ignore for TDX to ignore hypercall patch
Date:   Tue, 25 Jul 2023 15:15:00 -0700
Message-Id: <943309c5d446e59e056e29809a9130e1f2687016.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because guest TD memory is protected, VMM patching guest binary for
hypercall instruction isn't possible.  Add a method to ignore hypercall
patching with a warning.  Note: guest TD kernel needs to be modified to use
TDG.VP.VMCALL for hypercall.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d235268b2a76..563b11679d00 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -724,6 +724,19 @@ static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 	return vmx_get_interrupt_shadow(vcpu);
 }
 
+static void vt_patch_hypercall(struct kvm_vcpu *vcpu,
+				  unsigned char *hypercall)
+{
+	/*
+	 * Because guest memory is protected, guest can't be patched. TD kernel
+	 * is modified to use TDG.VP.VMCAL for hypercall.
+	 */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_patch_hypercall(vcpu, hypercall);
+}
+
 static void vt_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	if (is_td_vcpu(vcpu))
@@ -991,7 +1004,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vt_set_interrupt_shadow,
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
+	.patch_hypercall = vt_patch_hypercall,
 	.inject_irq = vt_inject_irq,
 	.inject_nmi = vt_inject_nmi,
 	.inject_exception = vt_inject_exception,
-- 
2.25.1

