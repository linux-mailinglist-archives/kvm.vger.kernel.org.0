Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048FB5F08B9
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiI3KWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiI3KTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDD21D13B4;
        Fri, 30 Sep 2022 03:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533147; x=1696069147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l0Ac5IexnuZLAZe++dN+UELVX47OgBp4i6lJyLywpTc=;
  b=BtXd1hDWwqNX6BRXVz1IJAjo6aO3yZCziubZNDJPJrI0ZVw5R0xB+aUn
   lqyF+u8cpqjqSivLS1E5+FW8Vl9U5E+ptFEcN4Y6PLFP2KbP6k0eOFdo4
   SeakwhsFJVBdLGiYeLFBAQDtlCF0WNLlJGEBW+gwI67xJy+wGtLhJWUGN
   TnJ9iXAkvejSEumZDFBTgUGnyXnD1RqBzUHhurOkgXnsdvSuwm9ggnNct
   deGEHGE1fjJUNSLypwBJno1Ubm5OKFX84vYaTOeI+YemU/jShDinD5zqf
   VRAqtGrjX/u+b+X0WOA9MgCD1DqtM8xySdmKfcn3dVQpBKt1xCqW0oSH8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="285294801"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="285294801"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:03 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807725"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807725"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>, Chao Gao <chao.gao@intel.com>
Subject: [PATCH v9 068/105] KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr
Date:   Fri, 30 Sep 2022 03:18:02 -0700
Message-Id: <50af57e5a5845c408f42a5fce44b3907e6e36286.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Gao <chao.gao@intel.com>

Several MSRs are constant and only used in userspace(ring 3).  But VMs may
have different values.  KVM uses kvm_set_user_return_msr() to switch to
guest's values and leverages user return notifier to restore them when the
kernel is to return to userspace.  To eliminate unnecessary wrmsr, KVM also
caches the value it wrote to an MSR last time.

TDX module unconditionally resets some of these MSRs to architectural INIT
state on TD exit.  It makes the cached values in kvm_user_return_msrs are
inconsistent with values in hardware.  This inconsistency needs to be
fixed.  Otherwise, it may mislead kvm_on_user_return() to skip restoring
some MSRs to the host's values.  kvm_set_user_return_msr() can help correct
this case, but it is not optimal as it always does a wrmsr.  So, introduce
a variation of kvm_set_user_return_msr() to update cached values and skip
that wrmsr.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 26 +++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 18224a3b59a5..e772798684ae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2076,6 +2076,7 @@ int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 void kvm_user_return_msr_init_cpu(void);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
+void kvm_user_return_update_cache(unsigned int index, u64 val);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9254d2e72c56..8160f51bbb92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -435,6 +435,15 @@ void kvm_user_return_msr_init_cpu(void)
 }
 EXPORT_SYMBOL_GPL(kvm_user_return_msr_init_cpu);
 
+static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
+{
+	if (!msrs->registered) {
+		msrs->urn.on_user_return = kvm_on_user_return;
+		user_return_notifier_register(&msrs->urn);
+		msrs->registered = true;
+	}
+}
+
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
@@ -450,15 +459,22 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 		return 1;
 
 	msrs->values[slot].curr = value;
-	if (!msrs->registered) {
-		msrs->urn.on_user_return = kvm_on_user_return;
-		user_return_notifier_register(&msrs->urn);
-		msrs->registered = true;
-	}
+	kvm_user_return_register_notifier(msrs);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
+/* Update the cache, "curr", and register the notifier */
+void kvm_user_return_update_cache(unsigned int slot, u64 value)
+{
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+
+	WARN_ON_ONCE(!msrs->initialized);
+	msrs->values[slot].curr = value;
+	kvm_user_return_register_notifier(msrs);
+}
+EXPORT_SYMBOL_GPL(kvm_user_return_update_cache);
+
 static void drop_user_return_notifiers(void)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
-- 
2.25.1

