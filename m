Return-Path: <kvm+bounces-45003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78DF6AA581C
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 00:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 362711C0761E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 22:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0668226CE1;
	Wed, 30 Apr 2025 22:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KsUYag1b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F189225A29
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 22:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746053245; cv=none; b=djtWW/+TddmPrMtWrZnbm1mIoEmQmn+DSeYPdL7fcB3jm9Hy+NIeZGB+G6y0O3pz8a8MjbGYF9uSj/ke9Dt5QhmxmtlIsekOHJXJRvDb+iUtZFWsjPKhJT+hjMIUgUha9joMsLEKWEeLw7cuIBBD6YaSQpxC+yo29NBx8Lhz5Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746053245; c=relaxed/simple;
	bh=2vYGYCet0hjMU3TSdiP7asYFuc8P2tPj9FAeZb0nawY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D/465qmEHw67p9uGYAVl45bDuRiu0VX3s+1A0np/FE3GXxVda05CXEsIyIbR/ES5pySA3PEh5Azsx1i/8fjHabqglCTosUVnqhgEEy7JsYyPK4KP85PntbST5iVdpeY/NkSbeNxj55rxfOH/c9khDxLYB9Rd4nd61y+QhjBIs28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KsUYag1b; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-224347aef79so4757375ad.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 15:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746053243; x=1746658043; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I6d6xMX81cfx8vl/Zx5jrRQk1gOoG8o0iyTTHEscye4=;
        b=KsUYag1bppWfBdCDddJDa0gLDWv82CiDu+O3bTWfhHC01emt/Li7Q1+yVHeeKMIO+P
         8Ae92OjoO1SInX11oWkcokt0euF6KYayFZrbDSrQeHyWnigVxfSAmgRHL+4aZvKHr8sA
         j7romaxazFDeQQoQGYchWqzhup/SlsV8TcIXIy1k/iYl68BCTCGEEMBar9TdKkjFf/2G
         F/9QDcZLnYFU5CiEGhXh5pRibD9mGmFtD2zfae/Di44s3U+LBahStXGrSzmmBE66DktJ
         T08E7Shv6i/2n30IeNjXpMrSWq60BlsESp2ck5W/TvjUw507S6U9jrviOYehTxh0DBUK
         7KQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746053243; x=1746658043;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I6d6xMX81cfx8vl/Zx5jrRQk1gOoG8o0iyTTHEscye4=;
        b=gF6L++h2EZrkDSEdehYk7EREh2JvfJ/HjeoYWHFK2YG0h1hfps0ogPzmqKsOF/NzYA
         34jyoEkX8yF2/Ns/dvBG5I7iYlYcwR3JnMFT8zh8VtHnu/mPZlJlpuHhLCHb9klB1pG6
         qY8cXgFMpdMn26oe+PU43oGfXysNBtp1Gmp+h15RoWsRQGEcj3S0idtEQraV3Dw6R22S
         qx6m4hcoeQUME4dmJBiOjUOnMRTdtbCOIyHL+tHFsv9PoM4ZwzmEviWb3P47maTndTiw
         7iS1dvaWfF/4X/7E1oXPkGhGglLnEQNsJy3dCBybw9fujUoQT3VlbboJrd89+RA7uXuU
         0ETg==
X-Forwarded-Encrypted: i=1; AJvYcCWefhIRB5xWEtB4X8VglJnxpPifIDuNIoMZdwlrG0DR4wN7ql/kE09kXpievuir8ApRcw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLI7GK9w4XnRQBYAKULuuPMqC6lGv0ZPIje8uM+p2EZkAbG6pu
	CEvyFzSoJkDrE/xInC6dXd3aF71UvkLkkC4hLAlZPHpyoJ5vIaHBC9ngANySHpfeuRpqqtWDeAg
	2thu2kKDVoA==
X-Google-Smtp-Source: AGHT+IHfuB23NFkGxUOAohzZBfnYlQDcsto8mmtSQcnh90hh0T1xBgxRL74TiSJiuHrr2SC7EIvaioBXJP/2qw==
X-Received: from plblq15.prod.google.com ([2002:a17:903:144f:b0:223:6458:d313])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f693:b0:223:90ec:80f0 with SMTP id d9443c01a7336-22e040c1f99mr12828775ad.22.1746053243561;
 Wed, 30 Apr 2025 15:47:23 -0700 (PDT)
Date: Wed, 30 Apr 2025 15:47:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250430224720.1882145-1-dmatlack@google.com>
Subject: [PATCH] KVM: selftests: Use $(SRCARCH) instead of $(ARCH)
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Sean Christopherson <seanjc@google.com>, Muhammad Usama Anjum <usama.anjum@collabora.com>, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Use $(SRCARCH) in Makefile.kvm instead of $(ARCH). The former may have
been set on the command line and thus make will ignore the variable
assignment to convert x86_64 to x86.

