Return-Path: <kvm+bounces-6938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EFEE83B80D
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:32:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33CAD1C21400
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D08F1A726;
	Thu, 25 Jan 2024 03:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OG8ibtqB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7560199D0
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153397; cv=none; b=ALxdJWZbuvJkotdThDEgqa4/rEBlfwLyzTZyM4pmNlytXxtwKUi11ntjaVLHrWghcveLvF8deDfMII0Eb3AeGmiKyeNqfK0hfKBEvvF//OZ3ei763Dq5XlUhsU4mvc9NP0TWc+FHIdwhgzCS+ggH2JMZ37Ga1lAhc6la/6/7WDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153397; c=relaxed/simple;
	bh=ApcKD7KIvNT2bfBIjrshzea2tHyD/Q7COO8WA0lJvDs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d1vKV3+ODDWUjpqi9gTapmynf90iL/Cgg/IbcmilvPau1YKUb3nN2W0wYppCTw/bFbqHy26RKivufeiigqhJdcuymdvUukHlAgV0Y9ziLCVkvRREOjgDC+/dpAngTICQJNdjdKIxXBhoJMAe+Cq7N+S/jVevcH2uqiXCGP1G0Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OG8ibtqB; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153396; x=1737689396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ApcKD7KIvNT2bfBIjrshzea2tHyD/Q7COO8WA0lJvDs=;
  b=OG8ibtqBFaFp9++aHc5JLagppZFjK1AXuW1rDl84+XshWtBY0JeTjF0v
   6QxMC1de3PY4DJcdMc8xSWpBxuiEpwgSyzxYPGxxqT1UP1CIvr/JOOMUU
   jC+aDAqn4zT6YP5kPKJ5LUyDUY/PJBZbfFmSJQ9D5+D/d8jtQlOKDzBIM
   8QdloU04Du/4ac6Q8tZkXdlsNj724sukO3sDO87Nf2DGsp0stqVmw4MDS
   JvDAF8iDNf3VfVdk9iVo0FjOIwVvIFIIQrvZu8+vyjxLUcTmWw86lYU86
   EQPELQcjI8bz+tI8X7qiZqJ8wsoRmXp17B+LM74TTrRU0ObcBg5h8Qmzp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429325"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429325"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:26:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2085839"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:26:50 -0800
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
Subject: [PATCH v4 36/66] i386/tdvf: Introduce function to parse TDVF metadata
Date: Wed, 24 Jan 2024 22:22:58 -0500
Message-Id: <20240125032328.2522472-37-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX VM needs to boot with its specialized firmware, Trusted Domain
Virtual Firmware (TDVF). QEMU needs to parse TDVF and map it in TD
guest memory prior to running the TDX VM.

A TDVF Metadata in TDVF image describes the structure of firmware.
QEMU refers to it to setup memory for TDVF. Introduce function
tdvf_parse_metadata() to parse the metadata from TDVF image and store
the info of each TDVF section.

TDX metadata is located by a TDX metadata offset block, which is a
GUID-ed structure. The data portion of the GUID structure contains
only an 4-byte field that is the offset of TDX metadata to the end
of firmware file.

Select X86_FW_OVMF when TDX is enable to leverage existing functions
to parse and search OVMF's GUID-ed structures.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>

---
Changes in v1:
 - rename tdvf_parse_section_entry() to
   tdvf_parse_and_check_section_entry()
Changes in RFC v4:
 - rename TDX_METADATA_GUID to TDX_METADATA_OFFSET_GUID
---
 hw/i386/Kconfig        |   1 +
 hw/i386/meson.build    |   1 +
 hw/i386/tdvf.c         | 199 +++++++++++++++++++++++++++++++++++++++++
 include/hw/i386/tdvf.h |  51 +++++++++++
 4 files changed, 252 insertions(+)
 create mode 100644 hw/i386/tdvf.c
 create mode 100644 include/hw/i386/tdvf.h

diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
index c0ccf50ac3ef..4e6c8905f077 100644
--- a/hw/i386/Kconfig
+++ b/hw/i386/Kconfig
@@ -12,6 +12,7 @@ config SGX
 
 config TDX
     bool
+    select X86_FW_OVMF
     depends on KVM
 
 config PC
