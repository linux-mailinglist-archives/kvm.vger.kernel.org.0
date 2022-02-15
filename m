Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BF04B8368
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 09:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiBPIyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 03:54:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiBPIyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 03:54:18 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16DE15F602
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 00:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645001646; x=1676537646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HHSwigx+fEOjTfkwt5vUqTNa2cOrqiOLC5/yaTKJ80E=;
  b=bepFA3ZbyepGR7ID8rOurzJdT0goEwqfAeNKh1t79yfi03EQzD5aG77V
   ZB39PqP5QQkHzIvbDkFevt24VTxBfeDmeUBYb7lSiBXOjVCa3I4E3Uh3/
   QEPnnmmOXJh1UNs3W3PnmlDBoWxDa0ss0TIphMaXBhSjVh+G7cOXkBxvu
   nafGNgp6O3ixMeI5pP43MN5mPhbSYmOg5C9nIm1106InQF3v2n1+6VPfZ
   sKhFkeuQWLM61OMXsBrSxapFaMqJAiBjcZRMxxvTw58Wf+Dc5QBsEHeT1
   utLN3fJczFdw126Mp0ngQ5tvvdKOlp6RcecGjkKFqZIg6nDJwRg9V18P5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275135787"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="275135787"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="633418276"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:05 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        like.xu.linux@gmail.com, wei.w.wang@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH 3/8] target/i386: Add kvm_get_one_msr helper
Date:   Tue, 15 Feb 2022 14:52:53 -0500
Message-Id: <20220215195258.29149-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215195258.29149-1-weijiang.yang@intel.com>
References: <20220215195258.29149-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When try to get one msr from KVM, I found there's no such kind of
existing interface while kvm_put_one_msr() is there. So here comes
the patch. It'll remove redundant preparation code before finally
call KVM_GET_MSRS IOCTL.

No functional change intended.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/kvm/kvm.c | 48 ++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8dbda2420d..764d110e0f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -136,6 +136,7 @@ static struct kvm_msr_list *kvm_feature_msrs;
 
 #define BUS_LOCK_SLICE_TIME 1000000000ULL /* ns */
 static RateLimit bus_lock_ratelimit_ctrl;
+static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
 
 int kvm_has_pit_state2(void)
 {
@@ -206,28 +207,21 @@ static int kvm_get_tsc(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
-    struct {
-        struct kvm_msrs info;
-        struct kvm_msr_entry entries[1];
-    } msr_data = {};
+    uint64_t value;
     int ret;
 
     if (env->tsc_valid) {
         return 0;
     }
 
-    memset(&msr_data, 0, sizeof(msr_data));
-    msr_data.info.nmsrs = 1;
-    msr_data.entries[0].index = MSR_IA32_TSC;
     env->tsc_valid = !runstate_is_running();
 
-    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, &msr_data);
+    ret = kvm_get_one_msr(cpu, MSR_IA32_TSC, &value);
     if (ret < 0) {
         return ret;
     }
 
-    assert(ret == 1);
-    env->tsc = msr_data.entries[0].data;
+    env->tsc = value;
     return 0;
 }
 
@@ -1485,21 +1479,14 @@ static int hyperv_init_vcpu(X86CPU *cpu)
          * the kernel doesn't support setting vp_index; assert that its value
          * is in sync
          */
-        struct {
-            struct kvm_msrs info;
-            struct kvm_msr_entry entries[1];
-        } msr_data = {
-            .info.nmsrs = 1,
-            .entries[0].index = HV_X64_MSR_VP_INDEX,
-        };
-
-        ret = kvm_vcpu_ioctl(cs, KVM_GET_MSRS, &msr_data);
+        uint64_t value;
+
+        ret = kvm_get_one_msr(cpu, HV_X64_MSR_VP_INDEX, &value);
         if (ret < 0) {
             return ret;
         }
-        assert(ret == 1);
 
-        if (msr_data.entries[0].data != hyperv_vp_index(CPU(cpu))) {
+        if (value != hyperv_vp_index(CPU(cpu))) {
             error_report("kernel's vp_index != QEMU's vp_index");
             return -ENXIO;
         }
@@ -2752,6 +2739,25 @@ static int kvm_put_one_msr(X86CPU *cpu, int index, uint64_t value)
     return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, cpu->kvm_msr_buf);
 }
 
+static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value)
+{
+    int ret;
+    struct {
+        struct kvm_msrs info;
+        struct kvm_msr_entry entries[1];
+    } msr_data = {
+        .info.nmsrs = 1,
+        .entries[0].index = index,
+    };
+
+    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, &msr_data);
+    if (ret < 0) {
+        return ret;
+    }
+    assert(ret == 1);
+    *value = msr_data.entries[0].data;
+    return ret;
+}
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value)
 {
     int ret;
-- 
2.27.0

