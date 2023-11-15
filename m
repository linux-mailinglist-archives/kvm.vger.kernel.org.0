Return-Path: <kvm+bounces-1772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7F47EBDD4
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:21:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71227281317
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E6A4C6E;
	Wed, 15 Nov 2023 07:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hzTlJj8N"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891354685
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:21:34 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774879E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032892; x=1731568892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pw70+E9f7yP0q/kg6tok3Z3RGqPvOBZoP8fDG+f0630=;
  b=hzTlJj8N1UZneFBgfILocUAvXflN8hr86LquiwyNSrQHSVHXwq3814WT
   eGABQ0wDv2bgB21sFAiBs6uMqDAicKNxz4qIt0EKwnEa/qL2z+VJo6EnR
   AssRAUw8q/rwMS4HXg7AZwHcTXSr86Lm/9c5j8XgUFVtxx78OPluHoUWx
   VdAYVLUho/yxDwaOQ94ptJyvDxfQPmFS3mzIOfsvTKpCdoDtNf/HvoEmq
   Hp/K1ydjOdFbsK73WmWr5WdfJcGMmOhypmD+t4PR8Aoz1iZvZOdpq87/Z
   dROax9+ioHmHSCoewTcUneJfgtMxTeLd+LVZGGb6WqjhfY28zSeW/Nui2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623297"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623297"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:21:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800026"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800026"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:21:20 -0800
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
Subject: [PATCH v3 44/70] headers: Add definitions from UEFI spec for volumes, resources, etc...
Date: Wed, 15 Nov 2023 02:14:53 -0500
Message-Id: <20231115071519.2864957-45-xiaoyao.li@intel.com>
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

Add UEFI definitions for literals, enums, structs, GUIDs, etc... that
will be used by TDX to build the UEFI Hand-Off Block (HOB) that is passed
to the Trusted Domain Virtual Firmware (TDVF).

All values come from the UEFI specification [1], PI spec [2] and TDVF
design guide[3].

[1] UEFI Specification v2.1.0 https://uefi.org/sites/default/files/resources/UEFI_Spec_2_10_Aug29.pdf
[2] UEFI PI spec v1.8 https://uefi.org/sites/default/files/resources/UEFI_PI_Spec_1_8_March3.pdf
[3] https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 include/standard-headers/uefi/uefi.h | 198 +++++++++++++++++++++++++++
 1 file changed, 198 insertions(+)
 create mode 100644 include/standard-headers/uefi/uefi.h

