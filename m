Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F264742A8
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 13:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhLNMdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 07:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbhLNMdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 07:33:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CEAC061756;
        Tue, 14 Dec 2021 04:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=PVok14eFrHFZpBr8zViQSBxGvIQegi7QB4U9hnh0tls=; b=RoTbBBct32OHhDXsezV8tZxpuE
        59EMoOsByp35Rq3ruuKoECkweIGdmFrfObsAPiW8hL7t9HzgrA2sauhIkndnM7IiIauy1zf/ZN+md
        p0ZFrpJ5PE0UtnVLDTp4e0DgktSb7liR9L8pVhA6SyzblFLKIxxeHProN29hw1Db/iq1iep7/+jjE
        FoN0m1alMcdAIIql4a3o83cW8JFDlyl1LHuy1o9uv6CNxnsktES3neis5qIXFP03TrwZ2NUI26f/8
        uDBafV9pJRXph2UOPYCWIXQeqrRC5aX238XKrUKbC/E5sOqDp701eugw+m7kcPdMvCdLM7nQJqxAG
        CR8OPnmA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mx6zE-00DhT9-4f; Tue, 14 Dec 2021 12:32:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mx6zE-000N6L-A6; Tue, 14 Dec 2021 12:32:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH v2 0/7] Parallel CPU bringup for x86_64
Date:   Tue, 14 Dec 2021 12:32:43 +0000
Message-Id: <20211214123250.88230-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a cut-down version of parallel CPU bringup for x86_64, which 
only does the INIT/SIPI/SIPI for APs in a CPUHP_BP_PARALLEL_DYN stage 
before the normal bringup to CPUHP_ONLINE happens sequentially.

Thus, we don't yet need any of the cleanups in RCU, TSC sync, topology 
updates, etc. — we only need to handle reentrancy through the real mode 
trampoline and the beginning of start_secondary() up to the point where 
it waits in wait_for_master_cpu().

This much is simple and sane enough to be merged, I think — modulo the
lack of sign-off on the patch that Thomas now claims not to remember
writing :)

This brings the 96-thread 2-socket Skylake startup time from 500ms to
100ms, which is a bit more modest than the 34ms we claimed before, but
still a nice win.

Further testing and analysis has shown us that allowing the APs to 
proceed from wait_from_master_cpu() in parallel is going to require a
bit more thought.

Once the APs reach smp_callin(), they call notify_cpu_starting() which 
walks through the states up to min(st->target, CPUHP_AP_ONLINE_IDLE). 
But if we allow the AP to get there when its target is one of the 
CPUHP_BP_PARALLEL_DYN states, that means that notify_cpu_starting() 
doesn't walk it through any states at all!

And then when the AP gets to the end of start_secondary() it ends up in 
cpu_startup_entry() which *sets* the state to CPUHP_AP_ONLINE_IDLE and 
thus has effectively *skipped* all the CPUHP_*_STARTING states.

The cheap answer is to explicitly walk to CPUHP_AP_ONLINE_IDLE but I 
don't want to let the APs *overtake* the target set for them by the 
overall CPUHP state machine.

So I think the better solution for further parallelisation is to make 
bringup_nonboot_cpus() bring all the APs to CPUHP_AP_ONLINE_IDLE in 
parallel, and *then* bring them to CPUHP_ONLINE. We will continue to 
play with that one and make sure the rest of the startup states are 
reentrant, in addition to the ones we've already fixed in 
https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-5.16

v2: Only do do_cpu_up() for APs in parallel, nothing more. Drop half the
    fixes that aren't yet needed until we go further.

David Woodhouse (6):
      x86/apic/x2apic: Fix parallel handling of cluster_mask
      cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
      cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
      x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
      x86/smpboot: Split up native_cpu_up into separate phases and document them
      x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel

Thomas Gleixner (1):
      x86/smpboot: Support parallel startup of secondary CPUs

 arch/x86/include/asm/realmode.h       |   3 +
 arch/x86/include/asm/smp.h            |   9 +-
 arch/x86/kernel/acpi/sleep.c          |   1 +
 arch/x86/kernel/apic/apic.c           |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c |  82 ++++++-----
 arch/x86/kernel/head_64.S             |  71 ++++++++++
 arch/x86/kernel/smpboot.c             | 251 +++++++++++++++++++++++++---------
 arch/x86/realmode/init.c              |   3 +
 arch/x86/realmode/rm/trampoline_64.S  |  14 ++
 include/linux/cpuhotplug.h            |   2 +
 include/linux/smpboot.h               |   7 +
 kernel/cpu.c                          |  27 +++-
 kernel/smpboot.c                      |   2 +-
 kernel/smpboot.h                      |   2 -
 14 files changed, 371 insertions(+), 105 deletions(-)


