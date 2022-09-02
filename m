Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB0F5AA59B
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiIBCTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiIBCS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EF9AB055;
        Thu,  1 Sep 2022 19:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085101; x=1693621101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kP8Ku5Lv8rqfw0Nma82+ZaeLrsDvE/lPJOPwAOWO6Gg=;
  b=HejgL1XlZmwwU2nKwNzVjjgyw1cD+yZ+OWCIB2Wm/BaSdUb1ByGny+og
   8RWH66K1VYE4QizvTcdzt8qbBklFejFGSr+S0w4jY6796Q3+KOg9x9zMa
   +btw6Ec2Kh0xTetLY+pU12PnabT514ReUF/16uPA5TlUFtgwtOQuiBK7k
   qGXaXjppWMhBFAHmFNmsxO6lRn5+3rBo7lKPellRR+Ig9Ky5vckYqcStW
   LH75l2+1zbZ+ekkwUCJKIICnZ7H5ZuGO4HsZczJSXo0YZdi/wkFLzgbq8
   G3FPS2xHz58/+EZTONO5XYbUXyKadcwXFtAAq2EpcUwVUiiOZEAljsoNr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157867"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157867"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:21 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835672"
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
Subject: [PATCH v3 20/22] KVM: Add config to not compile kvm_arch.c
Date:   Thu,  1 Sep 2022 19:17:55 -0700
Message-Id: <3faaf048edc544cc9bcedd9e3bc1fc6decbb7cb4.1662084396.git.isaku.yamahata@intel.com>
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

So that kvm_arch_hardware_enable/disable() aren't defined.

Once the conversion of all KVM archs is done, this config and kvm_arch.c
should be removed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig     | 1 +
 include/linux/kvm_host.h | 2 ++
 virt/kvm/Kconfig         | 3 +++
 virt/kvm/Makefile.kvm    | 5 ++++-
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e3cbd7706136..e2e16205425d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -25,6 +25,7 @@ config KVM
 	depends on X86_LOCAL_APIC
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
+	select HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_IRQFD
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8abbf7a1773b..74111118db42 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1434,8 +1434,10 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
+#ifndef CONFIG_HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
+#endif
 int kvm_arch_hardware_setup(void *opaque);
 void kvm_arch_pre_hardware_unsetup(void);
 void kvm_arch_hardware_unsetup(void);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index a8c5c9f06b3c..917314a87696 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -72,3 +72,6 @@ config KVM_XFER_TO_GUEST_WORK
 
 config HAVE_KVM_PM_NOTIFIER
        bool
+
+config HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
+	def_bool n
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index c4210acabd35..c0187ec4f83c 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -5,7 +5,10 @@
 
 KVM ?= ../../../virt/kvm
 
-kvm-y := $(KVM)/kvm_main.o $(KVM)/kvm_arch.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
+kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
+ifneq ($(CONFIG_HAVE_KVM_OVERRIDE_HARDWARE_ENABLE), y)
+kvm-y += $(KVM)/kvm_arch.o
+endif
 kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
-- 
2.25.1

