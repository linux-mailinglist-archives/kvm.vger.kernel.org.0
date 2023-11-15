Return-Path: <kvm+bounces-1775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F04C97EBDD8
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:22:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A870028130C
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43065676;
	Wed, 15 Nov 2023 07:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nqWpsxqi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66884524F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:21:59 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5115B8E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032918; x=1731568918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5u+WKJc4+yttRr+qCCOD151Jg4QmLt+f0sR3Wiffs48=;
  b=nqWpsxqiBHePnWIbsxcYLr/4TALNeO8162+B1SX6U07f/7VF1uq7gFaQ
   bAOLuNUQl6at7Z2DHeOsf+WGiBDaYbDwmoNM7yG1JjjgGMWor4jxZcftP
   1cdnyNGCZTAQpcBOgD23sm10B8p8avQT4tj5upWqfQsX0R1R1fZC8Kqxb
   ULz1d1d2gPfcBsR7HD09f9hc63mSRPZJ9owsSldsxp0oV3CjS5Kwz9l/d
   devnAxM/1H1wgMLfYDtSywYSfNOl7k6vz2JthzBrRj8TDn4K4V2LEOaxt
   R5hUr8WUwPRrEp4+2PiRQVsFw0ilmsPQwxdQaONUnZlJNUK8pp+r8NBDB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623340"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623340"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:21:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800116"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800116"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:21:51 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 47/70] memory: Introduce memory_region_init_ram_guest_memfd()
Date: Wed, 15 Nov 2023 02:14:56 -0500
Message-Id: <20231115071519.2864957-48-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce memory_region_init_ram_guest_memfd() to allocate private
guset memfd on the MemoryRegion initialization. It's for the use case of
TDVF, which must be private on TDX case.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/memory.h |  6 ++++++
 system/memory.c       | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index c8b0385b19ad..ca23a1a6b336 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1590,6 +1590,12 @@ void memory_region_init_ram(MemoryRegion *mr,
                             uint64_t size,
                             Error **errp);
 
+void memory_region_init_ram_guest_memfd(MemoryRegion *mr,
+                                        Object *owner,
+                                        const char *name,
+                                        uint64_t size,
+                                        Error **errp);
+
 /**
  * memory_region_init_rom: Initialize a ROM memory region.
  *
diff --git a/system/memory.c b/system/memory.c
index b0c58232b6f7..166eb9fd6f7d 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -3632,6 +3632,33 @@ void memory_region_init_ram(MemoryRegion *mr,
     vmstate_register_ram(mr, owner_dev);
 }
 
+void memory_region_init_ram_guest_memfd(MemoryRegion *mr,
+                                        Object *owner,
+                                        const char *name,
+                                        uint64_t size,
+                                        Error **errp)
+{
+    DeviceState *owner_dev;
+    Error *err = NULL;
+
+    memory_region_init_ram_flags_nomigrate(mr, owner, name, size,
+                                           RAM_GUEST_MEMFD, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+    memory_region_set_default_private(mr);
+
+    /* This will assert if owner is neither NULL nor a DeviceState.
+     * We only want the owner here for the purposes of defining a
+     * unique name for migration. TODO: Ideally we should implement
+     * a naming scheme for Objects which are not DeviceStates, in
+     * which case we can relax this restriction.
+     */
+    owner_dev = DEVICE(owner);
+    vmstate_register_ram(mr, owner_dev);
+}
+
 void memory_region_init_rom(MemoryRegion *mr,
                             Object *owner,
                             const char *name,
-- 
2.34.1


