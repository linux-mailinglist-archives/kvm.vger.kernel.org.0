Return-Path: <kvm+bounces-23442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 151EC9499EC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 469E21C22131
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 21:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F42156F57;
	Tue,  6 Aug 2024 21:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RISqjWeo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777246FC3
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 21:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722979006; cv=none; b=rPNBVGusLH5ufh0Ui4cIPkp1es/FInC+YVfGv1/AvfayJNK/v4K6p9DV6JAY2oOL4/slaVeE4T+7pgxTXP8dJg3JV0KGwqZGByONWAYYkP4qI4Vq+enp80k8gvRZHHvjteVzrs/awJYXRommxWc+UyyxzrqMp7oSQVTT6V/3zOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722979006; c=relaxed/simple;
	bh=BtK/XUR40r61Z1lsEVnoZZDpCAL6IxnCThj0m18Tosc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q5D/hF4r8/7TzF848QkdVEvwk0cHNbj5DsjVaoW4CTxub7TERNTz/dwbjac0CSTWBcgMjlDzzaYAYfl1FQc0808f6ES1rWEP3DY1MTraT1UJwrcKMJTkwES1Znx7HOEY3pwndYybYbz+ZqRXhxeTh3JYcGJgiSf6MeCnzHu1viI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RISqjWeo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12443C4AF10
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 21:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722979006;
	bh=BtK/XUR40r61Z1lsEVnoZZDpCAL6IxnCThj0m18Tosc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RISqjWeoBS5hkIgSlyBw2rXmKNVPF65pflZp4N27eHSls6UgmTdR0AM99LWGPKOaU
	 BtOZffNw6aznCoEUz3Thw0y64idEPwwKiykVv6fv12JUn+ee+F2ch1FP5NQsCxpZoI
	 eC1rrGN61grI20+fai5+BuRtMXNF6cWU3nPlhjVsEOCwiHjSLwF7ehomDLDHBroOTe
	 2hNkHNRGpnzvahx1+W87stfEHBzA8rMru6FJOB+x/W2ioZ5un8VaT6nRicBGjmBciH
	 /OW2qflg2LqTUHcJYekwCTIqxdSsY7/AlSjNFtzQ0ppOy62nVLMVk9P25ZRIfLyaHh
	 TRoV6QDvL4CsA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0014DC53B50; Tue,  6 Aug 2024 21:16:45 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Tue, 06 Aug 2024 21:16:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jftucker@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219129-28872-CZuun1oaxK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219129-28872@https.bugzilla.kernel.org/>
References: <bug-219129-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219129

James Tucker (jftucker@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jftucker@gmail.com

--- Comment #1 from James Tucker (jftucker@gmail.com) ---
Likely caused by e269d79c7d35aa3808b1f3c1737d63dab504ddc8, fixed by
89add40066f9ed9abe5f7f886fe5789ff7e0c50e

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

