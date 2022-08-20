Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAF859AB92
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244916AbiHTGA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244300AbiHTGAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41C6A260F;
        Fri, 19 Aug 2022 23:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975250; x=1692511250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eC/FmkI+0wbcW1yT5moTG/B/uNqw/iJshQXbZJpzhw4=;
  b=ftFa88ZbGO4NSyQwP1KWpSeFyG3MJeaPvGEFqXN0AnZEBZlvd28jLewq
   kWr6xahh1wFpYcsgN2inaj0v6Xl9sRTtJM8OEYbsv8xHMz4hRvcM+Al1S
   O9AnFC/LaS04deRYInNN6r92Oit4BS8Ku57JREYLT9KRyznnMUkHENo7M
   dJu/KRpYppwSvYioyMEB+DhaGAiDIaoT5jaQP66sP0PZx7jbHzq7ldZvH
   j/YosBRB/5YHG4eO1R8m8WLT81NjIxEqFb1iXZYqLaMccZW43MEwPQTIc
   fbnYmYlo2+U6A3kd07srb8BaQ1cEMw+HvIn+hAeHeQZxGu3wGivEEAwo8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448971"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448971"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857524"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 05/18] KVM: x86: Move TSC fixup logic to KVM arch resume callback
Date:   Fri, 19 Aug 2022 23:00:11 -0700
Message-Id: <054173a5afbcc79e596dbcdac32588bf9a2242e4.1660974106.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660974106.git.isaku.yamahata@intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
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
index 7d5fff68befe..a7ab9984a236 100644
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

