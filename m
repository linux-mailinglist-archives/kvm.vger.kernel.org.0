Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38156FEC8A
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbjEKHPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237549AbjEKHOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:14:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F528A42;
        Thu, 11 May 2023 00:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789238; x=1715325238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i7lV+AJDDwMSt8GlHXcIg9vDWIXFzEYq7jFzVP/darg=;
  b=YVdRmoPa9C8Z4O1+YxTv1ARmzlXUMpORhv6JHuzHcugiOLk5IkYfswK/
   Rl3kXxhtKAqD99zRcVx6LgmQ2Z0HGmChzYhSkvXGKqgt79XH6hC/Rl4lR
   42Mt8obw8YJ8gl402bc8Is4balVptHxd0Qjix0IpA2SuKDkW52zdPtTLj
   wepUtueVGH17A+eWM3EsxoKWJuxS72PmNAcC55OyLknRtIQDkZ3fa/spx
   VQN6I8wYTx/9M6XNBU5oVatKReephfhLDEOx2r+RSIKR4kAgFO6nryKs9
   Sx4F8E1jKC5d8G1t/CZB71Nq+NhBVWTnQOo/Gv145ndAN4Rvq+hoD5X0X
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896680"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896680"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512388"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512388"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:26 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v3 16/21] KVM:x86: Save/Restore GUEST_SSP to/from SMM state save area
Date:   Thu, 11 May 2023 00:08:52 -0400
Message-Id: <20230511040857.6094-17-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save GUEST_SSP to SMM state save area when guest exits to SMM
due to SMI and restore it VMCS field when guest exits SMM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/smm.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index b42111a24cc2..c54d3eb2b7e4 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -275,6 +275,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
 
 	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
+
+	if (kvm_cet_user_supported()) {
+		struct msr_data msr;
+
+		msr.index = MSR_KVM_GUEST_SSP;
+		msr.host_initiated = true;
+		/* GUEST_SSP is stored in VMCS at vm-exit. */
+		static_call(kvm_x86_get_msr)(vcpu, &msr);
+		smram->ssp = msr.data;
+	}
 }
 #endif
 
@@ -565,6 +575,16 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
 	ctxt->interruptibility = (u8)smstate->int_shadow;
 
+	if (kvm_cet_user_supported()) {
+		struct msr_data msr;
+
+		msr.index = MSR_KVM_GUEST_SSP;
+		msr.host_initiated = true;
+		msr.data = smstate->ssp;
+		/* Mimic host_initiated access to bypass ssp access check. */
+		static_call(kvm_x86_set_msr)(vcpu, &msr);
+	}
+
 	return X86EMUL_CONTINUE;
 }
 #endif
-- 
2.27.0

