Return-Path: <kvm+bounces-27833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 527C998E650
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 00:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84B4F1C20FAA
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 22:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6811919C56A;
	Wed,  2 Oct 2024 22:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvpQYYjU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2A319ABD1
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 22:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909632; cv=none; b=B5UWcHajnnhDKmbO4QwFXKoIaLGToHErc+z4H7eCQ2HDx3/WZyENeR7acV69Nc+zc3JxOVHX/APJNPdfd37MG8SQHAllqyy1a/Ks9bD0ycBkIIq40brhE7uUr+rx+i3gJaPPLH4YrawemL1kgVBr+t9OV3LCu17FG0wcwzJqBA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909632; c=relaxed/simple;
	bh=IYfkYmqtAKI5xmcoEK2mJNwiZ2ACW/LGfGivYgyZfig=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VxjrWQEKhPsfPYmlrS7wq6LY2Ty/HSgbLUsJwjwHvX626qtr3XA2VwKQCOuRwLfql3cXvrmb3VKh1wx0IhKASt/0jrF76KoTmvvrGJ7de7L5XxB+QjK2vpW7bIyYi6seT3+1VEZ6s5bM7lRW47xHKZPHkbSYhjkbqu05KJi3p4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JvpQYYjU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 184DAC4CED4
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 22:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727909632;
	bh=IYfkYmqtAKI5xmcoEK2mJNwiZ2ACW/LGfGivYgyZfig=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JvpQYYjURQeP1W3KbHEIce8yHX/IhjD324trmDk2pemR+Xws3ongxjQNquBANOBUM
	 y1U3VD+QJ6ow/3YvTu0t8SKdHMsssvCOw41O/YU2HcN6Laeo3idS8tByFqYPaNWcZW
	 eWBQDia7YC1sxMbY+RpBrbwiQ2u5os6T16IufH21cWgnsSPPBGKWDm1HgPu/2goV3k
	 A+EuJmZIIfiGtB0hFbFxTeJwUGkuupgp5cq0oSo6Omg+c1tDO5Xf+oTHe+LflhYwQO
	 BxfjjmhnlOFRCR4WdWDs6MmpQFTEQDQUgzYQy8DsmRHWj1I4aIHf2qFWk+REk4/9Pb
	 jNgvgJUD6QMzQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 128A0C53BBF; Wed,  2 Oct 2024 22:53:52 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 02 Oct 2024 22:53:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-joByTM99Ed@https.bugzilla.kernel.org/>
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

--- Comment #20 from Ben Hirlston (ozonehelix@gmail.com) ---
I am wondering if the fixes for those CVE's are related to this bug

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

