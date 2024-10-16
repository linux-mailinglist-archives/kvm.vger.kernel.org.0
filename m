Return-Path: <kvm+bounces-29024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF80C9A1131
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B69A1F262CA
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:04:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BD0212F1B;
	Wed, 16 Oct 2024 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxXzx7Sa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811E618BC0E
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 18:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101888; cv=none; b=H+HPm8HFj3nD42HLNhYyP/L68Aw0JIYtNGHu4WN/uMgT4S83oZ/kmID72+IBR793LwVD0z9MULQitsvgnV8Ro6V7nPevGuksWji8PlKOBCBoQZu/t5cxOqfxzu3Jm8yTJNmBzW/y8g86J2irRUgJHwHGIJ1YZ7fQWauC0yJa1Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101888; c=relaxed/simple;
	bh=mdRPeuNKKtL92ffeohi1I8Jh+NKHGDAGvfLnYJLNL+c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ME5DWYlmhFka2mrueA0wtcRdu+rKifQ/wfWaE0XUD7z7RrbcwdS4GZ8cEwVitlkbiPp3k+AFQ4SrFjeemfbTIICLajkY38h3Gn97iOsHUIi35HV8Si2Z11MjlU3q8lI5XrF+cItyKVB/dB346IG1YvWsq8zzPXMLzeyvn9XBZgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gxXzx7Sa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22489C4CED6
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729101888;
	bh=mdRPeuNKKtL92ffeohi1I8Jh+NKHGDAGvfLnYJLNL+c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gxXzx7SaY1y9dWnGHSByoYif1+JvUVp7lZYXQNy1UBhm65c3U0eDr38ggBHZhLHW5
	 BLWvZTzo4GKxjgakwyJhtxUCx0WQQrDtqEpi+V+m/xmVrUb4fXLZKY5Y4wIQpEeDfb
	 5h8T2ntNgC8bA9m7+RjPiHHU0/zxkGGgezDJ33l4W/qaK3reqMYFhCpBfGLj2OiCKZ
	 1ov3WoTjIHl3l8GIbRKzOsPZr9eeTW6+owVnLRwhOFwJ2mijjyLVpbcwyAw9l6H5JG
	 PM+lSz3gngJozNTEqsnjVePuG/AUd+mxUFQs7rCxMlAOCuMjDocKf7OGT6nvpaj64p
	 XKIr/uvbWRh5Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1CF34C53BCE; Wed, 16 Oct 2024 18:04:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 16 Oct 2024 18:04:47 +0000
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
Message-ID: <bug-219009-28872-a8cuN1iAsy@https.bugzilla.kernel.org/>
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

--- Comment #33 from Ben Hirlston (ozonehelix@gmail.com) ---
I wanna say it doesn't if I ever got it to launch it was probably defaultin=
g to
WSL1 as a fallback

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

