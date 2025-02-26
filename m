Return-Path: <kvm+bounces-39206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E25A45200
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40C551891700
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87552154BFE;
	Wed, 26 Feb 2025 01:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1wL2Mi6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF188154423
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 01:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740532217; cv=none; b=rBm/y7Af4cH7S+yWGaM/6gGwkOkcZIb7+KHEAO3sT03t2AZ0OT3UQC38W/y9oftqwAxFVNA3E2FwJPl8EM4St8eTzMza2WK+LO9Bi1joAzj+NL7gK2a696rBn1kqitcYNShLKQN5jMkhwaKlPgJFaV8WUrrkDYyodkccLMkvmP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740532217; c=relaxed/simple;
	bh=OSW57oXt67Ed2fdNFMSPzadT3QYEoWc8H26kSeVfvuA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G8Edyz9fqIglFAzE6aTiTPUanHR3EgFMVAEQ+OUZOapNYuWrrjw60/ygk5etyd2SR8csY8OCQRatMJp+9izuW9BTRfeXU9Sng2M65Ds29+FQW8hZ84s5XoKAcVxmMlytoMotq9/4xjNvCkkgoSBW0QXZtAseeknzRteUptsW+l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V1wL2Mi6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F099AC4CEE6
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 01:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740532216;
	bh=OSW57oXt67Ed2fdNFMSPzadT3QYEoWc8H26kSeVfvuA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=V1wL2Mi6vmyzmkLhXvshvlFVs85sncjLqsX9ySRXti6F/sA3OHWzulHKH5aqfMMzz
	 KaenqgtgH+LzbJbakU52qvyhiYogIvIsha9I3sti2gZ716dOujTGg2hMDejG0t+1BQ
	 2ANyBpIxSRPPdMQHUna1jArz0kTQuGE73HzpIBN1Aleq2A9bjAVfaD0s+Pv3JcNmun
	 mpps35oUyfoKc7lyDQIhE4bvIc3BUDzLrpEye8OQvCPI3D3jQ8fw7tLK2Z/ow5XqiT
	 Kd/yEGLiAIBjp+yEuMP7afz7+KxQvRLcQQyVZdKfZqME5vMpfvmuESAye0wGAz8SKV
	 GkGYUkTTLzQJg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E774DC41616; Wed, 26 Feb 2025 01:10:15 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 26 Feb 2025 01:10:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-rKnGFi9EYB@https.bugzilla.kernel.org/>
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

--- Comment #48 from Ben Hirlston (ozonehelix@gmail.com) ---
I haven't had issues with this since 6.11 6.12 fixed this for me. for conte=
xt I
have an Ryzen 9 7900X3D

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

