Return-Path: <kvm+bounces-19235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5726E902463
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:45:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 559551C21145
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 14:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3834F132137;
	Mon, 10 Jun 2024 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bMyHcG/1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632BC38FA8
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718030732; cv=none; b=DEW5YnvhEhJXRAKoqXCScSNCiy+ebvMmIu58aSlpFHREZq+2y8nJGZgDZWPCUxfNWjB9GrL2idUuy0xNtsw+zfFNSHvIAzqCBFAeVRZR7Gb9Lh9PJRXmCAwsAiUi9/X8FQxPL39HHbsGAxx7lQ8E7WmqeDpZd5mfErAQjsOXPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718030732; c=relaxed/simple;
	bh=9erE22Pr39gRvA4xd+DfcL2S4PQs9Vf/WyZAuVDjKcc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bFi4ff0VcJ87HEZRBqT+eVEH0GGlNmZwvMbhNmMIpLQM2Qfdzk3FJyx5tJOUQXv/eKT6yPPif6MPdbkQtokr8mMIH3Me6b4tAGySXuGTZMJY+lqImLRuxPu7niFunA4eh9YjVM/WPOmJeN3VtFnHKeUf4qkJVk/TyBbgbD/52io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bMyHcG/1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAD2FC4AF4D
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718030732;
	bh=9erE22Pr39gRvA4xd+DfcL2S4PQs9Vf/WyZAuVDjKcc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bMyHcG/13nV3RZFcG6Lq+Ddrd1oBZRUiE08E6B709oVezvqQ2HUnX2ZCHejSnkHQD
	 sXxSalcXi1mDuaOIbHHbv3PQ2BO6VfPBcMKaOJJBH7ZqoHMrhrYuMG2JWe8s/GHnYF
	 4n08/zWXoTbaGYz3+TJhndq/160+oYIuChWXx0jG2o10I7y7Gx13w+ndssxieQg2Lm
	 mYTPIDjEpsT63ximCl6Z1wzYuIFZdXwmVmtASHN+g91aJmZqok6wk8InwWi3iOW3Pd
	 IivG9zBDjiduukh7du0+5rzzOIDVVGm6lA/xSugXtCifUU7K7YU0U/osgSKZdVm54s
	 vxSsXKfwvzePg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DC5E3C53BB9; Mon, 10 Jun 2024 14:45:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
Date: Mon, 10 Jun 2024 14:45:31 +0000
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
Message-ID: <bug-218949-28872-WSKpwN5473@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218949-28872@https.bugzilla.kernel.org/>
References: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
On Mon, Jun 10, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218949
>=20
> --- Comment #2 from Gino Badouri (badouri.g@gmail.com) ---
> Alright, it's not a regression in the kernel but caused by a bios update =
(I
> guess).
> I get the same on my previous kernel 6.9.0-rc1.

The WARNs are not remotely the same.  The below issue in svm_vcpu_enter_exi=
t()
was resolved in v6.9 final[1].

The lockdep warnings in track_pfn_remap() and remap_pfn_range_notrack() is a
known issue in vfio_pci_mmap_fault(), with an in-progress fix[2] that is
destined
for 6.10.

[1]
https://lore.kernel.org/all/1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.=
hr
[2]
https://lore.kernel.org/all/20240530045236.1005864-1-alex.williamson@redhat=
.com

> Both my 6.9.0-rc1 6.10.0-rc2 kernels are vanilla builds from kernel.org
> (unpatched).
>=20
> After updating the bios/firmware of my mainboard Asus ROG Zenith II Extre=
me
> from 1802 to 2102, it always seems to spawn the error:
>=20
> [ 1150.380137] ------------[ cut here ]------------
> [ 1150.380141] Unpatched return thunk in use. This should not happen!
> [ 1150.380144] WARNING: CPU: 3 PID: 4849 at arch/x86/kernel/cpu/bugs.c:29=
35
> __warn_thunk+0x40/0x50

...

> [ 1150.380266] CPU: 3 PID: 4849 Comm: CPU 0/KVM Not tainted 6.9.0-rc1 #1
> [ 1150.380269] Hardware name: ASUS System Product Name/ROG ZENITH II EXTR=
EME,
> BIOS 2102 02/16/2024
> [ 1150.380271] RIP: 0010:__warn_thunk+0x40/0x50

...

> [ 1150.380298] Call Trace:
> [ 1150.380300]  <TASK>
> [ 1150.380344]  warn_thunk_thunk+0x16/0x30
> [ 1150.380351]  svm_vcpu_enter_exit+0x71/0xc0 [kvm_amd]
> [ 1150.380364]  svm_vcpu_run+0x1e7/0x850 [kvm_amd]
> [ 1150.380377]  kvm_arch_vcpu_ioctl_run+0xca3/0x16d0 [kvm]
> [ 1150.380458]  kvm_vcpu_ioctl+0x295/0x800 [kvm]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

