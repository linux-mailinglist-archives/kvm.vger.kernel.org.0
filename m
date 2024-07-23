Return-Path: <kvm+bounces-22128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E0193A79C
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 21:13:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC81DB220ED
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 19:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0E41411E7;
	Tue, 23 Jul 2024 19:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D0alnu6n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1D813DB9F
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 19:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721761991; cv=none; b=KPQCCQTFfOvbkOO0QbRAFA5E0Rt4ts8RCAAcdZfvEGXrSVWeABH2K+JG2HfoJrZ9EN3/wL+fRtoL/bVk8NXGWdSU2r6ceZYjFy3mVyxw0XVQa65PJXMCM2jRqtbxvUF6teTTRuaebplm49mitG+DJ4zHwzFxIugl3YFfHALc/6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721761991; c=relaxed/simple;
	bh=iJWLL6DVW3CQyvQHjHvBfJgxoh75Sqfv/iguqPRJuWw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=byb1a2no/ksDZWpFpEc8OL/mwuHW4373dr/MBQvjPCj3MDA6ZF1VAi0/0t9+hPtG0FA1qegjhPYgjLCggEnwfiGf0GLFrMZFvVrQDNLjUrJFg/3PlrUTJhEyLaK7Nqr2zXl4d/ZXiGssd8uD1UJ+uDv8p4t6Igj8lRbvDIYNP1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D0alnu6n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C480C4AF0B
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 19:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721761989;
	bh=iJWLL6DVW3CQyvQHjHvBfJgxoh75Sqfv/iguqPRJuWw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=D0alnu6nsG7JjhJ58LXXC15/AMBs7p3Hw3BJ68PcNdxSRv8DezVP9SvxDHLOF/9a6
	 0UIIY2SmwzEo60FwZQiRwf30qbpoKb3NTxdskg5KW0w5Ov69Wl+hUqN1w0Zosx7MkC
	 mGWJZy3jRS+QnfsZeK617nCM6LxngMI1OOF47AXTC5bq2HYI4wJ8/Gg2yQRIQG9yb6
	 XCtufPFISmwGrke4bL1wiN6kwSISLejq5GjOyh+Xt2WEghUJ2wYBP6HtRfhkr1rLt5
	 RgGfxHLuD5pBE0cye3kkUnLuOZsZXB+4g5e4Fiutfw2DzPZ5i7Lubwwwqhrd5JARZ0
	 Z0xrxC7irqe4w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7B409C53BB9; Tue, 23 Jul 2024 19:13:09 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
Date: Tue, 23 Jul 2024 19:13:09 +0000
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
Message-ID: <bug-219085-28872-pkXKCfLeZV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219085-28872@https.bugzilla.kernel.org/>
References: <bug-219085-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219085

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
On Tue, Jul 23, 2024, bugzilla-daemon@kernel.org wrote:
> I also saw a claim from Peter Maydell, qemu developer, who had said this
> about
> qemu command line parameter `-cpu _processor_type_`:
> > using a specific cpu type will only work with KVM if the host CPU reall=
y is
> > that exact CPU type, otherwise, use "-cpu host" or "-cpu max".

This generally isn't true.  KVM is very capable of running older vCPU model=
s on
newer hardware.  What won't work (at least, not well) is cross-vendor
virtualization,
i.e. advertising AMD on Intel and vice versa, but that's not what you're do=
ing.

> > This is a restriction in the kernel's KVM handling, and not something t=
hat
> > can be worked around in the QEMU side.
> Per https://gitlab.com/qemu-project/qemu/-/issues/239
>=20
> I was somewhat confused by this claim because=20
> > --- Comment #1 from ununpta@mailto.plus ---
> > Command I used on L0 AMD Ryzen:
> > qemu-system-x86_64.exe -m 4096 -machine q35 -accel whpx -smp 1 -cpu
> > Opteron_G5
>=20
> Let me ask you a few questions.
> Q1: Can one use an older cpu (but still supporting SVM), not the actual b=
are
> one in qemu command line for nested virtualization or KVM will crash due =
to
> restriction in the kernel's KVM handling?

Yes.  There might be caveats, but AFAIK, QEMU's predefined vCPU models shou=
ld
always work.  If it doesn't work, and you have decent evidence that it's a =
KVM
problem, definitely feel free to file a KVM bug.

> Q2: Is there a command in bare Kernel/KVM console to figure out if EFER.S=
VME
> register/bit is writeable? If not,

grep -q svm /proc/cpuinfo

SVM can be disabled by firmware via MSR_VM_CR (0xc0010114) even if SVM is
reported
in raw CPUID, but the kernel accounts for that and clears the "svm" flag fr=
om
the
CPU data that's reported in /proc/cpuinfo.

> Q3: Can you recommend any package to figure out it?

Sorry, I don't follow this question.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

