Return-Path: <kvm+bounces-27853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 259F098F233
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 17:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCB4A2831B4
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 15:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB831A08A3;
	Thu,  3 Oct 2024 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfVWDWI6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2521A01BC
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727968312; cv=none; b=sOHEtkmNzM4hQGV7NpWcJcP7grE03a10TmcDbJzAIe/xESZg3yx9gTM+88K1tmDScU3YPIBGetB5EnncgnKRdi8gXxu+nPYNW+Bf5XwZThu/ba8HgdAhvr02h0pZgeeeEHNGSeEfVR1/L6LJYQzae/uHb9u4emvcoBKlYd5n+3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727968312; c=relaxed/simple;
	bh=ho4MlLm5V4koYEpudYUqhEMKFfzRHO7NxbC2tK0ic3w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uxkLh4l2Mtfa1AMwVm0D1m1Ml4PX4pDtPGDPAYA6T1UwVP/q0MjDdWd4x5BaZu7wyHbwXnScdwnmIG6Z0/DRVvQvEzS6YxQC/Nc3Nc9XUyqwuYKOkPAZuH/dptTOhdXXwHbal36AOMmpCPjRz+mdodQpzLB6PlzPgWsKwS7WFoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfVWDWI6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A86B1C4CECE
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727968311;
	bh=ho4MlLm5V4koYEpudYUqhEMKFfzRHO7NxbC2tK0ic3w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QfVWDWI6yI2GHeVBs/tHxXMTsPWQuzonj/2ZbCTosmwkj7Yv4ufeBv0sqTJWhAKjg
	 LCDUig8omGVJ/Cal8xwHIJnWiRhvn0OeUu7+mOCtkDFFk3SoQWmUrseFfpY13L/DRK
	 PfsI68imjRBAOLcaZnrfTFI0QL0WvRoHUz2eo5KTLJtiE7Sb6ecevhgK2qaAmsQpny
	 d/lwnkIVu2eKf+TbdYNOFSCB+jZUaKOC/YpcJGkdMjPdw9dGQoygWu2HWeqlQ7uJKw
	 PeIwWJNwHzDXt7W+JhTbiMDp8IHL5okTjicFS1nULB5IM85mC6Jt1Q01w5s6IRQ9Ja
	 G6sEccjb0WJgw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9F7EEC53BBF; Thu,  3 Oct 2024 15:11:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Thu, 03 Oct 2024 15:11:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-xazpFkwh9s@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219009

--- Comment #23 from mlevitsk@redhat.com ---
On Sat, 2024-07-06 at 11:20 +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219009
>=20
>             Bug ID: 219009
>            Summary: Random host reboots on Ryzen 7000/8000 using nested
>                     VMs (vls suspected)
>            Product: Virtualization
>            Version: unspecified
>           Hardware: AMD
>                 OS: Linux
>             Status: NEW
>           Severity: high
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: zaltys@natrix.lt
>         Regression: No
>=20
> Running nested VMs on AMD Ryzen 7000/8000 (ZEN4) CPUs results in random
> host's
> reboots.
>=20
> There is no kernel panic, no log entries, no relevant output to serial
> console.
> It is as if platform is simply hard reset. It seems time to reproduce it
> varies
> from system to system and can be dependent on workload and even specific =
CPU
> model.
>=20
> I can reproduce it with kernel 6.9.7 and qemu 9.0 on Ryzen 7950X3D under =
one
> hour by using KVM -> Windows 10/11 with Hyper-V services on or KVM -> Win=
dows
> 10/11 with 3 VBox VMs (also Win11) running. Others people had it repeated=
ly
> reproduced on Ryzen 7700,7600 and 8700GE, including KVM -> KVM -> Linux.[=
1] I
> also have seen Hetzner (company offering Ryzen based dedicated servers)
> customers complaining about similiar random reboots.
>=20
> I tried looking up errata for Ryzen 7000/8000, but could not find one
> published, so I decided to check errata for EPYC 9004 [2], which is also =
Zen4
> arch as Ryzen 7000/8000. It has nesting related bug #1495 (on page 49), w=
hich
> mentions using Virtualized VMLOAD/VMSAVE can result in MCE and/or system
> reset.=20
>=20
> Based on that errata mentioned above, I reconfigured my system with
> kvm_amd.vls=3D0 and for me random reboots with nested virtualization stop=
ped.
> Same was reported by several people from [1].
>=20
> Somebody from AMD must be asked to confirm if it is really Ryzen 7000/8000
> hardware bug, and if there is a better fix than disabling VLS as it has
> performance hit. If disabling it is the only fix, then kvm_amd.vls=3D0 mu=
st be
> default for Ryzen 7000/8000.
>=20
> [1]
>
> https://www.reddit.com/r/Proxmox/comments/1cym3pl/nested_virtualization_c=
rashing_ryzen_7000_series/
> [2]
>
> https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revi=
sion-guides/57095-PUB_1_01.pdf
>=20

Hi!

Can someone from AMD take a look at this bug:

From the bug report it appears that recent Zen4 CPUs have errata in their
virtual VMLOAD/VMSAVE implemenatation,
which causes random host reboots (#MC?) when nesting is used, which is IMHO=
 a
quite serious issue.


Thanks,
Best regards,
       Maxim Levitsky

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

