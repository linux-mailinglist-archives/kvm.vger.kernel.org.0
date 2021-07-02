Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1137E3BA006
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhGBLvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:51:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:32954 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbhGBLvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:51:21 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C0EA722981;
        Fri,  2 Jul 2021 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SONhayCU7FpAnz5Dmu8koWdtd5Oc311NmWbF8JN42Eo=;
        b=ZEw72e6Jp6Y5jtaO4cl+E+ctPnWQj69ARmuPltB04vWt33rLcDPhnayMbVSlT2g6LgKzVH
        Lk/SZjv4ZHeG9KpS100Bw3MbD0/DiGqv/O08kIKjcGFxZ/sAAKtr1LLkbQLUke3JVaNbzE
        jtGJMUS43gzabV6IMWHG/NZq5FL1nwk=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 5D45F11C84;
        Fri,  2 Jul 2021 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SONhayCU7FpAnz5Dmu8koWdtd5Oc311NmWbF8JN42Eo=;
        b=ZEw72e6Jp6Y5jtaO4cl+E+ctPnWQj69ARmuPltB04vWt33rLcDPhnayMbVSlT2g6LgKzVH
        Lk/SZjv4ZHeG9KpS100Bw3MbD0/DiGqv/O08kIKjcGFxZ/sAAKtr1LLkbQLUke3JVaNbzE
        jtGJMUS43gzabV6IMWHG/NZq5FL1nwk=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id sJ8sFSD93mDDDAAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 02 Jul 2021 11:48:48 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jroedel@suse.de,
        bp@suse.de, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 2/6] x86: Call efi_main from _efi_pe_entry
Date:   Fri,  2 Jul 2021 13:48:16 +0200
Message-Id: <20210702114820.16712-3-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702114820.16712-1-varad.gautam@suse.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EFI calls _efi_pe_entry in long mode with the location of EFI
handle/system table. Add an efi_main() C handler to make it easier
to communicate with EFI for initial setup. efi_main will later,
1. Acquire the efi memmap
2. Call ExitBootServices
3. Perform remaining bootstrapping before calling the testcase main()

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/linux/uefi.h    | 337 ++++++++++++++++++++++++++++++++++++++++++++
 x86/Makefile.common |   2 +-
 x86/cstart64.S      |  10 +-
 x86/efi_main.c      |  11 ++
 4 files changed, 358 insertions(+), 2 deletions(-)
 create mode 100644 lib/linux/uefi.h
 create mode 100644 x86/efi_main.c

