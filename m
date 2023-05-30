Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2E67168DC
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjE3QLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjE3QLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:11:14 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6084C180
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:10:47 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 124911AED;
        Tue, 30 May 2023 09:11:01 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FCB53F663;
        Tue, 30 May 2023 09:10:14 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v6 19/32] lib/efi: Add support for reading an FDT
Date:   Tue, 30 May 2023 17:09:11 +0100
Message-Id: <20230530160924.82158-20-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change adds support for reading enviroment variables. To do so it
introduces a new GUID: 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 that the
user needs to provide when setting enviroment variables. For example,
to set the path to the fdt a user can execute:

In addition, this change add support for reading the fdt into memory
and providing a pointer to the test through efi_bootinfo_t.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/linux/efi.h | 101 ++++++++++++++++++++++++++++++++++++++++
 lib/efi.h       |  12 +++++
 lib/efi.c       | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 233 insertions(+)

diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index 9a1cf87b..bb6d5a85 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -12,6 +12,7 @@
 
 #define BITS_PER_LONG 64
 
+#define EFI_ERROR(a)		(((int64_t) a) < 0)
 #define EFI_SUCCESS		0
 #define EFI_LOAD_ERROR		( 1 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_INVALID_PARAMETER	( 2 | (1UL << (BITS_PER_LONG-1)))
@@ -436,6 +437,106 @@ struct efi_loaded_image_64 {
 	efi_status_t		(__efiapi * unload)(efi_handle_t image_handle);
 };
 
+
+typedef struct _efi_simple_file_system_protocol efi_simple_file_system_protocol_t;
+typedef struct _efi_file_protocol efi_file_protocol_t;
+typedef efi_simple_file_system_protocol_t efi_file_io_interface_t;
+typedef efi_file_protocol_t efi_file_t;
+
+typedef efi_status_t efi_simple_file_system_protocol_open_volume(
+	efi_simple_file_system_protocol_t *this,
+	efi_file_protocol_t **root);
+
+#define EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_GUID EFI_GUID(0x964e5b22, 0x6459, 0x11d2, 0x8e, 0x39, 0x0, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
+
+struct _efi_simple_file_system_protocol {
+	uint64_t						revision;
+	efi_simple_file_system_protocol_open_volume __efiapi	*open_volume;
+};
+
+/* Open modes */
+#define EFI_FILE_MODE_READ    0x0000000000000001ULL
+#define EFI_FILE_MODE_WRITE   0x0000000000000002ULL
+#define EFI_FILE_MODE_CREATE  0x8000000000000000ULL
+
+typedef efi_status_t efi_file_open(efi_file_protocol_t *this,
+				   efi_file_protocol_t **new_handle,
+				   efi_char16_t *file_name,
+				   uint64_t open_mode,
+				   uint64_t attributes);
+typedef efi_status_t efi_file_close(efi_file_protocol_t *this);
+typedef efi_status_t efi_file_delete(efi_file_protocol_t *this);
+typedef efi_status_t efi_file_read(efi_file_protocol_t *this,
+				   uint64_t *buffer_size,
+				   void *buffer);
+typedef efi_status_t efi_file_write(efi_file_protocol_t *this,
+				    uint64_t *buffer_size,
+				    void *buffer);
+typedef efi_status_t efi_file_set_position(efi_file_protocol_t *this,
+					   uint64_t position);
+typedef efi_status_t efi_file_get_position(efi_file_protocol_t *this,
+					   uint64_t *position);
+typedef efi_status_t efi_file_get_info(efi_file_protocol_t *this,
+				       efi_guid_t *information_type,
+				       uint64_t *buffer_size,
+				       void *buffer);
+typedef efi_status_t efi_file_set_info(efi_file_protocol_t *this,
+				       efi_guid_t *information_type,
+				       uint64_t *buffer_size,
+				       void *buffer);
+typedef efi_status_t efi_file_flush(efi_file_protocol_t *this);
+
+typedef struct {
+	efi_event_t event;
+	efi_status_t status;
+	uint64_t buffer_size;
+	void *buffer;
+} efi_file_io_open_t;
+
+typedef efi_status_t efi_file_open_ex(efi_file_protocol_t *this,
+				      efi_file_protocol_t **new_handle,
+				      efi_char16_t *file_name,
+				      uint64_t open_mode,
+				      uint64_t attributes,
+				      efi_file_io_open_t *token);
+typedef efi_status_t efi_file_read_ex(efi_file_protocol_t *this,
+				      efi_file_io_open_t *token);
+typedef efi_status_t efi_file_write_ex(efi_file_protocol_t *this,
+				       efi_file_io_open_t *token);
+typedef efi_status_t efi_file_flush_ex(efi_file_protocol_t *this,
+				       efi_file_io_open_t *token);
+
+struct _efi_file_protocol {
+	uint64_t			revision;
+	efi_file_open __efiapi		*open;
+	efi_file_close __efiapi		*close;
+	efi_file_delete __efiapi	*delete;
+	efi_file_read __efiapi		*read;
+	efi_file_write __efiapi		*write;
+	efi_file_get_position __efiapi	*get_position;
+	efi_file_set_position __efiapi	*set_position;
+	efi_file_get_info __efiapi	*get_info;
+	efi_file_set_info __efiapi	*set_info;
+	efi_file_flush __efiapi		*flush;
+	efi_file_open_ex __efiapi	*open_ex;
+	efi_file_read_ex __efiapi	*read_ex;
+	efi_file_write_ex __efiapi	*write_ex;
+	efi_file_flush_ex __efiapi	*flush_ex;
+};
+
+#define EFI_FILE_INFO_ID EFI_GUID(0x9576e92, 0x6d3f, 0x11d2, 0x8e, 0x39, 0x0, 0xa0, 0xc9, 0x69, 0x72, 0x3b )
+
+typedef struct {
+	uint64_t	size;
+	uint64_t	file_size;
+	uint64_t	physical_size;
+	efi_time_t	create_time;
+	efi_time_t	last_access_time;
+	efi_time_t	modification_time;
+	uint64_t	attributes;
+	efi_char16_t	file_name[1];
+} efi_file_info_t;
+
 #define efi_bs_call(func, ...) efi_system_table->boottime->func(__VA_ARGS__)
 #define efi_rs_call(func, ...) efi_system_table->runtime->func(__VA_ARGS__)
 
