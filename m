Return-Path: <kvm+bounces-29487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 464DD9AC90E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 613021C21342
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D5F1A3A95;
	Wed, 23 Oct 2024 11:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K1cwdy5X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39361ADFF1
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683257; cv=none; b=LYkQEDsMmLHhqQP3zRDWuox0uZj0CEp62aM8pGe9hsKcTFLj6LpNsa1PxKdLqUZL/WVjRucfK0mQs+aZw3xW2b7B82tMi5bbdpAazuxYy4h7yblvTkZXZW2FvLxVNMq3ITbwBRRjb5JyxmTFSQzEKGo7B6McjAFsjyeH2x9TZ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683257; c=relaxed/simple;
	bh=QWG9ZhP11lz8vpu7KdovjodYfeghGXgM0FmoYGZiK7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OL4PGNqV9y14pHALO+HgkvDpsblx6Wg7EMROm/8Pe6Jrprp6pjNil+AuRVdcmjk3iV0Tgfuk2/J+SWzZ4tdYjmDThVLCcPFeuQ/UMJEAfnVBwWflLfNxVynArB0b7AMzJijk9IFKmngLSrqhvqV6AguXAVZcrVt6COKzOm8ONSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K1cwdy5X; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c962c3e97dso8032481a12.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683254; x=1730288054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXxgum5YZeyhem1wJIKkI9XyHJDK2HstmvwMGCvFrKs=;
        b=K1cwdy5X88RCUZzad8upmcUW5oqrJGzzaoW0exdosF5bFgUKCIHZcn/KJpZ/UCQ+9d
         5ygIROaefyEIs8C8d9gwHsNBzgPoAM0FKvsssRmCBPgv7qjyumlGkkLB8r0Vvg5i/I8o
         b5yfO2Jfbn12+0rqJpfn7S/ml7QwPQG2zWCADTCeW3zuydeOzGGk5fc6L4p5y2pvKUDQ
         ClEnZ0+hiBjpPBU+QCxtCyc1RQilSH34QlaFMBrYGGOIvoF3mo44fp/O55DWBlkpDrYz
         kkLi/9i9KSsSR+0/11tQtOziyyafTKlK3JopyLZjBO6Jqjt76IHncm9NncZ+ZLXwsyL2
         VWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683254; x=1730288054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mXxgum5YZeyhem1wJIKkI9XyHJDK2HstmvwMGCvFrKs=;
        b=tEFSZHo4UKNVevxJ+gVxQXB0+IH5TAf3PhiHPvDNRkcLv/UgfBJTY+UwpkGmFxvIYw
         SAiypDMJmPn8IsxSTd3U3n2UK8cmTMvXB4HjOvacaRBg3DOGFBuCh+z/pc3o4zJBDCvY
         uwj9pPgRnUetIQ37iwOc8u+wYutgDmo7oHXELtTXw2RTJenEbolRade6fCRbp03uGREd
         NCfaEEFKxb5K5Hg/SnKNDy2JidVaiNeNblf9YYf+RbPGqFLWiBImJFpnj803Jlzdy7fU
         pdwAEeouw2GVukaTfeGSv3oilOKY3I87mS9j89VgDttPJ78w0ujyEjdDwDKUPMUYkqNB
         aHWg==
X-Forwarded-Encrypted: i=1; AJvYcCUtY0ZHRquj850JUH1F3lTEMXjUBV0uvIp0N0yZvC+39duK8b+mUbtQLgsH2Pm0fFmB0As=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhlBDKf1okQR+AxleIhI3x5ag7UfBBOUCBmzPHC6cyM0NBpoy1
	1os2fEBGAFVKR6egfe+Kpf00bqVufN/wJ1NA/OFNnjHWm3hTFb2elUdi+EebVyw=
X-Google-Smtp-Source: AGHT+IHRTit0g8/bbhEgsxdoStcLwtJwEj0lmJnkwGZ6qbwUYTq1iGytPFaoHqieRWzS0F839R+7jA==
X-Received: by 2002:a05:6402:2186:b0:5ca:d533:1c7b with SMTP id 4fb4d7f45d1cf-5cb8af6c62bmr2323197a12.28.1729683254182;
        Wed, 23 Oct 2024 04:34:14 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a654a2sm4338458a12.38.2024.10.23.04.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 9C8B75F92E;
	Wed, 23 Oct 2024 12:34:07 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v3 07/18] tests/tcg/x86_64: Add cross-modifying code test
Date: Wed, 23 Oct 2024 12:33:55 +0100
Message-Id: <20241023113406.1284676-8-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241023113406.1284676-1-alex.bennee@linaro.org>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
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
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20241022105614.839199-8-alex.bennee@linaro.org>
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


