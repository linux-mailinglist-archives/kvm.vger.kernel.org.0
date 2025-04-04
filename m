Return-Path: <kvm+bounces-42763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C358A7C57B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 23:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D4811895F5A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F350F1B0F30;
	Fri,  4 Apr 2025 21:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGHJp8c4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244A57404E
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743802002; cv=none; b=Ri3ae4jbpFgwELWioWinXWY8IQqQ6RpvvQfW2KFp2qv2mdAhcWTWKkEhhjYEPyWJTRUeguloQmxT7cTlNW9iertvNnuiBfmyP4A/kjrqB9z79D8e552nSrhK3WmTETLI+YQgUIiu3vOyi1hDgL8NHZL1dLopVf+I7CoCcdw3YLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743802002; c=relaxed/simple;
	bh=Z3+mmQiW3eqWuD9CkXjlwt8VlJTraYnnMsQPCuzP69E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hsEX3jgICNDRax7CbiuLyn5+/oC9YwyXFFrqn9in3TnKbDlPav6LLhJgN34BRgemaLzjRNnezfp0GINEeCDfN2UY9yzG/PbxZShM9zcG9KRlwPebKA3klx0AjgDObTjrYnjlq5Bk5jLe7IkxTVwzZ302JBbzCuckrdTKZ5+JJ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGHJp8c4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BDF8C4CEE4
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 21:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743802001;
	bh=Z3+mmQiW3eqWuD9CkXjlwt8VlJTraYnnMsQPCuzP69E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VGHJp8c4DVSzM/KCLeY81wEf1gTfgdKae1P78LWqOEsWUrKEhUC1u78uIywVQb/UW
	 x5kIgTreW+GEXCURgdm2bUR3KFRq2zXJkgASAVy0HxH5LhCtCt69nTZvN4QoUy4nza
	 cL7/sR9CehsJOjJ9VbVXy9sFDT4vYQcPmmX2P5hnHpEtmwMEJjjvcReG/+jCDw/mOq
	 s/ruGvta9O51qtym/YV2Qcl8D5X7w3zaCAIILr/4kPY3GmI4eQo3RYefQZ22N33AMu
	 VNULLTEPCwsbVexW8vDn9r36Lug9UDblIs/oVwcbhGQcM+h7gmX5127gQoR/EZG6Ve
	 mQe3/Vvq6WHNg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 80AD6C41612; Fri,  4 Apr 2025 21:26:41 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 217379] Latency issues in irq_bypass_register_consumer
Date: Fri, 04 Apr 2025 21:26:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217379-28872-iXqvlQbQMV@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217379-28872@https.bugzilla.kernel.org/>
References: <bug-217379-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217379

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
Huh.  Rereading this almost two years later, I realized I completely missed
that (a) your setup wasn't actually using irqbypass and (b) you suggested
giving userspace a way to disable irqbypass in KVM when it couldn't possibl=
y be
utilized.

I've proposed adding a module param for other reasons[1].  If that doesn't
suffice, KVM could also provide KVM_IRQFD_FLAG_NO_IRQBYPASS (which would al=
so
be useful for other reasons).

As for the ugly latency problems, I posted a new patch to use xarray to
mitigate the issue[2].

[1] https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com
[2] https://lore.kernel.org/all/20250404211449.1443336-1-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