diff --git a/lib/efi.h b/lib/efi.h
index ce8b74d7..db46d450 100644
--- a/lib/efi.h
+++ b/lib/efi.h
@@ -11,6 +11,17 @@
 #include "linux/efi.h"
 #include <elf.h>
 
+/*
+ * Define a GUID that we can use to to pass environment variables.
+ *
+ * For example, to set the variable var to the value val via the EFI shell:
+ * # setvar env -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"val"
+ */
+#define EFI_VAR_GUID EFI_GUID(0x97ef3e03, 0x7329, 0x4a6a, 0xb9, 0xba, 0x6c, 0x1f, 0xdc, 0xc5, 0xf8, 0x23);
+
+/* Names of environment variables we can handle */
+#define ENV_VARNAME_DTBFILE L"fdtfile"
+
 /*
  * efi_bootinfo_t: stores EFI-related machine info retrieved before exiting EFI
  * boot services, and is then used by setup_efi(). setup_efi() cannot retrieve
@@ -19,6 +30,7 @@
  */
 typedef struct {
 	struct efi_boot_memmap mem_map;
+	const void *fdt;
 } efi_bootinfo_t;
 
 efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle,
diff --git a/lib/efi.c b/lib/efi.c
index f524ec9b..2e127a40 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -173,6 +173,125 @@ static char *efi_convert_cmdline(struct efi_loaded_image_64 *image, int *cmd_lin
 	return (char *)cmdline_addr;
 }
 
