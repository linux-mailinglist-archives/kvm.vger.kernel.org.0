Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF6E42B09
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 17:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437271AbfFLPgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 11:36:25 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:29736 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409443AbfFLPgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 11:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560353785; x=1591889785;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=iysjHFEmFK6WReRy+l8vRaIRl3mJUVuzUzI1BfSSuWA=;
  b=h/VdZDVYQt+QuQNBHV4WQ+OaIWjgZxkOixOP5tuhujVKt3nw4Zw7Tj66
   rcjM+fuAzhGM8euXjkXwb1oZC9MjkJ33u9BD/n7YQjxyO9Qwo8+wlGgFL
   SYPcbygmmVGaWnFg3thwdySl+31uA18jG+QsdDO0nMt/E4MQ5r8a30n00
   Y=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="400429507"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 12 Jun 2019 15:36:23 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 494C6A245B;
        Wed, 12 Jun 2019 15:36:18 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:36:18 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Jun 2019 15:36:18 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 12 Jun 2019 15:36:15 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [v2, 0/4] x86 instruction emulator fuzzing
Date:   Wed, 12 Jun 2019 17:35:56 +0200
Message-ID: <20190612153600.13073-1-samcacc@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear all,

This series aims to provide an entrypoint for, and fuzz KVM's x86 instruction
emulator from userspace.  It mirrors Xen's application of the AFL fuzzer to
it's instruction emulator in the hopes of discovering vulnerabilities.
Since this entrypoint also allows arbitrary execution of the emulators code
from userspace, it may also be useful for testing.

The current 4 patches build the emulator and 2 harnesses: simple-harness is
an example of unit testing; afl-harness is a frontend for the AFL fuzzer.

Patches
=======

- 01: Builds and links afl-harness with the required kernel objects.
- 02: Introduces the minimal set of emulator operations and supporting code
to emulate simple instructions.
- 03: Demonstrates simple-harness as a unit test.
- 04: Adds scripts for install, running, and crash triage.

Any comments/suggestions are greatly appreciated.

Best,
Sam Caccavale

Sam Caccavale (4):
  Build target for emulate.o as a userspace binary
  Emulate simple x86 instructions in userspace
  Demonstrating unit testing via simple-harness
  Added scripts for filtering, building, deploying

 tools/Makefile                                |   9 +
 tools/fuzz/x86ie/.gitignore                   |   2 +
 tools/fuzz/x86ie/Makefile                     |  54 +++
 tools/fuzz/x86ie/README.md                    |  12 +
 tools/fuzz/x86ie/afl-harness.c                | 151 +++++++
 tools/fuzz/x86ie/common.h                     |  87 ++++
 tools/fuzz/x86ie/emulator_ops.c               | 398 ++++++++++++++++++
 tools/fuzz/x86ie/emulator_ops.h               | 120 ++++++
 tools/fuzz/x86ie/scripts/afl-many             |  28 ++
 tools/fuzz/x86ie/scripts/bin.sh               |  49 +++
 tools/fuzz/x86ie/scripts/build.sh             |  32 ++
 tools/fuzz/x86ie/scripts/coalesce.sh          |   6 +
 tools/fuzz/x86ie/scripts/deploy.sh            |   9 +
 tools/fuzz/x86ie/scripts/deploy_remote.sh     |   9 +
 tools/fuzz/x86ie/scripts/gen_output.sh        |  11 +
 tools/fuzz/x86ie/scripts/install_afl.sh       |  14 +
 .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |   5 +
 tools/fuzz/x86ie/scripts/rebuild.sh           |   6 +
 tools/fuzz/x86ie/scripts/run.sh               |  10 +
 tools/fuzz/x86ie/scripts/summarize.sh         |   9 +
 tools/fuzz/x86ie/simple-harness.c             |  42 ++
 tools/fuzz/x86ie/stubs.c                      |  56 +++
 tools/fuzz/x86ie/stubs.h                      |  52 +++
 23 files changed, 1171 insertions(+)
 create mode 100644 tools/fuzz/x86ie/.gitignore
 create mode 100644 tools/fuzz/x86ie/Makefile
 create mode 100644 tools/fuzz/x86ie/README.md
 create mode 100644 tools/fuzz/x86ie/afl-harness.c
 create mode 100644 tools/fuzz/x86ie/common.h
 create mode 100644 tools/fuzz/x86ie/emulator_ops.c
 create mode 100644 tools/fuzz/x86ie/emulator_ops.h
 create mode 100755 tools/fuzz/x86ie/scripts/afl-many
 create mode 100755 tools/fuzz/x86ie/scripts/bin.sh
 create mode 100755 tools/fuzz/x86ie/scripts/build.sh
 create mode 100755 tools/fuzz/x86ie/scripts/coalesce.sh
 create mode 100644 tools/fuzz/x86ie/scripts/deploy.sh
 create mode 100755 tools/fuzz/x86ie/scripts/deploy_remote.sh
 create mode 100755 tools/fuzz/x86ie/scripts/gen_output.sh
 create mode 100755 tools/fuzz/x86ie/scripts/install_afl.sh
 create mode 100755 tools/fuzz/x86ie/scripts/install_deps_ubuntu.sh
 create mode 100755 tools/fuzz/x86ie/scripts/rebuild.sh
 create mode 100755 tools/fuzz/x86ie/scripts/run.sh
 create mode 100755 tools/fuzz/x86ie/scripts/summarize.sh
 create mode 100644 tools/fuzz/x86ie/simple-harness.c
 create mode 100644 tools/fuzz/x86ie/stubs.c
 create mode 100644 tools/fuzz/x86ie/stubs.h

--
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



