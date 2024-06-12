Return-Path: <kvm+bounces-19407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 87C79904ADA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BEF2B22169
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D1F44C6F;
	Wed, 12 Jun 2024 05:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CzKklzZg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1BD4437D
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169862; cv=none; b=F0DerilZplTF3tsaD3t/vamGHjfytKsFdHIwgL7JSUiXodF3DN23PIx3abN4Vhg4FRFHosiLQxHZ+3sRo1cj4IXqlTizD2bCTdcZsBQsqKkP4MJDqh0M6gD+ZEQIZRAsL7orcAlitSOKKQuXZ5UFgWYT4YHBHjQmT1Akj0uISts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169862; c=relaxed/simple;
	bh=S9VIH50LhKDvHH1wBXgLHxLxSyb9oXivoJxd3qTSHgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx602BWAqaeEEGTeGn9Aw/alrPplCJuXyXYy7ASfz9iJtHOFaiw5D5+DSGz8icmJGk7pnKcYZsordi8U+jVnkcEbuAmI1f0zWYUGD10I9OdnbSzspvSsneBRK4/9pJSzicfm+EpFcTlH203lB8lWXxpjjcog90huFRdKc6ew4mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CzKklzZg; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f70509b811so24221495ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169861; x=1718774661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ov2H6CvAf7+nJ+8vHcgazEvP35meWrkDmpE16so9J0U=;
        b=CzKklzZgh00hvugrtMT78Fg3PrfMx9SL24wW7TfJN1EvgPjxiEf7g9t224c1qsuMyb
         sO59BH6Pp9TfFYfPFZOPaZZU8gusP4206yxVZRyyK4beiWrqkw7qxIijCLxjyqYOAvWV
         FVDM14Mum1sVOF5CBWHobiVuV4WCiGjfPqBgm2QeG9TjpG3MJfYaCvN0LfDKUEUgzvFr
         F4p8BajJTsuIqrgdD+BsF96nZh7DW2DfRRs9RFTdSmL+TmJYuOpJQK/6iqlxF8a3Tq8Q
         Ukt84nIwL3JgpxpJ6ZIVmTvElj1gqkb8041/hNBJ6Tzf2FvOmBdzkeZUGXBXQXStAOXd
         oErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169861; x=1718774661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ov2H6CvAf7+nJ+8vHcgazEvP35meWrkDmpE16so9J0U=;
        b=l9fQ+TaMErSDyzpI63XawM/COrRI/qSM3IILhfrOSBDgO2iG+AvKmymUx93PYvmbww
         2HajRWmhbKGtYIJe8jnKbIkRNks2P3gfSepAb0CeaEWoFA+u9yYELYAuqDNaXqEFOS/c
         WSopu0+tHwDE/lPyXzdFHrtwTpX7rjzOJKIeWb8gCiGL7z6FA/Vqx/NBskHTw1dclxtU
         XaiJeYGztRR2VYZeWtNNa1XOE2xJjAxQaLYV4JLsJKWd7I/RA3ANypcHjtWDlw8i+Kzt
         +6ivTliyHTm2cEWjoRCXpJU+nUU3CsxG1DmX56zKrwHSDtX46Dh9nJhp/EJlSQdR+k6W
         K7SQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqrN7FninmvqwfSAKqKsmD/JNQPQkeqgjrWxzWgaxtKL1qvbz8vPCAUno881tqkAFHUvdUovoru5I2IqLhBrEZYlCY
X-Gm-Message-State: AOJu0YzM6xPjIU29Da+w0rF+3LbtjERvseYRgp/H5qfNr4DSYfTwDZGy
	HtzrWoakpDWEVqIyiC7BHn3HychmWCNgfpclqVlczUS6enJfX/Vo
X-Google-Smtp-Source: AGHT+IFK+RWCn1upQXe3RKipRXNTH/O9r+U30yabOqdDmeKU44uJZ/dinNzYARKqzW7k18zx2pJJVQ==
X-Received: by 2002:a17:903:1c4:b0:1f7:178d:6990 with SMTP id d9443c01a7336-1f83b5eb0fdmr11078365ad.22.1718169860868;
        Tue, 11 Jun 2024 22:24:20 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:24:20 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 13/15] powerpc: Add a panic test
