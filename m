Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC69C31C56E
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBPCTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:19:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:39372 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhBPCRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:17:12 -0500
IronPort-SDR: UtH7T7wxBlzcdVvcHu2WcNzDc9Sw+ZoFV3fLFh4k3ZS3U+VEVeADT0e5Ynq9mWfpbmDGFDNUhV
 M4yRxtTdk3EQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244270211"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244270211"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:53 -0800
IronPort-SDR: uEIPyVgNqxoWCeAX+jQvySajVlslnR9m4TdcajA4n8gB76HoJvujnUPoO9HBoMENmZqIAuGUae
 tX0mtOagF+iQ==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705436"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:53 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 17/23] i386/tdx: Add definitions for TDVF metadata
Date:   Mon, 15 Feb 2021 18:13:13 -0800
Message-Id: <6de1c04f79d4a5626429aa86feb1ea1b992f625c.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add constants and structs for the TD Virtual Firmware metadata, which
describes how the TDVF must be built to ensure correct functionality and
measurement.

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
2.17.1

