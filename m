Return-Path: <kvm+bounces-44840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 02367AA3F6E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 02:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C14597ACD01
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 00:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 247032DC77A;
	Wed, 30 Apr 2025 00:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r6OYyN0u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD102DC767
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 00:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745972449; cv=none; b=LJjAEneA3uYK/a8r+UgGtnYAoSdGX+wEzbgPWyfMdzSEwNp3eBZBZMnhvo7HGp+Su+SmzIwl9tVTZvnUbQyIckRPAtdggYK8O3I7L6DtsSBwKTdNEZ5oN+Qb7wjq+Om5ChfwphEM647z3f40jJuaIanuwluzTJG5J6JtdCqaibw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745972449; c=relaxed/simple;
	bh=s2LKFcZELVpyBFy9TjkqA4pFXN4i3Galqcl3yH9TTVU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YjJMkKX/O4d9Zon0zDkPrbwJVaELmcSCDKSnxlkDj2/utigaWfRLtRL+XO7o5KNuxSic2dY02KBp4j2JlW8gDIbtsRA90aB4g/RvDplv2Ci93uipbMYAK2UxWzY15niUEgg1Bujdsstn7SQoUBVE6nyQh49FAM/auZ7dj4/RdmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r6OYyN0u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD9D2C4CEF1
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 00:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745972448;
	bh=s2LKFcZELVpyBFy9TjkqA4pFXN4i3Galqcl3yH9TTVU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=r6OYyN0ur+BQmtefIXz49AfY4lH7dRofZnvkTFDbZvwtzjqpzW3Rl5mnAXj3LqkNc
	 oZdPNhGm5QR0ARdTxU2XPeo8pd522lpbitn7qT9n75BIyAPG52iy1P++57i0ETXaYl
	 f4sXD7zfqTpFdWBbDygM552Omr/kyjFcrcDESsJdQf9Z3INA2Wzpz4ZrwTPI2Gsb/N
	 IFSnegKHXHRjawr/7X1HA5R6OLKDvD9KopFktnkmtXW/mwfEM1eq7l4hn7gnEDYCHq
	 2fwJqAayuqWduE/ue7o1T85HaauSNelMLiC442P7vmK9njK15KJ2SEpq6OE5nlTTlA
	 heIcdp9JNG1QQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B380EC41614; Wed, 30 Apr 2025 00:20:48 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Wed, 30 Apr 2025 00:20:48 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220057-28872-8QfYp6MeIw@https.bugzilla.kernel.org/>
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

--- Comment #35 from Adolfo (adolfotregosa@gmail.com) ---
Created attachment 308055
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308055&action=3Dedit
vm startup

here, full vm log from startup to shutdown after running:

echo "func vfio_pci_mmap_huge_fault +p" > /proc/dynamic_debug/control

on the host, but I did not spot anything different from usual.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

