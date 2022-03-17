Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36D04DC841
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiCQODp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiCQODN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:03:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8F71E31B9
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525716; x=1679061716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BYAe2LusAaSRURXWhV4ju9j/C1xHQreVBbaqFDZzgAw=;
  b=PoxG94E+rVQ9UCihLVbJxfUDFc8dlJ+/vVY7HBtk5Euu8VmYvqarJ4pl
   rP1EikFZZhlufs4Vnbp++gOmQoowYkGd0C3R28VC/Vxn7siLiMcQXp8Dp
   588h4+Nc6Ki3ywSLm6nF8KVk/HOyn0VSoC6Up4+747FoA8y7ohBBop9OI
   kcGpj+6/GZxg107fgxsdmxmpT2Pa63aHCNGhg7PBzPIsOpTLFfvxo6Pb3
   5xrHj5ooWDk5Mr6MuenFRDzskuinE3FzmNE4JDOQ1e2W8DrupXblSoyIX
   PL7U+ya2hPg9DM3KhCNVe7CMC3I18B7MQI+IkMFZ9U/Esdb9KUy1kN5Xh
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="239034484"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="239034484"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:01:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541379084"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:01:51 -0700
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
Subject: [RFC PATCH v3 35/36] i386/tdx: Don't get/put guest state for TDX VMs
Date:   Thu, 17 Mar 2022 21:59:12 +0800
Message-Id: <20220317135913.2166202-36-xiaoyao.li@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Don't get/put state of TDX VMs since accessing/mutating guest state of
production TDs is not supported.

Note, it will be allowed for a debug TD. Corresponding support will be
introduced when debug TD support is implemented in the future.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9c7eb3dea0a8..dafb63d4d2d7 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4395,6 +4395,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
 
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     /* must be before kvm_put_nested_state so that EFER.SVME is set */
     ret = has_sregs2 ? kvm_put_sregs2(x86_cpu) : kvm_put_sregs(x86_cpu);
     if (ret < 0) {
@@ -4489,6 +4494,12 @@ int kvm_arch_get_registers(CPUState *cs)
     if (ret < 0) {
         goto out;
     }
+
+    /* TODO: Allow accessing guest state for debug TDs. */
+    if (is_tdx_vm()) {
+        return 0;
+    }
+
     ret = kvm_getput_regs(cpu, 0);
     if (ret < 0) {
         goto out;
-- 
2.27.0

