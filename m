Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36527CD001
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 00:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbjJQWXz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 17 Oct 2023 18:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjJQWXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 18:23:54 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CAE95;
        Tue, 17 Oct 2023 15:23:52 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-27d5fe999caso2045931a91.1;
        Tue, 17 Oct 2023 15:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697581432; x=1698186232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+bAkXYEq4fBPkfmCJqbJ3IX/vaNNycxeQ/xhF0uP4i4=;
        b=snP77pJMUjxYB8V97R00ETZZxG0D1YfpLdBe+9D96htfwA8fZ1RJeeplppA4PuFE8s
         zzFM158BTwYT79CFRDOTPiHqOAS4v/u91DRfNfKSXb0d2sHTykgBFqHMWqFT5pcqjOqX
         kf4OD/KjLJi6sH3bRGT0zF/HpLJy3TSbhEvj9mo+RorkvjvOq4DDiAzfR6O1gdq4a5Zi
         m2OlroATnkB7LI0YB5txONYNuukYKidLp78CnNvu/WRZFIiBLkjd+D+wowiLSvS0MU/h
         X1oA0tJ5tM6PVPbRyN+PMr1r6r52bp3rkIIe0Vc3Q2wRdN83B89MLD+lDJ3sAIT3ZszL
         NRLQ==
X-Gm-Message-State: AOJu0YyinzZpEVw0Qcdp2/WfPIUTk0cxj2JKXrlZr8sigOtfSrJwOLSt
        25MxXlbNF03cBL2Y7Kxn7lkH24fj6jqsOHAMLdA=
X-Google-Smtp-Source: AGHT+IFC3WJU3Bl9lB+KohU+H2GaxX+RDO7Ndvc2AuCxV9afR7nK4iClEDOuI4e9OJy0Xrt5XoNvpQezBQZRvDhYI9A=
X-Received: by 2002:a17:90a:e381:b0:27d:5c9d:def6 with SMTP id
 b1-20020a17090ae38100b0027d5c9ddef6mr3358539pjz.5.1697581431799; Tue, 17 Oct
 2023 15:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <20231011195740.3349631-1-oliver.upton@linux.dev> <20231011195740.3349631-3-oliver.upton@linux.dev>
In-Reply-To: <20231011195740.3349631-3-oliver.upton@linux.dev>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Tue, 17 Oct 2023 15:23:40 -0700
Message-ID: <CAM9d7cjxkAmEc=g0jWBPQ9d6GYmfdZSKjqi5v0UsoPvkQy-fSw@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] perf build: Generate arm64's sysreg-defs.h and add
 to include path
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Wed, Oct 11, 2023 at 12:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Start generating sysreg-defs.h in anticipation of updating sysreg.h to a
> version that needs the generated output.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

It seems we also need this on non-ARM archs to process ARM SPE data.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/Makefile.perf | 15 +++++++++++++--
>  tools/perf/util/Build    |  2 +-
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 37af6df7b978..14dedd11a1f5 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -443,6 +443,15 @@ drm_ioctl_tbl := $(srctree)/tools/perf/trace/beauty/drm_ioctl.sh
>  # Create output directory if not already present
>  _dummy := $(shell [ -d '$(beauty_ioctl_outdir)' ] || mkdir -p '$(beauty_ioctl_outdir)')
>
> +arm64_gen_sysreg_dir := $(srctree)/tools/arch/arm64/tools
> +
> +arm64-sysreg-defs: FORCE
> +       $(Q)$(MAKE) -C $(arm64_gen_sysreg_dir)
> +
> +arm64-sysreg-defs-clean:
> +       $(call QUIET_CLEAN,arm64-sysreg-defs)
> +       $(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) clean > /dev/null
> +
>  $(drm_ioctl_array): $(drm_hdr_dir)/drm.h $(drm_hdr_dir)/i915_drm.h $(drm_ioctl_tbl)
>         $(Q)$(SHELL) '$(drm_ioctl_tbl)' $(drm_hdr_dir) > $@
>
> @@ -716,7 +725,9 @@ endif
>  __build-dir = $(subst $(OUTPUT),,$(dir $@))
>  build-dir   = $(or $(__build-dir),.)
>
> -prepare: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h archheaders $(drm_ioctl_array) \
> +prepare: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h archheaders \
> +       arm64-sysreg-defs \
> +       $(drm_ioctl_array) \
>         $(fadvise_advice_array) \
>         $(fsconfig_arrays) \
>         $(fsmount_arrays) \
> @@ -1125,7 +1136,7 @@ endif # BUILD_BPF_SKEL
>  bpf-skel-clean:
>         $(call QUIET_CLEAN, bpf-skel) $(RM) -r $(SKEL_TMP_OUT) $(SKELETONS)
>
> -clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMBOL)-clean $(LIBPERF)-clean fixdep-clean python-clean bpf-skel-clean tests-coresight-targets-clean
> +clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMBOL)-clean $(LIBPERF)-clean arm64-sysreg-defs-clean fixdep-clean python-clean bpf-skel-clean tests-coresight-targets-clean
>         $(call QUIET_CLEAN, core-objs)  $(RM) $(LIBPERF_A) $(OUTPUT)perf-archive $(OUTPUT)perf-iostat $(LANG_BINDINGS)
>         $(Q)find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
>         $(Q)$(RM) $(OUTPUT).config-detected
> diff --git a/tools/perf/util/Build b/tools/perf/util/Build
> index 6d657c9927f7..2f76230958ad 100644
> --- a/tools/perf/util/Build
> +++ b/tools/perf/util/Build
> @@ -345,7 +345,7 @@ CFLAGS_rbtree.o        += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ET
>  CFLAGS_libstring.o     += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
>  CFLAGS_hweight.o       += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
>  CFLAGS_header.o        += -include $(OUTPUT)PERF-VERSION-FILE
> -CFLAGS_arm-spe.o       += -I$(srctree)/tools/arch/arm64/include/
> +CFLAGS_arm-spe.o       += -I$(srctree)/tools/arch/arm64/include/ -I$(srctree)/tools/arch/arm64/include/generated/
>
>  $(OUTPUT)util/argv_split.o: ../lib/argv_split.c FORCE
>         $(call rule_mkdir)
> --
> 2.42.0.609.gbb76f46606-goog
>
