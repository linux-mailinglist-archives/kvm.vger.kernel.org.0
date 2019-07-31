Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968A97C5C9
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfGaPKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:10:08 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43828 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388498AbfGaPIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:24 -0400
Received: by mail-ed1-f65.google.com with SMTP id e3so66030788edr.10
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2O79cZSevj0fRjj98yOOKrmJ0HJlarDgQ5rQqTlE+Vc=;
        b=owT4iRH22mETHlgcegYuhOK9u2nliY5q2VeZyUqXWoHHX/n19x6syg9GnDrIywB6W7
         APi/TtXQtb/nyf25clrFAdZFZGzagMUnv2Z+2cnjWF04cbPyOCM49Gksu1AvQeUUnvR7
         XUl2UNWMozLrrjHv201FJREyJgY9narxPLb1H5CawrRm8y//HMtVsyE9d/mxsDfkAKPA
         enOpyJ4Rl3qA1WMr8I6NZp5PsirfuPoIKC32e6w353HdSR4LEILwTFl4IFSdfBVVRSfh
         STKHa9Io28Fnozh/5ryrT10P9Qc9Ssl4F2PLmi5mOWUpEijdd0/vEnnTb2ET+50iJgoQ
         809g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2O79cZSevj0fRjj98yOOKrmJ0HJlarDgQ5rQqTlE+Vc=;
        b=uBd7xyGOL/tsVfErAKuT56j9v0u33K7ll/k4vuUTvORIBrnVAguX5rwrtBfEcxNqn0
         VnkvdKSj+0F4q0PMJx9ZaKuKPZNtCfmsKfJYy6a8K8tj8rg3RQNg5j29wowEH1WWnCLO
         Txize2aErIoQp8GVQMRQ2Nh0pccGjqIyAJOv5Zl61wpDTWucsT/giPjZ7OdyWaSjC/Ib
         T8iHjDzsWUEl6kyRMGq/Z8Pu4rGUItckNei/krAfUi0yH682o4NR01oliF97ZF7njPit
         O2CFsxCMYYIjzZKZ+4s2jZngM23MA6FZbHSQYnFNMrV1mKjm9/Q7C+PDz33VEFePw+Br
         2J7w==
X-Gm-Message-State: APjAAAU0buFf+V6H31bp4cImvPvo8WAJ5IkRSww7hmjFOv6YhE7FqyaM
        +fMYXnSB4a83V4UtoMXP4ns=
X-Google-Smtp-Source: APXvYqwVNuaD30wHzFTa+Rk9wdAadH3VZ+X69/JVMMK7ntSPJ0Jg/TWgZwrRyyNLslnPzeWxXrLqGw==
X-Received: by 2002:a17:906:1105:: with SMTP id h5mr26111047eja.53.1564585702584;
        Wed, 31 Jul 2019 08:08:22 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id k11sm16516389edq.54.2019.07.31.08.08.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:19 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 25CB810131F; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 08/59] x86/mm: Introduce helpers to read number, shift and mask of KeyIDs
Date:   Wed, 31 Jul 2019 18:07:22 +0300
Message-Id: <20190731150813.26289-9-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mktme_nr_keyids() returns the number of KeyIDs available for MKTME,
excluding KeyID zero which used by TME. MKTME KeyIDs start from 1.

mktme_keyid_shift() returns the shift of KeyID within physical address.

mktme_keyid_mask() returns the mask to extract KeyID from physical address.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mktme.h | 19 +++++++++++++++++++
 arch/x86/kernel/cpu/intel.c  | 15 ++++++++++++---
 arch/x86/mm/Makefile         |  2 ++
 arch/x86/mm/mktme.c          | 27 +++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/mktme.h
 create mode 100644 arch/x86/mm/mktme.c

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
new file mode 100644
index 000000000000..b9ba2ea5b600
--- /dev/null
+++ b/arch/x86/include/asm/mktme.h
@@ -0,0 +1,19 @@
+#ifndef	_ASM_X86_MKTME_H
+#define	_ASM_X86_MKTME_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_X86_INTEL_MKTME
+extern phys_addr_t __mktme_keyid_mask;
+extern phys_addr_t mktme_keyid_mask(void);
+extern int __mktme_keyid_shift;
+extern int mktme_keyid_shift(void);
+extern int __mktme_nr_keyids;
+extern int mktme_nr_keyids(void);
+#else
+#define mktme_keyid_mask()	((phys_addr_t)0)
+#define mktme_nr_keyids()	0
+#define mktme_keyid_shift()	0
+#endif
+
+#endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index f03eee666761..7ba44825be42 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -618,6 +618,9 @@ static void detect_tme(struct cpuinfo_x86 *c)
 
 #ifdef CONFIG_X86_INTEL_MKTME
 	if (mktme_status == MKTME_ENABLED && nr_keyids) {
+		__mktme_nr_keyids = nr_keyids;
+		__mktme_keyid_shift = c->x86_phys_bits - keyid_bits;
+
 		/*
 		 * Mask out bits claimed from KeyID from physical address mask.
 		 *
@@ -625,17 +628,23 @@ static void detect_tme(struct cpuinfo_x86 *c)
 		 * and number of bits claimed for KeyID is 6, bits 51:46 of
 		 * physical address is unusable.
 		 */
-		phys_addr_t keyid_mask;
+		__mktme_keyid_mask = GENMASK_ULL(c->x86_phys_bits - 1, mktme_keyid_shift());
+		physical_mask &= ~mktme_keyid_mask();
 
-		keyid_mask = GENMASK_ULL(c->x86_phys_bits - 1, c->x86_phys_bits - keyid_bits);
-		physical_mask &= ~keyid_mask;
 	} else {
 		/*
 		 * Reset __PHYSICAL_MASK.
 		 * Maybe needed if there's inconsistent configuation
 		 * between CPUs.
+		 *
+		 * FIXME: broken for hotplug.
+		 * We must not allow onlining secondary CPUs with non-matching
+		 * configuration.
 		 */
 		physical_mask = (1ULL << __PHYSICAL_MASK_SHIFT) - 1;
+		__mktme_keyid_mask = 0;
+		__mktme_keyid_shift = 0;
+		__mktme_nr_keyids = 0;
 	}
 #endif
 
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 84373dc9b341..600d18691876 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -53,3 +53,5 @@ obj-$(CONFIG_PAGE_TABLE_ISOLATION)		+= pti.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+
+obj-$(CONFIG_X86_INTEL_MKTME)	+= mktme.o
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
new file mode 100644
index 000000000000..0f48ef2720cc
--- /dev/null
+++ b/arch/x86/mm/mktme.c
@@ -0,0 +1,27 @@
+#include <asm/mktme.h>
+
+/* Mask to extract KeyID from physical address. */
+phys_addr_t __mktme_keyid_mask;
+phys_addr_t mktme_keyid_mask(void)
+{
+	return __mktme_keyid_mask;
+}
+EXPORT_SYMBOL_GPL(mktme_keyid_mask);
+
+/* Shift of KeyID within physical address. */
+int __mktme_keyid_shift;
+int mktme_keyid_shift(void)
+{
+	return __mktme_keyid_shift;
+}
+EXPORT_SYMBOL_GPL(mktme_keyid_shift);
+
+/*
+ * Number of KeyIDs available for MKTME.
+ * Excludes KeyID-0 which used by TME. MKTME KeyIDs start from 1.
+ */
+int __mktme_nr_keyids;
+int mktme_nr_keyids(void)
+{
+	return __mktme_nr_keyids;
+}
-- 
2.21.0

