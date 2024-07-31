Return-Path: <kvm+bounces-22718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91985942447
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 03:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B75228593E
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 01:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A02DF59;
	Wed, 31 Jul 2024 01:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7k3JFGC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE13D53F
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 01:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722390478; cv=none; b=o+2JOP7Zmu2NwT+mhtDNHEGn9vXlAcIwPbmWC8uoN1IN62hKf3G6NY7kGOZieKfSLWCTJXKKKYWReoEwT5K3BLWKP2a68rtgGHAD/SSAWI1C9U8SWGUnKZ3F4UGwBzW4jf5UUiP94JDg2rhH2/vfqv8f9DDcAGq21RJlJmS25iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722390478; c=relaxed/simple;
	bh=kKQOtjoTILbJapNH5Wr0dasGho7damKQlIpxoC0bQiY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M8ihWj0TbQYqOYT7Qj4975ADed+a00TD7pjPHwXRv/dYyfuc3K+8hBB3LyXZJTyS9dxb9x+IAH6/LgAaaVl/UszapEMSE5xka5PSLoTqT9Vyk3OTmqCBsfQ6fMf1ndTHMTgYXAlvoqTiXYPiTW1CIGSyLiUeE4BcxHAgG9v3JYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7k3JFGC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6AEC7C4AF10
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 01:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722390478;
	bh=kKQOtjoTILbJapNH5Wr0dasGho7damKQlIpxoC0bQiY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=N7k3JFGC9WjKNDDvsBhSBoWF98gdr6OL874SWFwyKBW3sZrqJ1sm8jiKh7yfRqVKx
	 GP7qpCuxNpUyYdrRMC/M1BqsdJbVr0VqhBwPIoQcriGnSH61OQEF6vJwTju8BPXsGk
	 7T39zW1D5AYGkZzz+kjtzdDn5Bre7aP7NsdGIuyS8Qli/iROVKgjRMG0xYqxWStjjZ
	 8S3ePIPzi2ohYFtSj7fW20hdi0fZX7ipYR0qikyGESq5GKISp6y2Axk7O0s61f5ESM
	 jAn+ZHCRYtliZHxWQBMn0KSTVfx9WA70G2lXmzzA8LKKj63yBbF9OrgHsc/7bXwZFD
	 moYFNuIG8Hc+g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5966CC53B73; Wed, 31 Jul 2024 01:47:58 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219112] Machine will not wake from suspend if KVM VM is running
Date: Wed, 31 Jul 2024 01:47:58 +0000
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
Message-ID: <bug-219112-28872-seWIDJiINi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219112-28872@https.bugzilla.kernel.org/>
References: <bug-219112-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219112

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Tue, Jul 30, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219112
>=20
>             Bug ID: 219112
>            Summary: Machine will not wake from suspend if KVM VM is
>                     running
>            Product: Virtualization
>            Version: unspecified
>           Hardware: AMD
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: alex.delorenzo@gmail.com
>         Regression: No
>=20
> Steps to reproduce:
>=20
> 1) Start a KVM virtual machine with QEMU. I used Quickemu to build and st=
art
> a
> VM.=20
>=20
> 2) Suspend to RAM
>=20
> 3) Wake from suspend
>=20
> Expected outcome: Machine should resume from suspend when a KVM VM is run=
ning
>=20
> Observed outcome: Machine will not resume from suspend

As in, suspend/resume the host, and the host never resumes?

> I tried this on 6.6.42 LTS, 6.9.x, and 6.10-rc1 through 6.10.2, and ran i=
nto

Have you tried older kernels?  If so, is bisecting possible?  E.g. there wa=
s a
somewhat related rework in 6.1 (IIRC).

> the same problem. Unfortunately, I can't find a kernel version where this
> problem isn't present. Nothing gets printed to the system or kernel logs.
>=20
> This is on an AMD Ryzen 7 5850U laptop.
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

