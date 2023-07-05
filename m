Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE3B748B52
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 20:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbjGESQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 14:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbjGESQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 14:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C7D170B
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688580943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SG6L3dp9605PexKsHPw83zB2kthmZFHytF62UPgGYE8=;
        b=FA7KPV7HF/tBCRUI9yo+Xz1INAxU6vtphX0UWkqdQ1hi+92/u7gT8zgej2CBngqSKQR+3s
        JO3SnxY8CSEtBZ82P3kuwemLu68L2o8lC/e8n1B6KS2SUxBd7fsG/pjVGmy9kc6Ag3UIt5
        5omZFcgd9cdyViNwx6Ow90UXc9GZ8hc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-Pcw8oDbdNOmZLprASWcRKg-1; Wed, 05 Jul 2023 14:15:40 -0400
X-MC-Unique: Pcw8oDbdNOmZLprASWcRKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCE6880269A;
        Wed,  5 Jul 2023 18:15:37 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.42.28.164])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D85AD18EB4;
        Wed,  5 Jul 2023 18:15:31 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: [RFC PATCH 00/14] context_tracking,x86: Defer some IPIs until a user->kernel transition
Date:   Wed,  5 Jul 2023 19:12:42 +0100
Message-Id: <20230705181256.3539027-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Context
=======

We've observed within Red Hat that isolated, NOHZ_FULL CPUs running a
pure-userspace application get regularly interrupted by IPIs sent from
housekeeping CPUs. Those IPIs are caused by activity on the housekeeping CPUs
leading to various on_each_cpu() calls, e.g.:

  64359.052209596    NetworkManager       0    1405     smp_call_function_many_cond (cpu=0, func=do_kernel_range_flush)
    smp_call_function_many_cond+0x1
    smp_call_function+0x39
    on_each_cpu+0x2a
    flush_tlb_kernel_range+0x7b
    __purge_vmap_area_lazy+0x70
    _vm_unmap_aliases.part.42+0xdf
    change_page_attr_set_clr+0x16a
    set_memory_ro+0x26
    bpf_int_jit_compile+0x2f9
    bpf_prog_select_runtime+0xc6
    bpf_prepare_filter+0x523
    sk_attach_filter+0x13
    sock_setsockopt+0x92c
    __sys_setsockopt+0x16a
    __x64_sys_setsockopt+0x20
    do_syscall_64+0x87
    entry_SYSCALL_64_after_hwframe+0x65

The heart of this series is the thought that while we cannot remove NOHZ_FULL
CPUs from the list of CPUs targeted by these IPIs, they may not have to execute
the callbacks immediately. Anything that only affects kernelspace can wait
until the next user->kernel transition, providing it can be executed "early
enough" in the entry code.

The original implementation is from Peter [1]. Nicolas then added kernel TLB
invalidation deferral to that [2], and I picked it up from there.

Deferral approach
=================

Storing each and every callback, like a secondary call_single_queue turned out
to be a no-go: the whole point of deferral is to keep NOHZ_FULL CPUs in
userspace for as long as possible - no signal of any form would be sent when
deferring an IPI. This means that any form of queuing for deferred callbacks
would end up as a convoluted memory leak.

Deferred IPIs must thus be coalesced, which this series achieves by assigning
IPIs a "type" and having a mapping of IPI type to callback, leveraged upon
kernel entry.

What about IPIs whose callback take a parameter, you may ask?

Peter suggested during OSPM23 [3] that since on_each_cpu() targets
housekeeping CPUs *and* isolated CPUs, isolated CPUs can access either global or
housekeeping-CPU-local state to "reconstruct" the data that would have been sent
via the IPI.

This series does not affect any IPI callback that requires an argument, but the
approach would remain the same (one coalescable callback executed on kernel
entry).

Kernel entry vs execution of the deferred operation
===================================================

There is a non-zero length of code that is executed upon kernel entry before the
deferred operation can be itself executed (i.e. before we start getting into
context_tracking.c proper).

