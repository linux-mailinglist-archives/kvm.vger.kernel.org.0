Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516E8769C59
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjGaQZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjGaQZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:43 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE27199C
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820729; x=1722356729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ta4InYtMSOxVmVlrTdpkepm14awSYjV/tD5ZIXGmuAY=;
  b=kDxbga/cGJLjLlMyQL+4k4AF4LpwZuCEGauH2F0h8KWj1flaSc2r0+J4
   JCH78JcqPyiizFz0qc61hK0IigIYemXgWAqv+kg/OZopwAhyfMyhihB9j
   1wAwdxGb+CM25LcI+uUWuJG/K9K+fyc/A2ATjkDiZDa3WMa6z+8cEG46T
   kIm4+vkwRLlpT8Kj4ackiklh4HyFwvm5nQGG6qWYfxPJgLWEbSN58lfgO
   Ckqcjql3jToSYqI+6m4OPL3Yba+AuWW+dETwvo3+odyhcq73nUJDavQ2j
   haAqJWgIzWdtsjJ6NW1whg9biJiE5vSecymTD2IswF4BeIdl63c0OVsOx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993467"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993467"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984187"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984187"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:24 -0700
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
Subject: [RFC PATCH 08/19] HostMem: Add private property to indicate to use kvm gmem
Date:   Mon, 31 Jul 2023 12:21:50 -0400
Message-Id: <20230731162201.271114-9-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 backends/hostmem.c       | 18 ++++++++++++++++++
 include/sysemu/hostmem.h |  2 +-
 qapi/qom.json            |  4 ++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/backends/hostmem.c b/backends/hostmem.c
index 747e7838c031..dbdbb0aafd45 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -461,6 +461,20 @@ static void host_memory_backend_set_reserve(Object *o, bool value, Error **errp)
     }
     backend->reserve = value;
 }
+
+static bool host_memory_backend_get_private(Object *o, Error **errp)
+{
+    HostMemoryBackend *backend = MEMORY_BACKEND(o);
+
+    return backend->private;
+}
+
+static void host_memory_backend_set_private(Object *o, bool value, Error **errp)
+{
+    HostMemoryBackend *backend = MEMORY_BACKEND(o);
+
+    backend->private = value;
+}
 #endif /* CONFIG_LINUX */
 
 static bool
@@ -541,6 +555,10 @@ host_memory_backend_class_init(ObjectClass *oc, void *data)
         host_memory_backend_get_reserve, host_memory_backend_set_reserve);
     object_class_property_set_description(oc, "reserve",
         "Reserve swap space (or huge pages) if applicable");
+    object_class_property_add_bool(oc, "private",
+        host_memory_backend_get_private, host_memory_backend_set_private);
+    object_class_property_set_description(oc, "private",
+        "Use KVM gmem private memory");
 #endif /* CONFIG_LINUX */
     /*
      * Do not delete/rename option. This option must be considered stable
diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
index 39326f1d4f9c..d88970395618 100644
--- a/include/sysemu/hostmem.h
+++ b/include/sysemu/hostmem.h
@@ -65,7 +65,7 @@ struct HostMemoryBackend {
     /* protected */
     uint64_t size;
     bool merge, dump, use_canonical_path;
-    bool prealloc, is_mapped, share, reserve;
+    bool prealloc, is_mapped, share, reserve, private;
     uint32_t prealloc_threads;
     ThreadContext *prealloc_context;
     DECLARE_BITMAP(host_nodes, MAX_NODES + 1);
diff --git a/qapi/qom.json b/qapi/qom.json
index 7f92ea43e8e1..e0b2044e3d20 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -605,6 +605,9 @@
 # @reserve: if true, reserve swap space (or huge pages) if applicable
 #     (default: true) (since 6.1)
 #
+# @private: if true, use KVM gmem private memory
+#           (default: false) (since 8.1)
+#
 # @size: size of the memory region in bytes
 #
 # @x-use-canonical-path-for-ramblock-id: if true, the canonical path
@@ -631,6 +634,7 @@
             '*prealloc-context': 'str',
             '*share': 'bool',
             '*reserve': 'bool',
+            '*private': 'bool',
             'size': 'size',
             '*x-use-canonical-path-for-ramblock-id': 'bool' } }
 
-- 
2.34.1

