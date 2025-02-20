Return-Path: <kvm+bounces-38619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3019A3CE20
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 01:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 834D31761A4
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 00:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563D32F852;
	Thu, 20 Feb 2025 00:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyWh3Ern"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7D1BA3D
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 00:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740011501; cv=none; b=s/Uy3F0aDk/9BhE6LZFz6eKgypmqq8bV9+tTf/MH5M7yM9ERjGLbGxQJFk9Llo9X4iEySiIlHaaAtOWpSONdUSYwXIkMD5x87P2MF63qifhvCm+46jUwTprLe0LgI3RdQFnywf+2Z+6Il0dLtC7vlVzVGTYfjQV6xnxHKH3Zqts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740011501; c=relaxed/simple;
	bh=xSVppGq9+V7ALEiXCPRgemWj9e+DGu1tlR7sXnhBuXI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UwOQ3pnVMsWkoP1D7FN+JFziHTGx/vNG+GkMNHdKugwnpuirO7MJJHOBYGRgV2v2LZ0W2MfcCk5TP8p2h0WH7V/QFZtFYR4QcW6vFagZ5rXdlhbFRjUK6TxQRUY5xLZ+Ki2MzFo4OWlHouy1RmQmBxhYcdm2rx19ZGoB9jM0fhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyWh3Ern; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7945C4CEE7
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 00:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740011500;
	bh=xSVppGq9+V7ALEiXCPRgemWj9e+DGu1tlR7sXnhBuXI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SyWh3ErnHd1SnOIyeTpl5LXIEyP3LCjW9WUZgv/FoFF2XUrtkTxV/MOAnKGjRGIOR
	 E/K/pNDtdN5mktQ4eVemwyt7rfr3RsqyRqu5/9DtF9I8vHOBwiYOWs2yTJGdgGYIwQ
	 oL0WL0Tz1uOAdtRxxDqjSXzYTesLzfvTHu0tJd527AjRa9kF4Rw4kib5rxY7yRXG9f
	 6mNs8P9MMLLmazivUIgpTEdHBZgNmUKYyqLtDXooLUAoK3tG/vmNwr29mN9BT0h13g
	 HGdcgrN7dvK05g83CeWu1bn5x+8QRk0JOVss0i4V6HSubxwJfkI/uGXWQjzISJkG72
	 8H6ROf8zE0Ugw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DA72CC41615; Thu, 20 Feb 2025 00:31:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Thu, 20 Feb 2025 00:31:40 +0000
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
Message-ID: <bug-219787-28872-14OUBFCKIh@https.bugzilla.kernel.org/>
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

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #2 from Sean Christopherson (seanjc@google.com) ---
Are you able to bisect to an exact commit?  There are significant KVM chang=
es
in 6.13, but they're almost all related to memory management.  I can't thin=
k of
anything that would manifest as an unexpected single step #DB, especially n=
ot
with any consistency.

And just to double check, the only difference in the setup is that the host
kernel was upgraded from v6.12 =3D> v6.13?  E.g. there was no QEMU update or
guest-side changes?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