diff --git a/lib/linux/uefi.h b/lib/linux/uefi.h
new file mode 100644
index 0000000..eb142a5
--- /dev/null
+++ b/lib/linux/uefi.h
@@ -0,0 +1,337 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Relevant definitions from linux/efi.h. */
+
+#ifndef __LINUX_UEFI_H
+#define __LINUX_UEFI_H
+
+#include "libcflat.h"
+
+#define BITS_PER_LONG	64
+
+#define EFI_SUCCESS		0
+#define EFI_LOAD_ERROR		( 1 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_INVALID_PARAMETER	( 2 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_UNSUPPORTED		( 3 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_BAD_BUFFER_SIZE	( 4 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_BUFFER_TOO_SMALL	( 5 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_NOT_READY		( 6 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_DEVICE_ERROR	( 7 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_WRITE_PROTECTED	( 8 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_OUT_OF_RESOURCES	( 9 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_NOT_FOUND		(14 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_TIMEOUT		(18 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_ABORTED		(21 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_SECURITY_VIOLATION	(26 | (1UL << (BITS_PER_LONG-1)))
+
+typedef unsigned long efi_status_t;
+typedef u8 efi_bool_t;
+typedef u16 efi_char16_t;		/* UNICODE character */
+typedef u64 efi_physical_addr_t;
+typedef void *efi_handle_t;
+#define __efiapi __attribute__((ms_abi))
+
+/*
+ * Generic EFI table header
+ */
+typedef	struct {
+	u64 signature;
+	u32 revision;
+	u32 headersize;
+	u32 crc32;
+	u32 reserved;
+} efi_table_hdr_t;
+
+typedef struct {
+	u16 scan_code;
+	efi_char16_t unicode_char;
+} efi_input_key_t;
+
+typedef void *efi_event_t;
+/* Note that notifications won't work in mixed mode */
+typedef void (__efiapi *efi_event_notify_t)(efi_event_t, void *);
+
+typedef union efi_simple_text_input_protocol efi_simple_text_input_protocol_t;
+typedef union efi_simple_text_output_protocol efi_simple_text_output_protocol_t;
+
+union efi_simple_text_input_protocol {
+	struct {
+		void *reset;
+		efi_status_t (__efiapi *read_keystroke)(efi_simple_text_input_protocol_t *,
+							efi_input_key_t *);
+		efi_event_t wait_for_key;
+	};
+	struct {
+		u32 reset;
+		u32 read_keystroke;
+		u32 wait_for_key;
+	} mixed_mode;
+};
+
+union efi_simple_text_output_protocol {
+	struct {
+		void *reset;
+		efi_status_t (__efiapi *output_string)(efi_simple_text_output_protocol_t *,
+						       efi_char16_t *);
+		void *test_string;
+	};
+	struct {
+		u32 reset;
+		u32 output_string;
+		u32 test_string;
+	} mixed_mode;
+};
+
+typedef enum {
+	EfiTimerCancel,
+	EfiTimerPeriodic,
+	EfiTimerRelative
+} EFI_TIMER_DELAY;
+
+struct efi_generic_dev_path {
+	u8				type;
+	u8				sub_type;
+	u16				length;
+} __packed;
+typedef struct efi_generic_dev_path efi_device_path_protocol_t;
+
+union efi_boot_services {
+	struct {
+		efi_table_hdr_t hdr;
+		void *raise_tpl;
+		void *restore_tpl;
+		efi_status_t (__efiapi *allocate_pages)(int, int, unsigned long,
+							efi_physical_addr_t *);
+		efi_status_t (__efiapi *free_pages)(efi_physical_addr_t,
+						    unsigned long);
+		efi_status_t (__efiapi *get_memory_map)(unsigned long *, void *,
+							unsigned long *,
+							unsigned long *, u32 *);
+		efi_status_t (__efiapi *allocate_pool)(int, unsigned long,
+						       void **);
+		efi_status_t (__efiapi *free_pool)(void *);
+		efi_status_t (__efiapi *create_event)(u32, unsigned long,
+						      efi_event_notify_t, void *,
+						      void *);
+		efi_status_t (__efiapi *set_timer)(efi_event_t,
+						  EFI_TIMER_DELAY, u64);
+		efi_status_t (__efiapi *wait_for_event)(unsigned long,
+							void *,
+							unsigned long *);
+		void *signal_event;
+		efi_status_t (__efiapi *close_event)(void);
+		void *check_event;
+		void *install_protocol_interface;
+		void *reinstall_protocol_interface;
+		void *uninstall_protocol_interface;
+		efi_status_t (__efiapi *handle_protocol)(efi_handle_t,
+							 void *, void **);
+		void *__reserved;
+		void *register_protocol_notify;
+		efi_status_t (__efiapi *locate_handle)(int, void *,
+						       void *, unsigned long *,
+						       efi_handle_t *);
+		efi_status_t (__efiapi *locate_device_path)(void *,
+							    efi_device_path_protocol_t **,
+							    efi_handle_t *);
+		efi_status_t (__efiapi *install_configuration_table)(void *,
+								     void *);
+		void *load_image;
+		void *start_image;
+		efi_status_t (__efiapi *exit)(efi_handle_t,
+							 efi_status_t,
+							 unsigned long,
+							 efi_char16_t *);
+		void *unload_image;
+		efi_status_t (__efiapi *exit_boot_services)(efi_handle_t,
+							    unsigned long);
+		void *get_next_monotonic_count;
+		efi_status_t (__efiapi *stall)(unsigned long);
+		void *set_watchdog_timer;
+		void *connect_controller;
+		efi_status_t (__efiapi *disconnect_controller)(efi_handle_t,
+							       efi_handle_t,
+							       efi_handle_t);
+		void *open_protocol;
+		void *close_protocol;
+		void *open_protocol_information;
+		void *protocols_per_handle;
+		void *locate_handle_buffer;
+		efi_status_t (__efiapi *locate_protocol)(void *, void *,
+							 void **);
+		void *install_multiple_protocol_interfaces;
+		void *uninstall_multiple_protocol_interfaces;
+		void *calculate_crc32;
+		void *copy_mem;
+		void *set_mem;
+		void *create_event_ex;
+	};
+	struct {
+		efi_table_hdr_t hdr;
+		u32 raise_tpl;
+		u32 restore_tpl;
+		u32 allocate_pages;
+		u32 free_pages;
+		u32 get_memory_map;
+		u32 allocate_pool;
+		u32 free_pool;
+		u32 create_event;
+		u32 set_timer;
+		u32 wait_for_event;
+		u32 signal_event;
+		u32 close_event;
+		u32 check_event;
+		u32 install_protocol_interface;
+		u32 reinstall_protocol_interface;
+		u32 uninstall_protocol_interface;
+		u32 handle_protocol;
+		u32 __reserved;
+		u32 register_protocol_notify;
+		u32 locate_handle;
+		u32 locate_device_path;
+		u32 install_configuration_table;
+		u32 load_image;
+		u32 start_image;
+		u32 exit;
+		u32 unload_image;
+		u32 exit_boot_services;
+		u32 get_next_monotonic_count;
+		u32 stall;
+		u32 set_watchdog_timer;
+		u32 connect_controller;
+		u32 disconnect_controller;
+		u32 open_protocol;
+		u32 close_protocol;
+		u32 open_protocol_information;
+		u32 protocols_per_handle;
+		u32 locate_handle_buffer;
+		u32 locate_protocol;
+		u32 install_multiple_protocol_interfaces;
+		u32 uninstall_multiple_protocol_interfaces;
+		u32 calculate_crc32;
+		u32 copy_mem;
+		u32 set_mem;
+		u32 create_event_ex;
+	} mixed_mode;
+};
+
+typedef union efi_boot_services efi_boot_services_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
+	u64 fw_vendor;	/* physical addr of CHAR16 vendor string */
+	u32 fw_revision;
+	u32 __pad1;
+	u64 con_in_handle;
+	u64 con_in;
+	u64 con_out_handle;
+	u64 con_out;
+	u64 stderr_handle;
+	u64 stderr;
+	u64 runtime;
+	u64 boottime;
+	u32 nr_tables;
+	u32 __pad2;
+	u64 tables;
+} efi_system_table_64_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
+	u32 fw_vendor;	/* physical addr of CHAR16 vendor string */
+	u32 fw_revision;
+	u32 con_in_handle;
+	u32 con_in;
+	u32 con_out_handle;
+	u32 con_out;
+	u32 stderr_handle;
+	u32 stderr;
+	u32 runtime;
+	u32 boottime;
+	u32 nr_tables;
+	u32 tables;
+} efi_system_table_32_t;
+
+typedef union {
+	struct {
+		efi_table_hdr_t hdr;
+		unsigned long fw_vendor;	/* physical addr of CHAR16 vendor string */
+		u32 fw_revision;
+		unsigned long con_in_handle;
+		efi_simple_text_input_protocol_t *con_in;
+		unsigned long con_out_handle;
+		efi_simple_text_output_protocol_t *con_out;
+		unsigned long stderr_handle;
+		unsigned long stderr;
+		void *runtime;
+		efi_boot_services_t *boottime;
+		unsigned long nr_tables;
+		unsigned long tables;
+	};
+	efi_system_table_32_t mixed_mode;
+} efi_system_table_t;
+
+/*
+ * Memory map descriptor:
+ */
+
+/* Memory types: */
+#define EFI_RESERVED_TYPE		 0
+#define EFI_LOADER_CODE			 1
+#define EFI_LOADER_DATA			 2
+#define EFI_BOOT_SERVICES_CODE		 3
+#define EFI_BOOT_SERVICES_DATA		 4
+#define EFI_RUNTIME_SERVICES_CODE	 5
+#define EFI_RUNTIME_SERVICES_DATA	 6
+#define EFI_CONVENTIONAL_MEMORY		 7
+#define EFI_UNUSABLE_MEMORY		 8
+#define EFI_ACPI_RECLAIM_MEMORY		 9
+#define EFI_ACPI_MEMORY_NVS		10
+#define EFI_MEMORY_MAPPED_IO		11
+#define EFI_MEMORY_MAPPED_IO_PORT_SPACE	12
+#define EFI_PAL_CODE			13
+#define EFI_PERSISTENT_MEMORY		14
+#define EFI_MAX_MEMORY_TYPE		15
+
+/* Attribute values: */
+#define EFI_MEMORY_UC		((u64)0x0000000000000001ULL)	/* uncached */
+#define EFI_MEMORY_WC		((u64)0x0000000000000002ULL)	/* write-coalescing */
+#define EFI_MEMORY_WT		((u64)0x0000000000000004ULL)	/* write-through */
+#define EFI_MEMORY_WB		((u64)0x0000000000000008ULL)	/* write-back */
+#define EFI_MEMORY_UCE		((u64)0x0000000000000010ULL)	/* uncached, exported */
+#define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
+#define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
+#define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
+#define EFI_MEMORY_NV		((u64)0x0000000000008000ULL)	/* non-volatile */
+#define EFI_MEMORY_MORE_RELIABLE \
+				((u64)0x0000000000010000ULL)	/* higher reliability */
+#define EFI_MEMORY_RO		((u64)0x0000000000020000ULL)	/* read-only */
+#define EFI_MEMORY_SP		((u64)0x0000000000040000ULL)	/* soft reserved */
+#define EFI_MEMORY_CPU_CRYPTO	((u64)0x0000000000080000ULL)	/* supports encryption */
+#define EFI_MEMORY_RUNTIME	((u64)0x8000000000000000ULL)	/* range requires runtime mapping */
+#define EFI_MEMORY_DESCRIPTOR_VERSION	1
+
+#define EFI_PAGE_SHIFT		12
+#define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
+#define EFI_PAGES_MAX		(U64_MAX >> EFI_PAGE_SHIFT)
+
+typedef struct {
+	u32 type;
+	u32 pad;
+	u64 phys_addr;
+	u64 virt_addr;
+	u64 num_pages;
+	u64 attribute;
+} efi_memory_desc_t;
+
+struct efi_boot_memmap {
+	efi_memory_desc_t	**map;
+	unsigned long		*map_size;
+	unsigned long		*desc_size;
+	u32			*desc_ver;
+	unsigned long		*key_ptr;
+	unsigned long		*buff_size;
+};
+
+#define efi_bs_call(func, ...)						\
+	efi_system_table->boottime->func(__VA_ARGS__)
+
+#endif /* __LINUX_UEFI_H */
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 837a8a5..98d8de9 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -50,7 +50,7 @@ FLATLIBS = lib/libcflat.a
 	$(OBJCOPY) -O elf32-i386 $^ $@
 	@chmod a-x $@
 
