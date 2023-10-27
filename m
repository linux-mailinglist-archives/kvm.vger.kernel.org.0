Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CA67D8CA4
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 02:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345039AbjJ0Ay7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 20:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjJ0Ay6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 20:54:58 -0400
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82231B9
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 17:54:55 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698368091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5J0Jhz2hwPSoOVC//hWixstF6ppS3O/i9FTlVlzu+p8=;
        b=BmzBBNu0/uOKhKHcCoDgdZf8qmZZ7mUnCVufXKpsfR87RLu2Yh5uXLz/ZilZ21arxll72T
        lBpz2E4PPfCAv5rbxgQcyVclitzNpgl515RbgpitzGmUW+bD4K+JXDjEo3Fx5WqTl5P8Gp
        vktdz0UL8B8YOMKcdr17ZIm/HvIu+LQ=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Aishwarya TCV <aishwarya.tcv@arm.com>
Subject: [PATCH 1/2] tools headers arm64: Fix references to top srcdir in Makefile
Date:   Fri, 27 Oct 2023 00:54:38 +0000
Message-ID: <20231027005439.3142015-2-oliver.upton@linux.dev>
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

Aishwarya reports that KVM selftests for arm64 fail with the following
error:

 | make[4]: Entering directory '/tmp/kci/linux/tools/testing/selftests/kvm'
 | Makefile:270: warning: overriding recipe for target
 | '/tmp/kci/linux/build/kselftest/kvm/get-reg-list'
 | Makefile:265: warning: ignoring old recipe for target
 | '/tmp/kci/linux/build/kselftest/kvm/get-reg-list'
 | make -C ../../../../tools/arch/arm64/tools/
 | make[5]: Entering directory '/tmp/kci/linux/tools/arch/arm64/tools'
 | Makefile:10: ../tools/scripts/Makefile.include: No such file or directory
 | make[5]: *** No rule to make target '../tools/scripts/Makefile.include'.
 |  Stop.

It would appear that this only affects builds from the top-level
Makefile (e.g. make kselftest-all), as $(srctree) is set to ".". Work
around the issue by shadowing the kselftest naming scheme for the source
tree variable.

Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Fixes: 0359c946b131 ("tools headers arm64: Update sysreg.h with kernel sources")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/arch/arm64/tools/Makefile | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

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
2.42.0.820.g83a721a137-goog