+/*
+ * Open the file and read it into a buffer.
+ */
+static void efi_load_image(efi_handle_t handle, struct efi_loaded_image_64 *image, void **data,
+			   int *datasize, efi_char16_t *path_name)
+{
+	uint64_t buffer_size = sizeof(efi_file_info_t);
+	efi_file_info_t *file_info;
+	efi_file_io_interface_t *io_if;
+	efi_file_t *root, *file;
+	efi_status_t status;
+	efi_guid_t file_system_proto_guid = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_GUID;
+	efi_guid_t file_info_guid = EFI_FILE_INFO_ID;
+
+	/* Open the device */
+	status = efi_bs_call(handle_protocol, image->device_handle, &file_system_proto_guid,
+			     (void **)&io_if);
+	if (status != EFI_SUCCESS)
+		return;
+
+	status = io_if->open_volume(io_if, &root);
+	if (status != EFI_SUCCESS)
+		return;
+
+	/* And then open the file */
+	status = root->open(root, &file, path_name, EFI_FILE_MODE_READ, 0);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to open %ls - %lx\n", path_name, status);
+		assert(status == EFI_SUCCESS);
+	}
+
+	/* Find the file size in order to allocate the buffer */
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, buffer_size, (void **)&file_info);
+	if (status != EFI_SUCCESS)
+		return;
+
+	status = file->get_info(file, &file_info_guid, &buffer_size, file_info);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_free_pool(file_info);
+		status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, buffer_size, (void **)&file_info);
+		assert(file_info);
+		status = file->get_info(file, &file_info_guid, &buffer_size, file_info);
+	}
+	assert(status == EFI_SUCCESS);
+
+	buffer_size = file_info->file_size;
+
+	efi_free_pool(file_info);
+
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, buffer_size, (void **)data);
+	assert(*data);
+	/* Perform the actual read */
+	status = file->read(file, &buffer_size, *data);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_free_pool(*data);
+		status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, buffer_size, (void **)data);
+		status = file->read(file, &buffer_size, *data);
+	}
+	assert(status == EFI_SUCCESS);
+
+	*datasize = buffer_size;
+}
+
+static int efi_grow_buffer(efi_status_t *status, void **buffer, uint64_t buffer_size)
+{
+	int try_again;
+
+	if (!*buffer && buffer_size) {
+		*status = EFI_BUFFER_TOO_SMALL;
+	}
+
+	try_again = 0;
+	if (*status == EFI_BUFFER_TOO_SMALL) {
+		if (*buffer)
+			efi_free_pool(*buffer);
+
+		efi_bs_call(allocate_pool, EFI_LOADER_DATA, buffer_size, buffer);
+		if (*buffer) {
+			try_again = 1;
+		} else {
+			*status = EFI_OUT_OF_RESOURCES;
+		}
+	}
+
+	if (!try_again && EFI_ERROR(*status) && *buffer) {
+		efi_free_pool(*buffer);
+		*buffer = NULL;
+	}
+
+	return try_again;
+}
+
+static void* efi_get_var(efi_handle_t handle, struct efi_loaded_image_64 *image, efi_char16_t *var)
+{
+	efi_status_t status = EFI_SUCCESS;
+	void *val = NULL;
+	uint64_t val_size = 100;
+	efi_guid_t efi_var_guid = EFI_VAR_GUID;
+
+	while (efi_grow_buffer(&status, &val, val_size))
+		status = efi_rs_call(get_variable, var, &efi_var_guid, NULL, &val_size, val);
+
+	return val;
+}
+
+static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
+{
+	efi_char16_t var[] = ENV_VARNAME_DTBFILE;
+	efi_char16_t *val;
+	void *fdt = NULL;
+	int fdtsize;
+
+	val = efi_get_var(handle, image, var);
+	if (val)
+		efi_load_image(handle, image, &fdt, &fdtsize, val);
+
+	return fdt;
+}
+
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
@@ -211,6 +330,7 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	}
 	setup_args(cmdline_ptr);
 
+	efi_bootinfo.fdt = efi_get_fdt(handle, image);
 	/* Set up efi_bootinfo */
 	efi_bootinfo.mem_map.map = &map;
 	efi_bootinfo.mem_map.map_size = &map_size;
-- 
2.25.1

