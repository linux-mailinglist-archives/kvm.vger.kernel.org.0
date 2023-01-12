Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969D8667B04
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbjALQiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbjALQhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:13 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BD7642E;
        Thu, 12 Jan 2023 08:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541218; x=1705077218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=14ei65Uin7WTR3nSRJrTU5cndalXPOLKf39nxB0YQU0=;
  b=TNNFyNo20q9wE2stFBImDlDglAWykzvq4ruWata8w3ZV3o7D/8lw0d3M
   chKPBmWlRgYm86OeDqMBaZvbF1U4KZ6Vfc9+XCPZtKB4VNxUnRwOupSX8
   dYhP5+D8g2sFLoNrsZLwwvVGQiCToEBTmuQ3JCUc56CcR3/+9CxnEAMOM
   Idmh0vL2+IL6t1TZwmarHH09qR413zmAcqBW8XLhSjUHABIr2mhzebhoi
   wDB2i9YL2lnc5UItajjSxzBbz9AXcssNQpUyetS8LATj0zJQQKLybHLgJ
   etKSXa6OVXgnaT71WsUqAyqTT6ns3hl1XUzVewQ1LJBRYt8acfYjxIYGo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089641"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089641"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372489"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372489"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:33 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 076/113] KVM: x86: Assume timer IRQ was injected if APIC state is proteced
Date:   Thu, 12 Jan 2023 08:32:24 -0800
Message-Id: <ffc9a600c62a53490e535532f408df1bed95c09e.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9e8d768ce83f..9e5ffe355847 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1607,8 +1607,17 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
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

