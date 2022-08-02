Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7346D58784B
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiHBHte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbiHBHtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:49:17 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D07A1707F
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426554; x=1690962554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/gt0PoHUNhR0uCIrYkf31yLSwQBYQJkpg37Hobzxqpc=;
  b=BR96r0+FUq0KZqBl+bbAcCzPIRhk9unFl+DdMbbrLNKgdl2B0Wd2MEz7
   tbLIKwVffpU/3gecpxWoeuK2M6LcyGou49snckgApyWF2KGBM8Zb271pW
   QhTOePn8GOHifp40zLi1SrK24aIMsKW2G/L/Ii3Q5pSJI5Q7mYsqZfZzQ
   WUM5zIWvZ4/oyTMBcUwez9AUL3BKqjWc6g23Be7pRydl9AGANL+mtGPDM
   wjZnTI49n3Zh8iQxHnqi1KHKGUjAeE2/6SjGhx/JiTPDP930B+cS/ydTZ
   a+r/tEkuMeZpVmZfHHQMlwf7XDXOStcQbYvZs7TxrUJ6/ZCrljxjPGcEt
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="272393025"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="272393025"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:49:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630604066"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:49:09 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [PATCH v1 18/40] i386/tdx: Implement user specified tsc frequency
Date:   Tue,  2 Aug 2022 15:47:28 +0800
Message-Id: <20220802074750.2581308-19-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
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
---
Changes from RFC v4:
  - Use VM scope VM_SET_TSC_KHZ to set the TSC frequency of TD since KVM
    side drop the @tsc_khz field in struct kvm_tdx_init_vm
---
 target/i386/kvm/kvm.c |  9 +++++++++
 target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4f491f871f3e..1545b6f870f5 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -812,6 +812,15 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
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
index 42cef484c574..0162d7cc9df4 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -30,6 +30,9 @@
                                      (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
                                      (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
 
+#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
+
 #define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
@@ -504,6 +507,27 @@ int tdx_pre_create_vcpu(CPUState *cpu)
         goto out;
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
2.27.0

