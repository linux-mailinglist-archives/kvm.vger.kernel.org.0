Return-Path: <kvm+bounces-48619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26AA9ACFA3D
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 02:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8124B7A6A48
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 00:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EBE729A1;
	Fri,  6 Jun 2025 00:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MADXL6nU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CC310E0
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 00:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749168155; cv=none; b=HgKcp8E0vcrHGr8jt+vqIYcW4v+CEMWapK3Tpvsjfqt/RhinnAZL1slxSgcXtXRhRTsxyfVMbmpT25m7W0EdtlL2iHC5BVnAKiKWzmSyW3ICuTbHuxCzqaWWWEUSxSubPNerJgpxCaZ/eBeIyx1rZrrJRyjiF+og7wWsboeBtx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749168155; c=relaxed/simple;
	bh=Yjo/VFph+mqK3F5QWTrhSFFvfo0aIapsD3ka0icqibQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fSPsLtVjzDyUx4tTe8egp4Ux+EzRmN3gRqLXALefoyoJfb7IFOCoCRhcc0TeS8ZGEFm32yT0Sv5oNf63uKUcwsYHTZaTKz0Izi2aIMkmY/eLtj0VG17Jp/b9TsCzd+Qk3ZtjGt8nogPYPQMOYFoTqb4iH21PsZiYCln6CZRKIvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MADXL6nU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 011A0C4CEF2
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 00:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749168155;
	bh=Yjo/VFph+mqK3F5QWTrhSFFvfo0aIapsD3ka0icqibQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MADXL6nUuW6dj/geLI3Fpu5YfJ5Qs4OtUYAy7FsGN9xhzKMs6+Bs4mQT7sex0qcmy
	 pA/DK6zc8j4yUBHaWvQlWSzC8gwkb2Lh9sjWLVZP7pO3AlVGsKi7EZiloCG+X5A0kN
	 VrxsOLUyIPhR8bOfSg3LsThTdyVlcx6hc1YhtJJfC8DbEhScPWWgzjEzxRSTTEIOxQ
	 ois2dtTnBYJe2pyay3kBHrd+Rjv8u8sc3mDKN5sUnnU2Lr/GIO8viBFRfUlpKIiBUK
	 yikSFZNayGYfXqF8wQRviatxKAvawCn0xD42pKpb7+BkGCfquOKPQMPW8wltc+X0+x
	 3AzBlVN1xjQWw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id EB8D0C53BC7; Fri,  6 Jun 2025 00:02:34 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220200] Kernel crash with WARNING: CPU: 17 PID: 4510 at
 lib/refcount.c:28 refcount_warn_saturate+0xd8/0xe0
Date: Fri, 06 Jun 2025 00:02:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: gs.thiruus@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-220200-28872-uTvjbCG2Dy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220200-28872@https.bugzilla.kernel.org/>
References: <bug-220200-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220200

gs.thiruus@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |5.4.286

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

