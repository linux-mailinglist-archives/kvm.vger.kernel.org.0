Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBDD5AA5AC
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiIBCTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiIBCSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EEDAB059;
        Thu,  1 Sep 2022 19:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085102; x=1693621102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mjHCuUh4QzwKqJ2CYqtbn0vRlgOAmqqF6RfZuHZQYJ0=;
  b=mIHtEQ0h3nWkSjD0VmycGblcOc1uxMyTEE8uHMZt/7PtJeT16uceMr+M
   KiPUdYmhgcImkj8wewkjGsQxvpdzC/YAUmgZZS+EtnEWFiqF5oOQHqzCW
   PaLOmqCQSfikB1CY5bI0YJAa/x5Db07HYlXoOH6P5iLXJCadMxzCOwdiu
   a8OxEl4E/JRNxmFBPi5VVGTorf1ex00+/fZuAxUrClu6Bk4j7PE2x7WW4
   3uM5QcKi2zhCaqZM1Z67t9vnY4s8ezHCXv03SWvl2VaE06/ba3A1QCERr
   poIU9I3DB9mOgRQA2OnmdfYTQFzX8bpj33lWgRb6QlVlcf8uZmKSdhGJD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157868"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157868"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:21 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835676"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:21 -0700
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
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v3 21/22] RFC: KVM: x86: Remove cpus_hardware_enabled and related sanity check
Date:   Thu,  1 Sep 2022 19:17:56 -0700
Message-Id: <d0033c78b2aaffda2666810b95a8265ba506ee81.1662084396.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662084396.git.isaku.yamahata@intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

cpus_hardware_enabled mask seems incomplete protection against other kernel
component using CPU virtualization feature.  Because it's obscure and
incomplete, remove the check.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f0382f3d5baf..15e123757b11 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11834,23 +11834,16 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
-static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
-
 static int __hardware_enable(void *caller_name)
 {
-	int cpu = raw_smp_processor_id();
 	int r;
 
 	WARN_ON_ONCE(preemptible());
 
-	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return 0;
 	r = static_call(kvm_x86_hardware_enable)();
 	if (r)
 		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
-			cpu, (const char *)caller_name);
-	else
-		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+			smp_processor_id(), (const char *)caller_name);
 	return r;
 }
 
@@ -11864,13 +11857,7 @@ static void hardware_enable(void *arg)
 
 static void hardware_disable(void *junk)
 {
-	int cpu = raw_smp_processor_id();
-
 	WARN_ON_ONCE(preemptible());
-
-	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return;
-	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
 	static_call(kvm_x86_hardware_disable)();
 	drop_user_return_notifiers();
 }
-- 
2.25.1

