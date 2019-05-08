Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F19117C01
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfEHOrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:47:08 -0400
Received: from mga07.intel.com ([134.134.136.100]:33094 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbfEHOow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:51 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2019 07:44:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 269641075; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 48/62] selftests/x86/mktme: Test the MKTME APIs
Date:   Wed,  8 May 2019 17:44:08 +0300
Message-Id: <20190508144422.13171-49-kirill.shutemov@linux.intel.com>
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

This is a draft for poweron testing.
I'm assuming it needs to be in Intel-next to be available for poweron.

It is not in the selftest Makefiles.
COMPILE w keyutils library ==>  cc -o mktest mktme_test.c -lkeyutils

Usage: mktme_test [options]...
-a                      Run ALL tests
-t <testnum>            Run one <testnum> test
-l                      List available tests
-h, -?                  Show this help

mktest -l
[ 1] Keys: Add each type key
[ 2] Flow: One simple roundtrip
[ 3] Keys: Valid Payload Options
[ 4] Keys: Invalid Payload Options
[ 5] Keys: Add Key Descriptor Field
[ 6] Keys: Add Multiple Same
[ 7] Keys: Change payload, auto update
[ 8] Keys: Update, explicit update
[ 9] Keys: Update, Clear
[10] Keys: Add, Invalidate Keys
[11] Keys: Add, Revoke Keys
[12] Keys: Keyctl Describe
[13] Keys: Clear
[14] Keys: No Encrypt
[15] Keys: Unique KeyIDs
[16] Keys: Get Max KeyIDs
[17] Encrypt: Parameter Alignment
[18] Encrypt: Change Protections
[19] Encrypt: Swap Keys
[20] Encrypt: Counters Same Key
[21] Encrypt: Counters Diff Key
[22] Encrypt: Counters Holes
[23] Flow: Switch key no data
[24] Flow: Switch key multi VMAs
[25] Flow: Switch No Key to Any Key
[26] Flow: madvise
[27] Flow: Invalidate In Use Key

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 .../selftests/x86/mktme/encrypt_tests.c       | 433 ++++++++++++++
 .../testing/selftests/x86/mktme/flow_tests.c  | 266 +++++++++
 tools/testing/selftests/x86/mktme/key_tests.c | 526 ++++++++++++++++++
 .../testing/selftests/x86/mktme/mktme_test.c  | 300 ++++++++++
 4 files changed, 1525 insertions(+)
 create mode 100644 tools/testing/selftests/x86/mktme/encrypt_tests.c
 create mode 100644 tools/testing/selftests/x86/mktme/flow_tests.c
 create mode 100644 tools/testing/selftests/x86/mktme/key_tests.c
 create mode 100644 tools/testing/selftests/x86/mktme/mktme_test.c

