Return-Path: <kvm+bounces-4824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0497818AFA
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 16:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50AA51F24212
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F6A1CA97;
	Tue, 19 Dec 2023 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YshL7osj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F05D1CA80
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 15:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A78D5C433C9
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702998968;
	bh=D1VwdLk59/i70pH9Yp7fpKIgWrbEGAfMpu5g7Vt63MI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YshL7osjxW5Etel55qQK7umGhbo6pBwZwqiBQfdbTtRj66VyHiqseagZKBGUbozRu
	 Gpjb45V/C1Z7omqhzncdirogTzpOKitWAhpntLSL4DCzYN4oWR0sNnt2RhvD/eFtjV
	 nh7rkNDOx7hvic57Dd6lNM2FAOTAPsDzE9jb7+i7f33fcxexLhWGRVgQ9iQQVCuEDo
	 PM9QqlOvkcqWHaY6P7TVWrlKQlqCGjbXdl1xBSzOgXhGgAbz/fJ1REjGQlpZh3Kihj
	 kI15gDWtqOW+/H4XfjsclBIJBvRHq5TGQ6jJxt9KQuNDg/Bjx76ShZgm3SMkVjJ8Cb
	 y7x67FtlHFtgg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 93F5CC53BD2; Tue, 19 Dec 2023 15:16:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Tue, 19 Dec 2023 15:16:08 +0000
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
Message-ID: <bug-218259-28872-rHHddF6TmR@https.bugzilla.kernel.org/>
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

--- Comment #7 from Sean Christopherson (seanjc@google.com) ---
On Tue, Dec 19, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218259
>=20
> --- Comment #6 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
> (In reply to Sean Christopherson from comment #5)
>=20
> > This is likely/hopefully the same thing Yan encountered[1].  If you are
> able
> > to
> > test patches, the proposed fix[2] applies cleanly on v6.6 (note, I need=
 to
> > post a
> > refreshed version of the series regardless), any feedback you can provi=
de
> > would
> > be much appreciated.
> >=20
> > [1] https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.=
com
> > [2] https://lore.kernel.org/all/20230825020733.2849862-1-seanjc@google.=
com
>=20
> I admit that I don't understand most of what's written in the those threa=
ds.

LOL, no worries, sometimes none of us understand what's written either ;-)

> I applied the two patches from [2] (excluding [3]) to v6.6 and it appears=
 to
> solve the problem.
>=20
> However I haven't measured how/if any of the changes/flags affect perform=
ance
> or if any other problems are caused. After about 1 hour uptime it appears=
 to
> be
> okay.

Don't worry too much about additional testing.  Barring a straight up bug
(knock
wood), the changes in those patches have a very, very low probability of
introducing unwanted side effects.

> > KVM changes aside, I highly recommend evaluating whether or not NUMA
> > autobalancing is a net positive for your environment.  The interactions
> > between
> > autobalancing and KVM are often less than stellar, and disabling
> > autobalancing
> > is sometimes a completely legitimate option/solution.
>=20
> I'll have to evaluate multiple options for my production environment.
> Patching+Building the kernel myself would only be a last resort. And it w=
ill
> probably take a while until Debian ships a patch for the issue. So maybe
> disable the NUMA balancing, or perhaps try to pin a VM's memory+cpu to a
> single
> NUMA node.

Another viable option is to disable the TDP MMU, at least until the above
patches
land and are picked up by Debian.  You could even reference commit 7e546bd0=
8943
("Revert "KVM: x86: enable TDP MMU by default"") from the v5.15 stable tree=
 if
you want a paper trail that provides some justification as to why it's ok to
revert
back to the "old" MMU.

Quoting from that:

  : As far as what is lost by disabling the TDP MMU, the main selling point=
 of
  : the TDP MMU is its ability to service page fault VM-Exits in parallel,
  : i.e. the main benefactors of the TDP MMU are deployments of large VMs
  : (hundreds of vCPUs), and in particular delployments that live-migrate s=
uch
  : VMs and thus need to fault-in huge amounts of memory on many vCPUs after
  : restarting the VM after migration.

In other words, the old MMU is not broken, e.g. it didn't suddently become
unusable
after 15+ years of use.  We enabled the newfangled TDP MMU by default becau=
se
it
is the long-term replacement, e.g. it can scale to support use cases that t=
he
old
MMU falls over on, and we want to put the old MMU into maintenance-only mod=
e.

But we are still ironing out some wrinkles in the TDP MMU, particularly for
host
kernels that support preemption (the kernel has lock contention logic that =
is
unique to preemptible kernels).  And in the meantime, for most KVM use case=
s,
the
old MMU is still perfectly servicable.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

