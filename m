Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F83EF693
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbhHRAKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbhHRAKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:15 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABCFC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:41 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id g73-20020a379d4c000000b003d3ed03ca28so459121qke.23
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z0qyErf8Ud9Z6DKOnKYG56vqdm7ZbLp2MXh9AUjLvIw=;
        b=HOhyXK+kY/y81QeAoMDiCPlGmRjzWNoLs8n3CJAsv7fozfcJyCv+L72xPxRFcqRwbd
         PbsPqp78i9/loTQ0s3NK+FP9bysSVbvDMMqPKJe/kS3PfBmNodMTP+7N+2pSCOadg7HU
         cuk/TYO5IfVcdUOIznD6iMSq9v5EfaOzej2ouU6aOc7ptHQsCclE8zKeMgUm0IacrxHe
         uC9oPSjM5rMY0TJ1BW29/nW85qsYtuss4QF8O5kfnMHhcNk+cIzev24UvRiLjhHD2vIn
         U0SmFru+Q9YRvKKdljXJPq2LfPVUh3ilmk8tBBnatwIi1I403YJSsiVEM2JXZUkHkvUr
         HoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z0qyErf8Ud9Z6DKOnKYG56vqdm7ZbLp2MXh9AUjLvIw=;
        b=ub8SVPOd3rYRns6Q+4Jfb4t2XuHJ/gdeOy2g9MSu/ExdMPWaxzx50jUpf9OvRc/qkn
         cuhH6Nv1FAHa3LjMJIVKOAs3vAL0onasksq5bTjKYGgSy816U5RKn4D6yu+kNOME8asP
         AT3cCPMc5wc05QlNP3SYoBK9QA80vmECtDARKFtz7miWZlwHdDvEibsVTsZjXcCtl4fA
         AZkyYGE97eYq66lX1AKPGTYd56p9qtZ19mBNLBdfakQfEtSD4CKLP9+sG0ewP5qOJJdP
         Cf6LemxTsAPvl5PfamqMQO6u/bjp7MCjbbP/SFUW8iinr0+k67RzkO0x4jBZIRDpEEDd
         REdw==
X-Gm-Message-State: AOAM531HHOWVI3BotL93zQIqOpj8JUS7X86a1nZKgonULT4Fan7A6oms
        4/eXfBwRqFsylNd0XwXhSIvuOHcviM7UKy2Yy0DAY8B0l5s3nVZLAAPKCtlERd4ECxb1C4m1LBE
        CFpfybCwCYA/51eccgnKScWdIzV++GuL/wRoIdvA6/Josqe8W2ICqbPfBK3TlI/j6sF0Y
X-Google-Smtp-Source: ABdhPJzre8y4OcOn98NFi986MFJdz8dN15Yb5m0cPW1KQvGl8WN23mTaEciAZ57zIPqZEiqaVjmdARqO+87fxGjK
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a05:6214:5288:: with SMTP id
 kj8mr5955405qvb.62.1629245381112; Tue, 17 Aug 2021 17:09:41 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:09:04 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-16-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 15/16] x86 AMD SEV-ES: Set up GHCB page
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 lib/x86/amd_sev.c | 35 +++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h |  6 ++++++
 lib/x86/setup.c   |  4 ++++
 3 files changed, 45 insertions(+)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 04b6912..7f6265a 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -11,6 +11,7 @@
 
 #include "amd_sev.h"
 #include "x86/processor.h"
+#include "x86/vm.h"
 
 static unsigned long long amd_sev_c_bit_pos;
 
@@ -64,6 +65,40 @@ EFI_STATUS setup_amd_sev_es(void){
 	return EFI_SUCCESS;
 }
 
+void setup_ghcb_pte(pgd_t *page_table)
+{
+	/* SEV-ES guest uses GHCB page to communicate with host. This page must
+	 * be unencrypted, i.e. its c-bit should be unset.
+	 */
+	phys_addr_t ghcb_addr, ghcb_base_addr;
+	pteval_t *pte;
+
+	/* Read the current GHCB page addr */
+	ghcb_addr = rdmsr(SEV_ES_GHCB_MSR_INDEX);
+
+	/* Find Level 1 page table entry for GHCB page */
+	pte = get_pte_level(page_table, (void *)ghcb_addr, 1);
+
+	/* Create Level 1 pte for GHCB page if not found */
+	if (pte == NULL) {
+		/* Find Level 2 page base address */
+		ghcb_base_addr = ghcb_addr & ~(LARGE_PAGE_SIZE-1);
+		/* Install Level 1 ptes */
+		install_pages(page_table, ghcb_base_addr, LARGE_PAGE_SIZE,
+			      (void *)ghcb_base_addr);
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
 static void copy_gdt_entry(gdt_entry_t *dst, gdt_entry_t *src, unsigned segment)
 {
 	unsigned index;
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 5ebd4a6..2f08cdb 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -41,9 +41,15 @@
  */
 #define SEV_ES_VC_HANDLER_VECTOR 29
 
+/* AMD Programmer's Manual Volume 2
+ *   - Section "GHCB"
+ */
+#define SEV_ES_GHCB_MSR_INDEX 0xc0010130
+
 EFI_STATUS setup_amd_sev(void);
 #ifdef CONFIG_AMD_SEV_ES
 EFI_STATUS setup_amd_sev_es(void);
+void setup_ghcb_pte(pgd_t *page_table);
 void copy_uefi_segments(void);
 #endif /* CONFIG_AMD_SEV_ES */
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index d828638..d782c39 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -290,6 +290,10 @@ static void setup_page_table(void)
 		curr_pt[i] = ((phys_addr_t)(i << 21)) | flags;
 	}
 
+#ifdef CONFIG_AMD_SEV_ES
+	setup_ghcb_pte((pgd_t *)&ptl4);
+#endif /* CONFIG_AMD_SEV_ES */
+
 	/* Load 4-level page table */
 	write_cr3((ulong)&ptl4);
 }
-- 
2.33.0.rc1.237.g0d66db33f3-goog

