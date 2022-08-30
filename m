Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343A05A62B8
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiH3MCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiH3MCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:01 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06263E58B0;
        Tue, 30 Aug 2022 05:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860919; x=1693396919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TYBvZOLwTg/r74aw4zfac896o38NzV2pCG9Didy3epg=;
  b=fYAbcL6yIjnpValKDsFxEWoHtE6MOYkI7m7tfYudui6ipqNHGeTVSUPJ
   0BxE+LISWMAcRZFsnfZjQnfm6+Qcr3HbPef/mDEJ1dgWuL6Z48veoN06I
   qyd3/4eJ4BDMk+6I/3EgUhWjH0tC237FDgNB7Hm7LFkfoC8BNs+uHn2HY
   4I1qotIYKEkJhbKc4ew/vBCI+YGqsi6Vx9T35ddhLcjFGYYZrAlq2FcZe
   Ri6bAWPcJRl7YL9ucozITjkA5FBSUporR5U3ePHwhS1CSz6mOL/4Tvicw
   xbSmn+vSn8Bcp/Zhp09d8iY9duOej1pRiIHM4SBczHaCPx18WN1fbreMO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870970"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870970"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:57 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469634"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 08/19] KVM: x86: Move TSC fixup logic to KVM arch resume callback
Date:   Tue, 30 Aug 2022 05:01:23 -0700
Message-Id: <f7c7a5227957b347fa28eac5cc9014c0386beb66.1661860550.git.isaku.yamahata@intel.com>
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

commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable due to S4 suspend") made
use of kvm_arch_hardware_enable() callback to detect that TSC goes backward
due to S4 suspend.  It has to check it only when resuming from S4. Not
every time virtualization hardware ennoblement.  Move the logic to
kvm_arch_resume() callback.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca920b6b925d..0b112cd7de58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11831,18 +11831,30 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
 int kvm_arch_hardware_enable(void)
+{
+	return static_call(kvm_x86_hardware_enable)();
+}
+
+void kvm_arch_hardware_disable(void)
+{
+	static_call(kvm_x86_hardware_disable)();
+	drop_user_return_notifiers();
+}
+
+void kvm_arch_resume(int usage_count)
 {
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
-	int ret;
 	u64 local_tsc;
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
-	ret = static_call(kvm_x86_hardware_enable)();
-	if (ret != 0)
-		return ret;
+	if (!usage_count)
+		return;
+
+	if (kvm_arch_hardware_enable())
+		return;
 
 	local_tsc = rdtsc();
 	stable = !kvm_check_tsc_unstable();
@@ -11917,13 +11929,6 @@ int kvm_arch_hardware_enable(void)
 		}
 
 	}
-	return 0;
-}
-
-void kvm_arch_hardware_disable(void)
-{
-	static_call(kvm_x86_hardware_disable)();
-	drop_user_return_notifiers();
 }
 
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
-- 
2.25.1

