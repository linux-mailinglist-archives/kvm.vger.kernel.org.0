Return-Path: <kvm+bounces-19182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADC79902018
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B55A0B22BAB
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 11:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3AC78C9D;
	Mon, 10 Jun 2024 11:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qS8wObaz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2738671743
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 11:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718017489; cv=none; b=uvd5q50TAr/i8xvoHNCmNDJkYPMOqAZAisStWTHcwFkreGBKPCwIseZ5VTJUBlBTK2VLRDIF4JrUNNIvnr9cW6b2emJJtPkqUhLLQTeenFfV3L4TUoRyozUAMyatWO2UEvSHXVKh5JPdGe2+rp3uprifui9K13gybDu6hMZ3RAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718017489; c=relaxed/simple;
	bh=s4IzzmJGBfjdpry4x86mygMsk8GH5K7vTEHYSBnn5L0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G1zn2kSf+BGV19d6rj+Xx11quU98qLvfQhlAzlhsxsZv/96CXN3FZenuwXGDdrnR8swNude+5z9+33Pe3LWXUnIQbuwL5PNNgrV5otKa5wcmeQZkYrAwotZuJhUQq5sdhUzuZ3/HQY3PfTjLC4iiAtBTujA1X+TNvKET7pWeR+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qS8wObaz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E976C4AF1C
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 11:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718017488;
	bh=s4IzzmJGBfjdpry4x86mygMsk8GH5K7vTEHYSBnn5L0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qS8wObazKNHQOZMCdadiCQZsXbLMo8JUZ2frfEhSFzYXAmG4q+RzauN1ROYFBrX/h
	 dE6ybTXGWXa6RxAecbVuQXFaoALL9qgPlsanDG0w7sXtfHLkizFoL2ccFvG4W3P1oo
	 tvSzmeFX95uULV5wj/sLboC7oMD99ylQz5N5Q7vI2xLS4bjWX/oQkb2d73yqt81Ijh
	 v+d3tbuhLCNkiYSHKMJdwkV8ZkpqI1v+nzaGJlRLmRMJ904tBts65MUGRbTe08COp/
	 PQoVE2kSnBUhn4gT5iRWa+Wz2mfmQDEzeipLEAUroZ8/mMWOwmhfZ80DVh1aXwJXWl
	 uRirFLwCZXaWw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 961DAC53BB8; Mon, 10 Jun 2024 11:04:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218949] Kernel panic after upgrading to 6.10-rc2
Date: Mon, 10 Jun 2024 11:04:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: badouri.g@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_regression
Message-ID: <bug-218949-28872-F0fIPvvEXA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218949-28872@https.bugzilla.kernel.org/>
References: <bug-218949-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218949

Gino Badouri (badouri.g@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|Yes                         |No

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

