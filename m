Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849AD780924
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359467AbjHRJ46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359504AbjHRJ4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:56:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9941C3AA2
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352578; x=1723888578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLI8i4NLnFT1VxTuNpWDpAzjpebLGmZNzlqiDs9hxoY=;
  b=a6S2z43yhk97mG8vB+IYnA7+Nxw+xFIHOH868Svoa/752Y4ELcrc0AKt
   xdF/S0N7EKJW4Pu4AcF9xhyLhH6Sik4HufY7K4jG6r3xMLheQyO0fQNlL
   pPLs5aLbPowr7Q7NFlu3vxvyjlmsLZ8Q4UJSiNHbQF7NdN2qFL+BjGsIZ
   E3fkOAyX4oXTvL3705rBl67sCIupmRGFiFmzGsm4bNlRkvnshj0m12Fba
   AKjeG3YbDD1o1gT1AW4cMdH6q4ooimctZv9eS/DyCUob9Fh1HwwTgoymR
   DghwOPn3ZBAbSeL83OKDN9fBukqyBbaUBbCHMhMS4xPH0d5y1Y2ANKmgT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966022"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966022"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235167"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235167"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:56:12 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 21/58] i386/tdx: Implement user specified tsc frequency
Date:   Fri, 18 Aug 2023 05:50:04 -0400
Message-Id: <20230818095041.1973309-22-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reuse "-cpu,tsc-frequency=" to get user wanted tsc frequency and call VM
scope VM_SET_TSC_KHZ to set the tsc frequency of TD before KVM_TDX_INIT_VM.

Besides, sanity check the tsc frequency to be in the legal range and
legal granularity (required by TDX module).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
Changes from RFC v4:
  - Use VM scope VM_SET_TSC_KHZ to set the TSC frequency of TD since KVM
    side drop the @tsc_khz field in struct kvm_tdx_init_vm
---
 target/i386/kvm/kvm.c |  9 +++++++++
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d51067fdc12a..4a146bc42f63 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -859,6 +859,15 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
     int r, cur_freq;
     bool set_ioctl = false;
 
+    /*
+     * TSC of TD vcpu is immutable, it cannot be set/changed via vcpu scope
+     * VM_SET_TSC_KHZ, but only be initialized via VM scope VM_SET_TSC_KHZ
+     * before ioctl KVM_TDX_INIT_VM in tdx_pre_create_vcpu()
+     */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     if (!env->tsc_khz) {
         return 0;
     }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 33d015a08c34..a72badfbfd65 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -32,6 +32,9 @@
                                      (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
                                      (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
 
+#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
+
 #define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
@@ -513,6 +516,27 @@ int tdx_pre_create_vcpu(CPUState *cpu)
         goto out_free;
     }
 
+    r = -EINVAL;
+    if (env->tsc_khz && (env->tsc_khz < TDX_MIN_TSC_FREQUENCY_KHZ ||
+                         env->tsc_khz > TDX_MAX_TSC_FREQUENCY_KHZ)) {
+        error_report("Invalid TSC %ld KHz, must specify cpu_frequency between [%d, %d] kHz",
+                      env->tsc_khz, TDX_MIN_TSC_FREQUENCY_KHZ,
+                      TDX_MAX_TSC_FREQUENCY_KHZ);
+        goto out;
+    }
+
+    if (env->tsc_khz % (25 * 1000)) {
+        error_report("Invalid TSC %ld KHz, it must be multiple of 25MHz", env->tsc_khz);
+        goto out;
+    }
+
+    /* it's safe even env->tsc_khz is 0. KVM uses host's tsc_khz in this case */
+    r = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, env->tsc_khz);
+    if (r < 0) {
+        error_report("Unable to set TSC frequency to %" PRId64 " kHz", env->tsc_khz);
+        goto out;
+    }
+
     r = setup_td_guest_attributes(x86cpu);
     if (r) {
         goto out;
-- 
2.34.1

