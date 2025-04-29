Return-Path: <kvm+bounces-44802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2016CAA1095
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6199B3BBDA4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0170F221557;
	Tue, 29 Apr 2025 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VeFKS8B+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C20216386
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745940912; cv=none; b=VLUH6Q+yfW8HNIvrwLGg5nhfVg7RDLrZ6uytF5HBlqkmKeYNpLaRWsqnGK8gfKM4K5hc8uZO8FOLCFqgITX4f1spoFzpd/kFMte7cUbU/gDj/qkwOg7sdxgGgflRrjoiduW0jGziMKwAfRR6tq9qBXzWhAjKbjsX0Gzro/txvNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745940912; c=relaxed/simple;
	bh=Lb3s5tfAwHXIFB0CZmkQBP2iqKnhSlnbe75IvVMYPL4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bVSQggeql65kT3/YI+EAIk58SSlW/hABsNFGBLMI+GH5Va2IWTCYp0fGGOxLC/3LLfQLGVKxOdn3IdLnNrNBKtZZYTMtJSYUXgh/ulJav41mcDjkBt0pxW9SKsPB69dwXIaWBBpn4mkn5EqB5Mz+1BwSQbZUhBEXAur0wfVtm2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VeFKS8B+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6AD4C4CEEF
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745940911;
	bh=Lb3s5tfAwHXIFB0CZmkQBP2iqKnhSlnbe75IvVMYPL4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VeFKS8B+bb4RJC4/kmPvJf3Jlg7QTfUsrb2VNExZcntK0n2l+w9scQvTzTS01ZEAd
	 CGWjNvwiBRjjr7o8bUGFtSCLT9MKMlVnUggboF8YvdGGnxj+HvqwgYMtopgnz1goYv
	 xdvNS4s/FYeT2zCqhQsV8xrFYeL7EkzPlfNnwRHOLTZeDGDh+Gob6QMS705f4b32Ez
	 jEJKVF0/taAc/61sd5Isj/ZFJI8SIiuprakwHt78gLpwPAUXplP6xiN3aZ4y05i0C5
	 e5Vgc/wsS15kgNY6U/LaI//45SCkEWkGX/G/yOc+zGYNTOivQphHk2jeXJNk908M+l
	 IEalHYt1BCcCg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CCCFCC433E1; Tue, 29 Apr 2025 15:35:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 29 Apr 2025 15:35:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: adolfotregosa@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-yRd4OMCACK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #32 from Adolfo (adolfotregosa@gmail.com) ---
I retested using qemu64 and kvm64. The VM will start but does not boot unle=
ss
cpu is set to host, at least using this 5060TI gpu. IIRC the same happened =
with
the 4060TI I had previously.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

