Return-Path: <kvm+bounces-9539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AD6861658
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 007CC1C24920
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E10884A33;
	Fri, 23 Feb 2024 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cZsHC+5A"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888E283CD2
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703541; cv=none; b=DkC51D0AK1ZirP9sky6QZq4TwmrTLX+INr55RVXDglFmxNCY3lZX3ljTMxntDLmz0my94oMZbgazApvLg43IgSqU+OcR+zdpgwZlvE4rw6k4UDPnxRuHnkXVcL9tZSlQ9btdz77BeMMfhqieKk+sRX+EbuBXQtg5pGSjZDprYgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703541; c=relaxed/simple;
	bh=xin4Ma602BK3JDlW/sBwEZSrxoI+t+Q1OLYq70BO+co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=CGDK6IxXATggudvRgLo702+Jw50AAB8nNHmWbIPLsBheVIuWnp+50IUca5r+xUo8/5nueWnhkY2v5LK9zuTb1Xl5LEoLSUOojvzvYfScLAOFF2/nc6LJaTPggnowxSSgJudPZ0mBJCQ/M9aGUGxVWzNA5jTJi7scw6eEIVMhyis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cZsHC+5A; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JqRuCfOS78D2tqOlNEUkzy1K+Rijz3OoIyyC33mXe98=;
	b=cZsHC+5AA3oqc01lWZODRP6dKn1sKe0MgW+tvB7hMTTLoaJqnwqt29CFyOMHUFwuHPeDQC
	ZbFuMHvKWKZizQMgr83TYRclNOVRhmr2DSdXLcFz3wUSBgTzeTD3jsV8gd6645ZHvojHTw
	DWK81irWNjjBnXlqYnkS9XGgor18BYM=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 09/14] lib/efi: Add support for loading the initrd
Date: Fri, 23 Feb 2024 16:51:35 +0100
Message-ID: <20240223155125.368512-25-andrew.jones@linux.dev>
In-Reply-To: <20240223155125.368512-16-andrew.jones@linux.dev>
References: <20240223155125.368512-16-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When loading non-efi tests with QEMU's '-kernel' option we also load
an environ with the '-initrd' option. Now that efi tests can also be
loaded with the '-kernel' option also provide the '-initrd' environ.
For EFI, we use the EFI_LOAD_FILE2_PROTOCOL_GUID protocol to load
LINUX_EFI_INITRD_MEDIA_GUID. Each architecture which wants to use the
initrd for the environ will need to call setup_env() on the initrd
data. As usual, the new efi function is heavily influenced by Linux's
implementation.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/efi.c       | 65 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/linux/efi.h | 27 ++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 0785bd3e8916..edfcc80ef114 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -14,6 +14,10 @@
 #include "efi.h"
 #include "libfdt/libfdt.h"
 
+/* From each arch */
+extern char *initrd;
+extern u32 initrd_size;
+
 /* From lib/argv.c */
 extern int __argc, __envc;
 extern char *__argv[100];
@@ -303,6 +307,65 @@ static bool efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image,
 	return fdt_check_header(*fdt) == 0;
 }
 
