Return-Path: <kvm+bounces-11029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F165E8724AF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:47:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 919AC1F2615B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EAD4111AD;
	Tue,  5 Mar 2024 16:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h4oZokIE"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519CB1758C
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657216; cv=none; b=LgQzLWfAWIvwAYrj5xIfYg+r83imsgV7Fxgof7sloIcWhbCbX6KGdvvBdpEGa7O8qrfg483jao4y8C2FcRDo5duWVmQpA1dUE1g2+W9ObLu2/QlG4rcWL0Fevs9X1xj2rmbDou/5LodDA8OI3udAzqZaan0zvbv3Yiz3e7JmH5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657216; c=relaxed/simple;
	bh=WZ1nnASCLXaw8hXGVUKPy/XAig0PlLzT3NlCxdTm1JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=DVFHHAlnTi5b6edNt7rjs8mZ1WJ+EM67ORUz3kHEyCR6wX8ad6Nt/5f6ke6258LCUnYyrRxGQNtimgUp9I4VXssl4Krc6Elcg9FXtyOmASeFGgDDXUdgoKwPHuGQuKFzvHZJiG0WPRKS0D5T161eZvhrmMmkZkDh6iNrgj72k8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h4oZokIE; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UeqPKhXa62dzio8QwISwv1BHy0y6QQ4nVa37ltWJJRM=;
	b=h4oZokIEGJDHa1ZShMS1k5Rizs6DApsUa8uXBiSx9fPGswXMGEx/64aMv9TSg3MeBNfzmm
	x8cdHcSxkvvvmLvZbTub9xfL49zIniitR3omWf0DqCbO1GZuBtAuAPyLdD9WBx8U2/p0gB
	zApiV/Nm1cJgxn219hcOPHb3RLQLnso=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 08/18] arm64: efi: Improve device tree discovery
Date: Tue,  5 Mar 2024 17:46:32 +0100
Message-ID: <20240305164623.379149-28-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Check the device tree GUID when the environment variable is missing,
which allows directly loading the unit test with QEMU's '-kernel'
command line parameter, which is much faster than putting the test
in the EFI file system and then running it from the UEFI shell.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/efi.c       | 19 ++++++++++++-------
 lib/linux/efi.h |  2 ++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/lib/efi.c b/lib/efi.c
index d94f0fa16fc0..4d1126b4a64e 100644
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
@@ -288,13 +288,18 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
 	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
 	efi_char16_t *val;
 	void *fdt = NULL;
-	int fdtsize;
+	int fdtsize = 0;
 
 	val = efi_get_var(handle, image, var);
-	if (val)
+	if (val) {
 		efi_load_image(handle, image, &fdt, &fdtsize, val);
+		if (fdtsize == 0)
+			return NULL;
+	} else if (efi_get_system_config_table(DEVICE_TREE_GUID, &fdt) != EFI_SUCCESS) {
+		return NULL;
+	}
 
-	return fdt;
+	return fdt_check_header(fdt) == 0 ? fdt : NULL;
 }
 
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
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
2.44.0


