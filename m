Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D52875BE5A
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjGUGJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjGUGIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D22292;
        Thu, 20 Jul 2023 23:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919734; x=1721455734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TLsCDwkPypQyoDGr6WA5M8mk+rSbh1ZROOPBD8uLgVM=;
  b=Q+Y9TnWjyRBrD/wc3at1uonwO1muE6vcB6PAs70p8SmzEEHFtClxx7lT
   0ZQizZCHMDXmELcX+nUCdzuT9TRfYD+WfQ5YBqNGCkObtbl2Hj4tpSod9
   eB6Zsrocnqd8Uk2B2l6NPeOpvooCqfZP49t/cQr/iPCImSP2hxxwOHeV3
   lX2uOd00H9PSVBtDV8ACHeLrLb35Cc0YVM2o3QOaMpveTJB/E4FQS9Gnh
   70MvNIySnk7yNhZkWIsJbl9UGF02RqupWY8e+XW+hr00enUq5GYZsycb1
   YU+NMCHGUETiv6Ky56OfoKoQgA6+c0kWb3SZIlUXXPFcVRTOmqZnRqdsC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547533"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547533"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721964"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721964"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 07/20] KVM:x86: Add fault checks for guest CR4.CET setting
Date:   Thu, 20 Jul 2023 23:03:39 -0400
Message-Id: <20230721030352.72414-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check potential faults for CR4.CET setting per Intel SDM.
CET can be enabled if and only if CR0.WP==1, i.e. setting
CR4.CET=1 faults if CR0.WP==0 and setting CR0.WP=0 fails
if CR4.CET==1.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04f0245ad0a2..be76ac6bbb21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -993,6 +993,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
+		return 1;
+
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1204,6 +1207,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
+		return 1;
+
 	static_call(kvm_x86_set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
-- 
2.27.0

