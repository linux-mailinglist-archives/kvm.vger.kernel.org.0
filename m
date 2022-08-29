Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD515A54C0
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 21:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiH2TtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 15:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiH2TtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 15:49:11 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94535786FF
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 12:49:10 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s206so8648188pgs.3
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 12:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=XCNEHMJr0hfjsQ+vnHehtUNGIlWFLDcrEGyzhvj9K5g=;
        b=eV5+IDKMWHvTrLvY5qdVe2Dr8YGn8pA5uYTHFoM9WqzJ5yfWrLY1ZhR0rkfUQI52Sc
         vNeIZmU55+sU2IZVsq+BoW6IjenTceTh1lz0uCOy5ba2iGdTso12xmH76m52E0Qvm94M
         Zg4brhVInfvtcp34fVq8tGinJE8OAYDNsZAEc2GABsyIYfPW2MH5luiguxHSF/MZjh2V
         eXX/eJ3nbdOGMriBwZjWgzv1hOmScTBqOfnD0bWbnATysgfikf1SixYpg17Z/LM4xhHO
         qHCMPVShLt9YadObdhwwX9LRRyTBs+gfLrx/pWpS4bII34OeIOvtH6xGSeGQ8n6BjK38
         gBiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=XCNEHMJr0hfjsQ+vnHehtUNGIlWFLDcrEGyzhvj9K5g=;
        b=O7UCdYGvhoat2mEUPif1veauFQ+dBx/x/jS6vjNy7d1TwEneoOErxY6Si6vvlmTAJD
         942C/+nYi3b/DhmrHZDccwLB0QU//0k39xT71bJ8NFFJl8qzwywiqeGGsdWdp60ilXpl
         iOkz2wLMdGxYwDdsZmr+oiO6TL8D2TcYyDN82QrFIVUDod6cTn5WGnjbSyY74DFKSeSk
         kIln94lq3Ianrn92pWqn18YMDGmAzSptl3s7+in+u9eyDp5Ot/UnOuwcrkJopWJQzO/2
         RtQ3cyd2ayGWiYETMhWNWxak+7BaEtBEL7n/8AAMTt9tOMUvkZuMrfUapvW+Dy6bpJjH
         ZJ+g==
X-Gm-Message-State: ACgBeo0276yeMKfcRFzpgtBM0Jj40fJG2U8vKS/yXLAYZQVS8Q/EvXYX
        /uTKS3bNPHYL6n2HYyFbYcQImQ==
X-Google-Smtp-Source: AA6agR5e+dxYKkxh2RPcBHN2REmqjfCB50lwaHYxN4slLs/mZYZ29Yp7izkcJL9Ihy+4bPNKYSzPeA==
X-Received: by 2002:a63:e011:0:b0:42a:1c12:17a9 with SMTP id e17-20020a63e011000000b0042a1c1217a9mr14923316pgh.557.1661802549901;
        Mon, 29 Aug 2022 12:49:09 -0700 (PDT)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id v12-20020a1709029a0c00b0017294d80f25sm7872364plp.258.2022.08.29.12.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 12:49:09 -0700 (PDT)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Cc:     Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH v6 2/2] selftests/vm/pkeys: Add a regression test for setting PKRU through ptrace
Date:   Mon, 29 Aug 2022 12:49:05 -0700
Message-Id: <20220829194905.81713-2-khuey@kylehuey.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829194905.81713-1-khuey@kylehuey.com>
References: <20220829194905.81713-1-khuey@kylehuey.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

This tests PTRACE_SETREGSET with NT_X86_XSTATE modifying PKRU directly and
removing the PKRU bit from XSTATE_BV.

Signed-off-by: Kyle Huey <me@kylehuey.com>
---
 tools/testing/selftests/vm/pkey-x86.h        |  12 ++
 tools/testing/selftests/vm/protection_keys.c | 131 ++++++++++++++++++-
 2 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/pkey-x86.h b/tools/testing/selftests/vm/pkey-x86.h
index b078ce9c6d2a..72c14cd3ddc7 100644
--- a/tools/testing/selftests/vm/pkey-x86.h
+++ b/tools/testing/selftests/vm/pkey-x86.h
@@ -104,6 +104,18 @@ static inline int cpu_has_pkeys(void)
 	return 1;
 }
 
+static inline int cpu_max_xsave_size(void)
+{
+	unsigned long XSTATE_CPUID = 0xd;
+	unsigned int eax;
+	unsigned int ebx;
+	unsigned int ecx;
+	unsigned int edx;
+
+	__cpuid_count(XSTATE_CPUID, 0, eax, ebx, ecx, edx);
+	return ecx;
+}
+
 static inline u32 pkey_bit_position(int pkey)
 {
 	return pkey * PKEY_BITS_PER_PKEY;
diff --git a/tools/testing/selftests/vm/protection_keys.c b/tools/testing/selftests/vm/protection_keys.c
index 291bc1e07842..95f403a0c46d 100644
--- a/tools/testing/selftests/vm/protection_keys.c
+++ b/tools/testing/selftests/vm/protection_keys.c
@@ -18,12 +18,13 @@
  *	do a plain mprotect() to a mprotect_pkey() area and make sure the pkey sticks
  *
  * Compile like this:
- *	gcc      -o protection_keys    -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
- *	gcc -m32 -o protection_keys_32 -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
+ *	gcc -mxsave      -o protection_keys    -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
+ *	gcc -mxsave -m32 -o protection_keys_32 -O2 -g -std=gnu99 -pthread -Wall protection_keys.c -lrt -ldl -lm
  */
 #define _GNU_SOURCE
 #define __SANE_USERSPACE_TYPES__
 #include <errno.h>
+#include <linux/elf.h>
 #include <linux/futex.h>
 #include <time.h>
 #include <sys/time.h>
@@ -1550,6 +1551,129 @@ void test_implicit_mprotect_exec_only_memory(int *ptr, u16 pkey)
 	do_not_expect_pkey_fault("plain read on recently PROT_EXEC area");
 }
 