diff --git a/include/standard-headers/uefi/uefi.h b/include/standard-headers/uefi/uefi.h
new file mode 100644
index 000000000000..b15aba796156
--- /dev/null
+++ b/include/standard-headers/uefi/uefi.h
@@ -0,0 +1,198 @@
+/*
+ * Copyright (C) 2020 Intel Corporation
+ *
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
+ *
+ */
+
+#ifndef HW_I386_UEFI_H
+#define HW_I386_UEFI_H
+
+/***************************************************************************/
+/*
+ * basic EFI definitions
+ * supplemented with UEFI Specification Version 2.8 (Errata A)
+ * released February 2020
+ */
+/* UEFI integer is little endian */
+
+typedef struct {
+    uint32_t Data1;
+    uint16_t Data2;
+    uint16_t Data3;
+    uint8_t Data4[8];
+} EFI_GUID;
+
+typedef enum {
+    EfiReservedMemoryType,
+    EfiLoaderCode,
+    EfiLoaderData,
+    EfiBootServicesCode,
+    EfiBootServicesData,
+    EfiRuntimeServicesCode,
+    EfiRuntimeServicesData,
+    EfiConventionalMemory,
+    EfiUnusableMemory,
+    EfiACPIReclaimMemory,
+    EfiACPIMemoryNVS,
+    EfiMemoryMappedIO,
+    EfiMemoryMappedIOPortSpace,
+    EfiPalCode,
+    EfiPersistentMemory,
+    EfiUnacceptedMemoryType,
+    EfiMaxMemoryType
+} EFI_MEMORY_TYPE;
+
+#define EFI_HOB_HANDOFF_TABLE_VERSION 0x0009
+
+#define EFI_HOB_TYPE_HANDOFF              0x0001
+#define EFI_HOB_TYPE_MEMORY_ALLOCATION    0x0002
+#define EFI_HOB_TYPE_RESOURCE_DESCRIPTOR  0x0003
+#define EFI_HOB_TYPE_GUID_EXTENSION       0x0004
+#define EFI_HOB_TYPE_FV                   0x0005
+#define EFI_HOB_TYPE_CPU                  0x0006
+#define EFI_HOB_TYPE_MEMORY_POOL          0x0007
+#define EFI_HOB_TYPE_FV2                  0x0009
+#define EFI_HOB_TYPE_LOAD_PEIM_UNUSED     0x000A
+#define EFI_HOB_TYPE_UEFI_CAPSULE         0x000B
+#define EFI_HOB_TYPE_FV3                  0x000C
+#define EFI_HOB_TYPE_UNUSED               0xFFFE
+#define EFI_HOB_TYPE_END_OF_HOB_LIST      0xFFFF
+
+typedef struct {
+    uint16_t HobType;
+    uint16_t HobLength;
+    uint32_t Reserved;
+} EFI_HOB_GENERIC_HEADER;
+
+typedef uint64_t EFI_PHYSICAL_ADDRESS;
+typedef uint32_t EFI_BOOT_MODE;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    uint32_t Version;
+    EFI_BOOT_MODE BootMode;
+    EFI_PHYSICAL_ADDRESS EfiMemoryTop;
+    EFI_PHYSICAL_ADDRESS EfiMemoryBottom;
+    EFI_PHYSICAL_ADDRESS EfiFreeMemoryTop;
+    EFI_PHYSICAL_ADDRESS EfiFreeMemoryBottom;
+    EFI_PHYSICAL_ADDRESS EfiEndOfHobList;
+} EFI_HOB_HANDOFF_INFO_TABLE;
+
+#define EFI_RESOURCE_SYSTEM_MEMORY          0x00000000
+#define EFI_RESOURCE_MEMORY_MAPPED_IO       0x00000001
+#define EFI_RESOURCE_IO                     0x00000002
+#define EFI_RESOURCE_FIRMWARE_DEVICE        0x00000003
+#define EFI_RESOURCE_MEMORY_MAPPED_IO_PORT  0x00000004
+#define EFI_RESOURCE_MEMORY_RESERVED        0x00000005
+#define EFI_RESOURCE_IO_RESERVED            0x00000006
+#define EFI_RESOURCE_MEMORY_UNACCEPTED      0x00000007
+#define EFI_RESOURCE_MAX_MEMORY_TYPE        0x00000008
+
+#define EFI_RESOURCE_ATTRIBUTE_PRESENT                  0x00000001
+#define EFI_RESOURCE_ATTRIBUTE_INITIALIZED              0x00000002
+#define EFI_RESOURCE_ATTRIBUTE_TESTED                   0x00000004
+#define EFI_RESOURCE_ATTRIBUTE_SINGLE_BIT_ECC           0x00000008
+#define EFI_RESOURCE_ATTRIBUTE_MULTIPLE_BIT_ECC         0x00000010
+#define EFI_RESOURCE_ATTRIBUTE_ECC_RESERVED_1           0x00000020
+#define EFI_RESOURCE_ATTRIBUTE_ECC_RESERVED_2           0x00000040
+#define EFI_RESOURCE_ATTRIBUTE_READ_PROTECTED           0x00000080
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_PROTECTED          0x00000100
+#define EFI_RESOURCE_ATTRIBUTE_EXECUTION_PROTECTED      0x00000200
+#define EFI_RESOURCE_ATTRIBUTE_UNCACHEABLE              0x00000400
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_COMBINEABLE        0x00000800
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_THROUGH_CACHEABLE  0x00001000
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_BACK_CACHEABLE     0x00002000
+#define EFI_RESOURCE_ATTRIBUTE_16_BIT_IO                0x00004000
+#define EFI_RESOURCE_ATTRIBUTE_32_BIT_IO                0x00008000
+#define EFI_RESOURCE_ATTRIBUTE_64_BIT_IO                0x00010000
+#define EFI_RESOURCE_ATTRIBUTE_UNCACHED_EXPORTED        0x00020000
+#define EFI_RESOURCE_ATTRIBUTE_READ_ONLY_PROTECTED      0x00040000
+#define EFI_RESOURCE_ATTRIBUTE_READ_ONLY_PROTECTABLE    0x00080000
+#define EFI_RESOURCE_ATTRIBUTE_READ_PROTECTABLE         0x00100000
+#define EFI_RESOURCE_ATTRIBUTE_WRITE_PROTECTABLE        0x00200000
+#define EFI_RESOURCE_ATTRIBUTE_EXECUTION_PROTECTABLE    0x00400000
+#define EFI_RESOURCE_ATTRIBUTE_PERSISTENT               0x00800000
+#define EFI_RESOURCE_ATTRIBUTE_PERSISTABLE              0x01000000
+#define EFI_RESOURCE_ATTRIBUTE_MORE_RELIABLE            0x02000000
+
+typedef uint32_t EFI_RESOURCE_TYPE;
+typedef uint32_t EFI_RESOURCE_ATTRIBUTE_TYPE;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_GUID Owner;
+    EFI_RESOURCE_TYPE ResourceType;
+    EFI_RESOURCE_ATTRIBUTE_TYPE ResourceAttribute;
+    EFI_PHYSICAL_ADDRESS PhysicalStart;
+    uint64_t ResourceLength;
+} EFI_HOB_RESOURCE_DESCRIPTOR;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_GUID Name;
+
+    /* guid specific data follows */
+} EFI_HOB_GUID_TYPE;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_PHYSICAL_ADDRESS BaseAddress;
+    uint64_t Length;
+} EFI_HOB_FIRMWARE_VOLUME;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_PHYSICAL_ADDRESS BaseAddress;
+    uint64_t Length;
+    EFI_GUID FvName;
+    EFI_GUID FileName;
+} EFI_HOB_FIRMWARE_VOLUME2;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    EFI_PHYSICAL_ADDRESS BaseAddress;
+    uint64_t Length;
+    uint32_t AuthenticationStatus;
+    bool ExtractedFv;
+    EFI_GUID FvName;
+    EFI_GUID FileName;
+} EFI_HOB_FIRMWARE_VOLUME3;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+    uint8_t SizeOfMemorySpace;
+    uint8_t SizeOfIoSpace;
+    uint8_t Reserved[6];
+} EFI_HOB_CPU;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+} EFI_HOB_MEMORY_POOL;
+
+typedef struct {
+    EFI_HOB_GENERIC_HEADER Header;
+
+    EFI_PHYSICAL_ADDRESS BaseAddress;
+    uint64_t Length;
+} EFI_HOB_UEFI_CAPSULE;
+
+#define EFI_HOB_OWNER_ZERO                                      \
+    ((EFI_GUID){ 0x00000000, 0x0000, 0x0000,                    \
+        { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 } })
+
+#endif
-- 
2.34.1


