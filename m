Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DC76FEC93
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbjEKHPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbjEKHO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:14:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B767D9EC1;
        Thu, 11 May 2023 00:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789259; x=1715325259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nBe0qXcnNHhJ84SptlgfdsQFDbSH+mW0zYFkQvIGEPk=;
  b=RL4Y7Q5Iyjj3qoeG4mZIC7mHX20Za+cwcTXeUOKkvrXZG0FEhakLLbre
   9j+9fs2In9r41vI8iDsweyFkFdkZfpdjGK3ebuS95aYpEApRneq3/H6cG
   G3L5a1fRLBSopzgbwseKISbGmsdkXNU9u3NUIbKjAxAmEpyQk4pG0tbrN
   sH7G0nJOYi/2Gj3O+AgFVo4B4hMwTdPZPu0gkwles9cATh8yCEE2UG3BO
   0HwCJWdtJsLKc4gqczZqKSDAx44qYhAdQ+LfHh5Wn3wNtu1VrJbZi2EWB
   We71088wqLt4TDZFAz+UWKkr3ql+etzPh1PEIr6vMHTFI68Vr46wY1sgm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896715"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896715"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512384"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512384"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:25 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 15/21] KVM:x86: Report CET MSRs as to-be-saved if CET is supported
Date:   Thu, 11 May 2023 00:08:51 -0400
Message-Id: <20230511040857.6094-16-weijiang.yang@intel.com>
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

Report CET user mode MSRs, including the synthetic GUEST_SSP MSR,
as to-be-saved MSRs.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index baac6acebd40..50026557fb2a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1470,6 +1470,7 @@ static const u32 msrs_to_save_base[] = {
 
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
+	MSR_IA32_U_CET, MSR_IA32_PL3_SSP, MSR_KVM_GUEST_SSP,
 };
 
 static const u32 msrs_to_save_pmu[] = {
-- 
2.27.0

