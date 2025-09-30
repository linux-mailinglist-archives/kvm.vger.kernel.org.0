Return-Path: <kvm+bounces-59190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C06BAE10B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0686B4C06F4
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD7D3259C94;
	Tue, 30 Sep 2025 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OllB5weS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D05724DD17
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250227; cv=none; b=kta/etpPNdDWlyBem9tvOTOy1daxtUC4jVQ1P76+5FLFFjOS2MLBJeXkjiNwQLxTrFJo4/ONyOTZA79jOfJAbRrk03CZQq8j4pA/DbHYMpJ6T9BC6KsjnDVHQzdSL/v6PwJgFSPU+aHpZ+69i5mT7u8mNlvmB7NfRPH3y6nwDpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250227; c=relaxed/simple;
	bh=ht7r0j9TStYFSS39J6A9S6LE0usVn0dEUwTN+cHJek4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t3LGFo9j3Thi8oQWdQL1ApeOgMEhw3Mmn5odDAxyzM0d46ziXrgbtTawqdGPOz+XCFkVdHw4s5EwshGR3UunkC20p2XWu8/yzM6fRyEqcLpQfU9QFn0tZ3NQ0Pfn+YHGmflF/hpOjdJFP84WBuV+xziVnIW0Ls8sOc8Anq7ij/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OllB5weS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3305c08d975so6203603a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250223; x=1759855023; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PDB4Bxe6YCqhMG0texjm2F7bd+t0DxvCH5y7s56NZ8g=;
        b=OllB5weSOx8IRBhKXc4tejRlEXcFjiNFtP8igOJ6S6h5aHQvouP9uzfB3L9cHTF40Y
         H+EOGIXk1+x3mxNDBTQm0q/flLZPuoInyJ8FdDTn3oCoqrI/56IpRwgN5gjWSZyk3A6y
         qfoERyxnySeQhoVq3KW35g4JbPFoMzxGcc+KElUvfMnttPhLIPHQCbQ/EzwDA4UACKft
         URKUH9OrtZnN/tFyw2MpMhcu9i93SQhxV72Q8VCl4l+hy0VWATuVByZ8jRwnEh2WhFa3
         bmavmhxG05dmfkNMUlXfT+Eiyyw7gLVm9N+LF00cEJUZO5uVBUuA0548qXkidtTEXuCA
         FWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250223; x=1759855023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PDB4Bxe6YCqhMG0texjm2F7bd+t0DxvCH5y7s56NZ8g=;
        b=DCsAWhaPVJ6F5KQ+0bBF1RXEyMQ4CWAxoQuJYVEhABhSEfJRXXGmfvgEa5TVX9gGQ/
         sL9t8P6z1SD7J0foZC0uQxkf+gxOHygpuDf9t+n6GbIKdp+tu1eOlmqyBVXPr5pKNn88
         NNTJXtoA8PMzERnHjt5DPMoqnHObXtZNa0PHHGTFm5wuT7R1yKVyGoUgWRi5A9ZAIzh5
         aOYSdywwVbfmz081MnurP9oIG4AwearuHbrnyE6Bc1UW83S8rpLImS4dINpJAIRAyBPm
         aJsCsvMyQK4q+4dteuLSMcfqFMUx2rAOxeazhE/LtqsPFfokCITDwxp/O87PFIklx/rQ
         S4NQ==
X-Gm-Message-State: AOJu0YwETNA1WNO+cYGG7FXgm6NyH2Bq8FibvntnrMo7tQiLP0Hd1oDI
	DtiowIAma7KA5ptNmEFc8ekdCu5rrl7lSxdYDN6TyctGCUBKQ1z274STRnXD6Mccn+VhFp2ed6W
	ACvoiD+9pf4yGJo2zI3sSa59rkXPhEbgnAKLRn2f7T5AD7haodyHoXeHmawAMeCDfbAG9JwZDM1
	Kz1b1+qbcbTEQJWoQYt3LfpoaKRCXbgyItmuhOvA==
X-Google-Smtp-Source: AGHT+IFH7MY9VunA10xfm7S9xXyjqnmpJ9IaA0KI2bTcJ1mC7PTk9P775POawCgRman2ri0lXRnMzI5UF9gA
X-Received: from pjbcz15.prod.google.com ([2002:a17:90a:d44f:b0:327:e021:e61d])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a92:b0:334:29f0:a7e4
 with SMTP id 98e67ed59e1d1-339a6f36cbamr103438a91.21.1759250222318; Tue, 30
 Sep 2025 09:37:02 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:36:34 -0700
In-Reply-To: <20250930163635.4035866-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250930163635.4035866-1-vipinsh@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930163635.4035866-9-vipinsh@google.com>
Subject: [PATCH v3 8/9] KVM: selftests: Add rule to generate default tests for
 KVM selftests runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org, 
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn, 
	chenhuacai@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	ajones@ventanamicro.com, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add 'tests_install' rule in the Makefile.kvm to auto generate default
testcases for KVM selftests runner. Preserve the hierarchy of test
executables for autogenerated files. Remove these testcases on
invocation of 'make clean'.

Autogeneration of default test files allows runner to execute default
testcases easily. These default testcases don't need to be checked in as
they are just executing the test without any command line options.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/.gitignore   |  1 +
 tools/testing/selftests/kvm/Makefile.kvm | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 95af97b1ff9e..548d435bde2f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -7,6 +7,7 @@
 !*.S
 !*.sh
 !*.test
+default.test
 !.gitignore
 !config
 !settings
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 41b40c676d7f..6bb63f88c0e6 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -306,11 +306,15 @@ $(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
 $(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
+# Default testcases for KVM selftests runner will be generated in this directory.
+DEFAULT_TESTCASES = testcases_default_gen
+
 EXTRA_CLEAN += $(GEN_HDRS) \
 	       $(LIBKVM_OBJS) \
 	       $(SPLIT_TEST_GEN_OBJ) \
 	       $(TEST_DEP_FILES) \
 	       $(TEST_GEN_OBJ) \
+	       $(OUTPUT)/$(DEFAULT_TESTCASES) \
 	       cscope.*
 
 $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
@@ -339,3 +343,19 @@ cscope:
 	find . -name '*.c' \
 		-exec realpath --relative-base=$(PWD) {} \;) | sort -u > cscope.files
 	cscope -b
+
+# Generate testcases in DEFAULT_TESTCASES directory.
+# $(OUTPUT) is either CWD or specified in the make command.
+tests_install: list_progs = $(patsubst $(OUTPUT)/%,%,$(TEST_GEN_PROGS))
+tests_install:
+	$(foreach tc, $(TEST_PROGS), \
+		$(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(patsubst %.sh,%,$(tc))))
+	$(foreach tc, $(TEST_PROGS), \
+		$(shell echo $(tc) > $(patsubst %.sh,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
+
+	$(foreach tc, $(list_progs), \
+		$(shell mkdir -p $(OUTPUT)/$(DEFAULT_TESTCASES)/$(tc)))
+	$(foreach tc, $(list_progs), \
+		$(shell echo $(tc) > $(patsubst %,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
+
+	@:
-- 
2.51.0.618.g983fd99d29-goog