Date: Wed, 12 Jun 2024 15:23:18 +1000
Message-ID: <20240612052322.218726-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds a simple panic test for pseries and powernv that works with
TCG (unlike the s390x panic tests), making it easier to test this part
of the harness code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/rtas.h |  1 +
 lib/powerpc/rtas.c     | 16 ++++++++++++++++
 powerpc/run            |  2 +-
 powerpc/selftest.c     | 18 ++++++++++++++++--
 powerpc/unittests.cfg  |  5 +++++
 5 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/lib/powerpc/asm/rtas.h b/lib/powerpc/asm/rtas.h
index 364bf9355..2dcb2f1b3 100644
--- a/lib/powerpc/asm/rtas.h
+++ b/lib/powerpc/asm/rtas.h
@@ -26,6 +26,7 @@ extern int rtas_call(int token, int nargs, int nret, int *outputs, ...);
 extern int rtas_call_unlocked(struct rtas_args *args, int token, int nargs, int nret, int *outputs, ...);
 
 extern void rtas_power_off(void);
+extern void rtas_os_panic(void);
 extern void rtas_stop_self(void);
 #endif /* __ASSEMBLY__ */
 
diff --git a/lib/powerpc/rtas.c b/lib/powerpc/rtas.c
index 9c1e0affc..98eee24f4 100644
--- a/lib/powerpc/rtas.c
+++ b/lib/powerpc/rtas.c
@@ -182,3 +182,19 @@ void rtas_power_off(void)
 	ret = rtas_call_unlocked(&args, token, 2, 1, NULL, -1, -1);
 	printf("RTAS power-off returned %d\n", ret);
 }
+
+void rtas_os_panic(void)
+{
+	struct rtas_args args;
+	uint32_t token;
+	int ret;
+
+	ret = rtas_token("ibm,os-term", &token);
+	if (ret) {
+		puts("RTAS ibm,os-term not available\n");
+		return;
+	}
+
+	ret = rtas_call_unlocked(&args, token, 1, 1, NULL, "rtas_os_panic");
+	printf("RTAS ibm,os-term returned %d\n", ret);
+}
diff --git a/powerpc/run b/powerpc/run
index 27abf1ef6..4cdc7d16c 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -56,7 +56,7 @@ fi
 
 command="$qemu -nodefaults $A $M $B $D"
 command+=" -display none -serial stdio -kernel"
-command="$(migration_cmd) $(timeout_cmd) $command"
+command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
 
 # powerpc tests currently exit with rtas-poweroff, which exits with 0.
 # run_qemu treats that as a failure exit and returns 1, so we need
diff --git a/powerpc/selftest.c b/powerpc/selftest.c
index 8d1a2c767..101cfcdef 100644
--- a/powerpc/selftest.c
+++ b/powerpc/selftest.c
@@ -7,6 +7,7 @@
  */
 #include <libcflat.h>
 #include <util.h>
+#include <asm/rtas.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
 
@@ -47,6 +48,17 @@ static void check_setup(int argc, char **argv)
 		report_abort("missing input");
 }
 
+static void do_panic(void)
+{
+	if (machine_is_pseries()) {
+		rtas_os_panic();
+	} else {
+		/* Cause a checkstop with MSR[ME] disabled */
+		*((char *)0x10000000000) = 0;
+	}
+	report_fail("survived panic");
+}
+
 int main(int argc, char **argv)
 {
 	report_prefix_push("selftest");
@@ -57,9 +69,11 @@ int main(int argc, char **argv)
 	report_prefix_push(argv[1]);
 
 	if (strcmp(argv[1], "setup") == 0) {
-
 		check_setup(argc-2, &argv[2]);
-
+	} else if (strcmp(argv[1], "panic") == 0) {
+		do_panic();
+	} else {
+		report_abort("unknown test %s", argv[1]);
 	}
 
 	return report_summary();
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 89455b618..9e7df22f4 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -18,6 +18,11 @@ smp = 2
 extra_params = -m 1g -append 'setup smp=2 mem=1024'
 groups = selftest gitlab-ci
 
+[selftest-panic]
+file = selftest.elf
+extra_params = -append 'panic'
+groups = selftest panic gitlab-ci
+
 [selftest-migration]
 file = selftest-migration.elf
 machine = pseries
-- 
2.45.1


