Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C385159769
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 11:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfF1J0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 05:26:44 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:28000 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfF1J0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 05:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561714003; x=1593250003;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=J2ajxUE4jXGVCtZSDbaR4rrIINZuPje5eD3Z8F3Mr+M=;
  b=Z6ZR2ehm4h1tvI9TApOVi3EIZMyWTU74K/68T820emj4dF3tSyHnR06T
   q3IFkPZuJMDcGX8YSnJusgrfkkwejFhKAZ15G+R+sUHkP0cYvHEEc7Yth
   OySLh3PzUL/mj0UCmoR55ZglKo73sprA2tNaN+g9aHrNkdLXzH8CBGLv9
   w=;
X-IronPort-AV: E=Sophos;i="5.62,427,1554768000"; 
   d="scan'208";a="813262319"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Jun 2019 09:26:34 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 1710FA1E9E;
        Fri, 28 Jun 2019 09:26:29 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 28 Jun 2019 09:26:29 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Fri, 28 Jun 2019 09:26:24 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Caccavale <samcacc@amazon.de>
Subject: [PATCH v4 0/5] x86 instruction emulator fuzzing
Date:   Fri, 28 Jun 2019 11:26:16 +0200
Message-ID: <20190628092621.17823-1-samcacc@amazon.de>
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
The fifth patch contains useful scripts for development but is not intended
for usptream consumption.

Patches
=======

- 01: Builds and links afl-harness with the required kernel objects.
- 02: Introduces the minimal set of emulator operations and supporting code
to emulate simple instructions.
- 03: Demonstrates simple-harness as a unit test.
- 04: Adds scripts for install and building.
- 05: Useful scripts for development


Issues
=======

Currently, fuzzing results in a large amount of FPU related crashes.  Xen's
fuzzing efforts had this issue too.  Their (temporary?) solution was to
disable FPU exceptions after every instruction iteration?  Some solution
is desired for this project.


Changelog
=======

v1 -> v2:
 - Moved -O0 to ifdef DEBUG
 - Building with ASAN by default
 - Removed a number of macros from emulator_ops.c and moved them as
   static inline functions in emulator_ops.h
 - Accidentally changed the example in simple-harness (reverted in v3)
 - Introduced patch 4 for scripts

v2 -> v3:
 - Removed a workaround for printf smashing the stack when compiled
   with -mcmodel=kernel, and stopped compiling with -mcmodel=kernel
 - Added a null check for malloc's return value
 - Moved more macros from emulator_ops.c into emulator_ops.h as
   static inline functions
 - Removed commented out code
 - Moved changes to emulator_ops.h into the first patch
 - Moved addition of afl-many script to the script patch
 - Fixed spelling mistakes in documentation
 - Reverted the simple-harness example back to the more useful original one
 - Moved non-essential development scripts from patch 4 to new patch 5

v3 -> v4:
 - Stubbed out all unimplemented emulator_ops with a unimplemented_op macro
 - Setting FAIL_ON_UNIMPLEMENTED_OP on compile decides whether calling these
   is treated as a crash or ignored
 - Moved setting up core dumps out of the default build/install path and
   detailed this change in the README
 - Added a .sh extention to afl-many
 - Added an optional timeout to afl-many.sh and made deploy_remote.sh use it
 - Building no longer creates a new .config each time and does not force any
   config options
 - Fixed a path bug in afl-many.sh

Any comments/suggestions are greatly appreciated.

Best,
Sam Caccavale

Sam Caccavale (5):
  Build target for emulate.o as a userspace binary
  Emulate simple x86 instructions in userspace
  Demonstrating unit testing via simple-harness
  Added build and install scripts
  Development scripts for crash triage and deploy

 tools/Makefile                                |   9 +
 tools/fuzz/x86ie/.gitignore                   |   2 +
 tools/fuzz/x86ie/Makefile                     |  54 ++
 tools/fuzz/x86ie/README.md                    |  21 +
 tools/fuzz/x86ie/afl-harness.c                | 151 +++++
 tools/fuzz/x86ie/common.h                     |  87 +++
 tools/fuzz/x86ie/emulator_ops.c               | 590 ++++++++++++++++++
 tools/fuzz/x86ie/emulator_ops.h               | 134 ++++
 tools/fuzz/x86ie/scripts/afl-many.sh          |  31 +
 tools/fuzz/x86ie/scripts/bin.sh               |  49 ++
 tools/fuzz/x86ie/scripts/build.sh             |  34 +
 tools/fuzz/x86ie/scripts/coalesce.sh          |   5 +
 tools/fuzz/x86ie/scripts/deploy.sh            |   9 +
 tools/fuzz/x86ie/scripts/deploy_remote.sh     |  10 +
 tools/fuzz/x86ie/scripts/gen_output.sh        |  11 +
 tools/fuzz/x86ie/scripts/install_afl.sh       |  15 +
 .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |   5 +
 tools/fuzz/x86ie/scripts/rebuild.sh           |   6 +
 tools/fuzz/x86ie/scripts/run.sh               |  10 +
 tools/fuzz/x86ie/scripts/summarize.sh         |   9 +
 tools/fuzz/x86ie/simple-harness.c             |  49 ++
 tools/fuzz/x86ie/stubs.c                      |  59 ++
 tools/fuzz/x86ie/stubs.h                      |  52 ++
 23 files changed, 1402 insertions(+)
 create mode 100644 tools/fuzz/x86ie/.gitignore
 create mode 100644 tools/fuzz/x86ie/Makefile
 create mode 100644 tools/fuzz/x86ie/README.md
 create mode 100644 tools/fuzz/x86ie/afl-harness.c
 create mode 100644 tools/fuzz/x86ie/common.h
 create mode 100644 tools/fuzz/x86ie/emulator_ops.c
 create mode 100644 tools/fuzz/x86ie/emulator_ops.h
 create mode 100755 tools/fuzz/x86ie/scripts/afl-many.sh
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



