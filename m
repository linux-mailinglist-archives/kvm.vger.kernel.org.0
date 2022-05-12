Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433B952434A
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343631AbiELDTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244533AbiELDTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:19:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AA0210B9A
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325588; x=1683861588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9j0hfZ+A0CAuqZkKpvMTnZ32QvMIH0LlEbmUNATKMEY=;
  b=Pat8Typ7EDIOUXpHJ05R9sHszmrvap4gPMrjH+wJk69fU6qBuqo0OD8i
   7hUxoHMgrBLNjJ3TG3uJgJedTsoxv9F9DO6pENAHBG+sSHzjVMWDC1Xq6
   Ps2xY9J5DuvP8JnURoOv6saDohiIqJgMHJoSZG91ZIN6HXJqcfCti02XC
   lMpYyZZACjedb0Lcl3FUTT5VbVLdP+wUbHIgXzpm+V3a5dAJMFOta96Td
   2bYysygBpwGbasbImIQjwcirdEm9wsapUgQJvySiRFrsxa779m8MgvQgz
   QLZ7LsXMhVDsZoc97c3Bbt9XI7jC09yNMnxQEwsd4NQNCJTD38tynUS/z
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="257424431"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="257424431"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:19:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594456006"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:19:43 -0700
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
Subject: [RFC PATCH v4 20/36] i386/tdx: Register a machine_init_done callback for TD
Date:   Thu, 12 May 2022 11:17:47 +0800
Message-Id: <20220512031803.3315890-21-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512031803.3315890-1-xiaoyao.li@intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before a TD can run, it needs to
 - setup/configure TD HOB list;
 - initialize TDVF into TD's private memory;
 - initialize TD vcpu state;

Register a machine_init_done callback to all those stuff.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 2953d2728b32..a95d5b894c34 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -16,6 +16,7 @@
 #include "qom/object_interfaces.h"
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
+#include "sysemu/sysemu.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
@@ -126,6 +127,15 @@ static void get_tdx_capabilities(void)
     tdx_caps = caps;
 }
 
+static void tdx_finalize_vm(Notifier *notifier, void *unused)
+{
+    /* TODO */
+}
+
+static Notifier tdx_machine_done_notify = {
+    .notify = tdx_finalize_vm,
+};
+
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
     TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
@@ -144,6 +154,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
      */
     kvm_readonly_mem_allowed = false;
 
+    qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
+
     tdx_guest = tdx;
 
     return 0;
-- 
2.27.0