Introduce $(SRCARCH) rather than just reverting commit 9af04539d474
("KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR")
to keep KVM selftests consistent with the top-level kernel Makefile,
which uses $(SRCARCH) for the exact same purpose.

While here, drop the comment about the top-level selftests allowing
ARCH=x86_64. The kernel itself allows/expects ARCH=x86_64 so it's
reasonable to expect the KVM selftests to handle it as well.

Fixes: 9af04539d474 ("KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile     | 10 +++++----
 tools/testing/selftests/kvm/Makefile.kvm | 26 ++++++++++++------------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 20af35a91d6f..02bf061c51f8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -1,13 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0-only
 top_srcdir = ../../../..
+
 include $(top_srcdir)/scripts/subarch.include
-ARCH            ?= $(SUBARCH)
+ARCH 	?= $(SUBARCH)
+SRCARCH := $(ARCH)
 
-ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64))
-# Top-level selftests allows ARCH=x86_64 :-(
 ifeq ($(ARCH),x86_64)
-	ARCH := x86
+        SRCARCH := x86
 endif
+
+ifeq ($(SRCARCH),$(filter $(SRCARCH),arm64 s390 riscv x86))
 include Makefile.kvm
 else
 # Empty targets for unsupported architectures
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f62b0a5aba35..065029b35355 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -193,10 +193,10 @@ TEST_GEN_PROGS_riscv += steal_time
 SPLIT_TESTS += arch_timer
 SPLIT_TESTS += get-reg-list
 
-TEST_PROGS += $(TEST_PROGS_$(ARCH))
-TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
-TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
-LIBKVM += $(LIBKVM_$(ARCH))
+TEST_PROGS += $(TEST_PROGS_$(SRCARCH))
+TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(SRCARCH))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(SRCARCH))
+LIBKVM += $(LIBKVM_$(SRCARCH))
 
 OVERRIDE_TARGETS = 1
 
@@ -208,24 +208,24 @@ include ../lib.mk
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
-LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
+LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(SRCARCH)/include
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
 	-fno-builtin-memcmp -fno-builtin-memcpy \
 	-fno-builtin-memset -fno-builtin-strnlen \
 	-fno-stack-protector -fno-PIE -fno-strict-aliasing \
 	-I$(LINUX_TOOL_INCLUDE) -I$(LINUX_TOOL_ARCH_INCLUDE) \
-	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(ARCH) \
+	-I$(LINUX_HDR_PATH) -Iinclude -I$(<D) -Iinclude/$(SRCARCH) \
 	-I ../rseq -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
-ifeq ($(ARCH),s390)
+ifeq ($(SRCARCH),s390)
 	CFLAGS += -march=z10
 endif
-ifeq ($(ARCH),x86)
+ifeq ($(SRCARCH),x86)
 ifeq ($(shell echo "void foo(void) { }" | $(CC) -march=x86-64-v2 -x c - -c -o /dev/null 2>/dev/null; echo "$$?"),0)
 	CFLAGS += -march=x86-64-v2
 endif
 endif
-ifeq ($(ARCH),arm64)
+ifeq ($(SRCARCH),arm64)
 tools_dir := $(top_srcdir)/tools
 arm64_tools_dir := $(tools_dir)/arch/arm64/tools/
 
@@ -259,7 +259,7 @@ LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
 LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
 SPLIT_TEST_GEN_PROGS := $(patsubst %, $(OUTPUT)/%, $(SPLIT_TESTS))
-SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(ARCH)/%.o, $(SPLIT_TESTS))
+SPLIT_TEST_GEN_OBJ := $(patsubst %, $(OUTPUT)/$(SRCARCH)/%.o, $(SPLIT_TESTS))
 
 TEST_GEN_OBJ = $(patsubst %, %.o, $(TEST_GEN_PROGS))
 TEST_GEN_OBJ += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
@@ -268,7 +268,7 @@ TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBKVM_OBJS))
 TEST_DEP_FILES += $(patsubst %.o, %.d, $(SPLIT_TEST_GEN_OBJ))
 -include $(TEST_DEP_FILES)
 
-$(shell mkdir -p $(sort $(OUTPUT)/$(ARCH) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
+$(shell mkdir -p $(sort $(OUTPUT)/$(SRCARCH) $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
 
 $(filter-out $(SPLIT_TEST_GEN_PROGS), $(TEST_GEN_PROGS)) \
 $(TEST_GEN_PROGS_EXTENDED): %: %.o
@@ -276,9 +276,9 @@ $(TEST_GEN_PROGS_EXTENDED): %: %.o
 $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(ARCH)/%.o
+$(SPLIT_TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(OUTPUT)/$(SRCARCH)/%.o
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
-$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(ARCH)/%.o: $(ARCH)/%.c
+$(SPLIT_TEST_GEN_OBJ): $(OUTPUT)/$(SRCARCH)/%.o: $(SRCARCH)/%.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 EXTRA_CLEAN += $(GEN_HDRS) \

base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
-- 
2.49.0.906.g1f30a19c02-goog


