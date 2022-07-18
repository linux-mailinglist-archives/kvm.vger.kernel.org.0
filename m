Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2CB577D90
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 10:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiGRIdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 04:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiGRIdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 04:33:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FFC19019;
        Mon, 18 Jul 2022 01:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658133222; x=1689669222;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=79y8dF/1EZHwFPNzMwvoWWdAytAcu/ymcjci+iNiuRw=;
  b=Ht+CbtZ80w5oKWEcG/cDfn+m8hx2Ex0aq5H0bq0U/jox2IxDtf2vdqF0
   37mR4Pa5SWVJZvsgKvaAzIzJhNf6FeXVaCsdcJZe48QN5fWuyk0s8gw1L
   ltQVMqh35Dbh/duJhhGlu4RYLBZ8bZ1vvss6ug/TdArBIzcKWQP+hje8i
   Tn7ZVmzo3TjXcSUUbJEYGIonIa0WRMc+uhHOMMBferJqy8DD8Py+4lEGz
   cS5AHcrjbTkDNTaSb00iZyd/beHUuaeSQbJ2RdsH86ol4fc6fFgOdV49T
   Y3qsg/2fPR6Jodjumb2tThePy7IYzvSniv1zRidfOqdHR3Til6Q+hjrug
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="372474714"
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="372474714"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 01:33:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,280,1650956400"; 
   d="scan'208";a="594389146"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2022 01:33:40 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, joro@8bytes.org, wanpengli@tencent.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: X86: Explicitly set the 'fault.async_page_fault' value in kvm_fixup_and_inject_pf_error().
Date:   Mon, 18 Jul 2022 15:47:56 +0800
Message-Id: <20220718074756.53788-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_fixup_and_inject_pf_error() was introduced to fixup the error code(
e.g., to add RSVD flag) and inject the #PF to the guest, when guest
MAXPHYADDR is smaller than the host one.

When it comes to nested, L0 is expected to intercept and fix up the #PF
and then inject to L2 directly if
- L2.MAXPHYADDR < L0.MAXPHYADDR and
- L1 has no intention to intercept L2's #PF (e.g., L2 and L1 have the
  same MAXPHYADDR value && L1 is using EPT for L2),
instead of constructing a #PF VM Exit to L1. Currently, with PFEC_MASK
and PFEC_MATCH both set to 0 in vmcs02, the interception and injection
may happen on all L2 #PFs.

However, failing to initialize 'fault' in kvm_fixup_and_inject_pf_error()
may cause the fault.async_page_fault being NOT zeroed, and later the #PF
being treated as a nested async page fault, and then being injected to L1.
Instead of zeroing 'fault' at the beginning of this function, we mannually
set the value of 'fault.async_page_fault', because false is the value we
really expect.

Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216178
Reported-by: Yang Lixiao <lixiao.yang@intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
v2:
- Set 'fault.async_page_fault' mannually to false, instead of initializing
the whole structure based on Sean's suggestion.
- Commit message changes based on the code change.
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 031678eff28e..ffd8c96cfaa5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12999,6 +12999,7 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 		fault.error_code = error_code;
 		fault.nested_page_fault = false;
 		fault.address = gva;
+		fault.async_page_fault = false;
 	}
 	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);
 }
-- 
2.25.1

