Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDC752434E
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344087AbiELDUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344306AbiELDUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:20:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69495219377
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325617; x=1683861617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NjarXFOxqHXwXtnjn08zXNwsmuxAFJqWAQBqjWFQ+AE=;
  b=KtsgG7+X6p7oqpRi5IGUxaftpHePUyF6cV6XYjy3orpJeJ7vsVgWTyX5
   wK1tb5wt8HAhclE0QPmf73PNDqOjsjnNStHuTh1WWjnKTFOf7P/1Gbn0m
   eZBvZGsOo5tPU5cLPnr40YKGpH5WdPSxEIkAeioR5SXtuUMa43S4+aDRN
   sXA2H2vg0H6Ns4/io+XsWctaNv9IJKjM2TY879l6VafgYhnTC/txtKZQu
   dSfIYqzCn09NPREqaZMtRMbs0WRh35WpB/CgD00vuxQcVPoB2Y6R0Deu/
   6INEzcTyaLGR38iiMSsRJZusyog1e5ERMA6Qi/n2jQvrGs4UCwAb7qKZk
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="269815599"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="269815599"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:20:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594456567"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:20:12 -0700
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
Subject: [RFC PATCH v4 26/36] i386/tdx: Finalize TDX VM
Date:   Thu, 12 May 2022 11:17:53 +0800
Message-Id: <20220512031803.3315890-27-xiaoyao.li@intel.com>
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

Invoke KVM_TDX_FINALIZE_VM to finalize the TD's measurement and make
the TD vCPUs runnable once machine initialization is complete.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d8b05b7749f7..4a7c149f895c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -307,6 +307,13 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
             entry->mem_ptr = NULL;
         }
     }
+
+    r = tdx_vm_ioctl(KVM_TDX_FINALIZE_VM, 0, NULL);
+    if (r < 0) {
+        error_report("KVM_TDX_FINALIZE_VM failed %s", strerror(-r));
+        exit(0);
+    }
+    tdx_guest->parent_obj.ready = true;
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.27.0

