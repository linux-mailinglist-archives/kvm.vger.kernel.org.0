Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F61667BA7
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241096AbjALQoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbjALQis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:48 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699711DF35;
        Thu, 12 Jan 2023 08:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541249; x=1705077249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SjSfZegdmweSOVkOZBBi7xj1NT4xg9DbSG4FLSUQzGQ=;
  b=QLDb3UbGm5ODaoghPkl8kmxvXzgKCdVhqcQFt8Z3ukAAAJHxQ2kefiaw
   sR2tR8/70rvrAJ+EmyE4qWamRHzJDhQsP6KiPP8rg3jv6ebqC5n1DXWFf
   JIr0iaqF5maWUbA/l9f15J2nZnuPDOtJ7YBeC72P3f/QAYnJcll4W6tso
   HFUh86B3NPBkjJLRg20Xhg/vW3iVpzs8ZuhPg8oFuFyv4ipQeJr8szbPr
   GKk1husLJ8jULk7KzwxoEwBcdA6rqjf+7SPo8atLvkKFiYnIF7FchSilU
   2L1I6nrCzQGB1hWP960EFnn7+3LzFqaXSzMprnX7cV29RvKEHlWmiGO1R
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811992"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811992"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151874"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151874"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Chao Gao <chao.gao@intel.com>
Subject: [PATCH v11 068/113] KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr
Date:   Thu, 12 Jan 2023 08:32:16 -0800
Message-Id: <877ae947a214b946840e35fac9ef6724411fe2d6.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/x86.c              | 25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 487ff9f4fe1a..91093622f7ba 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2154,6 +2154,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
+void kvm_user_return_update_cache(unsigned int index, u64 val);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7785225f03ec..a3da2526dfda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -430,6 +430,15 @@ static void kvm_user_return_msr_cpu_online(void)
 	}
 }
 
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
 	unsigned int cpu = smp_processor_id();
@@ -444,15 +453,21 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
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
+	msrs->values[slot].curr = value;
+	kvm_user_return_register_notifier(msrs);
+}
+EXPORT_SYMBOL_GPL(kvm_user_return_update_cache);
+
 static void drop_user_return_notifiers(void)
 {
 	unsigned int cpu = smp_processor_id();
-- 
2.25.1

