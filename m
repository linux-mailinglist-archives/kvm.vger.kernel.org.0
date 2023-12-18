Return-Path: <kvm+bounces-4743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 493BE81782C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 18:07:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E95842837CA
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49DA5D735;
	Mon, 18 Dec 2023 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwAy4dmM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3B34FF68
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 17:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F0A4C433CB
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702919226;
	bh=/ZTv56FEw8xRlKF7HJqRmpq1ussyhp64dWBig6cj67E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WwAy4dmMdfHVGJzqXgUIurZkyq2OGAW/AGUwgTkBIvsGjMhd36EPYeDl8WDN1qTfT
	 dCSYjbR72DGBKLPQQgwbqAAmG8MIDbzynMJMvlZ+DPWtmbZICQP1GoMCQh8Z0Pioqq
	 dHLS/yJtDxP1kqfchxCzb66ZyeziF4fgTJ4nmtBvHoIgBNk2A67MI4LTJJyM8fPWQY
	 ikGys5rsihQ1rCCR58MykNkBFfd00JmsXdSJD/8CTvwcZn8eeXc2QwkT1BoVMtqMFE
	 3iLkiIrPlKlQxEs4sNQ26dJIFJlhgtNvPdrsKU17qi0AWzQ/L/uEX6uKY+h7AZPqXj
	 /M8noE2Hm6h1g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4B18BC53BD2; Mon, 18 Dec 2023 17:07:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Mon, 18 Dec 2023 17:07:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218259-28872-oOlnHKCFQq@https.bugzilla.kernel.org/>
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

--- Comment #5 from Sean Christopherson (seanjc@google.com) ---
On Thu, Dec 14, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218259
>=20
> --- Comment #2 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
> Hi,
>=20
> 1. KSM is already disabled. Didn't try to enable it.
> 2. NUMA autobalancing was enabled on the host (value 1), not in the guest.
> When
> disabled, I can't see the issue anymore.

This is likely/hopefully the same thing Yan encountered[1].  If you are abl=
e to
test patches, the proposed fix[2] applies cleanly on v6.6 (note, I need to =
post
a
refreshed version of the series regardless), any feedback you can provide w=
ould
be much appreciated.

KVM changes aside, I highly recommend evaluating whether or not NUMA
autobalancing is a net positive for your environment.  The interactions bet=
ween
autobalancing and KVM are often less than stellar, and disabling autobalanc=
ing
is sometimes a completely legitimate option/solution.

[1] https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
[2] https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.com

> 3. tdp_mmu was "Y", disabling it seems to make no difference.

Hrm, that's odd.  The commit blamed by bisection was purely a TDP MMU chang=
e.
Did you relaunch VMs after disabling the module params?  While the module p=
aram
is writable, it's effectively snapshotted by each VM during creation, i.e.
toggling
it won't affect running VMs.

> So might be related to NUMA. On older kernels, the flag is 1 as well.
>=20
> There's one difference in the kernel messages that I hadn't noticed befor=
e.
> The
> newer one prints "pci_bus 0000:7f: Unknown NUMA node; performance will be
> reduced" (same with ff again). The older ones don't. No idea what this me=
ans,
> if it's important, and can't find info on the web regarding it.

That was a new message added by commit ad5086108b9f ("PCI: Warn if no host
bridge
NUMA node info"), which was first released in v5.5.  AFAICT, that warning is
only
complaning about the driver code for PCI devices possibly running on the wr=
ong
node.

However, if you are seeing that error on v6.1 or v6.6, but not v5.17, i.e. =
if
the
message started showing up well after the printk was added, then it might b=
e a
symptom of an underlying problem, e.g. maybe the kernel is botching parsing=
 of
ACPI tables?

> I think the kernel is preemptible:

Ya, not fully preemptible (voluntary only), but the important part is that =
KVM
will drop mmu_lock if there is contention (which is a "requirement" for the=
 bug
that Yan encountered).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

