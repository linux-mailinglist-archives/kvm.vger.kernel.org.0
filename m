Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF94A5E6AA2
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiIVSV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiIVSVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:21:33 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7661C10AB39;
        Thu, 22 Sep 2022 11:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870889; x=1695406889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rkbhPAbj7cDgUM/73qRc/G+VqqyGPWDg7DKyVgG5eCc=;
  b=hmAIprvsgIthS4/HtgAkW6ZY3TH91+54z2/8L5jUDGwijBBR51M+Qkcx
   Lkas0rDegI551cCCIc+A9emNqWz1f/LLQ4xaXp378ft0Uj/3OvIcW0KH9
   ehgrPtJ+3lZuAjuHDEL+Zk+N4+t0gVNhe5DWqTZkqvxSPQDjoXe3KSSBf
   aIa7ukKhAmBlXr0BBj7Bu/jsB9YDKt/0Wuz24m+nmQseEhn8I9QdSrrTw
   H2pBX3Qc2cij/+uGQyg07WiGw96yz1xUyXkFjJXUC5LwXIeNXQinuoWHy
   5r6eNRLWcO3dtA6aACyByjzdMmRjhvpco6s/dRKTPmyesjhSTnyJ1ZF0M
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="386675995"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="386675995"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086731"
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
Subject: [PATCH v5 13/30] KVM: Add arch hook for resume event
Date:   Thu, 22 Sep 2022 11:20:42 -0700
Message-Id: <f503a2bb23eaccd1e2028d43d1887337f80c15ad.1663869838.git.isaku.yamahata@intel.com>
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

Factor out the logic on resume event as arch callback.  Later kvm/x86 will
override it.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 861aad8812ff..1adbf74e3047 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1436,6 +1436,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 
 int kvm_arch_reboot(int val);
 int kvm_arch_suspend(int usage_count);
+void kvm_arch_resume(int usage_count);
 
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0ebe43a695e5..1270f88c2a1e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1159,6 +1159,12 @@ int __weak kvm_arch_suspend(int usage_count)
 	return 0;
 }
 
+void __weak kvm_arch_resume(int usage_count)
+{
+	if (usage_count)
+		hardware_enable_nolock(NULL);
+}
+
 /*
  * Called just after removing the VM from the vm_list, but before doing any
  * other destruction.
@@ -5769,10 +5775,8 @@ static int kvm_suspend(void)
 
 static void kvm_resume(void)
 {
-	if (kvm_usage_count) {
-		lockdep_assert_not_held(&kvm_lock);
-		hardware_enable_nolock(NULL);
-	}
+	lockdep_assert_not_held(&kvm_lock);
+	kvm_arch_resume(kvm_usage_count);
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.25.1

