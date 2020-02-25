Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D5716F020
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 21:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbgBYUea convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Feb 2020 15:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730566AbgBYUea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 15:34:30 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Tue, 25 Feb 2020 20:34:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206579-28872-Zyn11WN4Dj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #22 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287607
  --> https://bugzilla.kernel.org/attachment.cgi?id=287607&action=edit
svm.c patch option 2

Okay gentlemen, per Suravee's inquiry I created a patch with the "if (!avic ||
!lapic_in_kernel(&svm->vcpu))" option, did a clean build, and tested the VM.
Everything worked great, and there was no perceptible difference in operation
or performance between the two patch variations. I've attached the alternate
patch to this comment. I know nothing about the details of what's going on here
of course, so it's up to you to choose which one you prefer.

The problem now is that it appears that avic is not actually working. I
executed "perf kvm stat live" as Suravee suggested and all I saw was vintr,
there were no vmexit events. I also disabled avic per Paolo's instructions and
there was no perceptible difference in VM performance. I've done everything I
could discover to assure avic is enabled as follows:

\# dmesg | grep -i AMD-Vi
[    0.918716] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[    0.920160] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.920161] pci 0000:00:00.2: AMD-Vi: Extended features (0x58f77ef22294ade):
[    0.920163] AMD-Vi: Interrupt remapping enabled
[    0.920163] AMD-Vi: Virtual APIC enabled
[    0.920163] AMD-Vi: X2APIC enabled
[    0.920272] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.927736] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>

\# cat /sys/module/kvm_amd/parameters/avic
1

\# systool -m kvm_amd -v
...
```
  Parameters:
    avic                = "1"
    dump_invalid_vmcb   = "N"
    nested              = "1"
    npt                 = "1"
    nrips               = "1"
    pause_filter_count_grow= "2"
    pause_filter_count_max= "65535"
    pause_filter_count_shrink= "0"
    pause_filter_count  = "3000"
    pause_filter_thresh = "128"
    sev                 = "0"
    vgif                = "1"
    vls                 = "1"
...
```

So at this point I'm perplexed as to why avic isn't working. Any suggestions or
further instructions would be greatly appreciated.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
