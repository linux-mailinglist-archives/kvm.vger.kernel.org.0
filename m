Return-Path: <kvm+bounces-53407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF0AB11327
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 031625A6BCF
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D0223A997;
	Thu, 24 Jul 2025 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0QKqhZT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E848D239E8D
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 21:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753392701; cv=none; b=pBb+1e5U7TToA3DdmTZWzKmvoTI5wAlwdN+pgBQPNMACNwm2X1WXTJSS9UcL2p+NcaBMaoy3PBBBo41igOyV7lFbvmqscw5EK3ZLbDLXAWJw7P/vim+wHX1s3QfU4qOOL0C2zArqmb/6OEZj1z3jHw8VmNjpIbL72mop3JUAO24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753392701; c=relaxed/simple;
	bh=fPBDK1Pb01xY3o+AzsWHtdEJpvtaRS6ST0yKdiJ32js=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QRarRnXs25SE1BVHbpNIhFgA/PKS8b76hEUkIq/9zPcLl05454joyt89x86lAdjtty78bWHFn0ift49Pct9GVsfB203NcShKSpf9hAkv/O1IozmxFAzrL01mSm/lS7lE+CUJL1QJuuvUL4ha9mwACt6d9ilzlcTACyTcl9JWe/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s0QKqhZT; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74943a7cd9aso2524796b3a.3
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 14:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753392697; x=1753997497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GNn2q0Z8fFnvvjG2A8fpdx/gfmHIZHIsS4NnWlZQeUk=;
        b=s0QKqhZTxhcNuIyw8rmMm9Tun149cEgIYz42YTLe1+qgDsvo5aNXGNjshRWSj2b1Cv
         j+ijyIVlhEIgL29WvhypFlbZRJ5MwEunE8BaYw1YXiBXpJ18T8xdlS7A8/he9SaYHszV
         Oscbbfe5EKMAzrFy417BZsRnuVY4b4R5p/H/vCL9d6XBWe1CV218TIvJSCzXRKudehid
         eNmz9EVSF6y9aHkXx8q+GxFW7prQ3JnVnAdjJbej4ioRVikJNZZA+/O8/Lep0TcqUweD
         nZJQEO+pe6bvEvodmgGmTLF/ep9nqZA6+gyXJLgrB9DkfYvkndlonegee1X6/9S+NCJl
         FrgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753392697; x=1753997497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GNn2q0Z8fFnvvjG2A8fpdx/gfmHIZHIsS4NnWlZQeUk=;
        b=Q9czrbj4rqYO3DwS4XnXWSv2HzXPRDKW0/42OKKeMNDfyMtXTBlLYx1FtXFlvtOHbj
         CgiRbx9lve47UWOHayNh8ogUNauc/AkZVKEN9ey40YszbLR4qlDGMNOqNiZH7sBcKLot
         x5+zIJMqo9HUUODeBv/xfMCcwlcIRNUm9DScWfLpmvub+47WN3jFrQC4KZnRKK3qA6Eb
         aPU7Hi4vDD4WBdCyfoQotAdOtgQxk6EiIIYlTbUuYlKJeEEXoxyNMFTgmE8fJA+3p2zj
         VHUBILYufz0/NJxKm/AQQLdwxTpQelMd8KjG83ZNl2vQYvKOQEc+2KcQsNoE/xgrQ9la
         UFRg==
X-Forwarded-Encrypted: i=1; AJvYcCWIq2SP/SnUqbDBolcBGJctx2PQ3o+H5Sdh2RfiwLsRlBlTG3sUk2Yk1hXUdTjcUSOCqNs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3oDhKI0WgMgTtVS1EmPVEDViPvpCKSSSOFlTRDxmZbvREmoyW
	6uNRb6q5UQsGm1yPZwYnyjPv7Ku1NXmt5M0MusvwpDm1VKtcKHN4IdkZY77FSgjgFETIsQ8cZpu
	oXeNCZDBM7jx/6w==
X-Google-Smtp-Source: AGHT+IFvUnez9Bkuwx2pMJHu6VcnoXxwXp4RquHl0WtbI1rpTaCty2K5T3a3JzCxfErZmH7ew+8CdlnN0ixiJg==
X-Received: from pfbjr14.prod.google.com ([2002:a05:6a00:914e:b0:747:a8ac:ca05])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2315:b0:748:2ac2:f8c3 with SMTP id d2e1a72fcca58-76035bfa5ebmr11692206b3a.24.1753392697163;
 Thu, 24 Jul 2025 14:31:37 -0700 (PDT)
