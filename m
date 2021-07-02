Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1963BA008
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhGBLvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:51:23 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44738 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbhGBLvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:51:22 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A1A7820559;
        Fri,  2 Jul 2021 11:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eC9zp1q36Ee/jP4TtRNuvYFMVVhl5Tzhsv3C+E9+clA=;
        b=N1vYjPTkNMmBGoewtUUjTnRF7u9M5swnA/bBnNvNo3Oh8+Pz3QSTdVEd5kGkFfJOfLZdge
        foWtDCeJ3MvSQfcTp0LHyEy2JAB/5/L3MSBzVSAEp/zfYtd0B/KrpmkSIktTGIeSAISxHi
        fZslf93tVQdGdu+llip7XG0j8k8llck=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 41F0311C84;
        Fri,  2 Jul 2021 11:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eC9zp1q36Ee/jP4TtRNuvYFMVVhl5Tzhsv3C+E9+clA=;
        b=N1vYjPTkNMmBGoewtUUjTnRF7u9M5swnA/bBnNvNo3Oh8+Pz3QSTdVEd5kGkFfJOfLZdge
        foWtDCeJ3MvSQfcTp0LHyEy2JAB/5/L3MSBzVSAEp/zfYtd0B/KrpmkSIktTGIeSAISxHi
        fZslf93tVQdGdu+llip7XG0j8k8llck=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 0PlUDiH93mDDDAAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 02 Jul 2021 11:48:49 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jroedel@suse.de,
        bp@suse.de, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 4/6] x86: efi_main: Self-relocate ELF .dynamic addresses
Date:   Fri,  2 Jul 2021 13:48:18 +0200
Message-Id: <20210702114820.16712-5-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702114820.16712-1-varad.gautam@suse.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EFI expects a relocatable PE, and the loader will patch in the
relocations from the COFF.

Since we are wrapping an ELF into a PE here, the EFI loader will
not handle ELF relocations, and we need to patch the ELF .dynamic
section manually on early boot.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/efi_main.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/x86/efi_main.c b/x86/efi_main.c
index 237d4e7..be3f9ab 100644
--- a/x86/efi_main.c
+++ b/x86/efi_main.c
@@ -1,9 +1,13 @@
 #include <alloc_phys.h>
 #include <linux/uefi.h>
+#include <elf.h>
 
 unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 efi_system_table_t *efi_system_table = NULL;
 
+extern char ImageBase;
+extern char _DYNAMIC;
+
 static void efi_free_pool(void *ptr)
 {
 	efi_bs_call(free_pool, ptr);
@@ -93,11 +97,70 @@ static efi_status_t exit_efi(void *handle)
 	return EFI_SUCCESS;
 }
 
+static efi_status_t elf_reloc(unsigned long image_base, unsigned long dynamic)
+{
+	long relsz = 0, relent = 0;
+	Elf64_Rel *rel = 0;
+	Elf64_Dyn *dyn = (Elf64_Dyn *) dynamic;
+	unsigned long *addr;
+	int i;
+
+	for (i = 0; dyn[i].d_tag != DT_NULL; i++) {
+		switch (dyn[i].d_tag) {
+		case DT_RELA:
+			rel = (Elf64_Rel *)
+				((unsigned long) dyn[i].d_un.d_ptr + image_base);
+			break;
+		case DT_RELASZ:
+			relsz = dyn[i].d_un.d_val;
+			break;
+		case DT_RELAENT:
+			relent = dyn[i].d_un.d_val;
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (!rel && relent == 0)
+		return EFI_SUCCESS;
+
+	if (!rel || relent == 0)
+		return EFI_LOAD_ERROR;
+
+	while (relsz > 0) {
+		/* apply the relocs */
+		switch (ELF64_R_TYPE (rel->r_info)) {
+		case R_X86_64_NONE:
+			break;
+		case R_X86_64_RELATIVE:
+			addr = (unsigned long *) (image_base + rel->r_offset);
+			*addr += image_base;
+			break;
+		default:
+			break;
+		}
+		rel = (Elf64_Rel *) ((char *) rel + relent);
+		relsz -= relent;
+	}
+	return EFI_SUCCESS;
+}
+
 unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
+	unsigned long image_base, dyn;
 	efi_system_table = sys_tab;
 
 	exit_efi(handle);
 
+	image_base = (unsigned long) &ImageBase;
+	dyn = image_base + (unsigned long) &_DYNAMIC;
+
+	/* The EFI loader does not handle ELF relocations, so fixup
+	 * .dynamic addresses before proceeding any further. */
+	elf_reloc(image_base, dyn);
+
+	start64();
+
 	return 0;
 }
-- 
2.30.2

