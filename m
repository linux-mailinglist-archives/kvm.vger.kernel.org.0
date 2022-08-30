Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442D15A62CC
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiH3MC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiH3MCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E834EA319;
        Tue, 30 Aug 2022 05:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860923; x=1693396923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9IEoA4ocQWS+BnaWE2eKSbUpco8c34vmEkNWuWscBno=;
  b=hHfKnQobAHiEoMzxgq07jRaP5BV/6b5IEWnB5iUWYzC9thg6BI3Et2CE
   eGEfs/RZeoTxwr02uxndbXGmv4dRqvFeJYUYM0f5obuOvJIrGInT4u1dh
   JrZZTrsTzI21RZqOuLCMCgiAlWIXGKzO0cSHG7Gs2mIC8fMHURXiN0LaQ
   6ju1VsAqefG4tYVJsraw1HB18qnLll3e8o7k9HkWbSa5GAMmHODSVnWiP
   dKrDg4haDzhyOZcgJgsXC24Tyq4nkwCuKiRZEtI3Ssgc4zpBGx2VezqB7
   jLwN9n/D/val6W/3QjfdSUAgvHiT/k8XLUQdH/EFRsLQiCLQDmRJRUX70
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870988"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870988"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469651"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:59 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 13/19] KVM: Do processor compatibility check on cpu online and resume
Date:   Tue, 30 Aug 2022 05:01:28 -0700
Message-Id: <436cecd4b5a11056f89a46f2cd1cae67be18b192.1661860550.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661860550.git.isaku.yamahata@intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
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

So far the processor compatibility check is not done for newly added CPU.
It should be done.  For online cpu case, the function is called by kernel
thread bind to the cpu without irq disabled.  So remove
WARN_ON(!irq_disabled()).

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c  |  2 --
 virt/kvm/kvm_arch.c | 15 +++++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b112cd7de58..ac185e199f69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12003,8 +12003,6 @@ int kvm_arch_check_processor_compat(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
 
-	WARN_ON(!irqs_disabled());
-
 	if (__cr4_reserved_bits(cpu_has, c) !=
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 3990f85edab3..e440d4a99c8a 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -99,6 +99,12 @@ __weak int kvm_arch_del_vm(int usage_count)
 
 __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
+	int r;
+
+	r = kvm_arch_check_processor_compat();
+	if (r)
+		return r;
+
 	if (usage_count) {
 		/*
 		 * Abort the CPU online process if hardware virtualization cannot
@@ -132,6 +138,11 @@ __weak int kvm_arch_suspend(int usage_count)
 
 __weak void kvm_arch_resume(int usage_count)
 {
-	if (usage_count)
-		(void)__hardware_enable();
+	if (kvm_arch_check_processor_compat())
+		return; /* FIXME: disable KVM */
+
+	if (!usage_count)
+		return;
+
+	(void)__hardware_enable();
 }
-- 
2.25.1

