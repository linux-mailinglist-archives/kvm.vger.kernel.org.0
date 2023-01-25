Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1379C67AF97
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 11:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbjAYKXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 05:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbjAYKXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 05:23:21 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D52A2B62F;
        Wed, 25 Jan 2023 02:23:19 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DAEC4B3;
        Wed, 25 Jan 2023 02:24:00 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.9.209])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18A8D3F71E;
        Wed, 25 Jan 2023 02:23:13 -0800 (PST)
Date:   Wed, 25 Jan 2023 10:23:11 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, jgross@suse.com, srivatsa@csail.mit.edu,
        amakhalov@vmware.com, pv-drivers@vmware.com, rostedt@goodmis.org,
        mhiramat@kernel.org, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/6] A few cpuidle vs rcu fixes
Message-ID: <Y9EDD3PBNkxlZjTZ@FVFF77S0Q05N>
References: <20230123205009.790550642@infradead.org>
 <Y9AIj1s5iPPki3dK@FVFF77S0Q05N>
 <Y9AVtUY8bnF3WjQr@FVFF77S0Q05N>
 <Y9Al0PfSsx/VWL31@FVFF77S0Q05N>
 <Y9D31FHOCaSnO5gS@hirez.programming.kicks-ass.net>
 <Y9D5AfnOukWNOZ5q@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9D5AfnOukWNOZ5q@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 10:40:17AM +0100, Peter Zijlstra wrote:
