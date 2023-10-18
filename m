Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44C27CDED0
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344988AbjJROOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 10:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345116AbjJRONm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 10:13:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B3310DB
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 07:12:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D05EC433C9;
        Wed, 18 Oct 2023 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697638376;
        bh=51fIDWCVKB8uS2JBPxXFm+H74EFZkbMSdzM2pSNC22c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W+Gvms76pV5hSiJAOrI7JIk44J4aJD7XIdf7yMDCPx20skfodeyV+Cp8GCsFRftJh
         qz+RiAq7N/TbfgTkm1dyIZ4LCHrmPMhyJYbYbzSGW4OnqNp1Ht5FdCWP0knGAjbLNw
         ukttiawgU6pYBeK4MaphTHoLfctNQ/ntcCNwaHhFwLCVyn7UT4NZu82tLUXFk+JBAh
         2mI8IKAxvFfmhVvoUNrHiABrwtp9a07fXKQC1xmVXku52jGP4l0nF9YllHc33owMIw
         JRL/RW9l5ne/Prnc1Dk6oMQFiEs1CLsbeWW3uiGULtPDGvHGoRWDp0Xv05zBckuotp
         FGdLs3ivRIO5Q==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A57F140016; Wed, 18 Oct 2023 11:12:53 -0300 (-03)
Date:   Wed, 18 Oct 2023 11:12:53 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
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
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 2/5] perf build: Generate arm64's sysreg-defs.h and
 add to include path
Message-ID: <ZS/n5dqo6dZE40HE@kernel.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-3-oliver.upton@linux.dev>
 <CAM9d7cjxkAmEc=g0jWBPQ9d6GYmfdZSKjqi5v0UsoPvkQy-fSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM9d7cjxkAmEc=g0jWBPQ9d6GYmfdZSKjqi5v0UsoPvkQy-fSw@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Tue, Oct 17, 2023 at 03:23:40PM -0700, Namhyung Kim escreveu:
> Hello,
> 
> On Wed, Oct 11, 2023 at 12:58 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Start generating sysreg-defs.h in anticipation of updating sysreg.h to a
> > version that needs the generated output.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> It seems we also need this on non-ARM archs to process ARM SPE data.
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

When building with CORESIGHT=1, yes.

I have it in my tests and:

⬢[acme@toolbox perf-tools-next]$ ls -la /tmp/build/perf-tools-next/util/arm-spe.o
-rw-r--r--. 1 acme acme 135432 Oct 17 16:49 /tmp/build/perf-tools-next/util/arm-spe.o
⬢[acme@toolbox perf-tools-next]$ ldd /tmp/build/perf-tools-next/perf | grep csd
	libopencsd_c_api.so.1 => /lib64/libopencsd_c_api.so.1 (0x00007f36bfca5000)
	libopencsd.so.1 => /lib64/libopencsd.so.1 (0x00007f36be2e0000)
⬢[acme@toolbox perf-tools-next]$ rpm -qf /lib64/libopencsd.so.1
opencsd-1.3.3-1.fc38.x86_64
⬢[acme@toolbox perf-tools-next]$ rpm -q --qf "%{summary}\n" opencsd
An open source CoreSight(tm) Trace Decode library
⬢[acme@toolbox perf-tools-next]$

Well, double checked and arm-spe.o is built by default, only way to
disable it is using NO_AUXTRACE=1 in the make command line, but then
IIRC one needs linking with opencsd to decode all those traces, right?

Anyway:

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
 
> Thanks,
> Namhyung
> 
> 
> > ---
> >  tools/perf/Makefile.perf | 15 +++++++++++++--
> >  tools/perf/util/Build    |  2 +-
> >  2 files changed, 14 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> > index 37af6df7b978..14dedd11a1f5 100644
> > --- a/tools/perf/Makefile.perf
> > +++ b/tools/perf/Makefile.perf
> > @@ -443,6 +443,15 @@ drm_ioctl_tbl := $(srctree)/tools/perf/trace/beauty/drm_ioctl.sh
> >  # Create output directory if not already present
> >  _dummy := $(shell [ -d '$(beauty_ioctl_outdir)' ] || mkdir -p '$(beauty_ioctl_outdir)')
> >
> > +arm64_gen_sysreg_dir := $(srctree)/tools/arch/arm64/tools
> > +
> > +arm64-sysreg-defs: FORCE
> > +       $(Q)$(MAKE) -C $(arm64_gen_sysreg_dir)
> > +
> > +arm64-sysreg-defs-clean:
> > +       $(call QUIET_CLEAN,arm64-sysreg-defs)
> > +       $(Q)$(MAKE) -C $(arm64_gen_sysreg_dir) clean > /dev/null
> > +
> >  $(drm_ioctl_array): $(drm_hdr_dir)/drm.h $(drm_hdr_dir)/i915_drm.h $(drm_ioctl_tbl)
> >         $(Q)$(SHELL) '$(drm_ioctl_tbl)' $(drm_hdr_dir) > $@
> >
> > @@ -716,7 +725,9 @@ endif
> >  __build-dir = $(subst $(OUTPUT),,$(dir $@))
> >  build-dir   = $(or $(__build-dir),.)
> >
> > -prepare: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h archheaders $(drm_ioctl_array) \
> > +prepare: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h archheaders \
> > +       arm64-sysreg-defs \
> > +       $(drm_ioctl_array) \
> >         $(fadvise_advice_array) \
> >         $(fsconfig_arrays) \
> >         $(fsmount_arrays) \
> > @@ -1125,7 +1136,7 @@ endif # BUILD_BPF_SKEL
> >  bpf-skel-clean:
> >         $(call QUIET_CLEAN, bpf-skel) $(RM) -r $(SKEL_TMP_OUT) $(SKELETONS)
> >
> > -clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMBOL)-clean $(LIBPERF)-clean fixdep-clean python-clean bpf-skel-clean tests-coresight-targets-clean
> > +clean:: $(LIBAPI)-clean $(LIBBPF)-clean $(LIBSUBCMD)-clean $(LIBSYMBOL)-clean $(LIBPERF)-clean arm64-sysreg-defs-clean fixdep-clean python-clean bpf-skel-clean tests-coresight-targets-clean
> >         $(call QUIET_CLEAN, core-objs)  $(RM) $(LIBPERF_A) $(OUTPUT)perf-archive $(OUTPUT)perf-iostat $(LANG_BINDINGS)
> >         $(Q)find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.cmd' -delete -o -name '\.*.d' -delete
> >         $(Q)$(RM) $(OUTPUT).config-detected
> > diff --git a/tools/perf/util/Build b/tools/perf/util/Build
> > index 6d657c9927f7..2f76230958ad 100644
> > --- a/tools/perf/util/Build
> > +++ b/tools/perf/util/Build
> > @@ -345,7 +345,7 @@ CFLAGS_rbtree.o        += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ET
> >  CFLAGS_libstring.o     += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
> >  CFLAGS_hweight.o       += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
> >  CFLAGS_header.o        += -include $(OUTPUT)PERF-VERSION-FILE
> > -CFLAGS_arm-spe.o       += -I$(srctree)/tools/arch/arm64/include/
> > +CFLAGS_arm-spe.o       += -I$(srctree)/tools/arch/arm64/include/ -I$(srctree)/tools/arch/arm64/include/generated/
> >
> >  $(OUTPUT)util/argv_split.o: ../lib/argv_split.c FORCE
> >         $(call rule_mkdir)
> > --
> > 2.42.0.609.gbb76f46606-goog
> >

-- 

- Arnaldo
