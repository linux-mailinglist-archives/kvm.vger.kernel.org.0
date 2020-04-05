Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AED19ECC2
	for <lists+kvm@lfdr.de>; Sun,  5 Apr 2020 18:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgDEQws convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 5 Apr 2020 12:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbgDEQws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Apr 2020 12:52:48 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Sun, 05 Apr 2020 16:52:47 +0000
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
Message-ID: <bug-206579-28872-BpMz7tv6aJ@https.bugzilla.kernel.org/>
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

--- Comment #52 from Anthony (anthonysanwo@googlemail.com) ---
(In reply to muncrief from comment #51)
> Created attachment 288207 [details]
> Latest KVM warnings information
> 
> Okay gentlemen, here is an archive with all the latest information I have
> for the continued KVM warnings. To make things as clean as possible I did a
> clean compile of kernel 5.6.0 from the torvalds git. As before the first KVM
> patch was already in the kernel, and I manually checked the source file just
> to be sure. And the second KVM patch applied cleanly. However I included
> both patches so you can check to make sure they're correct. Here's a quick
> description of the four files in the archive:
> 
> dmesg_kvm_warnings.txt - Full dmesg output after a reboot, and then starting
> and logging into the VM.
> 
> Win10-1_UEFI.xml - The VM XML.
> 
> kvm_1.patch - The first KVM patch, which is now already in the kernel
> 
> 
> kvm_2.patch - The second KVM patch that applied cleanly to the kernel.

Yh the second patch is the GA Log one which has been queued for Linux 5.7.

Good news I finally managed to reproduce the same errors both in a test VM and
my current config.

To start my investigate I first made a test VM closely matching your config
minus the PCI devices that can passthrough. After some trial and error, I
managed to find out why I don't see the errors before in my config.

I found when installing Windows the errors would show up 100% of the time just
after it finishes installing and during the reboots to finish the setup. It
also produces the warning around the time a user account has been logged in.
Outside of that, I wasn't able to find any case to produce the warning 100% of
the time. In general, it just happens from time to time when the guest is
running.

The reason I wasn't getting the warnings was that I had both CPU pinning and
-overcommit cpu-pm so when I last tested I never tested with my cpu pinning
disabled.

In general, either CPU pinning or using -overcommit cpu-pm I have found
resulted in no warnings in both my test VM and current config.

Hopefully that helps with debugging the cause.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
