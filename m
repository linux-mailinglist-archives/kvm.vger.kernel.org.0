Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E9417BF9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfEHOqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:46:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:19928 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728504AbfEHOoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,446,1549958400"; 
   d="scan'208";a="169656578"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2019 07:44:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 9448E11B3; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 58/62] x86/mktme: Document the MKTME provided security mitigations
Date:   Wed,  8 May 2019 17:44:18 +0300
Message-Id: <20190508144422.13171-59-kirill.shutemov@linux.intel.com>
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

Describe the security benefits of Multi-Key Total Memory
Encryption (MKTME) over Total Memory Encryption (TME) alone.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/x86/mktme/index.rst             |   1 +
 Documentation/x86/mktme/mktme_mitigations.rst | 150 ++++++++++++++++++
 2 files changed, 151 insertions(+)
 create mode 100644 Documentation/x86/mktme/mktme_mitigations.rst

diff --git a/Documentation/x86/mktme/index.rst b/Documentation/x86/mktme/index.rst
index 1614b52dd3e9..a3a29577b013 100644
--- a/Documentation/x86/mktme/index.rst
+++ b/Documentation/x86/mktme/index.rst
@@ -6,3 +6,4 @@ Multi-Key Total Memory Encryption (MKTME)
 .. toctree::
 
    mktme_overview
