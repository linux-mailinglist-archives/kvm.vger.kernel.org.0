Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8F8524332
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343821AbiELDVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344423AbiELDUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:20:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B096219C10
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325622; x=1683861622;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zA4+vO3ZlL6FDdVOOW5n4kWKuIMD1g8bw35TxLB01wM=;
  b=TGyCBnrohGEB5R9QNI/sMhwdhbLOsdm9YXNAoJGA47c4lYDK+RDUfsg8
   z61BBByPT6wuw8Ngx1gavWL8Apsw0zykMBbIJxz/Y+rwWsQnyZCnLhPXr
   1ZF1P1w9MuoZaCrG/b+LC4cowklNOFqQ/hYnZ4Gl4p9FeKitmNoS6zOZ/
   wh78P7Dn5T+nRrOmoOBYXokUJNwW1o0UfhjSBfol/mhc4hObIUgGrPh1C
   WnZSdc5WFYoCa/pZgjKtfx0c4mHzYYMcLh05FlSk92f8Mp4DDVUNmxqhs
   Wu/fRE7LQHEfPQ85eHCLRZi0z1Kt8dYKuPyYatZ5C5j0VpGF2XMxl+YQf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="269815614"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="269815614"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:20:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594456595"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:20:17 -0700
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
Subject: [RFC PATCH v4 27/36] i386/tdx: Disable SMM for TDX VMs
Date:   Thu, 12 May 2022 11:17:54 +0800
Message-Id: <20220512031803.3315890-28-xiaoyao.li@intel.com>
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

TDX doesn't support SMM and VMM cannot emulate SMM for TDX VMs because
VMM cannot manipulate TDX VM's memory.

Disable SMM for TDX VMs and error out if user requests to enable SMM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 4a7c149f895c..7ff4c6a9a7ca 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -322,9 +322,17 @@ static Notifier tdx_machine_done_notify = {
 
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
+    X86MachineState *x86ms = X86_MACHINE(ms);
     TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
                                                     TYPE_TDX_GUEST);
 
+    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+        x86ms->smm = ON_OFF_AUTO_OFF;
+    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support SMM");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         get_tdx_capabilities();
     }
-- 
2.27.0

