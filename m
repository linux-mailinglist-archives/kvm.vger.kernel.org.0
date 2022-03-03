Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3721E4CB7C6
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 08:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiCCH24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 02:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiCCH2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 02:28:51 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457E614866B
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 23:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646292482; x=1677828482;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=onaminJGlBSKcooFIkqPzR6gZ0Rx0iv8d2UEQxqj7R8=;
  b=dsBdlB0kU+zOWGTqa7BOtlJi+HiNahu54V/mElAr+IFbiGiL194zIVyc
   902Dbg3t0uUkPZfaIUgq5xcDv+MsF6eoYRu0CzMMGYFUlM29qMol1hC3g
   /ZqF4jfU7bHgJauCzPEf/zFdMJBWLBbHOU66yR1wzY4MyV8vHqTT7nr8q
   ropFaPQ1cru9P8QP+YOubwUwqqa4yTSSjYeqtt3y5c86YxlHTosNzwG4n
   H5p3S4xHZ4f1mTV2/v16Ac9wWwRpD9TGG3HffyuG0LG0qE9W7D9IT+tqV
   DVPq2b9pV8vut4QPbSBP7xDboYwpw9mu6RV3bbQBbQAofS6mU94nIaHC4
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251177046"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251177046"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:28:01 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551631848"
Received: from duan-server-s2600bt.bj.intel.com ([10.240.192.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 23:27:59 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yu.c.zhang@intel.com,
        zixuanwang@google.com, marcorr@google.com, jun.nakajima@intel.com,
        erdemaktas@google.com
Subject: [kvm-unit-tests RFC PATCH 16/17] x86 UEFI: Add support for parameter passing
Date:   Thu,  3 Mar 2022 15:19:06 +0800
Message-Id: <20220303071907.650203-17-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303071907.650203-1-zhenzhong.duan@intel.com>
References: <20220303071907.650203-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UEFI supports command line in unicode format, translate it into ascii
format and pass to main() as parameters. Only support general
characters with ascii < 0x80.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
---
 lib/argv.c      |  2 +-
 lib/argv.h      |  1 +
 lib/efi.c       | 73 +++++++++++++++++++++++++++++++++++++++++++++++++
 lib/linux/efi.h | 18 ++++++++++++
 4 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/lib/argv.c b/lib/argv.c
index 0312d74011d3..4d5c318a4bc4 100644
--- a/lib/argv.c
+++ b/lib/argv.c
@@ -44,7 +44,7 @@ void __setup_args(void)
 	__argc = argv - __argv;
 }
 
-static void setup_args(const char *args)
+void setup_args(const char *args)
 {
 	if (!args)
 		return;
diff --git a/lib/argv.h b/lib/argv.h
index 1fd746dc2177..0fa7772549da 100644
--- a/lib/argv.h
+++ b/lib/argv.h
@@ -9,6 +9,7 @@
 #define _ARGV_H_
 
 extern void __setup_args(void);
+extern void setup_args(const char *args);
 extern void setup_args_progname(const char *args);
 extern void setup_env(char *env, int size);
 extern void add_setup_arg(const char *arg);
diff --git a/lib/efi.c b/lib/efi.c
index 64cc9789274e..69dbfa1d1f24 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -10,6 +10,7 @@
 #include "efi.h"
 #include <libcflat.h>
 #include <asm/setup.h>
+#include <argv.h>
 
 /* From lib/argv.c */
 extern int __argc, __envc;
@@ -96,6 +97,72 @@ static void efi_exit(efi_status_t code)
 	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, code, 0, NULL);
 }
 
+/*
+ * Convert the unicode UEFI command line to ASCII, only support ascii < 0x80.
+ * Size of memory allocated return in *cmd_line_len.
+ */
+static efi_status_t efi_convert_cmdline(efi_loaded_image_t *image,
+					char **cmd_line_ptr, int *cmd_line_len)
+{
+	char *cmdline_addr = 0;
+	int options_chars = image->load_options_size;
+	const u16 *options = image->load_options;
+	int options_bytes = 0;
+	efi_status_t status;
+
+	if (!options || !options_chars)
+		return EFI_NOT_FOUND;
+
+	options_chars /= sizeof(*options);
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, options_chars + 1,
+			(void **)&cmdline_addr);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	while (options_bytes < options_chars) {
+		if (options[options_bytes] >= 0x80)
+			return EFI_UNSUPPORTED;
+
+		cmdline_addr[options_bytes] = (char)options[options_bytes];
+		options_bytes++;
+	}
+
+	/*
+	 * UEFI command line should already includes NUL termination,
+	 * just in case.
+	 */
+	cmdline_addr[options_bytes] = '\0';
+
+	*cmd_line_len = options_bytes;
+	*cmd_line_ptr = (char *)cmdline_addr;
+	return EFI_SUCCESS;
+}
+
+static efi_status_t setup_efi_args(efi_handle_t handle)
+{
+	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
+	efi_loaded_image_t *image = NULL;
+	char *cmdline_ptr;
+	int options_size = 0;
+	efi_status_t status;
+
+	status = efi_bs_call(handle_protocol, handle, &proto, (void **)&image);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
+		return status;
+	}
+
+	status = efi_convert_cmdline(image, &cmdline_ptr, &options_size);
+
+	if (status != EFI_SUCCESS && status != EFI_NOT_FOUND)
+		return status;
+
+	if (status == EFI_SUCCESS)
+		setup_args(cmdline_ptr);
+
+	return EFI_SUCCESS;
+}
+
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
@@ -104,6 +171,12 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 
 	efi_system_table = sys_tab;
 
+	status = setup_efi_args(handle);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to get efi parameters\n");
+		goto efi_main_error;
+	}
+
 	/* Memory map struct values */
 	efi_memory_desc_t *map = NULL;
 	unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
diff --git a/lib/linux/efi.h b/lib/linux/efi.h
index df9fa7974d87..8b9fa06f84ba 100644
--- a/lib/linux/efi.h
+++ b/lib/linux/efi.h
@@ -59,6 +59,7 @@ typedef guid_t efi_guid_t;
 	(c) & 0xff, ((c) >> 8) & 0xff, d } }
 
 #define ACPI_TABLE_GUID EFI_GUID(0xeb9d2d30, 0x2d88, 0x11d3, 0x9a, 0x16, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
+#define LOADED_IMAGE_PROTOCOL_GUID EFI_GUID(0x5b1b31a1, 0x9562, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
 
 typedef struct {
 	efi_guid_t guid;
@@ -417,6 +418,23 @@ struct efi_boot_memmap {
 	unsigned long           *buff_size;
 };
 
+#define __aligned_u64 u64 __attribute__((aligned(8)))
+typedef struct {
+	u32			revision;
+	efi_handle_t		parent_handle;
+	efi_system_table_t	*system_table;
+	efi_handle_t		device_handle;
+	void			*file_path;
+	void			*reserved;
+	u32			load_options_size;
+	void			*load_options;
+	void			*image_base;
+	__aligned_u64		image_size;
+	unsigned int		image_code_type;
+	unsigned int		image_data_type;
+	efi_status_t		(__efiapi *unload)(efi_handle_t image_handle);
+} efi_loaded_image_t;
+
 /*
  * efi_memdesc_ptr - get the n-th EFI memmap descriptor
  * @map: the start of efi memmap
-- 
2.25.1

