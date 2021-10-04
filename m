Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF244218B1
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbhJDUvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbhJDUvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D16C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:58 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so357123pjb.1
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3nCpi/3q0Xk4Fi+QEeFqwLO52wqA3929fKW6++LrdJk=;
        b=VWrm0JHjvocUm1hPVj7ML0GlfqQr6nG9WBEKsWlzGV7Tkwp+zfDq/7g3lrGSuGLcYo
         go9QfK/ioM6EXas5jZ+4AZiIcERyqGQgB+832MDZUEwVqGiq5Rdi0s3Z60wMqPnpeeSp
         jDhEZi/45h2Ns09nPDoifLaZx8Lz8VKaSg7qSRsFiF6xpHxZTqWjWbJ/zPoc8EwmzRIg
         DYCiJSp0C7Pa7Z9k+8J7ZA838WUWfUlYleeoqQ0f+iPi1oNTfnbFqTvEJzbbMVK5LkJ+
         TxEWYByGkQQFDGZ+QYHIxHy8TUhXV2sk3dxQoxSRMicmzlvyqWTi5LxdNXtAyIst1La6
         QqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3nCpi/3q0Xk4Fi+QEeFqwLO52wqA3929fKW6++LrdJk=;
        b=Np/SGGMcT7QNnDvZ33nmnTd+eytq6tSs82iGLlIn5IwYN8jKMGI4ujikB9PWYfnB9+
         oqBxQykUWRv1gYSmLBs9pj50bmY0JKRmNWXHZVh5qzk+kb3GKIeb/evQ0ntMqGMNYdbF
         kIT5m/pnOEHA+ltu/HP1dXU/urHJa4VqiCrKu+DKe1Wh51tewK7H64EBucc6nWi8wPo+
         J1eEyA2DbF0xydahusek9TZRESi6ZKyaaonKb69GDg8PWYYyHQaQCHHSZSDxhw0Tlu8P
         iOV3tiMMiVQ7u5xAa1gU71FRqP2iOcl4X8/kKs5SvHIYGXHdfd6V79dPmVgFXYPl2Q29
         VALA==
X-Gm-Message-State: AOAM530TFvd+eivdkPgbQnTMaEVtbxQpH8NkBn1wKeyIOToEoJtxI90e
        t4deqH6JAYDtDDnK7D7t4LSQk+flWcAiSA==
X-Google-Smtp-Source: ABdhPJwkxY4yEtBX1e4921tUQN0KNZN8C54VYbGsklheOHEE4mz/LR1YV2u25v7FZuc9/kwgR1hRAA==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr6043130pjb.129.1633380597371;
        Mon, 04 Oct 2021 13:49:57 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:56 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 16/17] x86 AMD SEV-ES: Set up GHCB page
Date:   Mon,  4 Oct 2021 13:49:30 -0700
Message-Id: <20211004204931.1537823-17-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

AMD SEV-ES introduces a GHCB page for guest/host communication. This
page should be unencrypted, i.e. its c-bit should be unset, otherwise
the guest VM may crash when #VC exception happens.

By default, KVM-Unit-Tests only sets up 2MiB pages, i.e. only Level 2
page table entries are provided. Unsetting GHCB Level 2 pte's c-bit
still crashes the guest VM. The solution is to unset only its Level 1
pte's c-bit.

This commit provides GHCB page set up code that:

   1. finds GHCB Level 1 pte
   2. if not found, installs corresponding Level 1 pages
   3. unsets GHCB Level 1 pte's c-bit

In this commit, KVM-Unit-Tests can run in an SEV-ES VM and boot into
test cases' main().

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 37 +++++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h |  7 +++++++
 lib/x86/setup.c   |  4 ++++
 3 files changed, 48 insertions(+)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 50352df..6672214 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -11,6 +11,7 @@
 
 #include "amd_sev.h"
 #include "x86/processor.h"
+#include "x86/vm.h"
 
 static unsigned short amd_sev_c_bit_pos;
 
@@ -117,6 +118,42 @@ efi_status_t setup_amd_sev_es(void)
 	return EFI_SUCCESS;
 }
 
+void setup_ghcb_pte(pgd_t *page_table)
+{
+	/*
+	 * SEV-ES guest uses GHCB page to communicate with the host. This page
+	 * must be unencrypted, i.e. its c-bit should be unset. To do so, this
+	 * function searches GHCB's L1 pte, creates corresponding L1 ptes if not
+	 * found, and unsets the c-bit of GHCB's L1 pte.
+	 */
+	phys_addr_t ghcb_addr, ghcb_base_addr;
+	pteval_t *pte;
+
+	/* Read the current GHCB page addr */
+	ghcb_addr = rdmsr(SEV_ES_GHCB_MSR_INDEX);
+
+	/* Search Level 1 page table entry for GHCB page */
+	pte = get_pte_level(page_table, (void *)ghcb_addr, 1);
+
+	/* Create Level 1 pte for GHCB page if not found */
+	if (pte == NULL) {
+		/* Find Level 2 page base address */
+		ghcb_base_addr = ghcb_addr & ~(LARGE_PAGE_SIZE - 1);
+		/* Install Level 1 ptes */
+		install_pages(page_table, ghcb_base_addr, LARGE_PAGE_SIZE, (void *)ghcb_base_addr);
+		/* Find Level 2 pte, set as 4KB pages */
+		pte = get_pte_level(page_table, (void *)ghcb_addr, 2);
+		assert(pte);
+		*pte &= ~(PT_PAGE_SIZE_MASK);
+		/* Find Level 1 GHCB pte */
+		pte = get_pte_level(page_table, (void *)ghcb_addr, 1);
+		assert(pte);
+	}
+
+	/* Unset c-bit in Level 1 GHCB pte */
+	*pte &= ~(get_amd_sev_c_bit_mask());
+}
+
 unsigned long long get_amd_sev_c_bit_mask(void)
 {
 	if (amd_sev_enabled()) {
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 0ea1fda..6a10f84 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -45,8 +45,15 @@ efi_status_t setup_amd_sev(void);
  */
 #define SEV_ES_VC_HANDLER_VECTOR 29
 
+/*
+ * AMD Programmer's Manual Volume 2
+ *   - Section "GHCB"
+ */
+#define SEV_ES_GHCB_MSR_INDEX 0xc0010130
+
 bool amd_sev_es_enabled(void);
 efi_status_t setup_amd_sev_es(void);
+void setup_ghcb_pte(pgd_t *page_table);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 529c3d0..1f2cdde 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -314,6 +314,10 @@ static void setup_page_table(void)
 		curr_pt[i] = ((phys_addr_t)(i << 21)) | flags;
 	}
 
+	if (amd_sev_es_enabled()) {
+		setup_ghcb_pte((pgd_t *)&ptl4);
+	}
+
 	/* Load 4-level page table */
 	write_cr3((ulong)&ptl4);
 }
-- 
2.33.0

