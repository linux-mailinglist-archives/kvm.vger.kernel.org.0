Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783FC40CE85
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhIOVFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231490AbhIOVFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 73D6A60F8F
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 21:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631739827;
        bh=dkUNFAvmsR2mwSsTO9GuBelv3qyuSfSAuO2esUwzsIw=;
        h=From:To:Subject:Date:From;
        b=QNdlPOqegU0MBgIxZ9IKjM0hjg995lIyXcUX+Ga07EyUCdp8nZnGQ+2zvvROxbMFA
         DR223oOx7WczDS8rAGWY62mpOYBWuE9m/9l+QbuH/cjUvKh+1ZawVut1IBSkU+1y0h
         XCJuNdqCMxUgXKWIAbWwz89SkVtyseptACvVWCZ3olt/niEw8sWf1AUO1g5ABOIbHu
         w4a+f5+kSXoNXXSk0o1CupmPEn6jlZ5z5eMAUOWvuZXPpT0OYSi1QQxvYw7neCzLR5
         Mq3Q96kaNeysigwqYm86B9H++ByEtdjFGrP1u3gnMwc9kO082gezNTDo9b6dGoMikM
         L2JXG1bY7zG4g==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 691C360FD7; Wed, 15 Sep 2021 21:03:47 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 214423] New: Windows guests become unresponsive and display
 black screen in VNC
Date:   Wed, 15 Sep 2021 21:03:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: bsherwood218@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-214423-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214423

            Bug ID: 214423
           Summary: Windows guests become unresponsive and display black
                    screen in VNC
           Product: Virtualization
           Version: unspecified
    Kernel Version: 1:4.2-3ubuntu6.17
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: bsherwood218@gmail.com
        Regression: No

Host is Ubuntu 20.04 - 5.4.0-26-generic

KVM is 1:4.2-3ubuntu6.17

Guest OS -- various flavors of Windows 2012 server or greater

Symptom:   Guests will appear to be running fine for some time (hours or da=
ys),
occasionally a perfectly running guest will "lock up" and become unresponsi=
ve
to network, VNC, etc..   We are unable to access the VM and the only resort=
 is
to destroy the VM - shutdown will not tear down the VM.

Looking at a number of things, we can see the following via trace_pipe --
nothing else is emitted while in the hung state.

 cat /sys/kernel/debug/tracing/trace_pipe | grep -i <pid>

.....

 <...>-3441924 [004] .... 1907374.582975: kvm_set_irq: gsi 0 level 1 source=
 0
           <...>-3441924 [004] .... 1907374.582977: kvm_pic_set_irq: chip 0=
 pin
0 (edge|masked)
           <...>-3441924 [004] .... 1907374.582979: kvm_apic_accept_irq: ap=
icid
0 vec 209 (Fixed|edge)
           <...>-3441924 [004] .... 1907374.582981: kvm_ioapic_set_irq: pin=
 2
dst 1 vec 209 (Fixed|logical|edge)
           <...>-3441924 [004] .... 1907374.582983: kvm_set_irq: gsi 0 leve=
l 0
source 0
           <...>-3441924 [004] .... 1907374.582984: kvm_pic_set_irq: chip 0=
 pin
0 (edge|masked)
           <...>-3441924 [004] .... 1907374.582984: kvm_ioapic_set_irq: pin=
 2
dst 1 vec 209 (Fixed|logical|edge)
           <...>-3441924 [004] .... 1907374.583457: kvm_set_irq: gsi 0 leve=
l 1
source 0
           <...>-3441924 [004] .... 1907374.583459: kvm_pic_set_irq: chip 0=
 pin
0 (edge|masked)
           <...>-3441924 [004] .... 1907374.583461: kvm_apic_accept_irq: ap=
icid
0 vec 209 (Fixed|edge)
           <...>-3441924 [004] .... 1907374.583462: kvm_ioapic_set_irq: pin=
 2
dst 1 vec 209 (Fixed|logical|edge)
           <...>-3441924 [004] .... 1907374.583464: kvm_set_irq: gsi 0 leve=
l 0
source 0
.....


----------------------=20


Strace (15 second) output:

 55.39    0.082181          16      4937           ioctl
 23.05    0.034208          14      2390           ppoll
 21.56    0.031990          13      2379           futex
  0.00    0.000001           0        30           read
------ ----------- ----------- --------- --------- ----------------
100.00    0.148380                  9736           total


-----------------------

KVM stat live output:

        APIC_ACCESS      11491    44.50%     5.12%      1.82us   5021.41us=
=20=20=20=20=20
9.41us ( +-   9.87% )
       EPT_MISCONFIG       8007    31.01%    17.51%     11.25us  11003.56us=
=20=20=20=20
46.18us ( +-   8.59% )
                 HLT       3804    14.73%    76.26%      2.19us   3962.04us=
=20=20=20
423.30us ( +-   0.44% )
  EXTERNAL_INTERRUPT       2492     9.65%     0.46%      0.96us    163.72us=
=20=20=20=20
 3.91us ( +-   4.36% )
   PAUSE_INSTRUCTION         14     0.05%     0.00%      1.24us      6.59us=
=20=20=20=20
 3.40us ( +-  14.61% )
      IO_INSTRUCTION          8     0.03%     0.64%      8.34us  13470.05us=
=20=20
1693.58us ( +-  99.34% )
   PENDING_INTERRUPT          3     0.01%     0.00%      2.31us      3.69us=
=20=20=20=20
 2.99us ( +-  13.36% )
       EPT_VIOLATION          2     0.01%     0.00%      7.74us      9.37us=
=20=20=20=20
 8.56us ( +-   9.51% )
       EXCEPTION_NMI          1     0.00%     0.00%      3.09us      3.09us=
=20=20=20=20
 3.09us ( +-   0.00% )
 TPR_BELOW_THRESHOLD          1     0.00%     0.00%      2.39us      2.39us=
=20=20=20=20
 2.39us ( +-   0.00% )


We have tried quite a few of the HyperV enlightenments and clock settings a=
nd
those do not resolve the issue

We can reproduce the issue by stopping all guests(7) on the host and starti=
ng
them up at the same time - this may take a couple of cycles(2-3) en-masse
restarts and 1 or 2 out of the 7 will exhibit this behavior


CPU is host-passthrough
Server has 24 cores with 256G of ram=20


Looking to see if anyone in the community has encountered this problem.=20

Thanks=20
Bill

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
