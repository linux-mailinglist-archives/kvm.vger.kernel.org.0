Return-Path: <kvm+bounces-53406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F556B11328
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C90C3A699D
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D834B239E7E;
	Thu, 24 Jul 2025 21:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ElEtGwEl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEA7238D5A
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 21:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753392699; cv=none; b=RUYBO2aqnanOXJc6z5X0oKszDBGIgynib2HJR4vC33tUVGADrnQO1hMnF0Xlsj0CLIAgAoOEJ7aqP1l7HAz0V3Wylsf9gHbUfV0HZnVJ6TRIyzs/41mU186r9y38ljQTSfcuOnuy0SZyHh2TXYGoINmjtCaMdBnjdbJIcOSfkFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753392699; c=relaxed/simple;
	bh=CcMQesfCJBwPrJckuYkYkYqXUS3yf3NuqZ/LGh7bw0I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BEYF8ItOxoHC/p7aILDZldpyYhIXnNul6zbOGJjedm2zdIo+gCO75lH9BYyj4NtjNQvtv7Fq1xFgqGVivgh7dROB4V0EFVRQN9gxUxkwkN7SYGFqu+GloMhejEHBAS18e26p2m+5TnIN0FuagHOk16e604K16TfQN5H8Rs7ldfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ElEtGwEl; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0e0c573531so1043307a12.3
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 14:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753392696; x=1753997496; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EF9sxiK3Xy/PXVuW+exVELSMPBsoTeCFIahlM0k1Eq0=;
        b=ElEtGwElPPI5IUiAm/nCr3+6O1OltxBXtfvaSMiQ0DCqclY4IcA2bUuYnFPgJJ1Bsm
         zMvHx6NSjUSeLuwfQ2exSV5Z3r0dJxoz+dF4CV48ox0q9nDy+PXZO9v70jSde/ryNFuE
         f1HB9WAr58gN5zbQWWWzUoT/sHXaT2KA10R6eSHIcAIGiU4u7ruFfL8yAspaaFH9J3Sm
         /2I46H2DUbm/4mJf5jS7xb128itFf0WVBtB3h5pRUa8ynksDJfttmi9yOm0r0QU9NYYQ
         jxP+2RSknzF6riVJvj6LDxfSzh8yz8+dNiZOVwwTXg2c9L0SE/TxpzAREo2kAvMCPPte
         Hsag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392696; x=1753997496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EF9sxiK3Xy/PXVuW+exVELSMPBsoTeCFIahlM0k1Eq0=;
        b=GC4+4eS4rT3QoNf3gAA2edFDGoSsLxxqeDEy47NGk9omFM6BZWbWQimxaMFDGoGzHG
         Xv3YXO1bkSyJCRU1Ddb3S5l0pn5suQWRnpIqPG4YaePpeJaV4xkHEDUMMQ+pUnA2WkVi
         4+6BB7dIyrCSEFstjqIE+awzjQwQsisW9wkcg5h2pMMtP0k7K0j5meR13h5QJhDqphqS
         7JPkN5oD5TVFCZwICmxVXy/C2aynFE+pSTNhuLNTvpYanjCxmVmCypYLzRRu/lPzbN/Y
         kTiWmjEcYX6VCJ4evo97ADxrvl1pgq/vUw5GWZa3ETOjS7au4bSkx9ho4opus8tRbzbH
         fAAA==
X-Forwarded-Encrypted: i=1; AJvYcCXjAYLRJHCmynf4RHdBN1UA+q/duxDmd3eqTuFmHq0OBLlSkB1+rLD3qFiPmgyt5hJ4g8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5eFwbb2kH3nzxWRzApYfjLd8sxZ8sRnRHfFPIR7yDFluCHBbU
	49RKYILmrwUC+lyR1A+n/Vbf//fB80yEfIlsZ1xBatB1i607zvndch2GF70CCFhp+IWu2aG9AXH
	fURi3bkJljGlVEg==
