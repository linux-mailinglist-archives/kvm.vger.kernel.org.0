Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E637C5DEE
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 21:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346999AbjJKT6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 15:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjJKT6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 15:58:13 -0400
Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [IPv6:2001:41d0:203:375::be])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2AC90
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 12:58:10 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697054289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mkb88gwthe9rmyJo47XBN/x3y4c76v+Pxc5yvqj8F2U=;
        b=xc5aeD7G/cBCfO9Y/N5pBIdTlIoH7nbyldyNRr7uA3JrD16RTuHr7bu5iycqSP5iMoplsp
        ABpWynVHxo+QEzKYxhZhV1AAGPkS4a1ovE1ebiAuEqimw/sVYGKlsC1xKlBad0U8lGgrK1
        yXA3Mo4Mby0URfi2bKIWPeKJqVdPoG0=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 3/5] KVM: selftests: Generate sysreg-defs.h and add to include path
Date:   Wed, 11 Oct 2023 19:57:38 +0000
Message-ID: <20231011195740.3349631-4-oliver.upton@linux.dev>
In-Reply-To: <20231011195740.3349631-1-oliver.upton@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Start generating sysreg-defs.h for arm64 builds in anticipation of
updating sysreg.h to a version that depends on it.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a3bb36fb3cfc..07b3f4dc1a77 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -17,6 +17,17 @@ else
 	ARCH_DIR := $(ARCH)
 endif
 
+ifeq ($(ARCH),arm64)
+arm64_tools_dir := $(top_srcdir)/tools/arch/arm64/tools/
+GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
+CFLAGS += -I$(GEN_HDRS)
+
+prepare:
+	$(MAKE) -C $(arm64_tools_dir)
+else
+prepare:
+endif
+
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
 LIBKVM += lib/guest_modes.c
@@ -256,13 +267,18 @@ $(TEST_GEN_OBJ): $(OUTPUT)/%.o: %.c
 $(SPLIT_TESTS_TARGETS): %: %.o $(SPLIT_TESTS_OBJS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@
 
-EXTRA_CLEAN += $(LIBKVM_OBJS) $(TEST_DEP_FILES) $(TEST_GEN_OBJ) $(SPLIT_TESTS_OBJS) cscope.*
+EXTRA_CLEAN += $(GEN_HDRS) \
+	       $(LIBKVM_OBJS) \
+	       $(SPLIT_TESTS_OBJS) \
+	       $(TEST_DEP_FILES) \
+	       $(TEST_GEN_OBJ) \
+	       cscope.*
 
 x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
-$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
+$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c prepare
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
+$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S prepare
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 # Compile the string overrides as freestanding to prevent the compiler from
@@ -274,6 +290,7 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
+$(TEST_GEN_OBJ): prepare
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
-- 
2.42.0.609.gbb76f46606-goog