This means one must take extra care to what can happen in the early entry code,
and that <bad things> cannot happen. For instance, we really don't want to hit
instructions that have been modified by a remote text_poke() while we're on our
way to execute a deferred sync_core().

Patches
=======

o Patches 1-5 have been submitted previously and are included for the sake of
  testing

o Patches 6-10 focus on having objtool detect problematic static key usage in early
  entry

  The context_tracking_key one causes a page_fault_oops() on my RHEL userspace
  due to the KVM module, cf. changelog.
  
o Patch 11 adds the infrastructure for IPI deferral.  
o Patch 12 adds text_poke() IPI deferral.

  This one I'm fairly confident about, we "just" need to do something about the
  __ro_after_init key vs module loading issue.

o Patches 13-14 add vunmap() flush_tlb_kernel_range() IPI deferral

  These ones I'm a lot less confident about, mostly due to lacking
  instrumentation/verification.
  
  The actual deferred callback is also incomplete as it's not properly noinstr:
    vmlinux.o: warning: objtool: __flush_tlb_all_noinstr+0x19: call to native_write_cr4() leaves .noinstr.text section
  and it doesn't support PARAVIRT - it's going to need a pv_ops.mmu entry, but I
  have *no idea* what a sane implementation would be for Xen so I haven't
  touched that yet.

Patches are also available at:

https://gitlab.com/vschneid/linux.git -b redhat/isolirq/defer/v1

Testing
=======

Xeon Platinum 8380 system with SMToff, NOHZ_FULL, isolated CPUs.
RHEL9 userspace.

Workload is using rteval (kernel compilation + hackbench) on housekeeping CPUs
and a dummy stay-in-userspace loop on the isolated CPUs. The main invocation is:

$ trace-cmd record -e "ipi_send_cpumask" -f "cpumask & MASK{$ISOL_CPUS}" \
	           -e "ipi_send_cpu"     -f "cpu & MASK{$ISOL_CPUS}" \
		   rteval --onlyload --loads-cpulist=$HK_CPUS \
		   --hackbench-runlowmem=True --duration=$DURATION

This only records IPIs sent to isolated CPUs, so any event there is interference
(with a bit of fuzz at the start/end of the workload when spawning the
processes). All tests were done with a duration of 20 minutes.
		   
v6.4 (+ cpumask filtering patches):
$ trace-cmd report | grep callback | awk '{ print $NF }' | sort | uniq -c
    236 callback=do_flush_tlb_all+0x0
    576 callback=do_sync_core+0x0
    814 callback=generic_smp_call_function_single_interrupt+0x0
    309 callback=nohz_full_kick_func+0x0

v6.4 + patches:
$ trace-cmd report | grep callback | awk '{ print $NF }' | sort | uniq -c
     22 callback=do_flush_tlb_all+0x0
     24 callback=generic_smp_call_function_single_interrupt+0x0
    307 callback=nohz_full_kick_func+0x0

o IPIs from instruction patching are entirely gone.

o Some TLB flushes remain as I only patched the vunmap cases:

  kworker/2:0-13856 [002]  3517.445719: ipi_send_cpumask:     cpumask=0-1,3-79 callsite=on_each_cpu_cond_mask+0x20 
  callback=do_flush_tlb_all+0x0
  kworker/2:0-13856 [002]  3517.445722: kernel_stack:         <stack trace >
  => trace_event_raw_event_ipi_send_cpumask (ffffffffa974a050)
  => smp_call_function_many_cond (ffffffffa97fb0a7)
  => on_each_cpu_cond_mask (ffffffffa97fb1f0)
  => pcpu_reclaim_populated (ffffffffa996b451)
  => pcpu_balance_workfn (ffffffffa996c399)
  => process_one_work (ffffffffa9730e14)
  => worker_thread (ffffffffa9731440)
  => kthread (ffffffffa973984e)

