Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D1F71428A
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjE2EUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjE2EUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:20:47 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A56B1;
        Sun, 28 May 2023 21:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334044; x=1716870044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MKnGiDEs752LajLT4rj1fw59cY3aNrVMzRp3TA7UHGo=;
  b=jtDXOuZmj7O97OmwyCECx2DwRnAOIS7n/ALt+q+UtU7Ddj7NUYHlAC7G
   FsygHhwYZZDwommkQC/IALufE6PpOAZatEkqJuZnaEM+hbYumZoll91je
   eLM8qFyyrgANqBf8b3mooW4Y6aRjt38oSR9AvUNQ4cvqNsgkZdwOomkWZ
   tDKFL8g0i0J6p6xgMLBqU+nS5qeHN2t15gnF+TrgK0LjG2idjOV7Q6oOH
   wHdIRMycLq5oI09W2kG6oB4k2k02kv3sh6k6hiwNQ2BOlDioOHAdrw444
   163nOlrcCk2vj46jkFEzRmtCyx+dikZ0tBzHqDUh6dFa0p1DEnyDr5ajg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="418094234"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="418094234"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="683419286"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="683419286"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:20:42 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 002/113] KVM: x86/vmx: initialize loaded_vmcss_on_cpu in vmx_hardware_setup()
Date:   Sun, 28 May 2023 21:18:44 -0700
Message-Id: <cf6589003b1fa0a4fe92c0daa43f169f633b3d6a.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 66d93164cea0..ed7bf8fc55a8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8179,8 +8179,12 @@ __init int vmx_hardware_setup(void)
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
 
@@ -8427,11 +8431,8 @@ static int __init vmx_init(void)
 
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

