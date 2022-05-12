Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDF0524346
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343499AbiELDTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245697AbiELDTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:19:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A353B210106
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325551; x=1683861551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9l3R6Y7ShNVLtRbyZK/8UZ/kBCc9sedF2FufXnx43E4=;
  b=f1VpNKGmeng7oSZELkYpmh+6wImuT9L9p4fYf6KfOlfbMm6kfjWfQI6q
   S4owt+P40winrOZqCQQ3xtd0E18ITm4SiYprESOpFGba0J7lfjz2rQzMf
   iQHquHl0Zj/KRZGynIf4kJp3XCA3D4sMSLhp75rU3z7Hp8iyKGS4QkKDc
   JJNY4/uSh6eHErhmGeVAr2LzkBOfaCvD7DyVQhRWqLYcuJr7UqqVqiZhz
   MtD+Vno0NZ59j+AfJOySw8vKM6sr+IJrFMt6eODAOPGDUhfGExOlnWSLP
   dtJJIFuz8PXemqyO0w8W5sKx2OoTyFhA1GcTApSLL20FOp33Vt8oEadiS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="268709885"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="268709885"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:19:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594455708"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:19:02 -0700
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
Subject: [RFC PATCH v4 12/36] i386/tdx: Wire CPU features up with attributes of TD guest
Date:   Thu, 12 May 2022 11:17:39 +0800
Message-Id: <20220512031803.3315890-13-xiaoyao.li@intel.com>
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

For QEMU VMs, PKS is configured via CPUID_7_0_ECX_PKS and PMU is
configured by x86cpu->enable_pmu. Reuse the existing configuration
interface for TDX VMs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 3472b59c2dbb..e9c6e6fb396c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -31,6 +31,9 @@
                                      (1ULL << KVM_FEATURE_PV_SCHED_YIELD) | \
                                      (1ULL << KVM_FEATURE_MSI_EXT_DEST_ID))
 
+#define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
+#define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
+
 static TdxGuest *tdx_guest;
 
 /* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
@@ -166,6 +169,15 @@ void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
     }
 }
 
+static void setup_td_guest_attributes(X86CPU *x86cpu)
+{
+    CPUX86State *env = &x86cpu->env;
+
+    tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
+                             TDX_TD_ATTRIBUTES_PKS : 0;
+    tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
+}
+
 int tdx_pre_create_vcpu(CPUState *cpu)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
@@ -179,6 +191,8 @@ int tdx_pre_create_vcpu(CPUState *cpu)
         goto out;
     }
 
+    setup_td_guest_attributes(x86cpu);
+
     memset(&init_vm, 0, sizeof(init_vm));
     init_vm.cpuid.nent = kvm_x86_arch_cpuid(env, init_vm.entries, 0);
 
-- 
2.27.0

