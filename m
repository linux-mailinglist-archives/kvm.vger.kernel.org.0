Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9117C638
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfGaPVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:21:49 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42073 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfGaPVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:21:49 -0400
Received: by mail-ed1-f68.google.com with SMTP id v15so66084632eds.9
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rS7n4vbFz7RKbnJIWYLJ3LD2/VhASWWBXDQ1YiyXUK4=;
        b=afbMm0GfaAisY0kxZUpRSnh8R0UIgNbJC7BJabH5D9WD/FNoXqbra0An01CbRBxtGZ
         6HU1X6ERvuzfNqTtDr+HgIFNQrS9uH8mDg4JioI9lUGBcB+JyiVbUiZDn49xnAK2QQn2
         oQ3mhFNgfpG+AUJM6loNdB65enq3rg75smpnnn5r67isH8PNtXlUf6jqP5gfHsQbMQyF
         l59jSDgnvEUi9oWKOkD6rlyjzioaGiCcKXFv5vzlqChSrqbNMbLCeGEwMXmrJepCKBgI
         Uuo0QV/OGqvUg9Jx7SfUQ3NHZ5kkTcCYHyjFw9TFCxaRJlkdceV57/R8dgaSbT3qft98
         VEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rS7n4vbFz7RKbnJIWYLJ3LD2/VhASWWBXDQ1YiyXUK4=;
        b=QAaQKwO5+PjQDPY0xX4oF/sqDNVEwoNaa/HQkA8EsBrtakSKCwBY8vrN/VF9+Qtz/N
         31hqqr41HEwUbnNv3XXbmg8Iu9IFDS1Drvzu/bzZAk3h1XRkOohc61BvmTi0w0V38QGn
         Vf7utTV1LoHWWfppfVaN2Igr2gZ+J+8++mJB17VjFzwCsC8sm7P8V3ALTXpVCxdDEFaG
         4KLOBtA+gExpqd42OnjwCazjLGHQTSrmaeSFHIFqEaR38LxsBrILSKThgkNR6ICIQ8ZK
         WR476s/1rjhpZt1SSqoi4qen7o1fF+SKe4mKmWKAQDOULU1IGoKDVzGdSwXs9gVNVxnS
         Xn3A==
X-Gm-Message-State: APjAAAUkRcp4GvGzgUeDiFaJf53Eg/L8k40Tgo8l4Unu3MgZF5zSvAgd
        x6p0PuOX+peM2UVAyqPTjLE=
X-Google-Smtp-Source: APXvYqzYx7vkfK0pCreTlPXP87r4rm9+sWwDysXJ5rrTYu3XJTTOF6g20uha3nGp0gwYlH89T1Svfw==
X-Received: by 2002:a17:906:6bc4:: with SMTP id t4mr97503471ejs.256.1564586032415;
        Wed, 31 Jul 2019 08:13:52 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id 9sm8069757ejw.63.2019.07.31.08.13.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:50 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 7337F1048A6; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 54/59] x86/mktme: Overview of Multi-Key Total Memory Encryption
Date:   Wed, 31 Jul 2019 18:08:08 +0300
Message-Id: <20190731150813.26289-55-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
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
 Documentation/x86/index.rst                |  1 +
 Documentation/x86/mktme/index.rst          |  8 +++
 Documentation/x86/mktme/mktme_overview.rst | 57 ++++++++++++++++++++++
 3 files changed, 66 insertions(+)
 create mode 100644 Documentation/x86/mktme/index.rst
 create mode 100644 Documentation/x86/mktme/mktme_overview.rst

diff --git a/Documentation/x86/index.rst b/Documentation/x86/index.rst
index af64c4bb4447..449bb6abeb0e 100644
--- a/Documentation/x86/index.rst
+++ b/Documentation/x86/index.rst
@@ -22,6 +22,7 @@ x86-specific Documentation
    intel_mpx
    intel-iommu
    intel_txt
+   mktme/index
    amd-memory-encryption
    pti
    mds
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
index 000000000000..64c3268a508e
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
+   first implementation is expected to support 6 bits, making 63
+   keys available to applications.  However, this is not guaranteed.
+   The number of available keys could be reduced if, for instance,
+   additional physical address space is desired over additional
+   KeyIDs.
-- 
2.21.0

