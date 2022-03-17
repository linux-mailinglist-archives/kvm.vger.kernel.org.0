Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5944DC82A
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiCQOCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiCQOB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:01:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991421E7452
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525639; x=1679061639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/qTfHzbQ7Js7epycg8meh7h+jZZHKsMGM8Fx6fShEHQ=;
  b=W/rpgcDeKn6QiHsw7Qmq68RWqx/dQrNGMDsUfdMnikD06j21Fu17iKom
   Jb3ws4ySGhi3NzKYbghpYbAxdecLD77eo+m65R+sH7yVqkrYVb6T7v+ug
   C67hb6IKB08h877G4Cruw6CByhNpln12sMbg6wEHFu/WZep6LyUd4YltS
   jnPUmsTFtdGDLYsFwc31/DkZCuKLMx0oNGcZbjQYPI0Y/tccRAUtPMLx9
   +kwQNF1WcYKlvg7LKmmeclfqiMz0AgzL7pLmB23z2lqRNCE8Qr+8Ch5IZ
   NfGdZppA0F9KnwC8qNwQISgOnTrNUmQtaDDRI4qc+TjbXWOJQlTx/JeaZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058484"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058484"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:00:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378215"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:00:21 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        xiaoyao.li@intel.com, erdemaktas@google.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, seanjc@google.com
Subject: [RFC PATCH v3 15/36] i386/tdx: Implement user specified tsc frequency
Date:   Thu, 17 Mar 2022 21:58:52 +0800
Message-Id: <20220317135913.2166202-16-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
index f2d71359b59d..4a8b6e2c8797 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -806,6 +806,14 @@ static int kvm_arch_set_tsc_khz(CPUState *cs)
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
index a76c41fe5724..94a9c1ea7e9c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -26,6 +26,9 @@
 #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
 #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
+#define TDX_MIN_TSC_FREQUENCY_KHZ   (100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ   (10 * 1000 * 1000)
+
 static TdxGuest *tdx_guest;
 
 /* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
@@ -209,6 +212,20 @@ int tdx_pre_create_vcpu(CPUState *cpu)
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
@@ -219,6 +236,7 @@ int tdx_pre_create_vcpu(CPUState *cpu)
 
     init_vm.cpuid = (__u64)(&cpuid_data);
     init_vm.max_vcpus = ms->smp.cpus;
+    init_vm.tsc_khz = env->tsc_khz;
     init_vm.attributes = tdx_guest->attributes;
 
     r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
-- 
2.27.0

