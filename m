Return-Path: <kvm+bounces-29367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CB89AA094
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A06F1C21FBA
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2B719CD07;
	Tue, 22 Oct 2024 10:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LfHw3Rod"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785ED19C547
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594590; cv=none; b=WcvnxhhmYqClCG/FfQJVu5VPOmVgOO5OMER7HDJtk3r9tmNPAaC1FiWxRHnQBG2DeZzNYWvitGomqBaKh1Lw07VB0oeAmspQTOW0+mrVsC7DQZes4bnqC6WES8vmDuCjBq+wNCif1b2G2+6MThCpEebtYyOOi8xsi5sn2nDb1iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594590; c=relaxed/simple;
	bh=uIQzKypzDYGhleI5zrxAFqDW7he8vjMJscNcMmSUFwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I2kHwpDRhX7u04FcvYTGO+Xq96k7j+DYVoSoy1Szlc4oqgh9zLj49bTDnvnJUSlFWcKh4HbO/NBpFMVX5qpfiij1Fa8d2tFEqln3GZ9FeL0DZ2KhtWjupbAClc/7XOnMyVqxYEcXx17qxqPhBJln8bqFvjBVe6cjcCq4r/KAfi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LfHw3Rod; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a99e3b3a411so1054242766b.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594586; x=1730199386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOyxXWkbmxyeJp1271bZ6nHrEgwT9agO1ZydqcSHiVY=;
        b=LfHw3RodAKlgsw4IWpCkt2uZFrhpwcvw2wk4X1kQkBafUmTCb6eISFPhGXSAGZhTqC
         PH9N39YAWbYDOPPjhscRZmNDNlG54cpoB6l2vW+T0PvlUFEpfrGOBoIM2y/vvjC+Gxbl
         g8gUrJtxwxvymfD3qO/eY5zzUxAqqPeBEfGIoabd++UkV4R74YVPRieZB7QhyH3uwmis
         G5RyVz3DYIfOBxRZtBf+NMSxGqLK4dtzFI4ts42Vu383ADRJ4skoW1xv6QJ8zHFRPGSv
         svGRjA/9jaWvcQLqflJna41Ziy4cO4HnaKvHU5YHMLYLQqAVfYogblMqC262IwZYe56W
         BR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594586; x=1730199386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOyxXWkbmxyeJp1271bZ6nHrEgwT9agO1ZydqcSHiVY=;
        b=Dwyw0exm4ZMEwXL+fwi2fbfExx9GlZrQEaSrasDVggC2OMpkr+0GTeCagkHesFOuAu
         UpZduPzaMfG/UkyKNzBrOnlnaY7+UZRYa7c4fz2Yc49xJuxzMg411h3m/IvFbbnJSBzx
         bNS4mVw9hXK/+oYTyJKOsmnDzFBOBIj2CIY4KyH/80YiBAvybRD057dLSFr8m8pE6HIa
         SpMq9lpIfyZEsilbrgsvUMy+irLUKSaS5j+opSh+TbArObscljyzWpgy8VrUNt2+7Vhb
         vr/3YFpdN9BzvXguvS8IhxfX1SnD9DupppueFL3lFwzXpYKlf/tCN3342Yt58wTu7h2L
         hEHQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5aC/NCA5YR5PErDCQJsDsULdADzErfapnW6zR/U8j94TG1oRScU2W4XqorC46Uf8uPkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdFE/GFBRWntS/lCyGfcWgqufnIpdlvu+R6q8wOLBBAAJR6HA3
	sMBqHJ1F7EJjrmV5bplSZWfvjE6X1lQtyBRSbwXUIaYrmMSE7fOWedW4iRcqsd8=
X-Google-Smtp-Source: AGHT+IEZjLLtqU09Sx+uo+mrjZmbCZKUxmm4Ab8Z+Gbl4XRa6e9yqIzpm990wPYB5uU0/r5L4B8Jhw==
X-Received: by 2002:a17:907:1c85:b0:a9a:597:8cc9 with SMTP id a640c23a62f3a-a9aaa523356mr288374566b.12.1729594585591;
        Tue, 22 Oct 2024 03:56:25 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91370e91sm320592666b.123.2024.10.22.03.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:19 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 465EC5F942;
	Tue, 22 Oct 2024 11:56:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 07/20] tests/tcg/x86_64: Add cross-modifying code test
Date: Tue, 22 Oct 2024 11:56:01 +0100
Message-Id: <20241022105614.839199-8-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241022105614.839199-1-alex.bennee@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit f025692c992c ("accel/tcg: Clear PAGE_WRITE before translation")
fixed cross-modifying code handling, but did not add a test. The
changed code was further improved recently [1], and I was not sure
whether these modifications were safe (spoiler: they were fine).

