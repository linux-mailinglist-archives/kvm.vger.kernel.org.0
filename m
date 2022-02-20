Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7E44BD250
	for <lists+kvm@lfdr.de>; Sun, 20 Feb 2022 23:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245187AbiBTWnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 17:43:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245184AbiBTWnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 17:43:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC72E089
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 14:42:41 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so1212956pjb.0
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 14:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HjAl366zu24rAX+PE059gK9rclNP/mCI9CQZBpcrWe4=;
        b=pTaPhob+fU7TT4b1LBBZixlKSca++H2XCdjaHuEte5tvw8SVM5nR1bX6GURMthwp1y
         CjIIfjiDbhXT0Qb9Ntai0PFBaKmNYOuzOI1gtDLCnclerl3hwtoXYH8rGcQoqdlgks9T
         hAVIn3sIozOLa25EOJDVe3oByOzbnPMMaB8QnN1OO1b+eIjVcIBtvhNr4jbDPK8w1Yh/
         VAFVumSKqAsTGDIiGOXMIsbcoN0cBnZgz3lm0ebwndlHclLkAPsOJz+wT1iEO/lB+Rk6
         jxW8JrHSfK6dfZvtFHSHzkrUM+EL5zWJMOonrgGo100dYx9GgWDJU1zC1OpBJWTIzsZF
         CiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HjAl366zu24rAX+PE059gK9rclNP/mCI9CQZBpcrWe4=;
        b=fihbr9OfEIb8dQpTrWSutr4fUDJJDxLiN/PvNXs5S8bp7/lpFerG3V8lE8lyfseg2x
         obc7v5sQIzt6FXXVpct6NhpQAANFW+aevMGM2D903Aww40tYIyeFc26aau4cTUASRr1u
         yz1Q48Ddw9YwykZq8J+Tnui59IFC/oAyaMuhhrEfpuOuwU6gG2WY0d3pQ/RxjKUg3d0F
         JkCO/gXI3dPXdF2b4cfWTxsWMdONpuniMQeDwlNTMFNzAha3vcRHzlEs149xAewg16JF
         bSbV578vg+/K80dp1jIK/PyYhRb/YLgREf7NnBXJDJe36dRGWgY8+J6lDxAv7emGy6cc
         PPvw==
X-Gm-Message-State: AOAM5321U3nYhODIAndTeYL3OaXVPJydcdy8Zh/t3CA3pyy8xefsM9Xa
        PhV3JrDJx/X6pGm2NvZxV4cB5njHFZk=
X-Google-Smtp-Source: ABdhPJzfBJk2AxN+WwuShI3A45bMJbjp5/QiEWAhC4/toJsy3cD1SbmD545iK5FPFsZWCPMBmqsq7g==
X-Received: by 2002:a17:902:f54a:b0:14f:47:a452 with SMTP id h10-20020a170902f54a00b0014f0047a452mr16502512plf.87.1645396960928;
        Sun, 20 Feb 2022 14:42:40 -0800 (PST)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id gk17sm605629pjb.15.2022.02.20.14.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 14:42:40 -0800 (PST)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v1 3/3] x86 UEFI: read args from file
Date:   Sun, 20 Feb 2022 14:42:34 -0800
Message-Id: <20220220224234.422499-4-zxwang42@gmail.com>
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

This commit enables kvm-unit-tests to get args from the host through
UEFI.

Previously, when compiled to run under UEFI, kvm-unit-tests could not
get args from the host through QEMU's '-append' argument. This is
because kvm-unit-tests (under UEFI) does not rely on QEMU's '-kernel'
argument, while without which, QEMU rejects the '-append' argument.

This commit enables the host to pass the args through a file. This
process is similar to the '-initrd' support introduced in the previous
commit.

Signed-off-by: Zixuan Wang <zxwang42@gmail.com>
---
 lib/efi.c   | 24 ++++++++++++++++++++++++
 x86/efi/run | 12 +++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/lib/efi.c b/lib/efi.c
index 4ddc3a4..dfde788 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -14,6 +14,7 @@
 
 /* From lib/argv.c */
 extern int __argc, __envc;
+extern const char *__args;
 extern char *__argv[100];
 extern char *__environ[200];
 
@@ -212,6 +213,28 @@ efi_set_up_envs_error:
 	return EFI_ABORTED;
 }
 
+static efi_status_t efi_set_up_args(efi_file_protocol_t *volume)
+{
+	efi_char16_t file_name[] = L"ARGS.TXT";
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
+	__args = file_data;
+	__setup_args();
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
@@ -234,6 +257,7 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 	}
 
 	efi_set_up_envs(volume);
+	efi_set_up_args(volume);
 
 	/* Set up efi_bootinfo */
 	efi_bootinfo.mem_map.map = &map;
diff --git a/x86/efi/run b/x86/efi/run
index f4a5930..e02a6e1 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -44,9 +44,10 @@ fi
 mkdir -p "$EFI_CASE_DIR"
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 
-# Capture -initrd
+# Capture -initrd and -append
 efi_qemu_args=""
 efi_qemu_initrd=""
+efi_qemu_append=""
 while [[ -n "$1" ]]; do
 	case "$1" in
 		--initrd|-initrd)
@@ -54,6 +55,11 @@ while [[ -n "$1" ]]; do
 			efi_qemu_initrd="$1"
 			shift 1
 		;;
+		--append|-append)
+			shift 1
+			efi_qemu_append="$1"
+			shift 1
+		;;
 		*)
 			efi_qemu_args+=" $1"
 			shift 1
@@ -67,6 +73,10 @@ KVM_UNIT_TESTS_EFI_ENV="$EFI_TEST/$EFI_CASE/ENVS.TXT"
 mv "$KVM_UNIT_TESTS_ENV" "$KVM_UNIT_TESTS_EFI_ENV"
 [[ -f "$efi_qemu_initrd" ]] && cat "$efi_qemu_initrd" >> "$KVM_UNIT_TESTS_EFI_ENV"
 
+# Create ARGS file
+KVM_UNIT_TESTS_EFI_ARG="$EFI_TEST/$EFI_CASE/ARGS.TXT"
+echo -n "$efi_qemu_append" > "$KVM_UNIT_TESTS_EFI_ARG"
+
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
 # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
 # memory region is ~42MiB. Although this is sufficient for many test cases to
-- 
2.35.1

