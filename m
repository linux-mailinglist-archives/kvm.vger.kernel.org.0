Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E94174202
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgB1Waf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 28 Feb 2020 17:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgB1Wae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:30:34 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206707] Irregular behavior debugging userspace program on SMP
 guest
Date:   Fri, 28 Feb 2020 22:30:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dustin@virtualroadside.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206707-28872-5dARM6GC8A@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206707-28872@https.bugzilla.kernel.org/>
References: <bug-206707-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206707

--- Comment #2 from Dustin Spicuzza (dustin@virtualroadside.com) ---
Note: I'm really sorry about the extra emails... clicked 'submit bug' when
trying to upload an attachment. Oops! Here's the actual description of the bug:

Guest: Windows 7 x64
Host: Fedora 32 (rawhide?) kernel 5.6.0-0.rc3.git0.1.fc32.x86_64
QEMU: master e0175b7163

With an SMP guest (in this case Windows 7, but we've observed issues in other
OS also), debugging userspace programs exhibits irregular behavior. On older
kernels, a single step exception would escape into the guest application. On
newer kernels, this doesn't seem to occur anymore, but instead it takes down
the whole VM with a STOP 0x00000101 BSOD.

If it would be helpful to reproduce this bug with a Linux VM, I'm happy to try
and do so -- if you could point me at an ideal QCOW2 or distribution to use for
reproducing, that would be great.

None of these errors occur with QEMU in TCG mode.

Reproduction (version 1)
------------------------

TL;DR: I created a guest application that launches multiple threads, and a gdb
script that tries to debug the guest application. This setup reliably triggers
the bugs discussed above.


iloop.exe should be compiled from iloop.cpp. I used Visual Studio as 32-bit
project. I've also uploaded the exe if you don't want to compile your own.

When you compile your own iloop.exe, you need to run it at least once and
copy/paste the output (of various offsets needed for debugging) to the top of
the gdb script.

QEMU command line:

IMG=/path/to/image
VNC=some port
ROOT=/path/to/smb/share
UUID=some uuid

~/qemu-install/bin/qemu-system-x86_64 -enable-kvm \
        -m 4096 -gdb tcp::4567 -smp 4,cores=2 \
        -usb -usbdevice tablet \
        -net user,smb=${ROOT} -net nic,model=virtio \
        -device usb-ehci,id=ehci \
        -rtc base=utc,clock=vm \
        -show-cursor -monitor stdio -vnc :$VNC \
        -uuid $UUID -snapshot \
        $IMG

When running the quest, you need to run 'iloop.exe', then run gdb with the
attached script:

gdb -x gdbs.py

Once you start gdb, it will ask for the base address of iloop.exe, which is
output when the executable is started (because ASLR). The attached script will
try to pause in the executable's context, and once it detects it, will set two
hardware breakpoints, activate the two threads and watch for breakpoints to get
hit. Each time it gets hit it will validate that the counters each thread is
incrementing are correct.

After a few hundred or few thousand breakpoints getting hit, eventually the VM
will either hang, the guest application will crash with a single step exception
(0x80000004), or the guest VM will blue screen with a STOP 0x00000101 error.

Reproduction (version 2)
------------------------

Attaching GDB, switching to the context of the process, then running 'stepi
100000' will cause similar effects as observed above. May be a separate bug,
but doubtful. See original QEMU bug report @
https://bugs.launchpad.net/qemu/+bug/1863819

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
