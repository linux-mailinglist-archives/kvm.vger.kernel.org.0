Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D5052433A
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343667AbiELDT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343555AbiELDTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:19:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CC021605D
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325558; x=1683861558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g0arAYqX7qyUTtrTHk+CfMx8l5NPyKI+u1IWkEt9Y3I=;
  b=K5HnHfk3RBedsQ3l325ISUeO5MbbRg6p8eOBaB00fYFCjenZWpls300o
   oi2YZCGhhRBBT+SXVPbaCTeUro0WaUr574oNyhy3+JzZIV0lTFYBFEKQj
   hnBaFHZBGrWxyntT3PAcx6o3R9esYYHsJCakPyNI6ya98cPa6G9rnT3tq
   EtpbbD15tc6gzfA4K6FL582Nllg3YljpFuNJ8wBa3LoxV6HNQjiNoubPb
   kjeEHEy4fvHHFsUFzJ2QWOuiMz2GNEmuW2izKiZbDJLBRvKX/c54YI/xw
   +M5ugNk8ItnY7xz0t545rQQQl54HOURCcdfM3xAzCs62mDwpdXmbXffrn
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="268709921"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="268709921"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:19:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594455812"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:19:14 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
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
Subject: [RFC PATCH v4 14/36] i386/tdx: Implement user specified tsc frequency
Date:   Thu, 12 May 2022 11:17:41 +0800
Message-Id: <20220512031803.3315890-15-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512031803.3315890-1-xiaoyao.li@intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reuse "-cpu,tsc-frequency=" to get user wanted tsc frequency and pass it
to KVM_TDX_INIT_VM.

Besides, sanity check the tsc frequency to be in the legal range and
legal granularity (required by TDX module).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c |  8 ++++++++
 target/i386/kvm/tdx.c | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f2d7c3cf59ac..c51125ab200f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -818,6 +818,14 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
     int r, cur_freq;
     bool set_ioctl = false;
 
+    /*
+     * TD guest's TSC is immutable, it cannot be set/changed via
+     * KVM_SET_TSC_KHZ, but only be initialized via KVM_TDX_INIT_VM
+     */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     if (!env->tsc_khz) {
         return 0;
     }
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 9f2cdf640b5c..622efc409438 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -35,6 +35,9 @@
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
 #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
+#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
+
 static TdxGuest *tdx_guest;
 
 /* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
@@ -211,6 +214,20 @@ int tdx_pre_create_vcpu(CPUState *cpu)
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
     r = setup_td_guest_attributes(x86cpu);
     if (r) {
         goto out;
@@ -221,6 +238,7 @@ int tdx_pre_create_vcpu(CPUState *cpu)
 
     init_vm.attributes = tdx_guest->attributes;
     init_vm.max_vcpus = ms->smp.cpus;
+    init_vm.tsc_khz = env->tsc_khz;
 
     r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
     if (r < 0) {
-- 
2.27.0

