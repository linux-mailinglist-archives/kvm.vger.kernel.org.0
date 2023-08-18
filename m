Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A124278096B
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359562AbjHRKAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359709AbjHRKAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:00:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166BC4681
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352797; x=1723888797;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iTeIjQmMojhvinRjMzjk62mPRc0ZaQ/Cr7AqNpnikfk=;
  b=kOiN35oORQJaI0eS0TvTsVJPVIdDWRyngwRKxcLqaPtjCbdbVD4D7xxk
   Y/2XwLInhYMwgRv5pqg0iTE4HcP//SWjF9c8c5M2grLwBEFRiyOH/u4bb
   fr731FlA3YiHJ7TOqNqeLgsyOTgAKHNgEk0euRjPuXcExlCXc6Sj4wJ6C
   NNNHn445vmzPIexEgdq+DaIE3AlokcQign61Z2xMuWQF+7WCsIT7rs2ic
   KL/nL/LlpKEnfaq8ODOyzX2Q+Qh/4Gz30sjdHlZet5qF60UvD+XTuAroo
   9Jg6yUPeNaYVdy3eJdqMMK8msJ9ImWEduaDoBsVc4X48C5AIuUbqFwHRl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966750"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966750"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235542"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235542"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:22 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 46/58] i386/tdx: Handle TDG.VP.VMCALL<REPORT_FATAL_ERROR>
Date:   Fri, 18 Aug 2023 05:50:29 -0400
Message-Id: <20230818095041.1973309-47-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index ced55be506d1..f111b46dac92 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -936,6 +936,7 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 
 #define TDG_VP_VMCALL_MAP_GPA                           0x10001ULL
 #define TDG_VP_VMCALL_GET_QUOTE                         0x10002ULL
+#define TDG_VP_VMCALL_REPORT_FATAL_ERROR                0x10003ULL
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
 
 #define TDG_VP_VMCALL_SUCCESS           0x0000000000000000ULL
@@ -1407,6 +1408,42 @@ static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
 }
 
+static void tdx_handle_report_fatal_error(X86CPU *cpu,
+                                          struct kvm_tdx_vmcall *vmcall)
+{
+    uint64_t error_code = vmcall->in_r12;
+    char *message = NULL;
+
+    if (error_code & 0xffff) {
+        error_report("invalid error code of TDG.VP.VMCALL<REPORT_FATAL_ERROR>\n");
+        exit(1);
+    }
+
+    /* it has optional message */
+    if (vmcall->in_r14) {
+        uint64_t * tmp;
+
+#define GUEST_PANIC_INFO_TDX_MESSAGE_MAX        64
+        message = g_malloc0(GUEST_PANIC_INFO_TDX_MESSAGE_MAX + 1);
+
+        tmp = (uint64_t *)message;
+        /* The order is defined in TDX GHCI spec */
+        *(tmp++) = cpu_to_le64(vmcall->in_r14);
+        *(tmp++) = cpu_to_le64(vmcall->in_r15);
+        *(tmp++) = cpu_to_le64(vmcall->in_rbx);
+        *(tmp++) = cpu_to_le64(vmcall->in_rdi);
+        *(tmp++) = cpu_to_le64(vmcall->in_rsi);
+        *(tmp++) = cpu_to_le64(vmcall->in_r8);
+        *(tmp++) = cpu_to_le64(vmcall->in_r9);
+        *(tmp++) = cpu_to_le64(vmcall->in_rdx);
+        message[GUEST_PANIC_INFO_TDX_MESSAGE_MAX] = '\0';
+        assert((char *)tmp == message + GUEST_PANIC_INFO_TDX_MESSAGE_MAX);
+    }
+
+    error_report("TD guest reports fatal error. %s\n", message ? : "");
+    exit(1);
+}
+
 static void tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
                                                     struct kvm_tdx_vmcall *vmcall)
 {
@@ -1441,6 +1478,9 @@ static void tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     case TDG_VP_VMCALL_GET_QUOTE:
         tdx_handle_get_quote(cpu, vmcall);
         break;
+    case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
+        tdx_handle_report_fatal_error(cpu, vmcall);
+        break;
     case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
         tdx_handle_setup_event_notify_interrupt(cpu, vmcall);
         break;
-- 
2.34.1

