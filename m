Return-Path: <kvm+bounces-28145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8609955E8
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 19:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 769F21C2505D
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 17:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19C520ADC6;
	Tue,  8 Oct 2024 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eO6+1Ugz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD15B33986
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 17:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728409406; cv=none; b=iYbtxrQkqnkRTEkNb06qhZdWoSV8pCRLRoqxan+r+8Xic47AJxxnIou0ufGI0ZPIKj0F6KfOtOb2+uAsODN4NSaLlj1JMmMT9j2uLu3tJTuD2lF2HdR/oikjgor16lUBjagBRRXFYJnAgCqKF+/t1pdGBP4LG6LB7uM/C1MG76g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728409406; c=relaxed/simple;
	bh=gD4IV0WFh7+duOYa96fR9zauhsOrR4tkGS95Bis7DtQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sn3TCxIpGccr4nYAS69mxwzdzNFWJP8o/KyU2DMwGuFZgEfyQQWX7ZcyARW15cWwwMrnWJCUhFCps513kNXRFgn9Jq8ASqFDygnEKYgupls/fRLrxu4+BElMAFaNhLs11t9N+oxbZGkrKGNLRIQ6Jkiq4F6TzpdU8GhbokLY8fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eO6+1Ugz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 691EBC4CED4
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728409406;
	bh=gD4IV0WFh7+duOYa96fR9zauhsOrR4tkGS95Bis7DtQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eO6+1Ugz4S35J21fUlnT27aaYxJ09oNo3fm2ksUMb//S+wi2kKGyiZTKcA6guMPSd
	 PxBfHj6UYmSIxYU1+rhFCwUsZvpJQUQJhxIgSuUseFWJLEv3Z5zsTGxvw9xmM7wQtY
	 gvi8G2z2kcZtF6Bj3QsSt586H9xUgnrQFM7RQjsZiVu1DniXjMwbKI0C6BeVR3BiyI
	 V8tUdVOhBQpGypYBs4aymkpI8JQpCD8VY/HahY89sF//LwFCkeQTNoMB2zJo45YibF
	 bCyGFhZtdrQtnEiA5FbN0wX4IysbYe+amPvRbRd3OwH4BqyRmYb+DqXUClDoIoug5k
	 y8OmoPGmSuO9w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 61BE9C53BCA; Tue,  8 Oct 2024 17:43:26 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 08 Oct 2024 17:43:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-WcUwWEr7NM@https.bugzilla.kernel.org/>
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

--- Comment #26 from mlevitsk@redhat.com ---
But the question is - did they use nested virtualization on Linux actively =
and
with vls enabled?


The use case which causes the reboots as I understand is Hyperv enabled
Windows, in which case pretty much the whole Windows is running as a nested=
 VM,
nested to the Hyperv hypervisor.

Once I get my hands on a client Zen4 machine (I only have Zen2 at home), I =
will
also try to reproduce this but not promises when this will happen.=20

Meanwhile I really hope that someone from AMD can take a look a this, and
either confirm that this is or will be fixed with a microcode patch or conf=
irm
that we have to disable vls on the affected CPUs.

Best regards,
       Maxim Levitsky

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

