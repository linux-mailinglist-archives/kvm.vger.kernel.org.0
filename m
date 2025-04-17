Return-Path: <kvm+bounces-43534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA85DA911E7
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 05:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 096BF445E8D
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 03:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B885E1C84D4;
	Thu, 17 Apr 2025 03:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RiucDbwh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDE5EAE7
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 03:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744859596; cv=none; b=lp9iajWiWVUAC2veuxkjIeXDZ3+IJ7PtQ2wvP41rf+vJRNaVMG0G5NJPCv6JQYtgz3nzTQ9RNhhSsgRv/V7NV1I3EhNGSbypklwgpnMa3opBCJ3dS5soDMVE/rZRggTKquRtp3HQMhNU1RvclLcJo2NmXjPKJazs/ix1jo/4gIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744859596; c=relaxed/simple;
	bh=w5lBmGR9gTbtYdkQCihEaBjds+m7XRWqJ6JcZXLSjjQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JhOR+4k0bKeZb3VCIyCPfZj25l0bCokhKwS1qgLabHRHxW3lRdkEKbLk8eekVm/zESE2T+Ta6DQylhSvtEY+0E7HP3T171gndzh1qgiHXldEW5zB0gv4c/OptonAxPEa64EY68qj/nd/bna3pQj68pZTmXvLrVySA9H4K4a1bxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RiucDbwh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 497D6C4CEEF
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 03:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744859596;
	bh=w5lBmGR9gTbtYdkQCihEaBjds+m7XRWqJ6JcZXLSjjQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RiucDbwhUCyseKwGP95eLee3aJn3qm2fTuOv1YF3YZfaNcKtK7DWG7xjC76BiBd3h
	 GdpdF1Gk2ykoMDI2B969it8UyYYcNjPtWX4ozSGqDOTVGzfh8GfzGXqcJ9znOIqa0V
	 PJhV5TFQHxXeizxzbb++4++kDbT/9utcfmabXUyZYlZUWKQRktxQVSuqhGWpaeHVkZ
	 oo0IEhoxcW1+POvrY5LBKWc7AeQ4FXg7ESSJg3f3OJdfnwUy4C/pbGA5s32xjlqFJ9
	 a3ut/QKbtiQtpi4Ff+18mSTmPdq7wh5HHkTj4IAY4SQiv/fYYl/jutkOUl/P1nt2m4
	 KZQVxnVnlrncQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3C27DC53BBF; Thu, 17 Apr 2025 03:13:16 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220019] Host call trace and crash after boot guest with perf
 kvm stat record
Date: Thu, 17 Apr 2025 03:13:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-220019-28872-tnonKpdBUd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220019-28872@https.bugzilla.kernel.org/>
References: <bug-220019-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220019

Chen, Fan (farrah.chen@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |farrah.chen@intel.com

--- Comment #2 from Chen, Fan (farrah.chen@intel.com) ---
Created attachment 307977
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D307977&action=3Dedit
Call Trace

Sorry, forgot to add the call trace log, attached

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

