Return-Path: <kvm+bounces-24123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B33951898
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24D43B227EA
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12EA1AD9DC;
	Wed, 14 Aug 2024 10:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NX2UqjNj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1482614264C
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723631075; cv=none; b=N00Fu7JjZ8oKpBIL+0D16tUG1SgHHuol6G0Wua4fwZ1WmpU0U7d4zMGsekllqYKUopXJxuok6GsoAGKkqKDGpr/psxjcFMBKhceyuFk+2jFfyjSKr8hsEZRIGTbJVE3ewd9Ljgo0MRP4YNh7cRzlMtCjk+l+jxJN3r2yiEKcqlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723631075; c=relaxed/simple;
	bh=Cg0PYnrDfaqiYyswQFr1/uiSUatMMxgo1NOWZ7hrvY0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ELHQAnI+Cy7Jz2Gq0tcYaFSu61WgBihJYkDv3s3oFG9WJ+2UY5rZrOFrBJeKmMJC7gURW484O08My/0HevHV8gwbKXPuNfMnUdVICBqPgASzaZ2LIzSnxWPGuPnHD+A43Rl+IcBSHlUkzVerLEtnJJ2ZpBljr/90N5hbI/mXzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NX2UqjNj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EC51C4AF15
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723631074;
	bh=Cg0PYnrDfaqiYyswQFr1/uiSUatMMxgo1NOWZ7hrvY0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NX2UqjNjUyw6+YfK8vh6AMIJRpG+S/VJwEsB1yqPFRTuHNQD+xHs4bXwJ2VWr+8hd
	 OE0pg9j1cWEszPhd15ps1a39DgPAY3bTL3xYC8jFB+s/lnUwVER6IFbSbuF6o6jEeV
	 G6MqQ8+fG2YaOZAYCOfObL13EcRo50ZWSx7jad7qMhXcWc7wfAMjjmh8Uj91xHx1UB
	 9MsX/sSzOH3zxTMtIVjllChwkBQ/b65avvdjd561VRBFOpY1DeitvX0EMtC/Zlx47E
	 TyXg2//n19LDn86Ea0RJiqPU+JWZVglRxUR9SSHySoX6gTSYbVEqaA6MCL5kObec8g
	 8XGcsekxIlnjA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 99031C53BB7; Wed, 14 Aug 2024 10:24:34 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Wed, 14 Aug 2024 10:24:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: christian@heusel.eu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219129-28872-6b8KH5O0Uz@https.bugzilla.kernel.org/>
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

--- Comment #7 from Christian Heusel (christian@heusel.eu) ---
The patch made it to the 6.10 and 6.6 stable queues :)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

