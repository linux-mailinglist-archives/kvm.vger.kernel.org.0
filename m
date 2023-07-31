Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27840769C6B
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjGaQ1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjGaQ1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:27:10 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9488B1BFD
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820800; x=1722356800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OqbwFxE5zjsZMZns5dcqTBrG/GaaJmBZ5rVzXVb5HAQ=;
  b=PsSlb4UWQFy712+bBB1u7OlnF7Y5lLRnziREQMcOCz9jZqJc9h++w1rC
   OA3mCIIhZC//C3cTj98w4MQZH9hHBOapumTl1PFvRLPlku+7PB7hV3A4J
   LgGKXktMWFx0Ou+gNF6uKGsQimP5Zgc9v2/pTK2On9lealhF5BKR5jHF7
   2paL0QcOQ0q6Gl8/1GLoKcRAsmIf+b8fw4I2dLmfShCrRRo8lW+o+z7dO
   A6AsOrsmz4k9snQ2kDthnGCBi3Zk3nR3A9LkUqc347wtAzgha6cmAg4Zf
   Vmb1K3UxhVq2bJaLnvxdBsoMPyKBgdU8mtnNe8cCKYeRYWN1BsMqKi/4p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993656"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993656"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:26:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984483"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984483"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:26:15 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        xiaoyao.li@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 19/19] i386: Disable SMM mode for X86_SW_PROTECTED_VM
Date:   Mon, 31 Jul 2023 12:22:01 -0400
Message-Id: <20230731162201.271114-20-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731162201.271114-1-xiaoyao.li@intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a96640512dbc..62f237068a3a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2654,6 +2654,13 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     if (x86ms->vm_type == KVM_X86_SW_PROTECTED_VM) {
         memory_listener_register(&kvm_x86_sw_protected_vm_memory_listener, &address_space_memory);
+
+        if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+            x86ms->smm = ON_OFF_AUTO_OFF;
+        } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+            error_report("X86_SW_PROTECTED_VM doesn't support SMM");
+            return -EINVAL;
+        }
     }
 
     if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
-- 
2.34.1