Date: Thu, 24 Jul 2025 21:31:30 +0000
In-Reply-To: <20250724213130.3374922-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250724213130.3374922-1-dmatlack@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250724213130.3374922-3-dmatlack@google.com>
Subject: [PATCH v2 2/2] KVM: selftests: Rename $(ARCH_DIR) to $(SRCARCH)
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Sean Christopherson <seanjc@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename $(ARCH_DIR) to $(SRCARCH) to match the top-level kernel Makefile
which uses $(SRCARCH) to represent the same thing that $(ARCH_DIR)
represents in the KVM selftests.

This change also paves the way for eventually sharing the code construct
$(SRCARCH) with the top-level kernel Makefile instead of KVM having its
own logic e.g. to convert x86_64 to x86.

While here, drop the comment about the top-level selftests allowing
ARCH=x86_64. The kernel itself allows/expects ARCH=x86_64 so it's
reasonable to expect the KVM selftests to handle it as well.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile     | 10 ++++-----
 tools/testing/selftests/kvm/Makefile.kvm | 26 ++++++++++++------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7aad782aeb1d..340657052fc3 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -1,15 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0-only
 top_srcdir = ../../../..
+
 include $(top_srcdir)/scripts/subarch.include
 ARCH            ?= $(SUBARCH)
+SRCARCH := $(ARCH)
 
-ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64 loongarch))
-# Top-level selftests allows ARCH=x86_64 :-(
 ifeq ($(ARCH),x86_64)
-	ARCH_DIR := x86
-else
-	ARCH_DIR := $(ARCH)
+        SRCARCH := x86
 endif
+
+ifeq ($(SRCARCH),$(filter $(SRCARCH),arm64 s390 riscv x86 loongarch))
 include Makefile.kvm
 else
 # Empty targets for unsupported architectures
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index d770c2f244da..d2729e678025 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -215,10 +215,10 @@ TEST_GEN_PROGS_loongarch += set_memory_region_test
 SPLIT_TESTS += arch_timer
 SPLIT_TESTS += get-reg-list
 
-TEST_PROGS += $(TEST_PROGS_$(ARCH_DIR))
-TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
-TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
-LIBKVM += $(LIBKVM_$(ARCH_DIR))
+TEST_PROGS += $(TEST_PROGS_$(SRCARCH))
+TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(SRCARCH))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(SRCARCH))
+LIBKVM += $(LIBKVM_$(SRCARCH))
 
 OVERRIDE_TARGETS = 1
 
@@ -231,24 +231,24 @@ include ../cgroup/lib/libcgroup.mk
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH_DIR)/include
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(SRCARCH)/include
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
 	-fno-builtin-memcmp -fno-builtin-memcpy \
 	-fno-builtin-memset -fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -fno-strict-aliasing \
 	-I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
-	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH_DIR) \
+	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(SRCARCH) \
 	-I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
-ifeq ($(ARCH_DIR),s390)
+ifeq ($(SRCARCH),s390)
 	CFLAGS += -march=z10
 endif
-ifeq ($(ARCH_DIR),x86)
+ifeq ($(SRCARCH),x86)
 ifeq ($(shell echo "void foo(void) { }" | $(CC) -march=x86-64-v2 -x c - -c -o /dev/null 2>/dev/null; echo "$$?"),0)
 	CFLAGS += -march=x86-64-v2
 endif
 endif
-ifeq ($(ARCH_DIR),arm64)
+ifeq ($(SRCARCH),arm64)
 tools_dir := $(top_srcdir)/tools
 arm64_tools_dir := $(tools_dir)/arch/arm64/tools/
 
@@ -282,7 +282,7 @@ LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
 LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ) $(LIBCGROUP_O)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
-SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH_DIR)/%.o, $(SPLIT_TESTS))
+SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(SRCARCH)/%.o, $(SPLIT_TESTS))
 
 TEST_GEN_OBJ = $(patsubst %, %.o, $(TEST_GEN_PROGS))
 TEST_GEN_OBJ += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
@@ -291,7 +291,7 @@ TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
 TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TEST_GEN_OBJ))
 -include $(TEST_DEP_FILES)
 
-$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH_DIR) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
+$(shell mkdir -p $(sort $(OUTPUT)/$(SRCARCH) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
 
 $(filter-out $(SPLIT_TEST_GEN_PROGS), $(TEST_GEN_PROGS)) \
 $(TEST_GEN_PROGS_EXTENDED): %: %.o
@@ -299,9 +299,9 @@ $(TEST_GEN_PROGS_EXTENDED): %: %.o
 $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH_DIR)/%.o
+$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(SRCARCH)/%.o
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
-$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH_DIR)/%.o: $(ARCH_DIR)/%.c
+$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(SRCARCH)/%.o: $(SRCARCH)/%.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 EXTRA_CLEAN += $(GEN_HDRS) \
-- 
2.50.1.470.g6ba607880d-goog


