Return-Path: <kvm+bounces-25277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93F4F962D99
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 495221F22877
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18791A38F3;
	Wed, 28 Aug 2024 16:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bK3GXkgu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB801DFEF
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724862397; cv=none; b=DbdbmBBgXHwu6fiXC9f1/xIGyOib+AB62/zmVzQ6vqEmqH5e4QlJ/drFHC7Rn58i8mqld9pnPU0QeJAOhKWwmC28/xklBHYDqT54YFyPrYDFR0eo7w8EFESp32TRPhrF4sjiYwKpJIRDUhBkEFEM+DTv5MepF8llGVmhmyHGEFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724862397; c=relaxed/simple;
	bh=47Qzl97WGbiSO6jOTD3TyLs7KJGZpQnpzuyqTn/YlHI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lvp7+Rfiap+wOyxFxU5/sg/4viCMecOBW6mpMvwlt7pA5o9n4tcAdo17XQ5h1rcGRAYQ50lQ6Z++gBsueBg6U8RoU1PaU6V40UTFbz/MKkcQVv8ZOuii1+VjswSzSQ0Ar5Y6bxh4Mf0BAN0Jk+qBiAnWt454qwfbagct0MoOKjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bK3GXkgu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68473C4FE07
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724862396;
	bh=47Qzl97WGbiSO6jOTD3TyLs7KJGZpQnpzuyqTn/YlHI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bK3GXkguLZZT9e14+5Plc+96MzM6kLX37PLfQzU6VXdC6VNJtS3GxaCmV+zofB11e
	 B9AbQuXWI4U0BXeCVUjRvxP9zmq9HthaCwDBETwvLOLokt5rXf3WInXtOLvKVwOIri
	 M/za3oAJh5eHn/hwM9IZw4N/MLfEKB+0gXK3G9KXKUCMBzXVpbDhXI+nNIjD+KiG50
	 RJa99HS1lF4WXslcl81lkAUoXnOjDxNN6qdTcITZhvPcAFn5eD0H1Cb0xV0t1HXE1K
	 zt41Dhd5hcjQ7dn5jx/kONOMPGYdfHa+Gm2CM5M6e1c5qB9HQwzbJbpzOF+PYpIMqw
	 bcAKPpTndDIjQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 581E1C53BB9; Wed, 28 Aug 2024 16:26:36 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219129] virtio net performance degradation between Windows and
 Linux guest in kernel 6.10.3
Date: Wed, 28 Aug 2024 16:26:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: info@it-connect-unix.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219129-28872-F44g7kXmvz@https.bugzilla.kernel.org/>
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

Karl Tischler (info@it-connect-unix.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |info@it-connect-unix.de

--- Comment #13 from Karl Tischler (info@it-connect-unix.de) ---
The degraded network performance also seems to be a problem in kernel 5.15.=
165.
Should I file a new bug report?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

