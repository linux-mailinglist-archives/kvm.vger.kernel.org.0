Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA1A46EABA
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbhLIPNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234445AbhLIPNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:13:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD08C061746;
        Thu,  9 Dec 2021 07:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Va8s2nesZ5VZPw32CYfVQw20nzizZ9oKz+lpuPZMQw8=; b=DMw/9HVnFZG17EK6kvf2fIaU5S
        nQGN6/RzzTMZMdLZatkx4/OuPYjFR5irrPfj3qHLa/wKSZ0GpmN2WHkhwOhreWlbLKCLzr/BIvOwQ
        5+lqKL64DKb0xJYsshV7T0C12LqJA3NRdQoUQ73skjEiWmq+vScMBVIvf0w3gqIvA+fKrnYPDwCZz
        Wbfl/cz7ZVU1CQ+pg20WzcP3ejQUdbCWetRp/qeQ/drjt65wplLbl7EqkzcNgCS+vxORXdYOQMJzS
        +7by5rLJmQ+tUp1PCvihhgIi3rX4W0CMW4i7LsgyPMeKJNOoyUsKaoOS3IEoWY9p4Q7OjK4ha4w5W
        yszgna5A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3J-009Rs1-2U; Thu, 09 Dec 2021 15:09:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3J-0000xk-83; Thu, 09 Dec 2021 15:09:45 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH 00/11] Parallel CPU bringup for x86_64
Date:   Thu,  9 Dec 2021 15:09:27 +0000
Message-Id: <20211209150938.3518-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dusting off this patch series from February, in which we reduce the time 
taken for bringing up CPUs on a 96-way Skylake box from 500ms to about 
34ms.

There is more parallelism to be had here, including a 1:many TSC sync 
(or just *no* TSC sync, in the kexec case), and letting the APs all run 
through their own states from CPUHP_BRINGUP_CPU to CPUHP_AP_ONLINE_IDLE 
in parallel too. But I'll take a mere factor of 15 for the time being.

We can also have a careful look at the remaining time spent in the 
initial INIT/SIPI phase and see what we can shave off it.

David Woodhouse (10):
      x86/apic/x2apic: Fix parallel handling of cluster_mask
      rcu: Kill rnp->ofl_seq and use only rcu_state.ofl_lock for exclusion
      rcu: Add mutex for rcu boost kthread spawning and affinity setting
      cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
      x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
      x86/smpboot: Split up native_cpu_up into separate phases
      cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
      x86/tsc: Avoid synchronizing TSCs with multiple CPUs in parallel
      x86/smp: Bring up secondary CPUs in parallel
      x86/kvm: Silence per-cpu pr_info noise about KVM clocks and steal time

Thomas Gleixner (1):
      x86/boot: Support parallel startup of secondary CPUs

 arch/x86/include/asm/realmode.h       |   3 +++
 arch/x86/include/asm/smp.h            |   9 ++++++-
 arch/x86/kernel/acpi/sleep.c          |   1 +
 arch/x86/kernel/apic/apic.c           |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c |  82 +++++++++++++++++++++++++++++++++++++-------------------------
 arch/x86/kernel/head_64.S             |  71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kvm.c                 |   6 ++---
 arch/x86/kernel/kvmclock.c            |   2 +-
 arch/x86/kernel/smpboot.c             | 243 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------
 arch/x86/kernel/tsc_sync.c            |   7 ++++++
 arch/x86/realmode/init.c              |   3 +++
 arch/x86/realmode/rm/trampoline_64.S  |  14 +++++++++++
 include/linux/cpuhotplug.h            |   2 ++
 include/linux/smpboot.h               |   7 ++++++
 kernel/cpu.c                          |  27 +++++++++++++++++++--
 kernel/rcu/tree.c                     |  65 ++++++++++++++++++++++++-------------------------
 kernel/rcu/tree.h                     |   7 +++---
 kernel/rcu/tree_plugin.h              |  10 ++++++--
 kernel/smpboot.c                      |   2 +-
 kernel/smpboot.h                      |   2 --
 20 files changed, 418 insertions(+), 147 deletions(-)


