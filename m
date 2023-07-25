Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8927625B9
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjGYWPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjGYWPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:35 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F460B6;
        Tue, 25 Jul 2023 15:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323334; x=1721859334;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q6K2maaUsjgfiXlRf9woadg1SoAwVb/MVIcmVsQ7T20=;
  b=R7Tss8A+m1rVbXQ54g1TCaRVSOujtMNkXVuOOZGFihTZrEepGdyxpYnA
   5FImPgz6RG5wIPienbXnY6ZYOpLQ96Q5A4p5cxoxTQ1ZqvSNvtWzcZ8I9
   cAsl6NF2GG4T9l0P1nggDDi/gm7HWToqpgkCv0i6I9Px4sjEuZeQlxnKb
   bzOSvhIPSsS6ooi6v2Gg+QCODSIyG8t/M5wdJrJQZQzBXvfQlJwquqFb9
   F1pG0n7TNAM1yD3WC6u+e2yVbXcmkhXIuxE9yz0vtElq+ndj8hfh7//Rt
   jHCkqQkp5TTNtspaJmzibLTg0Ck64Nk0Cniad2yNYmXHZErYN6PK2t5WC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863022"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863022"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938768"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938768"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:15 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 002/115] KVM: x86/vmx: initialize loaded_vmcss_on_cpu in vmx_hardware_setup()
Date:   Tue, 25 Jul 2023 15:13:13 -0700
Message-Id: <f22df73e1037c9386bafb788394e790540c3c1a9.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

vmx_hardware_disable() accesses loaded_vmcss_on_cpu via
hardware_disable_all().  To allow hardware_enable/disable_all() before
kvm_init(), initialize it in vmx_hardware_setup() so that tdx module
initialization, hardware_setup method, can reference the variable.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4d8655a905c4..9b035d5571fe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8227,8 +8227,12 @@ __init int vmx_hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
+	int cpu;
 	int r;
 
+	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 	store_idt(&dt);
 	host_idt_base = dt.address;
 
@@ -8475,11 +8479,8 @@ static int __init vmx_init(void)
 
 	vmx_setup_fb_clear_ctrl();
 
-	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
+	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
-	}
 
 #ifdef CONFIG_KEXEC_CORE
 	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
-- 
2.25.1

