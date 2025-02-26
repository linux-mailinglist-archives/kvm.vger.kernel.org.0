Return-Path: <kvm+bounces-39205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AAC2A451FD
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:10:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72C223B1B6D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CED317BB35;
	Wed, 26 Feb 2025 01:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afx6PMEI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7F81624E0
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 01:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740532085; cv=none; b=C72BLwEj3YKAa2wx3FsjkNHCbcswB3/sojceLAZzz/oj5bjSwjZJBnojbb/7C45XqSGOxkPael5bLNXUpcPEa8rZClsFcZGYnCng79lPyIa7Gq32mucuNhWCVzQUrf5To0raaNd5I0BEqxX+0JPCFEom4Ph6ljFz/XAKn2pzG/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740532085; c=relaxed/simple;
	bh=1tU24aHnzhEk3F2R1F4w4+meDAVsZIVgLWFhCjD1X6I=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L76rVLB8kEzQOL39gWanrDs8BL7RwIS1m6Af0bJIctxvcqSmwSXrnRzQWK6UAdSp8qV+5gg3kYj+rx4TKl+vySo0vKzZwMP9KHsxOwRWMsqcZS+gDefhbrAE4whLatZELbTvcFOFgtp3gB57a2wyWk2/EDqorXCympxuH4/voZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afx6PMEI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D196C4CEF2
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 01:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740532085;
	bh=1tU24aHnzhEk3F2R1F4w4+meDAVsZIVgLWFhCjD1X6I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=afx6PMEIlZ0IB8zm0krYQlMkEFc7PbWNbB3wefM5SPe69xMqIYokfTDhjXA5MfRgU
	 CuhBYogjhLEICqo5wYRH/eTOa3Q6oexpsVtgBoZ0Qr6px3Dv5TT7M37w6fdlLxBNYt
	 hyXq8rX9WK+c+wNQEiTNQ0ivLqWXDSr7qoD9yu4x59Nm7spAlG8kvzKIfPLRv8rO6y
	 hhm+xLdMJH4/GNP1jIO4HBBqAmDFzRNaD2JGdpBU7DUy8h0Vbo0JCdNcosLtHOATuf
	 e5UZkV9ysHx7TYX/EF6i4nh7gQRA5QsneTjSSBfQJkoxhUD8DuLO5AoZuSZIpKrDH4
	 y++Vnhy+EQr3Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 05805C41615; Wed, 26 Feb 2025 01:08:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 26 Feb 2025 01:08:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: chaefeli@angband.ch
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-OLFmrq7XB8@https.bugzilla.kernel.org/>
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

--- Comment #47 from Christian Haefeli (chaefeli@angband.ch) ---
(In reply to Mario Limonciello (AMD) from comment #46)
> > I would prefer the more flexible solution via kvm_amd module parameter.
> > I am not having this issue
>=20
> The failure rate is low, but it's statistically significant.
> Feel free to revert it on your local kernel tree if you're not hitting the
> issue.

I do not have the time to tend to a local kernel tree... IMHO an extreme
measure
in relation to a low failure rate. It looks like an after sales castration =
to
me.=20
>=20
> > due to this hard coded workaround.
>=20
> FWIW If you have a fixed BIOS, you will have the same result.

So you are saying that from a specific AGESA version onward, these instruct=
ions
are being hidden from the OS? If yes, is this the same case for Zen5 based
Client SoC SKUs?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

