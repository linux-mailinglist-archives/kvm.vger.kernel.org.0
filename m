Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6654479F90E
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbjINDvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbjINDvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:51:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808CB193
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663497; x=1726199497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H92kwpzNZpBa5P3PcIKApYqTKPa48fU3DQboSoQydpY=;
  b=bhrUjP0S7m+s4HoRXH57vVxI9gmw9ouM5WbdWz8U9Fp2B6Q825qX+dYq
   oEt+br/uvCaTEOUylHCyPm+UVvixlD/x6bMD2trnjVphQc92U1EOAVAO9
   cAtJTTb8QYAAJHMDLbe88LwzsYYiF86hdBhfHytKXg74+kkEyjHAbT2kt
   TZlRQpyQp2kWX0xh6xf4Ph5qlWdDtvroe/vasIlNq95jlbr2Fsx5iCmNp
   Zgve45QvXIuJU1KpFUBQtsaviakRIL1me2ebMODHze1fINn+8e/QCAdww
   +RdzQ7EbjPeQ7jYKQrH6rSy082PFjkP+9/CJQOqjO0QCgyyQhpC8qEhot
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528313"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528313"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:51:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500557"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500557"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:51:32 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 03/21] HostMem: Add private property and associate it with RAM_KVM_GMEM
Date:   Wed, 13 Sep 2023 23:50:59 -0400
Message-Id: <20230914035117.3285885-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new property "private" to memory backends. When it's set to true,
it indicates the RAMblock of the backend also requires kvm gmem.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 backends/hostmem-file.c  |  1 +
 backends/hostmem-memfd.c |  1 +
 backends/hostmem-ram.c   |  1 +
 backends/hostmem.c       | 18 ++++++++++++++++++
 include/sysemu/hostmem.h |  2 +-
 qapi/qom.json            |  4 ++++
 6 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/backends/hostmem-file.c b/backends/hostmem-file.c
index b4335a80e6da..861f76f2de8a 100644
--- a/backends/hostmem-file.c
+++ b/backends/hostmem-file.c
@@ -56,6 +56,7 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->private ? RAM_KVM_GMEM : 0;
     ram_flags |= fb->is_pmem ? RAM_PMEM : 0;
     ram_flags |= RAM_NAMED_FILE;
     memory_region_init_ram_from_file(&backend->mr, OBJECT(backend), name,
diff --git a/backends/hostmem-memfd.c b/backends/hostmem-memfd.c
index 3fc85c3db81b..f49990ce3bbd 100644
--- a/backends/hostmem-memfd.c
+++ b/backends/hostmem-memfd.c
@@ -55,6 +55,7 @@ memfd_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->private ? RAM_KVM_GMEM : 0;
     memory_region_init_ram_from_fd(&backend->mr, OBJECT(backend), name,
                                    backend->size, ram_flags, fd, 0, errp);
     g_free(name);
diff --git a/backends/hostmem-ram.c b/backends/hostmem-ram.c
index b8e55cdbd0f8..d6c46250dcfd 100644
--- a/backends/hostmem-ram.c
+++ b/backends/hostmem-ram.c
@@ -30,6 +30,7 @@ ram_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
+    ram_flags |= backend->private ? RAM_KVM_GMEM : 0;
     memory_region_init_ram_flags_nomigrate(&backend->mr, OBJECT(backend), name,
                                            backend->size, ram_flags, errp);
     g_free(name);
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
index fa3e88c8e6ab..d28c5403bc0f 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -605,6 +605,9 @@
 # @reserve: if true, reserve swap space (or huge pages) if applicable
 #     (default: true) (since 6.1)
 #
+# @private: if true, use KVM gmem private memory (default: false)
+#     (since 8.2)
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

