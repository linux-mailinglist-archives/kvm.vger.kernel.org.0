Return-Path: <kvm+bounces-17979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B6D8CC736
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 21:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A836B222EC
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 19:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FE5146013;
	Wed, 22 May 2024 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N36bXLLY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96995FBB3
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 19:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716406306; cv=none; b=GNSievzOd9cC69/lYa72E9AR937QpgDvPRpRfmgY0JCS5lc2YtfZgQQGpBtcqqvzzLFXwGI5tvuATfto0+R0m6Xwm4bZnC6OZ/6bAtMNA+s7oOqg4idIYYLWVFq28jWo0ePRkspXZpJFe7UKLHncRkFiuSbiWHABXC3g/hIfbYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716406306; c=relaxed/simple;
	bh=fjOk1xV6d3/dBjkUg/hJ1BXTcGqFqEvJlrwDsM76rnk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hoqNl2loH22RXP8bL/pAVT5Pni5M24Z4xh7vRQe77AG2/scnN8dfN30FAmiVMI6GwZjZMlk1Anh1SAzPZsgWZ2AG5p5FRd/KPYZ0EluC6rF+TVzXyotuKtNpvcarz/CgxyLnFBe4cb9JVI2rKxQ7sLD+Nzo4f7vpP4scQq3Eo+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N36bXLLY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D4F0C4AF07
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 19:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716406305;
	bh=fjOk1xV6d3/dBjkUg/hJ1BXTcGqFqEvJlrwDsM76rnk=;
	h=From:To:Subject:Date:From;
	b=N36bXLLYltcHn3kbvkV52EV3+eGN50/X7nvgIq4dI55PrNxq7r/RmBhVMfs3Xg43F
	 9tMfv0fmSPERZ5//aTeE1DOGhrW8BkKBu5lCmEtTTykSMiK5QEB37FtluWtjze5PHP
	 HVe7FCVimHFieSlHRajszf9/91Z1vaX4vuoGTX7sl54jAhsjRJJYS78dejshJBtEd3
	 ZrsBIDEOPCJY3txnn3oRh3r7hxa5aib4AUlxbrSiaah0NG8cRqPQaPe8aQRK/usD4n
	 81TrhRSr9XKNVPYo9ECiOwb4C1aUQ/Yr+qxwk2w4zv7kNdicCk/OiFH5ld+CzTFjKb
	 RYpFfD/R60k/A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7213DC53B73; Wed, 22 May 2024 19:31:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] New: PCIE device crash when trying to pass through USB
 Device to virtual machine
Date: Wed, 22 May 2024 19:31:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dan@danalderman.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218876-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218876

            Bug ID: 218876
           Summary: PCIE device crash when trying to pass through USB
                    Device to virtual machine
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: dan@danalderman.co.uk
        Regression: No

Hi.

I'm running a Debian Bookworm host with Xanmod 6.9.1 kernel

This motherboard:

https://www.supermicro.com/en/products/motherboard/a2sdi-16c-tp8f

With this USB controller in the 4x PCIe slot.

https://www.startech.com/en-gb/cards-adapters/pexusb3s2ei

The USB card is based on the Renesas uPD720201 USB 3.0 Host Controller and
reports the latest firmware.

I have a Debian Bookworm VM running on this host, which I intend to pass the
entire PCIe card through to (Gnome+Plexamp->USB-SPDIF).  If I configure the=
 VM
to do this the VM fails to start and I get the following errors from the
kernel.  The card then becomes seemingly unrecoverable without a warm reboo=
t at
least.

I have tried many kernel and BIOS options regarding PCIe but nothing has he=
lped
so far.  I'll attach a boot log. This is the error when I start the VM:

