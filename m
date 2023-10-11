Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF317C5DEB
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 21:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345948AbjJKT6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 15:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjJKT6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 15:58:06 -0400
Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [IPv6:2001:41d0:203:375::d2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F169D
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 12:58:03 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697054281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7iv9v0LVdSGzSsHpdfhFKUOpAMYpmC7eseuWuodo+T0=;
        b=VLQkkqXJJJr6XE5yBJGB/mhprgXWHZA9+vMrgeLL2SSJZmGl2gixD8qsmhGGXjBUm8exCN
        wFrHa5/Nka9VOkEevtVXOGYV6xlSXYd4dRH7v+OlnVrFCcBvtXHgHCukYyR4lp0z41YcyP
        dINv/Tq/IIyT5/brPmhu+4OVGFtXtuM=
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
Subject: [PATCH v3 1/5] tools: arm64: Add a Makefile for generating sysreg-defs.h
Date:   Wed, 11 Oct 2023 19:57:36 +0000
Message-ID: <20231011195740.3349631-2-oliver.upton@linux.dev>
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

Use a common Makefile for generating sysreg-defs.h, which will soon be
needed by perf and KVM selftests. The naming scheme of the generated
macros is not expected to change, so just refer to the canonical
script/data in the kernel source rather than copying to tools.

Co-developed-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/arch/arm64/include/.gitignore |  1 +
 tools/arch/arm64/tools/Makefile     | 38 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/tools/Makefile

diff --git a/tools/arch/arm64/include/.gitignore b/tools/arch/arm64/include/.gitignore
new file mode 100644
index 000000000000..9ab870da897d
--- /dev/null
+++ b/tools/arch/arm64/include/.gitignore
@@ -0,0 +1 @@
+generated/
diff --git a/tools/arch/arm64/tools/Makefile b/tools/arch/arm64/tools/Makefile
new file mode 100644
index 000000000000..f867e6036c62
--- /dev/null
+++ b/tools/arch/arm64/tools/Makefile
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: GPL-2.0
+
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(CURDIR)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+endif
+
+include $(srctree)/tools/scripts/Makefile.include
+
+AWK	?= awk
+MKDIR	?= mkdir
+RM	?= rm
+
+ifeq ($(V),1)
+Q =
+else
+Q = @
+endif
+
+arm64_tools_dir = $(srctree)/arch/arm64/tools
+arm64_sysreg_tbl = $(arm64_tools_dir)/sysreg
+arm64_gen_sysreg = $(arm64_tools_dir)/gen-sysreg.awk
+arm64_generated_dir = $(srctree)/tools/arch/arm64/include/generated
+arm64_sysreg_defs = $(arm64_generated_dir)/asm/sysreg-defs.h
+
+all: $(arm64_sysreg_defs)
+	@:
+
+$(arm64_sysreg_defs): $(arm64_gen_sysreg) $(arm64_sysreg_tbl)
+	$(Q)$(MKDIR) -p $(dir $@)
+	$(QUIET_GEN)$(AWK) -f $^ > $@
+
+clean:
+	$(Q)$(RM) -rf $(arm64_generated_dir)
+
+.PHONY: all clean
-- 
2.42.0.609.gbb76f46606-goog

