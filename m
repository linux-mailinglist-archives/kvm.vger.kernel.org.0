Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202FF1731C4
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 08:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgB1H0w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 28 Feb 2020 02:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgB1H0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 02:26:52 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Fri, 28 Feb 2020 07:26:51 +0000
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
Message-ID: <bug-206579-28872-kuPRiZaBRU@https.bugzilla.kernel.org/>
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

--- Comment #34 from muncrief (rmuncrief@humanavance.com) ---
Created attachment 287697
  --> https://bugzilla.kernel.org/attachment.cgi?id=287697&action=edit
Working avic setup information

Final success Suravee!

The last steps were to disable nested virtualization and set the pit tickpolicy
to discard. Setting kernel_irgchip to split was not necessary, and actually
caused the GPU HDMI audio to crackle and eventually disappear. There was also
no need to pass kernel options via grub as they can be specified in an option
file. I've attached the final working grub and qemu command lines, and VM XML,
to this comment.

So to wrap things up, here are the steps I took to get avic fully functioning:

1. Download the Arch linux-mainline AUR package, which currently downloads
kernel 5.6 rc3 from
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git.

2. Patch the kernel source with "svm.c patch option 2" from the Attachments and
compile the kernel.

3. Create file "/etc/modprobe.d/kvm.conf" and add "options kvm_amd avic=1
nested=0" to it.

4. Edit the VM XML file and change the pit tickpolicy with "<timer name='pit'
tickpolicy='discard'/>"

And that was it. I didn't see any performance change with the quick CPUID
benchmark I ran, but that may be because the VM runs at 98% of bare metal
already. It's really amazing.

So if you could give me the final word on which svm patch should be used that's
it for this bug (I used patch 2 because it seemed more direct). And if anyone
knows how to set the avic and nested options in the XML file, instead of an
options file, that would be great. I couldn't find any way to do it, and at
this point am assuming it can only be done in a file.

Thank you and Paolo and Alex for all your help, it's been both fun and
educational hammering out this bug with all of you.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
