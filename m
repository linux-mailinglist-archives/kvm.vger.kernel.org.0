Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9F117BF3
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfEHOoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:19928 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfEHOoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,446,1549958400"; 
   d="scan'208";a="169656575"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2019 07:44:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 88BA31186; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 57/62] x86/mktme: Overview of Multi-Key Total Memory Encryption
Date:   Wed,  8 May 2019 17:44:17 +0300
Message-Id: <20190508144422.13171-58-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

Provide an overview of MKTME on Intel Platforms.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/x86/mktme/index.rst          |  8 +++
 Documentation/x86/mktme/mktme_overview.rst | 57 ++++++++++++++++++++++
 2 files changed, 65 insertions(+)
 create mode 100644 Documentation/x86/mktme/index.rst
 create mode 100644 Documentation/x86/mktme/mktme_overview.rst

diff --git a/Documentation/x86/mktme/index.rst b/Documentation/x86/mktme/index.rst
new file mode 100644
index 000000000000..1614b52dd3e9
--- /dev/null
+++ b/Documentation/x86/mktme/index.rst
@@ -0,0 +1,8 @@
+
+=========================================
+Multi-Key Total Memory Encryption (MKTME)
+=========================================
+
+.. toctree::
+
+   mktme_overview
diff --git a/Documentation/x86/mktme/mktme_overview.rst b/Documentation/x86/mktme/mktme_overview.rst
new file mode 100644
index 000000000000..59c023965554
--- /dev/null
+++ b/Documentation/x86/mktme/mktme_overview.rst
@@ -0,0 +1,57 @@
+Overview
+=========
+Multi-Key Total Memory Encryption (MKTME)[1] is a technology that
+allows transparent memory encryption in upcoming Intel platforms.
+It uses a new instruction (PCONFIG) for key setup and selects a
+key for individual pages by repurposing physical address bits in
+the page tables.
+
+Support for MKTME is added to the existing kernel keyring subsystem
+and via a new mprotect_encrypt() system call that can be used by
+applications to encrypt anonymous memory with keys obtained from
+the keyring.
+
+This architecture supports encrypting both normal, volatile DRAM
+and persistent memory.  However, persistent memory support is
+not included in the Linux kernel implementation at this time.
+(We anticipate adding that support next.)
+
+Hardware Background
+===================
+
+MKTME is built on top of an existing single-key technology called
+TME.  TME encrypts all system memory using a single key generated
+by the CPU on every boot of the system. TME provides mitigation
+against physical attacks, such as physically removing a DIMM or
+watching memory bus traffic.
+
+MKTME enables the use of multiple encryption keys[2], allowing
+selection of the encryption key per-page using the page tables.
+Encryption keys are programmed into each memory controller and
+the same set of keys is available to all entities on the system
+with access to that memory (all cores, DMA engines, etc...).
+
+MKTME inherits many of the mitigations against hardware attacks
+from TME.  Like TME, MKTME does not mitigate vulnerable or
+malicious operating systems or virtual machine managers.  MKTME
+offers additional mitigations when compared to TME.
+
+TME and MKTME use the AES encryption algorithm in the AES-XTS
+mode.  This mode, typically used for block-based storage devices,
+takes the physical address of the data into account when
+encrypting each block.  This ensures that the effective key is
+different for each block of memory. Moving encrypted content
+across physical address results in garbage on read, mitigating
+block-relocation attacks.  This property is the reason many of
+the discussed attacks require control of a shared physical page
+to be handed from the victim to the attacker.
+
+--
+1. https://software.intel.com/sites/default/files/managed/a5/16/Multi-Key-Total-Memory-Encryption-Spec.pdf
+2. The MKTME architecture supports up to 16 bits of KeyIDs, so a
+   maximum of 65535 keys on top of the “TME key” at KeyID-0.  The
+   first implementation is expected to support 5 bits, making 63
+   keys available to applications.  However, this is not guaranteed.
+   The number of available keys could be reduced if, for instance,
+   additional physical address space is desired over additional
+   KeyIDs.
-- 
2.20.1

