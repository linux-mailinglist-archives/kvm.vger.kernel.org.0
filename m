Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F254D5F87
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 11:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347936AbiCKKdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 05:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347932AbiCKKdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 05:33:10 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F17C1B8C80;
        Fri, 11 Mar 2022 02:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646994727; x=1678530727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CUrQ4iZGpwAUu9vgjv4Bg8vnW+Jbs0mMi6B0DF1SJL8=;
  b=DrUJWJ2Ef5pZyi1OdBLWj+UN9Fmqj8sRlUaHQ2YfvozNwY0HMky9CVcm
   rUh6jte0AEdv4xiUlptcwGuwPQnwk7eF8DgQb/tpkc2T4qHeuB7JFmvRp
   L2X1GkJqUVvdNT3U4iE46zL7ZBtox8MrlU0OHbbg0oSokPl7NZTNyFb1b
   zJ9zgkFZLbX8guUP6EMgujF+Wv7dPD+x1VsdDSCNKG2snDhN8acZ4fgDD
   O8XxeTDaosTvcdlBEw5+xzCVka75bZCGECwcp6+Pl6U67btbio7g7NLfZ
   uZssGzFBDNQ86yWRVaESoH/iVhAwpF3cdpkV0srgV8gekPw0lq6BFdXRd
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="341976368"
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="341976368"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 02:32:07 -0800
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="538955709"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 02:32:04 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH v2 1/2] KVM: x86: Remove unnecessory assignment to uret->data
Date:   Fri, 11 Mar 2022 18:26:42 +0800
Message-Id: <20220311102643.807507-2-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220311102643.807507-1-zhenzhong.duan@intel.com>
References: <20220311102643.807507-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While update_transition_efer() doesn't unconditionally set uret->data,
which on the surface makes this look suspect, but it's safe because
uret->data is consumed if and only if uret->load_into_hardware is
true, and it's (a) set to false if uret->data isn't updated and
(b) uret->data is guaranteed to be updated before it's set to true.

Drop the local "msr" and use "vmx" directly instead of redoing to_vmx().

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b730d799c26e..cadb3769031c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2871,21 +2871,17 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct vmx_uret_msr *msr = vmx_find_uret_msr(vmx, MSR_EFER);
 
 	/* Nothing to do if hardware doesn't support EFER. */
-	if (!msr)
+	if (!vmx_find_uret_msr(vmx, MSR_EFER))
 		return 0;
 
 	vcpu->arch.efer = efer;
-	if (efer & EFER_LMA) {
-		vm_entry_controls_setbit(to_vmx(vcpu), VM_ENTRY_IA32E_MODE);
-		msr->data = efer;
-	} else {
-		vm_entry_controls_clearbit(to_vmx(vcpu), VM_ENTRY_IA32E_MODE);
+	if (efer & EFER_LMA)
+		vm_entry_controls_setbit(vmx, VM_ENTRY_IA32E_MODE);
+	else
+		vm_entry_controls_clearbit(vmx, VM_ENTRY_IA32E_MODE);
 
-		msr->data = efer & ~EFER_LME;
-	}
 	vmx_setup_uret_msrs(vmx);
 	return 0;
 }
-- 
2.25.1

