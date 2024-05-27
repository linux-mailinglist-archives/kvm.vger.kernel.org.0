Return-Path: <kvm+bounces-18185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB7118D09D9
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 20:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 377B228408F
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 18:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9684115FA67;
	Mon, 27 May 2024 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUEL7wkc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC5DD518
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 18:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716833976; cv=none; b=D+9GqqD93Un3+Mvo/5bXjNZ4GGSZMiYRAf0F4NZ5NrvIJr2pdJkXDDpopufEBuuMnyQwG/ORd++7oglLZZcMxvnpdtnzI6vxkMGt9HmJ/Py4AFSYxfod4B/QkxDumNr33AX45O9dRto3QPKVDiUMDhL4MkKxwjmWuJEz0jiOIzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716833976; c=relaxed/simple;
	bh=fwZMX5+lXGpu9fHC2sEcIKR+YxwW65HKBh6R+T3aHBs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pc5FtX++F0KYX39At6mm4T5LwKVW7/hlNEJ1onCGo0bl9MeHzPjMDvXZOvObK8KGVXq4Sl5kH0G9ekINpbbHVabZt9xp0ty2Hh/s4UsnA0vOKuof8vW7YgaPaKwc0ThCJWwArw6CewSYpRxSRnDJ/bbiOD5G8pRrLJVMqt3QRBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUEL7wkc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88521C32781
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716833976;
	bh=fwZMX5+lXGpu9fHC2sEcIKR+YxwW65HKBh6R+T3aHBs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CUEL7wkcdeBkfll7JuJXKel/VqujR3qRKB4ub+8x9sSeTEgDb8sNMAOOBxd1k8qrh
	 y3petxFEhET9nvavwaLgoba7OqGyqCZ5wDkZt4ARhrcgperP+KNqrJcAFpO10HQSmG
	 J+x1poejf54berLnNIBiezlnWMbeep4EXGljcszc8zdEP5rpWgBScgFkclZapNO32M
	 a7bfcqgVD8lW2392YvbZfM7Cu28rrP0KP1TdHmc5cPrjQNQyr0gMyg+JsFZteFaiT4
	 0SYmnti4Rma9FfAIzveEmghdKzVRRsvfLbhKRFegdsd1teq0ZCbYzkENnufoLuBRPX
	 YDXXzqtcu9l2Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7D93EC53B73; Mon, 27 May 2024 18:19:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218739] pmu_counters_test kvm-selftest fails with (count !=
 NUM_INSNS_RETIRED)
Date: Mon, 27 May 2024 18:19:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218739-28872-qwpXtkuBFd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218739-28872@https.bugzilla.kernel.org/>
References: <bug-218739-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218739

mlevitsk@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mlevitsk@redhat.com

--- Comment #2 from mlevitsk@redhat.com ---
Adding my .02 cents:

I also see this test fail sometimes (once per hour or so of continuous runn=
ing)
 and in my case it fails because 'count !=3D 0' assert on
INTEL_ARCH_LLC_MISSES_INDEX event and only for this event.

The reason is IMHO, is that it is possible  to have 0 LLC misses if the cac=
he
is large enough and code was run for enough iterations.

I wasn't able to make the test fail for other reasons (I only tested non-ne=
sted
case so far, nested this test also fails sometimes)

Best regards,
        Maxim Levitsky

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

