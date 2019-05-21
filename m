Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED89E2542F
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 17:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbfEUPjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 11:39:46 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59490 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728435AbfEUPjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 11:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558453184; x=1589989184;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=WfztY7zZ4LiPHFhQ5Ww3a/tWVFfo4DHyPMlNscacqJA=;
  b=D3+HXFPfDCpCl6Nu/VhwhF8OtmvktWUen0K5qlyePs21ODuAUSxxsR5w
   d2OgoTS9iekZJzv976VDF0ypwicoY6vFchWTbNYSy/+CsVX9PSV3pRxcB
   IVuZhnhAtaZli/2WmtOcPhDQi7JfyWnNANcJTJvA03e/89ZAi4H2Ylhs4
   U=;
X-IronPort-AV: E=Sophos;i="5.60,495,1549929600"; 
   d="scan'208";a="800925985"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 May 2019 15:39:42 +0000
Received: from EX13MTAUEB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x4LFdbVg109786
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 21 May 2019 15:39:37 GMT
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 May 2019 15:39:37 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 May 2019 15:39:36 +0000
Received: from uc2253769c0055c.ant.amazon.com (10.28.85.98) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 21 May 2019 15:39:32 +0000
From:   Sam Caccavale <samcacc@amazon.de>
CC:     <samcacc@amazon.de>, <samcaccavale@gmail.com>,
        <nmanthey@amazon.de>, <wipawel@amazon.de>, <dwmw@amazon.co.uk>,
        <mpohlack@amazon.de>, <graf@amazon.de>, <karahmed@amazon.de>,
        <andrew.cooper3@citrix.com>, <JBeulich@suse.com>,
        <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <paullangton4@gmail.com>, <anirudhkaushik@google.com>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: x86 instruction emulator fuzzing
Date:   Tue, 21 May 2019 17:39:21 +0200
Message-ID: <20190521153924.15110-1-samcacc@amazon.de>
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

The current 3 patches build the emulator and 2 harnesses: simple-harness is
an example of unit testing; afl-harness is a frontend for the AFL fuzzer.
They are early POC and include some issues outlined under "Issues."

Patches
=======

- 01: Builds and links afl-harness with the required kernel objects.
- 02: Introduces the minimal set of emulator operations and supporting code
to emulate simple instructions.
- 03: Demonstrates simple-harness as a unit test.

Issues
=======

1. Currently, building requires manually running the `make_deps` script
since I was unable to make the kernel objects a dependency of the tool.
2. The code will segfault if `CONFIG_STACKPROTECTOR=y` in config.
3. The code requires stderr to be buffered or it otherwise segfaults.

The latter two issues seem related and all of them are likely fixable by
someone more familiar with the linux than me.

Concerns
=======

I was able to carve the `arch/x86/kvm/emulate.c` code, but the emulator is
constructed in such a way that a lot of the code which enforces expected
behavior lives in the x86_emulate_ops supplied in `arch/x86/kvm/x86.c`.
Testing the emulator is still valuable, but a reproducible way to use the kvm
ops would be useful.

Any comments/suggestions are greatly appreciated.

Best,
Sam Caccavale





Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
Ust-ID: DE 289 237 879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B


