Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD437168EB
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjE3QLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbjE3QLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:11:47 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C3FD1B5
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:11:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 006711BF3;
        Tue, 30 May 2023 09:11:17 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AADB63F663;
        Tue, 30 May 2023 09:10:30 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v6 32/32] arm64: Use the provided fdt when booting through EFI
Date:   Tue, 30 May 2023 17:09:24 +0100
Message-Id: <20230530160924.82158-33-nikos.nikoleris@arm.com>
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

This patch uses the fdt pointer provided through efi_bootinfo_t for
tests that run as EFI apps. As in Linux, we give priority to the fdt.
First, we check if the pointer to the fdt is set and only if it isn't
we fallback to using the ACPI.

In addition, this patches changes the efi run script to generate and
use a fdt unless the user has set the enviroment variable EFI_USE_ACPI
to 'y'.

As a result:

$> ./arm/efi/run ./arm/selftest.efi -append "setup smp=2 mem=256" -smp 2 -m 256

will use an fdt, where as

$> EFI_USE_ACPI=y ./arm/efi/run ./arm/selftest.efi -append "setup smp=2 mem=256" -smp 2 -m 256

will run relying on ACPI.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/efi/run     |  9 +++++++++
 lib/arm/setup.c | 23 +++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index dfff717a..c61da311 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -19,6 +19,9 @@ source scripts/common.bash
 : "${EFI_UEFI:=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd}"
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
+: "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
+
+[ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
 
 if [ ! -f "$EFI_UEFI" ]; then
 	echo "UEFI firmware not found: $EFI_UEFI"
@@ -53,6 +56,12 @@ mkdir -p "$EFI_CASE_DIR"
 
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
 echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
+if [ "$EFI_USE_DTB" = "y" ]; then
+	qemu_args+=(-machine acpi=off)
+	FDT_BASENAME="dtb"
+	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_TEST/$EFI_CASE/$FDT_BASENAME" "${qemu_args[@]}")
+	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_TEST/$EFI_CASE/startup.nsh"
+fi
 echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
 
 EFI_RUN=y $TEST_DIR/run \
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index c4f495a9..0fa21b7e 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -329,6 +329,8 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	struct mem_region r;
 	uintptr_t text = (uintptr_t)&_text, etext = __ALIGN((uintptr_t)&_etext, 4096);
 	uintptr_t data = (uintptr_t)&_data, edata = __ALIGN((uintptr_t)&_edata, 4096);
+	const void *fdt = efi_bootinfo->fdt;
+	int fdt_size, ret;
 
 	/*
 	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
@@ -393,6 +395,17 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		}
 		mem_region_add(&r);
 	}
+	if (fdt) {
+		/* Move the FDT to the base of free memory */
+		fdt_size = fdt_totalsize(fdt);
+		ret = fdt_move(fdt, (void *)free_mem_start, fdt_size);
+		assert(ret == 0);
+		ret = dt_init((void *)free_mem_start);
+		assert(ret == 0);
+		free_mem_start += ALIGN(fdt_size, EFI_PAGE_SIZE);
+		free_mem_pages -= ALIGN(fdt_size, EFI_PAGE_SIZE) >> EFI_PAGE_SHIFT;
+	}
+
 	__phys_end &= PHYS_MASK;
 	asm_mmu_disable();
 
@@ -440,10 +453,12 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
-	status = setup_rsdp(efi_bootinfo);
-	if (status != EFI_SUCCESS) {
-		printf("Cannot find RSDP in EFI system table\n");
-		return status;
+	if (!dt_available()) {
+		status = setup_rsdp(efi_bootinfo);
+		if (status != EFI_SUCCESS) {
+			printf("Cannot find RSDP in EFI system table\n");
+			return status;
+		}
 	}
 
 	psci_set_conduit();
-- 
2.25.1