Add a test to make sure there are no regressions.

[1] https://lists.gnu.org/archive/html/qemu-devel/2022-09/msg00034.html

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Message-Id: <20241001150617.9977-1-iii@linux.ibm.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/tcg/x86_64/cross-modifying-code.c | 80 +++++++++++++++++++++++++
 tests/tcg/x86_64/Makefile.target        |  4 ++
 2 files changed, 84 insertions(+)
 create mode 100644 tests/tcg/x86_64/cross-modifying-code.c

diff --git a/tests/tcg/x86_64/cross-modifying-code.c b/tests/tcg/x86_64/cross-modifying-code.c
new file mode 100644
index 0000000000..2704df6061
--- /dev/null
+++ b/tests/tcg/x86_64/cross-modifying-code.c
@@ -0,0 +1,80 @@
+/*
+ * Test patching code, running in one thread, from another thread.
+ *
+ * Intel SDM calls this "cross-modifying code" and recommends a special
+ * sequence, which requires both threads to cooperate.
+ *
+ * Linux kernel uses a different sequence that does not require cooperation and
+ * involves patching the first byte with int3.
+ *
+ * Finally, there is user-mode software out there that simply uses atomics, and
+ * that seems to be good enough in practice. Test that QEMU has no problems
+ * with this as well.
+ */
+
+#include <assert.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdlib.h>
+
+void add1_or_nop(long *x);
+asm(".pushsection .rwx,\"awx\",@progbits\n"
+    ".globl add1_or_nop\n"
+    /* addq $0x1,(%rdi) */
+    "add1_or_nop: .byte 0x48, 0x83, 0x07, 0x01\n"
+    "ret\n"
+    ".popsection\n");
+
+#define THREAD_WAIT 0
+#define THREAD_PATCH 1
+#define THREAD_STOP 2
+
+static void *thread_func(void *arg)
+{
+    int val = 0x0026748d; /* nop */
+
+    while (true) {
+        switch (__atomic_load_n((int *)arg, __ATOMIC_SEQ_CST)) {
+        case THREAD_WAIT:
+            break;
+        case THREAD_PATCH:
+            val = __atomic_exchange_n((int *)&add1_or_nop, val,
+                                      __ATOMIC_SEQ_CST);
+            break;
+        case THREAD_STOP:
+            return NULL;
+        default:
+            assert(false);
+            __builtin_unreachable();
+        }
+    }
+}
+
+#define INITIAL 42
+#define COUNT 1000000
+
+int main(void)
+{
+    int command = THREAD_WAIT;
+    pthread_t thread;
+    long x = 0;
+    int err;
+    int i;
+
+    err = pthread_create(&thread, NULL, &thread_func, &command);
+    assert(err == 0);
+
+    __atomic_store_n(&command, THREAD_PATCH, __ATOMIC_SEQ_CST);
+    for (i = 0; i < COUNT; i++) {
+        add1_or_nop(&x);
+    }
+    __atomic_store_n(&command, THREAD_STOP, __ATOMIC_SEQ_CST);
+
+    err = pthread_join(thread, NULL);
+    assert(err == 0);
+
+    assert(x >= INITIAL);
+    assert(x <= INITIAL + COUNT);
+
+    return EXIT_SUCCESS;
+}
diff --git a/tests/tcg/x86_64/Makefile.target b/tests/tcg/x86_64/Makefile.target
index 783ab5b21a..d6dff559c7 100644
--- a/tests/tcg/x86_64/Makefile.target
+++ b/tests/tcg/x86_64/Makefile.target
@@ -17,6 +17,7 @@ X86_64_TESTS += cmpxchg
 X86_64_TESTS += adox
 X86_64_TESTS += test-1648
 X86_64_TESTS += test-2175
+X86_64_TESTS += cross-modifying-code
 TESTS=$(MULTIARCH_TESTS) $(X86_64_TESTS) test-x86_64
 else
 TESTS=$(MULTIARCH_TESTS)
@@ -27,6 +28,9 @@ adox: CFLAGS=-O2
 run-test-i386-ssse3: QEMU_OPTS += -cpu max
 run-plugin-test-i386-ssse3-%: QEMU_OPTS += -cpu max
 
+cross-modifying-code: CFLAGS+=-pthread
+cross-modifying-code: LDFLAGS+=-pthread
+
 test-x86_64: LDFLAGS+=-lm -lc
 test-x86_64: test-i386.c test-i386.h test-i386-shift.h test-i386-muldiv.h
 	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)
-- 
2.39.5


