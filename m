Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E410350DDB
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbfFXOYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:24:33 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:42263 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfFXOYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:24:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561386271; x=1592922271;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=mbXtN/wmuceti3gzhSKEMiJrhbqvcxWqydonahjOXys=;
  b=Uq9d4E8VR4tjcsrzV9tjPTrIBNfmX9gSbElkdvmbOCjFH4Y/HC4yw8Dj
   YCb0H7ikLd3TUt3xOPBBQu5AFrFBev0TUZia/I8cMYY7FnYToV1MYGmOT
   +kw4kysgDiNyeKlGP2cA1BsD2MqdvdyZEbskRnLgRWgDn0sypmr62kw8M
   w=;
X-IronPort-AV: E=Sophos;i="5.62,412,1554768000"; 
   d="scan'208";a="807320953"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 24 Jun 2019 14:24:28 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 1479D240C46;
        Mon, 24 Jun 2019 14:24:23 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:23 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 24 Jun 2019 14:24:23 +0000
Received: from u6cf1b7119fa15b.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 14:24:18 +0000
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
Subject: [PATCH v3 0/5] x86 instruction emulator fuzzing
Date:   Mon, 24 Jun 2019 16:24:09 +0200
Message-ID: <20190624142414.22096-1-samcacc@amazon.de>
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
 - Moved non-essential development scripts from patch 4 new patch 5


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
 tools/fuzz/x86ie/Makefile                     |  54 +++
 tools/fuzz/x86ie/README.md                    |  17 +
 tools/fuzz/x86ie/afl-harness.c                | 151 +++++++
 tools/fuzz/x86ie/common.h                     |  87 ++++
 tools/fuzz/x86ie/emulator_ops.c               | 381 ++++++++++++++++++
 tools/fuzz/x86ie/emulator_ops.h               | 120 ++++++
 tools/fuzz/x86ie/scripts/afl-many             |  31 ++
 tools/fuzz/x86ie/scripts/bin.sh               |  49 +++
 tools/fuzz/x86ie/scripts/build.sh             |  33 ++
 tools/fuzz/x86ie/scripts/coalesce.sh          |   5 +
 tools/fuzz/x86ie/scripts/deploy.sh            |   9 +
 tools/fuzz/x86ie/scripts/deploy_remote.sh     |   9 +
 tools/fuzz/x86ie/scripts/gen_output.sh        |  11 +
 tools/fuzz/x86ie/scripts/install_afl.sh       |  17 +
 .../fuzz/x86ie/scripts/install_deps_ubuntu.sh |   5 +
 tools/fuzz/x86ie/scripts/rebuild.sh           |   6 +
 tools/fuzz/x86ie/scripts/run.sh               |  10 +
 tools/fuzz/x86ie/scripts/summarize.sh         |   9 +
 tools/fuzz/x86ie/simple-harness.c             |  49 +++
 tools/fuzz/x86ie/stubs.c                      |  56 +++
 tools/fuzz/x86ie/stubs.h                      |  52 +++
 23 files changed, 1172 insertions(+)
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



