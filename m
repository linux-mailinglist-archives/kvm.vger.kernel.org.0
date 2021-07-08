Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058C53BF308
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhGHA6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:19320 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhGHA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696078"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696078"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770044"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 17/44] i386/tdx: Add definitions for TDVF metadata
Date:   Wed,  7 Jul 2021 17:54:47 -0700
Message-Id: <7a06bbaff6b399811b7a2c17a2e9b1d7f4e84a2d.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add constants and structs for the TD Virtual Firmware metadata, which
describes how the TDVF must be built to ensure correct functionality and
measurement.  They are defined in TDVF Design Guide [1].

[1] TDVF Design Guide
https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 include/hw/i386/tdvf.h | 55 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 include/hw/i386/tdvf.h

diff --git a/include/hw/i386/tdvf.h b/include/hw/i386/tdvf.h
new file mode 100644
index 0000000000..5c78e2affb
--- /dev/null
+++ b/include/hw/i386/tdvf.h
@@ -0,0 +1,55 @@
+/*
+ * SPDX-License-Identifier: GPL-2.0-or-later
+
+ * Copyright (c) 2020 Intel Corporation
+ * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
+ *                        <isaku.yamahata at intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HW_I386_TDVF_H
+#define HW_I386_TDVF_H
+
+#include "qemu/osdep.h"
+
+#define TDVF_METDATA_OFFSET_FROM_END    0x20
+
+#define TDVF_SECTION_TYPE_BFV               0
+#define TDVF_SECTION_TYPE_CFV               1
+#define TDVF_SECTION_TYPE_TD_HOB            2
+#define TDVF_SECTION_TYPE_TEMP_MEM          3
+
+#define TDVF_SECTION_ATTRIBUTES_EXTENDMR    (1U << 0)
+
+typedef struct {
+    uint32_t DataOffset;
+    uint32_t RawDataSize;
+    uint64_t MemoryAddress;
+    uint64_t MemoryDataSize;
+    uint32_t Type;
+    uint32_t Attributes;
+} TdvfSectionEntry;
+
+#define TDVF_SIGNATURE_LE32     0x46564454 /* TDVF as little endian */
+
+typedef struct {
+    uint8_t Signature[4];
+    uint32_t Length;
+    uint32_t Version;
+    uint32_t NumberOfSectionEntries;
+    TdvfSectionEntry SectionEntries[];
+} TdvfMetadata;
+
+#endif /* HW_I386_TDVF_H */
-- 
2.25.1

