Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AAF6B699B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjCLSGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjCLSD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:03:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1FB2F794;
        Sun, 12 Mar 2023 11:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644000; x=1710180000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ywg5sMZVHb2IQnj3J4ep6DC9fk7SuQKFRSN+L1ln7C0=;
  b=lFDUsG/0dtW3CqBAy3xWwVNn76wc24QS8KrIZ+7155yytup+1hozUiDC
   qlScgEJZka/gTCn2W5DkCPHSqsCpB6rpv7DtaC8Lsdrww90+L0zlvbryW
   TW4x3IJwQJpB02k4EeXSBMgmo4QeeVULGBo2a4MhPxtIMHDfW0qVkcngd
   aRbTc+lwudI53hmXmv5dSHljz3KhZQ+GDDGTABi/sB7X8h/IxT2nGPL+x
   JCioF7c2hc+P5jyAEtroERs/S0BIcBLFqUY0G78lYS26VydSBIf8IBIRD
   gFFhwYK2/AsASjjlCTTNmz+jT4LCEsx7xdmnjlZicCbBXp0lkF72W4NK6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659999"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659999"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596740"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596740"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:11 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 075/113] KVM: x86: Assume timer IRQ was injected if APIC state is proteced
Date:   Sun, 12 Mar 2023 10:56:39 -0700
Message-Id: <6d1ea5cc97b68d0e2fb72c7ef9917295452e1aa8.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

If APIC state is protected, i.e. the vCPU is a TDX guest, assume a timer
IRQ was injected when deciding whether or not to busy wait in the "timer
advanced" path.  The "real" vIRR is not readable/writable, so trying to
query for a pending timer IRQ will return garbage.

Note, TDX can scour the PIR if it wants to be more precise and skip the
"wait" call entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b2612a86789f..6b2e2d38a48b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1734,8 +1734,17 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	u32 reg;
 
+	/*
+	 * Assume a timer IRQ was "injected" if the APIC is protected.  KVM's
+	 * copy of the vIRR is bogus, it's the responsibility of the caller to
+	 * precisely check whether or not a timer IRQ is pending.
+	 */
+	if (apic->guest_apic_protected)
+		return true;
+
+	reg  = kvm_lapic_get_reg(apic, APIC_LVTT);
 	if (kvm_apic_hw_enabled(apic)) {
 		int vec = reg & APIC_VECTOR_MASK;
 		void *bitmap = apic->regs + APIC_ISR;
-- 
2.25.1

