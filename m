Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F9932C63F
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346592AbhCDA2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:44167 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244369AbhCCOK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 09:10:29 -0500
IronPort-SDR: 58X3yDiho7wYeXFAEontxG6IKHrIPMYGqJ9f7WbqGzxkDyc+Ae4+WNwG9zjJd2NcT2FPb4NJTv
 EF5dGbrZoucg==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="183818917"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="183818917"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 06:05:27 -0800
IronPort-SDR: NThTEMZPjU4btmywDup90QQ+4dTkBqU8IefMrriIkBXT1R2HQ13dlJgZ7rcq/T2BNXKQvlPyC4
 1J5NAZymu+dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399729377"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 06:05:23 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v3 4/9] perf/x86/lbr: Use GFP_ATOMIC for cpuc->lbr_xsave memory allocation
Date:   Wed,  3 Mar 2021 21:57:50 +0800
Message-Id: <20210303135756.1546253-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210303135756.1546253-1-like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When allocating the cpuc->lbr_xsave memory in the guest Arch LBR driver,
we may get a stacktrace due to relatively slow execution like below:

[   54.283563] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:196
[   54.285218] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 830, name: perf
[   54.286684] INFO: lockdep is turned off.
[   54.287448] irq event stamp: 8644
[   54.288098] hardirqs last  enabled at (8643): [<ffffffff810e2212>] __local_bh_enable_ip+0x82/0xd0
[   54.289806] hardirqs last disabled at (8644): [<ffffffff812a8777>] perf_event_exec+0x1c7/0x3c0
[   54.291418] softirqs last  enabled at (8642): [<ffffffff81033f22>] fpu__clear+0x92/0x190
[   54.292921] softirqs last disabled at (8638): [<ffffffff81033e95>] fpu__clear+0x5/0x190
[   54.294418] CPU: 3 PID: 830 Comm: perf Not tainted 5.11.0-guest+ #1145
[   54.295635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[   54.297136] Call Trace:
[   54.297603]  dump_stack+0x8b/0xb0
[   54.298246]  ___might_sleep.cold+0xb6/0xc6
[   54.299022]  ? intel_pmu_lbr_add+0x147/0x160
[   54.299823]  kmem_cache_alloc+0x26d/0x2f0
[   54.300587]  intel_pmu_lbr_add+0x147/0x160
[   54.301358]  x86_pmu_add+0x85/0xe0
[   54.302009]  ? check_irq_usage+0x147/0x460
[   54.302793]  ? __bfs+0x210/0x210
[   54.303420]  ? stack_trace_save+0x3b/0x50
[   54.304190]  ? check_noncircular+0x66/0xf0
[   54.304978]  ? save_trace+0x3f/0x2f0
[   54.305670]  event_sched_in+0xf5/0x2a0
[   54.306401]  merge_sched_in+0x1a0/0x3b0
[   54.307141]  visit_groups_merge.constprop.0.isra.0+0x16e/0x490
[   54.308255]  ctx_sched_in+0xcc/0x200
[   54.308948]  ctx_resched+0x84/0xe0
[   54.309606]  perf_event_exec+0x2c0/0x3c0
[   54.310370]  begin_new_exec+0x627/0xbc0
[   54.311096]  load_elf_binary+0x734/0x17a0
[   54.311853]  ? lock_acquire+0xbc/0x360
[   54.312562]  ? bprm_execve+0x346/0x860
[   54.313272]  ? kvm_sched_clock_read+0x14/0x30
[   54.314095]  ? sched_clock+0x5/0x10
[   54.314760]  ? sched_clock_cpu+0xc/0xb0
[   54.315492]  bprm_execve+0x337/0x860
[   54.316176]  do_execveat_common+0x164/0x1d0
[   54.316971]  __x64_sys_execve+0x39/0x50
[   54.317698]  do_syscall_64+0x33/0x40
[   54.318390]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix it by allocating this part of memory with GFP_ATOMIC mask.

Cc: Peter Zijlstra <peterz@infradead.org>
Fixes: c085fb8774 ("perf/x86/intel/lbr: Support XSAVES for arch LBR read")
Suggested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 355ea70f1879..495466b12480 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -700,7 +700,7 @@ void intel_pmu_lbr_add(struct perf_event *event)
 	if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&
 	    kmem_cache && !cpuc->lbr_xsave &&
 	    (cpuc->lbr_users != cpuc->lbr_pebs_users))
-		cpuc->lbr_xsave = kmem_cache_alloc(kmem_cache, GFP_KERNEL);
+		cpuc->lbr_xsave = kmem_cache_alloc(kmem_cache, GFP_ATOMIC);
 }
 
 void release_lbr_buffers(void)
-- 
2.29.2

