Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE1D17BED
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfEHOo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:7390 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbfEHOoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:53 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 08 May 2019 07:44:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 7CDA2117C; Wed,  8 May 2019 17:44:31 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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
Subject: [PATCH, RFC 56/62] x86: Introduce CONFIG_X86_INTEL_MKTME
Date:   Wed,  8 May 2019 17:44:16 +0300
Message-Id: <20190508144422.13171-57-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add new config option to enabled/disable Multi-Key Total Memory
Encryption support.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ce9642e2c31b..4d2cfee50102 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1533,6 +1533,27 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
 	  If set to N, then the encryption of system memory can be
 	  activated with the mem_encrypt=on command line option.
 
+config X86_INTEL_MKTME
+	bool "Intel Multi-Key Total Memory Encryption"
+	select DYNAMIC_PHYSICAL_MASK
+	select PAGE_EXTENSION
+	select X86_MEM_ENCRYPT_COMMON
+	depends on X86_64 && CPU_SUP_INTEL && !KASAN
+	depends on KEYS
+	depends on !MEMORY_HOTPLUG_DEFAULT_ONLINE
+	depends on ACPI_HMAT
+	---help---
+	  Say yes to enable support for Multi-Key Total Memory Encryption.
+	  This requires an Intel processor that has support of the feature.
+
+	  Multikey Total Memory Encryption (MKTME) is a technology that allows
+	  transparent memory encryption in upcoming Intel platforms.
+
+	  MKTME is built on top of TME. TME allows encryption of the entirety
+	  of system memory using a single key. MKTME allows having multiple
+	  encryption domains, each having own key -- different memory pages can
+	  be encrypted with different keys.
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
@@ -2207,7 +2228,7 @@ config RANDOMIZE_MEMORY
 
 config MEMORY_PHYSICAL_PADDING
 	hex "Physical memory mapping padding" if EXPERT
-	depends on RANDOMIZE_MEMORY
+	depends on RANDOMIZE_MEMORY || X86_INTEL_MKTME
 	default "0xa" if MEMORY_HOTPLUG
 	default "0x0"
 	range 0x1 0x40 if MEMORY_HOTPLUG
-- 
2.20.1

