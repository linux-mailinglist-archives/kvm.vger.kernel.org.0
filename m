Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF597CAFDB
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbjJPQjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbjJPQhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AB1728D;
        Mon, 16 Oct 2023 09:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473362; x=1729009362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/xICi/lxQ3uFDdmNBJiK/bhHHl0zWMlhjZNjgKQB2ys=;
  b=bD/fpSG9k2YTM3I6/ZHpedWeeibrZ0rmDm3FVekNlDSZKjOCRJ6tdnYT
   +S3aXKkqBucBGE4vYj2dWlCWrgf7sJsaIWQEoW1UL1xTZ3XL/8de2d4sg
   URTazTA+UT1U8dPfOyC5rxH3ouF0JqYcjr0T7F9+o35JMWC97xd4RTPys
   VReZ+ecSjB2wJN6E2vIq1ecweesI00cXCGZQv/d3SYfr1FbQbgmanIp02
   eRUyXzmpWY5//QRhdSXeY+kGVNhrDbkVy4r1cgGCgoyRfEOZVmuA9DurN
   WAJX5whFsoZqBiMxIRRB+/pWgh/nfcSRiQaQK4BBS21eMOMVdk6EfAEvR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922143"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922143"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1003006478"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1003006478"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:11 -0700
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
Subject: [PATCH v16 108/116] KVM: TDX: Add a method to ignore for TDX to ignore hypercall patch
Date:   Mon, 16 Oct 2023 09:15:00 -0700
Message-Id: <f6df6709662f5372e3f0ee89778fd16ae0175500.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index df84a12aa232..0d0af3fadc75 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -740,6 +740,19 @@ static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
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
@@ -1008,7 +1021,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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

