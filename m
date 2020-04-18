Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F771AF561
	for <lists+kvm@lfdr.de>; Sun, 19 Apr 2020 00:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgDRW2B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 18 Apr 2020 18:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgDRW2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 18:28:01 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sat, 18 Apr 2020 22:28:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anthonysanwo@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-nMzCacfsoo@https.bugzilla.kernel.org/>
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

--- Comment #59 from Anthony (anthonysanwo@googlemail.com) ---
(In reply to muncrief from comment #57)
> I just compiled and installed 5.7-rc1 and according to "perf kvm stat live"
> AVIC is not working at all again. I wasn't able to apply the normal patches
> because the code directory structure has changed, so this is just a raw
> compile from git.
> 
> My VM hasn't changed from Comment 51. So are there new patches I'm supposed
> to apply, or changes that need to be made to my XML? Or is AVIC in an
> interim dysfunctional state in 5.7-rc1?

Have you tried using perf top? I have found this to be the most reliable way to
know AVIC is working as it shows the kernel functions being used. perf stat
live only shows vmexits by default which isn't always easy to know for sure
AVIC is activate. sudo perf stat -e 'kvm:*' -a -- sleep 1 helps to check if
it's working optimally as it gives you counter of all kvm related vmexits that
happen after 1 second.

You can do so with the below command -

sudo perf kvm --host top --kallsyms=/proc/kallsyms -gp `pidof
qemu-system-x86_64`

It might not resolve the symbols the first time. Easy way to check is by
searching for "svm" using "\". If you get no results exit with "Esc" or "Ctrl +
C" and try again.The other reason might be your kernel doesn't have
CONFIG_KALLSYMS enabled.

You can use "h" to bring up the help menu for other commands.

To see if SVM AVIC is working you want to search for it should return something
like what I posted in comment 49/50.

   0.61%  [kvm_amd]  [k] svm_deliver_avic_intr
   0.05%  [kvm_amd]  [k] avic_vcpu_put.part.0
   0.02%  [kvm_amd]  [k] avic_vcpu_load

And for IOMMU AVIC -
   2.83%  [kernel]  [k] iommu_completion_wait
   0.87%  [kernel]  [k] __iommu_queue_command_sync
   0.16%  [kernel]  [k] amd_iommu_update_ga
   0.03%  [kernel]  [k] iommu_flush_irt

As far as Linux 5.7-rc1 AVIC is working as described in comment 55 including
when tested with the patch that fixes IOMMU AVIC on windows.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