+   mktme_mitigations
diff --git a/Documentation/x86/mktme/mktme_mitigations.rst b/Documentation/x86/mktme/mktme_mitigations.rst
new file mode 100644
index 000000000000..90699c38750a
--- /dev/null
+++ b/Documentation/x86/mktme/mktme_mitigations.rst
@@ -0,0 +1,150 @@
+MKTME-Provided Mitigations
+==========================
+
+MKTME adds a few mitigations against attacks that are not
+mitigated when using TME alone.  The first set are mitigations
+against software attacks that are familiar today:
+
+ * Kernel Mapping Attacks: information disclosures that leverage
+   the kernel direct map are mitigated against disclosing user
+   data.
+ * Freed Data Leak Attacks: removing an encryption key from the
+   hardware mitigates future user information disclosure.
+
+The next set are attacks that depend on specialized hardware,
+such as an “evil DIMM” or a DDR interposer:
+
+ * Cross-Domain Replay Attack: data is captured from one domain
+(guest) and replayed to another at a later time.
+ * Cross-Domain Capture and Delayed Compare Attack: data is
+   captured and later analyzed to discover secrets.
+ * Key Wear-out Attack: data is captured and analyzed in order
+   to Weaken the AES encryption itself.
+
+More details on these attacks are below.
+
+Kernel Mapping Attacks
+----------------------
+Information disclosure vulnerabilities leverage the kernel direct
+map because many vulnerabilities involve manipulation of kernel
+data structures (examples: CVE-2017-7277, CVE-2017-9605).  We
+normally think of these bugs as leaking valuable *kernel* data,
+but they can leak application data when application pages are
+recycled for kernel use.
+
+With this MKTME implementation, there is a direct map created for
+each MKTME KeyID which is used whenever the kernel needs to
+access plaintext.  But, all kernel data structures are accessed
+via the direct map for KeyID-0.  Thus, memory reads which are not
+coordinated with the KeyID get garbage (for example, accessing
+KeyID-4 data with the KeyID-0 mapping).
+
+This means that if sensitive data encrypted using MKTME is leaked
+via the KeyID-0 direct map, ciphertext decrypted with the wrong
+key will be disclosed.  To disclose plaintext, an attacker must
+“pivot” to the correct direct mapping, which is non-trivial
+because there are no kernel data structures in the KeyID!=0
+direct mapping.
+
+Freed Data Leak Attack
+----------------------
+The kernel has a history of bugs around uninitialized data.
+Usually, we think of these bugs as leaking sensitive kernel data,
+but they can also be used to leak application secrets.
+
+MKTME can help mitigate the case where application secrets are
+leaked:
+
+ * App (or VM) places a secret in a page * App exits or frees
+memory to kernel allocator * Page added to allocator free list *
+Attacker reallocates page to a purpose where it can read the page
+
+Now, imagine MKTME was in use on the memory being leaked.  The
+data can only be leaked as long as the key is programmed in the
+hardware.  If the key is de-programmed, like after all pages are
+freed after a guest is shut down, any future reads will just see
+ciphertext.
+
+Basically, the key is a convenient choke-point: you can be more
+confident that data encrypted with it is inaccessible once the
+key is removed.
+
+Cross-Domain Replay Attack
+--------------------------
+MKTME mitigates cross-domain replay attacks where an attacker
+replaces an encrypted block owned by one domain with a block
+owned by another domain.  MKTME does not prevent this replacement
+from occurring, but it does mitigate plaintext from being
+disclosed if the domains use different keys.
+
+With TME, the attack could be executed by:
+ * A victim places secret in memory, at a given physical address.
+   Note: AES-XTS is what restricts the attack to being performed
+   at a single physical address instead of across different
+   physical addresses
+ * Attacker captures victim secret’s ciphertext * Later on, after
+   victim frees the physical address, attacker gains ownership 
+ * Attacker puts the ciphertext at the address and get the secret
+   plaintext
+
+But, due to the presumably different keys used by the attacker
+and the victim, the attacker can not successfully decrypt old
+ciphertext.
+
+Cross-Domain Capture and Delayed Compare Attack
+-----------------------------------------------
+This is also referred to as a kind of dictionary attack.
+
+Similarly, MKTME protects against cross-domain capture-and-compare
+attacks.  Consider the following scenario:
+ * A victim places a secret in memory, at a known physical address
+ * Attacker captures victim’s ciphertext
+ * Attacker gains control of the target physical address, perhaps
+   after the victim’s VM is shut down or its memory reclaimed.
+ * Attacker computes and writes many possible plaintexts until new
+   ciphertext matches content captured previously.
+
+Secrets which have low (plaintext) entropy are more vulnerable to
+this attack because they reduce the number of possible plaintexts
+an attacker has to compute and write.
+
+The attack will not work if attacker and victim uses different
+keys.
+
+Key Wear-out Attack
+-------------------
+Repeated use of an encryption key might be used by an attacker to
+infer information about the key or the plaintext, weakening the
+encryption.  The higher the bandwidth of the encryption engine,
+the more vulnerable the key is to wear-out.  The MKTME memory
+encryption hardware works at the speed of the memory bus, which
+has high bandwidth.
+
+Such a weakness has been demonstrated[1] on a theoretical cipher
+with similar properties as AES-XTS.
+
+An attack would take the following steps:
+ * Victim system is using TME with AES-XTS-128
+ * Attacker repeatedly captures ciphertext/plaintext pairs (can
+   be Performed with online hardware attack like an interposer).
+ * Attacker compels repeated use of the key under attack for a
+   sustained time period without a system reboot[2].
+ * Attacker discovers a cipertext collision (two plaintexts
+   translating to the same ciphertext)
+ * Attacker can induce controlled modifications to the targeted
+   plaintext by modifying the colliding ciphertext
+
+MKTME mitigates key wear-out in two ways:
+ * Keys can be rotated periodically to mitigate wear-out.  Since
+   TME keys are generated at boot, rotation of TME keys requires a
+   reboot.  In contrast, MKTME allows rotation while the system is
+   booted.  An application could implement a policy to rotate keys
+   at a frequency which is not feasible to attack.
+ * In the case that MKTME is used to encrypt two guests’ memory
+   with two different keys, an attack on one guest’s key would not
+   weaken the key used in the second guest.
+
+--
+1. http://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf
+2. This sustained time required for an attack could vary from days
+   to years depending on the attacker’s goals.
-- 
2.20.1

