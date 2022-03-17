Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F55F4DC824
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiCQOBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiCQOBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:01:35 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7CA1E3197
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525618; x=1679061618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M4VLp7VWWFfDL79yGUvCpml6hW/Tz/hJK8YH3y2de/o=;
  b=UtiQ6onOqV8vEML5z5SMzTULhlPEjgwdfIs82Bxav0Nh4pMaJ9OqReqB
   OInnGMp9DAWiYlr4WRIMqATtu5ENuOn2aSZZbhlz7i8y1ERAcMabu+xtm
   H0zCBcV3fLix44sGCkZgCI1p57r6Is25uX8qw7lN8Mt/imKzw30hJUwD2
   +x+W+P/8qO6FmWNnJobSYtCw4r7P1Yt3xEtDwGoyNPhBt2oZNW9IVGUqQ
   fitT1jxhLtW7rKz0videID0txHBXs71q54bVCNhgkqSpbnpxU2I8nBGrO
   yqIBjafCzcODiJl73TfYWssdK4ba5ff5TBVJzT7aG8jIGSoiDiHGeA1mY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058398"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058398"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:00:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378170"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:00:12 -0700
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
Subject: [RFC PATCH v3 13/36] i386/tdx: Wire CPU features up with attributes of TD guest
Date:   Thu, 17 Mar 2022 21:58:50 +0800
Message-Id: <20220317135913.2166202-14-xiaoyao.li@intel.com>
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

For QEMU VMs, PKS is configured via CPUID_7_0_ECX_PKS and PMU is
configured by x86cpu->enable_pmu. Reuse the existing configuration
interface for TDX VMs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 409526765304..de4146025995 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -22,6 +22,8 @@
 #include "tdx.h"
 
 #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
+#define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
+#define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
 
 static TdxGuest *tdx_guest;
 
@@ -152,6 +154,15 @@ void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
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
     struct {
@@ -178,6 +189,8 @@ int tdx_pre_create_vcpu(CPUState *cpu)
         goto out;
     }
 
+    setup_td_guest_attributes(x86cpu);
+
     memset(&cpuid_data, 0, sizeof(cpuid_data));
     cpuid_data.cpuid.nent = kvm_x86_arch_cpuid(env, cpuid_data.entries, 0);
 
-- 
2.27.0

