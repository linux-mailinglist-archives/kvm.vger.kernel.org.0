Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B7C3BA007
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhGBLvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:51:23 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44722 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhGBLvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:51:22 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 375AD20558;
        Fri,  2 Jul 2021 11:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X0PCbfsKKi5Z5ypmtVXwwsJ90tFRD61CKAIuZBznxzQ=;
        b=exOewFtVlDV2ckakHVvdAvM8jyTXGXcGir38/1JM/5MwiN7SegbSlRo4uCQOLCG8wM8HFM
        yIxNBYV8jNyM8uAtw8yhJWkeaKGxMl9EaVC7nG0Xw+MXTYgR4q8ZqKNRzxIjjGJ4iqdUm7
        YGBTAbXpTO2821xRAas3JaT2b2daG80=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id CB5A811C84;
        Fri,  2 Jul 2021 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X0PCbfsKKi5Z5ypmtVXwwsJ90tFRD61CKAIuZBznxzQ=;
        b=exOewFtVlDV2ckakHVvdAvM8jyTXGXcGir38/1JM/5MwiN7SegbSlRo4uCQOLCG8wM8HFM
        yIxNBYV8jNyM8uAtw8yhJWkeaKGxMl9EaVC7nG0Xw+MXTYgR4q8ZqKNRzxIjjGJ4iqdUm7
        YGBTAbXpTO2821xRAas3JaT2b2daG80=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 8DsIMCD93mDDDAAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 02 Jul 2021 11:48:48 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jroedel@suse.de,
        bp@suse.de, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 3/6] x86: efi_main: Get EFI memory map and exit boot services
Date:   Fri,  2 Jul 2021 13:48:17 +0200
Message-Id: <20210702114820.16712-4-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702114820.16712-1-varad.gautam@suse.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The largest EFI_CONVENTIONAL_MEMORY chunk is passed over to
alloc_phys for the testcase.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/efi_main.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/x86/efi_main.c b/x86/efi_main.c
index 00e7086..237d4e7 100644
--- a/x86/efi_main.c
+++ b/x86/efi_main.c
@@ -1,11 +1,103 @@
+#include <alloc_phys.h>
 #include <linux/uefi.h>
 
 unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
 efi_system_table_t *efi_system_table = NULL;
 
+static void efi_free_pool(void *ptr)
+{
+	efi_bs_call(free_pool, ptr);
+}
+
+static efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
+{
+	efi_memory_desc_t *m = NULL;
+	efi_status_t status;
+	unsigned long key = 0, map_size = 0, desc_size = 0;
+
+	status = efi_bs_call(get_memory_map, &map_size,
+			     NULL, &key, &desc_size, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL || map_size == 0)
+		goto out;
+
+	/* Pad map_size with additional descriptors so we don't need to
+	 * retry. */
+	map_size += 4 * desc_size;
+	*map->buff_size = map_size;
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
+			     map_size, (void **)&m);
+	if (status != EFI_SUCCESS)
+		goto out;
+
+	/* Get the map. */
+	status = efi_bs_call(get_memory_map, &map_size,
+			     m, &key, &desc_size, NULL);
+	if (status != EFI_SUCCESS) {
+		efi_free_pool(m);
+		goto out;
+	}
+
+	*map->desc_size = desc_size;
+	*map->map_size = map_size;
+	*map->key_ptr = key;
+out:
+	*map->map = m;
+	return status;
+}
+
+static efi_status_t efi_exit_boot_services(void *handle,
+					   struct efi_boot_memmap *map)
+{
+	return efi_bs_call(exit_boot_services, handle, *map->key_ptr);
+}
+
+static efi_status_t exit_efi(void *handle)
+{
+	unsigned long map_size = 0, key = 0, desc_size = 0, buff_size;
+	efi_memory_desc_t *mem_map, *md, *conventional = NULL;
+	efi_status_t status;
+	unsigned num_ents, i;
+	unsigned long pages = 0;
+	struct efi_boot_memmap map;
+
+	map.map = &mem_map;
+	map.map_size = &map_size;
+	map.desc_size = &desc_size;
+	map.desc_ver = NULL;
+	map.key_ptr = &key;
+	map.buff_size = &buff_size;
+
+	status = efi_get_memory_map(&map);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = efi_exit_boot_services(handle, &map);
+	if (status != EFI_SUCCESS) {
+		efi_free_pool(mem_map);
+		return status;
+	}
+
+	/* Use the largest EFI_CONVENTIONAL_MEMORY range for phys_alloc_init. */
+	num_ents = map_size / desc_size;
+	for (i = 0; i < num_ents; i++) {
+		md = (efi_memory_desc_t *) (((u8 *) mem_map) + i * (desc_size));
+
+		if (md->type == EFI_CONVENTIONAL_MEMORY && md->num_pages > pages) {
+			conventional = md;
+			pages = md->num_pages;
+		}
+	}
+	phys_alloc_init(conventional->phys_addr,
+			conventional->num_pages << EFI_PAGE_SHIFT);
+
+	return EFI_SUCCESS;
+}
+
 unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
 {
 	efi_system_table = sys_tab;
 
+	exit_efi(handle);
+
 	return 0;
 }
-- 
2.30.2

