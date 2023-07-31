Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40DD769C57
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjGaQZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjGaQZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:24 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BB31722
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820720; x=1722356720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KrHq5Q0AGZhu0U92WRZt5YMhM+0kmJOGaYAi4j7AhxI=;
  b=PB0hh+4DYg6oDCjKN5xmRcvGLqwvvThyLn4Ma4aM6yOrwuM39EeFt8yW
   3CbidbBiViHkT6udrtN42mRu8q9aDmOHIra3zHkIyT4czIBXIh+HGPtPB
   XLJ34A+ddnyZKQqPcI4/WQ8T152O2YexHT228dzfvBCGlC8PRR28wDbKH
   5BchE3znxAX/E9k9Aab38N8/6/0UGhFSd8Lrwf/Fd6t8i7AjRqDqGs8bX
   YyrFTOQvMPHP3ksulo9BYVn0nGLdycxaVFj7dqpeNRWq6wu7yxHvBEnIt
   RHWySxvfmAVh36yDIu6/diaBQ2/6QVrLwTYrrJEUNgPqsKv6xRYGdLoZO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993443"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993443"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984123"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984123"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:15 -0700
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
Subject: [RFC PATCH 06/19] i386/pc: Drop pc_machine_kvm_type()
Date:   Mon, 31 Jul 2023 12:21:48 -0400
Message-Id: <20230731162201.271114-7-xiaoyao.li@intel.com>
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

pc_machine_kvm_type() was introduced by commit e21be724eaf5 ("i386/xen:
add pc_machine_kvm_type to initialize XEN_EMULATE mode") to do Xen
specific initialization by utilizing kvm_type method.

commit eeedfe6c6316 ("hw/xen: Simplify emulated Xen platform init")
moves the Xen specific initialization to pc_basic_device_init().

There is no need to keep the PC specific kvm_type() implementation
anymore. On the other hand, later patch will implement kvm_type()
method for all x86/i386 machines to support KVM_X86_SW_PROTECTED_VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/pc.c         | 5 -----
 include/hw/i386/pc.h | 3 ---
 2 files changed, 8 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 3109d5e0e035..abeadd903827 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1794,11 +1794,6 @@ static void pc_machine_initfn(Object *obj)
     cxl_machine_init(obj, &pcms->cxl_devices_state);
 }
 
-int pc_machine_kvm_type(MachineState *machine, const char *kvm_type)
-{
-    return 0;
-}
-
 static void pc_machine_reset(MachineState *machine, ShutdownCause reason)
 {
     CPUState *cs;
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index d54e8b1101e4..c98d628a76f3 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -296,15 +296,12 @@ extern const size_t pc_compat_1_5_len;
 extern GlobalProperty pc_compat_1_4[];
 extern const size_t pc_compat_1_4_len;
 
-int pc_machine_kvm_type(MachineState *machine, const char *vm_type);
-
 #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
     static void pc_machine_##suffix##_class_init(ObjectClass *oc, void *data) \
     { \
         MachineClass *mc = MACHINE_CLASS(oc); \
         optsfn(mc); \
         mc->init = initfn; \
-        mc->kvm_type = pc_machine_kvm_type; \
     } \
     static const TypeInfo pc_machine_type_##suffix = { \
         .name       = namestr TYPE_MACHINE_SUFFIX, \
-- 
2.34.1

