Return-Path: <kvm+bounces-1786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DD77EBDEC
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D67621C2099B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58F6522D;
	Wed, 15 Nov 2023 07:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aryI8hK+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E834685
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:23:06 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541958E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032985; x=1731568985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j6EK6gjeMnO1svoBe83lzwmRzB9m0iGmYDYaHxGemsI=;
  b=aryI8hK+rnq8d/kSl0yUxp78aUTjU++hrd6XMs9uQ4owdtn6eQgrU1Id
   69VZ9mnoBAcDXNMv4hC2dTliIJnxz7h0UOuZI05rgXS/azJd7VEbPKTP0
   qDS3xANOA9bcONWXgqsqKxPTG+cKyT6DkaoYGhFt0N28wR1UDtY9CX8nF
   NNzZLnThdhOMJ/RoaW1ZIVoOQZ5dH6POAqJm1bJbI0wQY4mBIuRdBedpy
   EveFlJ0VfO01Lu88E6dkyNGZPbS9weS3Zk/jCcSdNAZOkbh9luuR1dlVJ
   YvUOssphXSCsrvaW1qnGbDa19SZrn6h2ObbjAuh82FI7sxBi8Ftri8Jg1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623523"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623523"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:23:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800337"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800337"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:22:57 -0800
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
Subject: [PATCH v3 58/70] pci-host/q35: Move PAM initialization above SMRAM initialization
Date: Wed, 15 Nov 2023 02:15:07 -0500
Message-Id: <20231115071519.2864957-59-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

In mch_realize(), process PAM initialization before SMRAM initialization so
that later patch can skill all the SMRAM related with a single check.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/pci-host/q35.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/hw/pci-host/q35.c b/hw/pci-host/q35.c
index 08534bc7cc09..4ac44975c75d 100644
--- a/hw/pci-host/q35.c
+++ b/hw/pci-host/q35.c
@@ -568,6 +568,16 @@ static void mch_realize(PCIDevice *d, Error **errp)
     /* setup pci memory mapping */
     pc_pci_as_mapping_init(mch->system_memory, mch->pci_address_space);
 
+    /* PAM */
+    init_pam(&mch->pam_regions[0], OBJECT(mch), mch->ram_memory,
+             mch->system_memory, mch->pci_address_space,
+             PAM_BIOS_BASE, PAM_BIOS_SIZE);
+    for (i = 0; i < ARRAY_SIZE(mch->pam_regions) - 1; ++i) {
+        init_pam(&mch->pam_regions[i + 1], OBJECT(mch), mch->ram_memory,
+                 mch->system_memory, mch->pci_address_space,
+                 PAM_EXPAN_BASE + i * PAM_EXPAN_SIZE, PAM_EXPAN_SIZE);
+    }
+
     /* if *disabled* show SMRAM to all CPUs */
     memory_region_init_alias(&mch->smram_region, OBJECT(mch), "smram-region",
                              mch->pci_address_space, MCH_HOST_BRIDGE_SMRAM_C_BASE,
@@ -634,15 +644,6 @@ static void mch_realize(PCIDevice *d, Error **errp)
 
     object_property_add_const_link(qdev_get_machine(), "smram",
                                    OBJECT(&mch->smram));
-
-    init_pam(&mch->pam_regions[0], OBJECT(mch), mch->ram_memory,
-             mch->system_memory, mch->pci_address_space,
-             PAM_BIOS_BASE, PAM_BIOS_SIZE);
-    for (i = 0; i < ARRAY_SIZE(mch->pam_regions) - 1; ++i) {
-        init_pam(&mch->pam_regions[i + 1], OBJECT(mch), mch->ram_memory,
-                 mch->system_memory, mch->pci_address_space,
-                 PAM_EXPAN_BASE + i * PAM_EXPAN_SIZE, PAM_EXPAN_SIZE);
-    }
 }
 
 uint64_t mch_mcfg_base(void)
-- 
2.34.1


