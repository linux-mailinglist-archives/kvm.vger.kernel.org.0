Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CD77BF016
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 03:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379327AbjJJBKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 21:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379319AbjJJBKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 21:10:42 -0400
Received: from out-202.mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B29D
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 18:10:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696900236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D/xsxQ4LzVYx+XDjI68Ddpsftd1w0hm4aUvT0mmXdYk=;
        b=ckLnks3QhRSxElVrGiCinLuaRwEuJ3x9I2FBTMqkTBsIB27CyGC1BHU0eZZvF8HTd1lQqn
        25hYAYMR/wVSfyCOyaiGwU10B0x44Qmw39JlHb45/CfBLGKpEtb1UB+b7wwokNrDKrM//Q
        7K0Wjr3hIZVqc2sZn+BtTEe6/xyUumw=
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
Subject: [PATCH v2 0/5] KVM: selftests: Add ID reg test, update headers
Date:   Tue, 10 Oct 2023 01:10:17 +0000
Message-ID: <20231010011023.2497088-1-oliver.upton@linux.dev>
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

The writable ID register test depends on the latest system register
definitions, which cannot be trivially added to tools. In order to keep
a single copy of sysreg gunk in tools all users (KVM selftests, perf)
need to be updated to generate headers at build time.

Tested arm64 and x86 builds of both KVM selftests and perf tool.

v1 -> v2:
 - Use the sysreg definition generation script instead of copying the
   output (broonie)
 - Use a common Makefile for both KVM selftests as well as perf
 - Include the KVM selftest responsible for the change

v1: https://lore.kernel.org/kvmarm/20231005180325.525236-1-oliver.upton@linux.dev/

Jing Zhang (2):
  tools headers arm64: Update sysreg.h with kernel sources
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (3):
  tools headers arm64: Copy sysreg-defs generation from kernel source
  perf build: Generate arm64's sysreg-defs.h and add to include path
  KVM: selftests: Generate sysreg-defs.h and add to include path

 tools/arch/arm64/include/.gitignore           |    1 +
 tools/arch/arm64/include/asm/gpr-num.h        |   26 +
 tools/arch/arm64/include/asm/sysreg.h         |  839 ++----
 tools/arch/arm64/tools/Makefile               |   38 +
 tools/arch/arm64/tools/gen-sysreg.awk         |  336 +++
 tools/arch/arm64/tools/sysreg                 | 2497 +++++++++++++++++
 tools/perf/Makefile.perf                      |   15 +-
 tools/perf/check-headers.sh                   |    4 +
 tools/perf/util/Build                         |    2 +-
 tools/testing/selftests/kvm/Makefile          |   24 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c   |    4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   12 +-
 .../selftests/kvm/aarch64/page_fault_test.c   |    6 +-
 .../selftests/kvm/aarch64/set_id_regs.c       |  479 ++++
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +-
 15 files changed, 3622 insertions(+), 667 deletions(-)
 create mode 100644 tools/arch/arm64/include/.gitignore
 create mode 100644 tools/arch/arm64/include/asm/gpr-num.h
 create mode 100644 tools/arch/arm64/tools/Makefile
 create mode 100755 tools/arch/arm64/tools/gen-sysreg.awk
 create mode 100644 tools/arch/arm64/tools/sysreg
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: dafa493dd01d5992f1cb70b08d1741c3ab99e04a
-- 
2.42.0.609.gbb76f46606-goog

