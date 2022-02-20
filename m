Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C141B4BD253
	for <lists+kvm@lfdr.de>; Sun, 20 Feb 2022 23:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245183AbiBTWnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 17:43:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243751AbiBTWnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 17:43:02 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644BD11C03
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 14:42:40 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id d16so12698380pgd.9
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 14:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mcKHBB1zPuBm0PoJry2FdYYyxTjDZhYA3Qp7gMq+zSM=;
        b=T317m3U6f/FfkrgT6zn4pK8Clfw0Dm5kW577Ez7jY+Fdtt5yG4OpRFvSkdkZ8PUc6W
         MTFv0qkoGL/pLxf/SrO5XllYPcPMtWT1SjRyHDL7eLfayRF0slEjHBZVVoQQdRdQo+0z
         SvbR8akTDaw6gFIks9KPO+rOrItD6F2HRLe/gJnnkLjrIV+aP+3cosJjo/Xay3KA0dwQ
         5e9KKdILQyCVU7RwO2LSnR2KrmmMUuZuaCDf7Rw3ddWqlX1NPH0jKRoZ+xsW8LD0u97p
         03rlwprbrmEZHBmrb3kNw3wuGoGdvAEm9FE6xOkIYBqJPdas5+K2uXxTZLzn6YSnBlap
         7YPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mcKHBB1zPuBm0PoJry2FdYYyxTjDZhYA3Qp7gMq+zSM=;
        b=IWu/+wEfWe+6IJ9Yq58EaUk1kUF1/YS0Uu7ufa8rFgqkmvX2TzHo+guhtuR+Y/GB/t
         XwqOugAJf8uGvWkVuFuTQcW0nHH8B3e2fJceTHQKRlHIuRCdRtd6qcS3AAey7OodtRSL
         H9tXniW2C4vCSJrwkChwc/Bp0L1kx8EqEeY97Vw9MJDKvnGl1i2znT/9E3OcrBEHZQHw
         EQouel0G0vxW6V5/RZWLEO3oHUp+JkyZt+a5c9SWARSJOitrQt/xXm5xBIBtfb2rIb5K
         akhblYU/f/K9gxvlvokxtF8a0gkrcbKkjspSv4ehZL5okFZfMeJ6CKvd2j6t128fQ1Q0
         /1cA==
X-Gm-Message-State: AOAM531V7/b3CculgZOAog09i3hKTU0iIzby8JopW8KOhMgKbSFuFcr/
        bNC124I7MbFN1ZyHuuZ40+Z4fehepJc=
X-Google-Smtp-Source: ABdhPJz9LMFf9el9bmYKIzbUiu+vHobXdAD9cadVC6TGx5uX/noKEWvP7NN3Bab4zUO7Co2QLfT1Gg==
X-Received: by 2002:a05:6a00:244d:b0:4e0:1f65:d5da with SMTP id d13-20020a056a00244d00b004e01f65d5damr17258965pfj.6.1645396959480;
        Sun, 20 Feb 2022 14:42:39 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id gk17sm605629pjb.15.2022.02.20.14.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 14:42:38 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 2/3] x86 UEFI: read envs from file
Date:   Sun, 20 Feb 2022 14:42:33 -0800
Message-Id: <20220220224234.422499-3-zxwang42@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220224234.422499-1-zxwang42@gmail.com>
References: <20220220224234.422499-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zxwang42@gmail.com>

This commit enables kvm-unit-tests to get envs from the host through
UEFI.

Previously, when kvm-unit-tests runs with Multiboot, it gets a kernel
binary through QEMU's '-kernel' argument and envs through the '-initrd'
argument.

But under UEFI, kvm-unit-tests loads an EFI binary from a disk image
instead of QEMU's '-kernel' argument. In this case, QEMU rejects the
'-initrd' argument without the '-kernel' argument being used, which
makes kvm-unit-tests unable to get an initrd through this argument.

This commit enables the host to pass the initrd through a file:
  1. The host runner script 'x86/efi/run' captures the '-initrd'
     argument and suppress it from QEMU arguments, so QEMU will not
     report the error
  2. The runner script reads the default initrd and the user-specified
     initrd to generate an 'ENVS.TXT' file for each EFI test case
  3. The kvm-unit-tests EFI set up process reads this 'ENVS.TXT' from
     the disk image and pass it to 'setup_env()'

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 lib/efi.c   | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 x86/efi/run |  26 ++++++++++-
 2 files changed, 151 insertions(+), 1 deletion(-)

diff --git a/lib/efi.c b/lib/efi.c
index 64cc978..4ddc3a4 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -8,6 +8,7 @@
  */
 
 #include "efi.h"
+#include "argv.h"
 #include <libcflat.h>
 #include <asm/setup.h>
 
@@ -96,6 +97,121 @@ static void efi_exit(efi_status_t code)
 	efi_rs_call(reset_system, EFI_RESET_SHUTDOWN, code, 0, NULL);
 }
 
