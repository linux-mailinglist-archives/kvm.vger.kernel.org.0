Return-Path: <kvm+bounces-32210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D46F69D4298
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 20:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AC2828470C
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C3216DED2;
	Wed, 20 Nov 2024 19:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7SEh9tp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDD22F2A
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 19:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732131374; cv=none; b=WMIism3Hdj/XJUikGygVKOW38MP+yrJKfFA1lxI484jCZ1+x2h/t4qR5jRNb1lEVpNbx36zobFQUWoZibwBtkzCF6EjLbbRKmB4UXNYjgQHKUUynzNlEJA35g1357hwM0bHE0LGwJk/Nnq4v57/bQp3hPQ4UrvGG6lCFWK3yweg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732131374; c=relaxed/simple;
	bh=eJ4PEZn+k1IylB2rvWus1XLzJo9bCMGx0v3bCZO7Xb8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PDeQcp6+82sTpknRkGNLPPcwyVbZk/NbARufKN0rC2qQ2guOiCx0TIpzD26AHKa/bYP7GnV5KKLv0o0p9T2m3uFydaCz0wTseEDCc8trh9dwum0Sqy27zTa26D6SUbxq6T1ICz8swpWxx8nW0+K/ofEesU/y8mbwdIjW49Gn0Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7SEh9tp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E215C4CEDC
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 19:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732131374;
	bh=eJ4PEZn+k1IylB2rvWus1XLzJo9bCMGx0v3bCZO7Xb8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=f7SEh9tpC/9jEGs3eHRX+Jl8h+YsHA5eUjRoFwXaTMVOx8WWZK7gidv20FXggU85E
	 /pilOF+2eawu472alnEeEV/TyKr9cxK63eBR/EKuJzyeHc5XU8rBsmmMfF0M+RLrR8
	 +yQ3EFndFO7HZ1ffqnz3f5hmDM5i9Ix/GV01igxDqrp8t2oP7vXMaEvdz/RnAzMzvn
	 fvPt4I4xZrkW5w1AzICrAqFnttn4BNgDRgUhCpdlf1RzW2a5Ku32IuimPMRSdFELl5
	 m4yljTEg4e3hYsWLgjZPhLbscEW/hz/GN+Ujoy5/z58gkC4QIs7hnEHotPUPLMotlm
	 mEdAH+1sZ4nvw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 09078C53BC2; Wed, 20 Nov 2024 19:36:14 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 20 Nov 2024 19:36:13 +0000
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
Message-ID: <bug-219009-28872-iU5eihKu0J@https.bugzilla.kernel.org/>
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

--- Comment #41 from Ben Hirlston (ozonehelix@gmail.com) ---
I am testing Linux Zen 6.12 with the vls flag disabled and so far I haven't
encountered a crash with WSL2 and Windows 7 in virtualbox in my Windows VM
KVM/QEMU VM so I guess we will see if that changes with time

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