o The nohz_full_kick_func() ones seem to come from the dev_watchdog() but are
  anyway consistent across revisions

  <...>-3734  [042]   392.890491: ipi_send_cpu:         cpu=42 callsite=irq_work_queue_on+0x77 callback=nohz_full_kick_func+0x0
  <...>-3734  [042]   392.890497: kernel_stack:         <stack trace >
  => trace_event_raw_event_ipi_send_cpu (ffffffff901492d8)
  => __irq_work_queue_local (ffffffff902acb3d)
  => irq_work_queue_on (ffffffff902acc47)
  => __mod_timer (ffffffff901dcd81)
  => dev_watchdog (ffffffff90a75310)
  => call_timer_fn (ffffffff901dc174)
  => __run_timers.part.0 (ffffffff901dc47e)
  => run_timer_softirq (ffffffff901dc546)
  => __do_softirq (ffffffff90c52348)
  => __irq_exit_rcu (ffffffff90113329)
  => sysvec_apic_timer_interrupt (ffffffff90c3c895)
  => asm_sysvec_apic_timer_interrupt (ffffffff90e00d86)

Acknowledgements
================

Special thanks to:
o Clark Williams for listening to my ramblings about this and throwing ideas my way
o Josh Poimboeuf for his guidance regarding objtool and hinting at the
  .data..ro_after_init section.

Links
=====

[1]: https://lore.kernel.org/all/20210929151723.162004989@infradead.org/
[2]: https://github.com/vianpl/linux.git -b ct-work-defer-wip
[3]: https://youtu.be/0vjE6fjoVVE

Valentin Schneider (14):
  tracing/filters: Dynamically allocate filter_pred.regex
  tracing/filters: Enable filtering a cpumask field by another cpumask
  tracing/filters: Enable filtering a scalar field by a cpumask
  tracing/filters: Enable filtering the CPU common field by a cpumask
  tracing/filters: Document cpumask filtering
  objtool: Flesh out warning related to pv_ops[] calls
  objtool: Warn about non __ro_after_init static key usage in .noinstr
  BROKEN: context_tracking: Make context_tracking_key __ro_after_init
  x86/kvm: Make kvm_async_pf_enabled __ro_after_init
  x86/sev-es: Make sev_es_enable_key __ro_after_init
  context-tracking: Introduce work deferral infrastructure
  context_tracking,x86: Defer kernel text patching IPIs
  context_tracking,x86: Add infrastructure to defer kernel TLBI
  x86/mm, mm/vmalloc: Defer flush_tlb_kernel_range() targeting NOHZ_FULL
    CPUs

 Documentation/trace/events.rst               |  14 ++
 arch/Kconfig                                 |   9 +
 arch/x86/Kconfig                             |   1 +
 arch/x86/include/asm/context_tracking_work.h |  20 ++
 arch/x86/include/asm/text-patching.h         |   1 +
 arch/x86/include/asm/tlbflush.h              |   2 +
 arch/x86/kernel/alternative.c                |  24 +-
 arch/x86/kernel/kprobes/core.c               |   4 +-
 arch/x86/kernel/kprobes/opt.c                |   4 +-
 arch/x86/kernel/kvm.c                        |   2 +-
 arch/x86/kernel/module.c                     |   2 +-
 arch/x86/kernel/sev.c                        |   2 +-
 arch/x86/mm/tlb.c                            |  40 +++-
 include/linux/context_tracking.h             |   1 +
 include/linux/context_tracking_state.h       |   1 +
 include/linux/context_tracking_work.h        |  30 +++
 include/linux/trace_events.h                 |   1 +
 kernel/context_tracking.c                    |  65 +++++-
 kernel/time/Kconfig                          |   5 +
 kernel/trace/trace_events_filter.c           | 228 ++++++++++++++++---
 mm/vmalloc.c                                 |  15 +-
 tools/objtool/check.c                        |  22 +-
 tools/objtool/include/objtool/check.h        |   1 +
 tools/objtool/include/objtool/special.h      |   2 +
 tools/objtool/special.c                      |   3 +
 25 files changed, 451 insertions(+), 48 deletions(-)
 create mode 100644 arch/x86/include/asm/context_tracking_work.h
 create mode 100644 include/linux/context_tracking_work.h

--
2.31.1