+static efi_status_t efi_get_volume(efi_handle_t handle,
+				   efi_file_protocol_t **volume)
+{
+	efi_guid_t loaded_image_protocol = LOADED_IMAGE_PROTOCOL_GUID;
+	efi_guid_t file_system_protocol = EFI_FILE_SYSTEM_GUID;
+	efi_loaded_image_t *loaded_image = NULL;
+	efi_simple_file_system_protocol_t *io;
+	efi_status_t status;
+
+	status = efi_bs_call(handle_protocol, handle, &loaded_image_protocol,
+			     (void **)&loaded_image);
+	if (status != EFI_SUCCESS) {
+		printf("ERROR: failed to handle loaded image");
+		goto efi_get_volume_error;
+	}
+
+	status = efi_bs_call(handle_protocol, loaded_image->device_handle,
+			     &file_system_protocol, (void **)&io);
+	if (status != EFI_SUCCESS) {
+		printf("ERROR: failed to handle file system protocol");
+		goto efi_get_volume_error;
+	}
+
+	status = io->open_volume(io, volume);
+	if (status != EFI_SUCCESS) {
+		printf("ERROR: failed to open volume");
+		goto efi_get_volume_error;
+	}
+
+	return EFI_SUCCESS;
+
+efi_get_volume_error:
+	printf(" error: 0x%lx\n", status);
+	return EFI_ABORTED;
+}
+
+static efi_status_t efi_read_file(efi_file_protocol_t *volume,
+				  efi_char16_t *file_name,
+				  unsigned long *file_size, char **file_data)
+{
+	efi_guid_t file_info_guid = EFI_FILE_INFO_ID;
+	efi_file_protocol_t *file_handle = NULL;
+	struct finfo file_info;
+	unsigned long file_info_size;
+	efi_status_t status;
+
+	status = volume->open(volume, &file_handle, file_name,
+			      EFI_FILE_MODE_READ, 0);
+	if (status != EFI_SUCCESS) {
+		printf("ERROR: failed to open file");
+		goto efi_read_file_error;
+	}
+
+	file_info_size = sizeof(file_info);
+	status = file_handle->get_info(file_handle, &file_info_guid,
+				       &file_info_size, &file_info);
+	if (status != EFI_SUCCESS) {
+		printf("ERROR: failed to get file info");
+		goto efi_read_file_error;
+	}
+
+	*file_size = file_info.info.file_size;
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, *file_size + 1,
+			     (void **)file_data);
+	if (status != EFI_SUCCESS) {
+		printf("ERROR: failed allocate buffer");
+		goto efi_read_file_error;
+	}
+
+	status = file_handle->read(file_handle, file_size, *file_data);
+	if (status != EFI_SUCCESS) {
+		printf("ERROR: failed to read file data");
+		goto efi_read_file_error;
+	}
+
+	status = file_handle->close(file_handle);
+	if (status != EFI_SUCCESS) {
+		printf("ERROR: failed to close file");
+		goto efi_read_file_error;
+	}
+
+	(*file_data)[*file_size] = '\0';
+
+	return EFI_SUCCESS;
+
+efi_read_file_error:
+	/*
+	 * TODO: Current printf does not support wide char (2nd byte of the each
+	 * wide char is always a '\0'), thus only the 1st character is printed.
+	 */
+	printf(" file: %ls, error: 0x%lx\n", file_name, status);
+	return EFI_ABORTED;
+}
+
+static efi_status_t efi_set_up_envs(efi_file_protocol_t *volume)
+{
+	efi_char16_t file_name[] = L"ENVS.TXT";
+	unsigned long file_size;
+	char *file_data = NULL;
+	efi_status_t status;
+
+	status = efi_read_file(volume, file_name, &file_size, &file_data);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to read file\n");
+		goto efi_set_up_envs_error;
+	}
+
+	setup_env(file_data, (int)file_size);
+
+	return EFI_SUCCESS;
+
+efi_set_up_envs_error:
+	return EFI_ABORTED;
+}
+
 efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	int ret;
@@ -103,12 +219,22 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	efi_bootinfo_t efi_bootinfo;
 
 	efi_system_table = sys_tab;
+	efi_file_protocol_t *volume = NULL;
 
 	/* Memory map struct values */
 	efi_memory_desc_t *map = NULL;
 	unsigned long map_size = 0, desc_size = 0, key = 0, buff_size = 0;
 	u32 desc_ver;
 
+	/* Open env and args files */
+	status = efi_get_volume(handle, &volume);
+	if (status != EFI_SUCCESS) {
+		printf("Failed to get volume\n");
+		goto efi_main_error;
+	}
+
+	efi_set_up_envs(volume);
+
 	/* Set up efi_bootinfo */
 	efi_bootinfo.mem_map.map = &map;
 	efi_bootinfo.mem_map.map_size = &map_size;
diff --git a/x86/efi/run b/x86/efi/run
index ac368a5..f4a5930 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -12,6 +12,7 @@ if [ ! -f config.mak ]; then
 	exit 2
 fi
 source config.mak
+source scripts/arch-run.bash
 
 : "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
 : "${EFI_UEFI:=/usr/share/ovmf/OVMF.fd}"
@@ -43,6 +44,29 @@ fi
 mkdir -p "$EFI_CASE_DIR"
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 
+# Capture -initrd
+efi_qemu_args=""
+efi_qemu_initrd=""
+while [[ -n "$1" ]]; do
+	case "$1" in
+		--initrd|-initrd)
+			shift 1
+			efi_qemu_initrd="$1"
+			shift 1
+		;;
+		*)
+			efi_qemu_args+=" $1"
+			shift 1
+		;;
+	esac
+done
+
+# Create ENVS file
+initrd_create
+KVM_UNIT_TESTS_EFI_ENV="$EFI_TEST/$EFI_CASE/ENVS.TXT"
+mv "$KVM_UNIT_TESTS_ENV" "$KVM_UNIT_TESTS_EFI_ENV"
+[[ -f "$efi_qemu_initrd" ]] && cat "$efi_qemu_initrd" >> "$KVM_UNIT_TESTS_EFI_ENV"
+
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
 # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
 # memory region is ~42MiB. Although this is sufficient for many test cases to
@@ -60,5 +84,5 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 	-net none \
 	-nographic \
 	-m 256 \
-	"$@" \
+	${efi_qemu_args} \
 	-smp "$EFI_SMP"
-- 
2.35.1

