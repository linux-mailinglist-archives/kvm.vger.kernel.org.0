Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1B75E6AD4
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiIVSY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiIVSXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BD910B580;
        Thu, 22 Sep 2022 11:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870948; x=1695406948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xexmELbi5aH40qDujxrSWqQj4dEkU4fMT/enlz5uNnQ=;
  b=AB/8BM+mTCFs9ly15QjUz3y1vPXNnekDwSW4FQoRJE+c0CYWDkDBB46D
   9h2Lmus+IKCRCz/OEI+Pis4VVo21Ti6MQ4f8DosxKB6SieDmaH6P+A2T6
   a1+d+t6BKUf6qKsnkL/cAllfwqgQ7VYA6GwkSeszWDO0Bs4kXSCXMZSOs
   l4U9b9vGPSaO0p9ucGXnJprnUdcUh61qdV7+ymMSpVtcbcN/LPuX1ogiX
   fqs4dx90zGx9hxaPcGY5Gu3aAo4Fssjr6TKz/X9SC+Ums4bANGE9i+kGN
   WG1hE9qkLH/mSUNcny62XqVyTBdWilcbfLt/NWXoi3YeCQuHgt3j010cG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712932"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712932"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086875"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:27 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 25/30] KVM: x86: Delete kvm_arch_hardware_enable/disable()
Date:   Thu, 22 Sep 2022 11:20:54 -0700
Message-Id: <23e34c8aba1372d6e7c054b737242f08a614078d.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Now they're function call and there is no point to keep them.  Open code
them.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01687b553915..aa6594de1fc1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -354,7 +354,7 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 
 	/*
 	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_hardware_disable()
+	 * interrupted and executed through hardware_disable()
 	 */
 	local_irq_save(flags);
 	if (msrs->registered) {
@@ -11864,11 +11864,6 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
-static int kvm_arch_hardware_enable(void)
-{
-	return static_call(kvm_x86_hardware_enable)();
-}
-
 static int __hardware_enable(void);
 
 void kvm_arch_resume(int usage_count)
@@ -11961,12 +11956,6 @@ void kvm_arch_resume(int usage_count)
 	}
 }
 
-static void kvm_arch_hardware_disable(void)
-{
-	static_call(kvm_x86_hardware_disable)();
-	drop_user_return_notifiers();
-}
-
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 
 static int __hardware_enable(void)
@@ -11978,7 +11967,7 @@ static int __hardware_enable(void)
 
 	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
 		return 0;
-	r = kvm_arch_hardware_enable();
+	r = static_call(kvm_x86_hardware_enable)();
 	if (r)
 		pr_warn("kvm: enabling virtualization on CPU%d failed during %pSb\n",
 			cpu, __builtin_return_address(0));
@@ -12004,7 +11993,8 @@ static void hardware_disable(void *junk)
 	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
 		return;
 	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
-	kvm_arch_hardware_disable();
+	static_call(kvm_x86_hardware_disable)();
+	drop_user_return_notifiers();
 }
 
 /*
-- 
2.25.1

