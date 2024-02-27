Return-Path: <kvm+bounces-10123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F85D86A015
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1E5F1F27B37
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB344149DF0;
	Tue, 27 Feb 2024 19:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A0/pZ8xj"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FDD1369B9
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061708; cv=none; b=AG27P+kt0CsbTBrkN7VNPLMxcI6csuvAb1rCj4CxvPA73AQ5fXkqb0fVTbdUlg/HfWAKp6BFTKGCaXou4SycgTLPCMX2g3hSU496Xd48fUTJLc6R9ALgu7FRVFLag2KECIo572eBRs5fnUKBbq/BTnEPuDkGFn0Cl8xHnNofpM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061708; c=relaxed/simple;
	bh=mXnxA8GpBHOStiU9ED8il/47Ba3BP3xeZUtQkc10dcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=En+m0ge7+cnh18tbwkP7ZpdQe7OBGYtPg7T/R783V+RRc8HSElOPcOCVwRz3qI1+FVWmSkdy9bzU6FLFEiQ1c5Y9GrvlOQr/rqryO3tHmK9f5gmoQQLIbuXanqm7ogC12/vECVwsOVHEACISK4G5ZJiu6lxi/kV4Cnm7UiDzOyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A0/pZ8xj; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dIhBoE+ztxgrIn9LX6XotPKIWxQt8o1cjxufO8kGC80=;
	b=A0/pZ8xjsVA5BRgY0pr3jp3Z+KVktBdx673uV+UclbgOGU+ZwqvCWU8LidVQa1iLQnX/cV
	8ety7LWGRs/ENw1/6j/AZp6yjCPcGfIpX/B/IGR12jn+mP217t9PY8YYF9mjx2JYSzr5pa
	tPH4oYbVLqqL4WRw7GoXNjlkIsnM2GU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 08/18] arm64: efi: Improve device tree discovery
Date: Tue, 27 Feb 2024 20:21:18 +0100
Message-ID: <20240227192109.487402-28-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Zero is a valid address for the device tree so add an fdt_valid data
member to determine when the address is valid or not. Also, check the
device tree GUID when the environment variable is missing. The latter
change allows directly loading the unit test with QEMU's '-kernel'
command line parameter, which is much faster than putting the test
in the EFI file system and then running it from the UEFI shell.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c |  3 ++-
 lib/efi.c       | 28 +++++++++++++++++-----------
 lib/efi.h       |  3 ++-
 lib/linux/efi.h |  2 ++
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 0382cbdaf5a1..76aae4627a7b 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -342,7 +342,8 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		}
 		memregions_add(&r);
 	}
-	if (fdt) {
+
+	if (efi_bootinfo->fdt_valid) {
 		/* Move the FDT to the base of free memory */
 		fdt_size = fdt_totalsize(fdt);
 		ret = fdt_move(fdt, (void *)free_mem_start, fdt_size);
diff --git a/lib/efi.c b/lib/efi.c
index d94f0fa16fc0..0785bd3e8916 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -6,13 +6,13 @@
  *
  * SPDX-License-Identifier: LGPL-2.0-or-later
  */
-
-#include "efi.h"
+#include <libcflat.h>
 #include <argv.h>
-#include <stdlib.h>
 #include <ctype.h>
-#include <libcflat.h>
+#include <stdlib.h>
 #include <asm/setup.h>
+#include "efi.h"
+#include "libfdt/libfdt.h"
 
 /* From lib/argv.c */
 extern int __argc, __envc;
@@ -283,18 +283,24 @@ static void* efi_get_var(efi_handle_t handle, struct efi_loaded_image_64 *image,
 	return val;
 }
 
-static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
+static bool efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image, void **fdt)
 {
 	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
 	efi_char16_t *val;
-	void *fdt = NULL;
-	int fdtsize;
+	int fdtsize = 0;
+
+	*fdt = NULL;
 
 	val = efi_get_var(handle, image, var);
-	if (val)
-		efi_load_image(handle, image, &fdt, &fdtsize, val);
+	if (val) {
+		efi_load_image(handle, image, fdt, &fdtsize, val);
+		if (fdtsize == 0)
+			return false;
+	} else if (efi_get_system_config_table(DEVICE_TREE_GUID, fdt) != EFI_SUCCESS) {
+		return false;
+	}
 
-	return fdt;
+	return fdt_check_header(*fdt) == 0;
 }
 
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
@@ -335,7 +341,7 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	}
 	setup_args(cmdline_ptr);
 
-	efi_bootinfo.fdt = efi_get_fdt(handle, image);
+	efi_bootinfo.fdt_valid = efi_get_fdt(handle, image, &efi_bootinfo.fdt);
 	/* Set up efi_bootinfo */
 	efi_bootinfo.mem_map.map = &map;
 	efi_bootinfo.mem_map.map_size = &map_size;
diff --git a/lib/efi.h b/lib/efi.h
index db46d45068ee..4bd01f7199ce 100644
--- a/lib/efi.h
+++ b/lib/efi.h
@@ -30,7 +30,8 @@
  */
 typedef struct {
 	struct efi_boot_memmap mem_map;
-	const void *fdt;
+	void *fdt;
+	bool fdt_valid;
 } efi_bootinfo_t;
 
 efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle,
diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 410f0b1a0da1..92d798f79767 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -66,6 +66,8 @@ typedef guid_t efi_guid_t;
 #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define ACPI_20_TABLE_GUID EFI_GUID(0x8868e871, 0xe4f1, 0x11d3,  0xbc, 0x22, 0x00, 0x80, 0xc7, 0x3c, 0x88, 0x81)
 
+#define DEVICE_TREE_GUID EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
+
 #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
 
 typedef struct {
-- 
2.43.0


