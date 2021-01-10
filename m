Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB55C2F0639
	for <lists+kvm@lfdr.de>; Sun, 10 Jan 2021 10:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbhAJJqd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 10 Jan 2021 04:46:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbhAJJqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jan 2021 04:46:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F12E322D01
        for <kvm@vger.kernel.org>; Sun, 10 Jan 2021 09:45:51 +0000 (UTC)
Received: by pdx-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E87E186729; Sun, 10 Jan 2021 09:45:51 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 211109] New: Hard kernel freeze due to large cpu allocation.
Date:   Sun, 10 Jan 2021 09:45:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vytautas.mickus.exc@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-211109-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=211109

            Bug ID: 211109
           Summary: Hard kernel freeze due to large cpu allocation.
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.9.9-95-tkg-MuQSS-llvm
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: vytautas.mickus.exc@gmail.com
        Regression: No

Allocating a large amount of vcpu (30,31) on a system with 32 threads (16 core
ryzen 3950x) causes hard freeze of the whole system. While 16-17 vcpu
allocation is fine.

This was seen while using minikube
```
minikube start --cni=calico --container-runtime=cri-o --cpus=$(($(nproc) - 1))
--driver=kvm2 -n 3
```

Last journal entry is:
```
Jan 10 10:14:51 rig libvirtd[2269]: operation failed: domain 'minikube' already
exists with uuid 4aacd29f-bd5f-418d-b267-42b79f75fbab
```
At which point minikube sees that the domain already exists and launches it.
Hard freeze is immediate.

OS:
Linux rig 5.9.9-95-tkg-MuQSS-llvm #1 TKG SMP PREEMPT Sun, 22 Nov 2020 07:41:26
+0000 x86_64 GNU/Linux

os-release:
```
NAME="Arch Linux"
PRETTY_NAME="Arch Linux"
ID=arch
BUILD_ID=rolling
```

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.
