Return-Path: <kvm+bounces-38890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E87DA3FFF8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 20:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42055700528
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 19:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1592A253338;
	Fri, 21 Feb 2025 19:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooj46zrb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AFF1FECCB
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 19:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740167107; cv=none; b=guudARwA0DMh+fuxGbEEQmoDG2DysHHKtbXts9NyJvVzlQgc4g493/bm/XVG8gEx5keKpR9W9+XwtqSr2+p8mcpZlf9o5+azn+W7Bbwrf0xbhSVw4BfNJlXh/c1/kzkRuJsg6/uw/f+UPM3++7vvinfLv1X7sGzgehGm6jWnNfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740167107; c=relaxed/simple;
	bh=VmdRC2D6XUpZaRnKCy6uF+ObaD0lHPNgwaz23qRGypQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g+AebiD+oNUHUATBhCU6Vy/Rohlt/nFC4r37nIOCwP8ZIlNF8Mq3rxFZnDlae6BhgKu2P901qkXG17tsI4AR94ruzJeOPMjIU6ExA0finHf2zGizuLx3h8r2DoSeeO9BO4/rzpxAgM4sTJWEHFN4sFF41bvawpsigEW25GO1lco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooj46zrb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92B8FC4CEEE
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 19:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740167106;
	bh=VmdRC2D6XUpZaRnKCy6uF+ObaD0lHPNgwaz23qRGypQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ooj46zrbyEPKNWYw41RkZOf11nOmJFN0C32gprmpKvI5gRDk8BRQNSIm3pI/Wsx9p
	 XHM58cZqM0V22v3SE0ZBq21aYkK/EoP7uFM6LBMhh4KnIu1g9bygKP5Y7st+LU4E+6
	 v69sxzbdpjP0gfCgeJhuC2YzHPuBQVAttMICRsy5meNeOwOEl2o+d2nA2QhF9x8c4i
	 fr4rAfeU8NNjS7DxE25PTjDk4z5Y04GE+iGsZbD1pjvzg3qXOpvM6dl5hNyEUA0XCH
	 rf/Z2Ey/6zYyIiPg44c4zlQiDNYf63G+eNa6VJOtyUNtRBvkBteF45ZsWTdgVR959D
	 o2uzo5DD+awFw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8D50AC41606; Fri, 21 Feb 2025 19:45:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Fri, 21 Feb 2025 19:45:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mario.limonciello@amd.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-SkwpmLQars@https.bugzilla.kernel.org/>
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

--- Comment #46 from Mario Limonciello (AMD) (mario.limonciello@amd.com) ---
> I would prefer the more flexible solution via kvm_amd module parameter.
> I am not having this issue

The failure rate is low, but it's statistically significant.
Feel free to revert it on your local kernel tree if you're not hitting the
issue.

> due to this hard coded workaround.

FWIW If you have a fixed BIOS, you will have the same result.

> Does my CPU also qualify as a 'Zen4 Client SoC?=20

Yes it also affects any CPUs leveraged from client CPUs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

