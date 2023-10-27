Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F017D8CA3
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 02:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbjJ0Ay6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 20:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjJ0Ay4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 20:54:56 -0400
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A957D1B5
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 17:54:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698368093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hG2LAfyctCoLtIjZzeKRYZw/nVIS+d0blJ9NshgUWD4=;
        b=vVzP0BLkHnaCFvF6jizyBwsKW1cp7K/9C9wBvrPcrCtmDL0mXqxcIsrWIBWAGsCvHx5qtR
        +ywor4Zee9qLAjxE6ZW0D7ofd2vX7gR7we5QYOwsC13o2nnjf5qfx+kSAvke04qQldIIqZ
        CQTyiOZOEx0M+AQkkrzUOG0mngaS0dM=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [PATCH 2/2] KVM: selftests: Avoid using forced target for generating arm64 headers
Date:   Fri, 27 Oct 2023 00:54:39 +0000
Message-ID: <20231027005439.3142015-3-oliver.upton@linux.dev>
In-Reply-To: <20231027005439.3142015-1-oliver.upton@linux.dev>
References: <20231027005439.3142015-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'prepare' target that generates the arm64 sysreg headers had no
prerequisites, so it wound up forcing a rebuild of all KVM selftests
each invocation. Add a rule for the generated headers and just have
dependents use that for a prerequisite.

Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Fixes: 9697d84cc3b6 ("KVM: selftests: Generate sysreg-defs.h and add to include path")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4f4f6ad025f4..4de096bbf124 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -22,10 +22,8 @@ arm64_tools_dir := $(top_srcdir)/tools/arch/arm64/tools/
 GEN_HDRS := $(top_srcdir)/tools/arch/arm64/include/generated/
 CFLAGS += -I$(GEN_HDRS)
 
-prepare:
+$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
 	$(MAKE) -C $(arm64_tools_dir)
-else
-prepare:
 endif
 
 LIBKVM += lib/assert.c
@@ -276,10 +274,10 @@ EXTRA_CLEAN += $(GEN_HDRS) \
 	       cscope.*
 
 x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
-$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c prepare
+$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S prepare
+$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
 # Compile the string overrides as freestanding to prevent the compiler from
@@ -289,9 +287,10 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
 
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
+$(SPLIT_TESTS_OBJS): $(GEN_HDRS)
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
-$(TEST_GEN_OBJ): prepare
+$(TEST_GEN_OBJ): $(GEN_HDRS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
-- 
2.42.0.820.g83a721a137-goog

