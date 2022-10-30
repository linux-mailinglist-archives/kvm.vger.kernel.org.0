Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B832612844
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiJ3G3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiJ3G2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:28:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EF92C9;
        Sat, 29 Oct 2022 23:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111075; x=1698647075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HraWBcwqZJ2nGI3BZlCpi18wRbeK6+tErMp5WGmZpNI=;
  b=f4E3p5Pk+cdapkEkvmpw+HZbRhIacVzsebNCbwj50cRMxqyosOikuqSj
   5Dy2C78Gnxg0qfI+hFe5R12E/rXbLS6ucrbbqXVQ6XzgJD0p3x6A7saSV
   /T2/Ij3XUVndWx87tdSVoixi2zrxaGjU9K0fGc4ThkgQD3yV+aYgKqHD/
   fmw5bozyPayaOFINnw2wewE09Wk0d29F60zWvv6KrKJT6Pd9x5Rm/JxHb
   un89XMGXMeNjYudxzi7xK82m09h1HksK+ksh7Hw78cD+Dbn/dAm8PLaSU
   GecmAhGjWpXhMCxbsJd8AF48wwHN5+uSzwhf/pcKqfO7SOYOSb73xbZwx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037184"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037184"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393073"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393073"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:09 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Chao Gao <chao.gao@intel.com>
Subject: [PATCH v10 071/108] KVM: x86: Allow to update cached values in kvm_user_return_msrs w/o wrmsr
Date:   Sat, 29 Oct 2022 23:23:12 -0700
Message-Id: <238ab2d9a9d2ea71ecacb25203b91abbaf6fbcb4.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/x86.c              | 26 +++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b225cdfac4bc..fdb00d96e954 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2082,6 +2082,7 @@ int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 void kvm_user_return_msr_init_cpu(void);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
+void kvm_user_return_update_cache(unsigned int index, u64 val);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 65541bfebb37..4d4b71c4cdb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -440,6 +440,15 @@ void kvm_user_return_msr_init_cpu(void)
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
@@ -455,15 +464,22 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
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

