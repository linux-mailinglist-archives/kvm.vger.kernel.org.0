Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18C07C5DED
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 21:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346890AbjJKT6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 15:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjJKT6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 15:58:09 -0400
Received: from out-203.mta1.migadu.com (out-203.mta1.migadu.com [IPv6:2001:41d0:203:375::cb])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F799D
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 12:58:07 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697054285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jXH7cg8de1dzBGNJz3ypcSLqe/t7Zxe4VVUQ1QtkOqY=;
        b=WxjqDrIvpFrblECPWQqArHOCHxrD8YmEykhamTxk0Vykx4UURzg+tQCp7tdxqZRGqwcoT5
        Bp7RcWmDrjyLZIxeIk6y+EKgbvynDaIYs42pMqw8iMG4BAHUMZzQUosPTxeiav0ajxxU77
        SURBxMijdzhIfPklOg13jr8OIYZfyr0=
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
Subject: [PATCH v3 2/5] perf build: Generate arm64's sysreg-defs.h and add to include path
Date:   Wed, 11 Oct 2023 19:57:37 +0000
Message-ID: <20231011195740.3349631-3-oliver.upton@linux.dev>
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

Start generating sysreg-defs.h in anticipation of updating sysreg.h to a
version that needs the generated output.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/perf/Makefile.perf | 15 +++++++++++++--
 tools/perf/util/Build    |  2 +-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 37af6df7b978..14dedd11a1f5 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -443,6 +443,15 @@ drm_ioctl_tbl := $(srctree)/tools/perf/trace/beauty/drm_ioctl.sh
 # Create output directory if not already present
 _dummy := $(shell [ -d '$(beauty_ioctl_outdir)' ] || mkdir -p '$(beauty_ioctl_outdir)')
 
+arm64_gen_sysreg_dir := $(srctree)/tools/arch/arm64/tools
+
+arm64-sysreg-defs: FORCE
+	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir)
+
+arm64-sysreg-defs-clean:
+	$(call QUIET_CLEAN,arm64-sysreg-defs)
+	$(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) clean > /dev/null
+
 $(drm_ioctl_array): $(drm_hdr_dir)/drm.h $(drm_hdr_dir)/i915_drm.h $(drm_ioctl_tbl)
 	$(Q)$(SHELL) '$(drm_ioctl_tbl)' $(drm_hdr_dir) > $@
 
@@ -716,7 +725,9 @@ endif
 __build-dir = $(subst $(OUTPUT),,$(dir $@))
 build-dir   = $(or $(__build-dir),.)
 
-prepare: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h archheaders $(drm_ioctl_array) \
+prepare: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h archheaders \
+	arm64-sysreg-defs \
+	$(drm_ioctl_array) \
 	$(fadvise_advice_array) \
 	$(fsconfig_arrays) \
 	$(fsmount_arrays) \
@@ -1125,7 +1136,7 @@ endif # BUILD_BPF_SKEL
 bpf-skel-clean:
 	$(call QUIET_CLEAN, bpf-skel) $(RM) -r $(SKEL_TMP_OUT) $(SKELETONS)
 
-clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMBOL)-clean $(LIBPERF)-clean fixdep-clean python-clean bpf-skel-clean tests-coresight-targets-clean
+clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMBOL)-clean $(LIBPERF)-clean arm64-sysreg-defs-clean fixdep-clean python-clean bpf-skel-clean tests-coresight-targets-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIBPERF_A) $(OUTPUT)perf-archive $(OUTPUT)perf-iostat $(LANG_BINDINGS)
 	$(Q)find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
 	$(Q)$(RM) $(OUTPUT).config-detected
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 6d657c9927f7..2f76230958ad 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -345,7 +345,7 @@ CFLAGS_rbtree.o        += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ET
 CFLAGS_libstring.o     += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_hweight.o       += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_header.o        += -include $(OUTPUT)PERF-VERSION-FILE
-CFLAGS_arm-spe.o       += -I$(srctree)/tools/arch/arm64/include/
+CFLAGS_arm-spe.o       += -I$(srctree)/tools/arch/arm64/include/ -I$(srctree)/tools/arch/arm64/include/generated/
 
 $(OUTPUT)util/argv_split.o: ../lib/argv_split.c FORCE
 	$(call rule_mkdir)
-- 
2.42.0.609.gbb76f46606-goog

