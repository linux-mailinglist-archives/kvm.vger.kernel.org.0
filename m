Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15C776A7B2
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 05:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjHAD7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 23:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjHAD7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 23:59:07 -0400
Received: from mgamail.intel.com (unknown [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21CA173E
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 20:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690862335; x=1722398335;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LZEBc8Xtx5lD4IT4Uyl+oSvLfFV6DZIEis36ObmZu70=;
  b=Lqb0vhCKdiXYzf+TG8WviAsPhWTxfTJChW7wtqgGixqBqFrUlglt3bsy
   m4ZRtmEpZJ/GB807wWzTmROe1sdKZ1KgISOfxiXvIH/puNtEFe8fWyOM/
   Ti3NOfNVwIIufZaELEvwlc8gpPcmE8jx770ywkZcklg0YBLmKeEP9A/uA
   4YykUGRQIY3WXZrvdmFiCgiPDLdkiMZKwXq92MiJEfvtNCbrqygT8SEzx
   x5ojjnoinfnVi6hzrDYKk1jVDA0444tIgMnY6BKxItPpYTgNiAk+1BIQ5
   S/NkLVgpOizyEybZWZ36/jAteZ5TwJjLTKHdhreDJBHritpaOZUKy/skP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="366661445"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="366661445"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 20:58:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="1059225490"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="1059225490"
Received: from ruichenw-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.77])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 20:58:52 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     weijiang.yang@intel.com, seanjc@google.com,
        like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2] Documentation: KVM: Add vPMU implementaion and gap document
Date:   Tue,  1 Aug 2023 11:58:36 +0800
Message-Id: <20230801035836.1048879-1-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a vPMU implementation and gap document to explain vArch PMU and vLBR
implementation in kvm, especially the current gap to support host and
guest perf event coexist.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
Changelog:
v1 -> v2:
* Refactor perf scheduler section
* Correct one sentence in vArch PMU section
---
 Documentation/virt/kvm/x86/index.rst |   1 +
 Documentation/virt/kvm/x86/pmu.rst   | 325 +++++++++++++++++++++++++++
 2 files changed, 326 insertions(+)
 create mode 100644 Documentation/virt/kvm/x86/pmu.rst

diff --git a/Documentation/virt/kvm/x86/index.rst b/Documentation/virt/kvm/x86/index.rst
index 9ece6b8dc817..02c1c7b01bf3 100644
--- a/Documentation/virt/kvm/x86/index.rst
+++ b/Documentation/virt/kvm/x86/index.rst
@@ -14,5 +14,6 @@ KVM for x86 systems
    mmu
    msr
    nested-vmx
+   pmu
    running-nested-guests
    timekeeping
