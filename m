Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025A92651E1
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 23:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgIJVEI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Sep 2020 17:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbgIJVDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 17:03:45 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209079] CPU 0/KVM: page allocation failure on 5.8 kernel
Date:   Thu, 10 Sep 2020 21:03:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel@martin.schrodt.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209079-28872-rMRH9f2z0d@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209079-28872@https.bugzilla.kernel.org/>
References: <bug-209079-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209079

--- Comment #5 from Martin Schrodt (kernel@martin.schrodt.org) ---
Strange things happen sometimes...

What I did (I did only unload/reload the module after config changes, hoping
this would suffice):

- running with "kvm_amd nested=0 avic=1 npt=0" and "kvm_amd nested=0 npt=0" on
5.8.7, all working fine.

- rolling back to the 5.8.5 kernel I had the bug with, and trying the above
combinations -> working fine

- rolling the VM back to a state before changing it to AVIC (reasonably sure
it's the same) -> working fine, on both 5.8.7 and 5.8.5.

Heisenbugs here they come.

Trying to come up with things that I changed since then but did not roll back
yet:

I have a qemu hook, which did the following: 

1) drop caches, 
2) compact memory 
3) create a cpuset for the host and move all tasks there to free the cores
assigned to the VM (which included a flag for memory migration, so that the
processes would have their memory moved to the non VM node) 
4) then let qemu allocate memory

Since then I changed this to move the compacting step after the moving step (my
thought was that *after* moving the memory from node 1 to node 0, there is more
free space on node 1, compaction should yield better results)

Does the error I initially got say anything about *why* the allocation failed?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
