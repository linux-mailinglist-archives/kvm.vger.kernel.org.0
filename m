Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1236EAFA0
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjDUQvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbjDUQvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:51:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1625C15611;
        Fri, 21 Apr 2023 09:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095852; x=1713631852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i7lV+AJDDwMSt8GlHXcIg9vDWIXFzEYq7jFzVP/darg=;
  b=S4VoRY3bOzWdh/bIHqKxOUN8M1VcgCFS65kDra5kAW3ELMgF7SX/Egpn
   mtwtjIES9FIp7iZTXnPPq5XH6/nvl/aALfnOBGlrG3L8JbjMwsKxdNDyN
   7TIoUBfvfWtFqZZbtCOv2rZVty/rQIGyZ6saQkamm+Vanb55BhSU3OKrJ
   YMrxoPsG5JWuluzOI82cYOfLVwEvNU6qoBvjsIcf7r7eqnMEgsvIfyJcX
   W0+qJVNN6QGG7fiQQSbNQZZZcKbZRq/cz0sUa/WxVH6Ka910H4rWzEHGj
   Q8ND5Ou6S8uE1apKDog0m1NQ4ADQXomgKkD9njoIrvVRqY6rvEeG6JYVw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787054"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787054"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817412"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817412"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 16/21] KVM:x86: Save/Restore GUEST_SSP to/from SMM state save area
Date:   Fri, 21 Apr 2023 09:46:10 -0400
Message-Id: <20230421134615.62539-17-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
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