-%.so: %.o $(FLATLIBS) $(cstart.o)
+%.so: %.o $(FLATLIBS) $(TEST_DIR)/efi_main.o $(cstart.o)
 	$(LD) -shared -nostdlib -znocombreloc -Bsymbolic -T $(SRCDIR)/x86/efi.lds $^ \
 		-o $@ $(FLATLIBS)
 	@chmod a-x $@
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 404fcac..98e7848 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -267,7 +267,15 @@ ap_start64:
 #ifdef CONFIG_EFI
 .globl _efi_pe_entry
 _efi_pe_entry:
-	ret
+	# EFI image loader calls this with rcx=efi_handle,
+	# rdx=efi_system_table. Pass these to efi_main.
+	mov     %rcx, %rdi
+	mov     %rdx, %rsi
+
+	pushq   %rdi
+	pushq   %rsi
+
+	call efi_main
 #endif
 
 start64:
diff --git a/x86/efi_main.c b/x86/efi_main.c
new file mode 100644
index 0000000..00e7086
--- /dev/null
+++ b/x86/efi_main.c
@@ -0,0 +1,11 @@
+#include <linux/uefi.h>
+
+unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
+efi_system_table_t *efi_system_table = NULL;
+
+unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
+{
+	efi_system_table = sys_tab;
+
+	return 0;
+}
-- 
2.30.2

