Return-Path: <kvm+bounces-27831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F17C98E64C
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 00:52:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F955B218A3
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 22:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F8B19C56B;
	Wed,  2 Oct 2024 22:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ffdq7bJO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6201119AD5C
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 22:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909535; cv=none; b=XbGHfXPdS3T3rXfS7ZX/1tEHX9fGvSREhOMwQSLIhl2Hr7j4NATm0qCEHixnLrSkNqCHYFTbFmTLHpLmABDQxGihh90Ow47Di4fH4xfJjMQNFb3vBY2fWrz59qUhAFt193hcXqJyA0UVvb/Lc/Hqe+Mx81ZPYOYGAhd+s9QYUuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909535; c=relaxed/simple;
	bh=f2db1FrvTB7FC/F3d8PR7JuA7Gj3LwjV+GEZe0juu94=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e8pHBaEMGXK+6OyoSlfJV56UZ0Q6vs42jwYyT4eSvAwRzHB+AsM1y7OHBuDv9Aie9lBN5sWum32N7uFyIKaCzreXKl7y6v5rdNkVQMmWQGAmGfHv8c3uVP+/0OtylihfgZYod6xEAdORBwigpz0HIuIUW+bc+R2PMUAy7SCpe8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ffdq7bJO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6E21C4CEC5
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 22:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727909534;
	bh=f2db1FrvTB7FC/F3d8PR7JuA7Gj3LwjV+GEZe0juu94=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ffdq7bJOTphUBqLpK/Hnh+irR09uHkFXRVpdijitiRipipDNsO9MFcVkkbB+/6P3l
	 QFPQDhvswIjWKRcfr8YgGZoirX7Z/9eaHTZr62cGRM1Y5E7CLyh3U1fKBikaqTUEsi
	 xs2PUSDr9GCldQxIa/gknCXTDiXoe7ghJVHO4/EY/luFe0TjlIgO8rFm2pbX9+iPwg
	 E31sREe2zdf2yBxpLidAsxVpv4gviiEgCHPU4TMRFsJ9iCtJ+RNUaXtTSbgkD6S8fq
	 WCjIpOMPKiKElpEzAUWVXE6EU5kD/G7+QIAMzU+dy8ZJu0u1hHdL0T1UzrXRT9Xlbb
	 ekut+jq0PLkmw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D676CC53BBF; Wed,  2 Oct 2024 22:52:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 02 Oct 2024 22:52:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-rgkGv8l3sE@https.bugzilla.kernel.org/>
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

--- Comment #18 from Ben Hirlston (ozonehelix@gmail.com) ---
I was wondering if this issue might be related to this thread on gentoo's b=
ug
tracker?
https://bugs.gentoo.org/808990

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

