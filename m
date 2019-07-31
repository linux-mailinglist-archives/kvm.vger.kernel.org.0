Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1007C653
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfGaPWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:22:07 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40971 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfGaPWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:22:05 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so66019267eds.8
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZkftAsGdSxojE0fJOOOF/MZdp7LK73Cocd1bOG6H+X8=;
        b=yNcUiWdQFKls9CJ+s1kmqNYTq4HAt/+z4PQnyTb2R/O/QG4HejvHYbZEnDpZkx4u6m
         rYryPmrZZw5X0yVl9cqTObJ/vAbi3N2kcWUJTn/nS5m7u0j1NeO76bPx86u5y6/FFXzG
         GwvkGwtp3dVrAmLGNQwceerYEf8lbhe3A3hpQ9jH6pM/+5oR2hB1poc9BJZ/qpFk3lFg
         AVoV+a8D/wx7gKubBM5x0ly/CpnY4m7riIc5gECoUZ1ttMWB61O3sn/gxcaUYdZYR3rm
         riJBLh8bckwgmhvRhWjFVk43K9z3429hxlIIgWZDxIvHcCVj0zmgN7kgBdEg+aubIbZF
         aYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZkftAsGdSxojE0fJOOOF/MZdp7LK73Cocd1bOG6H+X8=;
        b=NABfyMpsXDZ2cwFf4LaupHFGzdO8pPIgvXqYJV3IE98HyFbinvNJRdGPzrDVpUjVsZ
         ZveYfz6MuFW17oIXyJhhfaNbzUVdJlPLg6m1zHYvB998wY5zXDezlpEXZ1Agdjo9BV+W
         nJdzo5eRRm/+zPs4fz/b9ovR+D1JZJklVbDAAGXTUmta3f29SogdY7ZULjpYOsNA24to
         kpXqxQInjx/Slz0aXpPM9LUib3O6QKiYnjT2MOJgUW32TvVtRgzHtzGpkgjIqhofeyXy
         S+TfdyzSzLEGam8/JZJTXHGTb44DR8P0vyoc8qdsrP1yifLxWW0udfCh/aUeY04W6DYZ
         0AIw==
X-Gm-Message-State: APjAAAWFv/8lZq6SfcoU0X1DSIYQxtwWgJigQnBExC5mUlBvch6bpKvZ
        miFJeKqnE7crY7MVLk1QaGo=
X-Google-Smtp-Source: APXvYqxlBWhD79QJcY6LnrhxwdW4BCeLIylkUAMRGP9j6V32DYMCll5/WusJdm6IK3xrXEoHhQo02A==
X-Received: by 2002:a17:906:94ce:: with SMTP id d14mr97075606ejy.251.1564586031480;
        Wed, 31 Jul 2019 08:13:51 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id j37sm17791942ede.23.2019.07.31.08.13.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:50 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 251F0104601; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 43/59] x86/mm: Set KeyIDs in encrypted VMAs for MKTME
Date:   Wed, 31 Jul 2019 18:07:57 +0300
Message-Id: <20190731150813.26289-44-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

MKTME architecture requires the KeyID to be placed in PTE bits 51:46.
To create an encrypted VMA, place the KeyID in the upper bits of
vm_page_prot that matches the position of those PTE bits.

When the VMA is assigned a KeyID it is always considered a KeyID
change. The VMA is either going from not encrypted to encrypted,
or from encrypted with any KeyID to encrypted with any other KeyID.
To make the change safely, remove the user pages held by the VMA
and unlink the VMA's anonymous chain.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mktme.h |  4 ++++
 arch/x86/mm/mktme.c          | 26 ++++++++++++++++++++++++++
 include/linux/mm.h           |  6 ++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index d26ada6b65f7..e8f7f80bb013 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -16,6 +16,10 @@ extern int __mktme_nr_keyids;
 extern int mktme_nr_keyids(void);
 extern unsigned int mktme_algs;
 
+/* Set the encryption keyid bits in a VMA */
+extern void mprotect_set_encrypt(struct vm_area_struct *vma, int newkeyid,
+				unsigned long start, unsigned long end);
+
 DECLARE_STATIC_KEY_FALSE(mktme_enabled_key);
 static inline bool mktme_enabled(void)
 {
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
index ed13967bb543..05bbf5058ade 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -1,5 +1,6 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/rmap.h>
 #include <asm/mktme.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
@@ -71,6 +72,31 @@ int __vma_keyid(struct vm_area_struct *vma)
 	return (prot & mktme_keyid_mask()) >> mktme_keyid_shift();
 }
 
+/* Set the encryption keyid bits in a VMA */
+void mprotect_set_encrypt(struct vm_area_struct *vma, int newkeyid,
+			  unsigned long start, unsigned long end)
+{
+	int oldkeyid = vma_keyid(vma);
+	pgprotval_t newprot;
+
+	/* Unmap pages with old KeyID if there's any. */
+	zap_page_range(vma, start, end - start);
+
+	if (oldkeyid == newkeyid)
+		return;
+
+	newprot = pgprot_val(vma->vm_page_prot);
+	newprot &= ~mktme_keyid_mask();
+	newprot |= (unsigned long)newkeyid << mktme_keyid_shift();
+	vma->vm_page_prot = __pgprot(newprot);
+
+	/*
+	 * The VMA doesn't have any inherited pages.
+	 * Start anon VMA tree from scratch.
+	 */
+	unlink_anon_vmas(vma);
+}
+
 /* Prepare page to be used for encryption. Called from page allocator. */
 void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3f9640f388ac..98a6d2bd66a6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2905,5 +2905,11 @@ void __init setup_nr_node_ids(void);
 static inline void setup_nr_node_ids(void) {}
 #endif
 
+#ifndef CONFIG_X86_INTEL_MKTME
+static inline void mprotect_set_encrypt(struct vm_area_struct *vma,
+					int newkeyid,
+					unsigned long start,
+					unsigned long end) {}
+#endif /* CONFIG_X86_INTEL_MKTME */
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
-- 
2.21.0