diff --git a/Documentation/virt/kvm/x86/pmu.rst b/Documentation/virt/kvm/x86/pmu.rst
new file mode 100644
index 000000000000..1b83390bacbf
--- /dev/null
+++ b/Documentation/virt/kvm/x86/pmu.rst
@@ -0,0 +1,325 @@
+﻿.. SPDX-License-Identifier: GPL-2.0
+
+==========================
+PMU virtualization for X86
+==========================
+
+:Author: Xiong Zhang <xiong.y.zhang@intel.com>
+:Copyright: (c) 2023, Intel.  All rights reserved.
+
+.. Contents
+
+1. Overview
+2. Perf Scheduler Basic
+3. Arch PMU virtualization
+4. LBR virtualization
+
+1. Overview
+===========
+
+KVM has supported PMU virtualization on x86 for many years and provides
+MSR based Arch PMU interface to the guest. The major features include
+Arch PMU v2, LBR and PEBS. Users have the same operation to profile
+performance in guest and host.
+KVM is a normal perf subsystem user as other perf subsystem users. When
+the guest access vPMU MSRs, KVM traps it and creates a perf event for it.
+This perf event takes part in perf scheduler to request PMU resources
+and let the guest use these resources.
+
+This document describes the X86 PMU virtualization architecture design
+and opens. It is organized as follows: Next section describes more
+details of Linux perf scheduler as it takes a key role in vPMU
+implementation and allocates PMU resources for guest usage. Then Arch
+PMU virtualization and LBR virtualization are introduced, each feature
+has sections to introduce implementation overview,  the expectation and
+gaps when host and guest perf events coexist.
+
+2. Perf Scheduler Basic
+=======================
+
+Perf subsystem users can not get PMU counter or resource directly, user
+should create a perf event first and specify event’s attribute which is
+used to choose PMU counters, then perf event joins in perf scheduler,
+perf scheduler assigns the corresponding PMU counter to a perf event.
+
+Perf event is created by perf_event_open() system call:
+int syscall(SYS_perf_event_open, struct perf_event_attr *attr,
+	    pid_t pid, int cpu, int roup_fd, unsigned long flags)
+
+    struct perf_event_attr {
+	    ......
+	    /* Major type: hardware/software/tracepoint/etc. */
+	    __u32   type;
+	    /* Type specific configuration information. */
+	    __u64   config;
+	    union {
+		    __u64      sample_period;
+		    __u64      sample_freq;
+	    }
+	   __u64   disabled :1;
+	           pinned   :1;
+		   exclude_user  :1;
+		   exclude_kernel :1;
+		   exclude_host   :1;
+	           exclude_guest  :1;
+	    ......
+    }
+
+The pid and cpu arguments allow specifying which process and CPU
+to monitor:
+pid == 0 and cpu == -1
+        This measures the calling process/thread on any CPU.
+pid == 0 and cpu >= 0
+        This measures the calling process/thread only when running on
+	the specified cpu.
+pid > 0 and cpu == -1
+        This measures the specified process/thread on any cpu.
+pid > 0 and cpu >= 0
+        This  measures the specified process/thread only when running
+	on the specified CPU.
+pid == -1 and cpu >= 0
+        This measures all processes/threads on the specified CPU.
+pid == -1 and cpu == -1
+        This setting is invalid and will return an error.
+
+Perf scheduler's responsibility is choosing which events are active at
+one moment and binding counter with perf event. As processor has limited
+PMU counters and other resource, only limited perf events can be active
+at one moment, the inactive perf event may be active in the next moment,
+perf scheduler has defined rules to control these things.
+
+Perf scheduler defines four types of perf event, defined by the pid and
+cpu arguments in perf_event_open(), plus perf_event_attr.pinned, their
+schedule priority are: per_cpu pinned > per_process pinned
+> per_cpu flexible > per_process flexible. High priority events can
+preempt low priority events when resources contend.
+
+--------------------------------------------------------
+|                      |   pid   |   cpu   |   pinned  |
+--------------------------------------------------------
+| Per-cpu pinned       |   *    |   >= 0   |     1     |
+--------------------------------------------------------
+| Per-process pinned   |  >= 0  |    *     |     1     |
+--------------------------------------------------------
+| Per-cpu flexible     |   *    |   >= 0   |     0     |
+--------------------------------------------------------
+| Per-process flexible | >= 0   |    *     |     0     |
+--------------------------------------------------------
+
+    struct perf_event {
+	    struct list_head       event_entry;
+	    ......
+	    struct pmu             *pmu;
+	    enum perf_event_state  state;
+	    local64_t              count;
+	    u64                    total_time_enabled;
+	    u64                    total_time_running;
+	    struct perf_event_attr attr;
+	    ......
+    }
+
+For per-cpu perf event, it is linked into per cpu global variable
+perf_cpu_context, for per-process perf event, it is linked into
+task_struct->perf_event_context.
+
+Usually the following cases cause perf event reschedule:
+1) In a context switch from one task to a different task.
+2) When an event is manually enabled.
+3) A call to perf_event_open() with disabled field of the
+perf_event_attr argument set to 0.
+
+When perf_event_open() or perf_event_enable() is called, perf event
+reschedule is needed on a specific cpu, perf will send an IPI to the
+target cpu, and the IPI handler will activate events ordered by event
+type, and will iterate all the eligible events in per cpu gloable
+variable perf_cpu_context and current->perf_event_context.
+
+When a perf event is sched out, this event mapped counter is disabled,
+and the counter's setting and count value are saved. When a perf event
+is sched in, perf driver assigns a counter to this event, the counter's
+setting and count values are restored from last saved.
+
+If the event could not be scheduled because no resource is available for
+it, pinned event goes into error state and is excluded from perf
+scheduler, the only way to recover it is re-enable it, flexible event
+goes into inactive state and can be multiplexed with other events if
+needed.
+
+
+3. Arch PMU virtualization
+==========================
+
+3.1. Overview
+-------------
+
+Once KVM/QEMU expose vcpu's Arch PMU capability into guest, the guest
+PMU driver would access the Arch PMU MSRs (including Fixed and GP
+counter) as the host does. All the guest Arch PMU MSRs accessing are
+interceptable.
+
+When a guest virtual counter is enabled through guest MSR writing, the
+KVM trap will create a kvm perf event through the perf subsystem. The
+kvm perf event's attribute is gotten from the guest virtual counter's
+MSR setting.
+
+When a guest changes the virtual counter's setting later, the KVM trap
+will release the old kvm perf event then create a new kvm perf event
+with the new setting.
+
+When guest read the virtual counter's count number, the kvm trap will
+read kvm perf event's counter value and accumulate it to the previous
+counter value.
+
+When guest no longer access the virtual counter's MSR within a
+scheduling time slice and the virtual counter is disabled, KVM will
+release the kvm perf event.
+
+  ----------------------------
+  |  Guest                   |
+  |  perf subsystem          |
+  ----------------------------
+       |            ^
+  vMSR |            | vPMI
+       v            |
+  ----------------------------
+  |  vPMU        KVM vCPU    |
+  ----------------------------
+        |          ^
+  Call  |          | Callbacks
+        v          |
+  ---------------------------
+  | Host Linux Kernel       |
+  | perf subsystem          |
+  ---------------------------
+               |       ^
+           MSR |       | PMI
+               v       |
+         --------------------
+	 | PMU        CPU   |
+         --------------------
+
+Each guest virtual counter has a corresponding kvm perf event, and the
+kvm perf event joins host perf scheduler and complies with host perf
+scheduler rule. When kvm perf event is scheduled by host perf scheduler
+and is active, the guest virtual counter could supply the correct value.
+However, if another host perf event comes in and takes over the kvm perf
+event resource, the kvm perf event will be inactive, then the virtual
+counter keeps the saved value when the kvm perf event is preempted. But
+guest perf doesn't notice the underbeach virtual counter is stopped, so
+the final guest profiling data is wrong.
+
+3.2. Host and Guest perf event contention
+-----------------------------------------
+
+Kvm perf event is a per-process pinned event, its priority is second.
+When kvm perf event is active, it can be preempted by host per-cpu
+pinned perf event, or it can preempt host flexible perf events. Such
+preemption can be temporarily prohibited through disabling host IRQ.
+
+The following results are expected when host and guest perf event
+coexist according to perf scheduler rule:
+1). if host per cpu pinned events occupy all the HW resource, kvm perf
+event can not be active as no available resource, the virtual counter
+value is  zero always when the guest reads it.
+2). if host per cpu pinned event release HW resource, and kvm perf event
+is inactive, kvm perf event can claim the HW resource and switch into
+active, then the guest can get the correct value from the guest virtual
+counter during kvm perf event is active, but the guest total counter
+value is not correct since counter value is lost during kvm perf event
+is inactive.
+3). if kvm perf event is active, then host per cpu pinned perf event
+becomes active and reclaims kvm perf event resource, kvm perf event will
+be inactive. Finally the virtual counter value is kept unchanged and
+stores previous saved value when the guest reads it. So the guest total
+counter isn't correct.
+4). If host flexible perf events occupy all the HW resource, kvm perf
+event can be active and preempts host flexible perf event resource,
+the guest can get the correct value from the guest virtual counter.
+5). if kvm perf event is active, then other host flexible perf events
+request to active, kvm perf event still own the resource and active, so
+the guest can get the correct value from the guest virtual counter.
+
+3.3. vPMU Arch Gaps
+-------------------
+
+The coexist of host and guest perf events has gap:
+1). when guest accesses PMU MSRs at the first time, KVM will trap it and
+create kvm perf event, but this event may be inactive because the
+contention with host perf event. But guest doesn't notice this and when
+guest read virtual counter, the return value is zero.
+2). when kvm perf event is active, host per-cpu pinned perf event can
+reclaim kvm perf event resource at any time once resource contention
+happens. But guest doesn't notice this neither and guest following
+counter accesses get wrong data.
+So maillist had some discussion titled "Reconsider the current approach
+of vPMU".
+
+https://lore.kernel.org/lkml/810c3148-1791-de57-27c0-d1ac5ed35fb8@gmail.com/
+
+The major suggestion in this discussion is host pass-through some
+counters into guest, but this suggestion is not feasible, the reasons
+are:
+a. processor has several counters, but counters are not equal, some
+event must bind with a specific counter.
+b. if a special counter is passthrough into guest, host can not support
+such events and lose some capability.
+c. if a normal counter is passthrough into guest, guest can support
+general event only, and the guest has limited capability.
+So both host and guest lose capability in pass-through mode.
+
+4. LBR Virtualization
+=====================
+
+4.1. Overview
+-------------
+
+The guest LBR driver would access the LBR MSR (including IA32_DEBUGCTLMSR
+and records MSRs) as host does once KVM/QEMU export vcpu's LBR capability
+into guest,  The first guest access on LBR related MSRs is always
+interceptable. The KVM trap would create a vLBR perf event which enables
+the callstack mode and none of the hardware counters are assigned. The
+host perf would enable and schedule this event as usual.
+
+When vLBR event is scheduled by host perf scheduler and is active, host
+LBR MSRs are owned by guest and are pass-through into guest, guest will
+access them without VM Exit. However, if another host LBR event comes in
+and takes over the LBR facility, the vLBR event will be inactive, and
+the guest following access to the LBR MSRs will be trapped and
+meaningless.
+
+As kvm perf event, vLBR event will be released when guest doesn't access
+LBR-related MSRs within a scheduling time slice and guest unset LBR
+enable bit, then the pass-through state of the LBR MSRs will be canceled.
+
+4.2. Host and Guest LBR contention
+----------------------------------
+
+vLBR event is a per-process pinned event, its priority is second. vLBR
+event together with host other LBR event to contend LBR resource,
+according to perf scheduler rule, when vLBR event is active, it can be
+preempted by host per-cpu pinned LBR event, or it can preempt host
+flexible LBR event. Such preemption can be temporarily prohibited
+through disabling host IRQ as perf scheduler uses IPI to change LBR owner.
+
+The following results are expected when host and guest LBR event coexist:
+1) If host per cpu pinned LBR event is active when vm starts, the guest
+vLBR event can not preempt the LBR resource, so the guest can not use
+LBR.
+2). If host flexible LBR events are active when vm starts, guest vLBR
+event can preempt LBR, so the guest can use LBR.
+3). If host per cpu pinned LBR event becomes enabled when guest vLBR
+event is active, the guest vLBR event will lose LBR and the guest can
+not use LBR anymore.
+4). If host flexible LBR event becomes enabled when guest vLBR event is
+active, the guest vLBR event keeps LBR, the guest can still use LBR.
+5). If host per cpu pinned LBR event becomes inactive when guest vLBR
+event is inactive, guest vLBR event can be active and own LBR, the guest
+can use LBR.
+
+4.3. vLBR Arch Gaps
+-------------------
+
+Like vPMU Arch Gap, vLBR event can be preempted by host Per cpu pinned
+event at any time, or vLBR event is inactive at creation, but guest
+can not notice this, so the guest will get meaningless value when the
+vLBR event is inactive.

base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
-- 
2.25.1

