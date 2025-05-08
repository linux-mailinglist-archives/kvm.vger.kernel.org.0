Return-Path: <kvm+bounces-45925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB43AAFE73
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFF31B40DFD
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B4D283CBE;
	Thu,  8 May 2025 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ma1DteGc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4B228315F
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716765; cv=none; b=h5i7xGl0M6JDAwY5Ez/lCAhKpn48Wa2916DqngY714Leb6RmaLgbyFnRF8JXI975x/G/Sf1fJR4Hc3XnEnZdvv+84nkyvjTWylorZkKntnMPRBYB1L1dNnGx40UExIfqz+si2QEa5yb92aUCU0wbxzB2C3051vRqrOdVM0i4iPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716765; c=relaxed/simple;
	bh=wD8Kvtj/d3HQzlszpVDkCNb2gHjrXU68l4/VjTG4hpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAb3QjFw/mevYCfIKEvZIJOy3Cup6oC8GQpYRRys+cCbaZ6a2b63Jfmiwfhts2MGNYFe+TqObvPx6tAJioXLFx/4jYc0+uCL/Mz01oTuEUqvyvUsYiOg7tcSvVJNcYsWfBEovryOEsDwAfOKTYV+DrIrnVwF7BU4hmr7NIoWZWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ma1DteGc; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716763; x=1778252763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wD8Kvtj/d3HQzlszpVDkCNb2gHjrXU68l4/VjTG4hpk=;
  b=ma1DteGcCqSuWg6Xa2bLdhXL9fy+P/zCploi7UD90um5p7XNpi3BJrRI
   vWta5tlRdu9T7oC5TIfrIk2IiuuwrD7cC4Oqf7SVgnHz/FB4IIr32qOQo
   OCtmru1cqjhVcWTzzc0cXaHHXz8e70iHe7K3ASqXmgkD6leWVmjhmD6D7
   obdK8KxWoY4TcArK/Y2Da87Jh73pnXdsk0rrH56NDBmU69y+bYpxXfIOC
   jIPAMfgwsTWdQAv9q0/HDnaAAYCPuAE0Uakn6wf/1SHOZkL84gYtye8nf
   ItQFfyUvIKvTArfCz8Sd0ByqQ9EIxUOXDtxyJJ5ggmxfX2LHLr8o5TmCT
   w==;
X-CSE-ConnectionGUID: mjk7YsHySdKi56x03WrtVw==
X-CSE-MsgGUID: H8xmsB6ERiO8p1aFRKIHhg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888178"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888178"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:03 -0700
X-CSE-ConnectionGUID: L23JwriwTIqi9kO9SVkGUQ==
X-CSE-MsgGUID: 3roRcB+HQJuiuC/OIacYHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439987"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:00 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 22/55] headers: Add definitions from UEFI spec for volumes, resources, etc...
Date: Thu,  8 May 2025 10:59:28 -0400
Message-ID: <20250508150002.689633-23-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
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
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v7:
 - use SPDX tag;
---
 include/standard-headers/uefi/uefi.h | 187 +++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)
 create mode 100644 include/standard-headers/uefi/uefi.h

diff --git a/include/standard-headers/uefi/uefi.h b/include/standard-headers/uefi/uefi.h
new file mode 100644
index 000000000000..5256349ec0b6
--- /dev/null
+++ b/include/standard-headers/uefi/uefi.h
@@ -0,0 +1,187 @@
+/*
+ * Copyright (C) 2025 Intel Corporation
+ *
+ * Author: Isaku Yamahata <isaku.yamahata at gmail.com>
+ *                        <isaku.yamahata at intel.com>
+ *         Xiaoyao Li <xiaoyao.li@intel.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
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
2.43.0


