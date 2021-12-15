Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12293475B34
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 15:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbhLOO5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 09:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243648AbhLOO5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 09:57:12 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480C9C061757;
        Wed, 15 Dec 2021 06:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=P340VFo+4PrrAUQaheCNZWVztH0i3+oCk4D7HckAZkY=; b=U9RTLiGsf5f36zTBHdhGQRZzfA
        vLKPTDrqLnJ8zr4wpgXX6EweGnRqycbMic4oSiN35734GJ0vPyBv/OjxtFBpAeYFgj/Zkq2PT1PaW
        qyCh9xffpTqYIibTewVLaLWfkeW6UKRYuco+SL7DuXIDqB3/q+X8p+FJewTRAe3uOR8U0WMMWqcDE
        z+NQ7hmg1tMeVmikjhOwW0/rRNW3WUSs85+mxSu5oDRjmGdMcfCN0HmtmEf60GZ23afvisKsbbU1p
        AhyWeD/PvAWs9Aqy8REVLPLE4GmSqs4lkRGlU7TDUO62nPIXU0oHQCJU2qAs4hmCEhAoqZ5BLkDGj
        iZl4+Vaw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxVhr-001WOs-3j; Wed, 15 Dec 2021 14:56:35 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxVhq-0001Nd-Mi; Wed, 15 Dec 2021 14:56:34 +0000
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
Subject: [PATCH v3 0/9] Parallel CPU bringup for x86_64
Date:   Wed, 15 Dec 2021 14:56:24 +0000
Message-Id: <20211215145633.5238-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
them shaves about 80% off the AP bringup time on a 96-thread socket
Skylake box (EC2 c5.metal) — from about 500ms to 100ms.

There are more wins to be had with further parallelisation, but this is
the simple part.

v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
    in preparation for more parallelisation.


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

 arch/x86/include/asm/realmode.h       |   3 +
 arch/x86/include/asm/smp.h            |  13 +-
 arch/x86/include/asm/topology.h       |   2 -
 arch/x86/kernel/acpi/sleep.c          |   1 +
 arch/x86/kernel/apic/apic.c           |   2 +-
 arch/x86/kernel/apic/x2apic_cluster.c | 108 +++++++-----
 arch/x86/kernel/cpu/common.c          |   6 +-
 arch/x86/kernel/cpu/mtrr/mtrr.c       |   9 +
 arch/x86/kernel/head_64.S             |  71 ++++++++
 arch/x86/kernel/smpboot.c             | 324 ++++++++++++++++++++++++----------
 arch/x86/realmode/init.c              |   3 +
 arch/x86/realmode/rm/trampoline_64.S  |  14 ++
 arch/x86/xen/smp_pv.c                 |   4 +-
 include/linux/cpuhotplug.h            |   2 +
 include/linux/smpboot.h               |   7 +
 kernel/cpu.c                          |  27 ++-
 kernel/smpboot.c                      |   2 +-
 kernel/smpboot.h                      |   2 -
 18 files changed, 441 insertions(+), 159 deletions(-)


