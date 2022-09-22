Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE495E6AA6
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbiIVSVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiIVSVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:21:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921CF10AB27;
        Thu, 22 Sep 2022 11:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870886; x=1695406886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3j7AGT1eIC/BE0MhW+coP+8A6Ov/SyQoyWvgLPvXMnc=;
  b=SyvpkJdP7b70ZGFSZNoWMCFSyTUjmW89uB7vQViUZg2fqYVGuZmz2pZX
   g3YXqPLqHK++29qmF9Nns9hAfhYIVWoGf6OfHHuRecMfzzqTTC/YXA0q4
   gefPLShTnwQjVP88WCcbjE8oKoGskmlMPP/5JdbQBQit5xeVm6W92nedh
   pfMKE9jMH07w5UsDb9FLIIs800TfC1f9gxfelivAyC/cyXlJTDP5E8O2N
   Nsh5ctFyaFdYkIebXhQllQm6bKq4rFiilPmHBU4Wh91KPKRJVHn6W9nqq
   5qp/tp2oqp7tiPgI6gB+wz28N99xeXrOG+Y30z5pX3EAiKcY045UkoZrQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="386675992"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="386675992"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086727"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:19 -0700
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
Subject: [PATCH v5 12/30] KVM: Add arch hook for suspend
Date:   Thu, 22 Sep 2022 11:20:41 -0700
Message-Id: <ad5635d3477a14c8084ce85f2031308d3a9dc381.1663869838.git.isaku.yamahata@intel.com>
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

Factor out the logic on suspend event as arch callback.  Later kvm/x86 will
override it.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 21 ++++++++++++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 084ee8a13e9f..861aad8812ff 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1435,6 +1435,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 int kvm_arch_reboot(int val);
+int kvm_arch_suspend(int usage_count);
 
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 58385000b73f..0ebe43a695e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1148,6 +1148,17 @@ int __weak kvm_arch_reboot(int val)
 	return NOTIFY_OK;
 }
 
+int __weak kvm_arch_suspend(int usage_count)
+{
+	if (usage_count)
+		/*
+		 * Because kvm_suspend() is called with interrupt disabled,  no
+		 * need to disable preemption.
+		 */
+		hardware_disable_nolock(NULL);
+	return 0;
+}
+
 /*
  * Called just after removing the VM from the vm_list, but before doing any
  * other destruction.
@@ -5753,15 +5764,7 @@ static int kvm_suspend(void)
 	 * locking.
 	 */
 	lockdep_assert_not_held(&kvm_lock);
-
-	if (kvm_usage_count) {
-		/*
-		 * Because kvm_suspend() is called with interrupt disabled,  no
-		 * need to disable preemption.
-		 */
-		hardware_disable_nolock(NULL);
-	}
-	return 0;
+	return kvm_arch_suspend(kvm_usage_count);
 }
 
 static void kvm_resume(void)
-- 
2.25.1