+static const struct {
+	struct efi_vendor_dev_path	vendor;
+	struct efi_generic_dev_path	end;
+} __packed initrd_dev_path = {
+	{
+		{
+			EFI_DEV_MEDIA,
+			EFI_DEV_MEDIA_VENDOR,
+			sizeof(struct efi_vendor_dev_path),
+		},
+		LINUX_EFI_INITRD_MEDIA_GUID
+	}, {
+		EFI_DEV_END_PATH,
+		EFI_DEV_END_ENTIRE,
+		sizeof(struct efi_generic_dev_path)
+	}
+};
+
+static void efi_load_initrd(void)
+{
+	efi_guid_t lf2_proto_guid = EFI_LOAD_FILE2_PROTOCOL_GUID;
+	efi_device_path_protocol_t *dp;
+	efi_load_file2_protocol_t *lf2;
+	efi_handle_t handle;
+	efi_status_t status;
+	unsigned long file_size = 0;
+
+	initrd = NULL;
+	initrd_size = 0;
+
+	dp = (efi_device_path_protocol_t *)&initrd_dev_path;
+	status = efi_bs_call(locate_device_path, &lf2_proto_guid, &dp, &handle);
+	if (status != EFI_SUCCESS)
+		return;
+
+	status = efi_bs_call(handle_protocol, handle, &lf2_proto_guid, (void **)&lf2);
+	assert(status == EFI_SUCCESS);
+
+	status = efi_call_proto(lf2, load_file, dp, false, &file_size, NULL);
+	assert(status == EFI_BUFFER_TOO_SMALL);
+
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, file_size, (void **)&initrd);
+	assert(status == EFI_SUCCESS);
+
+	status = efi_call_proto(lf2, load_file, dp, false, &file_size, (void *)initrd);
+	assert(status == EFI_SUCCESS);
+
+	initrd_size = (u32)file_size;
+
+	/*
+	 * UEFI appends initrd=initrd to the command line when an initrd is present.
+	 * Remove it in order to avoid confusing unit tests.
+	 */
+	if (!strcmp(__argv[__argc - 1], "initrd=initrd")) {
+		__argv[__argc - 1] = NULL;
+		__argc -= 1;
+	}
+}
+
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
@@ -341,6 +404,8 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	}
 	setup_args(cmdline_ptr);
 
+	efi_load_initrd();
+
 	efi_bootinfo.fdt_valid = efi_get_fdt(handle, image, &efi_bootinfo.fdt);
 	/* Set up efi_bootinfo */
 	efi_bootinfo.mem_map.map = &map;
diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 92d798f79767..8fa23ad078ce 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -70,6 +70,9 @@ typedef guid_t efi_guid_t;
 
 #define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
 
+#define EFI_LOAD_FILE2_PROTOCOL_GUID EFI_GUID(0x4006c0c1, 0xfcb3, 0x403e,  0x99, 0x6d, 0x4a, 0x6c, 0x87, 0x24, 0xe0, 0x6d)
+#define LINUX_EFI_INITRD_MEDIA_GUID EFI_GUID(0x5568e427, 0x68fc, 0x4f3d,  0xac, 0x74, 0xca, 0x55, 0x52, 0x31, 0xcc, 0x68)
+
 typedef struct {
 	efi_guid_t guid;
 	void *table;
@@ -248,6 +251,12 @@ struct efi_generic_dev_path {
 	u16				length;
 } __packed;
 
+struct efi_vendor_dev_path {
+	struct efi_generic_dev_path	header;
+	efi_guid_t			vendorguid;
+	u8				vendordata[];
+} __packed;
+
 typedef struct efi_generic_dev_path efi_device_path_protocol_t;
 
 /*
@@ -449,6 +458,19 @@ typedef struct _efi_simple_file_system_protocol efi_simple_file_system_protocol_
 typedef struct _efi_file_protocol efi_file_protocol_t;
 typedef efi_simple_file_system_protocol_t efi_file_io_interface_t;
 typedef efi_file_protocol_t efi_file_t;
+typedef union efi_load_file_protocol efi_load_file_protocol_t;
+typedef union efi_load_file_protocol efi_load_file2_protocol_t;
+
+union efi_load_file_protocol {
+	struct {
+		efi_status_t (__efiapi *load_file)(efi_load_file_protocol_t *,
+						   efi_device_path_protocol_t *,
+						   bool, unsigned long *, void *);
+	};
+	struct {
+		u32 load_file;
+	} mixed_mode;
+};
 
 typedef efi_status_t efi_simple_file_system_protocol_open_volume(
 	efi_simple_file_system_protocol_t *this,
@@ -544,7 +566,12 @@ typedef struct {
 	efi_char16_t	file_name[1];
 } efi_file_info_t;
 
+#define efi_fn_call(inst, func, ...) (inst)->func(__VA_ARGS__)
 #define efi_bs_call(func, ...) efi_system_table->boottime->func(__VA_ARGS__)
 #define efi_rs_call(func, ...) efi_system_table->runtime->func(__VA_ARGS__)
+#define efi_call_proto(inst, func, ...) ({				\
+		__typeof__(inst) __inst = (inst);			\
+		efi_fn_call(__inst, func, __inst, ##__VA_ARGS__);	\
+})
 
 #endif /* __LINUX_UEFI_H */
-- 
2.43.0


