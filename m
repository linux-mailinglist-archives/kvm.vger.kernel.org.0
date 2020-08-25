Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784BE250DD6
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 02:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgHYAxO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Aug 2020 20:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:32866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHYAxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 20:53:14 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209025] The "VFIO_MAP_DMA failed: Cannot allocate memory" bug
 is back
Date:   Tue, 25 Aug 2020 00:53:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209025-28872-XUeSVoycBy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209025-28872@https.bugzilla.kernel.org/>
References: <bug-209025-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209025

--- Comment #3 from muncrief (rmuncrief@humanavance.com) ---
Unfortunately bisect failed, and in a very odd way. I've bisected the kernel
numerous times over the decades, but this time it didn't work correctly from
the start because of module directories it wanted to delete that weren't there.

To make a long story short, after the initial compile of 5.9-rc1 I did the
normal bisect start and good/bad version definition. But when making the first
bisect it failed during the final phase of the modules process with errors
saying it couldn't delete
"pkg/linux-bisect/usr/lib/modules/5.9.0-rc1-1-bisect/source" or
"pkg/linux-bisect/usr/lib/modules/5.9.0-rc1-1-bisect/build". And when I looked
they didn't exist.

So I spent a few hours trying numerous things, but could never get bisect to
work as expected. In the end I just timed the manual creation of the
directories correctly as the modules process was completing, but then bisect
complained they were directories. So I tried again but this time just touched
to make files instead of directories, and bisect completed.

Perplexed but undeterred I installed and ran the bisected kernel, the VM
worked, and I marked the bisect as good. But when compiling the next bisect the
same thing happened, and I did the same thing to fix it. However this time when
I installed and ran the kernel my VM seemed to boot, but actually didn't.
Neither the QXL or passthrough GPU displays came on, and I couldn't shut it
down. I just had to do a power off.

So I rebooted with my working 5.8.3 kernel and was surprised that my entire VM
disk was completely erased. There were no partitions at all, it was just blank.
Of course I made a backup before doing all this so it was easy to restore, but
it's the first time I've ever seen anything like it.

In any case, the disk is attached to a passthrough Phison NVME controller, so I
assume there was some kind of different, silent, VFIO error that wiped out the
disk.

In summary, I have no idea what's going on. Of course sometimes bisect works
and sometimes it doesn't, and the kernel is the most difficult and dangerous to
bisect, but I've never seen actual process errors like this before. Compilation
errors yes, but not missing source or package files and directories.

I'm hoping, and assuming, this is some kind of pilot error on my part. If so,
and someone knows what it is, just tell me what it is and I'll give it another
try. By the way, I'm running Arch with all the latest updates.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
