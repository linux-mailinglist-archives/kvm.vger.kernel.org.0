Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BE64A666D
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 21:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiBAUyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 15:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiBAUx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 15:53:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EC8C06173B;
        Tue,  1 Feb 2022 12:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ACFUAk/bShXqd5wXRlEcrHBvlAiJ8WaYggjcEl+oAos=; b=TkyYKckQglj0xJZbd3gaQeoeXW
        HIyE5R6JeVcq+UTACO0suBrW53GYtJLBnF3a/T3qTRZK5w2csSfWhBBcCYDVmApP1EUQ8wGdQa4Z4
        xlFsuBah6FgFo7mSph7nT8TZCmyCVOw+nuHRxNbE090x3vuCxmkBpNDW/qVFU/7Ip0r0e5MoGMO7f
        PNOdeyeYVnoRcCl50wx7VawlGTBoGsELYiBNVACcd84QskfFEseTqNqW+GwOKMHCCU9Dmkk78nJk9
        RxWZOGcSJAypfmz9z7utpgIFSwg/8NxcL8VOkmFu7ZEX5DqviyxxxIg/HhIO/3RsU4Z/He3va7j97
        xNR+XzKA==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09b-00D5CQ-Bv; Tue, 01 Feb 2022 20:53:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09Z-001EdZ-Uz; Tue, 01 Feb 2022 20:53:29 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH v4 0/9] Parallel CPU bringup for x86_64
Date:   Tue,  1 Feb 2022 20:53:19 +0000
Message-Id: <20220201205328.123066-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
them shaves about 80% off the AP bringup time on a 96-thread 2-socket
Skylake box (EC2 c5.metal) — from about 500ms to 100ms.

There are more wins to be had with further parallelisation, but this is
the simple part.

v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
    in preparation for more parallelisation.
v4: Fixes to the real mode parallelisation patch spotted by SeanC, to
    avoid scribbling on initial_gs in common_cpu_up(), and to allow all
    24 bits of the physical X2APIC ID to be used. That patch still needs
    a Signed-off-by from its original author, who once claimed not to
    remember writing it at all. But now we've fixed it, hopefully he'll
    admit it now :)

David Woodhouse (8):
      x86/apic/x2apic: Fix parallel handling of cluster_mask
      cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
      cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
      x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
      x86/smpboot: Split up native_cpu_up into separate phases and document them
      x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
      x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
      x86/smpboot: Serialize topology updates for secondary bringup

Thomas Gleixner (1):
      x86/smpboot: Support parallel startup of secondary CPUs

[dwoodhou@i7 linux-2.6]$ git diff --stat  v5.17-rc2..share/parallel-5.17-part1 
 arch/x86/include/asm/realmode.h       |   3 +
 arch/x86/include/asm/smp.h            |  13 +-
 arch/x86/include/asm/topology.h       |   2 -
 arch/x86/kernel/acpi/sleep.c          |   1 +
 arch/x86/kernel/apic/apic.c           |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c | 108 ++++++-----
 arch/x86/kernel/cpu/common.c          |   6 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c       |   9 +
 arch/x86/kernel/head_64.S             |  73 ++++++++
 arch/x86/kernel/smpboot.c             | 325 ++++++++++++++++++++++++----------
 arch/x86/realmode/init.c              |   3 +
 arch/x86/realmode/rm/trampoline_64.S  |  14 ++
 arch/x86/xen/smp_pv.c                 |   4 +-
 include/linux/cpuhotplug.h            |   2 +
 include/linux/smpboot.h               |   7 +
 kernel/cpu.c                          |  27 ++-
 kernel/smpboot.c                      |   2 +-
 kernel/smpboot.h                      |   2 -
 18 files changed, 442 insertions(+), 161 deletions(-)