May 19 09:24:46 kryten kernel: VFIO - User Level meta-driver version: 0.3
May 19 09:24:46 kryten kernel: xhci_hcd 0000:02:00.0: remove, state 1
May 19 09:24:46 kryten kernel: usb usb4: USB disconnect, device number 1
May 19 09:24:46 kryten kernel: xhci_hcd 0000:02:00.0: USB bus 4 deregistered
May 19 09:24:46 kryten kernel: xhci_hcd 0000:02:00.0: remove, state 1
May 19 09:24:46 kryten kernel: usb usb3: USB disconnect, device number 1
May 19 09:24:46 kryten kernel: usb 3-4: USB disconnect, device number 2
May 19 09:24:46 kryten kernel: xhci_hcd 0000:02:00.0: USB bus 3 deregistered
May 19 09:24:47 kryten kernel: usb 1-1.2: USB disconnect, device number 4
May 19 09:24:53 kryten kernel: pcieport 0000:00:09.0: broken device, retrai=
ning
non-functional downstream link at 2.5GT/s
May 19 09:24:54 kryten kernel: pcieport 0000:00:09.0: retraining failed
May 19 09:24:55 kryten kernel: pcieport 0000:00:09.0: broken device, retrai=
ning
non-functional downstream link at 2.5GT/s
May 19 09:24:56 kryten kernel: pcieport 0000:00:09.0: retraining failed
May 19 09:24:56 kryten kernel: vfio-pci 0000:02:00.0: not ready 1023ms after
bus reset; waiting
May 19 09:24:57 kryten kernel: vfio-pci 0000:02:00.0: not ready 2047ms after
bus reset; waiting
May 19 09:24:59 kryten kernel: vfio-pci 0000:02:00.0: not ready 4095ms after
bus reset; waiting
May 19 09:25:04 kryten kernel: vfio-pci 0000:02:00.0: not ready 8191ms after
bus reset; waiting
May 19 09:25:12 kryten kernel: vfio-pci 0000:02:00.0: not ready 16383ms aft=
er
bus reset; waiting
May 19 09:25:29 kryten kernel: vfio-pci 0000:02:00.0: not ready 32767ms aft=
er
bus reset; waiting
May 19 09:26:05 kryten kernel: pcieport 0000:00:09.0: broken device, retrai=
ning
non-functional downstream link at 2.5GT/s
May 19 09:26:06 kryten kernel: pcieport 0000:00:09.0: retraining failed
May 19 09:26:08 kryten kernel: pcieport 0000:00:09.0: broken device, retrai=
ning
non-functional downstream link at 2.5GT/s
May 19 09:26:09 kryten kernel: pcieport 0000:00:09.0: retraining failed
May 19 09:26:09 kryten kernel: vfio-pci 0000:02:00.0: not ready 1023ms after
bus reset; waiting
May 19 09:26:10 kryten kernel: vfio-pci 0000:02:00.0: not ready 2047ms after
bus reset; waiting
May 19 09:26:12 kryten kernel: vfio-pci 0000:02:00.0: not ready 4095ms after
bus reset; waiting
May 19 09:26:16 kryten kernel: vfio-pci 0000:02:00.0: not ready 8191ms after
bus reset; waiting
May 19 09:26:25 kryten kernel: vfio-pci 0000:02:00.0: not ready 16383ms aft=
er
bus reset; waiting
May 19 09:26:43 kryten kernel: vfio-pci 0000:02:00.0: not ready 32767ms aft=
er
bus reset; waiting
May 19 09:27:18 kryten kernel: vfio-pci 0000:02:00.0: Unable to change power
state from D0 to D3hot, device inaccessible
May 19 09:27:19 kryten kernel: vfio-pci 0000:02:00.0: Unable to change power
state from D3cold to D0, device inaccessible
May 19 09:27:19 kryten kernel: vfio-pci 0000:02:00.0: Unable to change power
state from D3cold to D0, device inaccessible
May 19 09:27:19 kryten kernel: vfio-pci 0000:02:00.0: Unable to change power
state from D3cold to D0, device inaccessible
May 19 09:27:19 kryten kernel: vfio-pci 0000:02:00.0: Unable to change power
state from D3cold to D0, device inaccessible
May 19 09:27:19 kryten kernel: vfio-pci 0000:02:00.0: Unable to change power
state from D3cold to D0, device inaccessible
May 19 09:27:19 kryten kernel: xhci_hcd 0000:02:00.0: Invalid ROM..
May 19 09:27:19 kryten kernel: xhci_hcd 0000:02:00.0: Unable to change power
state from D3cold to D0, device inaccessible
May 19 09:27:19 kryten kernel: xhci_hcd 0000:02:00.0: xHCI Host Controller
May 19 09:27:19 kryten kernel: xhci_hcd 0000:02:00.0: new USB bus registere=
d,
assigned bus number 3
May 19 09:27:19 kryten kernel: xhci_hcd 0000:02:00.0: Host halt failed, -19
May 19 09:27:19 kryten kernel: xhci_hcd 0000:02:00.0: can't setup: -19
May 19 09:27:19 kryten kernel: xhci_hcd 0000:02:00.0: USB bus 3 deregistered
May 19 09:27:19 kryten kernel: xhci_hcd 0000:02:00.0: init 0000:02:00.0 fai=
l,
-19

Thanks for your time and help.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

