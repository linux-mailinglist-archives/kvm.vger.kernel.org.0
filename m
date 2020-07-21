Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA0022796F
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 09:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGUHYr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 Jul 2020 03:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgGUHYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 03:24:46 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207489] Kernel panic due to Lazy update IOAPIC EOI on an x86_64
 *host*, when two (or more) PCI devices from different IOMMU groups are passed
 to Windows 10 guest, upon guest boot into Windows, with more than 4 VCPUs
Date:   Tue, 21 Jul 2020 07:24:45 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: yaweb@mail.bg
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-207489-28872-8jxLISC1ka@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207489-28872@https.bugzilla.kernel.org/>
References: <bug-207489-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207489

Yani Stoyanov (yaweb@mail.bg) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |yaweb@mail.bg

--- Comment #16 from Yani Stoyanov (yaweb@mail.bg) ---
Kernel 5.8+
on Fedora 32

I have the same issue with macos (sierra and catalina) virtual machines with
passed through gpus. 

What I do to identify the problem: 

Try adding different cards to the mac vm's no matter amd/nvidia the vm hangs
and if you try to restart/force restart it the whole libvirt process hangs. 

I get the same kernel overflow as mentioned in the bug. 

How I am sure its the same problem: 

I checked out the kernel source comment the problematic: 

if (edge && kvm_apicv_activated(ioapic->kvm))
                ioapic_lazy_update_eoi(ioapic, irq);

Rebuild the kernel and try with my version and it was working fine. I also try
kernel 5.5.19 where it was fine also since it didn't have the check. 

I assume macos have some special way of treating the interrupts but since I am
new to the linux kernel and linux as hole I can not identify what exactly case
the problem.

-- 
You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.
