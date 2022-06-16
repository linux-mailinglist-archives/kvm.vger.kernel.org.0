Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC90D54DD63
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376284AbiFPIt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376350AbiFPIsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA3C2DAAC;
        Thu, 16 Jun 2022 01:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369265; x=1686905265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R7sGqyE6ELUI6BrR6Bhsf2tb+qtJTh756ZHNEPItrck=;
  b=fLK0PIDFI+JmM2r9K/0fKqOD0zEp6kXOiiHl6n9tKaCzWFoyrxR+ikfE
   +WKahze3PSD6XqJo1eLtsy5aLfwyMzkCelveRKeYh9RAGCI8d08s+7CX7
   JiqV6iQARyG0LWij+qGGFNIRLkkRXUkRiwWonwdtATuyNyMafO6yWsE/O
   BYvoQjSMvKIjP4uKqee2Kw5Vaj42QHF9HnL1eDE2h/+tSQ0cwxyQUBc4b
   GUcofB1bLKhUN2KJCvMA+MxKh/onTicxcFbbu4Y81uHr+Wj0KW0W5Wyfq
   H8GNynAMZ5IHx68be9vWzt4iZmvhBIkz4AwK06Owp+zXlqNwEUxLmU5zF
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259055233"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259055233"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083172"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH 15/19] KVM: x86: Save/Restore GUEST_SSP to/from SMM state save area
Date:   Thu, 16 Jun 2022 04:46:39 -0400
Message-Id: <20220616084643.19564-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save GUEST_SSP in the SMM state save area when guest exits to SMM
due to SMI and restore it when guest exits SMM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20210203113421.5759-15-weijiang.yang@intel.com>
[Change the SMM offset to some place that is actually free. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 11 +++++++++++
 arch/x86/kvm/x86.c     | 10 ++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39ea9138224c..eb0d45ae5214 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2558,6 +2558,17 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 			return r;
 	}
 
+	if (kvm_cet_user_supported()) {
+		struct msr_data msr;
+
+		val = GET_SMSTATE(u64, smstate, 0x7f08);
+		msr.index = MSR_KVM_GUEST_SSP;
+		msr.host_initiated = true;
+		msr.data = val;
+		/* Mimic host_initiated access to bypass ssp access check. */
+		kvm_x86_ops.set_msr(ctxt->vcpu, &msr);
+	}
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3613b73f13fb..86bccb12f036 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9833,6 +9833,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 
 	for (i = 0; i < 6; i++)
 		enter_smm_save_seg_64(vcpu, buf, i);
+
+	if (kvm_cet_user_supported()) {
+		struct msr_data msr;
+
+		msr.index = MSR_KVM_GUEST_SSP;
+		msr.host_initiated = true;
+		/* GUEST_SSP is stored in VMCS at vm-exit. */
+		kvm_x86_ops.get_msr(vcpu, &msr);
+		put_smstate(u64, buf, 0x7f08, msr.data);
+	}
 }
 #endif
 
-- 
2.27.0

