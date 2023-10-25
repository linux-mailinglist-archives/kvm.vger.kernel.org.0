Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E737D73E3
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 21:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjJYTHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 15:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjJYTHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 15:07:35 -0400
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE1F115
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 12:07:33 -0700 (PDT)
Date:   Wed, 25 Oct 2023 19:07:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698260851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1z86aOessVJf1f7xTckw9Z9ZagBGFYnpPIX+SQ4dj5k=;
        b=g1YIzv3UzFcSTAdMrk9BTNrjuCINFTW1OhbSWcnaBmNZR5DUPH8XAefDSjxkTzC7PNSTf1
        Z+lz63/exdLv+COn2chrk19epNG27mgBhnjORcmE4cfuh6+GjAo5021Wn3MpPnMmEdjnjz
        ubr0VwIRVK0p6CXX0SH10P18OH7Q3Ok=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Aishwarya TCV <aishwarya.tcv@arm.com>
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
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 3/5] KVM: selftests: Generate sysreg-defs.h and add to
 include path
Message-ID: <ZTlnbQ2U9ZaAkXYE@linux.dev>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-4-oliver.upton@linux.dev>
 <f25acdcb-269e-fae5-fbbc-54e8d6d05b23@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f25acdcb-269e-fae5-fbbc-54e8d6d05b23@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 10:02:36AM +0100, Aishwarya TCV wrote:
> On 11/10/2023 20:57, Oliver Upton wrote:
> > Start generating sysreg-defs.h for arm64 builds in anticipation of
> > updating sysreg.h to a version that depends on it.
> > 
> > Reviewed-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  tools/testing/selftests/kvm/Makefile | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> > 
> 
> Hi Oliver,
> 
> 
> Currently when building kselftest against next-master with arm64 arch
> and defconfig+kselftest-kvm  “make[4]: *** [Makefile:26: prepare] Error
> 2” is observed.

Looks like we're descending into tools/arch/arm64/tools/ w/
$(srctree) == ".", which I believe is coming from the top makefile. The
following diff fixes it for me, care to give it a go?

diff --git a/tools/arch/arm64/tools/Makefile b/tools/arch/arm64/tools/Makefile
index f867e6036c62..7f64b8bb5107 100644
--- a/tools/arch/arm64/tools/Makefile
+++ b/tools/arch/arm64/tools/Makefile
@@ -1,13 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(CURDIR)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
+ifeq ($(top_srcdir),)
+top_srcdir := $(patsubst %/,%,$(dir $(CURDIR)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
+top_srcdir := $(patsubst %/,%,$(dir $(top_srcdir)))
 endif
 
-include $(srctree)/tools/scripts/Makefile.include
+include $(top_srcdir)/tools/scripts/Makefile.include
 
 AWK	?= awk
 MKDIR	?= mkdir
@@ -19,10 +19,10 @@ else
 Q = @
 endif
 
-arm64_tools_dir = $(srctree)/arch/arm64/tools
+arm64_tools_dir = $(top_srcdir)/arch/arm64/tools
 arm64_sysreg_tbl = $(arm64_tools_dir)/sysreg
 arm64_gen_sysreg = $(arm64_tools_dir)/gen-sysreg.awk
-arm64_generated_dir = $(srctree)/tools/arch/arm64/include/generated
+arm64_generated_dir = $(top_srcdir)/tools/arch/arm64/include/generated
 arm64_sysreg_defs = $(arm64_generated_dir)/asm/sysreg-defs.h
 
 all: $(arm64_sysreg_defs)

-- 
Thanks,
Oliver