X-Google-Smtp-Source: AGHT+IEVnap/eu9Dz2ddWw4wyMBOt0WtnZUh233sGTHqAfXQEwS/hWW2xddcmUxipaoBtbgbu5pOyoCLHXoZEA==
X-Received: from pfbct19.prod.google.com ([2002:a05:6a00:f93:b0:73c:26eb:39b0])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:a346:b0:215:df3d:d56 with SMTP id adf61e73a8af0-23d490e7f2dmr13646377637.21.1753392695802;
 Thu, 24 Jul 2025 14:31:35 -0700 (PDT)
Date: Thu, 24 Jul 2025 21:31:29 +0000
In-Reply-To: <20250724213130.3374922-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250724213130.3374922-1-dmatlack@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250724213130.3374922-2-dmatlack@google.com>
Subject: [PATCH v2 1/2] Revert "KVM: selftests: Override ARCH for x86_64
 instead of using ARCH_DIR"
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

This reverts commit 9af04539d474dda4984ff4909d4568e6123c8cba.

If ARCH is set on the command line then Make will skip the variable
assignment to convert x86_64 to x86. i.e. Revert this commit because it
breaks builds where ARCH=x86_64 is specified on the command line.

Fixes: 9af04539d474 ("KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile     |  4 +++-
 tools/testing/selftests/kvm/Makefile.kvm | 26 ++++++++++++------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d9fffe06d3ea..7aad782aeb1d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -6,7 +6,9 @@ ARCH            ?= $(SUBARCH)
 ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64 loongarch))
 # Top-level selftests allows ARCH=x86_64 :-(
 ifeq ($(ARCH),x86_64)
-	ARCH := x86
+	ARCH_DIR := x86
+else
+	ARCH_DIR := $(ARCH)
 endif
 include Makefile.kvm
 else
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index e11ed9e59ab5..d770c2f244da 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -215,10 +215,10 @@ TEST_GEN_PROGS_loongarch += set_memory_region_test
 SPLIT_TESTS += arch_timer
 SPLIT_TESTS += get-reg-list
 
-TEST_PROGS += $(TEST_PROGS_$(ARCH))
-TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
-TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
-LIBKVM += $(LIBKVM_$(ARCH))
+TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
+TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
+LIBKVM += $(LIBKVM_$(ARCH_DIR))
 
 OVERRIDE_TARGETS = 1
 
@@ -231,24 +231,24 @@ include ../cgroup/lib/libcgroup.mk
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH_DIR)/include
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
 	-fno-builtin-memcmp -fno-builtin-memcpy \
 	-fno-builtin-memset -fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -fno-strict-aliasing \
 	-I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
-	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH) \
+	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH_DIR) \
 	-I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
-ifeq ($(ARCH),s390)
+ifeq ($(ARCH_DIR),s390)
 	CFLAGS += -march=z10
 endif
-ifeq ($(ARCH),x86)
+ifeq ($(ARCH_DIR),x86)
 ifeq ($(shell echo "void foo(void) { }" | $(CC) -march=x86-64-v2 -x c - -c -o /dev/null 2>/dev/null; echo "$$?"),0)
 	CFLAGS += -march=x86-64-v2
 endif
 endif
-ifeq ($(ARCH),arm64)
+ifeq ($(ARCH_DIR),arm64)
 tools_dir := $(top_srcdir)/tools
 arm64_tools_dir := $(tools_dir)/arch/arm64/tools/
 
@@ -282,7 +282,7 @@ LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
 LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIBCGROUP_O)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
-SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
+SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH_DIR)/%.o, $(SPLIT_TESTS))
 
 TEST_GEN_OBJ = $(patsubst %, %.o, $(TEST_GEN_PROGS))
 TEST_GEN_OBJ += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
@@ -291,7 +291,7 @@ TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
 TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TEST_GEN_OBJ))
 -include $(TEST_DEP_FILES)
 
-$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
+$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
 
 $(filter-out $(SPLIT_TEST_GEN_PROGS), $(TEST_GEN_PROGS)) \
 $(TEST_GEN_PROGS_EXTENDED): %: %.o
@@ -299,9 +299,9 @@ $(TEST_GEN_PROGS_EXTENDED): %: %.o
 $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
+$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH_DIR)/%.o
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
-$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
+$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH_DIR)/%.o: $(ARCH_DIR)/%.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 EXTRA_CLEAN += $(GEN_HDRS) \
-- 
2.50.1.470.g6ba607880d-goog