+#if defined(__i386__) || defined(__x86_64__)
+void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
+{
+	u32 new_pkru;
+	pid_t child;
+	int status, ret;
+	int pkey_offset = pkey_reg_xstate_offset();
+	size_t xsave_size = cpu_max_xsave_size();
+	void *xsave;
+	u32 *pkey_register;
+	u64 *xstate_bv;
+	struct iovec iov;
+
+	new_pkru = ~read_pkey_reg();
+	/* Don't make PROT_EXEC mappings inaccessible */
+	new_pkru &= ~3;
+
+	child = fork();
+	pkey_assert(child >= 0);
+	dprintf3("[%d] fork() ret: %d\n", getpid(), child);
+	if (!child) {
+		ptrace(PTRACE_TRACEME, 0, 0, 0);
+		/* Stop and allow the tracer to modify PKRU directly */
+		raise(SIGSTOP);
+
+		/*
+		 * need __read_pkey_reg() version so we do not do shadow_pkey_reg
+		 * checking
+		 */
+		if (__read_pkey_reg() != new_pkru)
+			exit(1);
+
+		/* Stop and allow the tracer to clear XSTATE_BV for PKRU */
+		raise(SIGSTOP);
+
+		if (__read_pkey_reg() != 0)
+			exit(1);
+
+		/* Stop and allow the tracer to examine PKRU */
+		raise(SIGSTOP);
+
+		exit(0);
+	}
+
+	pkey_assert(child == waitpid(child, &status, 0));
+	dprintf3("[%d] waitpid(%d) status: %x\n", getpid(), child, status);
+	pkey_assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);
+
+	xsave = (void *)malloc(xsave_size);
+	pkey_assert(xsave > 0);
+
+	/* Modify the PKRU register directly */
+	iov.iov_base = xsave;
+	iov.iov_len = xsave_size;
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+
+	pkey_register = (u32 *)(xsave + pkey_offset);
+	pkey_assert(*pkey_register == read_pkey_reg());
+
+	*pkey_register = new_pkru;
+
+	ret = ptrace(PTRACE_SETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+
+	/* Test that the modification is visible in ptrace before any execution */
+	memset(xsave, 0xCC, xsave_size);
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+	pkey_assert(*pkey_register == new_pkru);
+
+	/* Execute the tracee */
+	ret = ptrace(PTRACE_CONT, child, 0, 0);
+	pkey_assert(ret == 0);
+
+	/* Test that the tracee saw the PKRU value change */
+	pkey_assert(child == waitpid(child, &status, 0));
+	dprintf3("[%d] waitpid(%d) status: %x\n", getpid(), child, status);
+	pkey_assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);
+
+	/* Test that the modification is visible in ptrace after execution */
+	memset(xsave, 0xCC, xsave_size);
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+	pkey_assert(*pkey_register == new_pkru);
+
+	/* Clear the PKRU bit from XSTATE_BV */
+	xstate_bv = (u64 *)(xsave + 512);
+	*xstate_bv &= ~(1 << 9);
+
+	ret = ptrace(PTRACE_SETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+
+	/* Test that the modification is visible in ptrace before any execution */
+	memset(xsave, 0xCC, xsave_size);
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+	pkey_assert(*pkey_register == 0);
+
+	ret = ptrace(PTRACE_CONT, child, 0, 0);
+	pkey_assert(ret == 0);
+
+	/* Test that the tracee saw the PKRU value go to 0 */
+	pkey_assert(child == waitpid(child, &status, 0));
+	dprintf3("[%d] waitpid(%d) status: %x\n", getpid(), child, status);
+	pkey_assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGSTOP);
+
+	/* Test that the modification is visible in ptrace after execution */
+	memset(xsave, 0xCC, xsave_size);
+	ret = ptrace(PTRACE_GETREGSET, child, (void *)NT_X86_XSTATE, &iov);
+	pkey_assert(ret == 0);
+	pkey_assert(*pkey_register == 0);
+
+	ret = ptrace(PTRACE_CONT, child, 0, 0);
+	pkey_assert(ret == 0);
+	pkey_assert(child == waitpid(child, &status, 0));
+	dprintf3("[%d] waitpid(%d) status: %x\n", getpid(), child, status);
+	pkey_assert(WIFEXITED(status));
+	pkey_assert(WEXITSTATUS(status) == 0);
+	free(xsave);
+}
+#endif
+
 void test_mprotect_pkey_on_unsupported_cpu(int *ptr, u16 pkey)
 {
 	int size = PAGE_SIZE;
@@ -1585,6 +1709,9 @@ void (*pkey_tests[])(int *ptr, u16 pkey) = {
 	test_pkey_syscalls_bad_args,
 	test_pkey_alloc_exhaust,
 	test_pkey_alloc_free_attach_pkey0,
+#if defined(__i386__) || defined(__x86_64__)
+	test_ptrace_modifies_pkru,
+#endif
 };
 
 void run_tests_once(void)
-- 
2.37.2