> On Wed, Jan 25, 2023 at 10:35:16AM +0100, Peter Zijlstra wrote:
> > tip/sched/core contains the following patch addressing this:
> > 
> > ---
> > commit 9aedeaed6fc6fe8452b9b8225e95cc2b8631ff91
> > Author: Peter Zijlstra <peterz@infradead.org>
> > Date:   Thu Jan 12 20:43:49 2023 +0100
> > 
> >     tracing, hardirq: No moar _rcuidle() tracing
> >     
> >     Robot reported that trace_hardirqs_{on,off}() tickle the forbidden
> >     _rcuidle() tracepoint through local_irq_{en,dis}able().
> >     
> >     For 'sane' configs, these calls will only happen with RCU enabled and
> >     as such can use the regular tracepoint. This also means it's possible
> >     to trace them from NMI context again.
> >     
> >     Reported-by: kernel test robot <lkp@intel.com>
> >     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> >     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> >     Link: https://lore.kernel.org/r/20230112195541.477416709@infradead.org
> > 
> > diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
> > index 629f2854e12b..f992444a0b1f 100644
> > --- a/kernel/trace/trace_preemptirq.c
> > +++ b/kernel/trace/trace_preemptirq.c
> > @@ -19,6 +19,20 @@
> >  /* Per-cpu variable to prevent redundant calls when IRQs already off */
> >  static DEFINE_PER_CPU(int, tracing_irq_cpu);
> >  
> > +/*
> > + * Use regular trace points on architectures that implement noinstr
> > + * tooling: these calls will only happen with RCU enabled, which can
> > + * use a regular tracepoint.
> > + *
> > + * On older architectures, use the rcuidle tracing methods (which
> > + * aren't NMI-safe - so exclude NMI contexts):
> > + */
> > +#ifdef CONFIG_ARCH_WANTS_NO_INSTR
> > +#define trace(point)	trace_##point
> > +#else
> > +#define trace(point)	if (!in_nmi()) trace_##point##_rcuidle
> > +#endif
> > +
> >  /*
> >   * Like trace_hardirqs_on() but without the lockdep invocation. This is
> >   * used in the low level entry code where the ordering vs. RCU is important
> 
> For some reason I missed the trace_preempt_{on,off} things, so that then
> gets the below on top or so.
> 
> diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
> index f992444a0b1f..ea96b41c8838 100644
> --- a/kernel/trace/trace_preemptirq.c
> +++ b/kernel/trace/trace_preemptirq.c
> @@ -100,15 +100,13 @@ NOKPROBE_SYMBOL(trace_hardirqs_off);
>  
>  void trace_preempt_on(unsigned long a0, unsigned long a1)
>  {
> -	if (!in_nmi())
> -		trace_preempt_enable_rcuidle(a0, a1);
> +	trace(preempt_enable)(a0, a1);
>  	tracer_preempt_on(a0, a1);
>  }
>  
>  void trace_preempt_off(unsigned long a0, unsigned long a1)
>  {
> -	if (!in_nmi())
> -		trace_preempt_disable_rcuidle(a0, a1);
> +	trace(preempt_disable)(a0, a1);
>  	tracer_preempt_off(a0, a1);
>  }
>  #endif

I've tested this fixlet atop this series (itself atop tip/sched/core) with a
full-fat ftrace config and the ftrace selftests, and that all runs cleanly.

FWIW, if you spin this as a patch:

Tested-by: Mark Rutland <mark.rutland@arm.com>

Without the fixlet I get splats on both arm64 and x86_64, e.g.

On arm64:

| ------------[ cut here ]------------
| WARNING: CPU: 1 PID: 1162 at include/trace/events/preemptirq.h:55 trace_preempt_on+0x68/0x70
| Modules linked in:
| CPU: 1 PID: 1162 Comm: ftracetest Not tainted 6.2.0-rc1-00100-g1066815869f5 #1
| Hardware name: linux,dummy-virt (DT)
| pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : trace_preempt_on+0x68/0x70
| lr : preempt_count_sub+0xb4/0xf0
| sp : ffff80000e04ba70
| x29: ffff80000e04ba70 x28: ffff80000ade09e8 x27: ffff800009d0c960
| x26: ffff000007c97e10 x25: ffff000007c97e00 x24: ffff80000adf1410
| x23: ffff80000e04bb80 x22: ffff80000a9aabb0 x21: ffff8000080a5cf4
| x20: ffff8000080a5cf4 x19: 0000000000000001 x18: 0000000000000000
| x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
| x14: 0000000000000028 x13: 0000000000004320 x12: 0000000000000361
| x11: 0000000000000361 x10: 0000000000040361 x9 : ffff8000080a5cf4
| x8 : ffff80000ae42a18 x7 : 0000000000000000 x6 : 0000000000000001
| x5 : ffff80000a8f14e8 x4 : 0000000000000001 x3 : 0000000000000000
| x2 : 0000000000000007 x1 : ffff8000080a5cf4 x0 : ffff8000080a5cf4
| Call trace:
|  trace_preempt_on+0x68/0x70
|  preempt_count_sub+0xb4/0xf0
|  percpu_up_read.constprop.0+0xc4/0x180
|  cpus_read_unlock+0x18/0x24
|  static_key_enable+0x2c/0x40
|  tracepoint_add_func+0x330/0x3dc
|  tracepoint_probe_register+0x74/0xc0
|  trace_event_reg+0x8c/0xa0
|  __ftrace_event_enable_disable+0x174/0x4d0
|  __ftrace_set_clr_event_nolock+0xe0/0x150
|  ftrace_set_clr_event+0x90/0x13c
|  ftrace_event_write+0xd4/0x120
|  vfs_write+0xcc/0x2f0
|  ksys_write+0x78/0x110
|  __arm64_sys_write+0x24/0x30
|  invoke_syscall+0x50/0x120
|  el0_svc_common.constprop.0+0x68/0x124
|  do_el0_svc+0x40/0xbc
|  el0_svc+0x48/0xc0
|  el0t_64_sync_handler+0xf4/0x120
|  el0t_64_sync+0x190/0x194
| irq event stamp: 69662
| hardirqs last  enabled at (69661): [<ffff8000092d63f4>] _raw_spin_unlock_irqrestore+0x80/0xa0
| hardirqs last disabled at (69662): [<ffff8000092c4d64>] el1_dbg+0x24/0x90
| softirqs last  enabled at (69564): [<ffff800008010b08>] __do_softirq+0x448/0x5bc
| softirqs last disabled at (69555): [<ffff800008017288>] ____do_softirq+0x18/0x24
| ---[ end trace 0000000000000000 ]---
| ------------[ cut here ]------------
| WARNING: CPU: 1 PID: 1162 at include/trace/events/preemptirq.h:51 trace_preempt_off+0x68/0xb0
| Modules linked in:
| CPU: 1 PID: 1162 Comm: ftracetest Tainted: G        W          6.2.0-rc1-00100-g1066815869f5 #1
| Hardware name: linux,dummy-virt (DT)
| pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : trace_preempt_off+0x68/0xb0
| lr : preempt_count_add+0xa0/0xc0
| sp : ffff80000e04ba80
| x29: ffff80000e04ba80 x28: ffff80000ade09e8 x27: ffff800009d0c970
| x26: ffff000007c97e90 x25: ffff000007c97e80 x24: ffff80000adf13c8
| x23: ffff80000e04bb80 x22: ffff80000a9aabb0 x21: ffff80000b8c8d18
| x20: ffff8000080a5c68 x19: ffff8000080a5c68 x18: 0000000000000000
| x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
| x14: 0000000000000028 x13: 0000000000004320 x12: 0000000000000361
| x11: 0000000000000361 x10: 0000000000040361 x9 : ffff8000080a5c68
| x8 : ffff80000ae42a18 x7 : 0000000000000000 x6 : 0000000000000003
| x5 : 000000003a9e6115 x4 : 0000000000000001 x3 : 0000000000000000
| x2 : 0000000000000007 x1 : ffff8000080a5c68 x0 : ffff8000080a5c68
| Call trace:
|  trace_preempt_off+0x68/0xb0
|  preempt_count_add+0xa0/0xc0
|  percpu_up_read.constprop.0+0x38/0x180
|  cpus_read_unlock+0x18/0x24
|  static_key_enable+0x2c/0x40
|  tracepoint_add_func+0x330/0x3dc
|  tracepoint_probe_register+0x74/0xc0
|  trace_event_reg+0x8c/0xa0
|  __ftrace_event_enable_disable+0x174/0x4d0
|  __ftrace_set_clr_event_nolock+0xe0/0x150
|  ftrace_set_clr_event+0x90/0x13c
|  ftrace_event_write+0xd4/0x120
|  vfs_write+0xcc/0x2f0
|  ksys_write+0x78/0x110
|  __arm64_sys_write+0x24/0x30
|  invoke_syscall+0x50/0x120
|  el0_svc_common.constprop.0+0x68/0x124
|  do_el0_svc+0x40/0xbc
|  el0_svc+0x48/0xc0
|  el0t_64_sync_handler+0xf4/0x120
|  el0t_64_sync+0x190/0x194
| irq event stamp: 69686
| hardirqs last  enabled at (69685): [<ffff8000092c4db8>] el1_dbg+0x78/0x90
| hardirqs last disabled at (69686): [<ffff8000092c4d64>] el1_dbg+0x24/0x90
| softirqs last  enabled at (69670): [<ffff800008010b08>] __do_softirq+0x448/0x5bc
| softirqs last disabled at (69665): [<ffff800008017288>] ____do_softirq+0x18/0x24
| ---[ end trace 0000000000000000 ]---

On x86_64:

| ------------[ cut here ]------------
| WARNING: CPU: 0 PID: 1083 at include/trace/events/preemptirq.h:55 trace_preempt_on+0x31/0x40
| Modules linked in:
| CPU: 0 PID: 1083 Comm: ftracetest Not tainted 6.2.0-rc1-00100-g1066815869f5 #3
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
| RIP: 0010:trace_preempt_on+0x31/0x40
| Code: 1d d6 45 4c a9 00 00 f0 00 74 05 e9 29 11 00 00 cc 90 e9 22 11 00 00 65 8b 05 07 d6 45 4c 89 c0 48 0f a3 05 c1 af b1 01 73 e1 <0f> 0b eb dd 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 0
| RSP: 0018:ffffb374c0ce7ba8 EFLAGS: 00010247
| RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
| RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffffb49e9c1d
| RBP: 0000000000000000 R08: 000000004ea10906 R09: 000000005e02388f
| R10: 00000000f5e02388 R11: 00000000d269a5f5 R12: ffff98620005c780
| R13: ffffffffb3a363d0 R14: 0000000000000a37 R15: 0000000000000a38
| FS:  00007fc812d836a0(0000) GS:ffff98623bc00000(0000) knlGS:0000000000000000
| CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
| CR2: 0000000000642e58 CR3: 00000001039c6005 CR4: 0000000000370ef0
| DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
| DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
| Call Trace:
|  <TASK>
|  preempt_count_sub+0xa3/0xe0
|  _raw_spin_unlock+0x2d/0x50
|  ? trace_preempt_on+0x17/0x40
|  __text_poke+0x326/0x4c0
|  ? trace_preempt_on+0x17/0x40
|  text_poke_bp_batch+0x7f/0x360
|  text_poke_finish+0x1f/0x30
|  arch_jump_label_transform_apply+0x1c/0x30
|  static_key_enable_cpuslocked+0x65/0xa0
|  static_key_enable+0x1a/0x20
|  tracepoint_add_func+0x32c/0x430
|  ? __pfx_trace_event_raw_event_preemptirq_template+0x10/0x10
|  tracepoint_probe_register+0x78/0xb0
|  ? __pfx_trace_event_raw_event_preemptirq_template+0x10/0x10
|  __ftrace_event_enable_disable+0x180/0x250
|  __ftrace_set_clr_event_nolock+0xe3/0x130
|  ftrace_set_clr_event+0x74/0xf0
|  ftrace_event_write+0xdd/0x110
|  vfs_write+0xee/0x510
|  ksys_write+0x75/0x100
|  do_syscall_64+0x3e/0x90
|  entry_SYSCALL_64_after_hwframe+0x72/0xdc
| RIP: 0033:0x7fc812d09103
| Code: 8b 7c 24 08 89 c5 e8 c5 ff ff ff 89 ef 89 44 24 08 e8 81 bc 02 00 8b 44 24 08 48 83 c4 10 5d c3 48 63 ff b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 76 10 48 8b 15 4e fd 05 00 f7 d8 64 3
| RSP: 002b:00007ffcb12972f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
| RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fc812d09103
| RDX: 0000000000000004 RSI: 0000000000645050 RDI: 0000000000000001
| RBP: 0000000000645050 R08: fefefefefefefeff R09: ffffffff00000000
| R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000004
| R13: 00007fc812d83690 R14: 0000000000000001 R15: 0000000000000000
|  </TASK>
| irq event stamp: 57597
| hardirqs last  enabled at (57609): [<ffffffffb3b1384e>] __up_console_sem+0x5e/0x80
| hardirqs last disabled at (57620): [<ffffffffb3b13833>] __up_console_sem+0x43/0x80
| softirqs last  enabled at (57556): [<ffffffffb49eae94>] __do_softirq+0x354/0x4d7
| softirqs last disabled at (57543): [<ffffffffb3a92ad7>] irq_exit_rcu+0xc7/0x140
| ---[ end trace 0000000000000000 ]---
| ------------[ cut here ]------------
| WARNING: CPU: 0 PID: 1083 at include/trace/events/preemptirq.h:51 trace_preempt_off+0x31/0x40
| Modules linked in:
| CPU: 0 PID: 1083 Comm: ftracetest Tainted: G        W          6.2.0-rc1-00100-g1066815869f5 #3
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
| RIP: 0010:trace_preempt_off+0x31/0x40
| Code: cd d5 45 4c a9 00 00 f0 00 74 05 e9 f9 11 00 00 cc 90 e9 f2 11 00 00 65 8b 05 b7 d5 45 4c 89 c0 48 0f a3 05 71 af b1 01 73 e1 <0f> 0b eb dd 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 0
| RSP: 0018:ffffb374c0ce7c18 EFLAGS: 00010247
| RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
| RDX: 0000000000000000 RSI: ffffffffb3b74639 RDI: ffffffffb3b74639
| RBP: ffffffffb56faa10 R08: ffffffffb56faa10 R09: 000000005e02388f
| R10: 00000000f5e02388 R11: 00000000d269a5f5 R12: ffffffffb3a36d20
| R13: 0000000000000000 R14: 0000000000000000 R15: ffff9862038a0780
| FS:  00007fc812d836a0(0000) GS:ffff98623bc00000(0000) knlGS:0000000000000000
| CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
| CR2: 0000000000642e58 CR3: 00000001039c6005 CR4: 0000000000370ef0
| DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
| DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
| Call Trace:
|  <TASK>
|  on_each_cpu_cond_mask+0x29/0x80
|  text_poke_bp_batch+0xe7/0x360
|  text_poke_finish+0x1f/0x30
|  arch_jump_label_transform_apply+0x1c/0x30
|  static_key_enable_cpuslocked+0x65/0xa0
|  static_key_enable+0x1a/0x20
|  tracepoint_add_func+0x32c/0x430
|  ? __pfx_trace_event_raw_event_preemptirq_template+0x10/0x10
|  tracepoint_probe_register+0x78/0xb0
|  ? __pfx_trace_event_raw_event_preemptirq_template+0x10/0x10
|  __ftrace_event_enable_disable+0x180/0x250
|  __ftrace_set_clr_event_nolock+0xe3/0x130
|  ftrace_set_clr_event+0x74/0xf0
|  ftrace_event_write+0xdd/0x110
|  vfs_write+0xee/0x510
|  ksys_write+0x75/0x100
|  do_syscall_64+0x3e/0x90
|  entry_SYSCALL_64_after_hwframe+0x72/0xdc
| RIP: 0033:0x7fc812d09103
| Code: 8b 7c 24 08 89 c5 e8 c5 ff ff ff 89 ef 89 44 24 08 e8 81 bc 02 00 8b 44 24 08 48 83 c4 10 5d c3 48 63 ff b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 76 10 48 8b 15 4e fd 05 00 f7 d8 64 3
| RSP: 002b:00007ffcb12972f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
| RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fc812d09103
| RDX: 0000000000000004 RSI: 0000000000645050 RDI: 0000000000000001
| RBP: 0000000000645050 R08: fefefefefefefeff R09: ffffffff00000000
| R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000004
| R13: 00007fc812d83690 R14: 0000000000000001 R15: 0000000000000000
|  </TASK>
| irq event stamp: 58293
| hardirqs last  enabled at (58303): [<ffffffffb3b1384e>] __up_console_sem+0x5e/0x80
| hardirqs last disabled at (58314): [<ffffffffb3b13833>] __up_console_sem+0x43/0x80
| softirqs last  enabled at (57820): [<ffffffffb49eae94>] __do_softirq+0x354/0x4d7
| softirqs last disabled at (57811): [<ffffffffb3a92ad7>] irq_exit_rcu+0xc7/0x140
| ---[ end trace 0000000000000000 ]---

Thanks,
Mark.
