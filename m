Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9186B5E6AA9
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiIVSV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiIVSVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:21:22 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7F210AB0F;
        Thu, 22 Sep 2022 11:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870881; x=1695406881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FvgmsUs8lZSxyh4Y20DUAz52tAJaGD/FMSGQt1yYizU=;
  b=hrQVtJDyWatL6xxGM/5SfG8asl7eIXjGs78PNuYijbsN0guws9YqjR0Y
   mzrumyZPkpTmgSTH9r0SutGOVJ+51Uahzjj/5S2FimO2z5BOVkXlO9QMg
   /QNDXdYD2KSnL9GpMIrqduQBN8/CKeMFev8mJl8pF31DDPT00dJSe7smi
   lHdJv6Imfax3kCaZ61DP0T52pRuqSL4B0LltcutnjyWmlpt8bHV5OnWO5
   gkyqRmdV0p61Jmpeui5bZA0/GeVX4d7gtThwDkJuJxs+Mh9YYgygrIFcx
   1h0C6QcKNKxYixL54qUv1FYIeDxUz9wvusirzlRbu1sc5qn25oDi22bhA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="386675930"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="386675930"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086630"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:13 -0700
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
        Borislav Petkov <bp@alien8.de>, Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v5 02/30] KVM: x86: Use this_cpu_ptr() instead of per_cpu_ptr(smp_processor_id())
Date:   Thu, 22 Sep 2022 11:20:31 -0700
Message-Id: <851653aeb7230572e5b41cc617e89eeae38be24b.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

convert per_cpu_ptr(smp_processor_id()) to this_cpu_ptr() as trivial
cleanup.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e1b3af4a074..7fc19533a484 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -428,8 +428,7 @@ static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
 
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
 	int err;
 
 	kvm_user_return_msr_init_cpu(msrs);
@@ -453,8 +452,7 @@ EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
 static void drop_user_return_notifiers(void)
 {
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
 
 	if (msrs->registered)
 		kvm_on_user_return(&msrs->urn);
-- 
2.25.1