diff --git a/hw/i386/meson.build b/hw/i386/meson.build
index 369c6bf823bb..6808bd4e3032 100644
--- a/hw/i386/meson.build
+++ b/hw/i386/meson.build
@@ -27,6 +27,7 @@ i386_ss.add(when: 'CONFIG_PC', if_true: files(
   'port92.c'))
 i386_ss.add(when: 'CONFIG_X86_FW_OVMF', if_true: files('pc_sysfw_ovmf.c'),
                                         if_false: files('pc_sysfw_ovmf-stubs.c'))
+i386_ss.add(when: 'CONFIG_TDX', if_true: files('tdvf.c'))
 
 subdir('kvm')
 subdir('xen')
diff --git a/hw/i386/tdvf.c b/hw/i386/tdvf.c
new file mode 100644
index 000000000000..ff51f40088f0
--- /dev/null
+++ b/hw/i386/tdvf.c
@@ -0,0 +1,199 @@
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
+#include "qemu/osdep.h"
+#include "qemu/error-report.h"
+
+#include "hw/i386/pc.h"
+#include "hw/i386/tdvf.h"
+#include "sysemu/kvm.h"
+
+#define TDX_METADATA_OFFSET_GUID    "e47a6535-984a-4798-865e-4685a7bf8ec2"
+#define TDX_METADATA_VERSION        1
+#define TDVF_SIGNATURE              0x46564454 /* TDVF as little endian */
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
+typedef struct {
+    uint32_t Signature;
+    uint32_t Length;
+    uint32_t Version;
+    uint32_t NumberOfSectionEntries;
+    TdvfSectionEntry SectionEntries[];
+} TdvfMetadata;
+
+struct tdx_metadata_offset {
+    uint32_t offset;
+};
+
+static TdvfMetadata *tdvf_get_metadata(void *flash_ptr, int size)
+{
+    TdvfMetadata *metadata;
+    uint32_t offset = 0;
+    uint8_t *data;
+
+    if ((uint32_t) size != size) {
+        return NULL;
+    }
+
+    if (pc_system_ovmf_table_find(TDX_METADATA_OFFSET_GUID, &data, NULL)) {
+        offset = size - le32_to_cpu(((struct tdx_metadata_offset *)data)->offset);
+
+        if (offset + sizeof(*metadata) > size) {
+            return NULL;
+        }
+    } else {
+        error_report("Cannot find TDX_METADATA_OFFSET_GUID");
+        return NULL;
+    }
+
+    metadata = flash_ptr + offset;
+
+    /* Finally, verify the signature to determine if this is a TDVF image. */
+    metadata->Signature = le32_to_cpu(metadata->Signature);
+    if (metadata->Signature != TDVF_SIGNATURE) {
+        error_report("Invalid TDVF signature in metadata!");
+        return NULL;
+    }
+
+    /* Sanity check that the TDVF doesn't overlap its own metadata. */
+    metadata->Length = le32_to_cpu(metadata->Length);
+    if (offset + metadata->Length > size) {
+        return NULL;
+    }
+
+    /* Only version 1 is supported/defined. */
+    metadata->Version = le32_to_cpu(metadata->Version);
+    if (metadata->Version != TDX_METADATA_VERSION) {
+        return NULL;
+    }
+
+    return metadata;
+}
+
+static int tdvf_parse_and_check_section_entry(const TdvfSectionEntry *src,
+                                              TdxFirmwareEntry *entry)
+{
+    entry->data_offset = le32_to_cpu(src->DataOffset);
+    entry->data_len = le32_to_cpu(src->RawDataSize);
+    entry->address = le64_to_cpu(src->MemoryAddress);
+    entry->size = le64_to_cpu(src->MemoryDataSize);
+    entry->type = le32_to_cpu(src->Type);
+    entry->attributes = le32_to_cpu(src->Attributes);
+
+    /* sanity check */
+    if (entry->size < entry->data_len) {
+        error_report("Broken metadata RawDataSize 0x%x MemoryDataSize 0x%lx",
+                     entry->data_len, entry->size);
+        return -1;
+    }
+    if (!QEMU_IS_ALIGNED(entry->address, TARGET_PAGE_SIZE)) {
+        error_report("MemoryAddress 0x%lx not page aligned", entry->address);
+        return -1;
+    }
+    if (!QEMU_IS_ALIGNED(entry->size, TARGET_PAGE_SIZE)) {
+        error_report("MemoryDataSize 0x%lx not page aligned", entry->size);
+        return -1;
+    }
+
+    switch (entry->type) {
+    case TDVF_SECTION_TYPE_BFV:
+    case TDVF_SECTION_TYPE_CFV:
+        /* The sections that must be copied from firmware image to TD memory */
+        if (entry->data_len == 0) {
+            error_report("%d section with RawDataSize == 0", entry->type);
+            return -1;
+        }
+        break;
+    case TDVF_SECTION_TYPE_TD_HOB:
+    case TDVF_SECTION_TYPE_TEMP_MEM:
+        /* The sections that no need to be copied from firmware image */
+        if (entry->data_len != 0) {
+            error_report("%d section with RawDataSize 0x%x != 0",
+                         entry->type, entry->data_len);
+            return -1;
+        }
+        break;
+    default:
+        error_report("TDVF contains unsupported section type %d", entry->type);
+        return -1;
+    }
+
+    return 0;
+}
+
+int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size)
+{
+    TdvfSectionEntry *sections;
+    TdvfMetadata *metadata;
+    ssize_t entries_size;
+    uint32_t len, i;
+
+    metadata = tdvf_get_metadata(flash_ptr, size);
+    if (!metadata) {
+        return -EINVAL;
+    }
+
+    //load and parse metadata entries
+    fw->nr_entries = le32_to_cpu(metadata->NumberOfSectionEntries);
+    if (fw->nr_entries < 2) {
+        error_report("Invalid number of fw entries (%u) in TDVF", fw->nr_entries);
+        return -EINVAL;
+    }
+
+    len = le32_to_cpu(metadata->Length);
+    entries_size = fw->nr_entries * sizeof(TdvfSectionEntry);
+    if (len != sizeof(*metadata) + entries_size) {
+        error_report("TDVF metadata len (0x%x) mismatch, expected (0x%x)",
+                     len, (uint32_t)(sizeof(*metadata) + entries_size));
+        return -EINVAL;
+    }
+
+    fw->entries = g_new(TdxFirmwareEntry, fw->nr_entries);
+    sections = g_new(TdvfSectionEntry, fw->nr_entries);
+
+    if (!memcpy(sections, (void *)metadata + sizeof(*metadata), entries_size))  {
+        error_report("Failed to read TDVF section entries");
+        goto err;
+    }
+
+    for (i = 0; i < fw->nr_entries; i++) {
+        if (tdvf_parse_and_check_section_entry(&sections[i], &fw->entries[i])) {
+            goto err;
+        }
+    }
+    g_free(sections);
+
+    return 0;
+
+err:
+    g_free(sections);
+    fw->entries = 0;
+    g_free(fw->entries);
+    return -EINVAL;
+}
diff --git a/include/hw/i386/tdvf.h b/include/hw/i386/tdvf.h
new file mode 100644
index 000000000000..593341eb2e93
--- /dev/null
+++ b/include/hw/i386/tdvf.h
@@ -0,0 +1,51 @@
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
+#define TDVF_SECTION_TYPE_BFV               0
+#define TDVF_SECTION_TYPE_CFV               1
+#define TDVF_SECTION_TYPE_TD_HOB            2
+#define TDVF_SECTION_TYPE_TEMP_MEM          3
+
+#define TDVF_SECTION_ATTRIBUTES_MR_EXTEND   (1U << 0)
+#define TDVF_SECTION_ATTRIBUTES_PAGE_AUG    (1U << 1)
+
+typedef struct TdxFirmwareEntry {
+    uint32_t data_offset;
+    uint32_t data_len;
+    uint64_t address;
+    uint64_t size;
+    uint32_t type;
+    uint32_t attributes;
+} TdxFirmwareEntry;
+
+typedef struct TdxFirmware {
+    uint32_t nr_entries;
+    TdxFirmwareEntry *entries;
+} TdxFirmware;
+
+int tdvf_parse_metadata(TdxFirmware *fw, void *flash_ptr, int size);
+
+#endif /* HW_I386_TDVF_H */
-- 
2.34.1


