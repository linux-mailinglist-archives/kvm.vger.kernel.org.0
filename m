Return-Path: <kvm+bounces-22080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 12281939870
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 04:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F95AB21ABA
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 02:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A7F13B5B4;
	Tue, 23 Jul 2024 02:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSgralrg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF2C2F32
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 02:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721703242; cv=none; b=Mb/YPpQ0GLbK3ODjKfxyXuYRDO38/qrZEp7k7xM0uq7/tuvyHL/dKdkuUoLUeiSkWuCBxDVboxSIwOdo7dsu/1njQPmBC+U63TsptHUDAcxH5r9737ZyDw9ZSXbPl/XRE8FTq7XoxIJLb7gZS/XEzJpMq5Pln+f2hiQ09aifyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721703242; c=relaxed/simple;
	bh=M7sbiQWjQhZD+vmF+DF2rNGZXIqIPGoFf8kUacpCYjY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SKxYozbcdbihOEGyVXd+15A2vPzXDL48DYYCumd/FhpWgQIkO6n2mdqPqmCIhVaOVPa75HxXNyoAsnzX1WlF5jN4GFO/S27Od+GK4eSs4cu7y2LMbq+opOdf8HXBnkOhrYxjSD8gbuVW6DGONCDOQLIc6QbRZ9n7ToQL26uvun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSgralrg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53262C4AF0D
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 02:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721703242;
	bh=M7sbiQWjQhZD+vmF+DF2rNGZXIqIPGoFf8kUacpCYjY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JSgralrgK2ONqRITN39J5MQK4yQtw056KtuX7XY5UOhEdYodOtQzqFtLq9Z4i+ZHB
	 uFiYD8vbCK/DYwhrnc5XG0NpCS1nm5zECYdrEh41u5HAY1RNmUgiWFqEfa7WTGBc2s
	 1Vbbzn48ocgyPcQaOut9RZHmKh6MlHcyyAq3WCMyn88p/q8oenpiIV4fneHdTvYG7I
	 vNkTQsOBP5NDGh4EC6wI40vp+FN0fEiQWh74CBj7tyQmNtc2iuDc1gILFhaZaOIIzl
	 6+8CbVFrZ9TFbxpbqKUsmZ+sQkMYRUc1dpdfBYGLRUIXxK0N5gXACUtd421RTi558p
	 cbuaGCaa8/h+A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 470ABC53BBF; Tue, 23 Jul 2024 02:54:02 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219034] [linux-next][tag next-20240709] kernel BUG at
 lib/dynamic_queue_limits.c:99! and Oops: invalid opcode: 0000 [#1] PREEMPT
 SMP NOPTI
Date: Tue, 23 Jul 2024 02:54:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hongyu.ning@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: UNREPRODUCIBLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219034-28872-ajRG9TCzYd@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219034-28872@https.bugzilla.kernel.org/>
References: <bug-219034-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219034

hongyuni (hongyu.ning@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |UNREPRODUCIBLE

--- Comment #1 from hongyuni (hongyu.ning@intel.com) ---
issue no longer reproduced on next-20240722 linux-next tree, close accordin=
gly.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

