Return-Path: <kvm+bounces-38320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08FE7A373BA
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 11:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F8743B0341
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 10:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156CE18C93C;
	Sun, 16 Feb 2025 10:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ERhy4xua"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7478F35
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 10:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739700118; cv=none; b=LpSqW8sVKuXbE2JsFDpD7iDYxreMmjZh2ISt0ycvawJjOvn884cwlFGnrY06dsMM81a6qBagkVhR+CaQzXymkMqE/TQf7+VKeuofHS0JAQanxzO39YkZbQNUz+GNHKpEu2Ptw559nZB/KOPf/rsJLELXFzfApLfH0Uw7/mrtHuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739700118; c=relaxed/simple;
	bh=9i0otJ9KfxRNKqW2iO2hzewDxkC1q0qAc12CeMksqPs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AoaWKYiqIXv79BhnoJFWEKVKaIwHmxLS/vo/nwVhfLTfAJCX3yjwt4tLrnOF7SwqgG5IEFxsG0WRJw3XeM48+8ZvIBkfMRelVS0VojwfuHC2LZbjBApGfeNGP1LyThi3cgcJr1gcS85lJFDVL8q9wXBzlus4m0/JMoBUrAhQlvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ERhy4xua; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB4A2C4CEE9
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 10:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739700116;
	bh=9i0otJ9KfxRNKqW2iO2hzewDxkC1q0qAc12CeMksqPs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ERhy4xua8G0DgXsgpDb8drqV/fIRibluplEyvbT/19bJL5HD3T6UxCwH6ie/49Owa
	 CCatc0TBhPuR57d4+UzaAS62rYp7RGaG1hENqV2jCcWl1npRLttPS13cDN0rB5vYca
	 7ibq026kNwj+EhbWbTG2BYFyt3y9mjSSDBsd4reoDDoZjkmBMuRzaA6pxUyHEVuSpR
	 gUagYCxLB8RdJB3Ietr9TIOrh/PGyzbJG35UuiQcXmdcgaEDur5y5zQGQb3rOneJki
	 pPJNrqF/YYW8a91B35xprYFicmyjvwY5X+utltIRi9waEXW3Ykz96PxGL1QB1bL62q
	 0AwQDxnJWKfZw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 97C91C41606; Sun, 16 Feb 2025 10:01:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Sun, 16 Feb 2025 10:01:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: rangemachine@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-219787-28872-cTXqThZ3oS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

--- Comment #1 from rangemachine@gmail.com ---
Created attachment 307666
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307666&action=3Dedit
CrystalDiskMark installation

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

