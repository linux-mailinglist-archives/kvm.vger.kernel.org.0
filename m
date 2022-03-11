Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC53C4D5F88
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 11:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347949AbiCKKdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 05:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbiCKKdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 05:33:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E021BFDF8;
        Fri, 11 Mar 2022 02:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646994731; x=1678530731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e/UsX7cNMuryOkY6jULWGNVc2efVlgmX0ItMhmQS2qw=;
  b=bCFvsCV9nTerews7pfommMehZmsZhKkpJs3OSqHNtTC/aIbCvocuMtXJ
   NTCsD34ogumNbYX3yh0hJpRqwSUkJ7D88xsaxMhdvNCiwngib4ZHIuQSz
   AnWDtiJLVuvJSgrDdQ6M+WJFoQ9/mY95gU99XZruGiK3GlLEU8QLawybi
   OpOc1SoVLfJ/B6K+EPTcx2BJJpd474PC9MgTmyuXVGw8/NxSJq98kf2GQ
   /jfQ+alrk4c2VR44MtmCmQLrwhJRDzR6/Y6XhSEFB1lMVdBqvBDIL22BF
   C6DkwO+YFyPF0na53iH+6koDNsn4NmUQigw0FbCFbWHN+NQhpsbKod+L7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="341976375"
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="341976375"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 02:32:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,173,1643702400"; 
   d="scan'208";a="538955722"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 02:32:07 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH v2 2/2] KVM: x86: Remove redundant vm_entry_controls_clearbit() call
Date:   Fri, 11 Mar 2022 18:26:43 +0800
Message-Id: <20220311102643.807507-3-zhenzhong.duan@intel.com>
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

When emulating exit from long mode, EFER_LMA is cleared which lead to
efer writing emulation, which will unset VM_ENTRY_IA32E_MODE control
bit as requested by SDM. So no need to unset VM_ENTRY_IA32E_MODE again
in exit_lmode() explicitly.

In fact benefited from shadow controls mechanism, this change doesn't
eliminate vmread or vmwrite.

In case EFER isn't supported by hardware, long mode isn't supported,
so this will no break.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cadb3769031c..70717f56a2a2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2907,7 +2907,6 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 
 static void exit_lmode(struct kvm_vcpu *vcpu)
 {
-	vm_entry_controls_clearbit(to_vmx(vcpu), VM_ENTRY_IA32E_MODE);
 	vmx_set_efer(vcpu, vcpu->arch.efer & ~EFER_LMA);
 }
 
-- 
2.25.1

