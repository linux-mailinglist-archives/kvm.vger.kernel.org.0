Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424164218A4
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhJDUvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbhJDUv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:28 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BE9C061749
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:39 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t4so800337plo.0
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LN79VK4oUfP1jBlueSCHop8deFKXmtHsFgLKU4/bmMo=;
        b=eFpm2ImeVnGDnoapuApMzdujExeOkT+mXVcpu8tp4xeq49brEqpA5X7QlYsci2/ltd
         K3N/+S9R6O0YRoliWCucSalb6R2SrmAq1NV3HCY+T30rc5cJLIBQfSdnuMoUan5H+PZ0
         8nquKXOTIv4t3UGfanT/27ecRMmYLMiayxkPej5kW8SwUxuOJCX3ctvkfCNISiFoViNv
         dN4907FzE54iq/yLJtgwsQM0d+7uH2jHmSkDPUD6KEy9v5AOMo9HzyZPGQ1qcylPXSm/
         WDujdIri+cdtzkGzo+8obMsV9s6GrX4ITzgXhYoQFnLXGWG5XzcMgzbZJaJ0qy0Ooiro
         6oww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LN79VK4oUfP1jBlueSCHop8deFKXmtHsFgLKU4/bmMo=;
        b=43ah6jfwv97++0Q9eQFSJAfltOKCC1iMKiI6SY0OxmcIPY97GLBQrVpOFwLM7QIGwA
         wW81vowfoBEr3ZmPFgvlRCLYpIUy1zvCGFEbMGCJxzraSKtUIodth1chmu4MafaJ7b/8
         EOlmfsqfxXbNV4mVfK9dGFnO7ZMuVPVKpSxzq5irYuzZsJqg4s/RON6O3EsTO9386AOI
         gyvtml6bFX/wP5SLoW8NI3C+wwbwaZX+2dtaWYKO6ZQ57d7AgZ8IuXTCQkO+tLy6c61j
         mg7fok3X63lSdaD+iZcCFxJy3dJUXhddd31n7ieXeVcvdQrSNqJwyXQNZ2Vfz/1wTvl9
         uHnQ==
X-Gm-Message-State: AOAM533NVB1XWVP7vkr6LWv2l0tqwBtq3KaOftwngFsVjejZRxzpZFYH
        VdHpjj0PHik3nBZ4NhMWNh69E+07H/TSVA==
X-Google-Smtp-Source: ABdhPJyL7QwG9T1ZO/uPk64YSsqICTIjqcO8W6FokdLXXyeaTD4rCPs034Fr9deaPS1UqbiZB3JwrA==
X-Received: by 2002:a17:90a:a609:: with SMTP id c9mr14979847pjq.134.1633380578148;
        Mon, 04 Oct 2021 13:49:38 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:37 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 03/17] x86 UEFI: Implement UEFI function calls
Date:   Mon,  4 Oct 2021 13:49:17 -0700
Message-Id: <20211004204931.1537823-4-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Varad Gautam <varad.gautam@suse.com>

This commit implements helper functions that call UEFI services and
assist the boot up process.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 lib/efi.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 lib/efi.c

diff --git a/lib/efi.c b/lib/efi.c
new file mode 100644
index 0000000..7f08f0e
--- /dev/null
+++ b/lib/efi.c
@@ -0,0 +1,67 @@
+/*
+ * EFI-related functions to set up and run test cases in EFI
+ *
+ * Copyright (c) 2021, SUSE, Varad Gautam <varad.gautam@suse.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#include <linux/efi.h>
+
+unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
+efi_system_table_t *efi_system_table = NULL;
+
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
+	/*
+	 * Pad map_size with additional descriptors so we don't need to
+	 * retry.
+	 */
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
+unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
+{
+	efi_system_table = sys_tab;
+
+	return 0;
+}
-- 
2.33.0

