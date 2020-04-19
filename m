Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFCE1AFC66
	for <lists+kvm@lfdr.de>; Sun, 19 Apr 2020 19:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgDSRIc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 19 Apr 2020 13:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgDSRIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Apr 2020 13:08:31 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207357] New: Paravirtualized spinlocks causing very severe
 performance degradation with 3rd gen AMD Threadripper
Date:   Sun, 19 Apr 2020 17:08:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: abj0000@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207357-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207357

            Bug ID: 207357
           Summary: Paravirtualized spinlocks causing very severe
                    performance degradation with 3rd gen AMD Threadripper
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6.5
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: abj0000@gmail.com
        Regression: No

I've noticed very severe performance degradation on one of the few benchmarks I
have been running, and narrowed it down the paravirtualized spinlocks.

Host:
- Fedora 32 with kernel 5.6.5 / Proxmox 6.1-8 (tried both)
- Qemu 4.1 / 4.2 / 5.0.0 rc3 (tried all of these)
- AMD Threadripper 3970X (Zen 2) CPU, 32C/64T
- 64GB of RAM, mostly allocated to 1GB huge pages.

Guest:
- Fedora 32 with kernel 5.6.5

The VM has the following key specs (through libvirt):
  <memory unit="GiB">16</memory>
  <memoryBacking>
    <hugepages/>
  </memoryBacking>
  <vcpu placement="static">48</vcpu>
  <features>
    <acpi/>
    <apic/>
    <vmport state="off"/>
  </features>
  <cpu mode="host-passthrough" check="none">
    <topology sockets="1" dies="1" cores="24" threads="2"/>
    <feature policy="require" name="topoext"/>
  </cpu>

I'm passing through an NVMe drive and running a RocksDB benchmark on it.

Bare metal scores about 1 000 000 Op/s, while the guest scores about 180 000,
i.e only 18% of bare metal. CPU usage on the host is about 900%.
CPUID on 0x40000001: eax=0x01003afb

If I add <pvspinlock state="off"/> or <hint-dedicated state="on"/>, then the
guest scores very close to bare metal in the benchmark, with CPU usage on the
host at 4700%, which means that it's successfully using resources at its
disposal.
If I understand correctly, adding the above zeroes the KVM_FEATURE_PV_UNHALT
bit in the guest's CPUID, and therefore deactivates the paravirtualized
spinlocks.
CPUID on 0x40000001: eax=0x01003a7b

If it's of any help, I also noticed further performance degradation doing the
following:
- Pinning the vCPUs:
  <cputune> 
    <vcpupin vcpu="0" cpuset="8"/>
    <vcpupin vcpu="1" cpuset="40"/>
    <vcpupin vcpu="2" cpuset="9"/>
    <vcpupin vcpu="3" cpuset="41"/>
   ...
    <vcpupin vcpu="46" cpuset="31"/>
    <vcpupin vcpu="47" cpuset="63"/>
  </cputune>
- Adding <cache mode="passthrough" />

Enabling AVIC (AMD's equivalent to APICv) on kvm_amd and disabling x2apic and
nested virtualization to make it work did not help restore performance.

For comparison, I also tested VMware's ESXi 7.0 and out of the box got a very
high percentage of bare metal performance on that benchmark. That led me to
think it could be a bug in KVM.

Disclaimer: I'm just a simple enthusiast who doesn't even understand spinlocks,
TLB flushes, VM exists, IPI, APIC, etc. But I'm available to run commands and
provide you with their outputs.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
