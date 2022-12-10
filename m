Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5D7648FC2
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiLJQUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiLJQTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:19:33 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3073A1AA30;
        Sat, 10 Dec 2022 08:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689157; x=1702225157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SkNqvz6MYSdiJAug06PS7TZ56gPXaAGM412+ZDbyQLU=;
  b=eghg1UErXLVq3PlKvShACs5hXgqjfabTrIfwMKw6axcmeXA3uP/CilGg
   sp+e6G+D5G/zz4XqUVoEQydDyqbS9GzMVFKlPNWitDMXOiaBWymS3IHiD
   u3YTGNwoC2+8v03xp4wRqvIWLrfEwem+bK6l7t/Z0FWq81erafIuj3cCm
   LRmJFTNLtihNVl5pvgmno/byTCSBkHrSgPGeH0cd4K2ybJCO6QF2eJyUs
   XQmpLXS3Kubpe5p6JLGiXsE5WAb9DhRsyVYqwvjmzQ856FUn1zEa6pPWn
   H/Sib43LcaCa34LLb7ph5gM5y8SaBE9hFJyh6c6ird4lZ3PmQ8hu+ro/D
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780521"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780521"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208722"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208722"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:13 -0800
From:   Zhang Chen <chen.zhang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Zhang Chen <chen.zhang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 9/9] x86/kvm/vmx: Initialize SPEC_CTRL MASK for BHI
Date:   Sun, 11 Dec 2022 00:00:46 +0800
Message-Id: <20221210160046.2608762-10-chen.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210160046.2608762-1-chen.zhang@intel.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMMs can address mitigations issues in migration pool by applying
the needed controls whenever the guest is operating on a newer
processor. If a guest is using the BHB-clearing sequence
on transitions into CPL0 to mitigate BHI, the VMM can use the
“virtual IA32_SPEC_CTRL” VM-execution control to set BHI_DIS_S
on newer hardware which does not enumerate BHI_NO.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fb0f3b1639b9..980d1ace9718 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2431,6 +2431,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->spec_ctrl_mask &= ~SPEC_CTRL_RRSBA_DIS_S;
 
+		if (data & MITI_CTRL_BHB_CLEAR_SEQ_S_USED &&
+		    kvm_cpu_cap_has(X86_FEATURE_BHI_CTRL) &&
+		    !(arch_msr & ARCH_CAP_BHI_NO))
+			vmx->spec_ctrl_mask |= SPEC_CTRL_BHI_DIS_S;
+		else
+			vmx->spec_ctrl_mask &= ~SPEC_CTRL_BHI_DIS_S;
+
 		if (cpu_has_virt_spec_ctrl()) {
 			vmcs_write64(IA32_SPEC_CTRL_MASK, vmx->spec_ctrl_mask);
 		} else if (vmx->spec_ctrl_mask) {
-- 
2.25.1

