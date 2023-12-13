Return-Path: <kvm+bounces-4359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB10811A22
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81D741C2111E
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 16:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F74039FFE;
	Wed, 13 Dec 2023 16:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uxNvsCJp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A64B35F0F
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 16:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC47CC433C8
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702486485;
	bh=tEOWZFYrRER30bO/WCGCNTkgAcxAmBfaBXYEhzH3hmM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uxNvsCJp6GTiusOur36Zr8R9OASC8mJ787GhDcMS9TXFqm6ToDkjsUewH9btF42yq
	 HxnWC1whAMA8HfEepV5bpK3JN3JIUlP6wIKIMRQL+9ab3EPj0qJlpDMZmxzUobPhO0
	 rBek1MXPs/WYcSYsqb3yFcYpw3a3bDMKiiZsWihIKQiFs7tQld1UkgbUfPBmgVv9/W
	 bBYaSnWtP9PJVYOJz5hhPqYo1DgXAtikvlukzGA3/n5ot2c2NuHpq9WNU50OjuhUJC
	 pmZOKTAlwfqtPghsIsV/o1z2nCORG+LDWm1ERa/QJ/63xu4nr56cp/gE9g0GDJP/46
	 Bme8rgmW+ahQA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B93CEC53BC6; Wed, 13 Dec 2023 16:54:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Wed, 13 Dec 2023 16:54:45 +0000
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
Message-ID: <bug-218259-28872-xlZY7A1R7Q@https.bugzilla.kernel.org/>
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

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Tue, Dec 12, 2023, bugzilla-daemon@kernel.org wrote:
> The affected hosts run Debian 12; until Debian 11 there was no trouble.
> I git-bisected the kernel and the commit which appears to somehow cause t=
he
> trouble is:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3Df47e5bbbc92f5d234bbab317523c64a65b6ac4e2

Huh.  That commit makes it so that KVM keeps non-leaf SPTEs, i.e. upper lev=
el
page
table structures, when zapping/unmapping a guest memory range.  The idea is
that
preserving paging structures will allow for faster unmapping (less work) and
faster
repopulation if/when the guest faults the memory back in (again, less work =
to
create
a valid mapping).

The only downside that comes to mind is that keeping upper level paging
structures
will make it more costly to handle future invalidations as KVM will have to
walk
deeper into the page tables before discovering more work that needs to be d=
one.

> Qemu command line: See below.
> Problem does *not* go away when appending "kernel_irqchip=3Doff" to the
> -machine
> parameter
> Problem *does* go away with "-accel tcg", even though the guest becomes m=
uch
> slower.

Yeah, that's expected, as that completely takes KVM out of the picture.

> All affected guests run kubernetes with various workloads, mostly Java,
> databases like postgres und a few legacy 32 bit containers.
>=20
> Best method to manually trigger the problem I found was to drain other
> kubernetes nodes, causing many pods to start at the same time on the affe=
cted
> guest. But even when the initial load settled, there's little I/O and the
> guest is like 80% idle, the problem still occurs.
>=20
> The problem occurs whether the host runs only a single guest or lots of o=
ther
> (non-kubernetes) guests.
>=20
> Other (i.e. not kubernetes) guests don't appear to be affected, but those=
 got
> way less resources and usually less load.

The affected flows are used only for handling mmu_notifier invalidations and
for
edge cases related to non-coherent DMA.  I don't see any passthrough device=
s in
your setup, so that rules out the non-coherent DMA side of things.

A few things to try:

 1. Disable KSM (if enabled)

        echo 0 > /sys/kernel/mm/ksm/run

 2. Disable NUMA autobalancing (if enabled):

        echo 0 > /proc/sys/kernel/numa_balancing

 3. Disable KVM's TDP MMU.  On pre-v6.3 kernels, this can be done without
having
    to reload KVM (or reboot the kernel if KVM is builtin).

        echo N > /sys/module/kvm/parameters/tdp_mmu

    On v6.3 and later kernels, tdp_mmu is a read-only module param and so n=
eeds
    to be disable when loading kvm.ko or when booting the kernel.

There are plenty more things that can be tried, but the above are relatively
easy
and will hopefully narrow down the search significantly.

Oh, and one question: is your host kernel preemptible?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