diff --git a/tools/testing/selftests/x86/mktme/encrypt_tests.c b/tools/testing/selftests/x86/mktme/encrypt_tests.c
new file mode 100644
index 000000000000..735d5da89d29
--- /dev/null
+++ b/tools/testing/selftests/x86/mktme/encrypt_tests.c
@@ -0,0 +1,433 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* x86 MKTME Encrypt API Tests */
+
+/* Address & length parameters to encrypt_mprotect() must be page aligned */
+void test_param_alignment(void)
+{
+	size_t datalen = PAGE_SIZE * 2;
+	key_serial_t key;
+	int ret, i;
+	char *buf;
+
+	key = add_key("mktme", "keyname", options_CPU_long,
+		      strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+
+	if (key == -1) {
+		perror("test_param_alignment");
+		return;
+	}
+	buf = (char *)mmap(NULL, datalen, PROT_NONE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+
+	/* Fail if addr is not page aligned */
+	ret = syscall(sys_encrypt_mprotect, buf + 100, datalen / 2, PROT_NONE,
+		      key);
+	if (!ret)
+		fprintf(stderr, "Error: addr is not page aligned\n");
+
+	/* Fail if len is not page aligned */
+	ret = syscall(sys_encrypt_mprotect, buf, 9, PROT_NONE, key);
+	if (!ret)
+		fprintf(stderr, "Error: len is not page aligned.");
+
+	/* Fail if both addr and len are not page aligned */
+	ret = syscall(sys_encrypt_mprotect, buf + 100, datalen + 100,
+		      PROT_READ | PROT_WRITE, key);
+	if (!ret)
+		fprintf(stderr, "Error: addr and len are not page aligned\n");
+
+	/* Success if both addr and len are page aligned */
+	ret = syscall(sys_encrypt_mprotect, buf, datalen,
+		      PROT_READ | PROT_WRITE, key);
+
+	if (ret)
+		fprintf(stderr, "Fail: addr and len are both page aligned\n");
+
+	ret = munmap(buf, datalen);
+
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Error: invalidate failed on key [%d]\n", key);
+}
+
+/*
+ * Do encrypt_mprotect and follow with classic mprotects.
+ * KeyID should remain unchanged.
+ */
+void test_change_protections(void)
+{
+	unsigned int keyid, check_keyid;
+	key_serial_t key;
+	void *ptra;
+	int ret, i;
+
+	const int prots[] = {
+		PROT_NONE, PROT_READ, PROT_WRITE, PROT_EXEC,
+		PROT_READ | PROT_WRITE, PROT_READ | PROT_EXEC,
+	};
+
+	key = add_key("mktme", "testkey", options_CPU_long,
+		      strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+	if (key == -1) {
+		perror(__func__);
+		return;
+	}
+	ptra = mmap(NULL, PAGE_SIZE, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE,
+		    -1, 0);
+	if (!ptra) {
+		fprintf(stderr, "Error: mmap failed.");
+		goto revoke_key;
+	}
+	/* Encrypt Memory */
+	ret = syscall(sys_encrypt_mprotect, ptra, PAGE_SIZE, PROT_NONE, key);
+	if (ret)
+		fprintf(stderr, "Error: encrypt_mprotect [%d]\n", ret);
+
+	/* Remember the assigned KeyID */
+	keyid = find_smaps_keyid((unsigned long)ptra);
+
+	/* Classic mprotects()  should not change KeyID. */
+	for (i = 0; i < ARRAY_SIZE(prots); i++) {
+		ret = mprotect(ptra, PAGE_SIZE, prots[i]);
+		if (ret)
+			fprintf(stderr, "Error: encrypt_mprotect [%d]\n", ret);
+
+		check_keyid = find_smaps_keyid((unsigned long)ptra);
+		if (keyid != check_keyid)
+			fprintf(stderr, "Error: keyid change not expected\n");
+	};
+free_memory:
+	ret = munmap(ptra, PAGE_SIZE);
+revoke_key:
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Error: invalidate failed. [%d]\n", key);
+}
+
+/*
+ * Make one mapping and create a bunch of keys.
+ * Encrypt that one mapping repeatedly with different keys.
+ * Verify the KeyID changes in smaps.
+ */
+void test_key_swap(void)
+{
+	unsigned int prev_keyid, next_keyid;
+	int maxswaps = max_keyids / 2;		/* Not too many swaps */
+	key_serial_t key[maxswaps];
+	long size = PAGE_SIZE;
+	int keys_available = 0;
+	char name[12];
+	void *ptra;
+	int i, ret;
+
+	for (i = 0; i < maxswaps; i++) {
+		sprintf(name, "mk_swap_%d", i);
+		key[i] = add_key("mktme", name, options_CPU_long,
+				 strlen(options_CPU_long),
+				 KEY_SPEC_THREAD_KEYRING);
+		if (key[i] == -1) {
+			perror(__func__);
+			goto free_keys;
+		} else {
+			keys_available++;
+		}
+	}
+
+	printf("     Info: created %d keys\n", keys_available);
+	ptra = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (!ptra) {
+		perror("mmap");
+		goto free_keys;
+	}
+	prev_keyid = 0;
+
+	for (i = 0; i < keys_available; i++) {
+		ret = syscall(sys_encrypt_mprotect, ptra, size,
+			      PROT_NONE, key[i]);
+		if (ret) {
+			perror("encrypt_mprotect");
+			goto free_memory;
+		}
+
+		next_keyid = find_smaps_keyid((unsigned long)ptra);
+		if (prev_keyid == next_keyid)
+			fprintf(stderr, "Error %s: expected new keyid\n",
+				__func__);
+		prev_keyid = next_keyid;
+	}
+free_memory:
+	ret = munmap(ptra, size);
+
+free_keys:
+	for (i = 0; i < keys_available; i++) {
+		if (keyctl(KEYCTL_INVALIDATE, key[i]) == -1)
+			perror(__func__);
+	}
+}
+
+/*
+ * These may not be doing as orig planned. Need to check that key is
+ * invalidated and then gets destroyed when last map is removed.
+ */
+void test_counters_same(void)
+{
+	key_serial_t key;
+	int count = 4;
+	void *ptr[count];
+	int ret, i;
+
+	/* Get 4 pieces of memory */
+	i = count;
+	while (i--) {
+		ptr[i] = mmap(NULL, PAGE_SIZE, PROT_NONE,
+			      MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		if (!ptr[i])
+			perror("mmap");
+	}
+	/* Protect with same key */
+	key = add_key("mktme", "mk_same", options_USER, strlen(options_USER),
+		      KEY_SPEC_THREAD_KEYRING);
+
+	if (key == -1) {
+		perror("add_key");
+		goto free_mem;
+	}
+	i = count;
+	while (i--) {
+		ret = syscall(sys_encrypt_mprotect, ptr[i], PAGE_SIZE,
+			      PROT_NONE, key);
+		if (ret)
+			perror("encrypt_mprotect");
+	}
+	/* Discard Key & Unmap Memory (order irrelevant) */
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Error: invalidate failed.\n");
+free_mem:
+	i = count;
+	while (i--)
+		ret = munmap(ptr[i], PAGE_SIZE);
+}
+
+void test_counters_diff(void)
+{
+	int prot = PROT_READ | PROT_WRITE;
+	long size = PAGE_SIZE;
+	int ret, i;
+	int loop = 4;
+	char name[12];
+	void *ptr[loop];
+	key_serial_t diffkey[loop];
+
+	i = loop;
+	while (i--)
+		ptr[i] = mmap(NULL, size, prot, MAP_ANONYMOUS | MAP_PRIVATE,
+			      -1, 0);
+	i = loop;
+	while (i--) {
+		sprintf(name, "cheese_%d", i);
+		diffkey[i] = add_key("mktme", name, options_USER,
+				     strlen(options_USER),
+				     KEY_SPEC_THREAD_KEYRING);
+		ret = syscall(sys_encrypt_mprotect, ptr[i], size, prot,
+			      diffkey[i]);
+		if (ret)
+			perror("encrypt_mprotect");
+	}
+
+	i = loop;
+	while (i--)
+		ret = munmap(ptr[i], PAGE_SIZE);
+
+	i = loop;
+	while (i--) {
+		if (keyctl(KEYCTL_INVALIDATE, diffkey[i]) == -1)
+			fprintf(stderr, "Error: invalidate failed key:%d\n",
+				diffkey[i]);
+	}
+}
+
+void test_counters_holes(void)
+{
+	int prot = PROT_READ | PROT_WRITE;
+	long size = PAGE_SIZE;
+	int ret, i;
+	int loop = 6;
+	void *ptr[loop];
+	key_serial_t samekey;
+
+	samekey = add_key("mktme", "gouda", options_CPU_long,
+			  strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+
+	i = loop;
+	while (i--) {
+		ptr[i] = mmap(NULL, size, prot, MAP_ANONYMOUS | MAP_PRIVATE,
+			      -1, 0);
+		if (i % 2) {
+			ret = syscall(sys_encrypt_mprotect, ptr[i], size, prot,
+				      samekey);
+			if (ret)
+				perror("mprotect error");
+		}
+	}
+
+	i = loop;
+	while (i--)
+		ret = munmap(ptr[i], size);
+
+	if (keyctl(KEYCTL_INVALIDATE, samekey) == -1)
+		fprintf(stderr, "Error: invalidate failed\n");
+}
+
+/*
+ * Try on SIMICs. See is SIMICs 'a1a1' thing does the trick.
+ * May need real hardware.
+ * One buffer  -> encrypt entirety w one key
+ * Same buffer -> encrypt in pieces w different keys
+ */
+void test_split(void)
+{
+	int prot = PROT_READ | PROT_WRITE;
+	int ret, i;
+	int pieces = 10;
+	size_t len = PAGE_SIZE;
+	char name[12];
+	char *buf;
+	key_serial_t firstkey;
+	key_serial_t diffkey[pieces];
+
+	/* get one piece of memory, protect it, memset it */
+	buf = (char *)mmap(NULL, len, PROT_NONE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+
+	firstkey = add_key("mktme", "firstkey", options_CPU_long,
+			   strlen(options_CPU_long),
+			   KEY_SPEC_THREAD_KEYRING);
+
+	ret = syscall(sys_encrypt_mprotect, buf, len, PROT_READ | PROT_WRITE,
+		      firstkey);
+
+	if (ret) {
+		printf("firstkey mprotect error:%d\n", ret);
+		goto free_mem;
+	}
+
+	memset(buf, 9, len);
+	/*
+	 * Encrypt pieces of buf with different encryption keys.
+	 * Expect to see the data in those pieces zero'd
+	 */
+	for (i = 0; i < pieces; i++) {
+		sprintf(name, "cheese_%d", i);
+		diffkey[i] = add_key("mktme", name, options_CPU_long,
+				     strlen(options_CPU_long),
+				     KEY_SPEC_THREAD_KEYRING);
+		ret = syscall(sys_encrypt_mprotect, (buf + (i * len)), len,
+			      PROT_READ | PROT_WRITE, diffkey[i]);
+		if (ret)
+			printf("diff key mprotect error:%d\n", ret);
+		else
+			printf("done protecting w i:%d key[%d]\n", i,
+			       diffkey[i]);
+	}
+	printf("SIMICs - this should NOT be all 'f's.\n");
+	for (i = 0; i < len; i++)
+		printf("-%x", buf[i]);
+	printf("\n");
+
+	getchar();
+	i = pieces;
+	for (i = 0; i < pieces; i++) {
+		if (keyctl(KEYCTL_INVALIDATE, diffkey[i]) == -1)
+			fprintf(stderr, "invalidate failed key:%d\n",
+				diffkey[i]);
+	}
+	if (keyctl(KEYCTL_INVALIDATE, firstkey) == -1)
+		fprintf(stderr, "invalidate failed on key:%d\n", firstkey);
+free_mem:
+	ret = munmap(buf, len);
+}
+
+void test_well_suited(void)
+{
+	int prot;
+	long size = PAGE_SIZE;
+	int ret, i;
+	int loop = 6;
+	void *ptr[loop];
+	key_serial_t key;
+	void *addr, *first;
+
+	/* mmap alternating protections so that we get loop# of vma's  */
+	i = loop;
+	/* map the first one */
+	first = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+
+	addr = first + PAGE_SIZE;
+	i--;
+	while (i--)  {
+		prot = (i % 2) ? PROT_READ : PROT_WRITE;
+		ptr[i] = mmap(addr, size, prot, MAP_ANONYMOUS | MAP_PRIVATE,
+			      -1, 0);
+		addr = addr + PAGE_SIZE;
+	}
+	/* Protect with same key */
+	key = add_key("mktme", "mk_suited954", options_USER,
+		      strlen(options_USER), KEY_SPEC_THREAD_KEYRING);
+
+	/* Changing FLAGS and adding KEY */
+	ret = syscall(sys_encrypt_mprotect, ptr[0], (loop * PAGE_SIZE),
+		      PROT_EXEC, key);
+	if (ret)
+		fprintf(stderr, "Error: encrypt_mprotect [%d]\n", ret);
+
+	i = loop;
+	while (i--)
+		ret = munmap(ptr[i], size);
+
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Error: invalidate failed\n");
+}
+
+void test_not_suited(int argc, char *argv[])
+{
+	int prot;
+	int protA = PROT_READ;
+	int protB = PROT_WRITE;
+	int flagsA = MAP_ANONYMOUS | MAP_PRIVATE;
+	int flagsB = MAP_SHARED | MAP_ANONYMOUS;
+	int flags;
+	int ret, i;
+	int loop = 6;
+	void *ptr[loop];
+	key_serial_t key;
+
+	printf("loop count [%d]\n", loop);
+
+	/* mmap alternating protections so that we get loop# of vma's  */
+	i = loop;
+	while (i--)  {
+		prot = (i % 2) ? PROT_READ : PROT_WRITE;
+		if (i == 2)
+			flags = flagsB;
+		else
+			flags = flagsA;
+		ptr[i] = mmap(NULL, PAGE_SIZE, prot, flags, -1, 0);
+	}
+
+	/* protect with same key */
+	key = add_key("mktme", "mk_notsuited", options_CPU_long,
+		      strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+
+	/* Changing FLAGS and adding KEY */
+	ret = syscall(sys_encrypt_mprotect, ptr[0], (loop * PAGE_SIZE),
+		      PROT_EXEC, key);
+	if (!ret)
+		fprintf(stderr, "Error: expected encrypt_mprotect to fail.\n");
+
+	i = loop;
+	while (i--)
+		ret = munmap(ptr[i], PAGE_SIZE);
+
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Error: invalidate failed.\n");
+}
+
diff --git a/tools/testing/selftests/x86/mktme/flow_tests.c b/tools/testing/selftests/x86/mktme/flow_tests.c
new file mode 100644
index 000000000000..87b17d3bf142
--- /dev/null
+++ b/tools/testing/selftests/x86/mktme/flow_tests.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * x86 MKTME:  API Tests
+ *
+ * Flow Tests either
+ *	1) Validate some interaction between the 2 API's: Key & Encrypt
+ *	2) or, Validate code flows, scenarios, known/fixed issues.
+ */
+
+/*
+ * Userspace Keys with outstanding memory mappings can be discarded,
+ * (discarded == revoke, invalidate, expire, unlink)
+ * The paired KeyID will not be freed for reuse until the last memory
+ * mapping is unmapped.
+ */
+void test_discard_in_use_key(void)
+{
+	key_serial_t key;
+	void *ptra;
+	int ret;
+
+	key = add_key("mktme", "discard-test", options_CPU_long,
+		      strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+
+	if (key == -1) {
+		perror("add key");
+		return;
+	}
+	ptra = mmap(NULL, PAGE_SIZE, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE,
+		    -1, 0);
+	if (!ptra) {
+		fprintf(stderr, "Error: mmap failed. ");
+		if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+			fprintf(stderr, "Error: invalidate failed. Key:%d\n",
+				key);
+		return;
+	}
+	ret = syscall(sys_encrypt_mprotect, ptra, PAGE_SIZE, PROT_NONE, key);
+	if (ret) {
+		fprintf(stderr, "Error: encrypt_mprotect: %d\n", ret);
+		goto free_memory;
+	}
+	if (keyctl(KEYCTL_INVALIDATE, key) != 0)
+		fprintf(stderr, "Error: test_revoke_in_use_key\n");
+free_memory:
+	ret = munmap(ptra, PAGE_SIZE);
+}
+
+/* TODO: Can this be made useful? Used to reproduce a trace in Kai's setup. */
+void test_kai_madvise(void)
+{
+	key_serial_t key;
+	void *ptra;
+	int ret;
+
+	key = add_key("mktme", "testkey", options_USER, strlen(options_USER),
+		      KEY_SPEC_THREAD_KEYRING);
+
+	if (key == -1) {
+		perror("add_key");
+		return;
+	}
+
+	/* TODO wanted MAP_FIXED here - but kept failing to mmap */
+	ptra = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (!ptra) {
+		perror("failed to mmap");
+		goto revoke_key;
+	}
+
+	ret = madvise(ptra, PAGE_SIZE, MADV_MERGEABLE);
+	if (ret)
+		perror("madvise err mergeable");
+
+	if ((madvise(ptra, PAGE_SIZE, MADV_HUGEPAGE)) != 0)
+		perror("madvise err hugepage");
+
+	if ((madvise(ptra, PAGE_SIZE, MADV_DONTFORK)) != 0)
+		perror("madvise err dontfork");
+
+	ret = syscall(sys_encrypt_mprotect, ptra, PAGE_SIZE, PROT_NONE, key);
+	if (ret)
+		perror("mprotect error");
+
+	ret = munmap(ptra, PAGE_SIZE);
+revoke_key:
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "invalidate failed on key [%d]\n", key);
+}
+
+void test_one_simple_round_trip(void)
+{
+	long size = PAGE_SIZE * 10;
+	key_serial_t key;
+	void *ptra;
+	int ret;
+
+	key = add_key("mktme", "testkey", options_USER, strlen(options_USER),
+		      KEY_SPEC_THREAD_KEYRING);
+
+	if (key == -1) {
+		perror("add_key");
+		return;
+	}
+
+	ptra = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (!ptra) {
+		perror("failed to mmap");
+		goto revoke_key;
+	}
+
+	ret = syscall(sys_encrypt_mprotect, ptra, size, PROT_NONE, key);
+	if (ret)
+		perror("mprotect error");
+
+	ret = munmap(ptra, size);
+revoke_key:
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "revoke failed on key [%d]\n", key);
+}
+
+void test_switch_key_no_data(void)
+{
+	key_serial_t keyA, keyB;
+	int ret, i;
+	void *buf;
+
+	/*
+	 * Program 2 keys: Protect with one, protect with other
+	 */
+	keyA = add_key("mktme", "keyA", options_USER, strlen(options_USER),
+		       KEY_SPEC_THREAD_KEYRING);
+	if (keyA == -1) {
+		perror("add_key");
+		return;
+	}
+	keyB = add_key("mktme", "keyB", options_CPU_long,
+		       strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+	if (keyB == -1) {
+		perror("add_key");
+		return;
+	}
+	buf = mmap(NULL, PAGE_SIZE, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE,
+		   -1, 0);
+	if (!buf) {
+		perror("mmap error");
+		goto revoke_key;
+	}
+	ret = syscall(sys_encrypt_mprotect, buf, PAGE_SIZE, PROT_NONE, keyA);
+	if (ret)
+		perror("mprotect error");
+
+	ret = syscall(sys_encrypt_mprotect, buf, PAGE_SIZE, PROT_NONE, keyB);
+	if (ret)
+		perror("mprotect error");
+
+free_memory:
+	ret = munmap(buf, PAGE_SIZE);
+revoke_key:
+	if (keyctl(KEYCTL_INVALIDATE, keyA) == -1)
+		printf("revoke failed on key [%d]\n", keyA);
+	if (keyctl(KEYCTL_INVALIDATE, keyB) == -1)
+		printf("revoke failed on key [%d]\n", keyB);
+}
+
+void test_switch_key_mult_vmas(void)
+{
+	int prot = PROT_READ | PROT_WRITE;
+	long size = PAGE_SIZE;
+	int ret, i;
+	int loop = 12;
+	void *ptr[loop];
+	key_serial_t firstkey;
+	key_serial_t nextkey;
+
+	firstkey = add_key("mktme", "gouda", options_CPU_long,
+			   strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+	nextkey = add_key("mktme", "ricotta", options_CPU_long,
+			  strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+
+	i = loop;
+	while (i--) {
+		ptr[i] = mmap(NULL, size, PROT_NONE,
+			      MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		if (i % 2) {
+			ret = syscall(sys_encrypt_mprotect, ptr[i],
+				      size, prot, firstkey);
+			if (ret)
+				perror("mprotect error");
+		}
+	}
+	i = loop;
+	while (i--) {
+		if (i % 2) {
+			ret = syscall(sys_encrypt_mprotect, ptr[i], size, prot,
+				      nextkey);
+			if (ret)
+				perror("mprotect error");
+		}
+	}
+	i = loop;
+	while (i--)
+		ret = munmap(ptr[i], size);
+
+	if (keyctl(KEYCTL_INVALIDATE, nextkey) == -1)
+		fprintf(stderr, "invalidate failed key %d\n", nextkey);
+	if (keyctl(KEYCTL_INVALIDATE, firstkey) == -1)
+		fprintf(stderr, "invalidate failed key %d\n", firstkey);
+}
+
+/* Write to buf with no encrypt key, then encrypt buf */
+void test_switch_key0_to_key(void)
+{
+	key_serial_t key;
+	size_t datalen = PAGE_SIZE;
+	char *buf_1, *buf_2;
+	int ret, i;
+
+	key = add_key("mktme", "keyA", options_USER, strlen(options_USER),
+		      KEY_SPEC_THREAD_KEYRING);
+	if (key == -1) {
+		perror("add_key");
+		return;
+	}
+	buf_1 = (char *)mmap(NULL, datalen, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (!buf_1) {
+		perror("failed to mmap");
+		goto inval_key;
+	}
+	buf_2 = (char *)mmap(NULL, datalen, PROT_READ | PROT_WRITE,
+			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (!buf_2) {
+		perror("failed to mmap");
+		goto inval_key;
+	}
+	memset(buf_1, 9, datalen);
+	memset(buf_2, 9, datalen);
+
+	ret = syscall(sys_encrypt_mprotect, buf_1, datalen,
+		      PROT_READ | PROT_WRITE, key);
+	if (ret)
+		perror("mprotect error");
+
+	if (!memcmp(buf_1, buf_2, sizeof(buf_1)))
+		fprintf(stderr, "Error: bufs should not have matched\n");
+
+free_memory:
+	ret = munmap(buf_1, datalen);
+	ret = munmap(buf_2, datalen);
+inval_key:
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "invalidate failed on key [%d]\n", key);
+}
+
+void test_zero_page(void)
+{
+	/*
+	 * write access to the zero page, gets replaced with a newly
+	 * allocated page.
+	 * Can this be seen in smaps?
+	 */
+}
+
diff --git a/tools/testing/selftests/x86/mktme/key_tests.c b/tools/testing/selftests/x86/mktme/key_tests.c
new file mode 100644
index 000000000000..ff4c18dbf533
--- /dev/null
+++ b/tools/testing/selftests/x86/mktme/key_tests.c
@@ -0,0 +1,526 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ *  Testing payload options
+ *
+ *  Invalid options should return -EINVAL, not a Key.
+ *  TODO This is just checking for the Key.
+ *       Add a check for the actual -EINVAL return.
+ *
+ *  Invalid option cases are grouped based on why they are invalid.
+ *  Valid option cases are one large array of expected goodness
+ *
+ */
+const char *bad_type_tail = "algorithm=aes-xts-128 key=12345678123456781234567812345678 tweak=12345678123456781234567812345678";
+const char *bad_type[] = {
+	"type=",			/* missing */
+	"type=cpu, type=cpu",		/* duplicate good */
+	"type=cpu, type=user",
+	"type=user, type=user",
+	"type=user, type=cpu",
+	"type=cp",			/* spelling */
+	"type=cpus",
+	"type=pu",
+	"type=cpucpu",
+	"type=useruser",
+	"type=use",
+	"type=users",
+	"type=used",
+	"type=User",			/* case */
+	"type=USER",
+	"type=UsEr",
+	"type=CPU",
+	"type=Cpu",
+};
+
+const char *bad_alg_tail = "type=cpu";
+const char *bad_algorithm[] = {
+	"algorithm=",
+	"algorithm=aes-xts-12",
+	"algorithm=aes-xts-128aes-xts-128",
+	"algorithm=es-xts-128",
+	"algorithm=bad",
+	"algorithm=aes-xts-128-xxxx",
+	"algorithm=xxx-aes-xts-128",
+};
+
+const char *bad_key_tail = "type=cpu algorithm=aes-xts-128 tweak=12345678123456781234567812345678";
+const char *bad_key[] = {
+	"key=",
+	"key=0",
+	"key=ababababababab",
+	"key=blah",
+	"key=0123333456789abcdef",
+	"key=abracadabra",
+	"key=-1",
+};
+
+const char *bad_tweak_tail = "type=cpu algorithm=aes-xts-128 key=12345678123456781234567812345678";
+const char *bad_tweak[] = {
+	"tweak=",
+	"tweak=ab",
+	"tweak=bad",
+	"tweak=-1",
+	"tweak=000000000000000",
+};
+
+/* Bad, missing, repeating tokens and bad overall payload length */
+const char *bad_other[] = {
+	"",
+	" ",
+	"a ",
+	"algorithm= tweak= type= key=",
+	"key=aaaaaaaaaaaaaaaa tweak=aaaaaaaaaaaaaaaa type=cpu",
+	"algorithm=aes-xts-128 tweak=0000000000000000 tweak=aaaaaaaaaaaaaaaa key=0000000000000000  type=cpu",
+	"algorithm=aes-xts-128 tweak=0000000000000000 key=0000000000000000 key=0000000000000000 type=cpu",
+	"algorithm=aes-xts-128 tweak=0000000000000000 key=0000000000000000  type=cpu type=cpu",
+	"algorithm=aes-xts-128 tweak=0000000000000000 key=0000000000000000  type=cpu type=user",
+	"tweak=0000000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
+};
+
+void test_invalid_options(const char *bad_options[], unsigned int size,
+			  const char *good_tail, char *descrip)
+{
+	key_serial_t key[size];
+	char options[512];
+	char name[15];
+	int i, ret;
+
+	for (i = 0; i < size; i++) {
+		sprintf(name, "mk_inv_%d", i);
+		sprintf(options, "%s %s", bad_options[i], good_tail);
+
+		key[i] = add_key("mktme", name, options,
+				 strlen(options),
+				 KEY_SPEC_THREAD_KEYRING);
+		if (key[i] > 0)
+			fprintf(stderr, "Error %s: [%s] accepted.\n",
+				descrip, bad_options[i]);
+	}
+	for (i = 0; i < size; i++) {
+		if (key[i] > 0) {
+			ret = keyctl(KEYCTL_INVALIDATE, key[i]);
+			if (ret == -1)
+				fprintf(stderr, "Key invalidate failed: [%d]\n",
+					key[i]);
+		}
+	}
+}
+
+void test_keys_invalid_options(void)
+{
+	test_invalid_options(bad_type, ARRAY_SIZE(bad_type),
+			     bad_type_tail, "Invalid Type Option");
+	test_invalid_options(bad_algorithm, ARRAY_SIZE(bad_algorithm),
+			     bad_alg_tail, "Invalid Algorithm Option");
+	test_invalid_options(bad_key, ARRAY_SIZE(bad_key),
+			     bad_key_tail, "Invalid Key Option");
+	test_invalid_options(bad_tweak, ARRAY_SIZE(bad_tweak),
+			     bad_tweak_tail, "Invalid Tweak Option");
+	test_invalid_options(bad_other, ARRAY_SIZE(bad_other),
+			     NULL, "Invalid Option");
+}
+
+const char *valid_options[] = {
+	"algorithm=aes-xts-128 type=user key=0123456789abcdef0123456789abcdef tweak=abababababababababababababababab",
+	"algorithm=aes-xts-128 type=user tweak=0123456789abcdef0123456789abcdef key=abababababababababababababababab",
+	"algorithm=aes-xts-128 type=user key=01010101010101010101010101010101 tweak=0123456789abcdef0123456789abcdef",
+	"algorithm=aes-xts-128 tweak=01010101010101010101010101010101 type=user key=0123456789abcdef0123456789abcdef",
+	"algorithm=aes-xts-128 key=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa tweak=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa type=user",
+	"algorithm=aes-xts-128 tweak=aaaaaaaaaaaaaaaa0000000000000000 key=aaaaaaaaaaaaaaaa0000000000000000  type=user",
+	"algorithm=aes-xts-128 type=cpu key=aaaaaaaaaaaaaaaa0123456789abcdef tweak=abababaaaaaaaaaaaaaaaaababababab",
+	"algorithm=aes-xts-128 type=cpu tweak=0123456aaaaaaaaaaaaaaaa789abcdef key=abababaaaaaaaaaaaaaaaaababababab",
+	"algorithm=aes-xts-128 type=cpu key=010101aaaaaaaaaaaaaaaa0101010101 tweak=01234567aaaaaaaaaaaaaaaa89abcdef",
+	"algorithm=aes-xts-128 tweak=01010101aaaaaaaaaaaaaaaa01010101 type=cpu key=012345aaaaaaaaaaaaaaaa6789abcdef",
+	"algorithm=aes-xts-128 key=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa tweak=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa type=cpu",
+	"algorithm=aes-xts-128 tweak=00000000000000000000000000000000 type=cpu",
+	"algorithm=aes-xts-128 key=00000000000000000000000000000000 type=cpu",
+	"algorithm=aes-xts-128 type=cpu",
+	"algorithm=aes-xts-128 tweak=00000000000000000000000000000000 key=00000000000000000000000000000000 type=cpu",
+	"algorithm=aes-xts-128 tweak=00000000000000000000000000000000 key=00000000000000000000000000000000 type=cpu",
+};
+
+void test_keys_valid_options(void)
+{
+	char name[15];
+	int i, ret;
+	key_serial_t key[ARRAY_SIZE(valid_options)];
+
+	for (i = 0; i < ARRAY_SIZE(valid_options); i++) {
+		sprintf(name, "mk_val_%d", i);
+		key[i] = add_key("mktme", name, valid_options[i],
+				 strlen(valid_options[i]),
+				 KEY_SPEC_THREAD_KEYRING);
+		if (key[i] <= 0)
+			fprintf(stderr, "Fail valid option: [%s]\n",
+				valid_options[i]);
+	}
+	for (i = 0; i < ARRAY_SIZE(valid_options); i++) {
+		if (key[i] > 0) {
+			ret = keyctl(KEYCTL_INVALIDATE, key[i]);
+			if (ret)
+				fprintf(stderr, "Invalidate failed key[%d]\n",
+					key[i]);
+		}
+	}
+}
+
+/*
+ *  key_serial_t add_key(const char *type, const char *description,
+ *			 const void *payload, size_t plen,
+ *			 key_serial_t keyring);
+ *
+ *  The Kernel Key Service should validate this. But, let's validate
+ *  some basic syntax. MKTME Keys does NOT propose a description based
+ *  on type and payload if no description is provided. (Some other key
+ *  types do make that 'proposal'.)
+ */
+
+void test_keys_descriptor(void)
+{
+	key_serial_t key;
+
+	key = add_key("mktme", NULL, options_CPU_long, strlen(options_CPU_long),
+		      KEY_SPEC_THREAD_KEYRING);
+
+	if (errno != EINVAL)
+		fprintf(stderr, "Fail: expected EINVAL with NULL descriptor\n");
+
+	if (key > 0)
+		if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+			fprintf(stderr, "Key invalidate failed: %s\n",
+				strerror(errno));
+
+	key = add_key("mktme", "", options_CPU_long, strlen(options_CPU_long),
+		      KEY_SPEC_THREAD_KEYRING);
+
+	if (errno != EINVAL)
+		fprintf(stderr,
+			"Fail: expected EINVAL with empty descriptor\n");
+
+	if (key > 0)
+		if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+			fprintf(stderr, "Key invalidate failed: %s\n",
+				strerror(errno));
+}
+
+/*
+ * Test: Add multiple keys with with same descriptor
+ *
+ * Expect that the same Key Handle (key_serial_t) will be returned
+ * on each subsequent request for the same key. This is treated like
+ * a key update.
+ */
+
+void test_keys_add_mult_same(void)
+{
+	int i, inval, num_keys = 5;
+	key_serial_t key[num_keys];
+
+	for (i = 1; i <= num_keys; i++) {
+		key[i] = add_key("mktme", "multiple_keys",
+				 options_USER,
+				 strlen(options_USER),
+				 KEY_SPEC_THREAD_KEYRING);
+
+		if (i > 1)
+			if (key[i] != key[i - 1]) {
+				fprintf(stderr, "Fail: expected same key.\n");
+				inval = i;    /* maybe i keys to invalidate */
+				goto out;
+			}
+	}
+	inval = 1;    /* if all works correctly, only 1 key to invalidate */
+out:
+	for (i = 1; i <= inval; i++) {
+		if (keyctl(KEYCTL_INVALIDATE, key[i]) == -1)
+			fprintf(stderr, "Key invalidate failed: %s\n",
+				strerror(errno));
+	}
+}
+
+/*
+ * Add two keys with the same descriptor but different payloads.
+ * The result should be one key with the payload from the second
+ * add_key() request. Key Service recognizes the duplicate
+ * descriptor and allows the payload to be updated.
+ *
+ * mktme key type chooses not to support the keyctl read command.
+ * This means we cannot read the key payloads back to compare.
+ * That piece can only be verified in debug mode.
+ */
+void test_keys_change_payload(void)
+{
+	key_serial_t key_a, key_b;
+
+	key_a = add_key("mktme", "changepay", options_USER,
+			strlen(options_USER), KEY_SPEC_THREAD_KEYRING);
+	if (key_a == -1) {
+		fprintf(stderr, "Failed to add test key_a: %s\n",
+			strerror(errno));
+		return;
+	}
+	key_b = add_key("mktme", "changepay", options_CPU_long,
+			strlen(options_CPU_long), KEY_SPEC_THREAD_KEYRING);
+	if (key_b == -1) {
+		fprintf(stderr, "Failed to add test key_b: %s\n",
+			strerror(errno));
+		goto out;
+	}
+	if (key_a != key_b) {
+		fprintf(stderr, "Fail: expected same key, got new key.\n");
+		if (keyctl(KEYCTL_INVALIDATE, key_b) == -1)
+			fprintf(stderr, "Key invalidate failed: %s\n",
+				strerror(errno));
+	}
+out:
+	if (keyctl(KEYCTL_INVALIDATE, key_a) == -1)
+		fprintf(stderr, "Key invalidate failed: %s\n", strerror(errno));
+}
+
+/*  Add a key, then discard via method parameter: revoke or invalidate */
+void test_keys_add_discard(int method)
+{
+	key_serial_t key;
+	int i;
+
+	key = add_key("mktme", "mtest_add_discard", options_USER,
+		      strlen(options_USER), KEY_SPEC_THREAD_KEYRING);
+	if (key < 0)
+		perror("add_key");
+
+	if (keyctl(method, key) == -1)
+		fprintf(stderr, "Key %s failed: %s\n",
+			((method == KEYCTL_INVALIDATE) ? "invalidate"
+			: "revoke"), strerror(errno));
+}
+
+void test_keys_add_invalidate(void)
+{
+	test_keys_add_discard(KEYCTL_INVALIDATE);
+}
+
+void test_keys_add_revoke(void)
+{
+	if (remove_gc_delay()) {
+		fprintf(stderr, "Skipping REVOKE test. Cannot set gc_delay.\n");
+		return;
+	}
+	test_keys_add_discard(KEYCTL_REVOKE);
+	restore_gc_delay();
+}
+
+void test_keys_describe(void)
+{
+	key_serial_t key;
+	char buf[256];
+	int ret;
+
+	key = add_key("mktme", "describe_this_key", options_USER,
+		      strlen(options_USER), KEY_SPEC_THREAD_KEYRING);
+
+	if (key == -1) {
+		fprintf(stderr, "Add_key failed.\n");
+		return;
+	}
+	if (keyctl(KEYCTL_DESCRIBE, key, buf, sizeof(buf)) == -1) {
+		fprintf(stderr, "%s: KEYCTL_DESCRIBE failed\n", __func__);
+		goto revoke_key;
+	}
+	if (strncmp(buf, "mktme", 5))
+		fprintf(stderr, "Error: mktme descriptor missing.\n");
+
+revoke_key:
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Key invalidate failed: %s\n", strerror(errno));
+}
+
+void test_keys_update_explicit(void)
+{
+	key_serial_t key;
+
+	key = add_key("mktme", "testkey", options_USER, strlen(options_USER),
+		      KEY_SPEC_SESSION_KEYRING);
+
+	if (key == -1) {
+		perror("add_key");
+		return;
+	}
+	if (keyctl(KEYCTL_UPDATE, key, options_CPU_long,
+		   strlen(options_CPU_long)) == -1)
+		fprintf(stderr, "Error: Update key failed\n");
+
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Key invalidate failed: %s\n", strerror(errno));
+}
+
+void test_keys_update_clear(void)
+{
+	key_serial_t key;
+
+	key = add_key("mktme", "testkey", options_USER, strlen(options_USER),
+		      KEY_SPEC_SESSION_KEYRING);
+
+	if (keyctl(KEYCTL_UPDATE, key, options_CLEAR,
+		   strlen(options_CLEAR)) == -1)
+		fprintf(stderr, "update: clear key failed\n");
+
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Key invalidate failed: %s\n", strerror(errno));
+}
+
+void test_keys_no_encrypt(void)
+{
+	key_serial_t key;
+
+	key = add_key("mktme", "no_encrypt_key", options_NOENCRYPT,
+		      strlen(options_USER), KEY_SPEC_SESSION_KEYRING);
+
+	if (key == -1) {
+		fprintf(stderr, "Error: add_key type=no_encrypt failed.\n");
+		return;
+	}
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		fprintf(stderr, "Key invalidate failed: %s\n", strerror(errno));
+}
+
+void test_keys_unique_keyid(void)
+{
+	/*
+	 * exists[] array must be of mktme_nr_keyids + 1 size, else the
+	 * uniqueness test will fail. OK for max_keyids under test to be
+	 * less than mktme_nr_keyids.
+	 */
+	unsigned int exists[max_keyids + 1];
+	unsigned int keyids[max_keyids + 1];
+	key_serial_t key[max_keyids + 1];
+	void *ptr[max_keyids + 1];
+	int keys_available = 0;
+	char name[12];
+	int i, ret;
+
+	/* Get as many keys as possible */
+	for (i = 1; i <= max_keyids; i++) {
+		sprintf(name, "mk_unique_%d", i);
+		key[i] = add_key("mktme", name, options_CPU_short,
+				 strlen(options_CPU_short),
+				 KEY_SPEC_THREAD_KEYRING);
+		if (key[i] > 0)
+			keys_available++;
+	}
+	/* Create mappings, encrypt them, and find the assigned KeyIDs */
+	for (i = 1; i <= keys_available; i++) {
+		ptr[i] = mmap(NULL, PAGE_SIZE, PROT_NONE,
+			      MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		ret = syscall(sys_encrypt_mprotect, ptr[i], PAGE_SIZE,
+			      PROT_NONE, key[i]);
+		keyids[i] = find_smaps_keyid((unsigned long)ptr[i]);
+	}
+	/* Verify the KeyID's are unique */
+	memset(exists, 0, sizeof(exists));
+	for (i = 1; i <= keys_available; i++) {
+		if (exists[keyids[i]])
+			fprintf(stderr, "Error: duplicate keyid %d\n",
+				keyids[i]);
+		exists[keyids[i]] = 1;
+	}
+
+	/* Clean up */
+	for (i = 1; i <= keys_available; i++) {
+		ret = munmap(ptr[i], PAGE_SIZE);
+		if (keyctl(KEYCTL_INVALIDATE, key[i]) == -1)
+			fprintf(stderr, "Invalidate failed Serial:%d\n",
+				key[i]);
+	}
+	sleep(1);  /* Rest a bit while keys get freed. */
+}
+
+void test_keys_get_max_keyids(void)
+{
+	key_serial_t key[max_keyids + 1];
+	int keys_available = 0;
+	char name[12];
+	int i, ret;
+
+	for (i = 1; i <= max_keyids; i++) {
+		sprintf(name, "mk_get63_%d", i);
+		key[i] = add_key("mktme", name, options_CPU_short,
+				 strlen(options_CPU_short),
+				 KEY_SPEC_THREAD_KEYRING);
+		if (key[i] > 0)
+			keys_available++;
+	}
+
+	fprintf(stderr, "     Info: got %d of %d system keys\n",
+		keys_available, max_keyids);
+
+	for (i = 1; i <= keys_available; i++) {
+		if (keyctl(KEYCTL_INVALIDATE, key[i]) == -1)
+			fprintf(stderr, "Invalidate failed Serial:%d\n",
+				key[i]);
+	}
+	sleep(1);  /* Rest a bit while keys get freed. */
+}
+
+/*
+ * TODO: Run out of keys, release 1, grab it, repeat
+ * This test in not completed and is not in the run list.
+ */
+void test_keys_max_out(void)
+{
+	key_serial_t key[max_keyids + 1];
+	int keys_available;
+	char name[12];
+	int i, ret;
+
+	/* Get all the keys or as many as possible: keys_available */
+	for (i = 1; i <= max_keyids; i++) {
+		sprintf(name, "mk_max_%d", i);
+		key[i] = add_key("mktme", name, options_CPU_short,
+				 strlen(options_CPU_short),
+				 KEY_SPEC_THREAD_KEYRING);
+		if (key[i] < 0) {
+			fprintf(stderr, "failed to get key[%d]\n", i);
+			continue;
+		}
+	}
+	keys_available = i - 1;
+	if (keys_available < max_keyids)
+		printf("Error: only got %d keys, expected %d\n",
+		       keys_available, max_keyids);
+
+	for (i = 1; i <= keys_available; i++) {
+		if (keyctl(KEYCTL_INVALIDATE, key[i]) == -1)
+			fprintf(stderr, "Invalidate failed key:%d\n", key[i]);
+	}
+}
+
+/* Add each type of key */
+void test_keys_add_each_type(void)
+{
+	key_serial_t key;
+	int i;
+
+	const char *options[] = {
+		options_CPU_short, options_CPU_long, options_USER,
+		options_CLEAR, options_NOENCRYPT
+	};
+	static const char *opt_name[] = {
+		"add_key cpu_short", "add_key cpu_long", "add_key user",
+		"add_key clear", "add_key no-encrypt"
+	};
+
+	for (i = 0; i < ARRAY_SIZE(options); i++) {
+		key = add_key("mktme", opt_name[i], options[i],
+			      strlen(options[i]), KEY_SPEC_SESSION_KEYRING);
+
+		if (key == -1) {
+			perror(opt_name[i]);
+		} else {
+			perror(opt_name[i]);
+			if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+				fprintf(stderr, "Key invalidate failed: %d\n",
+					key);
+		}
+	}
+}
diff --git a/tools/testing/selftests/x86/mktme/mktme_test.c b/tools/testing/selftests/x86/mktme/mktme_test.c
new file mode 100644
index 000000000000..6409ccf94d4a
--- /dev/null
+++ b/tools/testing/selftests/x86/mktme/mktme_test.c
@@ -0,0 +1,300 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tests x86 MKTME Multi-Key Memory Protection
+ *
+ * COMPILE w keyutils library ==>  cc -o mktest mktme_test.c -lkeyutils
+ *
+ * Test requires capability of CAP_SYS_RESOURCE, or CAP_SYS_ADMIN.
+ * $ sudo setcap 'CAP_SYS_RESOURCE+ep' mktest
+ *
+ * Some tests may require root privileges because the test needs to
+ * remove the garbage collection delay /proc/sys/kernel/keys/gc_delay
+ * while testing. This keeps the tests (and system) from appearing to
+ * be out of keys when keys are simply awaiting the next scheduled
+ * garbage collection.
+ *
+ * Documentation/x86/mktme.rst
+ *
+ * There are examples in here of:
+ *  * how to use the Kernel Key Service MKTME API to allocate keys
+ *  * how to use the MKTME Memory Encryption API to encrypt memory
+ *
+ * Adding Tests:
+ *	o Each test should run independently and clean up after itself.
+ *	o There are no dependencies among tests.
+ *	o Tests that use a lot of keys, should consider adding sleep(),
+ *	  so that the next test isn't key-starved.
+ *	o Make no assumptions about the order in which tests will run.
+ *	o There are shared defines that can be used for setting
+ *	  payload options.
+ */
+#include <sys/fcntl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <errno.h>
+#include <keyutils.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+#define PAGE_SIZE sysconf(_SC_PAGE_SIZE)
+#define sys_encrypt_mprotect 335
+
+/*  TODO get this from kernel. Add to /proc/sys/kernel/keys/ */
+int max_keyids = 63;
+
+/* Use these pre-defined options to simplify the add_key() setup */
+char *options_CPU_short = "algorithm=aes-xts-128 type=cpu";
+char *options_CPU_long = "algorithm=aes-xts-128 type=cpu key=12345678912345671234567891234567 tweak=12345678912345671234567891234567";
+char *options_USER = "algorithm=aes-xts-128 type=user key=12345678912345671234567891234567 tweak=12345678912345671234567891234567";
+char *options_CLEAR = "type=clear";
+char *options_NOENCRYPT = "type=no-encrypt";
+
+/* Helper to check Encryption_KeyID in proc/self/smaps */
+static FILE *seek_to_smaps_entry(unsigned long addr)
+{
+	FILE *file;
+	char *line = NULL;
+	size_t size = 0;
+	unsigned long start, end;
+	char perms[5];
+	unsigned long offset;
+	char dev[32];
+	unsigned long inode;
+	char path[BUFSIZ];
+
+	file = fopen("/proc/self/smaps", "r");
+	if (!file) {
+		perror("fopen smaps");
+		_exit(1);
+	}
+	while (getline(&line, &size, file) > 0) {
+		if (sscanf(line, "%lx-%lx %s %lx %s %lu %s\n",
+			   &start, &end, perms, &offset, dev, &inode, path) < 6)
+			goto next;
+
+		if (start <= addr && addr < end)
+			goto out;
+next:
+		free(line);
+		line = NULL;
+		size = 0;
+	}
+	fclose(file);
+	file = NULL;
+out:
+	free(line);
+	return file;
+}
+
+/* Find the KeyID for this addr from /proc/self/smaps */
+unsigned int find_smaps_keyid(unsigned long addr)
+{
+	unsigned int keyid = 0;
+	char *line = NULL;
+	size_t size = 0;
+	FILE *smaps;
+
+	smaps = seek_to_smaps_entry(addr);
+	if (!smaps) {
+		printf("Unable to parse /proc/self/smaps\n");
+		goto out;
+	}
+	while (getline(&line, &size, smaps) > 0) {
+		if (!strstr(line, "KeyID:")) {
+			free(line);
+			line = NULL;
+			size = 0;
+			continue;
+		}
+		if (sscanf(line, "KeyID:             %5u\n", &keyid) < 1)
+			printf("Unable to parse smaps for KeyID:%s\n", line);
+		break;
+	}
+out:
+	free(line);
+	fclose(smaps);
+	return keyid;
+}
+
+/*
+ * Set the garbage collection delay to 0, so that keys are quickly
+ * available for re-use while running the selftests.
+ *
+ * Most tests use INVALIDATE to remove a key, which has no delay by
+ * design. But, revoke, unlink, and timeout still have a delay, so
+ * they should use this.
+ */
+char current_gc_delay[10] = {0};
+static inline int remove_gc_delay(void)
+{
+	int fd;
+
+	fd = open("/proc/sys/kernel/keys/gc_delay", O_RDWR | O_NONBLOCK);
+	if (fd < 0) {
+		perror("Failed to open /proc/sys/kernel/keys/gc_delay");
+		return -1;
+	}
+	if (read(fd, current_gc_delay, sizeof(current_gc_delay)) <= 0) {
+		perror("Failed to read /proc/sys/kernel/keys/gc_delay");
+		close(fd);
+		return -1;
+	}
+	lseek(fd, 0, SEEK_SET);
+	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
+		perror("Failed to write temp_gc_delay to gc_delay\n");
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	return 0;
+}
+
+static inline void restore_gc_delay(void)
+{
+	int fd;
+
+	fd  = open("/proc/sys/kernel/keys/gc_delay", O_RDWR | O_NONBLOCK);
+	if (fd < 0) {
+		perror("Failed to open /proc/sys/kernel/keys/gc_delay");
+		return;
+	}
+	if (write(fd, current_gc_delay, strlen(current_gc_delay)) !=
+	    strlen(current_gc_delay)) {
+		perror("Failed to restore gc_delay\n");
+		close(fd);
+		return;
+	}
+	close(fd);
+}
+
+/*
+ * The tests are sorted into 3 categories:
+ * key_test encrypt_test focus on their specific API
+ * flow_tests are special flows and regression tests of prior issue.
+ */
+
+#include "key_tests.c"
+#include "encrypt_tests.c"
+#include "flow_tests.c"
+
+struct tlist {
+	const char *name;
+	void (*func)();
+};
+
+static const struct tlist mktme_tests[] = {
+{"Keys: Add each type key",		test_keys_add_each_type		},
+{"Flow: One simple roundtrip",		test_one_simple_round_trip	},
+{"Keys: Valid Payload Options",		test_keys_valid_options		},
+{"Keys: Invalid Payload Options",	test_keys_invalid_options	},
+{"Keys: Add Key Descriptor Field",	test_keys_descriptor		},
+{"Keys: Add Multiple Same",		test_keys_add_mult_same		},
+{"Keys: Change payload, auto update",	test_keys_change_payload	},
+{"Keys: Update, explicit update",	test_keys_update_explicit	},
+{"Keys: Update, Clear",			test_keys_update_clear		},
+{"Keys: Add, Invalidate Keys",		test_keys_add_invalidate	},
+{"Keys: Add, Revoke Keys",		test_keys_add_revoke		},
+{"Keys: Keyctl Describe",		test_keys_describe		},
+{"Keys: Clear",				test_keys_update_clear		},
+{"Keys: No Encrypt",			test_keys_no_encrypt		},
+{"Keys: Unique KeyIDs",			test_keys_unique_keyid		},
+{"Keys: Get Max KeyIDs",		test_keys_get_max_keyids	},
+{"Encrypt: Parameter Alignment",	test_param_alignment		},
+{"Encrypt: Change Protections",		test_change_protections		},
+{"Encrypt: Swap Keys",			test_key_swap			},
+{"Encrypt: Counters Same Key",		test_counters_same		},
+{"Encrypt: Counters Diff Key",		test_counters_diff		},
+{"Encrypt: Counters Holes",		test_counters_holes		},
+/*
+{"Encrypt: Split",			test_split			},
+{"Encrypt: Well Suited",		test_well_suited		},
+{"Encrypt: Not Suited",			test_not_suited			},
+*/
+{"Flow: Switch key no data",		test_switch_key_no_data		},
+{"Flow: Switch key multi VMAs",		test_switch_key_mult_vmas	},
+{"Flow: Switch No Key to Any Key",	test_switch_key0_to_key		},
+{"Flow: madvise",			test_kai_madvise		},
+{"Flow: Invalidate In Use Key",		test_discard_in_use_key		},
+};
+
+void print_usage(void)
+{
+	fprintf(stderr, "Usage: mktme_test [options]...\n"
+		"  -a			Run ALL tests\n"
+		"  -t <testnum>		Run one <testnum> test\n"
+		"  -l			List available tests\n"
+		"  -h, -?		Show this help\n"
+	       );
+}
+
+int main(int argc, char *argv[])
+{
+	int test_selected = -1;
+	char printtest[12];
+	int trace = 0;
+	int i, c, err;
+	char *temp;
+
+	/*
+	 * TODO: Default case needs to run 'selftests' -  a
+	 * curated set of tests that validate functionality but
+	 * don't hog resources.
+	 */
+	c = getopt(argc, argv, "at:lph?");
+		switch (c) {
+		case 'a':
+			test_selected = -1;
+			printf("Test Selected [ALL]\n");
+			break;
+		case 't':
+			test_selected = strtoul(optarg, &temp, 10);
+			printf("Test Selected [%d]\n", test_selected);
+			break;
+		case 'l':
+			for (i = 0; i < ARRAY_SIZE(mktme_tests); i++)
+				printf("[%2d] %s\n", i + 1,
+				       mktme_tests[i].name);
+			exit(0);
+			break;
+		case 'p':
+			trace = 1;
+		case 'h':
+		case '?':
+		default:
+			print_usage();
+			exit(0);
+		}
+
+/*
+ *	if (!cpu_has_mktme()) {
+ *		printf("MKTME not supported on this system.\n");
+ *		exit(0);
+ *	}
+ */
+	if (trace) {
+		printf("Pausing: start trace on PID[%d]\n", (int)getpid());
+		getchar();
+	}
+
+	if (test_selected == -1) {
+		for (i = 0; i < ARRAY_SIZE(mktme_tests); i++) {
+			printf("[%2d] %s\n", i + 1, mktme_tests[i].name);
+			mktme_tests[i].func();
+		}
+		printf("\nTests Completed\n");
+
+	} else {
+		if (test_selected <= ARRAY_SIZE(mktme_tests)) {
+			printf("[%2d] %s\n", test_selected,
+			       mktme_tests[test_selected - 1].name);
+			mktme_tests[test_selected - 1].func();
+			printf("\nTest Completed\n");
+		}
+	}
+	exit(0);
+}
-- 
2.20.1

