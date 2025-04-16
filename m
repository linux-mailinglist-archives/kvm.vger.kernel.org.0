Return-Path: <kvm+bounces-43472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB82DA9067D
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 982A11775C9
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 14:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC231C5D67;
	Wed, 16 Apr 2025 14:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gta0rnft"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9350199947
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744813843; cv=none; b=cMuvEbqHarxNu0j9fdsHCUhE6lRsqH9qxUP6zPvsZRnSkjuAXqb3jsung1TQdWfiJ+y3C2HLifBEkMETUOANRvLbQ+jU83DrabVUEhwLfc5wNdY6qvW/Ul/DLVtJ1TT3FUnyrXcZ4yhCtikxIREXq+IOGS8pTumeXeX4FaHaaEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744813843; c=relaxed/simple;
	bh=Mi7sZKaygni2yT0JdwsrLevRBcTKkjAqEhP5MKP1FIg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i0Fabi2xaKr1S2ILA8S03q7YE3LJuk4UMvqAgHqTuMzTYdYnIneADrO0a69ve4YdqaxfqZkKD9YIzxecPI9BLainKe+IaWSSCI0vBbF+ec5wJDyHWSbO81K0TPEIW2C1oJhFdQXxLkWYD8jTw6N0ZxGR2369OQlKUskzLLHaCDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gta0rnft; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64AF9C4CEEF
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744813842;
	bh=Mi7sZKaygni2yT0JdwsrLevRBcTKkjAqEhP5MKP1FIg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gta0rnft1V7nHKUMTavwnu+5m9qJL7QdMYVlCnRkewSWk9dQCov4J250Ntqmhv4qq
	 12SZ06icpCBVbsYZuVJtEr/3M33cwzngufUJ8XL+A7PafzgPHeEJjtRZnL8M704A4P
	 ztjUVW9mWmdV/4M7RFkBmXPAjgM1tpHx1MyabNH0+9TfKDYpWbMVzHmXGDmk40xbKu
	 Dv2GY53Xm+hjf88yg6bDlqPgq7onLCvcf4TrpdvV2EhKhxNicpcb2uo8WMFQNwJU2a
	 TgG2LxmpggydgqQvJQb1tI5efoNGwRP2aYc/eKUnsTS7ZdSFGg3W2HW2LEpU3LGc5g
	 FdgkZ6nEHKEBw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 57B02C53BC7; Wed, 16 Apr 2025 14:30:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220019] Host call trace and crash after boot guest with perf
 kvm stat record
Date: Wed, 16 Apr 2025 14:30:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-220019-28872-B50z0Yg7n3@https.bugzilla.kernel.org/>
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

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
Can you provide more information on the host crash?  Assuming this is a new
issue, can you bisect the host?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

