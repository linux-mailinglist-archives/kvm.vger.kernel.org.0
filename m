Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692214DC840
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbiCQOD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiCQOC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:02:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05C01E31B1
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525702; x=1679061702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V1TpF4ykZcUCNvzWLC589Z/ejGjCpUcdPSqL4e6+7Ks=;
  b=YTPVT/DMeBaWnWQhaW/J9TExIR4lhejksbCn5SXlr1ywMTAlgivIzL12
   l0IzHIWrSWVNabHhDMfLC+HPC8fckZ9m4+Env05IwrF7AW267wYfwLoPx
   W4jnORtqj7zlbp0hWDRIDFKQF/5A452d5Wnnu0dGv7YPJMeYDsdA/qzdn
   ekiWxgrmjH+HqGQbV5Nc2GH89awP10yYyo1iwDruf7mBGvaVkyChSXfse
   0gMVjc1MUQsOS2j7++72/epzIakD+vwLlpK6zeZ0+112eZJ0xOX/KHKGL
   Oaz4fdLHhhAZ+qbrhJfKNYUWcqiznb92+YF4oARiJ0uk5DB62JoJ7EwWS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="239034412"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="239034412"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:01:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378939"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:01:38 -0700
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
Subject: [RFC PATCH v3 32/36] i386/tdx: Don't synchronize guest tsc for TDs
Date:   Thu, 17 Mar 2022 21:59:09 +0800
Message-Id: <20220317135913.2166202-33-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TSC of TDs is not accessible and KVM doesn't allow access of
MSR_IA32_TSC for TDs. To avoid the assert() in kvm_get_tsc, make
kvm_synchronize_all_tsc() noop for TDs,

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ccbafb4ca183..f6024b723b70 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -273,7 +273,7 @@ void kvm_synchronize_all_tsc(void)
 {
     CPUState *cpu;
 
-    if (kvm_enabled()) {
+    if (kvm_enabled() && !is_tdx_vm()) {
         CPU_FOREACH(cpu) {
             run_on_cpu(cpu, do_kvm_synchronize_tsc, RUN_ON_CPU_NULL);
         }
-- 
2.27.0

