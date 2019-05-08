Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EAA17C44
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfEHOtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:49:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:59507 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbfEHOor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:45 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 08 May 2019 07:44:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 441E5B47; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 32/62] keys/mktme: Store MKTME payloads if cmdline parameter allows
Date:   Wed,  8 May 2019 17:43:52 +0300
Message-Id: <20190508144422.13171-33-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

MKTME (Multi-Key Total Memory Encryption) key payloads may include
data encryption keys, tweak keys, and additional entropy bits. These
are used to program the MKTME encryption hardware. By default, the
kernel destroys this payload data once the hardware is programmed.

However, in order to fully support Memory Hotplug, saving the key data
becomes important. The MKTME Key Service cannot allow a new memory
controller to come online unless it can program the Key Table to match
the Key Tables of all existing memory controllers.

With CPU generated keys (a.k.a. random keys or ephemeral keys) the
saving of user key data is not an issue. The kernel and MKTME hardware
can generate strong encryption keys without recalling any user supplied
data.

With USER directed keys (a.k.a. user type) saving the key programming
data (data and tweak key) becomes an issue. The data and tweak keys
are required to program those keys on a new physical package.

In preparation for adding support for onlining new memory:

   Add an 'mktme_key_store' where key payloads are stored.

   Add 'mktme_storekeys' kernel command line parameter that, when
   present, allows the kernel to store user type key payloads.

   Add 'mktme_bitmap_user_type' to recall when USER type keys are in
   use. If no USER type keys are currently in use, new memory
   may be brought online, despite the absence of 'mktme_storekeys'.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 .../admin-guide/kernel-parameters.rst         |  1 +
 .../admin-guide/kernel-parameters.txt         | 11 ++++
 security/keys/mktme_keys.c                    | 51 ++++++++++++++++++-
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.rst b/Documentation/admin-guide/kernel-parameters.rst
index b8d0bc07ed0a..1b62b86d0666 100644
--- a/Documentation/admin-guide/kernel-parameters.rst
+++ b/Documentation/admin-guide/kernel-parameters.rst
@@ -120,6 +120,7 @@ parameter is applicable::
 			Documentation/m68k/kernel-options.txt.
 	MDA	MDA console support is enabled.
 	MIPS	MIPS architecture is enabled.
+	MKTME	Multi-Key Total Memory Encryption is enabled.
 	MOUSE	Appropriate mouse support is enabled.
 	MSI	Message Signaled Interrupts (PCI).
 	MTD	MTD (Memory Technology Device) support is enabled.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2b8ee90bb644..38ea0ace9533 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2544,6 +2544,17 @@
 			in the "bleeding edge" mini2440 support kernel at
 			http://repo.or.cz/w/linux-2.6/mini2440.git
 
+	mktme_storekeys [X86, MKTME] When CONFIG_X86_INTEL_MKTME is set
+			this parameter allows the kernel to store the user
+			specified MKTME key payload. Storing this payload
+			means that the MKTME Key Service can always allow
+			the addition of new physical packages. If the
+			mktme_storekeys parameter is not present, users key
+			data will not be stored, and new physical packages
+			may only be added to the system if no user type
+			MKTME keys are programmed.
+			See Documentation/x86/mktme.rst
+
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
 			parameter allows control of the logging verbosity for
diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 4b2d3dc1843a..bcd68850048f 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -22,6 +22,9 @@ static DEFINE_SPINLOCK(mktme_lock);
 struct kmem_cache *mktme_prog_cache;	/* Hardware programming cache */
 unsigned long *mktme_target_map;	/* Pconfig programming targets */
 cpumask_var_t mktme_leadcpus;		/* One lead CPU per pconfig target */
+static bool mktme_storekeys;		/* True if key payloads may be stored */
+unsigned long *mktme_bitmap_user_type;	/* Shows presence of user type keys */
+struct mktme_payload *mktme_key_store;	/* Payload storage if allowed */
 
 /* 1:1 Mapping between Userspace Keys (struct key) and Hardware KeyIDs */
 struct mktme_mapping {
@@ -124,6 +127,27 @@ struct mktme_payload {
 	u8		tweak_key[MKTME_AES_XTS_SIZE];
 };
 
+void mktme_store_payload(int keyid, struct mktme_payload *payload)
+{
+	/* Always remember if this key is of type "user" */
+	if ((payload->keyid_ctrl & 0xff) == MKTME_KEYID_SET_KEY_DIRECT)
+		set_bit(keyid, mktme_bitmap_user_type);
+	/*
+	 * Always store the control fields to program newly
+	 * onlined packages with RANDOM or NO_ENCRYPT keys.
+	 */
+	mktme_key_store[keyid].keyid_ctrl = payload->keyid_ctrl;
+
+	/* Only store "user" type data and tweak keys if allowed */
+	if (mktme_storekeys &&
+	    ((payload->keyid_ctrl & 0xff) == MKTME_KEYID_SET_KEY_DIRECT)) {
+		memcpy(mktme_key_store[keyid].data_key, payload->data_key,
+		       MKTME_AES_XTS_SIZE);
+		memcpy(mktme_key_store[keyid].tweak_key, payload->tweak_key,
+		       MKTME_AES_XTS_SIZE);
+	}
+}
+
 struct mktme_hw_program_info {
 	struct mktme_key_program *key_program;
 	int *status;
@@ -270,9 +294,10 @@ int mktme_instantiate_key(struct key *key, struct key_preparsed_payload *prep)
 			    0, GFP_KERNEL))
 		goto err_out;
 
-	if (!mktme_program_keyid(keyid, payload))
+	if (!mktme_program_keyid(keyid, payload)) {
+		mktme_store_payload(keyid, payload);
 		return MKTME_PROG_SUCCESS;
-
+	}
 	percpu_ref_exit(&encrypt_count[keyid]);
 err_out:
 	spin_lock_irqsave(&mktme_lock, flags);
@@ -487,10 +512,25 @@ static int __init init_mktme(void)
 	if (!encrypt_count)
 		goto free_targets;
 
+	/* Detect presence of user type keys */
+	mktme_bitmap_user_type = bitmap_zalloc(mktme_nr_keyids, GFP_KERNEL);
+	if (!mktme_bitmap_user_type)
+		goto free_encrypt;
+
+	/* Store key payloads if allowable */
+	mktme_key_store = kzalloc(sizeof(mktme_key_store[0]) *
+				   (mktme_nr_keyids + 1), GFP_KERNEL);
+	if (!mktme_key_store)
+		goto free_bitmap;
+
 	ret = register_key_type(&key_type_mktme);
 	if (!ret)
 		return ret;			/* SUCCESS */
 
+	kfree(mktme_key_store);
+free_bitmap:
+	bitmap_free(mktme_bitmap_user_type);
+free_encrypt:
 	kvfree(encrypt_count);
 free_targets:
 	free_cpumask_var(mktme_leadcpus);
@@ -504,3 +544,10 @@ static int __init init_mktme(void)
 }
 
 late_initcall(init_mktme);
+
+static int mktme_enable_storekeys(char *__unused)
+{
+	mktme_storekeys = true;
+	return 1;
+}
+__setup("mktme_storekeys", mktme_enable_storekeys);
-- 
2.20.1

