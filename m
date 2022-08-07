Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EB058BD2B
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbiHGWEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiHGWCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14309596;
        Sun,  7 Aug 2022 15:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909760; x=1691445760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lrdUUyGY5FAg5aF/ecsuvlLc8QeY6sIVMwfcSyZ3SOI=;
  b=MiYcV/gU5AQLzo/yKcYEF+qVZOSXc4hvNBlI85gj6JBtDppbZEhvwZJ6
   uunAzxOQwUB5aSDTBub4DMlEMcT0k3mDz8v3q5Fg5lLh0ciQidqfSUDHr
   TkXVJUfavo/E2o99LYPU4wed7up8CMWLV8nPpn2qKGTJB85jskPjZdoyw
   CmTI7/AdsgV00IaXBCL6QcMsrBSzrqB2c/uomchM7tN4ceZC/DI/w7lJE
   j0LIyftvqvrUrMJvy6oHW0MM3Ls/9z7LNuvnWT/pLCcIecNU0XRIV628U
   RZ+iETDSZJrgL87ocBBq2hjc2IzU7SHGwM4vERfkC4wEQwYfBm2lGMK8u
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240359"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240359"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682679"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:40 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 071/103] KVM: TDX: restore debug store when TD exit
Date:   Sun,  7 Aug 2022 15:01:56 -0700
Message-Id: <bcaa0958cd0e31a49539f9187c2e9ca32b040e53.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because debug store is clobbered, restore it on TD exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/events/intel/ds.c | 1 +
 arch/x86/kvm/vmx/tdx.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 376cc3d66094..cdba4227ad3b 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2256,3 +2256,4 @@ void perf_restore_debug_store(void)
 
 	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
 }
+EXPORT_SYMBOL_GPL(perf_restore_debug_store);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2c5fda9e213e..2354889df571 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -650,6 +650,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
 	tdx_user_return_update_cache();
+	perf_restore_debug_store();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
-- 
2.25.1

