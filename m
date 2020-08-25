Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122DE251DD3
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 19:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgHYRJJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Aug 2020 13:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHYRJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 13:09:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209025] The "VFIO_MAP_DMA failed: Cannot allocate memory" bug
 is back
Date:   Tue, 25 Aug 2020 17:09:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: niklas@komani.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209025-28872-dV11PwqzYf@https.bugzilla.kernel.org/>
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

--- Comment #9 from Niklas Schnelle (niklas@komani.de) ---
Hi Robert,

git does not know what you compiled so you could just
do "git bisect;git good v5.8;git bad v5.9-rc1"
with that said it is of course best to always compile the versions
you tell git are (not) working.

I'm a fellow Arch Linux user (on all my private machines) and actually suspect
its current QEMU and other package versions were necessary to expose this bug
and are the reason Alex could not reproduce this.

I did not do the git bisect with PKGBUILDs though, instead I
have a custom systemd-boot entry and in the .config set LOCALVERSION="-niklas"
then I used the following commands:

cd linux
zcat /proc/config.gz > .config # once ton get Arch Config
make oldconfig
make -j 24 
sudo make modules_install -j INSTALL_MOD_STRIP=1
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-linux-niklas
sudo mkinitcpio -p linux-niklas 

The last part is arch specific, on other distros there is a special
installkernel script that does the copy to /boot and rebuilds the initramfs and
also creates bootloader entries.
Also only add the strip flag if you don't need debug symbols
in modules.

The manual cp/modules_install of course means I have
to delete the /usr/lib/modules/.. folders manually but they all have "niklas"
in the name so that's easy enough ;-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
