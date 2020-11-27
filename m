Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E652C62F4
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 11:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgK0KVz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 27 Nov 2020 05:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgK0KVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 05:21:54 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209867] CPU soft lockup/stall with nested KVM and SMP
Date:   Fri, 27 Nov 2020 10:21:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: frantisek@sumsal.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-209867-28872-xcp34crhy1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209867-28872@https.bugzilla.kernel.org/>
References: <bug-209867-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209867

Frantisek Sumsal (frantisek@sumsal.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.9.9-arch1-1               |5.9.10-arch1-1

--- Comment #5 from Frantisek Sumsal (frantisek@sumsal.cz) ---
I noticed there's a MSR access error when trying to online secondary CPUs,
which may be relevant:

[    3.969876] Last level dTLB entries: 4KB 512, 2MB 255, 4MB 127, 1GB 0
[    3.973256] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user
pointer sanitization
[    3.976544] Spectre V2 : Mitigation: Full AMD retpoline
[    3.979874] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on
context switch
[    3.983210] Spectre V2 : mitigation: Enabling conditional Indirect Branch
Prediction Barrier
[    3.986544] Speculative Store Bypass: Mitigation: Speculative Store Bypass
disabled via prctl and seccomp
[    3.990704] Freeing SMP alternatives memory: 32K
[    3.997866] smpboot: CPU0: AMD Opteron 63xx class CPU (family: 0x15, model:
0x2, stepping: 0x0)
[    4.001938] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    4.003261] ... version:                0
[    4.006576] ... bit width:              48
[    4.009900] ... generic registers:      6
[    4.013234] ... value mask:             0000ffffffffffff
[    4.016567] ... max period:             00007fffffffffff
[    4.019900] ... fixed-purpose events:   0
[    4.023233] ... event mask:             000000000000003f
[    4.026887] rcu: Hierarchical SRCU implementation.
[    4.030952] smp: Bringing up secondary CPUs ...
[    4.034030] x86: Booting SMP configuration:

[    4.036581] .... node  #0, CPUs:      #1
[    1.328014] kvm-clock: cpu 1, msr 8801041, secondary cpu clock
[    1.328014] smpboot: CPU 1 Converting physical 0 to logical die 1
[    1.328014] unchecked MSR access error: WRMSR to 0x48 (tried to write
0x0000000000000000) at rIP: 0xffffffff9da6c984 (native_write_msr+0x4/0x20)
[    1.328014] Call Trace:
[    1.328014]  x86_spec_ctrl_setup_ap+0x34/0x50
[    1.328014]  identify_secondary_cpu+0x6c/0x80
[    1.328014]  smp_store_cpu_info+0x45/0x50
[    1.328014]  start_secondary+0x58/0x160
[    1.328014]  secondary_startup_64+0xb6/0xc0
[    6.088346] kvm-guest: stealtime: cpu 1, msr 1e66e080
[    6.094247]  #2
[    1.328014] kvm-clock: cpu 2, msr 8801081, secondary cpu clock
[    1.328014] smpboot: CPU 2 Converting physical 0 to logical die 2
[    6.123987] kvm-guest: stealtime: cpu 2, msr 1e6ae080

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
