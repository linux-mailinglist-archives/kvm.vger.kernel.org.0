Return-Path: <kvm+bounces-4818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B62818975
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B56241F21C03
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 14:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D802D7A6;
	Tue, 19 Dec 2023 14:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPQ4hCa0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DD7225D9
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 14:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1B66C433C9
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 14:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702994948;
	bh=KMzNmtuyZOj8ibjcBU9ONEYGt1jOdrkz9i7vW0cpWwA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aPQ4hCa0fQR+5rIWtz+25t650eO+B23c/n5H+6ztjSBrV7byXElgeCUT94dvrtdJc
	 QFmb8dNwQSp6YRvx/k3rYCsXs0E5KLZRo3wsrPbDS/4VheCFptNN8f2Yt49uzmZ65N
	 wOQspVdiyK7YQwkwXgA5+o10Cd3+TmX5iOeQJu7A0FwQ79iq+6dqldjk/jajQpn1Lw
	 8VLNOEiGnkIMX6MbldPQ+JlekRp3p/ksGHvcnjYgIkAxSRAi9ZE9J1nOYPa3sXfRlV
	 MBOMwoBOmG8Fox4LbwOMZywM68lOs9h+fhcyed80TpDdc+3hpY4r6mRGepAQCD69oN
	 2+qbPkh07lRcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CD2DDC53BD1; Tue, 19 Dec 2023 14:09:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Tue, 19 Dec 2023 14:09:08 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernelbugs2012@joern-heissler.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218259-28872-h88Ho5XI7I@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218259-28872@https.bugzilla.kernel.org/>
References: <bug-218259-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218259

--- Comment #6 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
(In reply to Sean Christopherson from comment #5)

> This is likely/hopefully the same thing Yan encountered[1].  If you are a=
ble
> to
> test patches, the proposed fix[2] applies cleanly on v6.6 (note, I need to
> post a
> refreshed version of the series regardless), any feedback you can provide
> would
> be much appreciated.
>=20
> [1] https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
> [2] https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com

I admit that I don't understand most of what's written in the those threads.
I applied the two patches from [2] (excluding [3]) to v6.6 and it appears to
solve the problem.

However I haven't measured how/if any of the changes/flags affect performan=
ce
or if any other problems are caused. After about 1 hour uptime it appears t=
o be
okay.

[3] https://lore.kernel.org/all/ZPtVF5KKxLhMj58n@google.com/


> KVM changes aside, I highly recommend evaluating whether or not NUMA
> autobalancing is a net positive for your environment.  The interactions
> between
> autobalancing and KVM are often less than stellar, and disabling
> autobalancing
> is sometimes a completely legitimate option/solution.

I'll have to evaluate multiple options for my production environment.
Patching+Building the kernel myself would only be a last resort. And it will
probably take a while until Debian ships a patch for the issue. So maybe
disable the NUMA balancing, or perhaps try to pin a VM's memory+cpu to a si=
ngle
NUMA node.

> > 3. tdp_mmu was "Y", disabling it seems to make no difference.
>=20
> Hrm, that's odd.  The commit blamed by bisection was purely a TDP MMU cha=
nge.
> Did you relaunch VMs after disabling the module params?  While the module
> param
> is writable, it's effectively snapshotted by each VM during creation, i.e.
> toggling
> it won't affect running VMs.

It's quite possible that I did not restart the VM afterwards. I tried again,
this time paying attention. Setting it to "N" *does* seem to eliminate the
issue.


> > The newer one prints "pci_bus 0000:7f: Unknown NUMA node; performance w=
ill
> be
> > reduced" (same with ff again). The older ones don't.
>=20
> That was a new message added by commit ad5086108b9f ("PCI: Warn if no host
> bridge
> NUMA node info"), which was first released in v5.5.

Seems I looked on systems running older (< v5.5) kernels. On the ones with
v5.10 the message is printed too.


Thanks a lot so far, I believe I've now got enough options to consider for =
my
production environment.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

