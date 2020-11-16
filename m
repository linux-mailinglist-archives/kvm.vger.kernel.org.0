Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5E92B3BD3
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 04:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKPD1i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 15 Nov 2020 22:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgKPD1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Nov 2020 22:27:38 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210213] New: vCPUs >= 64 can't be online and hotplugged in some
 scenarios
Date:   Mon, 16 Nov 2020 03:27:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zelin.deng@linux.alibaba.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-210213-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210213

            Bug ID: 210213
           Summary: vCPUs >= 64 can't be online and hotplugged in some
                    scenarios
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.10-rc4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zelin.deng@linux.alibaba.com
        Regression: No

Created attachment 293685
  --> https://bugzilla.kernel.org/attachment.cgi?id=293685&action=edit
Here is a workaround to fix this issue

In VM, if no-kvmclock-vsyscall is set, lscpu shows online 0-63 vcpus are online
vcpus >= 64 are offline and if we attempting to hotplug them, they will return
-ENOMEM.
This issue also happened in VM which are on TSC unstable host.
 bash-14295 [040] .... 64209.953702: cpuhp_enter: cpu: 0064 target: 199 step: 
64 (kvmclock_setup_percpu)
            bash-14295 [040] .... 64209.953702: cpuhp_exit:  cpu: 0064  state: 
64 step:  64 ret: -12
----------------------------

[root@iZwz9208df47apaoyvbmm3Z processor]# cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 166/166   #P:49
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
            bash-14295 [040] .... 64209.953675: cpuhp_enter: cpu: 0064 target:
199 step:   1 (smpboot_create_threads)
            bash-14295 [040] .... 64209.953676: cpuhp_exit:  cpu: 0064  state: 
 1 step:   1 ret: 0
            bash-14295 [040] .... 64209.953676: cpuhp_enter: cpu: 0064 target:
199 step:   2 (perf_event_init_cpu)
            bash-14295 [040] .... 64209.953677: cpuhp_exit:  cpu: 0064  state: 
 2 step:   2 ret: 0
            bash-14295 [040] .... 64209.953678: cpuhp_enter: cpu: 0064 target:
199 step:  35 (workqueue_prepare_cpu)
            bash-14295 [040] .... 64209.953678: cpuhp_exit:  cpu: 0064  state: 
35 step:  35 ret: 0
            bash-14295 [040] .... 64209.953678: cpuhp_enter: cpu: 0064 target:
199 step:  37 (hrtimers_prepare_cpu)
            bash-14295 [040] .... 64209.953679: cpuhp_exit:  cpu: 0064  state: 
37 step:  37 ret: 0
            bash-14295 [040] .... 64209.953679: cpuhp_enter: cpu: 0064 target:
199 step:  40 (smpcfd_prepare_cpu)
            bash-14295 [040] .... 64209.953692: cpuhp_exit:  cpu: 0064  state: 
40 step:  40 ret: 0
            bash-14295 [040] .... 64209.953693: cpuhp_enter: cpu: 0064 target:
199 step:  41 (relay_prepare_cpu)
            bash-14295 [040] .... 64209.953693: cpuhp_exit:  cpu: 0064  state: 
41 step:  41 ret: 0
            bash-14295 [040] .... 64209.953693: cpuhp_enter: cpu: 0064 target:
199 step:  44 (rcutree_prepare_cpu)
            bash-14295 [040] .... 64209.953694: cpuhp_exit:  cpu: 0064  state: 
44 step:  44 ret: 0
            bash-14295 [040] .... 64209.953694: cpuhp_enter: cpu: 0064 target:
199 step:  53 (topology_add_dev)
            bash-14295 [040] .... 64209.953699: cpuhp_exit:  cpu: 0064  state: 
53 step:  53 ret: 0
            bash-14295 [040] .... 64209.953700: cpuhp_multi_enter: cpu: 0064
target: 199 step:  56 (trace_rb_cpu_prepare)
            bash-14295 [040] .... 64209.953700: cpuhp_exit:  cpu: 0064  state: 
56 step:  56 ret: 0
            bash-14295 [040] .... 64209.953700: cpuhp_multi_enter: cpu: 0064
target: 199 step:  56 (trace_rb_cpu_prepare)
            bash-14295 [040] .... 64209.953700: cpuhp_exit:  cpu: 0064  state: 
56 step:  56 ret: 0
            bash-14295 [040] .... 64209.953701: cpuhp_multi_enter: cpu: 0064
target: 199 step:  56 (trace_rb_cpu_prepare)
            bash-14295 [040] .... 64209.953701: cpuhp_exit:  cpu: 0064  state: 
56 step:  56 ret: 0
            bash-14295 [040] .... 64209.953701: cpuhp_enter: cpu: 0064 target:
199 step:  62 (timers_prepare_cpu)
            bash-14295 [040] .... 64209.953701: cpuhp_exit:  cpu: 0064  state: 
62 step:  62 ret: 0
            bash-14295 [040] .... 64209.953702: cpuhp_enter: cpu: 0064 target:
199 step:  64 (kvmclock_setup_percpu)
            bash-14295 [040] .... 64209.953702: cpuhp_exit:  cpu: 0064  state: 
64 step:  64 ret: -12

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
